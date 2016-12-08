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
   
    //从group里边按照url读取数据
//    NSString *keyurl = [RDUserNotifyCenter getValueForKey:@"attach" inNotification:notification];
//    id data = [RDUserNotifyCenter loadDataFromGroup:keyurl];
    
    //从group里边按照payload的key读取数据
//    id data = [RDUserNotifyCenter loadDataFromGroup:@"attach" forNotification:notification];
//    UIImage *image = [UIImage imageWithData:data];
    
    //放一个imageview，显示从group里边共享过来的图片
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    imageView.image = image;
//    [self.view addSubview:imageView];
    

    //临时下载一段数据,显示出来 //测试结果，速度很慢
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    [self.view addSubview:imageView];
//    
//    NSString *attachUrl = (NSString*)[RDUserNotifyCenter getValueForKey:@"attach" inNotification:notification];
//    [RDUserNotifyCenter downLoadData:attachUrl completion:^(id data) {
//        if(data)
//        {
//            UIImage *image = [UIImage imageWithData:data];
//            imageView.image = image;
//        }
//    }];
    
    
    //获取数据
    id ldata = [RDUserNotifyCenter loadDataFromGroup:@"goto_page" forNotification:notification];
    NSDictionary *jdata = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:ldata options:NSJSONReadingAllowFragments error:nil];
    
    
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
