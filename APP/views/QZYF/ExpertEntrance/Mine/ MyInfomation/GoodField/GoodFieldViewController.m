//
//  GoodFieldViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "GoodFieldViewController.h"
#import "Circle.h"
#import "CircleModel.h"

@interface GoodFieldViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgView_layout_height;
@property (strong, nonatomic) NSMutableArray *tagList;
@property (strong, nonatomic) NSMutableArray *selectedList;

@end

@implementation GoodFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"擅长领域";
    
    self.tagList = [NSMutableArray array];
    self.selectedList = [NSMutableArray array];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.bgView.layer.cornerRadius = 4.0;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderColor = RGBHex(qwColor11).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    [self queryTags];
}

#pragma mark ---- 请求标签数据 ----
- (void)queryTags
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    [Circle TeamExpertiseListWithParams:setting success:^(id obj) {
        GoodFieldPageModel *page = [GoodFieldPageModel parse:obj Elements:[GoodFieldModel class] forAttribute:@"skilledFieldList"];
        if ([page.apiStatus integerValue] == 0) {
            if (page.skilledFieldList.count > 0) {
                [self.tagList removeAllObjects];
                [self.tagList addObjectsFromArray:page.skilledFieldList];
                [self setUpTags:self.tagList];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 设置标签 ----
- (void)setUpTags:(NSArray *)array
{
    for (UIView *subView in self.bgView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 0; i < array.count; i ++) {
        
        GoodFieldModel *model = array[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [btn setTitle:[NSString stringWithFormat:@"%@",model.dicValue] forState:UIControlStateNormal];
        [btn setTitleColor:RGBHex(qwColor8) forState:UIControlStateNormal];
        btn.titleLabel.font = fontSystem(14);
        btn.layer.cornerRadius = 3.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = RGBHex(qwColor9).CGColor;
        btn.layer.borderWidth = 0.5;
        btn.frame = CGRectMake(12 + i%4 * (64 + (APP_W-310)/3) ,10+i/4*(30 + 10)  , 64, 30);
        [btn addTarget:self action:@selector(clickTags:) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = YES;
        btn.tag = 100 + i;
        [self.bgView addSubview:btn];
    }
    
    self.bgView_layout_height.constant = 10 + (array.count/4+1)*40;
    CGRect frame = self.tableHeaderView.frame;
    frame.size.height = 10 + (array.count/4+1)*40 + 50;
    self.tableHeaderView.frame = frame;
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView reloadData];
}

#pragma mark ---- 点击标签 ----
- (void)clickTags:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int row = btn.tag - 100;
    
    GoodFieldModel *model = self.tagList[row];
    if ([self.selectedList containsObject:model]) {
        [self.selectedList removeObject:model];
        [btn setTitleColor:RGBHex(qwColor8) forState:UIControlStateNormal];
        btn.layer.borderColor = RGBHex(qwColor9).CGColor;
    }else{
        
        if (self.selectedList.count < 3) {
            [self.selectedList addObject:model];
            [btn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
            btn.layer.borderColor = RGBHex(qwColor1).CGColor;
        }else{
            [SVProgressHUD showErrorWithStatus:@"最多可选择3个擅长领域"];
        }
    }
}

#pragma mark ---- 保存 ----
- (void)saveAction
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (self.selectedList.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请至少选择一个擅长领域"];
        return;
    }
    
    NSString *tagId =@"";
    NSString *tagStr = @"";
    
    if (self.selectedList)
    {
        for (int i = 0; i < self.selectedList.count; i++) {
            GoodFieldModel *model = [self.selectedList objectAtIndex:i];
            if (i == 0) {
                tagId = [NSString stringWithFormat:@"%@",model.id];
                tagStr = [NSString stringWithFormat:@"%@",model.dicValue];
            }else{
                tagId = [NSString stringWithFormat:@"%@%@%@",tagId,SeparateStr,model.id];
                tagStr = [NSString stringWithFormat:@"%@%@%@",tagStr,SeparateStr,model.dicValue];
            }
        }
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"expertiseIds"] = StrFromObj(tagId);
    setting[@"expertise"] = StrFromObj(tagStr);
    setting[@"status"] = @"-1";
    [Circle TeamUpdateMbrInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            
            if (self.goodFieldViewControllerDelegate && [self.goodFieldViewControllerDelegate respondsToSelector:@selector(changeGoodField:)]) {
                [self.goodFieldViewControllerDelegate changeGoodField:self.selectedList];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}


#pragma mark ---- 列表代理 ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"GoodFieldCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
