//
//  NotificationViewController.m
//  NotifyExtensionList
//
//  Created by Radar on 2016/12/9.
//  Copyright © 2016年 Radar. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "RDUserNotifyCenter.h"

@interface NotificationViewController () <UNNotificationContentExtension>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    
    //测试方式1 做格子的方式
    float len  = [UIScreen mainScreen].bounds.size.width/3;
    float x = 0.0;
    float y = 0.0;
    NSInteger vtag = 100;
    
    for(int h=0; h<3; h++) //行
    {
        for(int v=0; v<3; v++) //列 
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
    

    
    //测试方式2，通过写好imageView，然后读取data，组合图片，再安装到imageView里边的方式，效率很低，显示时间消耗太长
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    _imageView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_imageView];
    
        
}

- (void)didReceiveNotification:(UNNotification *)notification {
    
    
    //测试方式1 做格子的方式
    id data = [RDUserNotifyCenter loadDataFromGroup:@"goto_page" forNotification:notification];
    NSDictionary *dataDic = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *products = [dataDic objectForKey:@"products"];
    if(!products || [products count] == 0) return;
    
    for(int i=0; i<products.count; i++)
    {
        NSDictionary *pdic = [products objectAtIndex:i];
        
        NSString *imgUrl = [pdic objectForKey:@"image_url"];
        id pdata = [RDUserNotifyCenter loadDataFromGroup:imgUrl forNotification:notification];
        
        if(pdata)
        {                        
            UIImageView *imgV = [self.view viewWithTag:(100+i)];
            if(!imgV) break;
            
            UIImage *img = [UIImage imageWithData:pdata];
            imgV.image = img; 
        }
    }
    
    
    

    
    //测试方式2，通过写好imageView，然后读取data，组合图片，再安装到imageView里边的方式，效率很低，显示时间消耗太长
//    NSDictionary *pdic = [products firstObject];
//    NSString *imgUrl = [pdic objectForKey:@"image_url"];
//    NSLog(@"图片开始读取: %@", imgUrl);
//    [RDUserNotifyCenter downLoadData:imgUrl completion:^(id data) {
//        if(data)
//        {
//            NSLog(@"图片读取完成");
//            UIImage *img = [UIImage imageWithData:data];
//            NSLog(@"图片组装完成");
//            _imageView.image = img;
//            NSLog(@"图片展示完成");
//            
//        }
//    }];

    
    

}




@end
