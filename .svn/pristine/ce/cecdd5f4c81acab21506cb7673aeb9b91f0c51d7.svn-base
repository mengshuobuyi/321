//
//  MapViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "MapViewController.h"
#import "ZhPMethod.h"
#import "LeveyPopListView.h"
#import "SVProgressHUD.h"
#import "GeocodeAnnotation.h"
#import "CommonUtility.h"
#import "AppDelegate.h"
#import "Constant.h"

#import "CusAnnotationView.h"

#import "Map.h"
#import "MapModel.h"
#import "MapModelR.h"

#import "Store.h"
#import "StoreModel.h"
#import "StoreModelR.h"
#import "Circle.h"
//#define SPAN  MACoordinateSpanMake(0.07, 0.07)
#define SPAN  MACoordinateSpanMake(0.025, 0.025)

#define TAG_PROVINCE 555 //省tag
#define TAG_CITY 556    //市tag
#define TAG_TEXTFIELD 557  //街区tag
#define TAG_LOADINGVIEW 558 //加载的view

#define kWidth  21.f
#define kHeight 32.f


@interface MapViewController ()<AMapSearchDelegate,MAMapViewDelegate,LeveyPopListViewDelegate,UITextFieldDelegate>
{
    UIImageView * topView;
    
    NSString * provinceCode;
    NSString * provinceName;
    NSString * cityCode;
    NSString * cityName;
    
    
    NSString * fieldText;
    NSString * annTitle;
    
    UIButton * provinceButton;
    UIButton * cityButton;
    UITextField * streetTextField;
    BOOL        isLongPress;
    
    
    BOOL textChange;

}

@property (nonatomic ,strong) NSMutableDictionary *userLocation;
@property (nonatomic ,strong) MAMapView *mapView;
@property (nonatomic ,strong) AMapSearchAPI *mapSearchAPI;
@property (nonatomic ,strong) MAUserLocation *currentLocation;

@property (nonatomic ,strong) NSMutableArray *provinceArray;
@property (nonatomic ,strong) NSMutableArray *cityArray;
@property (nonatomic ,strong) NSMutableArray *countryArray;

@end

@implementation MapViewController

- (id)init{
    if (self = [super init]) {
        self.title = @"标注机构地理位置";

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    textChange = NO;
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] init];
    self.mapView = QWGLOBALMANAGER.mapView;
    self.mapView.frame = CGRectMake(0, 40, APP_W, APP_H-20-NAV_H);
    [self.mapView addGestureRecognizer:longPress];
    self.mapView.showsUserLocation = YES;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [longPress addTarget:self action:@selector(longPressToAddAnnotation:)];
    
    self.userLocation = [NSMutableDictionary dictionary];

    
    self.mapSearchAPI = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
    
    topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 40)];
    topView.userInteractionEnabled = YES;
    topView.image = [UIImage imageNamed:@"地理位置背景.png"];
    [self.view addSubview:topView];
    
    //省
    provinceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    provinceButton.tag = TAG_PROVINCE;
    [provinceButton setFrame:CGRectMake(5, 10, 60, 20)];
    [provinceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    provinceButton.titleLabel.font = fontSystem(14);
    [provinceButton setTitle:@"省(必填)" forState:UIControlStateNormal];
    provinceButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [provinceButton addTarget:self action:@selector(loadProvince) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:provinceButton];
    
    UIImage * arrImage = [UIImage imageNamed:@"下拉箭头.png"];
    UIImageView * arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(provinceButton.frame.origin.x + provinceButton.frame.size.width + 5, topView.frame.size.height/2 - arrImage.size.height/2, arrImage.size.width, arrImage.size.height)];
    arrView1.image = arrImage;
    [topView addSubview:arrView1];
    
    //市
    cityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cityButton setFrame:CGRectMake(arrView1.frame.origin.x + arrView1.frame.size.width + 10, 10, 55, 20)];
    cityButton.tag = TAG_CITY;
    [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cityButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cityButton.titleLabel.font = fontSystem(14);
    [cityButton addTarget:self action:@selector(loadCity) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cityButton];
    
    UIImageView * arrView2 = [[UIImageView alloc] initWithFrame:CGRectMake(cityButton.frame.origin.x + cityButton.frame.size.width + 5, topView.frame.size.height/2 - arrImage.size.height/2, arrImage.size.width, arrImage.size.height)];
    arrView2.image = arrImage;
    [topView addSubview:arrView2];
    
    //输入框
    streetTextField = [[UITextField alloc] initWithFrame:CGRectMake(arrView2.frame.origin.x + arrView2.frame.size.width + 10, 8, 90, 25)];
    streetTextField.delegate = self;
    streetTextField.tag = TAG_TEXTFIELD;
    streetTextField.font = fontSystem(14);
    streetTextField.delegate = self;
    streetTextField.borderStyle = UITextBorderStyleNone;
    streetTextField.placeholder = @"路/街";
    [topView addSubview:streetTextField];
    
    //定位按钮
    UIButton * locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [locationButton setFrame:CGRectMake(streetTextField.frame.origin.x + streetTextField.frame.size.width+10, 0, APP_W - (streetTextField.frame.origin.x + streetTextField.frame.size.width+10), 40)];
    [locationButton addTarget:self action:@selector(locationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:locationButton];
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]init];
    UIImage * locationImage = [UIImage imageNamed:@"定位.png"];
    UIImageView * locationClick = [[UIImageView alloc] initWithFrame:CGRectMake(10, topView.frame.size.height/2-locationImage.size.height/2, locationImage.size.width, locationImage.size.height)];
    locationClick.userInteractionEnabled = YES;
    [locationClick addGestureRecognizer:imageTap];
    locationClick.image = locationImage;
    [imageTap addTarget:self action:@selector(locationButtonClick)];
    [locationButton addSubview:locationClick];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sureButton setFrame:CGRectMake(0, self.mapView.frame.size.height-20, APP_W, 40)];
    if (self.ComfromQuick ==YES ) {
        [sureButton setTitle:@"确认选中位置,完成注册验证" forState:UIControlStateNormal];
    }else{
        [sureButton setTitle:@"确认选中位置" forState:UIControlStateNormal];
    }
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setBackgroundColor:RGBHex(qwColor1)];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
    UIView * loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 40)];
    loadingView.backgroundColor = [UIColor whiteColor];
    loadingView.tag = TAG_LOADINGVIEW;
    UILabel * loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, APP_W-20, 20)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"正在定位中,请稍后...";
    loadingLabel.font = fontSystem(15);
    [loadingView addSubview:loadingLabel];
    [topView addSubview:loadingView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unloadMapView];
}

- (void)unloadMapView
{
    self.mapView.delegate = nil;
    self.mapView.mapType = MAMapTypeStandard;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.mapView.frame.size.height-8, APP_W-40, 40)];
    infoLabel.backgroundColor = [UIColor grayColor];
    infoLabel.text = @"准确标注位置，客户会更快找到你哦~";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = fontSystem(14);
    infoLabel.tag = 808;
    infoLabel.textColor = [UIColor whiteColor];
    [self.view insertSubview:infoLabel aboveSubview:self.mapView];
    
    [UIView animateWithDuration:2.0f delay:2.0f options:0 animations:^{
        infoLabel.alpha = 0;
    } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //FIXME:临时测试
    UIView * loadingView = (UIView *)[topView viewWithTag:TAG_LOADINGVIEW];
    [UIView animateWithDuration:1 animations:^{
        loadingView.alpha = 0;
    }];
    //如果从其他界面过来的时候,带有经纬度等信息
    if (self.userLocationDic.count > 0) {
         NSString * province = self.userLocationDic[@"provinceName"];
         NSString * cityNa = self.userLocationDic[@"cityName"];
         NSString * countryName = self.userLocationDic[@"countryName"];
        if (province.length > 0) {
            [provinceButton setTitle:province forState:UIControlStateNormal];
            provinceName = province;
        }
        if (cityNa.length > 0) {
            [cityButton setTitle:cityNa forState:UIControlStateNormal];
            cityName = cityNa;
        }
        
        if (countryName.length > 0) {
            streetTextField.text = countryName;
        }
        
        UIView * loadingView = (UIView *)[topView viewWithTag:TAG_LOADINGVIEW];
        [UIView animateWithDuration:1 animations:^{
            loadingView.alpha = 0;
        }];
        
        if (self.userLocationDic[@"latitude"] != nil && [self.userLocationDic[@"latitude"] floatValue] > 0) {
            MAPointAnnotation * ann = [[MAPointAnnotation alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.userLocationDic[@"latitude"] doubleValue], [self.userLocationDic[@"longitude"] doubleValue]);
            self.currentLocation.coordinate = coordinate;
            ann.coordinate = coordinate;
            ann.title = self.userLocationDic[@"title"];
            annTitle = self.userLocationDic[@"title"];
            isLongPress = YES;
            [self.userLocation setObject:self.userLocationDic[@"latitude"] forKey:@"latitude"];
            [self.userLocation setObject:self.userLocationDic[@"longitude"] forKey:@"longitude"];
            ann.subtitle = [NSString stringWithFormat:@"当前经纬度:{%f,%f}",coordinate.latitude,coordinate.longitude];
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotation:ann];
            [self.mapView setRegion:MACoordinateRegionMake(coordinate, SPAN) animated:YES];
            
            AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
            request.searchType = AMapSearchType_ReGeocode;
            request.requireExtension = YES;
            AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            request.location = point;
            [self.mapSearchAPI AMapReGoecodeSearch:request];
        }
    }
}

- (void)showLeveyListWith:(NSArray *)arr tag:(NSInteger)tag title:(NSString *)title{
    LeveyPopListView * leveyList = [[LeveyPopListView alloc] initWithTitle:[NSString stringWithFormat:@"请选择%@",title] options:arr];
    leveyList.tag = tag;
    leveyList.delegate = self;
    [leveyList showInView:self.view animated:YES];
}

- (void)locationButtonClick{
    [streetTextField endEditing:YES];
    [streetTextField resignFirstResponder];
    if (
            [provinceButton.titleLabel.text isEqualToString:@"省(必填)"] ||
            [cityButton.titleLabel.text isEqualToString:@"市(必填)"] ||
            streetTextField.text.length == 0
        )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入药店所在位置" duration:DURATION_SHORT];
        return;
    }
    
    isLongPress = NO;
    if (textChange) {
        AMapGeocodeSearchRequest * request = [[AMapGeocodeSearchRequest alloc] init];
        request.searchType = AMapSearchType_Geocode;
        request.address = [NSString stringWithFormat:@"%@%@%@",self.userLocation[@"province"],self.userLocation[@"city"],streetTextField.text];
        textChange = NO;
        [self.mapSearchAPI AMapGeocodeSearch:request];
    }else{
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.userLocation[@"latitude"] floatValue], [self.userLocation[@"longitude"] floatValue]);
        [self.mapView setRegion:MACoordinateRegionMake(coord, SPAN) animated:YES];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textChange = YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([provinceButton.titleLabel.text isEqualToString:@"省(必填)"] || [cityButton.titleLabel.text isEqualToString:@"市(必填)"])
    {
        [SVProgressHUD showErrorWithStatus:@"请选择药店所在省市" duration:DURATION_SHORT];
        return;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    fieldText = textField.text;
}

//加载地理位置
- (void)loadProvince{
    [streetTextField resignFirstResponder];
    
    [Map getAreaListWithCode:@"" success:^(id DFModel) {
        QueryAreaListModel *queryModel = (QueryAreaListModel *)DFModel;
        self.provinceArray = [NSMutableArray array];
        [self.provinceArray addObjectsFromArray:queryModel.list];
        NSMutableArray * titleArray = [NSMutableArray array];
        for (AreaListModel *codeModel in self.provinceArray) {
            [titleArray addObject:codeModel.name];
        }
        [self showLeveyListWith:titleArray tag:TAG_PROVINCE title:@"省份"];
        
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
    }];
}

- (void)loadCity{
    [streetTextField resignFirstResponder];
    if ([provinceButton.titleLabel.text isEqualToString:@"省(必填)"] && provinceName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择药店所在省" duration:DURATION_SHORT];
        return;
    }
    //先获得省的编码
    if (provinceName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择药店所在省" duration:DURATION_SHORT];
        return;
    }
    
    GetAreaCodeModelR *codeModelR = [GetAreaCodeModelR new];
    codeModelR.province = provinceName;
    codeModelR.city = @"";
    codeModelR.county = @"";
    
    [Map getAreaCodeWithParam:codeModelR success:^(id DFModel) {
        AreaCodeModel *areaCodeModel = (AreaCodeModel *)DFModel;
        provinceCode = areaCodeModel.provinceCode;
        
        [Map getAreaListWithCode:provinceCode success:^(id DFModel) {
            QueryAreaListModel *cityModel = (QueryAreaListModel *)DFModel;
            self.cityArray = [NSMutableArray array];
            [self.cityArray addObjectsFromArray:cityModel.list];
            NSMutableArray * titleArray = [NSMutableArray array];
            for (AreaListModel *cityModel in self.cityArray) {
                [titleArray addObject:cityModel.name];
            }
            [self showLeveyListWith:titleArray tag:TAG_CITY title:@"城市"];
        } failure:^(HttpException *e) {
            NSLog(@"%@",e);
        }];
        
        
    } failure:^(HttpException *e) {
        NSLog(@"%@",e);
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)longPressToAddAnnotation:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;//如果不设置这个属性,那么长按将会落下多个大头针(设置后,只落下一个)
    }
    CGPoint point = [longPress locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    //NSNumber * latitude = [NSNumber numberWithFloat:coordinate.latitude];
    //NSNumber * longitude = [NSNumber numberWithFloat:coordinate.longitude];
    NSString * latitude = [NSString stringWithFormat:@"%.6f",coordinate.latitude];
    NSString * longitude = [NSString stringWithFormat:@"%.6f",coordinate.longitude];
    isLongPress = YES;
    [self.userLocation setObject:latitude forKey:@"latitude"];
    [self.userLocation setObject:longitude forKey:@"longitude"];
    MAPointAnnotation * ann = [[MAPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    if (self.userLocationDic[@"title"] != nil && [(NSString *)self.userLocationDic[@"title"] length] > 0) {
        ann.title = self.userLocationDic[@"title"];
        annTitle = self.userLocationDic[@"title"];
    }else{
        ann.title = [NSString stringWithFormat:@"当前经纬度:{%f,%f}",coordinate.latitude,coordinate.longitude];
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:ann];
    
    AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc] init];
    request.searchType = AMapSearchType_ReGeocode;
    request.requireExtension = YES;
    AMapGeoPoint * GeoPoint = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.location = GeoPoint;
    [self.mapSearchAPI AMapReGoecodeSearch:request];
    
}

#pragma mark -------定位回调-------
/**
 *  地图将要开始定位是调用
 */
- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView{
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:kWaring46 message:kWaring44 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        self.mapView = nil;
        self.mapView.delegate = nil;
        return;
    }else{
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:kWaring46 message:kWaring45 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            self.mapView = nil;
            self.mapView.delegate = nil;
            return;
        }
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (!self.userLocationDic[@"latitude"] || [self.userLocationDic[@"latitude"] floatValue] <= 0){
        if (!isEqualCoordinate(self.currentLocation.coordinate, userLocation.coordinate, 0.001)) {

            self.currentLocation = userLocation;
            
            [self.mapView setRegion:MACoordinateRegionMake(userLocation.coordinate, SPAN) animated:YES];
            
            
            CGFloat longitude = userLocation.location.coordinate.longitude;
            CGFloat latitude = userLocation.location.coordinate.latitude;
            
            [self.userLocation setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
            [self.userLocation setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
            
            
            MAPointAnnotation * ann = [[MAPointAnnotation alloc] init];
            ann.coordinate = userLocation.coordinate;
            if (self.userLocationDic[@"title"] != nil) {
                ann.title = self.userLocationDic[@"title"];
                annTitle = self.userLocationDic[@"title"];
            }else{
                ann.title = [NSString stringWithFormat:@"当前经纬度:{%f,%f}",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
            }
            
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotation:ann];
            
            
            
            CLLocation * location = userLocation.location;
            AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc] init];
            request.searchType = AMapSearchType_ReGeocode;
            request.requireExtension = YES;
            AMapGeoPoint * point = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            request.location = point;
            [self.mapSearchAPI AMapReGoecodeSearch:request];
        }
    }
    //self.mapView.showsUserLocation = NO;
}
//逆地址解析
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    AMapReGeocode *regeocode = response.regeocode;
    AMapAddressComponent * address = regeocode.addressComponent;
    [self.userLocation setObject:address.streetNumber.location forKey:@"location"];
    
    
    [self.userLocation setObject:address.province forKey:@"province"];
    [self.userLocation setObject:address.city forKey:@"city"];
    [self.userLocation setObject:address.district forKey:@"country"];
    if (address.streetNumber.location.latitude && address.streetNumber.location.longitude) {
        
        CGFloat longitude = address.streetNumber.location.longitude;
        CGFloat latitude = address.streetNumber.location.latitude;
        if(!isLongPress){
            [self.userLocation setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
            [self.userLocation setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        }else{
            isLongPress = NO;
        }
    }
}
//正地址解析
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    NSLog(@"正地理解析 = %@",response);
   
    if (response.geocodes.count == 0){
        return;
    }
    AMapGeocode *geocode = response.geocodes[0];
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        MyAnnotation *geocodeAnnotation = [[MyAnnotation alloc] initWithGeocode:obj];
        [annotations addObject:geocodeAnnotation];
    }];
    
    if (annotations.count == 1){
        [self.mapView setCenterCoordinate:[annotations[0] coordinate] animated:YES];
    }else{
        [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:annotations] animated:YES];
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotations[0]];
    [self.userLocation setObject:[NSString stringWithFormat:@"%f",geocode.location.longitude] forKey:@"longitude"];
    [self.userLocation setObject:[NSString stringWithFormat:@"%f",geocode.location.latitude] forKey:@"latitude"];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CusAnnotationView *annotationView = (CusAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CusAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:customReuseIndetifier];
        }
        
        // must set to NO, so we can show the custom callout view.
        annotationView.canShowCallout   = NO;
        annotationView.calloutOffset    = CGPointMake(0, -5);
        annotationView.annTitle = annTitle;
        [annotationView setSelected:YES animated:YES];
        return annotationView;
    }
    
    return nil;
}

- (void)addMapAnnotation:(AMapGeocodeSearchResponse *)response{
    
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex{
    if (popListView.tag == TAG_PROVINCE) {
        AreaListModel *codeModel  = self.provinceArray[anIndex];
        //市标题和街道
        [cityButton setTitle:@"市(必填)" forState:UIControlStateNormal];
        provinceName = codeModel.name;
        streetTextField.text = @"";
        
        [provinceButton setTitle:provinceName forState:UIControlStateNormal];
        provinceCode = codeModel.code;
        [self.userLocation setObject:provinceName forKey:@"province"];
        [self loadCity];
    }else if (popListView.tag == TAG_CITY){
        AreaListModel *cityModel = self.cityArray[anIndex];
        //路和街道
        streetTextField.text = @"";
        //市标题
        [cityButton setTitle:cityModel.name forState:UIControlStateNormal];
        cityCode = cityModel.code;
        [self.userLocation setObject:cityModel.name forKey:@"city"];
    }else if (popListView.tag == TAG_TEXTFIELD){
        AreaListModel *countryModel = self.countryArray[anIndex];
        streetTextField.text = countryModel.name;
        [self.userLocation setObject:countryModel.name forKey:@"country"];
        [self locationButtonClick];
    }
}

- (void)leveyPopListViewDidCancel{
    
}

- (void)sureButtonClick{

    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (self.ComfromQuick == YES) {
        
        UpdateBranchLatModelR *modelR = [[UpdateBranchLatModelR alloc] init];
        modelR.groupId = QWGLOBALMANAGER.configure.groupId;
        // &&[self.userLocation objectForKey:@"longitude"] &&[self.userLocation objectForKey:@"latitude"]
        if (StrIsEmpty(StrFromObj(self.userLocation[@"longitude"])) || StrIsEmpty(StrFromObj(self.userLocation[@"latitude"]))) {
            [SVProgressHUD showErrorWithStatus:@"请选择药店所在位置" duration:DURATION_SHORT];
            return;
        }else{
            modelR.longitude = self.userLocation[@"longitude"];
            modelR.latitude = self.userLocation[@"latitude"];
        }
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"groupId"] = QWGLOBALMANAGER.configure.groupId;
        
        NSLog(@"the setting is %@",setting);
        
        
        [Map updateBranchLatWithParam:modelR success:^(id responseObj) {
            RegisterModelR *registerModel = [QWUserDefault getModelBy:QUICK_INFO];
            LoginModelR *loginModelR = [[LoginModelR alloc] init];
            loginModelR.deviceCode = DEVICE_IDD;
            loginModelR.account = registerModel.account;
            loginModelR.password = registerModel.password;
            loginModelR.deviceType = @"2";
            loginModelR.pushDeviceCode = [QWGLOBALMANAGER deviceToken];
            loginModelR.credentials=[AESUtil encryptAESData:registerModel.password app_key:AES_KEY];
            QWGLOBALMANAGER.configure.userName = registerModel.account;
            QWGLOBALMANAGER.configure.passWord = registerModel.password;
            [Store loginWithParam:loginModelR success:^(id obj) {
#pragma mark -------这个地方有问题，解决（CAOJING）-------
                [QWUserDefault setObject:@"1" key:@"ENTRANCETYPE"];
                StoreUserInfoModel *model = (StoreUserInfoModel *)obj;
                
                if ([model.apiStatus integerValue] == 0) {
                    
                    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                    setting[@"token"] = StrFromObj(model.token);
                    [Circle InitByBranchWithParams:setting success:^(id obj) {
                        CheckStoreStatuModel *mod = [CheckStoreStatuModel parse:obj];
                        if ([mod.apiStatus integerValue] == 0) {
                            if (mod.type) {
                                QWGLOBALMANAGER.configure.storeType = mod.type;
                                QWGLOBALMANAGER.configure.storeCity = mod.city;
                                QWGLOBALMANAGER.configure.shortName = mod.branchName;
                                [QWGLOBALMANAGER saveAppConfigure];
                            }
                        }else{
                            QWGLOBALMANAGER.configure.storeType = 1;
                            [QWGLOBALMANAGER saveAppConfigure];
                        }
                        [self saveLoginUserInfo:model];
                    } failure:^(HttpException *e) {
                        QWGLOBALMANAGER.configure.storeType = 1;
                        [QWGLOBALMANAGER saveAppConfigure];
                        [self saveLoginUserInfo:model];
                    }];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:model.apiMessage];
                }
                
            } failure:^(HttpException *e) {
                NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
            }];
            
            
        } failure:^(HttpException *e) {
            NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
        }];
    }else{
        if ([self.delegate respondsToSelector:@selector(pickUserLocation:)]) {
            [self.delegate pickUserLocation:self.userLocation];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveLoginUserInfo:(StoreUserInfoModel *)model
{
    RegisterModelR *registerModel = [QWUserDefault getModelBy:QUICK_INFO];
    NSString *str = model.token;
    if (!StrIsEmpty(str)) {
        QWGLOBALMANAGER.configure.userToken = model.token;
        QWGLOBALMANAGER.configure.passportId = model.passport;
        QWGLOBALMANAGER.configure.groupId = model.branchId;
        QWGLOBALMANAGER.configure.userName = registerModel.account;
        QWGLOBALMANAGER.configure.type = [NSString stringWithFormat:@"%@",model.type];
        QWGLOBALMANAGER.configure.showName = model.name;
        QWGLOBALMANAGER.configure.mobile = model.mobile;

        /*
         1, 待审核  资料已提交页面
         2, 审核不通过  带入老数据的认证流程
         3, 审核通过    功能正常
         4, 未提交审核  认证流程
         */
        QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",model.approveStatus];
        
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 3) {
            // 认证通过后，清除缓存
            [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
            [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
        }
        
        NSString *nickName = model.branchName;
        if(nickName && ![nickName isEqual:[NSNull null]]){
            QWGLOBALMANAGER.configure.nickName = nickName;
        }else{
            QWGLOBALMANAGER.configure.nickName = @"";
        }
        NSString *avatarUrl = model.branchImgUrl;
        if(avatarUrl && ![avatarUrl isEqual:[NSNull null]]){
            QWGLOBALMANAGER.configure.avatarUrl = avatarUrl;
        }else{
            QWGLOBALMANAGER.configure.avatarUrl = @"";
        }
        
        QWGLOBALMANAGER.loginStatus = YES;
        [QWGLOBALMANAGER saveAppConfigure];
        
        [QWUserDefault setBool:YES key:APP_LOGIN_STATUS];
        
        [QWGLOBALMANAGER saveOperateLog:@"1"];
        [QWGLOBALMANAGER saveOperateLog:@"2"];
        
        //通知登录成功
        [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:model object:self];
        [QWGLOBALMANAGER loginSucess];
        
        //聊天登录
        
        
        if(QWGLOBALMANAGER.tabBar){
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            
            AppDelegate *apppp = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [apppp initTabBar];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


@interface MyAnnotation ()

@end

@implementation MyAnnotation



@synthesize geocode = _geocode;

#pragma mark - MAAnnotation Protocol

- (NSString *)title{
    return self.geocode.formattedAddress;
}

- (NSString *)subtitle{
    return [self.geocode.location description];
}

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.geocode.location.latitude, self.geocode.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithGeocode:(AMapGeocode *)geocode{
    if (self = [super init]){
        self.geocode = geocode;
    }
    return self;
}

@end


@implementation MyAnnotationView

#pragma mark - Override


#pragma mark - Life Cycle

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:YES];
}


- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        UIImage * redImage = [UIImage imageNamed:@"point_red.png"];
        self.iconView = [[UIImageView alloc] initWithFrame:RECT(0, 0, redImage.size.width*2, redImage.size.height*2)];
        self.iconView.userInteractionEnabled = YES;
        [self.iconView setImage:redImage];
        [self addSubview:self.iconView];
        
        /* Create portrait image view and add to view hierarchy. */
        
        /* Create name label. */
    }
    
    return self;
}


@end

