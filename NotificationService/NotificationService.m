//
//  NotificationService.m
//  NotificationService
//
//  Created by Radar on 2016/11/29.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "NotificationService.h"
#import "RDUserNotifyCenter.h"


@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    

    //重写一些东西
    self.bestAttemptContent.title = @"我是新标题，说明我拦截到通知了";
//    self.bestAttemptContent.subtitle = @"我是子标题";
//    self.bestAttemptContent.body = @"Y的终于调通了";
    
    
    //这里添加一些点击事件，可以在收到通知的时候，添加，也可以在拦截通知的这个扩展中添加
    //self.bestAttemptContent.categoryIdentifier = @"myNotificationCategory";
    
    
    
//    //获取attachment并且存入group
//    [RDUserNotifyCenter downAndSaveAttachmentForNotifyRequest:request completion:^(UNNotificationAttachment *attach) {
//        
//        //attach先弄下来，起码保证推送过来的图片能看到
//        if(attach)
//        {
//            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
//        }
//        //必须读取完attach才可以走后面，否则attach看不到更没意义
//        self.contentHandler(self.bestAttemptContent);
//    }];
    
    
    
    //NSString *link = [RDUserNotifyCenter getValueForKey:@"goto_page" inNotification:request];
    
    NSString *listUrl = @"http://search.mapi.dangdang.com/index.php?action=list_category&user_client=iphone&client_version=6.3.0&udid=C468039A2648F6CDC79E77EDAC68C4FE&time_code=55029C0906B363E848DB2A969CF17E7A&timestamp=1481122253&union_id=537-50&permanent_id=20161107192044709529023687781578603&page=1&page_size=10&sort_type=default_0&cid=4002778&img_size=e";
    
    
    //必须先完成前面的，
    //获取attachment并且存入group
    [RDUserNotifyCenter downAndSaveAttachmentForNotifyRequest:request completion:^(UNNotificationAttachment *attach) {
        
        //attach先弄下来，起码保证推送过来的图片能看到
        if(attach)
        {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
        
        //接下来下载对应的数据
        [RDUserNotifyCenter downAndSaveDataToGroup:listUrl forceKey:@"goto_page" completion:^(id data) {
            self.contentHandler(self.bestAttemptContent);
        }];
    }];
    
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}






@end
