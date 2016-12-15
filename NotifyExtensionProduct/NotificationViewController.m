//
//  NotificationViewController.m
//  NotifyExtensionProduct
//
//  Created by Radar on 2016/12/1.
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
    
    //图片
    float len  = [UIScreen mainScreen].bounds.size.width/2;
    float x = 0.0;
    float y = 0.0;
    NSInteger vtag = 100;
    
    for(int h=0; h<2; h++) //行
    {
        for(int v=0; v<2; v++) //列 
        {
            x = len * v;
            y = len * h;
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, len, len)];
            imgV.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1.0];
            imgV.tag = vtag;
            [self.view addSubview:imgV];
            
            vtag++;
        }
    }
    
    //名称
    UITextView *nameL = [[UITextView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.width+5, [UIScreen mainScreen].bounds.size.width-30, 50)];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.font = [UIFont boldSystemFontOfSize:16.0];
    nameL.textColor = [UIColor blackColor];
    nameL.tag = 1001;
    [self.view addSubview:nameL];
    
    //价格
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(nameL.frame), [UIScreen mainScreen].bounds.size.width-40, 20)];
    priceL.font = [UIFont boldSystemFontOfSize:14.0];
    priceL.textColor = [UIColor redColor];
    priceL.tag = 1002;
    [self.view addSubview:priceL];
    
    //line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(priceL.frame)+5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    //店铺logo
    UIImageView *logoV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(nameL.frame)+30, len/2.5, len/2.5)];
    logoV.backgroundColor = [UIColor clearColor];
    logoV.tag = 1003;
    [self.view addSubview:logoV];
    
    //店铺名称
    UITextView *shopL = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoV.frame)+10, CGRectGetMinY(logoV.frame), [UIScreen mainScreen].bounds.size.width-CGRectGetWidth(logoV.frame)-15-10-20, 40)];
    shopL.font = [UIFont systemFontOfSize:14.0];
    shopL.backgroundColor = [UIColor clearColor];
    shopL.textColor = [UIColor darkGrayColor];
    shopL.tag = 1004;
    [self.view addSubview:shopL];
    
}

- (void)didReceiveNotification:(UNNotification *)notification {
    
    id data = [RDUserNotifyCenter loadDataFromGroup:@"goto_page" forNotification:notification];
    NSDictionary *dataDic = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *infoDic = [dataDic objectForKey:@"product_info_new"];
    
    //展示图片
    NSArray *images = [infoDic objectForKey:@"images_big"];
    for(int i=0; i<images.count; i++)
    {
        NSString *imgUrl = [images objectAtIndex:i];
        id pdata = [RDUserNotifyCenter loadDataFromGroup:imgUrl forNotification:notification];
        
        if(pdata)
        {                        
            UIImageView *imgV = [self.view viewWithTag:(100+i)];
            if(!imgV) break;
            
            UIImage *img = [UIImage imageWithData:pdata];
            imgV.image = img; 
        }
    }
    
    //展示名称和价格
    UITextView *nameL = [self.view viewWithTag:1001];
    nameL.text = [infoDic objectForKey:@"product_name"];
    
    UILabel *priceL = [self.view viewWithTag:1002];
    priceL.text = [NSString stringWithFormat:@" ¥ %@", [infoDic objectForKey:@"sale_price"]];
    
    //展示店铺信息
    NSDictionary *shopDic = [dataDic objectForKey:@"shop_info"];
    NSString *logoUrl = [shopDic objectForKey:@"shop_logo"];
    id lodata = [RDUserNotifyCenter loadDataFromGroup:logoUrl forNotification:notification];
    if(lodata)
    {
        UIImageView *logoV = [self.view viewWithTag:1003];
        UIImage *img = [UIImage imageWithData:lodata];
        logoV.image = img; 
    }
    
    UITextView *shopL = [self.view viewWithTag:1004];
    shopL.text = [shopDic objectForKey:@"shop_name"];
    
}






@end
