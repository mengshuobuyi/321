//
//  CustomCityView.m
//  wenYao-store
//
//  Created by YYX on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CustomCityView.h"
#import "AppDelegate.h"
#import "Branch.h"
#import "BranchModel.h"

@implementation CustomCityView

{
    UIWindow *window;
}

+ (CustomCityView *)sharedManager
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"CustomCityView" owner:self options:nil];
        self = array[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        self.provinceArray = [NSMutableArray array];
        self.cityArray = [NSMutableArray array];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        [self loadProvinceList];
    }
    return self;
}

#pragma mark ---- 获取省列表 ----

- (void)loadProvinceList
{
    [Branch BranchInfoQueryAreaWithParams:nil success:^(id obj) {
        
        NSArray *arr = (NSArray *)obj;
        [self.provinceArray addObjectsFromArray:arr];
        [self.pickerView reloadComponent:0];
        
        ProvinceAndCityModel *model = self.provinceArray[0];
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
        [self.pickerView reloadComponent:1];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- UIPickerView Delegate ----

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    }else{
        return self.cityArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        if (self.provinceArray.count > 0) {
            ProvinceAndCityModel *model = self.provinceArray[row];
            return model.name;
        }else{
            return @"";
        }
        
    }else{
        if (self.cityArray.count > 0) {
            ProvinceAndCityModel *model = self.cityArray[row];
            return model.name;
        }else{
            return @"";
        }
        
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        ProvinceAndCityModel *model = self.provinceArray[row];
        [self loadCityList:model.code];
        
        [self.pickerView reloadComponent:1];
        
    }
    else {
        
    }
}

- (void)dismiss
{
    [self hidden];
}

-(void)show
{
    self.bgView.alpha = 0;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    self.bg.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.bg.frame.size.height);
    __weak CustomCityView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.alpha = 0.4;
        weakSelf.bg.frame = CGRectMake(0, SCREEN_H - self.bg.frame.size.height, SCREEN_W, self.bg.frame.size.height);
    }];
}

-(void)hidden
{
    __weak CustomCityView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bg.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.bg.frame.size.height);
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark ---- 确定 ----

- (IBAction)makeSureAction:(id)sender
{
    [self hidden];
    NSInteger selectedProvinceIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger selectedCityIndex = [self.pickerView selectedRowInComponent:1];
    
    ProvinceAndCityModel *province = self.provinceArray[selectedProvinceIndex];
    ProvinceAndCityModel *city = self.cityArray[selectedCityIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getProvinceAndCityAction:provinceCode:cityCode:)]) {
        [self.delegate getProvinceAndCityAction:[NSString stringWithFormat:@"%@%@",province.name,city.name] provinceCode:province.code cityCode:city.code];
    }
}

#pragma mark ---- 取消 ----

- (IBAction)cancelAction:(id)sender
{
    [self hidden];
}

@end
