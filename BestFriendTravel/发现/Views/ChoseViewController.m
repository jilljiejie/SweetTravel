//
//  ChoseViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/1.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "ChoseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ChoseViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UISearchBarDelegate,UISearchControllerDelegate>
{
    MKMapView *_mapView;
    CLLocationDegrees _latitude;//纬度
    CLLocationDegrees _longitude;//经度
}
@property(nonatomic,strong)UITextField *searchTextField;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLLocation *currentLocation;
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)CLGeocoder *geocoder;
@end

@implementation ChoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNav];
    [self configUI];
    
    [self getLatitudeAndLongitude];//第一次获得传过来的城市的经纬度
    [self creatMapView];
   
    [self createPoint];//第一次创建大头针
    [self locationSet];
}
#pragma mark---左侧返回按钮---
//设计返回按钮
-(void)createNav{
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftImage.image=[UIImage imageNamed:@"icon_back_button"];
    leftImage.userInteractionEnabled=YES;
    [leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAction)]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftImage];
}
//返回按钮的响应事件
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark----布局导航栏的searchController和下面的textField-----
-(void)configUI{
    //设置导航栏
    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.delegate=self;
    _searchController.searchBar.delegate=self;
    _searchController.searchBar.frame=CGRectMake(50, 0, self.view.bounds.size.width-200, 30);
    

    //不隐藏导航
    _searchController.hidesNavigationBarDuringPresentation=NO;
    //不显示蒙版
    _searchController.dimsBackgroundDuringPresentation=NO;
    _searchController.searchBar.placeholder=@"请输入您要搜索的城市";
    self.navigationItem.titleView=_searchController.searchBar;
    [_searchController.searchBar sizeToFit];
    
    //设置下面的textField
    _searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.view.bounds.size.width-40, 30)];
    //设置为圆角类型
    _searchTextField.borderStyle=UITextBorderStyleRoundedRect;
    _searchTextField.placeholder=@"请输入您要搜索的关键字";
    [self.view addSubview:_searchTextField];
}
#pragma mark----获取传过来的城市的经纬度------
//刚跳到这个界面是获取传过来的城市的经纬度
-(void)getLatitudeAndLongitude{
    //获得输入的地址
    NSString *address=self.cityName;
    if (address.length==0) {
        return;
    }
    //开始地理编码
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
        if (error || placemarks.count==0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"哎呦" message:@"您输入的地址没有找到，可能在月球上呢哦" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
            NSLog(@"您输入的地址没有找到，可能在月球上呢哦");
        }
        else{//编码成功找到了具体的位置信息
            for (CLPlacemark *placemark in placemarks) {
                NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
            }
            //取出获取的地理信息数组中的第一个显示在界面上
            CLPlacemark *firstPlacmark=[placemarks firstObject];
            //纬度
            
           _latitude=firstPlacmark.location.coordinate.latitude;
            //经度
            _longitude=firstPlacmark.location.coordinate.longitude;
            [self creatMapView];
            [self createPoint];
        }
    }];
    
  
}
#pragma mark-----点击搜索按钮触发的方法（获得要搜索的城市的经纬度）

//点击搜索按钮触发的方法（获得要搜索的城市的经纬度）
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //获得输入的地址
    NSString *address=self.searchController.searchBar.text;
    NSLog(@"*****%@",address);
    if (address.length==0) {
        return;
    }
    //开始地理编码
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"哎呦" message:@"您输入的地址没有找到，可能在月球上呢哦" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
        else{//编码成功找到了具体的位置信息
            for (CLPlacemark *placemark in placemarks) {
                NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
            }
            //取出获取的地理信息数组中的第一个显示在界面上
            CLPlacemark *firstPlacmark=[placemarks firstObject];
            //纬度
            _latitude=firstPlacmark.location.coordinate.latitude;
            //经度
            _longitude=firstPlacmark.location.coordinate.longitude;
            NSString *la=[NSString stringWithFormat:@"%.2f",_latitude];
            NSString *lo=[NSString stringWithFormat:@"%.2f",_longitude];
            NSLog(@"经度：%@*******纬度：%@",lo,la);
            [self creatMapView];
            //清除前面生成的大头针
            [_mapView removeAnnotations:_mapView.annotations];
            
            //大头针
            MKPointAnnotation *pointAnnotation=[[MKPointAnnotation alloc]init];
            //设置经纬度坐标
            pointAnnotation.coordinate=CLLocationCoordinate2DMake(_latitude, _longitude);
            //设置标题
            pointAnnotation.title=self.searchController.searchBar.text;
            //添加大头针
            [_mapView addAnnotation:pointAnnotation];
        }
    }];
}
#pragma mark---mapView相关---
-(void)creatMapView{
    _mapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
    //地图类型（默认）
    _mapView.mapType=MKMapTypeStandard;
    //设置地图是否能够滚动
    _mapView.scrollEnabled=YES;
    //设置中心点坐标
    _mapView.centerCoordinate=CLLocationCoordinate2DMake(_latitude, _longitude);
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(_latitude, _longitude), 3000, 3000);
    //设置地图展示的范围
    _mapView.region=region;
    //设置代理
    _mapView.delegate=self;
    [self.view insertSubview:_mapView belowSubview:self.searchTextField];

}
#pragma mark----创建大头针------
//创建大头针
-(void)createPoint{
    //大头针
    MKPointAnnotation *pointAnnotation=[[MKPointAnnotation alloc]init];
    //设置经纬度坐标
    pointAnnotation.coordinate=CLLocationCoordinate2DMake(_latitude, _longitude);
    //设置标题
    pointAnnotation.title=self.cityName;
    //添加大头针
    [_mapView addAnnotation:pointAnnotation];

}


-(void)locationSet{
    //设置代理
    self.locationManager.delegate=self;
    //设置距离
    self.locationManager.distanceFilter=100.0f;
    //设置精确度
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //添加字段(在info.plist)
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        //用户请求定位系统
        [self.locationManager requestWhenInUseAuthorization];
    }
    //开启位置检测
    [self.locationManager startUpdatingLocation];
    //设置代理
    self.searchTextField.delegate=self;
}
#pragma mark----CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation=[locations lastObject];
}
#pragma mark  ----MKMapViewDelegate------
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //先去队列中（根据可重用标识符）取可重用的MKPinAnnotationView
    MKPinAnnotationView *pinView=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"map"];
    //如果为空，我们就去创建
    if (pinView==nil) {
        pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"map"];
        //是否显示提示框
        pinView.canShowCallout=YES;
    }
    pinView.annotation=annotation;
    pinView.image=[UIImage imageNamed:@"ClusterMapMarker@2x"];
    return pinView;
}
////点击某个大头针时触发这个方法
//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    MKPointAnnotation *an=view.annotation;
//    NSLog(@"大头针名称%@",an.title);
//}
#pragma mark----UItextFieldDelegate----
//点击return按钮触发的方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//收起键盘
    //创建请求对象
    MKLocalSearchRequest *request=[[MKLocalSearchRequest alloc]init];
    //设置关键字
    request.naturalLanguageQuery=textField.text;
    
//    //设置搜索范围
//    MKCoordinateRegion region=MKCoordinateRegionMake(CLLocationCoordinate2DMake(_latitude, _longitude), MKCoordinateSpanMake(0.5, 0.5));
//    
//    request.region=region;
    
//    //设置搜索范围
    request.region=_mapView.region;
    //创建搜索对象
    MKLocalSearch *search=[[MKLocalSearch alloc]initWithRequest:request];
    //向服务器发起请求
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        //清空上次搜索遗留的大头针
        [_mapView removeAnnotations:_mapView.annotations];
        for (MKMapItem *item in response.mapItems) {
            //创建大头针
            MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
            //设置大头针的坐标（经纬度）
            annotation.coordinate=item.placemark.coordinate;
            //设置大头针的标题
            annotation.title=item.name;
            //设置大头针的子标题
            annotation.subtitle=item.phoneNumber;
            //添加大头针
            [_mapView addAnnotation:annotation];
        }
    }];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];//点击结束编辑
}

#pragma mark---懒加载----
-(CLLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc]init];
    }
    return _locationManager;
}
-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
