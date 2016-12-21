//
//  RDPushSimuVC.m
//  TestNCEDeom
//
//  Created by Radar on 2016/12/19.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "RDPushSimuVC.h"
#import <AudioToolbox/AudioToolbox.h>


#define PSRGB(r, g, b)        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define PSRGBS(x)             [UIColor colorWithRed:x/255.0 green:x/255.0 blue:x/255.0 alpha:1.0]


@interface RDPushSimuVC ()

@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UIButton *disConnectBtn;
@property (nonatomic, strong) UITextView *payloadTextView;
@property (nonatomic, strong) UITextField *tokenField;
@property (nonatomic, strong) UIButton *pushBtn;
@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) UIButton *keyBoardBtn;

@end

@implementation RDPushSimuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//#ifdef DEBUG
//    
//#else
//    
//#endif
    
    self.navigationItem.title = @"RDPush Simulator";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //注册消息监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveConnectStateNotify:) name:NOTIFICATION_RDPUSHTOOL_REPORT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //连接按钮
    self.connectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _connectBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    _connectBtn.backgroundColor = PSRGBS(130);
    [_connectBtn setTitle:@"Connect to APNs." forState:UIControlStateNormal];
    [_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _connectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_connectBtn addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectBtn];
    
    //断开连接按钮
    self.disConnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _disConnectBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 70, 40);
    _disConnectBtn.backgroundColor = [UIColor darkGrayColor];
    [_disConnectBtn setTitle:@"disconnect" forState:UIControlStateNormal];
    [_disConnectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _disConnectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_disConnectBtn addTarget:self action:@selector(disConnectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_disConnectBtn];
    
    
    //payload内容输入
    UILabel *payloadL = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 200, 25)];
    payloadL.text = @"Payload:";
    payloadL.textColor = PSRGBS(50);
    payloadL.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:payloadL];
    
    self.payloadTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 306)];
    _payloadTextView.backgroundColor = PSRGBS(230);
    _payloadTextView.editable = YES;
    _payloadTextView.textColor = PSRGBS(100);
    _payloadTextView.font = [UIFont systemFontOfSize:14.0];
    _payloadTextView.text = [self getDefalutPayload];
    [self.view addSubview:_payloadTextView];
    
    
    
    //devicetoken显示区域
    UILabel *tokenL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_payloadTextView.frame), 95, 30)];
    tokenL.text = @"push to Token: ";
    tokenL.textColor = [UIColor whiteColor];
    tokenL.textAlignment = NSTextAlignmentCenter;
    tokenL.backgroundColor = [UIColor lightGrayColor];
    tokenL.font = [UIFont boldSystemFontOfSize:12.0];
    [self.view addSubview:tokenL];
    
    self.tokenField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tokenL.frame), CGRectGetMaxY(_payloadTextView.frame), [UIScreen mainScreen].bounds.size.width-CGRectGetWidth(tokenL.frame), 30)];
    _tokenField.backgroundColor = [UIColor lightGrayColor];
    _tokenField.textColor = [UIColor whiteColor];
    _tokenField.font = [UIFont systemFontOfSize:13.0];
    _tokenField.placeholder = @"input a devicetoken...";
    [self.view addSubview:_tokenField];
    
    
    //push按钮
    self.pushBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _pushBtn.frame = CGRectMake(0, CGRectGetMaxY(_tokenField.frame), [UIScreen mainScreen].bounds.size.width, 50);
    _pushBtn.backgroundColor = PSRGBS(130);//PSRGB(50, 220, 210);
    [_pushBtn setTitle:@"PUSH" forState:UIControlStateNormal];
    [_pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _pushBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_pushBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pushBtn];
    
    
    //状态显示
    UILabel *logL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_pushBtn.frame), [UIScreen mainScreen].bounds.size.width, 25)];
    logL.text = @"console:";
    logL.textColor = PSRGBS(50);
    logL.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:logL];
    
    self.logTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logL.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-CGRectGetMaxY(logL.frame))];
    _logTextView.backgroundColor = PSRGBS(200);
    _logTextView.editable = NO;
    _logTextView.textColor = PSRGBS(100);
    _logTextView.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:_logTextView];
    
    
    //收起键盘按钮
    self.keyBoardBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _keyBoardBtn.frame = CGRectMake(CGRectGetMaxX(_payloadTextView.frame)-140, CGRectGetMaxY(_payloadTextView.frame)-40, 140, 40); 
    _keyBoardBtn.backgroundColor = [UIColor darkGrayColor];
    [_keyBoardBtn setTitle:@"keyboard dismiss" forState:UIControlStateNormal];
    [_keyBoardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _keyBoardBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_keyBoardBtn addTarget:self action:@selector(keyboardDismissAction:) forControlEvents:UIControlEventTouchUpInside];
    _keyBoardBtn.alpha = 0;
    [self.view addSubview:_keyBoardBtn];
    
}

- (void)dealloc
{
    //在dealloc里边注销监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RDPUSHTOOL_REPORT object:nil];
}


- (void)connectAction:(id)sender
{
    [[RDPushTool sharedTool] connect:^(PTConnectReport *report) {
        
        NSString *stateStr = @"";
        
        if(report.status == PTConnectReportStatusConnecting)
        {
            _connectBtn.enabled = NO;
            stateStr = [NSString stringWithFormat:@"Connecting to APNs... : %@", report.summary];
        }
        else if(report.status == PTConnectReportStatusConnectSuccess)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            stateStr = [NSString stringWithFormat:@"APNs Connected: %@", report.summary];
            [self showDiscConnectBtn:YES];
        }
        else if(report.status == PTConnectReportStatusConnectFailure)
        {
            stateStr = [NSString stringWithFormat:@"Connect failure...: %@, Press to reconnect.", report.summary];
            [self showDiscConnectBtn:NO];
        }
        
        [_connectBtn setTitle:stateStr forState:UIControlStateNormal];
        
    }];
}
- (void)disConnectAction:(id)sender
{
    [[RDPushTool sharedTool] disconnect];
    [_connectBtn setTitle:@"Connect to APNs." forState:UIControlStateNormal];
    [self showDiscConnectBtn:NO];

}
- (void)showDiscConnectBtn:(BOOL)bshow
{
    if(bshow)
    {
        _connectBtn.enabled = NO;
        _connectBtn.backgroundColor = PSRGBS(170);
        [UIView animateWithDuration:0.25 animations:^{
            _connectBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-70, 40);
            _disConnectBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-70, 0, 70, 40);
        }];
    }
    else
    {
        _connectBtn.enabled = YES;
        _connectBtn.backgroundColor = PSRGBS(130);
        [UIView animateWithDuration:0.25 animations:^{
            _connectBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
            _disConnectBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 70, 40);
        }];
    }
}

- (void)keyboardDismissAction:(id)sender
{
    if([_payloadTextView isFirstResponder])
    {
        [_payloadTextView resignFirstResponder];
    }
    else if([_tokenField isFirstResponder])
    {
        [_tokenField resignFirstResponder];
    }
}

- (void)pushAction:(id)sender
{
    //TO DO: 推送消息，并显示推送状态和summary
    NSString *deviceToken = _tokenField.text;
    NSDictionary *payloadDic = [self getPayloadDic];
    
    [[RDPushTool sharedTool] pushPayload:payloadDic toToken:deviceToken completion:^(PTPushReport *report) {
        
    }];
}




#pragma mark -
#pragma mark - 一些配套方法
- (NSDictionary *)getPayloadDic
{
    NSString *payloadStr = _payloadTextView.text;
    if(!payloadStr || [payloadStr isEqualToString:@""]) return nil;
    
    payloadStr = [payloadStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    payloadStr = [payloadStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    payloadStr = [payloadStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSData *jsonData = [payloadStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    return dic;
}

- (NSString *)getDefalutPayload
{
    //TO DO: 要把payload做成一个json串。当成placeholder放倒payloadtextview里边去。
    NSString *payloadStr = @"{\n\t\"aps\":{\"alert\":{\"title\":\"我是原装标题\",\"subtitle\":\"我是副标题\",\"body\":\"it is a beautiful day\"},\"badge\":1,\"sound\":\"default\",\"mutable-content\":\"1\",\"category\":\"myNotificationCategory\",\"attach\":\"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=200&sharp=30\"},\"goto_page\":\"cms://page_id=14374\"}";
    return payloadStr;
}




#pragma mark -
#pragma mark - key board notification
- (void)keyboardWillShow:(NSNotification *)notification 
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        _keyBoardBtn.alpha = 1;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification 
{    
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        _keyBoardBtn.alpha = 0;
    }];
}






#pragma mark -
#pragma mark NOTIFICATION_RDPUSHTOOL_REPORT消息监听获取当前连接及推送状态的log
- (void)receiveConnectStateNotify:(NSNotification*)notification
{
    if(!notification) return;
    
    NSString *report = (NSString*)notification.object;
    if(!report) return;
    
    //TO DO: 根据report的内容，修改界面显示内容log
    
}







@end
