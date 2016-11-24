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
    [[RDUserNotifyCenter sharedCenter] appendAction:@"action2" actionTitle:@"取消" options:UNNotificationActionOptionForeground toCategory:@"myNotificationCategory"];
    
//    [[RDUserNotifyCenter sharedCenter] appendAction:@"action11" actionTitle:@"第11个anction显示" options:UNNotificationActionOptionForeground toCategory:@"category_the_second"];
//    [[RDUserNotifyCenter sharedCenter] appendAction:@"action12" actionTitle:@"第12个anction显示" options:UNNotificationActionOptionForeground toCategory:@"category_the_second"];
    
    [[RDUserNotifyCenter sharedCenter] bindingActions];
    
    
    
    //规划本地通知
    NSDictionary *info = @{ 
                              @"fire_timeinterval"  :@"3",   
                              @"fire_msg"   :@"这是一个本地通知的测试",                   
                              @"link_url"   :@"check://",                   
                              @"category_id":@"myNotificationCategory"               
                              //@"attach"     :@"xxxxx",                    
                              //@"repeats"    :@"1",                        
                              //@"sound"      :@"xxxxx"                     
                          };
    
    [[RDUserNotifyCenter sharedCenter] scheduleTimeIntervalLocalNotify:info completion:^(NSString *notifyid) {
        //do sth...
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    [[UNUserNotificationCenter currentNotificationCenter] getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
//        NSLog(@"%ld", categories.count);
//    }];
    
}




- (void)didReceiveNotificationResponse:(UNNotificationResponse*)response content:(UNNotificationContent*)content isLocal:(BOOL)blocal
{
    
    
}

@end
