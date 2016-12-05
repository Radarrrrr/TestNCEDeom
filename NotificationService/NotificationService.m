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
    
    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//    
//    // 重写一些东西
    self.bestAttemptContent.title = @"我是新标题，说明我拦截到通知了";
//    self.bestAttemptContent.subtitle = @"我是子标题";
//    self.bestAttemptContent.body = @"Y的终于调通了";
    
    
//    self.contentHandler(self.bestAttemptContent);
//    return;
    
    // 这里添加一些点击事件，可以在收到通知的时候，添加，也可以在拦截通知的这个扩展中添加
    //self.bestAttemptContent.categoryIdentifier = @"myNotificationCategory";
    
    
    
    //获取attachment并且存入group
    [RDUserNotifyCenter downAndSaveAttachmentForNotifyRequest:request completion:^(UNNotificationAttachment *attach) {
        
        if(attach)
        {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
        self.contentHandler(self.bestAttemptContent);
    }];
    
    
    
    return;
    //下面的是例子代码的--------
    
    // 附件
//    NSDictionary *dict =  self.bestAttemptContent.userInfo;
//    NSDictionary *apsDict = dict[@"aps"];    
//    NSString *imgUrl = apsDict[@"attach"];
//    if(!imgUrl || [imgUrl isEqualToString:@""]) 
//    {
//        self.contentHandler(self.bestAttemptContent);
//    }
//
//    //放在最后
//    [self loadAttachmentForUrlString:imgUrl withType:@"jpg" completionHandle:^(UNNotificationAttachment *attach) {
//        
//        if (attach) {
//            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
//            //self.bestAttemptContent.launchImageName = @"launch_image@2x.jpg";
//            
//            
////            //------------------
////            //save image
////            id data = [NSData dataWithContentsOfURL:attach.URL];
////            UIImage *image = [UIImage imageWithData:data];
////            
////            [RDUserNotifyCenter saveDataToGroup:data forNotifyID:request.identifier];
////            int i=0;
////            //------------------
//            
//        }
//        self.contentHandler(self.bestAttemptContent);
//        
//    }];
//    

}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}



- (void)loadAttachmentForUrlString:(NSString *)urlStr
                          withType:(NSString *)type
                  completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler{
    
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    //下载图片
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        
                        
//                        //------------------
//                        //save image
//                        id data = [NSData dataWithContentsOfURL:temporaryFileLocation];
//                        UIImage *image = [UIImage imageWithData:data];
//                        
//                        [RDUserNotifyCenter saveDataToGroup:data forNotifyID:@"222222"];
//                        int i=0;
//                        //------------------
                        
                        
                        
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    
                    completionHandler(attachment);
                    
                }] resume];
    
    
    
}
- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    
    
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    
    return [@"." stringByAppendingString:ext];
}





@end
