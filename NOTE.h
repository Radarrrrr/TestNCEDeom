//
//  NOTE.h
//  TestNCEDeom
//
//  Created by Radar on 2016/12/1.
//  Copyright © 2016年 Radar. All rights reserved.
//


//建议使用的推送结构
{
    "aps":
    {
        "alert":
        {
            "title":"我是原装标题",
            "subtitle":"我是副标题",
            "body":"it is a beautiful day"
        },
        "badge":1,
        "sound":"default",
        "mutable-content":"1",
        "category":"myNotificationCategory",
        "attach":"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=200&sharp=30"
    },
    "goto_page":"cms://page_id=14374"
}




//一些测试数据暂存---------------------------------------------------------
//单品测试数据
http://product.mapi.dangdang.com/index.php?action=get_product&user_client=iphone&client_version=6.3.0&udid=C468039A2648F6CDC79E77EDAC68C4FE&time_code=08BD43CAAA3586463EB6FA43687A6069&timestamp=1481112463&union_id=537-50&permanent_id=20161107192044709529023687781578603&pid=1142174671&expand=1,2,3,4,5,6&is_abtest=1&img_size=h&lunbo_img_size=h&result_format=3

//专题列表测试数据
http://cms.mapi.dangdang.com/index.php?action=list_cms_info&user_client=iphone&client_version=6.3.0&udid=C468039A2648F6CDC79E77EDAC68C4FE&time_code=76C9480EA17E4251BBEE55B478014536&timestamp=1481112638&union_id=537-50&permanent_id=20161107192044709529023687781578603&pageid=117094&page_no=1&img_size=e&result_format=3

//分类列表测试数据
http://search.mapi.dangdang.com/index.php?action=list_category&user_client=iphone&client_version=6.3.0&udid=C468039A2648F6CDC79E77EDAC68C4FE&time_code=55029C0906B363E848DB2A969CF17E7A&timestamp=1481122253&union_id=537-50&permanent_id=20161107192044709529023687781578603&page=1&page_size=10&sort_type=default_0&cid=4002778&img_size=e&result_format=3

//搜索列表测试数据
http://search.mapi.dangdang.com/index.php?action=all_search&user_client=iphone&client_version=6.3.0&udid=C468039A2648F6CDC79E77EDAC68C4FE&time_code=D859B3D061F614F9A893F2D732EA861E&timestamp=1481520394&union_id=537-50&permanent_id=20161107192044709529023687781578603&page=1&page_size=10&sort_type=default_0&keyword=Dog&img_size=e





//测试及演示相关推送payload数据结构------------------------------------------
//1. 推送一个默认Extension，原生状态展示图片
{
    "aps":
    {
        "alert":
        {
            "title":"我是原装标题",
            "subtitle":"我是副标题",
            "body":"it is a beautiful day"
        },
        "badge":1,
        "sound":"default",
        "mutable-content":"1",
        "category":"",
        "attach":"http://img3x2.ddimg.cn/29/14/1128514592-1_h_6.jpg"
    },
    "goto_page":""
}

//2. 推送一个自定义Extension，使用category = myNotificationCategory来展示图片和信息
{
    "aps":
    {
        "alert":
        {
            "title":"我是原装标题",
            "subtitle":"我是副标题",
            "body":"it is a beautiful day"
        },
        "badge":1,
        "sound":"default",
        "mutable-content":"1",
        "category":"myNotificationCategory",
        "attach":"http://img3x2.ddimg.cn/29/14/1128514592-1_h_6.jpg"
    },
    "goto_page":""
}

//3. 推送一个自定义Extension，使用category = notification_category_list来展示列表图片信息 4002778  10010412  4010621  4010623 
{
    "aps":
    {
        "alert":
        {
            "title":"我是原装标题",
            "subtitle":"我是副标题",
            "body":"it is a beautiful day"
        },
        "badge":1,
        "sound":"default",
        "mutable-content":"1",
        "category":"notification_category_list",
        "attach":"http://img3x2.ddimg.cn/29/14/1128514592-1_h_6.jpg"
    },
    "goto_page":"category://cid=4002778"
}

//3. 推送一个自定义Extension，使用category = notification_category_product来展示单品信息 1129549420  1142174671  1092437691 1478346305
{
    "aps":
    {
        "alert":
        {
            "title":"我是原装标题",
            "subtitle":"我是副标题",
            "body":"it is a beautiful day"
        },
        "badge":1,
        "sound":"default",
        "mutable-content":"1",
        "category":"notification_category_product",
        "attach":"http://img3x2.ddimg.cn/29/14/1128514592-1_h_6.jpg"
    },
    "goto_page":"product://pid=1142174671"
}





