//
//  RDPushSimuVC.m
//  TestNCEDeom
//
//  Created by Radar on 2016/12/19.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "RDPushSimuVC.h"

@interface RDPushSimuVC ()

@end

@implementation RDPushSimuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"RDPush Simulator";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //注册消息监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveConnectStateNotify:) name:NOTIFICATION_RDPUSHTOOL_REPORT object:nil];
    
    
    //连接按钮
    UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connectBtn.frame = CGRectMake(20, 50, 200, 50);
    [connectBtn setTitle:@"connect" forState:UIControlStateNormal];
    [connectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    connectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [connectBtn addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    
    UIButton *disConnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    disConnectBtn.frame = CGRectMake(200, 50, 200, 50);
    [disConnectBtn setTitle:@"disconnect" forState:UIControlStateNormal];
    [disConnectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    disConnectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [disConnectBtn addTarget:self action:@selector(disConnectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:disConnectBtn];
    
    
    //状态显示
    
    
}

- (void)dealloc
{
    //在dealloc里边注销监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RDPUSHTOOL_REPORT object:nil];
}


- (void)connectAction:(id)sender
{
    //[[RDPushTool sharedTool] connect];
}

- (void)disConnectAction:(id)sender
{
    //[[RDPushTool sharedTool] disconnect];
}

- (void)receiveConnectStateNotify:(NSNotification*)notification
{
    if(!notification) return;
    
    NSString *report = (NSString*)notification.object;
    if(!report) return;
    
    //TO DO: 根据report的内容，修改界面显示内容log
    
}


@end
