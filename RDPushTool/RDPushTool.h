//
//  RDPushTool.h
//  TestNCEDeom
//
//  Created by Radar on 2016/12/15.
//  Copyright © 2016年 Radar. All rights reserved.
//
// 消息推送工具类
// 本类为单实例，api很简单不多介绍了

//注1: 通过接收NOTIFICATION_RDPUSHTOOL_REPORT对应的广播来获取


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
//static NSString * const kdeviceToken = @"c79b18192ea895c33a58bd411dd4309d01f6ae6b8fd8804def2ecad4510a40c7";




//log report的广播发送和接收标志宏
#define NOTIFICATION_RDPUSHTOOL_REPORT @"notification_rdpushtool_report"

//log report的状态宏
#define RDPushTool_report_status_readP12fail        @"读取P12文件失败"
#define RDPushTool_report_status_importP12fail      @"加载P12文件失败"
#define RDPushTool_report_status_disonnected        @"断开连接"
#define RDPushTool_report_status_connecting         @"正在连接"
#define RDPushTool_report_status_Connectsuccess     @"APNs连接成功"
#define RDPushTool_report_status_Connectfailure     @"APNs连接失败"
#define RDPushTool_report_status_pushing            @"payload推送中"
#define RDPushTool_report_status_pushsuccess        @"推送成功"
#define RDPushTool_report_status_pushfailure        @"推送失败"





#pragma mark -
#pragma mark PTConnectReport类  
typedef enum {
    PTConnectReportStatusConnecting       = 0,
    PTConnectReportStatusConnectSuccess   = 1,
    PTConnectReportStatusConnectFailure   = 2
} PTConnectReportStatus;

@interface PTConnectReport : NSObject

@property (nonatomic)       PTConnectReportStatus status;  //当前连接状态
@property (nonatomic, copy) NSString *summary;             //当前连接状态的描述文字

@end



#pragma mark -
#pragma mark PTPushReport类  
typedef enum {
    PTPushReportStatusPushing       = 0,
    PTPushReportStatusPushSuccess   = 1,
    PTPushReportStatusPushFailure   = 2
} PTPushReportStatus;

@interface PTPushReport : NSObject

@property (nonatomic)       PTPushReportStatus status;  //当前推送状态
@property (nonatomic, copy) NSDictionary *payload;      //推送的内容payload
@property (nonatomic, copy) NSString *deviceToken;      //当前推送目标的devicetoken
@property (nonatomic, copy) NSString *summary;          //当前推送状态的描述文字

@end






#pragma mark -
#pragma mark 主类
@interface RDPushTool : NSObject <NWHubDelegate> {
    
}

//单实例
+ (instancetype)sharedTool;


- (void)connect:(void(^)(PTConnectReport *report))completion; //连接到APNs，异步完成，通过返回状态判断是否连接成功 //PS: report不会为nil，外部可以不用判断容错
- (void)disconnect;                                //从APNs断开连结, 顺序完成，不需要异步处理

- (void)pushPayload:(NSDictionary *)payloadDic toToken:(NSString *)deviceToken completion:(void(^)(PTPushReport *report))completion; //推送消息，返回是否推送成功，可以连续推送，里边有队列，//PS: report不会为nil，外部可以不用判断容错  


//TO DO: 需要考虑沙盒与正式环境两种情况的切换，尽量简洁,可考虑从配置里边抓去debug还是appstore或adhoc来自动选择对应的证书


@end
