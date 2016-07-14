//
//  SearchInstitutionViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SearchInstitutionViewController.h"
#import "InstitutionListViewController.h"
#import "PerfectInfoViewController.h"
#import "SVProgressHUD.h"
#import "LeveyPopListView.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"
#import "PharmacyModel.h"
#import "Pharmacy.h"

@interface SearchInstitutionViewController ()<LeveyPopListViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton    *btn_province;
@property (strong, nonatomic) IBOutlet UIButton    *btn_city;
@property (strong, nonatomic) IBOutlet UIButton    *btn_area;
@property (strong, nonatomic) IBOutlet UITextField *text_storeName;
@property (strong, nonatomic) IBOutlet UITextField *text_StoreAdress;

@property (assign, nonatomic) BOOL           hasAreaLsit;
@property (assign, nonatomic) BOOL           hasCityLsit;
@property (assign, nonatomic) int            type;
@property (strong, nonatomic) NSString       *provinceNum;
@property (strong, nonatomic) NSString       *cityNum;
@property (strong, nonatomic) NSString       *areaNum;
@property (strong, nonatomic) NSMutableArray *areaList;

- (IBAction)SearchInstitutionAction:(id)sender;
- (IBAction)WriteInfoAction:(id)sender;
- (IBAction)getAreaListAction:(id)sender;

@end

@implementation SearchInstitutionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查询我的机构";
    [self setUpForDismissKeyboard];
    self.areaList = [NSMutableArray array];
    
    self.hasAreaLsit = NO;
    self.hasCityLsit = NO;
}

#pragma mark ====
#pragma mark ==== 点击空白 收起键盘

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
    }];
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ====
#pragma mark ==== 查询机构

- (IBAction)SearchInstitutionAction:(id)sender {
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    
    if (self.provinceNum != nil) {
        setting[@"province"] = StrFromObj(self.provinceNum);
    }
    if (self.cityNum != nil) {
        setting[@"city"] = StrFromObj(self.cityNum);
    }
    if (self.areaNum != nil) {
        setting[@"county"] = StrFromObj(self.areaNum);
    }
    if ([self.text_storeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入机构名称" duration:DURATION_SHORT];
        return;
    }else {
        setting[@"storeName"] = StrFromObj([self.text_storeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }
    if (self.text_StoreAdress.text != 0) {
        setting[@"address"] = StrFromObj([self.text_StoreAdress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }
    setting[@"currPage"] = @"1";
    setting[@"pageSize"] = @"10";
    
    InstitutionListViewController *ListVC = [[InstitutionListViewController alloc] initWithNibName:@"InstitutionListViewController" bundle:nil];
    ListVC.searchInfo = setting;
    
    RegisterAreaInfoModel *areaModel = [RegisterAreaInfoModel new];
    areaModel.city = [self.btn_city.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    areaModel.country = [self.btn_area.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    areaModel.province = [self.btn_province.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [QWUserDefault setObject:areaModel key:REGISTER_JG_AREAINFO];
    
    [self.navigationController pushViewController:ListVC animated:YES];
}

#pragma mark ====
#pragma mark ==== 不查了，直接填写

- (IBAction)WriteInfoAction:(id)sender {
    
    PerfectInfoViewController *perfectVC = [[PerfectInfoViewController alloc] initWithNibName:@"PerfectInfoViewController" bundle:nil];
    if ([QWUserDefault getObjectBy:REGISTER_JG_COMPANYINFO]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:REGISTER_JG_COMPANYINFO];
    }
    perfectVC.comefromWrite = YES;
    [self.navigationController pushViewController:perfectVC animated:NO];
}

#pragma mark ====
#pragma mark ==== 选择省市区

- (IBAction)getAreaListAction:(id)sender {
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    if (sender == self.btn_province)
    {
        self.hasAreaLsit = NO;
        
    }else if(sender == self.btn_city)
    {
        if(self.provinceNum.length > 0){
            setting[@"code"] = StrFromObj(self.provinceNum);
        }else{
            [SVProgressHUD showErrorWithStatus:@"请选择药店所在省" duration:DURATION_SHORT];
            return;
        }
    }else
    {
        if(self.cityNum.length >0){
            setting[@"code"] = StrFromObj(self.cityNum);
        }else{
            [SVProgressHUD showErrorWithStatus:@"请选择药店所在省市" duration:DURATION_SHORT];
            return;
        }
    }
    
    [Pharmacy QueryAreaWithParams:setting success:^(id obj) {
        
        QueryAreaPage *page = (QueryAreaPage *)obj;
        
        if ([page.apiStatus intValue] == 0) {
            QueryAreaPage *page = (QueryAreaPage *)obj;
            NSMutableArray *arrname = [NSMutableArray array];
            self.areaList = (NSMutableArray *) page.list;
            for (int i = 0; i< self.areaList.count; i++) {
                
                QueryAreaModel *model = self.areaList[i];
                [arrname addObject:model.name];
            }
            if (sender == self.btn_province) {
                self.type = 1;
                self.hasAreaLsit = NO;
                self.hasCityLsit = NO;
            }else if(sender == self.btn_city){
                self.type = 2;
                
            }else if(sender == self.btn_area){
                self.type = 3;
            }
            
            LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"" options:arrname];
            popListView.delegate = self;
            [popListView showInView:self.view animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }
        
        
        
    } failure:^(HttpException *e) {
        
    }];
    
}

#pragma mark =====
#pragma mark ===== LeveyPopListView delegates

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    QueryAreaModel *model = self.areaList[anIndex];
    if (self.type == 1) {
        
        if (![self.btn_province.titleLabel.text isEqualToString:model.name]) {
            [self.btn_city setTitle:@"选择市" forState:UIControlStateNormal];
            [self.btn_area setTitle:@"选择区/县" forState:UIControlStateNormal];
            self.cityNum = @"";
            self.areaNum = @"";
        }
        [self.btn_province setTitle:model.name forState:UIControlStateNormal];
        self.provinceNum = model.code;
        self.btn_city.enabled = YES;
    }else if(self.type == 2){
        if (![self.btn_city.titleLabel.text isEqualToString:model.name]) {
            [self.btn_area setTitle:@"选择区/县" forState:UIControlStateNormal];
            self.areaNum = @"";
        }
        
        [self.btn_city setTitle:model.name forState:UIControlStateNormal];
        self.cityNum = model.name;
        self.btn_area.enabled = YES;
    }else{
        self.areaNum = model.code;
        [self.btn_area setTitle:model.name forState:UIControlStateNormal];
    }
    
}

- (void)leveyPopListViewDidCancel
{
    
}

@end