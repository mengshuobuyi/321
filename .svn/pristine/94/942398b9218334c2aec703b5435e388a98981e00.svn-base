//
//  StoreSendMedicineListViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/6/21.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "StoreSendMedicineListViewController.h"
#import "DrugDetailViewController.h"
#import "MedicineListCell.h"
#import "UIImageView+WebCache.h"
#import "Drug.h"

#import "QuickSearchDrugViewController.h"
#import "ChatViewController.h"
#import "XPChatViewController.h"
#import "ExpertChatViewController.h"
#import "ExpertXPChatViewController.h"

@interface StoreSendMedicineListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
    UIView *_nodataView;
}
@property (nonatomic ,strong) NSMutableArray * dataSource;

@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation StoreSendMedicineListViewController

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择要发送的本店药品";
    
    currentPage = 1;
    self.dataSource = [NSMutableArray array];
    
    self.tableView.rowHeight = 88;
    self.tableView=[[UITableView alloc]init];
    [self.tableView setFrame:CGRectMake(0, 0, APP_W, APP_H -NAV_H)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=RGBHex(qwColor11);
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    [self loadData];
}

- (void)cancelAction
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController=(UIViewController *)obj;
        if ([viewController isKindOfClass:[XPChatViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            *stop = YES;
        }else if([viewController isKindOfClass:[ChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
            *stop = YES;
        }else if(idx == (self.navigationController.viewControllers.count - 1)){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma mark ---- 查询数据 ----
- (void)loadData
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWarning215N6 image:@"网络信号icon"];
        return;
    }
    
    

    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = StrFromObj(QWGLOBALMANAGER.configure.groupId);
    setting[@"key"] = StrFromObj(self.keyWord);
    
    [Drug MmallByNameWithParams:setting success:^(id DFUserModel) {
        
        StoreSearchMedicinePageModel * page = [StoreSearchMedicinePageModel parse:DFUserModel Elements:[ExpertSearchMedicineListModel class] forAttribute:@"productList"];
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.productList.count > 0) {
                
                //关键字加入缓存
                if (self.historyBlock) {
                    self.historyBlock(self.keyWord);
                }
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:page.productList];
                [self.tableView reloadData];
            }else{
                [self showInfoView:@"本店暂无此药品销售\n\n请直接发送药品名称" image:@"img_search_common"];
            }
        }else if ([page.apiStatus integerValue] == 100)
        {
            [self showInfoView:@"本店暂无此药品销售\n\n请直接发送药品名称" image:@"img_search_common"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage duration:0.8f];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 列表代理 ----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"cellIdentifier";
    MedicineListCell * cell = (MedicineListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MedicineListCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ExpertSearchMedicineListModel *productclass=self.dataSource[indexPath.row];
    [cell configureStoreData:productclass];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ExpertSearchMedicineListModel *product = self.dataSource[indexPath.row];
    if (self.block) {
        self.block(product);
    }
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController=(UIViewController *)obj;
        if ([viewController isKindOfClass:[XPChatViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }else if([viewController isKindOfClass:[ChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
        }
        
        else if([viewController isKindOfClass:[ExpertChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
        }else if([viewController isKindOfClass:[ExpertXPChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
        }
        
        else if(idx == (self.navigationController.viewControllers.count - 1)){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
