//
//  QuickScanDrugListViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/9.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QuickScanDrugListViewController.h"
#import "ScanDrugTableViewCell.h"
#import "DrugDetailViewController.h"

#import "DrugModel.h"
#import "ChatViewController.h"
#import "XPChatViewController.h"
#import "ExpertChatViewController.h"
#import "ExpertXPChatViewController.h"

@interface QuickScanDrugListViewController ()

@end

@implementation QuickScanDrugListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.sendMedicineByStore) {
        self.title = @"选择要发送的本店药品";
    }else{
        self.title = @"选择要发送的药品";
    }
    
    
    self.drugTableView.dataSource = self;
    self.drugTableView.delegate = self;
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    self.drugTableView.tableFooterView = view;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
}

- (void)cancelAction
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for(NSInteger index = viewControllers.count - 1; index > 0; index--)
    {
        UIViewController *viewController = viewControllers[index];
        if ([viewController isKindOfClass:[XPChatViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }else if([viewController isKindOfClass:[ChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }else if(index == 0){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ScanDrugIdentifier = @"ScanDrugCellIdentifier";
    ScanDrugTableViewCell *cell = (ScanDrugTableViewCell *)[self.drugTableView dequeueReusableCellWithIdentifier:ScanDrugIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"ScanDrugTableViewCell" bundle:nil];
        [self.drugTableView registerNib:nib forCellReuseIdentifier:ScanDrugIdentifier];
        cell = (ScanDrugTableViewCell *)[self.drugTableView dequeueReusableCellWithIdentifier:ScanDrugIdentifier];
    }
    
    [cell setCell:self.product];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ExpertSearchMedicineListModel *model = [ExpertSearchMedicineListModel new];
    model.productId = self.product.productId;
    model.proId = self.product.proId;
    model.proName = self.product.proName;
    model.spec = self.product.spec;
    model.factory = self.product.factory;
    model.imgUrl = self.product.imgUrl;
    
    if (self.block) {
        self.block(model);
    }
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController=(UIViewController *)obj;
        if ([viewController isKindOfClass:[XPChatViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }else if([viewController isKindOfClass:[ChatViewController class]]){
            [self.navigationController popToViewController:viewController animated:YES];
        }else if([viewController isKindOfClass:[ExpertChatViewController class]]){
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
