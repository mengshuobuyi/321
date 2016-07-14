//
//  EditAddressViewController.m
//  wenYao-store
//  添加地址&编辑地址
//  编辑地址接口 EditRecieveAddress
//  删除地址接口 RemoveRecieveAddress
//  Created by qw_imac on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EditAddressViewController.h"
#import "EditAddressTableViewCell.h"
#import "DeleteAddressTableViewCell.h"
#import "MyTableViewCell.h"
#import "ChooseProvinceAndCityView.h"
#import "Branch.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
@implementation SetCellModel

@end

@interface EditAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray              *sourceArray;
    ChooseProvinceAndCityView   *chooseView;
    NSString                    *selectedProvince;
    NSString                    *selectedCity;
    NSString                    *selectedProvinceName;
    NSString                    *selectedCityName;
    NSString                    *tempSelectedProvince;
    NSString                    *tempSelectedCity;
    NSString                    *tempSelectedProvinceName;
    NSString                    *tempSelectedCityName;
    SetCellModel                *editModel;
    SetCellModel                *deleteModel;
    EmpAddressVo                *tempVo;
}
@property (strong, nonatomic) IBOutlet UIView       *headerAlert;
@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray         *provinceArray;
@property (nonatomic,strong) NSMutableArray         *cityArray;
@end

@implementation EditAddressViewController
static NSString *const editCellIdentifier = @"EditAddressTableViewCell";
static NSString *const deleteCellIdentifier = @"DeleteAddressTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewInit];
    _provinceArray = [@[] mutableCopy];
    _cityArray = [@[] mutableCopy];
    tempVo = [[EmpAddressVo alloc]init];
    if (_pageType == AddressPageTypeEdit) {
        [self recoverVo];
    }
    //根据屏幕和弹出键盘适当滑动
    [self registerLJWKeyboardHandler];
    [self dataSourceInit];
    [self setNaviItem];
    [self loadProvinceList];
}

-(void)recoverVo {
    selectedCity = _EmpAddressModel.receiverCity;
    selectedCityName = _EmpAddressModel.receiverCityName;
    selectedProvince = _EmpAddressModel.receiverProvince;
    selectedProvinceName = _EmpAddressModel.receiverProvinceName;
    tempVo = _EmpAddressModel;
}
//cellModel
-(void)dataSourceInit {
    editModel = [SetCellModel new];
    editModel.cellIdentifier = editCellIdentifier;
    sourceArray = [@[editModel] mutableCopy];
    if (_pageType == AddressPageTypeAdd) {
        self.title = @"添加地址";
    }else {
        self.title = @"修改地址";
        editModel.dataModel = _EmpAddressModel;
        deleteModel = [SetCellModel new];
        deleteModel.cellIdentifier = deleteCellIdentifier;
        [sourceArray addObject:deleteModel];
    }
}
//注册cell
-(void)tableViewInit {
    [_tableView registerNib:[UINib nibWithNibName:@"EditAddressTableViewCell" bundle:nil] forCellReuseIdentifier:editCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"DeleteAddressTableViewCell" bundle:nil] forCellReuseIdentifier:deleteCellIdentifier];
    _tableView.tableHeaderView = _headerAlert;
}
//set右上角navi按钮
-(void)setNaviItem {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 28)];
    btn.titleLabel.font = fontSystem(kFontS1);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = naviBtn;
}
//编辑地址校验
-(void)save {
    [self.view endEditing:YES];
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试"];
        return;
    }
    EditAddressTableViewCell *cell = (EditAddressTableViewCell *)[self.view viewWithTag:101];
//    if (StrIsEmpty(cell.receiver.text)) {
//        [SVProgressHUD showErrorWithStatus:@"请填写联系人"];
//        return;
//    }
//    if (StrIsEmpty(cell.tel.text)) {
//        [SVProgressHUD showErrorWithStatus:@"请填写手机号码"];
//        return;
//    }
//    if (cell.tel.text.length != 11) {
//        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
//        return;
//    }
//    if (StrIsEmpty(cell.cityName.text)) {
//        [SVProgressHUD showErrorWithStatus:@"请填写所在省市"];
//        return;
//    }
//    if (StrIsEmpty(cell.formatAddress.text)) {
//        [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
//        return;
//    }
    if (StrIsEmpty(tempVo.receiver)) {
        [SVProgressHUD showErrorWithStatus:@"请填写联系人"];
        return;
    }
    if (StrIsEmpty(tempVo.receiverTel)) {
        [SVProgressHUD showErrorWithStatus:@"请填写手机号码"];
        return;
    }
    if (tempVo.receiverTel.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    if (StrIsEmpty(selectedProvinceName) || StrIsEmpty(selectedCityName)) {
        [SVProgressHUD showErrorWithStatus:@"请填写所在省市"];
        return;
    }
    if (StrIsEmpty(tempVo.receiverAddr)) {
        [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
        return;
    }
    RecieveAddressEditR *modelR = [RecieveAddressEditR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken?QWGLOBALMANAGER.configure.userToken:@"";
    modelR.receiver = tempVo.receiver;
    modelR.receiverTel = tempVo.receiverTel;
    modelR.receiverProvince = selectedProvince;
    modelR.receiverCity = selectedCity;
    modelR.receiverAddr = tempVo.receiverAddr;
    if (cell.wBtn.isSelected) {
        modelR.receiverGender = @"F";
    }
    if (cell.mBtn.isSelected) {
        modelR.receiverGender = @"M";
    }
    if (_pageType == AddressPageTypeEdit) {
        modelR.addressId = _EmpAddressModel.id;
        modelR.receiverLng = _EmpAddressModel.receiverLng;
        modelR.receiverLat = _EmpAddressModel.receiverLat;
        modelR.receiverDist = _EmpAddressModel.receiverDist;
        modelR.receiverVillage = _EmpAddressModel.receiverVillage;
        modelR.falgDefault = _EmpAddressModel.falgDefault;
    }
    [self _save:modelR];
}
//编辑地址operation
-(void)_save:(RecieveAddressEditR *)modelR {
    [Address editAddress:modelR success:^(EmpAddressVo *responseModel) {
        if (responseModel.apiStatus.integerValue == 0) {
            if (_pageFrom == 1) {
                if (self.addressBlock) {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"lat"] = responseModel.receiverLat;
                    params[@"lng"] = responseModel.receiverLng;
                    params[@"address"] = responseModel.receiverAddr;
                    params[@"cityName"] = responseModel.receiverCityName;
                    params[@"countyName"] = responseModel.receiverDist;
                    params[@"nick"] = responseModel.receiver;
                    params[@"mobile"] = responseModel.receiverTel;
                    params[@"sex"] = responseModel.receiverGender;
                    params[@"village"] = responseModel.receiverVillage;
                    params[@"provinceName"] = responseModel.receiverProvinceName;
                    params[@"id"] = responseModel.id;
                    NSString *jsonString = nil;
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
                    if([jsonData length] > 0 && error == nil) {
                        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                        self.addressBlock(jsonString);
                    }
                }
            }
            [self popVCAction:nil];
        }else {
            [SVProgressHUD showErrorWithStatus:responseModel.apiMessage duration:0.8];
        }
    } failure:^(HttpException *e) {
        
    }];
}

//删除地址
-(void)deleteAddress {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您确定要删除收货地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self _deleteAddress];
    }
}

-(void)_deleteAddress {
    RemoveRecieveAddressR *modelR = [RemoveRecieveAddressR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken?QWGLOBALMANAGER.configure.userToken:@"";
    modelR.addressId = _EmpAddressModel.id;
    [Address removeAddress:modelR success:^(RemoveAddressVo *responseModel) {
        if (responseModel.apiStatus.integerValue == 0) {
            [self popVCAction:nil];
        }else {
            [SVProgressHUD showErrorWithStatus:responseModel.apiMessage duration:0.8];
        }
    } failure:^(HttpException *e) {
        
    }];
}

-(void)dealloc {
    DebugLog(@"the vc will dealloc");
}
//选择省市
-(void)chooseCity:(UIButton *)sender {
    [self.view endEditing:YES];
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试"];
        return;
    }
    if (!chooseView) {
        chooseView = [[NSBundle mainBundle]loadNibNamed:@"ChooseProvinceAndCityView" owner:nil options:nil][0];
        chooseView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        chooseView.provincePicker.delegate = self;
        [chooseView.confirmBtn addTarget:self action:@selector(chooseCityDone) forControlEvents:UIControlEventTouchUpInside];
        [chooseView.cancelBtn addTarget:self action:@selector(cancelChoose) forControlEvents:UIControlEventTouchUpInside];
    }
    chooseView.bkView.alpha = 0.0;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:chooseView];
    [UIView animateWithDuration:0.25 animations:^{
        chooseView.bkView.alpha = 0.4;
        chooseView.pickView.hidden = NO;
    }];
}

-(void)chooseCityDone {
    [chooseView disMiss];
    selectedCity = tempSelectedCity;
    selectedCityName = tempSelectedCityName;
    selectedProvince = tempSelectedProvince;
    selectedProvinceName = tempSelectedProvinceName;
    EditAddressTableViewCell *cell = (EditAddressTableViewCell *)[self.view viewWithTag:101];
    cell.cityName.text = [NSString stringWithFormat:@"%@%@",selectedProvinceName,selectedCityName];
}

-(void)cancelChoose {
    [chooseView disMiss];
}
#pragma mark - tableView 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sourceArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetCellModel *model = sourceArray[indexPath.section];
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([model.cellIdentifier isEqualToString:editCellIdentifier]) {
        cell.tag = 101;
    }
    [cell setCell:model];
    [cell setDelegate:self];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetCellModel *model = sourceArray[indexPath.section];
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellIdentifier];
    CGFloat height = [cell getCellHeight];
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SetCellModel *model = sourceArray[indexPath.section];
    if([model.cellIdentifier isEqualToString:deleteCellIdentifier]) {
        [self deleteAddress];
    }
}

#pragma mark - uitextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
     EditAddressTableViewCell *cell = (EditAddressTableViewCell *)[self.view viewWithTag:101];
    if (textField == cell.receiver) {
        [cell.tel becomeFirstResponder];
        return YES;
    }else if (textField == cell.tel){
        
        return YES;
    }else {
        [self.view endEditing:YES];
        return YES;
    }
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    EditAddressTableViewCell *cell = (EditAddressTableViewCell *)[self.view viewWithTag:101];
    if (textField == cell.receiver) {
        tempVo.receiver = textField.text;
    }else if (textField == cell.tel){
        tempVo.receiverTel = textField.text;
    }else {
        tempVo.receiverAddr = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    EditAddressTableViewCell *cell = (EditAddressTableViewCell *)[self.view viewWithTag:101];
    DebugLog(@"%@",string);
    if (textField != cell.tel) {
        return YES;
    }else {
        if (range.location < 11) {
            NSString *number = @"^[0-9]*$";
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
            if ([regextestmobile evaluateWithObject:string] == YES) {
                return YES;
            }else {
                [SVProgressHUD showErrorWithStatus:@"请输入数字！"];
                [cell.tel becomeFirstResponder];
                return NO;
            }
        }else {
            [SVProgressHUD showErrorWithStatus:@"只可输入11位手机号！"];
            [cell.formatAddress becomeFirstResponder];
            return NO;
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - pickerDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray.count;
    }else {
        return _cityArray.count;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        ProvinceAndCityModel *model = _provinceArray[row];
        return model.name;
    }else {
        ProvinceAndCityModel *model = _cityArray[row];
        return model.name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        ProvinceAndCityModel *model = _provinceArray[row];
        tempSelectedProvince = model.code;
        tempSelectedProvinceName = model.name;
        [self loadCityList:model.code];
    }else {
        ProvinceAndCityModel *model = _cityArray[row];
        tempSelectedCityName = model.name;
        tempSelectedCity = model.code;
    }
}
#pragma mark ---- 获取省列表 ----

- (void)loadProvinceList
{
    [Branch BranchInfoQueryAreaWithParams:nil success:^(id obj) {
        
        NSArray *arr = (NSArray *)obj;
        [self.provinceArray addObjectsFromArray:arr];
        [chooseView.provincePicker reloadComponent:0];
        
        ProvinceAndCityModel *model = self.provinceArray[0];
        tempSelectedProvince = model.code;
        tempSelectedProvinceName = model.name;
        [self loadCityList:model.code];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 获取市列表 ----

- (void)loadCityList:(NSString *)code
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"code"] = StrFromObj(code);
    [Branch BranchInfoQueryAreaWithParams:setting success:^(id obj) {
        
        NSArray *arr = (NSArray *)obj;
        [self.cityArray removeAllObjects];
        [self.cityArray addObjectsFromArray:arr];
        ProvinceAndCityModel *model = self.cityArray[0];
        tempSelectedCity = model.code;
        tempSelectedCityName = model.name;
        [chooseView.provincePicker reloadComponent:1];
    } failure:^(HttpException *e) {
        
    }];
}
@end
