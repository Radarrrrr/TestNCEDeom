//
//  NotificationViewController.m
//  NotificationViewController
//
//  Created by Radar on 2016/11/10.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "RDUserNotifyCenter.h"


@interface NotificationViewController () <UNNotificationContentExtension>


@end


@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
   
    //TO DO: 这里要考虑是否可以使用RULImageView直接加载一个url图片？？
    
//    NSString *keyurl = [RDUserNotifyCenter getValueForKey:@"attach" inNotification:notification];
//    id data = [RDUserNotifyCenter loadDataFromGroup:keyurl];
    
    id data = [RDUserNotifyCenter loadDataFromGroup:@"attach" forNotification:notification];
    UIImage *image = [UIImage imageWithData:data];
    int i=0;
}


//TO DO: 这些按钮相关的东西还要再研究，不知道怎么才能把按钮和资源挂起来
//- (UNNotificationContentExtensionMediaPlayPauseButtonType)mediaPlayPauseButtonType
//{
//    return UNNotificationContentExtensionMediaPlayPauseButtonTypeDefault;
//}
//
//- (CGRect)mediaPlayPauseButtonFrame
//{
//    return CGRectMake(100, 100, 100, 100);
//}
//
//- (UIColor *)mediaPlayPauseButtonTintColor{
//    return [UIColor blueColor];
//}
//
//- (void)mediaPlay{
//    NSLog(@"mediaPlay,开始播放");
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.extensionContext mediaPlayingPaused];
//    });
//    
//    
//}
//- (void)mediaPause{
//    NSLog(@"mediaPause，暂停播放");
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.extensionContext mediaPlayingStarted];
//    });
//    
//    
//}





@end
