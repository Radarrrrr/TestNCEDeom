//
//  ViewController.m
//  TestNCEDeom
//
//  Created by Radar on 2016/11/10.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "ViewController.h"
#import "RDUserNotifyCenter.h"

@interface ViewController () <RDUserNotifyCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //注册
    [[RDUserNotifyCenter sharedCenter] registerUserNotification:self completion:^(BOOL success) {
        //do sth..
    }];
    
    
    
    //绑定action到category
    [[RDUserNotifyCenter sharedCenter] prepareBindingActions];

    [[RDUserNotifyCenter sharedCenter] appendAction:@"action1" actionTitle:@"进去看看" options:UNNotificationActionOptionForeground toCategory:@"myNotificationCategory"];
    [[RDUserNotifyCenter sharedCenter] appendAction:@"action2" actionTitle:@"取消" options:UNNotificationActionOptionDestructive toCategory:@"myNotificationCategory"];
    
//    [[RDUserNotifyCenter sharedCenter] appendAction:@"action11" actionTitle:@"第11个anction显示" options:UNNotificationActionOptionForeground toCategory:@"category_the_second"];
//    [[RDUserNotifyCenter sharedCenter] appendAction:@"action12" actionTitle:@"第12个anction显示" options:UNNotificationActionOptionForeground toCategory:@"category_the_second"];
    
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
    [[RDUserNotifyCenter sharedCenter] scheduleLocalNotify:nil 
                                              timeInterval:@"3" 
                                                   repeats:NO 
                                                     title:@"这是一个标题" 
                                                  subtitle:@"这是一个副标题"
                                                      body:@"这是通知文本正文" 
                                                attachment:@"attach_image.png" 
                                                lauchImage:@"launch_image@2x.jpg" 
                                                     sound:nil 
                                                     badge:1 
                                                      info:nil 
                                               useCategory:nil 
                                                  notifyid:@"123456788" 
                                                completion:^(NSError *error) {
                                                    //do sth...
                                                }
     ];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    [[UNUserNotificationCenter currentNotificationCenter] getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
//        NSLog(@"%ld", categories.count);
//    }];
}




- (void)didReceiveNotificationResponse:(UNNotificationResponse*)response content:(UNNotificationContent*)content isLocal:(BOOL)blocal
{
    NSString     *actionID      = response.actionIdentifier;
    NSString     *categoryID    = content.categoryIdentifier;
    NSDictionary *userInfo      = content.userInfo;
    
    
    if([response.actionIdentifier isEqualToString:@"com.apple.UNNotificationDefaultActionIdentifier"])
    {
        //点击内容窗口进来的
        NSLog(@"点击内容窗口进来的");
    }
    else
    {
        //点击自定义Action按钮进来的
        NSLog(@"点击自定义Action按钮进来的 actionID: %@", response.actionIdentifier);
    }
    
}

@end
