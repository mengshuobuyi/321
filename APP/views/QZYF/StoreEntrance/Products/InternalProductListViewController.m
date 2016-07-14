//
//  InternalProductListViewController.m
//  wenYao-store
//
//  本店商品列表
//  调用接口:
//  获取分类列表: QueryInternalProductCateList    h5/bmmall/queryClassifys
//  获取商品列表: QueryInternalProductList        h5/bmmall/queryClassifyProduct
//  修改库存:    UpdateInternalProductStock      h5/bmmall/updateStock
//
//  Created by PerryChen on 3/8/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductListViewController.h"
#import "RightAccessButton.h"
#import "InternalProductSearchRootViewController.h"
#import "ComboxView.h"
#import "InternalProductListCell.h"
#import "ComboxViewCell.h"
#import "InternalProductDetailViewController.h"
#import "InternalProduct.h"
#import "CustomAddInternalProductView.h"
#import "AllScanReaderViewController.h"
#import "InternalProductManualAddViewController.h"
#import "InernalProductScanAddResultViewController.h"
#import "QYPhotoAlbum.h"
#import "BVReorderTableView.h"
#import "InternalCateReorderCell.h"
#import "InternalProductChangeClassifyViewController.h"
#import "InternalProductsInClassifyViewController.h"
#import "UIAlertView+RWBlock.h"
@interface InternalProductListViewController ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, ProductlistCellDelegate, ReorderTableViewDelegate>
{
}
@property (strong, nonatomic) IBOutlet UIView *naviViewSelection; // 导航栏顶部分类view
@property (weak, nonatomic) IBOutlet UISegmentedControl *naviSegmentSelection;
@property (strong, nonatomic) UITextField *groupNameTextField;  // 弹出库存框
@property (assign, nonatomic) NSInteger curPage;                // 记录当前页数
@property (nonatomic, strong) NSMutableArray *arrCateList;      // 类别列表
@property (nonatomic, strong) NSMutableArray *arrProductList;   // 本店商品列表
@property (nonatomic, strong) CustomAddInternalProductView *viewAddProduct;     // 添加本店商品的弹出页面
@property (nonatomic, assign) NSInteger intSelectType;          // 0 代表选择商品 1 代表选择分类
@property (nonatomic, assign) NSInteger intSelectProductType;   // 判断调用的是啥类型的商品
@property (weak, nonatomic) IBOutlet UIView *viewProductsContent;
@property (weak, nonatomic) IBOutlet UIView *viewProductsStatus;
@property (weak, nonatomic) IBOutlet UIView *viewProductsNoContent;
@property (weak, nonatomic) IBOutlet UITableView *viewProductTBView;
@property (weak, nonatomic) IBOutlet UIView *viewCategoriesContent;
@property (weak, nonatomic) IBOutlet UIView *viewCategoriesTips;
@property (weak, nonatomic) IBOutlet UIView *viewCategoriesNoContent;
@property (weak, nonatomic) IBOutlet BVReorderTableView *viewCategoriesTBView;

@property (weak, nonatomic) IBOutlet UIView *viewProStatusAll;  // 全部商品
@property (weak, nonatomic) IBOutlet UIView *viewProStatusSoldOut;  // 售罄
@property (weak, nonatomic) IBOutlet UIView *viewProStatusScore;    // 积分商品
@property (weak, nonatomic) IBOutlet UIView *viewProStatusReco;     // 本店推荐
@property (weak, nonatomic) IBOutlet UILabel *lblProStatusAll;
@property (weak, nonatomic) IBOutlet UILabel *lblProStatusSoldOut;
@property (weak, nonatomic) IBOutlet UILabel *lblProStatusScore;
@property (weak, nonatomic) IBOutlet UILabel *lblProStatusReco;





@end

@implementation InternalProductListViewController
static NSString *const MenuIdentifier = @"MenuIdentifier";
static NSString *const InterProIdentifier = @"InternalProductListCell";
static NSString *const InterCateIdentifier = @"InternalCateReorderCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品";
    if (AUTHORITY_ROOT) {
        [self setupLeftItem];
    }
    [self setupRightItem];
    // 初始化数组
    self.intSelectType = 0;
    [self setupNaviItem];
    [self initOriData];
    [self.viewProductTBView registerNib:[UINib nibWithNibName:@"InternalProductListCell" bundle:nil] forCellReuseIdentifier:InterProIdentifier];
    self.viewProductTBView.rowHeight = 123.0f;
    self.viewCategoriesTBView.rowHeight = 44.0f;
    self.viewCategoriesTBView.delegate = self;
    self.viewCategoriesTBView.dataSource = self;
    if (AUTHORITY_ROOT) {
        self.viewCategoriesTBView.canReorder = YES;
    } else {
        self.viewCategoriesTBView.canReorder = NO;
    }
    self.viewAddProduct = (CustomAddInternalProductView *)[[NSBundle mainBundle] loadNibNamed:@"CustomAddInternalProductView" owner:self options:nil][0];
    __weak typeof(self) wself = self;
    self.viewAddProduct.blockManual = ^(){
        [QWGLOBALMANAGER statisticsEventId:@"商品_添加商品" withLable:@"本店商品" withParams:nil];
        InternalProductManualAddViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductManualAddViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:vc animated:YES];
    };
    
    self.viewAddProduct.blockScan = ^(){
        [QWGLOBALMANAGER statisticsEventId:@"商品_添加商品" withLable:@"本店商品" withParams:nil];
        if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
            [QWGLOBALMANAGER getCramePrivate];
            return;
        }
        AllScanReaderViewController *vc = [[AllScanReaderViewController alloc]init];
        vc.scanType=Enum_Scan_Items_AddInternalProduct;
        vc.scan = ^(NSString *result) {
            InernalProductScanAddResultViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InernalProductScanAddResultViewController"];
            vc.strCode = result;
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:vc animated:YES];
    };
    
    self.view.backgroundColor = RGBHex(qwColor11);
    // 拉取类别列表
    [self getAllProductCateList];


    [self.viewProductTBView addFooterWithCallback:^{
        [HttpClient sharedInstance].progressEnabled = NO;
        self.curPage ++;
        [self getProductList];
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.curPage = 1;
    [self.arrProductList removeAllObjects];
    [HttpClient sharedInstance].progressEnabled = YES;
    self.viewProductTBView.footer.canLoadMore = YES;
    [self updateCurrentView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self.viewProductTBView viewWithTag:1018] == nil) {
        [self enableSimpleRefresh:self.viewProductTBView block:^(SRRefreshView *sender) {
            self.curPage = 1;
            [HttpClient sharedInstance].progressEnabled = NO;
            [self.arrProductList removeAllObjects];
            [self.viewProductTBView reloadData];
            self.viewProductTBView.footer.canLoadMore = YES;
            [self getProductList];
        }];
    }
}

// 设置商品列表顶部四个按钮
- (void)setProductStatusWithIndex
{
    self.viewProStatusAll.backgroundColor = self.viewProStatusSoldOut.backgroundColor = self.viewProStatusScore.backgroundColor = self.viewProStatusReco.backgroundColor = RGBHex(qwColor4);
    self.lblProStatusAll.textColor = self.lblProStatusSoldOut.textColor = self.lblProStatusScore.textColor = self.lblProStatusReco.textColor = RGBHex(qwColor6);
    if (self.intSelectProductType == 0) {
        self.viewProStatusAll.backgroundColor = RGBHex(qwColor1);
        self.lblProStatusAll.textColor = RGBHex(qwColor4);
    } else if (self.intSelectProductType == 1) {
        self.viewProStatusSoldOut.backgroundColor = RGBHex(qwColor1);
        self.lblProStatusSoldOut.textColor = RGBHex(qwColor4);
    } else if (self.intSelectProductType == 2) {
        self.viewProStatusScore.backgroundColor = RGBHex(qwColor1);
        self.lblProStatusScore.textColor = RGBHex(qwColor4);
    } else {
        self.viewProStatusReco.backgroundColor = RGBHex(qwColor1);
        self.lblProStatusReco.textColor = RGBHex(qwColor4);
    }
}

/**
 *  初始化页面需使用的array
 *
 *  @return
 */
- (void)initOriData
{
    InternalProductCateModel *cateModel = [InternalProductCateModel new];
    cateModel.classifyId = @"";
    cateModel.name = @"全部";
    self.arrCateList = [@[] mutableCopy];//[NSMutableArray arrayWithArray:@[cateModel]];
    self.arrProductList = [[NSMutableArray alloc] init];
    self.curPage = 1;
    self.intSelectProductType = 0;
    self.viewProStatusAll.layer.cornerRadius = self.viewProStatusSoldOut.layer.cornerRadius = self.viewProStatusScore.layer.cornerRadius = self.viewProStatusReco.layer.cornerRadius = 4.0f;
    [self setProductStatusWithIndex];
}

- (void)updateCurrentView
{
    if (self.intSelectType == 0) {
        // 商品
        self.viewProductsContent.hidden = NO;
        self.viewCategoriesContent.hidden = YES;
        [self getProductList];
    } else {
        // 分类
        self.viewProductsContent.hidden = YES;
        self.viewCategoriesContent.hidden = NO;
        [self.arrCateList removeAllObjects];
        [self getAllProductCateList];
    }
}

- (IBAction)segAction:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    self.intSelectType = [seg selectedSegmentIndex];
    [self updateCurrentView];
}

/**
 *  设置导航栏标题view
 */
- (void)setupNaviItem
{
    self.navigationItem.titleView = self.naviViewSelection;
}

/**
 *  设置导航栏左侧按钮
 */
- (void)setupLeftItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    
    //三个点button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 0, 50, 40);
    [button setImage:[UIImage imageNamed:@"btn_eidt_discount"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"navBar_icon_search_white_click"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.leftBarButtonItems = @[fixed,rightItem];
}

/**
 *  设置导航栏右侧按钮
 */
- (void)setupRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    
    //三个点button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, -2, 50, 40);
    [button setImage:[UIImage imageNamed:@"navBar_icon_search_white"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navBar_icon_search_white_click"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[fixed,rightItem];
}

/**
 *  点击导航栏左侧按钮事件
 */
- (void)leftAction
{
    CGRect rectFrame = [[UIScreen mainScreen] bounds];
    self.viewAddProduct.frame = rectFrame;
    [[UIApplication sharedApplication].keyWindow addSubview:self.viewAddProduct];
    self.viewAddProduct.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.viewAddProduct.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

    [self.viewAddProduct setNeedsLayout];
    [self.viewAddProduct layoutIfNeeded];
}

/**
 *  点击导航栏右侧按钮事件
 */
- (void)rightAction
{
    UIStoryboard *sbProduct = [UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil];
    InternalProductSearchRootViewController *vc = [sbProduct instantiateViewControllerWithIdentifier:@"InternalProductSearchRootViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionSelectStatus:(id)sender {
    UIButton *btnSelect = (UIButton *)sender;
    self.intSelectProductType = btnSelect.tag;
    [self setProductStatusWithIndex];
    self.curPage = 1;
    [self.arrProductList removeAllObjects];
    [self getProductList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                [self.viewProductTBView reloadData];
                [self showSuccess:@"修改成功"];
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
                [self.viewProductTBView reloadData];
            } else {
                [self showError:responseModel.apiMessage];
            }
        } failure:^(HttpException *e) {
            
        }];
    }
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
    modelR.flagClass = @"Y";
    if (self.intSelectProductType == 0) {
        // 全部
        modelR.status = @"0";
    } else if (self.intSelectProductType == 1) {
        // 售罄
        modelR.status = @"4";
    } else if (self.intSelectProductType == 2) {
        // 积分商品
        modelR.status = @"5";
    } else if (self.intSelectProductType == 3) {
        // 本店推荐
        modelR.status = @"6";
    }
    modelR.classifyId = @"";
    modelR.currPage = self.curPage;
    modelR.pageSize = 20;
    [InternalProduct queryInternalProducts:modelR success:^(InternalProductListModel *responseModel) {
        [self.viewProductTBView.footer endRefreshing];
        self.viewProductTBView.hidden = NO;
        self.viewProductsNoContent.hidden = YES;
        if (responseModel.list.count > 0) {
            [self.arrProductList addObjectsFromArray:responseModel.list];
            [self.viewProductTBView reloadData];
            
            [self.naviSegmentSelection setTitle:[NSString stringWithFormat:@"商品(%@)",responseModel.totalCount] forSegmentAtIndex:0];
            [self.naviSegmentSelection setTitle:[NSString stringWithFormat:@"分类(%@)",responseModel.classCount] forSegmentAtIndex:1];
        } else {
            
            if (self.curPage == 1) {
                self.viewProductsNoContent.hidden = NO;
                self.viewProductTBView.hidden = YES;
            } else {
                self.viewProductTBView.footer.canLoadMore = NO;
            }
        }
    } failure:^(HttpException *e) {
        [self.viewProductTBView.footer endRefreshing];
        [self showError:e.description];
    }];
}

/**
 *  获取商品类别列表
 *
 */
- (void)getAllProductCateList
{
    InternalProductCateModelR *modelR = [InternalProductCateModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    NSLog(@"branch id is %@",QWGLOBALMANAGER.configure.groupId);
    [InternalProduct queryProductCatesWithCount:modelR success:^(InternalProductCateListModel *responseModel) {
        [self.arrCateList addObjectsFromArray:responseModel.categories];
        [self.viewCategoriesTBView reloadData];
    } failure:^(HttpException *e) {
    }];
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
            InternalProductListCell *cell = [self.viewProductTBView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
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
                self.viewProductTBView.footer.canLoadMore = YES;
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

#pragma mark - UITableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.viewProductTBView) {
        return self.arrProductList.count;
    }else {
        return self.arrCateList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.viewProductTBView) {
        InternalProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:InterProIdentifier];
        if (self.arrProductList.count <= 0 ) {
            return cell;
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
        InternalCateReorderCell *cellReorder = [tableView dequeueReusableCellWithIdentifier:InterCateIdentifier];
        InternalProductCateModel *model = self.arrCateList[indexPath.row];
        [cellReorder setCell:model];
        return  cellReorder;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.viewProductTBView) {
        InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
        __block InternalProductModel *model = self.arrProductList[indexPath.row];
        vc.proId = model.proId;
        vc.updateModelBlock = ^(InternalProductModel *modelNew) {
            if (modelNew != nil) {
                [self.arrProductList replaceObjectAtIndex:indexPath.row withObject:modelNew];
                [self.viewProductTBView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        InternalProductCateModel *model = self.arrCateList[indexPath.row];
        [self performSegueWithIdentifier:@"segueClassifyProducts" sender:model];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Reorder table view methods
// This method is called when starting the re-ording process. You insert a blank row object into your
// data source and return the object you want to save for later. This method is only called once.
- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.arrCateList objectAtIndex:indexPath.row];
    return object;
}

// This method is called when the selected row is dragged to a new position. You simply update your
// data source to reflect that the rows have switched places. This can be called multiple times
// during the reordering process
- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id object = [self.arrCateList objectAtIndex:fromIndexPath.row];
    [self.arrCateList removeObjectAtIndex:fromIndexPath.row];
    [self.arrCateList insertObject:object atIndex:toIndexPath.row];
}

// This method is called when the selected row is released to its new position. The object is the same
// object you returned in saveObjectAndInsertBlankRowAtIndexPath:. Simply update the data source so the
// object is in its new position. You should do any saving/cleanup here.

- (void)finishReorderingWithIndex:(NSIndexPath *)oriIndexPath atIndexPath:(NSIndexPath *)destIndexPath savedObject:(id)object
{
    if (oriIndexPath.row <= 2) {
        
        [self.arrCateList removeObjectAtIndex:destIndexPath.row];
        [self.arrCateList insertObject:object atIndex:oriIndexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"你不能拖动" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else {
        if (destIndexPath.row <= 2) {
            [self.arrCateList removeObjectAtIndex:destIndexPath.row];
            [self.arrCateList insertObject:object atIndex:3];
        } else {
            [self.arrCateList replaceObjectAtIndex:destIndexPath.row withObject:object];
        }
    }
    [self.viewCategoriesTBView reloadData];
}


#pragma mark - NSNoti methods
/**
 *  添加商品的回调方法
 *
 *  @param success 是否成功
 */
- (void)addProductSuccessFunc:(BOOL) success
{
    [self showSuccess:@"恭喜，商品发布成功！"];
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotiInternalProductRefresh) {
        if ([data isKindOfClass:[InternalProductModel class]]) {
            InternalProductModel *model = (InternalProductModel *)data;
            NSInteger indexFound = NSNotFound;
            for (int i = 0; i < self.arrProductList.count; i++) {
                InternalProductModel *modelTemp = self.arrProductList[i];
                if ([modelTemp.proId isEqualToString:model.proId]) {
                    indexFound = i;
                    break;
                }
            }
            if (indexFound != NSNotFound) {
                [self.arrProductList replaceObjectAtIndex:indexFound withObject:model];
                [self.viewProductTBView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexFound inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } else if (type == NotiAddProductSuccessCallback) {
        [self addProductSuccessFunc:YES];
    }
}

#pragma mark - UISegue action
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueChangeClassify"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        InternalProductChangeClassifyViewController *vc =[[navigationController viewControllers]objectAtIndex:0];
//        InternalProductChangeClassifyViewController *vc = (InternalProductChangeClassifyViewController *)segue.destinationViewController;
        vc.hidesBottomBarWhenPushed = YES;
        InternalProductModel *model = (InternalProductModel *)sender;
        vc.modelSelect = model;
    } else if ([segue.identifier isEqualToString:@"segueClassifyProducts"]) {
        InternalProductsInClassifyViewController *vc = (InternalProductsInClassifyViewController *)segue.destinationViewController;
        vc.hidesBottomBarWhenPushed = YES;
        InternalProductCateModel *model = (InternalProductCateModel *)sender;
//        model.classType = @"2";
        vc.modelCate = model;
    }
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
        strTip = @"确定取消该商品的推荐?";
    } else {
        strTip = @"确定推荐此商品?";
    }
    UIAlertView *inputAlertView = [[UIAlertView alloc] initWithTitle:strTip message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    __weak InternalProductListViewController *weakself = self;
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
    [self.viewProductTBView reloadData];
}

@end
