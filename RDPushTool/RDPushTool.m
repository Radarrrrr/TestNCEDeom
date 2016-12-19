//
//  RDPushTool.m
//  TestNCEDeom
//
//  Created by Radar on 2016/12/15.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "RDPushTool.h"



#define PTSTRVALID(str)   [RDPushTool checkStringValid:str]   //检查一个字符串是否有效


@interface RDPushTool ()

@property (nonatomic, strong) NWHub *hub;
@property (nonatomic) NSUInteger index;
@property (nonatomic) dispatch_queue_t serial;

@property (nonatomic) NWIdentityRef identity;
@property (nonatomic) NWCertificateRef certificate;

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





#pragma mark -
#pragma mark 内部初始化方法
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
        return;
    }
    for (NWIdentityRef identity in ids) {
        NSError *error = nil;
        NWCertificateRef certificate = [NWSecTools certificateWithIdentity:identity error:&error];
        if (!certificate) {
            NSLog(@"Unable to import p12 file: %@", error.localizedDescription);
            return;
        }
        
        self.identity = identity;
        self.certificate = certificate;
    }
}





#pragma mark -
#pragma mark 连结及推送操作相关
- (void)connect
{
    //连结APNs
    if(_hub) return; //TO DO: 这个地方还得再考虑，是否如果有了hub，就算是连结状态呢？
    
    NWEnvironment preferredEnvironment = [self preferredEnvironmentForCertificate:_certificate];
    [self connectingToEnvironment:preferredEnvironment];
}

- (void)disconnect
{
    //从APNs断开连结
    if(_hub)
    {
        [_hub disconnect]; 
        _hub = nil;
    }
    NSLog(@"Disconnected");
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

- (void)connectingToEnvironment:(NWEnvironment)environment
{    
    //连接到对应的环境
    NSLog(@"Connecting..");
    dispatch_async(_serial, ^{
        NSError *error = nil;
        
        NWHub *hub = [NWHub connectWithDelegate:self identity:_identity environment:environment error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hub) 
            {
                NSString *summary = [NWSecTools summaryWithCertificate:_certificate];
                NSLog(@"Connected to APN: %@ (%@)", summary, descriptionForEnvironent(environment));
                _hub = hub;
            } 
            else 
            {
                NSLog(@"Unable to connect: %@", error.localizedDescription);
            }
        });
    });
}

- (void)pushPayload:(NSDictionary *)payloadDic completion:(void(^)(BOOL success))completion
{
    //推送payload
    if(!payloadDic || ![payloadDic isKindOfClass:[NSDictionary class]]) 
    {
        if(completion)
        {
            completion(NO);
        }
        return;
    }
    
    //NSString *payload = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"%@\",\"badge\":1,\"sound\":\"default\"}}", _textField.text];
    NSString *payload = [RDPushTool jsonFromDictionary:payloadDic];
    NSString *token = deviceToken;
    
    NSLog(@"Pushing..");
    
    dispatch_async(_serial, ^{
        NSUInteger failed = [_hub pushPayload:payload token:token];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, _serial, ^(void){
            
            BOOL pushed = NO;
            
            NSUInteger failed2 = failed + [_hub readFailed];
            if(!failed2) 
            {
                NSLog(@"Payload has been pushed");
                pushed = YES;
            }
            
            if(completion)
            {
                completion(pushed);
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
    });
}







@end
