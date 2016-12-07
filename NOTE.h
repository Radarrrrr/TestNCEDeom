//
//  NOTE.h
//  TestNCEDeom
//
//  Created by Radar on 2016/12/1.
//  Copyright © 2016年 Radar. All rights reserved.
//


/*
使用默认category，推送图片，下拉直接展示图片
{"aps":{"alert":"it is a beautiful day","badge":1,"mutable-content":"1","sound":"default"},"goto_page":"cms://page_id=14374","image":"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=200&sharp=30"}
*/


/*
使用自定义category，推送图片，下拉展示自定义界面，在自定义界面里边，通过group共享数据，自行绘制图片展示
{"aps":{"alert":"it is a beautiful day","badge":1,"mutable-content":"1","category":"myNotificationCategory","sound":"default"},"goto_page":"cms://page_id=14374","image":"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=200&sharp=30"}
*/





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


/*
//完整版推送通知，
{"aps":{"alert":{"title":"我是原装标题","subtitle":"我是副标题","body":"it is a beautiful day"},"badge":1,"sound":"default","mutable-content":"1","category":"myNotificationCategory","attach":"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=200&sharp=30"},"goto_page":"cms://page_id=14374"}

*/




//单品测试数据
http://product.mapi.dangdang.com/index.php?action=get_product&user_client=iphone&client_version=6.3.0&udid=C468039A2648F6CDC79E77EDAC68C4FE&time_code=08BD43CAAA3586463EB6FA43687A6069&timestamp=1481112463&union_id=537-50&permanent_id=20161107192044709529023687781578603&pid=1142174671&expand=1,2,3,4,5,6&is_abtest=1&img_size=h&lunbo_img_size=h&result_format=3

//专题列表测试数据
http://cms.mapi.dangdang.com/index.php?action=list_cms_info&user_client=iphone&client_version=6.3.0&udid=C468039A2648F6CDC79E77EDAC68C4FE&time_code=76C9480EA17E4251BBEE55B478014536&timestamp=1481112638&union_id=537-50&permanent_id=20161107192044709529023687781578603&pageid=117094&page_no=1&img_size=e&result_format=3

//分类列表测试数据
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
    "goto_page":"category://cid=4002778"
}
http://search.mapi.dangdang.com/index.php?action=list_category&user_client=iphone&client_version=6.3.0&udid=C468039A2648F6CDC79E77EDAC68C4FE&time_code=55029C0906B363E848DB2A969CF17E7A&timestamp=1481122253&union_id=537-50&permanent_id=20161107192044709529023687781578603&page=1&page_size=10&sort_type=default_0&cid=4002778&img_size=e&result_format=3





