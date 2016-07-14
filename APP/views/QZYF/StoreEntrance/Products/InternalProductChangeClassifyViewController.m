//
//  InternalProductChangeClassifyViewController.m
//  wenYao-store
//
//  Created by PerryChen on 7/12/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductChangeClassifyViewController.h"
#import "InternalProduct.h"
#import "InternalCateSelectCell.h"
@interface InternalProductChangeClassifyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (nonatomic, strong) NSMutableArray *arrCates;

@end

@implementation InternalProductChangeClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrCates = [@[] mutableCopy];
    self.navigationItem.title = @"修改分类";
    self.tbViewContent.rowHeight = 44.0f;
    [self getAllProductCateList];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.backButtonEnabled = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self setupLeftItem];
    [self setupRightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  设置导航栏左侧按钮
 */
- (void)setupLeftItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = 15;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItems = @[fixed,rightItem];
}

/**
 *  设置导航栏右侧按钮
 */
- (void)setupRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = 15;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction)];

    self.navigationItem.rightBarButtonItems = @[fixed,rightItem];
}

/**
 *  获取商品类别列表
 *
 */
- (void)getAllProductCateList
{
    InternalCateWithProModelR *modelR = [InternalCateWithProModelR new];
    modelR.branchProId = self.modelSelect.proId;
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [InternalProduct queryCatesWithPro:modelR success:^(InternalProductCateListModel *responseModel) {
        [self.arrCates addObjectsFromArray:responseModel.categories];
        [self.tbViewContent reloadData];
    } failure:^(HttpException *e) {
        [self showError:[e description]];
    }];
}

- (BOOL)checkCanMerge
{
    BOOL canMerge = NO;
    for (InternalProductCateModel *modelCate in self.arrCates) {
        if ([modelCate.check boolValue]) {
            canMerge = YES;
            break;
        }
    }
    return canMerge;
}

- (void)saveCategories
{
    NSMutableArray *arrIds = [@[] mutableCopy];
    for (InternalProductCateModel *modelCate in self.arrCates) {
        if ([modelCate.check boolValue]) {
            [arrIds addObject:modelCate.classId];
        }
    }
    NSString *strCates = [arrIds componentsJoinedByString:SeparateStr];
    InternalMergeCateModelR *modelR = [InternalMergeCateModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.branchProId = self.modelSelect.proId;
    modelR.branchCategories = strCates;
    [InternalProduct postMergeCates:modelR success:^(BaseAPIModel *responseModel) {
        if ([responseModel.apiStatus intValue] == 0) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                [self showSuccess:@"修改成功"];
            }];
        } else {
            [self showError:responseModel.apiMessage];
        }
    } failure:^(HttpException *e) {
        [self showError:[e description]];
    }];
}

#pragma mark - UINavigation item action
- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)confirmAction
{
    if ([self checkCanMerge]) {
        [self saveCategories];
    } else {
        [self showError:@"请选择一个分类"];
    }
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InternalProductCateModel *model = self.arrCates[indexPath.row];
    InternalCateSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InternalCateSelectCell"];
    [cell setCell:model];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrCates.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InternalProductCateModel *model = self.arrCates[indexPath.row];
    if ([model.check boolValue]) {
        model.check = @"false";
    } else {
        model.check = @"true";
    }
    [tableView reloadData];
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
