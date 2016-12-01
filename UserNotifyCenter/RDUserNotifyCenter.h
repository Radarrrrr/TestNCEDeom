//
//  RDUserNotifyCenter.h
//  TestNCEDeom
//
//  Created by Radar on 2016/11/10.
//  Copyright © 2016年 Radar. All rights reserved.
//

//注：本类必须iOS10以上使用
//注：获取devicetoken的方法，仍然是在appDelegate中使用:
//   - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken

//特别注意：必须在每个Target里面，点击buildSettings 然后把Require Only App-Extension-Safe API 然后把YES改为NO，否则可能遇到如下问题：
//'sharedApplication' is unavailable: not available on iOS (App Extension) - Use view controller based



/*
 使用方法：
 1. 添加头文件: import "RDUserNotifyCenter"
 2. 添加代理： <RDUserNotifyCenterDelegate> 
 3. 注册通知：[[[RDUserNotifyCenter sharedCenter] registerUserNotification:self completion:<#^(BOOL success)completion#>]]; 
 4. 实现代理协议：- (void)didReceiveNotificationResponse:content:isLocal 方法，在这个方法里边处理接收到的通知
 
 4. [可选]绑定catgegory和action，使用如下一套的方法
    - (void)prepareBindingActions;
    - (void)appendAction:....
    - (void)bindingActions;
 
 5. [可选]规划本地通知，可在任何地方调用，和前面的顺序不能错
    使用schedule系列的方法
*/


/*远程推送的消息通知数据结构如下：
 
 //现有payload格式
{
    "aps":
    {
        "alert":"xxxxx",
        "badge":"1",
        "sound":"default"
    },
    "goto_page" = "cms://page_id=14374"
}
 
 //新版payload格式
{
    "aps":
    {
         "alert":
         {
             "title":"hello",
             "subtitle":"Session 01",
             "body":"it is a beautiful day"
         },
         "category":"myNotificationCategory",
         "badge":1,
         "mutable-content":1, //iOS10非常重要
         "sound":"default"
    },
    "goto_page":"cms://page_id=14374",
    "image":"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=200&sharp=30",
    "source_url":"xxxxxxxxxxx"
}
 
 
*/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>




#pragma mark -
#pragma mark 一些通用的宏，用来全局使用，统一改动
#define RDUserNotifyCenter_App_Group_Suit @"group.com.dangdang.app"




@protocol RDUserNotifyCenterDelegate <NSObject>
@optional

//其他属性暂时不导出，这个地方直接返回response是因为里边带了太多信息，需要外面解析使用
//主要使用content和blocal参数，如果还不够，就去response里边找。
- (void)didReceiveNotificationResponse:(UNNotificationResponse*)response content:(UNNotificationContent*)content isLocal:(BOOL)blocal; 

@end



@interface RDUserNotifyCenter : NSObject <UNUserNotificationCenterDelegate> {
 
}
 
@property (assign) id <RDUserNotifyCenterDelegate> delegate;

//单实例
+ (instancetype)sharedCenter;



//注册通知，本地+远程，需要在适当的时候调用一次本方法，app才会开启通知功能 //特别注意，此方法必须在程序启动的时候调用一次，不管以前是否注册过，否则会收不到通知 //单独写此方法是因为很多app在第一次使用的时候，要紧跟着开启定位，通知，数据，三个提醒，太烦人了以至于用户很容易点错。
- (void)registerUserNotification:(id)delegate completion:(void (^)(BOOL success))completion;


//绑定action到指定的category上    //PS:目前暂不支持可以输入文字的anction样式   //PS:必须成套使用且只能使用一次，第二次使用会覆盖第一次
- (void)prepareBindingActions;
- (void)appendAction:(NSString *)actionID actionTitle:(NSString *)title options:(UNNotificationActionOptions)options toCategory:(NSString *)categoryID;
- (void)bindingActions; //prepare和binding必须配套使用




//规划本地通知
- (void)scheduleLocalNotify:(UNNotificationRequest *)request; //直接使用request规划本地通知，可以从外面直接做一个request调用。

//输入各种属性来规划本地通知的方法  //PS: 全量方法，不建议使用这个
- (void)scheduleLocalNotify:(NSDateComponents *)fireDate        //触发日期安排        //注意：前三个是互斥的触发方式，只能有一个存在，同时共存当作没有处理，三个都不存在则返回规划失败
               timeInterval:(NSString *)fireTimeInterval        //触发延后时间安排
                    repeats:(BOOL)repeats
                      title:(NSString *)title
                   subtitle:(NSString *)subtitle
                       body:(NSString *)body
                 attachment:(NSString *)attachmentName        //附件图片的名字即可，里边会自动在bundle里边找
                 lauchImage:(NSString *)lauchImageName        //下拉放大的时候展示的图片，也是在bundle里边找, PS://如果想显示这个图片，则必须不使用自定义category，即需要categoryid=nil
                      sound:(NSString *)soundName
                      badge:(NSInteger)badge
                       info:(NSDictionary *)infoDic           //用来记录要传递的内容，跳转字典等都放这里
                useCategory:(NSString *)categoryid            //不是必须有，如果不绑定类型，则下拉推送模块不会出现下拉自定义扩展窗口
                   notifyid:(NSString *)notifyid
                 completion:(void(^)(NSError *error))completion;


//规划本地通知 - 简化方法 - 根据日历规划
/*
 info:  //目前仅支持这几个种类，为了使用起来更方便，如果以后需要，再增加
 @{ 
     @"fire_timeinterval":@"5",              //触发时间延时 //注意，repeats的规则是下一次触发点是本次触发以后的timeinterval时间以后
     @"fire_msg":@"xxxxx",                   //触发时的显示信息
     @"link_url":@"xxxxx",                   //[可选]跳转字典
     @"category_id":@"xxxxx",                //[可选]此通知可以使用的下拉展开窗口的类型 
     @"attach":@"xxxxx",                     //[可选]通知带的图片附件
     @"repeats":@"1",                        //[可选]是否重复，使用0和1 //默认 0
     @"sound":@"xxxxx",                      //[可选]提示声音文件名，必须来自程序内置的，不写则使用默认声音
     ...                                     //[可选]可以随意添加更多数据，比如链接字典等，都会挂在userInfo里边   
  }
 */
- (void)scheduleTimeIntervalLocalNotify:(NSDictionary *)info completion:(void(^)(NSString *notifyid))completion; //只用info来规划本地通知, 规划成功以后会返回notifyid, 规划不成功则会返回nil，info也会加入到content.userInfo，用来接到通知以后使用


//规划本地通知 - 简化方法 - 根据日历规划
/*
 info:  //目前仅支持这几个种类，为了使用起来更方便，如果以后需要，再增加
 @{ 
    @"fire_date":@"YY-MM-dd HH:mm:ss",      //触发事件 //注意，repeats的规则是寻找下一次可以触发的时间点，所以如果每日触发，则不能写年、月、日，以此类推，以空格为界，分别向中间减少元素 如 MM-dd HH:mm  写的时候一定要注意前后不能出现空格，否则会出错
    @"fire_msg":@"xxxxx",                   //触发时的显示信息
    @"link_url":@"xxxxx",                   //[可选]跳转字典
    @"category_id":@"xxxxx",                //[可选]此通知可以使用的下拉展开窗口的类型 
    @"attach":@"xxxxx",                     //[可选]通知带的图片附件
    @"repeats":@"1",                        //[可选]是否重复，使用0和1 //默认 0
    @"sound":@"xxxxx",                      //[可选]提示声音文件名，必须来自程序内置的，不写则使用默认声音
    ...                                     //[可选]可以随意添加更多数据，比如链接字典等，都会挂在userInfo里边 
  }
*/
- (void)scheduleCalendarLocalNotify:(NSDictionary *)info completion:(void(^)(NSString *notifyid))completion; //只用info来规划本地通知, 规划成功以后会返回notifyid, 规划不成功则会返回nil，info也会加入到content.userInfo，用来接到通知以后使用




//撤销本地通知
+ (void)revokeNotifyWithIds:(NSArray *)notifyIds;               //根据通知的notifyid数组取消该通知，可以批量取消
+ (void)revokeAllNotifications;                                 //取消所有已经规划的消息通知

//检查通知是否已经添加
+ (void)checkHasScheduledById:(NSString *)notifyid feedback:(void(^)(BOOL scheduled))completion;             //通过notifyid判断是否已经添加


//一些配套方法
+ (NSString *)md5NotifyID:(NSString *)notifyIdStr;                  //字符串做md5，仅供外部调用本类时，拼一个id，和本地做对应，不做别的用途，别处使用需要使用通用方法里边的
+ (NSDateComponents *)compoFromDateString:(NSString *)dateString;   //根据日期格式获得NSDateComponents对象 //格式必须为: @"YY-MM-dd HH:mm:ss"
+ (NSDateComponents *)compoFromDate:(NSDate*)date;                  //根据日期对象获得NSDateComponents对象

+ (void)saveDataToGroup:(id)data forNotifyID:(NSString*)notifyid;   //根据通知的id存储数据到group里边
+ (id)loadDataFromGroup:(NSString*)notifyid;                        //根据通知的id从group里边取出存储的数据



@end


