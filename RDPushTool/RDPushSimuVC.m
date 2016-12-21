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

@end

@implementation RDPushSimuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"RDPush Simulator";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //注册消息监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveConnectStateNotify:) name:NOTIFICATION_RDPUSHTOOL_REPORT object:nil];
    
    
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
    
    
    //状态显示
    
    
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




//NOTIFICATION_RDPUSHTOOL_REPORT消息监听获取当前连接及推送状态的log
- (void)receiveConnectStateNotify:(NSNotification*)notification
{
    if(!notification) return;
    
    NSString *report = (NSString*)notification.object;
    if(!report) return;
    
    //TO DO: 根据report的内容，修改界面显示内容log
    
}




@end
