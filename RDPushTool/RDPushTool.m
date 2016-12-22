//
//  RDPushTool.m
//  TestNCEDeom
//
//  Created by Radar on 2016/12/15.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "RDPushTool.h"


//工具宏
#define PTSTRVALID(str)   [RDPushTool checkStringValid:str]   //检查一个字符串是否有效



#pragma mark -
#pragma mark PTConnectReport类  
@implementation PTConnectReport 
@end


#pragma mark -
#pragma mark PTPushReport类  
@implementation PTPushReport 
@end




#pragma mark -
#pragma mark 主类
@interface RDPushTool ()

@property (nonatomic, strong) NWHub *hub;
@property (nonatomic) NSUInteger index;
@property (nonatomic) dispatch_queue_t serial;

@property (nonatomic) NWIdentityRef identity;
@property (nonatomic) NWCertificateRef certificate;

@property (nonatomic, strong) void(^pushCompletionBlock)(PTPushReport *report);

@end



@implementation RDPushTool

- (id)init{
    self = [super init];
    if(self){
        //do something
        [self initProperties];
    }
    return self;
}

+ (instancetype)sharedTool
{
    static dispatch_once_t onceToken;
    static RDPushTool *tool;
    dispatch_once(&onceToken, ^{
        tool = [[RDPushTool alloc] init];
    });
    return tool;
}





#pragma mark -
#pragma mark 内部配套工具方法
+ (BOOL)checkStringValid:(NSString *)string
{
    if(!string) return NO;
    if(![string isKindOfClass:[NSString class]]) return NO;
    if([string compare:@""] == NSOrderedSame) return NO;
    if([string compare:@"(null)"] == NSOrderedSame) return NO;
    
    return YES;
}

+ (NSString *)jsonFromDictionary:(NSDictionary *)dic
{
    //本类内部只需要字典和字符串之间转换，不考虑数组
    if(!dic || ![dic isKindOfClass:[NSDictionary class]]) return nil;
    
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:dic])  
    {   
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];  
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  
    }  
    
    return jsonString;
}

+ (NSDictionary *)dictionaryFromJson:(NSString *)json
{
    if(!PTSTRVALID(json)) return nil;
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];  
    
    return dic;
}

- (void)broadCastReportMsg:(NSString *)reportMsg
{
    if(!PTSTRVALID(reportMsg)) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RDPUSHTOOL_REPORT object:reportMsg userInfo:nil];
}






#pragma mark -
#pragma mark 内部使用的数据相关方法
- (void)initProperties
{
    //初始化一些属性
    self.serial = dispatch_queue_create("RDPushTool", DISPATCH_QUEUE_SERIAL);
    [self loadCertificate];
    
}
- (void)loadCertificate
{
    NSURL *url = [NSBundle.mainBundle URLForResource:pkcs12FileName withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    
    NSArray *ids = [NWSecTools identitiesWithPKCS12Data:pkcs12 password:pkcs12Password error:&error];
    if (!ids) {
        NSLog(@"Unable to read p12 file: %@", error.localizedDescription);
        
        NSString *reportMsg = [NSString stringWithFormat:@"读取P12文件失败...: %@", error.localizedDescription];
        [self broadCastReportMsg:reportMsg];
        
        return;
    }
    for (NWIdentityRef identity in ids) {
        NSError *error = nil;
        NWCertificateRef certificate = [NWSecTools certificateWithIdentity:identity error:&error];
        if (!certificate) {
            NSLog(@"Unable to import p12 file: %@", error.localizedDescription);
            
            NSString *reportMsg = [NSString stringWithFormat:@"加载P12文件失败...: %@", error.localizedDescription];
            [self broadCastReportMsg:reportMsg];
            
            return;
        }
        
        self.identity = identity;
        self.certificate = certificate;
    }
}





#pragma mark -
#pragma mark 连结及推送操作相关
- (void)connect:(void(^)(PTConnectReport *report))completion
{    
    //连结APNs
    if(_hub)   //TO DO: 这个地方还得再考虑，是否如果有了hub，就算是连结状态呢？
    {
        if(completion)
        {
            PTConnectReport *report = [[PTConnectReport alloc] init];
            report.status = PTConnectReportStatusConnectSuccess;
            report.summary = @"connect success!...";
            
            completion(report);
        }
        return; 
    }
    
    NWEnvironment preferredEnvironment = [self preferredEnvironmentForCertificate:_certificate];
    [self connectingToEnvironment:preferredEnvironment completion:^(PTConnectReport *report) {
        if(completion)
        {
            completion(report);
        }
    }];
}

- (void)disconnect
{
    //从APNs断开连结
    if(_hub)
    {
        [_hub disconnect]; 
        self.hub = nil;
    }
    NSLog(@"Disconnected");
    [self broadCastReportMsg:@"断开连接"];
    
}

//- (void)sanboxCheckBoxDidPressed
//{
//    //连结沙盒，暂不知道何用
//    if(_certificate)
//    {
//        [self disconnect];
//        [self connectingToEnvironment:[self selectedEnvironmentForCertificate:_certificate]];
//    }
//}
//
//- (NWEnvironment)selectedEnvironmentForCertificate:(NWCertificateRef)certificate
//{
//    return _sanboxSwitch.isOn ? NWEnvironmentSandbox : NWEnvironmentProduction;
//}

- (NWEnvironment)preferredEnvironmentForCertificate:(NWCertificateRef)certificate
{
    //自动根据证书类型，返回环境类型，devlopment或者是production
    NWEnvironmentOptions environmentOptions = [NWSecTools environmentOptionsForCertificate:certificate];
    return (environmentOptions & NWEnvironmentOptionSandbox) ? NWEnvironmentSandbox : NWEnvironmentProduction;
}

- (void)connectingToEnvironment:(NWEnvironment)environment completion:(void(^)(PTConnectReport *report))completion
{    
    __block PTConnectReport *report = [[PTConnectReport alloc] init];
    
    //连接到对应的环境    
    NSLog(@"Connecting..");
    
    NSString *apnsServer = [NWSecTools summaryWithCertificate:_certificate];
    NSString *apnsEnviro = descriptionForEnvironent(environment);
    NSString *summary = [NSString stringWithFormat:@"%@ (%@)", apnsServer, apnsEnviro];
    
    report.status = PTConnectReportStatusConnecting;
    report.summary = summary;
    if(completion)
    {
        completion(report);
    }
    
    NSString *reportMsg = [NSString stringWithFormat:@"正在连接... %@", summary];
    [self broadCastReportMsg:reportMsg];
    
    
    //连接结果
    dispatch_async(_serial, ^{
        NSError *error = nil;
        
        NWHub *hub = [NWHub connectWithDelegate:self identity:_identity environment:environment error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *reportMsg = nil;
            if(hub) 
            {                
                self.hub = hub;
                NSLog(@"Connected to APN: %@", summary);
                reportMsg = [NSString stringWithFormat:@"APNs连接成功!... %@", summary];
                
                report.status = PTConnectReportStatusConnectSuccess;
                report.summary = summary;
            } 
            else 
            {
                NSLog(@"Unable to connect: %@", error.localizedDescription);
                reportMsg = [NSString stringWithFormat:@"APNs连接失败...: %@", error.localizedDescription];
                
                report.status = PTConnectReportStatusConnectFailure;
                report.summary = error.localizedDescription;
            }
            
            if(completion)
            {
                completion(report);
            }
            
            [self broadCastReportMsg:reportMsg];
        });
    });
}

- (void)pushPayload:(NSDictionary *)payloadDic toToken:(NSString *)deviceToken completion:(void(^)(PTPushReport *report))completion
{
    //接一下block
    self.pushCompletionBlock = completion;
    
    //创建report
    __block PTPushReport *report = [[PTPushReport alloc] init];
    report.payload = payloadDic;
    report.deviceToken = deviceToken;
    
    //推送payload
    if(!payloadDic || ![payloadDic isKindOfClass:[NSDictionary class]] || !PTSTRVALID(deviceToken)) 
    {
        NSLog(@"push failure...input parameters error");
        
        report.status = PTPushReportStatusPushFailure;
        report.summary = @"push failure，input parameters error!";
        if(completion)
        {
            completion(report);
        }

        NSString *reportMsg = [NSString stringWithFormat:@"推送失败...: 传入参数错误"];
        [self broadCastReportMsg:reportMsg];
        
        return;
    }
    
    
    //设定参数
    //NSString *payload = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"%@\",\"badge\":1,\"sound\":\"default\"}}", _textField.text];
    //NSString *token = kdeviceToken;
    
    NSString *payload = [RDPushTool jsonFromDictionary:payloadDic];
    NSString *token = deviceToken;
    
    
    //开始推送
    NSLog(@"Pushing..");
    
    report.status = PTPushReportStatusPushing;
    report.summary = @"payload pushing...";
    if(completion)
    {
        completion(report);
    }
    
    NSString *reportMsg = [NSString stringWithFormat:@"payload推送中..."];
    [self broadCastReportMsg:reportMsg];
    
    
    //获取推送结果
    dispatch_async(_serial, ^{
        NSUInteger failed = [_hub pushPayload:payload token:token]; //TO DO: 这个地方需要调整， _hub为nil，竟然也能进来，然后竟然返回推送成功。。。。
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, _serial, ^(void){
            
            BOOL pushed = NO;
            NSString *reportMsg = [NSString stringWithFormat:@"推送失败..."];
            
            report.status = PTPushReportStatusPushFailure;
            report.summary = @"payload push failure...";
            
            NSUInteger failed2 = failed + [_hub readFailed];
            if(!failed2) 
            {
                pushed = YES;
                
                NSLog(@"Payload has been pushed");
                reportMsg = [NSString stringWithFormat:@"推送成功!..."];
                
                report.status = PTPushReportStatusPushSuccess;
                report.summary = @"payload push success!...";
            }
            
            [self broadCastReportMsg:reportMsg];
            
            if(completion)
            {
                completion(report);
            }
            
        });
    });
}



#pragma mark -
#pragma mark NWHubDelegate返回方法
- (void)notification:(NWNotification *)notification didFailWithError:(NSError *)error
{
    //推送失败进这里
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Notification error: %@", error.localizedDescription);
        
        PTPushReport *report = [[PTPushReport alloc] init];
        report.status = PTPushReportStatusPushFailure;
        report.summary = error.localizedDescription;
        
        if(notification)
        {
            report.payload = [RDPushTool dictionaryFromJson:notification.payload];
            report.deviceToken = notification.token;
        }
        
        if(_pushCompletionBlock)
        {
            _pushCompletionBlock(report);
        }
        
        NSString *reportMsg = [NSString stringWithFormat:@"推送失败...: %@", error.localizedDescription];
        [self broadCastReportMsg:reportMsg];
        
    });
}







@end
