//
//  RDPushTool.h
//  TestNCEDeom
//
//  Created by Radar on 2016/12/15.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWHub.h"
#import "NWLCore.h"
#import "NWNotification.h"
#import "NWPusher.h"
#import "NWSSLConnection.h"
#import "NWSecTools.h"

// TODO: Export your push certificate and key in PKCS12 format to pusher.p12 in the root of the project directory.
static NSString * const pkcs12FileName = @"pusher.p12";

// TODO: Set the password of this .p12 file below, but be careful *not* to commit passwords to a (public) repository.
static NSString * const pkcs12Password = @"123456";

// TODO: Set the device token of the device you want to push to, see
//       `-application:didRegisterForRemoteNotificationsWithDeviceToken:` for more details.
static NSString * const deviceToken = @"c79b18192ea895c33a58bd411dd4309d01f6ae6b8fd8804def2ecad4510a40c7";


@interface RDPushTool : NSObject <NWHubDelegate> {
    
}

//单实例
+ (instancetype)sharedTool;


- (void)connect;        //连接到APNs
- (void)disconnect;     //从APNs断开连结

- (void)pushPayload:(NSDictionary *)payloadDic completion:(void(^)(BOOL success))completion; //推送消息，返回是否推送成功，可以连续推送，里边有队列，//TO DO: 需要再考虑如何锁定连续操作的情况


//TO DO: 需要调研是否可以检测当前的连结状态，是否正在连接或者是否断开连结了


@end
