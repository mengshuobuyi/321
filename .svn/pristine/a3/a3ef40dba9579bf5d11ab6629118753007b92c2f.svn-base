//
//  OrganLocationViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganLocationViewController.h"
#import "OrganLocationCell.h"
#import "NSString+Addition.h"
#import "PoisModel.h"
#import "Branch.h"
#import "BranchModel.h"
#import "LeveyPopListView.h"
#import "MapModelR.h"
#import "Map.h"
#import "MapModel.h"
#import "CustomProvinceView.h"
#import "CLLocation+YCLocation.h"


@interface OrganLocationViewController ()<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,AMapSearchDelegate,CustomProvinceViewDelegaet,CLLocationManagerDelegate>
{
    BOOL mapIsMove;   // 判断地图是否移动过

    BOOL selectedCellType;  // 点击列表
}
@property (weak, nonatomic) IBOutlet UIView *mapBgView;

@property (weak, nonatomic) IBOutlet UIImageView *markImage;

// 重新定位按钮
@property (weak, nonatomic) IBOutlet UIButton *againLocationButton;

// 省
@property (weak, nonatomic) IBOutlet UIButton *provinceButton;

// 市
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

// 区
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;

// 重回地位位置
- (IBAction)againLocation:(id)sender;

// 弹出省列表
- (IBAction)popProvinceAction:(id)sender;

// 弹出市列表
- (IBAction)popCityAction:(id)sender;

// 根据省市区定位
- (IBAction)locationByProvinceAndCity:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MAMapView                 *mapView;

@property (strong, nonatomic) AMapSearchAPI             *mapSearch;

@property (assign, nonatomic) CLLocationCoordinate2D    userCLLocation;

@property (strong, nonatomic) NSMutableArray            *pois;

@property (strong, nonatomic) NSMutableArray            *provinceArray;

@property (strong, nonatomic) NSMutableArray            *cityArray;

@property (strong, nonatomic) NSString *provinceCode;

@property (strong, nonatomic) CustomProvinceView *customProvinceView;

@property (weak, nonatomic) IBOutlet UIView *topView;

// 重新定位，获取当前位置的经纬度
@property (strong, nonatomic) CLLocationManager *locManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *provinceWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *streetWidthConstraint;

@end

@implementation OrganLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"标注机构地理位置";
    
    mapIsMove = NO;
    
    selectedCellType = NO;
    
    self.pois =   [[NSMutableArray alloc ] init];
    self.provinceArray = [NSMutableArray array];
    self.cityArray = [NSMutableArray array];
    
    // 设置地图
    [self ConfigureMapView];
    self.mapSearch = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
    //  改变输入框 placeHolder 颜色
    [self.streetTextField setValue:RGBHex(0xaaaaaa) forKeyPath:@"_placeholderLabel.textColor"];
    
    // 右侧确认按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction)];
    
    // 改变 选择省、市、街道 约束
    self.provinceWidthConstraint.constant = 80+(SCREEN_W-320)/4;
    self.cityWidthConstraint.constant = 80+(SCREEN_W-320)/4;
    self.streetWidthConstraint.constant = 95+(SCREEN_W-320)/4;
    
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.provinceButton setTitle:@"选择省" forState:UIControlStateNormal];
    [self.cityButton setTitle:@"选择市" forState:UIControlStateNormal];
    self.streetTextField.placeholder = @"街道门牌号";
    
    [self configureBottomText];
}

#pragma mark ---- 准确标注地理位置，客户会更快找到你哦～ ----

- (void)configureBottomText
{
    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_H-130, APP_W-40, 40)];
    infoLabel.backgroundColor = RGBHex(qwColor1);
    infoLabel.text = Kwarning220N76;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = fontSystem(14);
    infoLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:infoLabel];
    [self.tableView bringSubviewToFront:infoLabel];
    
    [UIView animateWithDuration:1.0f delay:2.0f options:0 animations:^{
        infoLabel.alpha = 0;
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeFromSuperview];
}

#pragma mark ---- 确认 ----

- (void)confirmAction
{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后重试!" duration:0.8];
        return;
    }
    
    if (self.pois.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择地理位置！" duration:0.8];
        return;
    }
    
    PoisModel *model = self.pois[0];
    NSMutableDictionary *other = [NSMutableDictionary dictionary];
    other[@"province"] = StrFromObj(model.provinceName);
    other[@"city"] = StrFromObj(model.cityName);
    other[@"county"] = StrFromObj(model.countyName);
    
    if (self.organLocationViewControllerDelegate && [self.organLocationViewControllerDelegate respondsToSelector:@selector(passLocationValue:longitude:otherInfo:)]) {
        [self.organLocationViewControllerDelegate passLocationValue:model.latitude longitude:model.longitude otherInfo:other];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 设置地图 ----

- (void)ConfigureMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.mapBgView.frame.size.width, 238)];
    [self.mapBgView addSubview:self.mapView];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardDown)];
    [self.view addGestureRecognizer:tap];
    [self.mapView addGestureRecognizer:tap];
    
    [self.mapBgView bringSubviewToFront:self.againLocationButton];
    [self.mapBgView bringSubviewToFront:self.markImage];
    [self.mapBgView bringSubviewToFront:self.topView];
}

- (void)keyBoardDown
{
    [self.view endEditing:YES];
}

/*!
 @brief 地图区域即将改变时会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self.streetTextField resignFirstResponder];
    if (self.userCLLocation.latitude && self.userCLLocation.longitude) {
        mapIsMove = YES;
    }
}

/*!
 @brief 地图区域改变完成后会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.userCLLocation.latitude && self.userCLLocation.longitude && mapIsMove) {
        
        CGPoint markPoint = CGPointMake(APP_W/2, 119);
        CLLocationCoordinate2D location = [self.mapView convertPoint:markPoint toCoordinateFromView:self.mapView];
        
        // 如果点击过cell，不需调用此方法
        if (selectedCellType) {
            return;
        }
        [self searchReGeocodeWithCoordinate:location];
        [self searchPoiByCenterCoordinate:location];
    }
}

/*!
 @brief 位置或者设备方向更新后，会调用此函数
 @param mapView 地图View
 @param userLocation 用户定位信息(包括位置与设备方向等数据)
 @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (self.userCLLocation.latitude && self.userCLLocation.longitude)
        return;
    MACoordinateSpan macoordinateSpan;
    macoordinateSpan.latitudeDelta = 0.02;
    macoordinateSpan.longitudeDelta= 0.02;
    MACoordinateRegion macoordinateRegion = MACoordinateRegionMake(userLocation.location.coordinate, macoordinateSpan);
    [self.mapView setRegion:macoordinateRegion animated:YES];
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    self.userCLLocation = userLocation.location.coordinate;
    [self searchReGeocodeWithCoordinate:userLocation.location.coordinate];
    [self searchPoiByCenterCoordinate:userLocation.location.coordinate];
    
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    [self.mapSearch AMapReGoecodeSearch:regeo];
}

#pragma mark ---- 根据中心点坐标来搜周边的POI ----

- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType          = AMapSearchType_PlaceAround;
    request.location            = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords            = @"汽车服务|汽车销售|汽车维修|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|公共设施";
    /* 按照距离排序. */
    request.sortrule            = 1;
    request.requireExtension    = YES;
    [self.mapSearch AMapPlaceSearch:request];
}

/*!
 @brief POI查询回调函数 搜索附近热点
 @param request 发起查询的查询选项(具体字段参考AMapPlaceSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapPlaceSearchResponse类中的定义)
 */

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    __weak OrganLocationViewController *weakSelf = self;
    
    if (weakSelf.pois.count > 0) {
        
        PoisModel *mod = weakSelf.pois[0];
        [respons.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            if (![obj.address isEmptyOrWhitespace] && ![obj.name isEmptyOrWhitespace]) {
                PoisModel *poisModel = [[PoisModel alloc ] init];
                poisModel.name = obj.name;
                poisModel.address=obj.address;
                poisModel.latitude = obj.location.latitude;
                poisModel.longitude = obj.location.longitude;
                poisModel.provinceName = obj.province;
                poisModel.cityName = obj.city;
                poisModel.countyName = obj.district;
                
                // 点击列表的时候 去重
                if (![poisModel.name isEqualToString:mod.name] && ![poisModel.address isEqualToString:mod.address]) {
                    [weakSelf.pois addObject:poisModel];
                }else{
                    
                }
            }
        }];
    }
    
    
    if (self.pois.count > 0) {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else{
        self.tableView.hidden = YES;
    }
}


#pragma mark - AMapSearchDelegate
/* 逆地理编码回调. 获取街道信息 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    __weak OrganLocationViewController *weakSelf = self;
    if (response.regeocode != nil)
    {
        
        if (!mapIsMove)
        {
            // 未手动移动地图，刚开始定位
            
            [weakSelf.pois removeAllObjects];
            PoisModel *poisModel = [[PoisModel alloc ] init];
            
            NSString *street = response.regeocode.addressComponent.streetNumber.street;
            if (!street ||[street isEqualToString:@""]) {
                street = response.regeocode.addressComponent.township;
            }
            poisModel.name = [NSString stringWithFormat:@"%@%@",response.regeocode.addressComponent.district,street];
            poisModel.latitude = request.location.latitude;
            poisModel.longitude = request.location.longitude;
            poisModel.provinceName = response.regeocode.addressComponent.province;
            poisModel.cityName = response.regeocode.addressComponent.city;
            poisModel.countyName = response.regeocode.addressComponent.district;
            [weakSelf.pois insertObject:poisModel atIndex:0];
        }else if (mapIsMove && selectedCellType)
        {
            // 点击列表
            
            selectedCellType = NO;
        }else
        {
            // 手动移动地图
            
            [weakSelf.pois removeAllObjects];
            PoisModel *poisModel = [[PoisModel alloc ] init];
            
            NSString *street = response.regeocode.addressComponent.streetNumber.street;
            if (!street ||[street isEqualToString:@""]) {
                street = response.regeocode.addressComponent.township;
            }
            poisModel.name = [NSString stringWithFormat:@"%@%@",response.regeocode.addressComponent.district,street];
            poisModel.latitude = request.location.latitude;
            poisModel.longitude = request.location.longitude;
            poisModel.provinceName = response.regeocode.addressComponent.province;
            poisModel.cityName = response.regeocode.addressComponent.city;
            poisModel.countyName = response.regeocode.addressComponent.district;
            [weakSelf.pois insertObject:poisModel atIndex:0];
        }
        
    }
    [self.tableView reloadData];
}


#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrganLocationCell"];
    
    PoisModel *model = self.pois[indexPath.row];
    [cell configureData:model];
    
    if (indexPath.row == 0) {
        cell.addressTitle.textColor = RGBHex(qwColor1);
        cell.addressDetail.textColor = RGBHex(qwColor1);
        cell.addressImage.image = [UIImage imageNamed:@"icon_location_green"];
    }else{
        cell.addressTitle.textColor = RGBHex(0x333333);
        cell.addressDetail.textColor = RGBHex(0x999999);
        cell.addressImage.image = [UIImage imageNamed:@"icon_location_grey"];
    }
    
    // 第一行 改变约束
    
    if (self.pois.count > 0) {
        PoisModel *mod1 = self.pois[0];
        if (indexPath.row == 0 && ( !mod1.address || [mod1.address isEqualToString:@""])) {
            cell.addressTitleTopConstraint.constant = 17;
        }else{
            cell.addressTitleTopConstraint.constant = 8;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PoisModel *model = self.pois[indexPath.row];
    
    selectedCellType = YES;
    
    [self.pois removeAllObjects];
    
    [self.pois addObject:model];
    
    CLLocationCoordinate2D location ;
    location.latitude = model.latitude;
    location.longitude = model.longitude;
    
    self.mapView.centerCoordinate = location;
    [self searchReGeocodeWithCoordinate:location];
    [self searchPoiByCenterCoordinate:location];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

#pragma mark ---- 重新定位 ----

- (IBAction)againLocation:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后重试！" duration:0.8];
        return;
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无法进行定位操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.locManager startUpdatingLocation];
}

#pragma mark ---- 重新定位的代理 ----

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    location = [location locationMarsFromEarth];
    self.mapView.centerCoordinate = location.coordinate;
    [self searchReGeocodeWithCoordinate:location.coordinate];
    [self searchPoiByCenterCoordinate:location.coordinate];
    self.locManager.delegate = nil;
}

#pragma mark ---- 弹出省列表 ----

- (IBAction)popProvinceAction:(id)sender
{
    [self.streetTextField resignFirstResponder];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后重试 ！" duration:0.8];
        return;
    }
    
    [Branch BranchInfoQueryAreaWithParams:nil success:^(id obj) {
        
        NSArray *arr = (NSArray *)obj;
        [self.provinceArray addObjectsFromArray:arr];
        self.customProvinceView = [CustomProvinceView sharedManagerWithDataList:self.provinceArray type:1];
        self.customProvinceView.delegate = self;
        [self.customProvinceView show];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 弹出市列表 ----

- (IBAction)popCityAction:(id)sender
{
    [self.streetTextField resignFirstResponder];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后重试 ！" duration:0.8];
        return;
    }
    
    //先获得省的编码
    if (self.provinceButton.titleLabel.text.length == 0 || [self.provinceButton.titleLabel.text isEqualToString:@"选择省"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择药店所在省" duration:DURATION_SHORT];
        return;
    }
    
    GetAreaCodeModelR *codeModelR = [GetAreaCodeModelR new];
    codeModelR.province = self.provinceButton.titleLabel.text;
    codeModelR.city = @"";
    codeModelR.county = @"";
    
    [Map getAreaCodeWithParam:codeModelR success:^(id DFModel) {
        AreaCodeModel *areaCodeModel = (AreaCodeModel *)DFModel;
        self.provinceCode = areaCodeModel.provinceCode;
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"code"] = StrFromObj(self.provinceCode);
        [Branch BranchInfoQueryAreaWithParams:setting success:^(id obj) {
            
            NSArray *arr = (NSArray *)obj;
            [self.cityArray removeAllObjects];
            [self.cityArray addObjectsFromArray:arr];
            self.customProvinceView = [CustomProvinceView sharedManagerWithDataList:self.cityArray type:2];
            self.customProvinceView.delegate = self;
            [self.customProvinceView show];
            
        } failure:^(HttpException *e) {
            
        }];
        
        
    } failure:^(HttpException *e) {
        
    }];
 
}

#pragma mark ---- 获取省市代理 ----

- (void)getSelectedProvinceOrCity:(NSString *)str code:(NSString *)code type:(int)type;
{
    if (type == 1) {
        [self.provinceButton setTitle:str forState:UIControlStateNormal];
        self.provinceCode = code;
        
        [self.streetTextField resignFirstResponder];
        
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后重试 ！" duration:0.8];
            return;
        }
        
        //先获得省的编码
        if (self.provinceButton.titleLabel.text.length == 0 || [self.provinceButton.titleLabel.text isEqualToString:@"选择省"]) {
            [SVProgressHUD showErrorWithStatus:@"请选择药店所在省" duration:DURATION_SHORT];
            return;
        }
        
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"code"] = StrFromObj(self.provinceCode);
        [Branch BranchInfoQueryAreaWithParams:setting success:^(id obj) {
            
            NSArray *arr = (NSArray *)obj;
            [self.cityArray removeAllObjects];
            [self.cityArray addObjectsFromArray:arr];
            self.customProvinceView = [CustomProvinceView sharedManagerWithDataList:self.cityArray type:2];
            self.customProvinceView.delegate = self;
            [self.customProvinceView show];
            
        } failure:^(HttpException *e) {
            
        }];

        
        
    }else if (type == 2){
        [self.cityButton setTitle:str forState:UIControlStateNormal];
    }
}


#pragma mark ---- 根据省市区定位 ----

- (IBAction)locationByProvinceAndCity:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍候重试！" duration:0.8];
        return;
    }
    
    if (self.provinceButton.titleLabel.text.length==0 || [self.provinceButton.titleLabel.text isEqualToString:@"选择省"] || self.cityButton.titleLabel.text.length==0 || [self.cityButton.titleLabel.text isEqualToString:@"选择市"] || self.streetTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N77 duration:0.8];
        return;
    }
    
    // 根据省市名 获取经纬度
    
    NSString *oreillyAddress = [NSString stringWithFormat:@"%@%@%@",self.provinceButton.titleLabel.text,self.cityButton.titleLabel.text,self.streetTextField.text];
    
    AMapGeocodeSearchRequest * request = [[AMapGeocodeSearchRequest alloc] init];
    request.searchType = AMapSearchType_Geocode;
    request.address = oreillyAddress;
    [self.mapSearch AMapGeocodeSearch:request];
    
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    if (response.geocodes.count == 0){
        return;
    }
    AMapGeocode *geocode = response.geocodes[0];
    
    CLLocationCoordinate2D location ;
    location.latitude = geocode.location.latitude;
    location.longitude = geocode.location.longitude;
    
    self.mapView.centerCoordinate = location;
    [self searchReGeocodeWithCoordinate:location];
    [self searchPoiByCenterCoordinate:location];
}

@end
