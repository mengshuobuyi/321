//
//  InternalProductsInClassifyViewController.m
//  wenYao-store
//
//  Created by PerryChen on 7/12/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductsInClassifyViewController.h"
#import "BVReorderTableView.h"
#import "InternalProductListCell.h"
#import "UIAlertView+RWBlock.h"
#import "InternalProductDetailViewController.h"
#import "InternalPackageCell.h"
#import "InternalProductChangeClassifyViewController.h"
@interface InternalProductsInClassifyViewController ()<UITableViewDelegate, UITableViewDataSource, ReorderTableViewDelegate, ProductlistCellDelegate ,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *arrProductList;   // 本店商品列表
@property (nonatomic, strong) NSMutableArray *arrPackageList;   // 优惠套餐列表
@property (assign, nonatomic) NSInteger curPage;                // 记录当前页数
@property (weak, nonatomic) IBOutlet BVReorderTableView *tbViewContent;
@property (strong, nonatomic) UITextField *groupNameTextField;  // 弹出库存框

@end

@implementation InternalProductsInClassifyViewController
static NSString *const InterProIdentifier = @"InternalProductListCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrProductList = [@[] mutableCopy];
    self.arrPackageList = [@[] mutableCopy];
    [self.tbViewContent registerNib:[UINib nibWithNibName:@"InternalProductListCell" bundle:nil] forCellReuseIdentifier:InterProIdentifier];
    if (AUTHORITY_ROOT) {
        self.tbViewContent.canReorder = YES;
    } else {
        self.tbViewContent.canReorder = NO;
    }
    if ([self.modelCate.classType intValue] == 2) {
        // 优惠套餐
        self.navigationItem.title = @"优惠套餐";
        [self getProductPackageList];
    } else {
        if ([self.modelCate.classType intValue] == 1) {
            self.navigationItem.title = self.modelCate.className;
        } else if ([self.modelCate.classType intValue] == 3) {
            self.navigationItem.title = @"优惠商品";
        } else if ([self.modelCate.classType intValue] == 4) {
            self.navigationItem.title = @"本店推荐";
        }
        [self getProductList];
    }
    
    [self.tbViewContent addFooterWithCallback:^{
        [HttpClient sharedInstance].progressEnabled = NO;
        self.curPage ++;
        if ([self.modelCate.classType intValue] == 2) {
            // 优惠套餐
        } else {
            [self getProductList];
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.curPage = 1;
//    [self.arrProductList removeAllObjects];
    
    [HttpClient sharedInstance].progressEnabled = YES;
    self.tbViewContent.footer.canLoadMore = YES;
//    [self updateCurrentView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self.tbViewContent viewWithTag:1018] == nil) {
        [self enableSimpleRefresh:self.tbViewContent block:^(SRRefreshView *sender) {
            self.curPage = 1;
            [HttpClient sharedInstance].progressEnabled = NO;
            [self.arrProductList removeAllObjects];
            [self.tbViewContent reloadData];
            self.tbViewContent.footer.canLoadMore = YES;
            if ([self.modelCate.classType intValue] == 2) {
                // 优惠套餐
                [self getProductPackageList];
            } else {
                [self getProductList];
            }
        }];
    }
}

/**
 *  获取优惠套餐列表
 */
- (void)getProductPackageList
{
    InternalProductPackageModelR *modelR = [InternalProductPackageModelR new];
    modelR.branchId = QWGLOBALMANAGER.configure.groupId;
    [InternalProduct queryInternalProductPackage:modelR success:^(InternalPackageListModel *responseModel) {
        [self.tbViewContent.footer endRefreshing];
        /**
         *  Fake data
         */
        for (int i = 0; i < 4; i++) {
            InternalPackageDrugListModel *modelList = [InternalPackageDrugListModel new];
            NSMutableArray *arrTemp = [@[] mutableCopy];
            for (int i = 0; i < 3; i++) {
                InternalPackageDrugModel *modelD = [InternalPackageDrugModel new];
                modelD.name = @"aaa";
                [arrTemp addObject:modelD];
            }
            modelList.druglist = arrTemp;
            [self.arrPackageList addObject:modelList];
        }
        
        if (self.arrPackageList.count > 0) {
            
            [self.tbViewContent reloadData];
        }else {
            
            if (self.curPage == 1) {
                [self showInfoView:@"暂无数据" image:@"ic_img_fail"];
            } else {
                self.tbViewContent.footer.canLoadMore = NO;
            }
        }
    } failure:^(HttpException *e) {
        [self.tbViewContent.footer endRefreshing];
        [self showError:e.description];
    }];
}

/**
 *  获取商品列表
 */
- (void)getProductList
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
        return;
    }
    InternalProductModelR *modelR = [InternalProductModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.flagTotal = @"Y";
    modelR.status = @"0";
    modelR.classifyId = self.modelCate.classId;
    modelR.currPage = self.curPage;
    modelR.pageSize = 20;
    [InternalProduct queryInternalProducts:modelR success:^(InternalProductListModel *responseModel) {
        [self.tbViewContent.footer endRefreshing];
        if (responseModel.list.count > 0) {
            [self.arrProductList addObjectsFromArray:responseModel.list];
            [self.tbViewContent reloadData];
        } else {
            
            if (self.curPage == 1) {
                [self showInfoView:@"暂无数据" image:@"ic_img_fail"];
            } else {
                self.tbViewContent.footer.canLoadMore = NO;
            }
        }
    } failure:^(HttpException *e) {
        [self.tbViewContent.footer endRefreshing];
        [self showError:e.description];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.modelCate.classType intValue] != 2) {
        return self.arrProductList.count;
    } else {
        return self.arrPackageList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.modelCate.classType intValue] != 2) {
        InternalProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:InterProIdentifier];
        if (self.arrProductList.count <= 0 ) {
            return cell;
        }
        if ([self.modelCate.classType intValue] != 1) {
            cell.intProType = 1;
        } else  {
            cell.intProType = 0;
        }
        InternalProductModel *model = self.arrProductList[indexPath.row];
        if (AUTHORITY_ROOT) {       // 店长
            cell.viewEditStock.hidden = NO;
            cell.productStockBtn.hidden = NO;
        } else {
            cell.viewEditStock.hidden = YES;
            cell.productStockBtn.hidden = YES;
        }
        [cell setCell:model];
        cell.tag = indexPath.row;
        cell.delegate = self;
        return cell;

    } else {
        InternalPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InternalPackageCell"];
        InternalPackageDrugListModel *modelList = self.arrPackageList[indexPath.row];
        [cell setCell:modelList];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
        __block InternalProductModel *model = self.arrProductList[indexPath.row];
        vc.proId = model.proId;
        vc.updateModelBlock = ^(InternalProductModel *modelNew) {
        if (modelNew != nil) {
            [self.arrProductList replaceObjectAtIndex:indexPath.row withObject:modelNew];
            [self.tbViewContent reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.modelCate.classType intValue] == 2) {
//        static InternalPackageCell *sizingCell = nil;
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            sizingCell = [self.tbViewContent dequeueReusableCellWithIdentifier:@"InternalPackageCell"];
//        });
        InternalPackageDrugListModel *modelList = self.arrPackageList[indexPath.row];
//        [sizingCell setCell:modelList];
//        
        CGFloat floatHeight = 0.0f;
        floatHeight = 35.0f;
        NSInteger countM = modelList.druglist.count;
        floatHeight += countM * 81.0f;
        return floatHeight;
//        sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tbViewContent.bounds), CGRectGetHeight(sizingCell.bounds));
//        [sizingCell setNeedsLayout];
////        [sizingCell layoutIfNeeded];
//        CGSize sizeFinal = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        return sizeFinal.height;
    } else {
        return 123.0f;
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - UITableview cell delegate
/**
 *  修改库存的cell点击代理事件
 *
 *  @param index
 */
- (void)editStackAction:(NSInteger)index
{
    InternalProductModel *model = self.arrProductList[index];
    model.isShowEditView = NO;
    [self showEditStackViewWithIndex:index];
}

- (void)editCateAction:(NSInteger)index
{
    InternalProductModel *model = self.arrProductList[index];
    model.isShowEditView = NO;
    [self performSegueWithIdentifier:@"segueChangeClassify" sender:model];
}

- (void)editRecoAction:(NSInteger)index
{
    InternalProductModel *model = self.arrProductList[index];
    model.isShowEditView = NO;
    NSString *strTip = @"";
    if ([model.isRecommend boolValue]) {
        strTip = @"是否取消推荐";
    } else {
        strTip = @"是否推荐";
    }
    UIAlertView *inputAlertView = [[UIAlertView alloc] initWithTitle:strTip message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    __weak InternalProductsInClassifyViewController *weakself = self;
    [inputAlertView setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself changeRecoAction:model];
        }
    }];
    [inputAlertView show];
}

- (void)editViewAction:(NSInteger)index
{
    InternalProductModel *model = self.arrProductList[index];
    model.isShowEditView = !model.isShowEditView;
    [self.tbViewContent reloadData];
}
#pragma mark - Reorder table view methods
// This method is called when starting the re-ording process. You insert a blank row object into your
// data source and return the object you want to save for later. This method is only called once.
- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.modelCate.classType intValue] == 2) {
        id object = [self.arrPackageList objectAtIndex:indexPath.row];
        return object;
    } else {
        id object = [self.arrProductList objectAtIndex:indexPath.row];
        return object;
    }
}

// This method is called when the selected row is dragged to a new position. You simply update your
// data source to reflect that the rows have switched places. This can be called multiple times
// during the reordering process
- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if ([self.modelCate.classType intValue] == 2) {
        id object = [self.arrPackageList objectAtIndex:fromIndexPath.row];
        [self.arrPackageList removeObjectAtIndex:fromIndexPath.row];
        [self.arrPackageList insertObject:object atIndex:toIndexPath.row];
    } else {
        id object = [self.arrProductList objectAtIndex:fromIndexPath.row];
        [self.arrProductList removeObjectAtIndex:fromIndexPath.row];
        [self.arrProductList insertObject:object atIndex:toIndexPath.row];
    }

}

// This method is called when the selected row is released to its new position. The object is the same
// object you returned in saveObjectAndInsertBlankRowAtIndexPath:. Simply update the data source so the
// object is in its new position. You should do any saving/cleanup here.

- (void)finishReorderingWithIndex:(NSIndexPath *)oriIndexPath atIndexPath:(NSIndexPath *)destIndexPath savedObject:(id)object
{
    if ([self.modelCate.classType intValue] == 2) {
    [self.arrPackageList replaceObjectAtIndex:destIndexPath.row withObject:object];
    } else {
    [self.arrProductList replaceObjectAtIndex:destIndexPath.row withObject:object];
    }


    [self.tbViewContent reloadData];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueChangeClassify"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        InternalProductChangeClassifyViewController *vc =[[navigationController viewControllers]objectAtIndex:0];
        vc.hidesBottomBarWhenPushed = YES;
        InternalProductModel *model = (InternalProductModel *)sender;
        vc.modelSelect = model;
    }
}



/**
 *  展示修改库存页面
 */
- (void)showEditStackViewWithIndex:(NSInteger)idx
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    
    UIView *bgView = [[UIView alloc] init];
    self.groupNameTextField = [[UITextField alloc] init];
    
    bgView.frame = CGRectMake(0, 0, 270, 84);
    self.groupNameTextField.frame = CGRectMake(15 , 20, 240, 44);
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.8];
    
    self.groupNameTextField.placeholder = @"请输入库存";
    self.groupNameTextField.font = fontSystem(14.0f);
    self.groupNameTextField.textColor = RGBHex(0x333333);
    self.groupNameTextField.layer.masksToBounds = YES;
    self.groupNameTextField.layer.borderWidth = 0.5;
    self.groupNameTextField.layer.borderColor = RGBHex(0xcccccc).CGColor;
    self.groupNameTextField.layer.cornerRadius = 5.0f;
    self.groupNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.groupNameTextField.delegate = self;
    self.groupNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    //    [self.groupNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.groupNameTextField.backgroundColor = [UIColor whiteColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.groupNameTextField.leftView = paddingView;
    self.groupNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.groupNameTextField.tag = idx;
    [bgView addSubview:self.groupNameTextField];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        [alert setValue:bgView forKey:@"accessoryView"];
    }else{
        [alert addSubview:bgView];
    }
    [alert show];
}

/**
 *  修改推荐分类的方法
 */
- (void)changeRecoAction:(InternalProductModel *)modelPro
{
    InternalProRecoModelR *modelR = [InternalProRecoModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.branchProId = modelPro.proId;
    if ([modelPro.isRecommend boolValue]) {
        // 取消推荐
        [InternalProduct postCancelRecoProduct:modelR success:^(BaseAPIModel *responseModel) {
            if ([responseModel.apiStatus intValue] == 0) {
                modelPro.isRecommend = @"N";
                [self.tbViewContent reloadData];
            } else {
                [self showError:responseModel.apiMessage];
            }
        } failure:^(HttpException *e) {
            
        }];
    } else {
        // 推荐
        [InternalProduct postRecoProduct:modelR success:^(BaseAPIModel *responseModel) {
            if ([responseModel.apiStatus intValue] == 0) {
                modelPro.isRecommend = @"Y";
                [self.tbViewContent reloadData];
            } else {
                [self showError:responseModel.apiMessage];
            }
        } failure:^(HttpException *e) {
            
        }];
    }
}
#pragma mark ---- UIAlertViewDelegate ----
- (void)showKeyboard
{
    [self.groupNameTextField becomeFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self updateStackWithIdx:self.groupNameTextField.tag];
    }
}

/**
 *  更新库存
 *
 *  @param idx
 */
- (void)updateStackWithIdx:(NSInteger)idx
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:@"网络未连接，请重试"];
        return;
    }
    if (self.groupNameTextField.text.length == 0) {
        [self showError:@"请输入库存"];
        return;
    }
    InternalProductStockModelR *modelR = [InternalProductStockModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.stock = [self.groupNameTextField.text intValue];
    InternalProductModel *model = self.arrProductList[idx];
    modelR.proId = model.proId;
    [InternalProduct changeStock:modelR success:^(BaseAPIModel *responseModel) {
        
        if ([responseModel.apiStatus intValue] == 0) {
            InternalProductListCell *cell = [self.tbViewContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            cell.productStackLbl.text = [NSString stringWithFormat:@"库存%@",self.groupNameTextField.text];
            if ([self.groupNameTextField.text intValue] == 0) {
                cell.productPlaceHolderImgView.hidden = NO;
            } else {
                cell.productPlaceHolderImgView.hidden = YES;
            }
            // 库存为0 且 用户修改的库存大于0
            if ([self.groupNameTextField.text intValue] > 0) {
                self.curPage = 1;
                [self.arrProductList removeAllObjects];
                self.tbViewContent.footer.canLoadMore = YES;
                [self getProductList];
            }
            [self showSuccess:@"修改成功"];
        } else {
            [self showError:responseModel.apiMessage];
        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];
}


@end
