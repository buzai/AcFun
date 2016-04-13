//
//  httpApiTools.m
//  AcFun
//
//  Created by 陈 on 16/4/13.
//  Copyright © 2016年 chenhao. All rights reserved.
//


//curl -H "Host: api.aixifan.com" -H "productId: 2000" -H "market: appstore" -H "Accept: */*" -H "appVersion: 4.1.7" -H "Accept-Language: zh-Hans;q=1, en;q=0.9, fr;q=0.8, de;q=0.7, zh-Hant;q=0.6, ja;q=0.5" -H "deviceType: 0" -H "User-Agent: AcFun/4.1.7 (iPhone; iOS 7.0.4; Scale/2.00)" -H "resolution: 640x1136" -H "udid: EE3D23C1-E1D3-44DE-B52D-2F565F62EB27" --compressed http://api.aixifan.com/videos/2664752

//api http://api.aixifan.com/videos/2664752
//{
//    "code": 200,
//    "data": {
//        
//        "channelId": 86,
//        "contentId": 2664752,
//        "cover": "http://cdn.aixifan.com/dotnet/artemis/u/cms/www/201604/12162143v2u4n7in.jpg",
//        
//        "description": "以后基本1周1更或2周3更！故P略多，这样也方便制作曲包。\r<br/>——————————求香蕉——————————\r<br/>曲包：链接：http://pan.baidu.com/s/1mi1XVba密码：717d【或】http://www.ctfile.com/shared/folder_13891038_dc7c6b1c/",
//        
//        "display": 0,
//        "isArticle": 0,
//        "isRecommend": 1,
//        
//        
//        "owner": {
//            "avatar": "http://cdn.aixifan.com/dotnet/artemis/u/cms/www/201603/15170004u158ed90.jpg",
//            "id": 1262073,
//            "name": "砍海椒"
//        },
//        
//        
//        "releaseDate": 1460447649000,
//        
//        "status": 2,
//        
//        "tags": ["动画", "娱乐", "曲包", "美女"],
//        
//        "title": "搜罗YouTube上那些好听好看好玩的视频 第十期（希望大家多发弹幕和评论，UP好确定大家的喜好）",
//        
//        "topLevel": 0,
//        "updatedAt": 1460556340000,
//        "videoCount": 27,
//        
//        "videos":
//            [{
//                "allowDanmaku": 1,
//                "commentId": 3389613,
//                "danmakuId": 3389613,
//                "sourceId": "3389613",
//                "sourceType": "zhuzhan",
//                "startTime": 0,
//                "time": 148,
//                "title": "音乐还可以这样玩，炫酷(这个东西叫Launchpad)Martin Garrix - Animals (R!OT Drop Edit)(有曲包)",
//                "url": "",
//                "videoId": 3389613,
//                "visibleLevel": -1
//            }],
//        
//        
//        "viewOnly": 0,
//        
//        "visit":
//            {
//                "comments": 95,
//                "danmakuSize": 745,
//                "goldBanana": 357,
//                "score": 0,
//                "stows": 1809,
//                "ups": 0,
//                "views": 246074
//            }
//    },
//    "message": "OK"
//    
//}



#import "httpApiTools.h"

@implementation httpApiTools

@end
