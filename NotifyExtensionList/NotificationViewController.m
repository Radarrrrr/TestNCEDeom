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
//@property (nonatomic, strong) UILabel *titleL;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    
    //做格子
//    float len  = [UIScreen mainScreen].bounds.size.width/3;
//    float x = 0.0;
//    float y = 0.0;
//    NSInteger vtag = 100;
//    
//    for(int h=0; h<3; h++) //行
//    {
//        for(int v=0; v<3; v++) //列 
//        {
//            x = len * v;
//            y = len * h;
//                        
//            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, len, len)];
//            imgV.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1.0];
//            imgV.tag = vtag;
//            [self.view addSubview:imgV];
//            
//            vtag++;
//        }
//    }
    

    
    //测试方式1，通过写好imageView，然后读取data，组合图片，再安装到imageView里边的方式，效率很低，显示时间消耗太长
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    _imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_imageView];
    
    
    //测试方式2，文字没有问题
//    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 20)];
//    _titleL.font = [UIFont boldSystemFontOfSize:16];
//    _titleL.textColor = [UIColor redColor];
//    [self.view addSubview:_titleL];
    
        
}

- (void)didReceiveNotification:(UNNotification *)notification {
    
    id data = [RDUserNotifyCenter loadDataFromGroup:@"goto_page" forNotification:notification];
    NSDictionary *dataDic = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *products = [dataDic objectForKey:@"products"];
    if(!products || [products count] == 0) return;
    
//    for(int i=0; i<products.count; i++)
//    {
//        NSDictionary *pdic = [products objectAtIndex:i];
//        
//        NSString *imgUrl = [pdic objectForKey:@"image_url"];
//        [RDUserNotifyCenter downLoadData:imgUrl completion:^(id data) {
//            if(data)
//            {
//                NSLog(@"读取完成第 %d 个", i);
//                
//                UIImageView *imgV = [self.view viewWithTag:(100+i)];
//                if(imgV)
//                {
//                    UIImage *img = [UIImage imageWithData:data];
//                    NSLog(@"第 %d 个的图片完成", i);
//                    imgV.image = img;
//                }
//            }
//        }];
//    }
    
    
    
    
//    id pdata = [RDUserNotifyCenter loadDataFromGroup:@"attach" forNotification:notification];
//    UIImage *attachImg = [UIImage imageWithData:pdata];
//    _imageView.image = attachImg;
    
    
    
    
    //测试方式1，通过写好imageView，然后读取data，组合图片，再安装到imageView里边的方式，效率很低，显示时间消耗太长, 瓶颈在UIImageView显示图片用时太长
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
    
    
    //测试方式2，文字没有问题
//    NSString *name = [pdic objectForKey:@"name"];
//    _titleL.text = name;
    
}




@end
