//
//  ViewController.m
//  TestNCEDeom
//
//  Created by Radar on 2016/11/10.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "ViewController.h"
#import "RDUserNotifyCenter.h"
#import "RDPushSimuVC.h"

@interface ViewController () <RDUserNotifyCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Main";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //推送模拟器入口
    UIButton *pushSimuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushSimuBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 0, 150, 50);
    pushSimuBtn.backgroundColor = [UIColor clearColor];
    [pushSimuBtn setTitle:@"推送模拟器-> " forState:UIControlStateNormal];
    [pushSimuBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    pushSimuBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [pushSimuBtn addTarget:self action:@selector(pushSimuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushSimuBtn];
    
    
    
    
    //注册和使用本地通知相关-----------------------------------------------------------------------------------------------------
    //注册
    [[RDUserNotifyCenter sharedCenter] registerUserNotification:self completion:^(BOOL success) {
        //do sth..
    }];
    
    
    //绑定action到category
    [[RDUserNotifyCenter sharedCenter] prepareBindingActions];

    [[RDUserNotifyCenter sharedCenter] appendAction:@"action_enter" actionTitle:@"进去看看" options:UNNotificationActionOptionForeground toCategory:@"myNotificationCategory"];
    [[RDUserNotifyCenter sharedCenter] appendAction:@"action_exit" actionTitle:@"关闭" options:UNNotificationActionOptionDestructive toCategory:@"myNotificationCategory"];
    
    [[RDUserNotifyCenter sharedCenter] appendAction:@"action_enter" actionTitle:@"进去看看" options:UNNotificationActionOptionForeground toCategory:@"notification_category_list"];
    [[RDUserNotifyCenter sharedCenter] appendAction:@"action_exit" actionTitle:@"关闭" options:UNNotificationActionOptionDestructive toCategory:@"notification_category_list"];
    
    [[RDUserNotifyCenter sharedCenter] bindingActions];
    
    
    //规划本地通知
//    NSDictionary *info = @{ 
//                              @"fire_timeinterval"  :@"3",   
//                              @"fire_msg"   :@"这是一个本地通知的测试",                   
//                              @"link_url"   :@"check://",                   
//                              @"category_id":@"myNotificationCategory"               
//                              //@"attach"     :@"xxxxx",                    
//                              //@"repeats"    :@"1",                        
//                              //@"sound"      :@"xxxxx"                     
//                          };
//    
//    [[RDUserNotifyCenter sharedCenter] scheduleTimeIntervalLocalNotify:info completion:^(NSString *notifyid) {
//        //do sth...
//    }];
    
    
    
    //全量规划本地通知
//    [[RDUserNotifyCenter sharedCenter] scheduleLocalNotify:nil 
//                                              timeInterval:@"3" 
//                                                   repeats:NO 
//                                                     title:@"这是一个标题" 
//                                                  subtitle:@"这是一个副标题"
//                                                      body:@"这是通知文本正文" 
//                                                attachment:@"attach_image.png" 
//                                                lauchImage:@"launch_image@2x.jpg" //TO DO: 这个地方还一直没有看到过效果，启动图片到底是什么？还需要确认一下
//                                                     sound:nil 
//                                                     badge:1 
//                                                      info:nil 
//                                               useCategory:nil 
//                                                  notifyid:@"123456788" 
//                                                completion:^(NSError *error) {
//                                                    //do sth...
//                                                }
//     ];
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    [[UNUserNotificationCenter currentNotificationCenter] getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
//        NSLog(@"%ld", categories.count);
//    }];
    
    
    //------一些测试
//    NSArray *urls = @[
//                      @"http://img50.ddimg.cn/39570025270550_y.jpg",
//                      @"http://img57.ddimg.cn/95680028860097_y.jpg",
//                      @"http://img35.ddimg.cn/imgother/201611/28_0/20161128155608105.jpg",
//                      @"http://img58.ddimg.cn/106640020843798_y.jpg",
//                      @"http://img39.ddimg.cn/imgother/201611/29_0/20161129151121169.jpg"
//                      ];
//    
//    [RDUserNotifyCenter downAndSaveDatasToGroup:urls completion:^{
//        NSLog(@"接收到全部数组下载完成了");
//    }];
    //------------
}




#pragma mark -
#pragma mark RDUserNotifyCenterDelegate 相关返回方法
- (void)didReceiveNotificationResponse:(UNNotificationResponse*)response content:(UNNotificationContent*)content isLocal:(BOOL)blocal
{
    NSString     *actionID      = response.actionIdentifier;
    NSString     *categoryID    = content.categoryIdentifier;
    NSDictionary *userInfo      = content.userInfo;
    
    
    if([actionID isEqualToString:@"com.apple.UNNotificationDefaultActionIdentifier"])
    {
        //点击内容窗口进来的
        NSLog(@"点击内容窗口进来的");
    }
    else
    {
        //点击自定义Action按钮进来的
        NSLog(@"点击自定义Action按钮进来的 actionID: %@", actionID);
    }
}




#pragma mark -
#pragma mark 推送界面相关
- (void)pushSimuAction:(id)sender
{
    RDPushSimuVC *simuVC = [[RDPushSimuVC alloc] init];
    [self.navigationController pushViewController:simuVC animated:YES];
}






@end
