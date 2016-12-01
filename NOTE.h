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





