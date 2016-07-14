//
//  ProfessionInfoThreeViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ProfessionInfoThreeViewController.h"
#import "ProfessionAuthInfoCell.h"
#import "ExpertAuthCommitViewController.h"
#import "ExpertAuthViewController.h"
#import "Circle.h"
#import "CircleModel.h"

@interface ProfessionInfoThreeViewController ()<UITableViewDataSource,UITableViewDelegate,ProfessionAuthInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (weak, nonatomic) IBOutlet UIButton *applyButton;      //申请按钮

@property (strong, nonatomic) NSMutableArray *tagList;           //获取的领域数组

@property (strong, nonatomic) NSMutableArray *selectedTagList;   //选中的擅长领域数组

- (IBAction)applyAction:(id)sender;

@end

@implementation ProfessionInfoThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    
    self.tagList = [NSMutableArray array];
    self.selectedTagList = [NSMutableArray array];
    
    [self configureUI];
    
    //网络获取擅长领域
    [self queryTags];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView =self.tableFooterView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)configureUI
{
    self.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.applyButton.layer.cornerRadius = 4.0;
    self.applyButton.layer.masksToBounds = YES;
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
        
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.skilledFieldList.count > 0) {
                [self.tagList removeAllObjects];
                [self.tagList addObjectsFromArray:page.skilledFieldList];
                [self.tableView reloadData];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = [ProfessionAuthInfoCell getCellHeight:self.tagList];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfessionAuthInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfessionAuthInfoCell"];
    [cell setUpTagsWithAllList:self.tagList selectedList:self.selectedTagList];
    cell.professionAuthInfoCellDelegate = self;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ---- 选择标签代理 ----
- (void)selectedTagAction:(UIButton *)button
{
    UIButton *btn = button;
    int row = btn.tag-100;
    
    GoodFieldModel *model = self.tagList[row];
    if ([self.selectedTagList containsObject:model])
    {
        [self.selectedTagList removeObject:model];
    }else
    {
        if (self.selectedTagList.count < 3) {
            [self.selectedTagList addObject:model];
        }else{
            [SVProgressHUD showErrorWithStatus:@"最多可选择3个擅长领域"];
        }
    }
    [self.tableView reloadData];
}

#pragma mark ---- 申请认证 ----
- (IBAction)applyAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (self.selectedTagList.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择擅长领域"];
        return;
    }
    
    NSString *tagId =@"";
    NSString *tagStr = @"";
    
    if (self.selectedTagList)
    {
        for (int i = 0; i < self.selectedTagList.count; i++) {
            GoodFieldModel *model = [self.selectedTagList objectAtIndex:i];
            if (i == 0)
            {
                tagId = [NSString stringWithFormat:@"%@",model.id];
                tagStr = [NSString stringWithFormat:@"%@",model.dicValue];
            }else
            {
                tagId = [NSString stringWithFormat:@"%@%@%@",tagId,SeparateStr,model.id];
                tagStr = [NSString stringWithFormat:@"%@%@%@",tagStr,SeparateStr,model.dicValue];
            }
        }
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"name"] = StrFromObj(self.nameString);
    setting[@"headImageUrl"] = StrFromObj(self.headerImageUrl);
    setting[@"expertiseIds"] = StrFromObj(tagId);
    setting[@"expertise"] = StrFromObj(tagStr);
    setting[@"status"] = @"1";;
    [Circle TeamUpdateMbrInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            ExpertAuthCommitViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthCommitViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
