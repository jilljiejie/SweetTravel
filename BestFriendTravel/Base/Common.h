//
//  Common.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/24.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#ifndef BestFriendTravel_Common_h
#define BestFriendTravel_Common_h

//屏幕的宽
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
//推荐，最外层接口sn为参数,sn+=10
#define BASE_URL @"http://e-traveltech.com/travelNotes/article/getArticleBlocks?sn=%d&nu=10&device_id=aimei865267027250405&plat=aphone&os_version=4.4.2&version=2.5.0&dev_model=Coolpad_8675&net_type=WIFI&language=1&channel_id=1030101&invitation_code=&t=1448438274&user_id=0&s="
//每日一问的借口,sn为参数,sn+=10
#define QUESTION_URL @"http://e-traveltech.com/travelNotes/article/getArticleBlocks?sn=%d&nu=10&type=1&title=每日一问&device_id=aimei865267027250405&plat=aphone&os_version=4.4.2&version=2.5.0&dev_model=Coolpad_8675&net_type=WIFI&language=1&channel_id=1030101&invitation_code=&t=1448536783&user_id=0&s="

//发现最美景致的接口,sn为参数,sn+=10
#define FIND_URL @"http://e-traveltech.com/travelNotes/article/getArticleBlocks?sn=%d&nu=10&type=1&title=发现醉美景致&device_id=aimei865267027250405&plat=aphone&os_version=4.4.2&version=2.5.0&dev_model=Coolpad_8675&net_type=WIFI&language=1&channel_id=1030101&invitation_code=&t=1448438274&user_id=0&s="
//户外达人的接口,sn为参数,sn+=10
#define OUT_URL @"http://e-traveltech.com/travelNotes/article/getArticleBlocks?sn=%d&nu=10&type=1&title=户外达人&device_id=aimei865267027250405&plat=aphone&os_version=4.4.2&version=2.5.0&dev_model=Coolpad_8675&net_type=WIFI&language=1&channel_id=1030101&invitation_code=&t=1448438274&user_id=0&s="

//热门游记的接口,sn为参数,sn+=10
#define HOT_URL @"http://e-traveltech.com/travelNotes/article/getArticleBlocks?sn=%d&nu=10&type=1&title=热门游记&device_id=aimei865267027250405&plat=aphone&os_version=4.4.2&version=2.5.0&dev_model=Coolpad_8675&net_type=WIFI&language=1&channel_id=1030101&invitation_code=&t=1448438274&user_id=0&s="
//tabBar发现的接口
#define FINDALL_URL @"http://api.breadtrip.com/hunter/products/more/?start=%d&city_name=北京&lat=40.11508556005164&lng=116.24508074995424"


//选择城市后刷新
#define FINDCHOSE_URL @"http://api.breadtrip.com/hunter/products/more/?start=%d&city_name=%@&lat=40.11508556005164&lng=116.24508074995424"
//目的地界面
#define ROUTALL_URL @"http://tubu.ibuzhai.com/rest/v2/trail/regions?&api_version=1&app_version=4.6.1&device_type=2"
//目的地点击进去的界面  (参数是search=城市的名字,page++)
#define ROUTDETAIL_URL @"http://tubu.ibuzhai.com/rest/v2/trails?&page_size=20&area_id=&page=%d&search=%@&device_type=2&search_in=1&app_version=4.6.1&api_version=1&access_token="
//目的地点击进去的界面下一个界面(参数是城市的id)
#define ROUTTHIRD_URL @"http://tubu.ibuzhai.com/rest/v2/trail/%@?&api_version=1&app_version=4.6.1&trail_id=942&device_type=2"
//目的地讨论区的接口（参数是城市的id）
#define ROUTTALK_URL @"http://tubu.ibuzhai.com/rest/v1/trail/%@/bbs/1/posts?&page_size=20&page=1&device_type=2&app_version=4.6.1&bbs_catid=1&api_version=1&trail_id=%@&access_token="
//专题
#define TOPIC_URL @"http://tubu.ibuzhai.com/rest/v1/trail/types?&api_version=1&app_version=4.6.1&device_type=2"

#define TOPICSECOND_URL @"http://tubu.ibuzhai.com/rest/v1/trail/type/%@?&app_version=4.6.1&page_size=20&api_version=1&page=%d&device_type=2&access_token=&type_id=%@"

#define TRAVELWRITE_URL @"http://tubu.ibuzhai.com/rest/v1/travelog/trail/%@?&app_version=4.6.1&page_size=20&api_version=1&page=1&trail_id=%@&device_type=2"

//tabBarItem发现详情接口
#define FINDDETAIL_URL @"http://web.breadtrip.com/hunter/product/"



#endif
