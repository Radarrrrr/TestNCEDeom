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





#pragma mark -
#pragma mark 一些初始化参数配置
// TODO: Export your push certificate and key in PKCS12 format to pusher.p12 in the root of the project directory.
static NSString * const pkcs12FileName = @"pusher.p12";

// TODO: Set the password of this .p12 file below, but be careful *not* to commit passwords to a (public) repository.
static NSString * const pkcs12Password = @"123456";

// TODO: Set the device token of the device you want to push to, see
//       `-application:didRegisterForRemoteNotificationsWithDeviceToken:` for more details.
static NSString * const kdeviceToken = @"c79b18192ea895c33a58bd411dd4309d01f6ae6b8fd8804def2ecad4510a40c7";





#define NOTIFICATION_RDPUSHTOOL_REPORT @"notification_rdpushtool_report"




//TO DO: 需要对推送的消息进行返回内容的整理，不仅包括成功失败，还得包括推送的devicetoken，summary，推送的内容，等等，全部都要返回，上层肯定需要使用的到
#pragma mark -
#pragma mark PTPushReport类  
//@property (nonatomic, copy) NSString *deviceToken;        //app当前推送的devicetoken




#pragma mark -
#pragma mark 主类
@interface RDPushTool : NSObject <NWHubDelegate> {
    
}

//单实例
+ (instancetype)sharedTool;


- (void)connect:(void(^)(BOOL success))completion; //连接到APNs，异步完成，通过返回状态判断是否连接成功
- (void)disconnect;                                //从APNs断开连结, 顺序完成，不需要异步处理

- (void)pushPayload:(NSDictionary *)payloadDic completion:(void(^)(BOOL success))completion; //推送消息，返回是否推送成功，可以连续推送，里边有队列，//TO DO: 需要再考虑如何锁定连续操作的情况


//TO DO: 需要调研是否可以检测当前的连结状态，是否正在连接或者是否断开连结了


//TO DO: 需要考虑沙盒与正式环境两种情况的切换，尽量简洁,可考虑从配置里边抓去debug还是appstore或adhoc来自动选择对应的证书


@end
