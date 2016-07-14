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
@interface InternalProductListViewController ()<UITableViewDataSource,UITableViewDelegate,ComboxViewDelegate, UITextFieldDelegate, ProductlistCellDelegate>
{
    NSArray             *filtArray;
    NSArray             *btnArray;
    ComboxView          *filtView;
    RightAccessButton   *leftBtn;
    RightAccessButton   *rightBtn;
    NSInteger           leftIndex;
    NSInteger           rightIndex;
}
@property (weak, nonatomic) IBOutlet UIView *viewFilter;
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (strong, nonatomic) UITextField *groupNameTextField;  // 弹出库存框
@property (assign, nonatomic) NSInteger curPage;                // 记录当前页数
@property (nonatomic, strong) NSMutableArray *arrCateList;      // 类别列表
@property (nonatomic, strong) NSMutableArray *arrStatusList;    // 状态列表
@property (nonatomic, strong) NSMutableArray *arrProductList;   // 本店商品列表

@end

@implementation InternalProductListViewController
static NSString *const MenuIdentifier = @"MenuIdentifier";
static NSString *const InterProIdentifier = @"InternalProductListCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店内药品";
    [self setupRightItem];
    // 初始化数组
    [self initOriData];
    [self setupFilterView];
    [self.tbViewContent registerNib:[UINib nibWithNibName:@"InternalProductListCell" bundle:nil] forCellReuseIdentifier:InterProIdentifier];
    self.tbViewContent.rowHeight = 85.0f;
    self.view.backgroundColor = RGBHex(qwGcolor11);
    // 拉取类别列表
    [self getAllProductCateList];


    [self.tbViewContent addFooterWithCallback:^{
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
    [self getProductList];
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
            [self getProductList];
        }];
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
    self.arrCateList = [NSMutableArray arrayWithArray:@[cateModel]];
    self.arrStatusList = [NSMutableArray arrayWithArray:@[@"全部",@"已上架",@"已下架",@"库存为0"]];
    self.arrProductList = [[NSMutableArray alloc] init];
    self.curPage = 1;
    leftIndex = rightIndex = 0;
}

/**
 *  后两个是combox的代理方法
 *
 *  @param combox
 */
- (void)comboxViewDidDisappear:(ComboxView *)combox {
    switch (combox.tag /100) {
        case 1:
            if (leftBtn.isToggle) {
                [leftBtn toggleButtonWithAccessView];
            }
            break;
        case 2:
            if (rightBtn.isToggle) {
                [rightBtn toggleButtonWithAccessView];
            }
            break;
        default:
            break;
    }

}
- (void)comboxViewWillDisappear:(ComboxView *)combox{
    switch (combox.tag /100) {
        case 1:
            [leftBtn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
            break;
        case 2:
            [rightBtn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

/**
 *  设置过滤界面
 */
- (void)setupFilterView
{
    
    UIView *filtrateView = nil;
    
    if (![self.view viewWithTag:1008])
    {
        filtrateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 40)];
        filtrateView.userInteractionEnabled = YES;
        filtrateView.tag = 1008;
        filtrateView.backgroundColor = RGBHex(qwColor4);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(APP_W/2, 4, 0.5, 30)];
        line.backgroundColor = RGBHex(qwColor10);
        [filtrateView addSubview:line];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0,39.5,APP_W, 0.5)];
        line3.backgroundColor = RGBHex(qwColor10);
        [filtrateView addSubview:line3];
        
        leftBtn = [[RightAccessButton alloc]initWithFrame:CGRectMake(0, 0, APP_W/2, 40)];
        leftBtn.tag = 1;
        [filtrateView addSubview:leftBtn];
        
        rightBtn = [[RightAccessButton alloc]initWithFrame:CGRectMake(APP_W/2, 0, APP_W/2, 40)];
        rightBtn.tag = 2;
        [filtrateView addSubview:rightBtn];
        
        [leftBtn addTarget:self action:@selector(showFilt:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(showFilt:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *accessView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        UIImageView *accessView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        
        [accessView1 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        [accessView2 setImage:[UIImage imageNamed:@"icon_downArrow"]];
        
        leftBtn.accessIndicate = accessView1;
        rightBtn.accessIndicate = accessView2;
        
        [leftBtn setCustomColor:RGBHex(qwColor7)];
        [rightBtn setCustomColor:RGBHex(qwColor7)];
        
        [leftBtn setButtonTitle:@"分类"];
        [rightBtn setButtonTitle:@"状态"];
 
        btnArray = @[leftBtn,rightBtn];
 
    }else{
        filtrateView = (UIView *)[self.view viewWithTag:1008];
    }
    
    [self.view addSubview:filtrateView];
}

/**
 *  筛选按钮的点击事件
 *
 *  @param sender 点击的筛选按钮
 */
- (void)showFilt:(UIButton *)sender {
//    filtArray = allArray[sender.tag - 1];
    if (sender.tag == 1) {
        // 类别
        filtArray = self.arrCateList;
    } else {
        // 状态
        filtArray = self.arrStatusList;
    }
    RightAccessButton *btn = (RightAccessButton *)sender;
    [btn toggleButtonWithAccessView];
    //修正其他筛选箭头
    for (RightAccessButton *button in btnArray) {
        if (btn != button) {
            if (button.isToggle) {
                //若其他筛选是展开的，先将其他展开的箭头修正，再移除视图
                [button toggleButtonWithAccessView];
                [button setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
                [filtView dismissView];
            }
        }
    }
    if (!btn.isToggle) {
        [btn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        [filtView dismissView];
        return;
    }
    [btn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    NSInteger intRow = filtArray.count;
    if (intRow > 5) {
        intRow = 5;
    }
    filtView = [[ComboxView alloc] initWithFrame:CGRectMake(0, 40, APP_W, intRow*44)];
    filtView.tag = sender.tag *100;
    [filtView.tableView registerClass:[ComboxViewCell class] forCellReuseIdentifier:MenuIdentifier];
    filtView.tableView.rowHeight = 44.0f;
    filtView.delegate = self;
    filtView.comboxDeleagte = self;
    filtView.tableView.scrollEnabled = YES;
    [filtView showInView:self.view];
    
    if (sender.tag == 1) {
        [leftBtn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    }else if (sender.tag == 2){
        [rightBtn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    }
    
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
 *  点击导航栏右侧按钮事件
 */
- (void)rightAction
{
    UIStoryboard *sbProduct = [UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil];
    InternalProductSearchRootViewController *vc = [sbProduct instantiateViewControllerWithIdentifier:@"InternalProductSearchRootViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    switch (rightIndex) {
        case 0:     // 全部
        {
            modelR.status = @"0";
        }
            break;
        case 1:     // 上架
        {
            modelR.status = @"2";
        }
            break;
        case 2:     // 下架
        {
            modelR.status = @"3";
        }
            break;
        case 3:     // 库存为0
        {
            modelR.status = @"4";
        }
            break;
        default:
            break;
    }
    NSInteger curLeftIdx = leftIndex;
    if (self.arrCateList.count < leftIndex) {
        curLeftIdx = 0;
    }
    InternalProductCateModel *model = self.arrCateList[curLeftIdx];
    modelR.classifyId = model.classifyId;
    modelR.currPage = self.curPage;
    modelR.pageSize = 20;
    [InternalProduct queryInternalProducts:modelR success:^(InternalProductListModel *responseModel) {
        [self.tbViewContent.footer endRefreshing];
        [self removeInfoView];
        if (responseModel.list.count > 0) {
            [self.arrProductList addObjectsFromArray:responseModel.list];
            [self.tbViewContent reloadData];
        } else {
            if (self.curPage == 1) {
                [self showInfoView:@"暂无商品" image:@"ic_img_fail" flatY:40.0f];
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
 *  获取商品类别列表
 *
 */
- (void)getAllProductCateList
{
    InternalProductCateModelR *modelR = [InternalProductCateModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [InternalProduct queryInternalCates:modelR success:^(InternalProductCateListModel *responseModel) {
        [self.arrCateList addObjectsFromArray:responseModel.list];
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
    InternalProductModel *model = self.arrProductList[idx-100];
    modelR.proId = model.proId;
    [InternalProduct changeStock:modelR success:^(BaseAPIModel *responseModel) {
        
        if ([responseModel.apiStatus intValue] == 0) {
            InternalProductListCell *cell = [self.tbViewContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx-100 inSection:0]];
            cell.productStackLbl.text = [NSString stringWithFormat:@"库存%@",self.groupNameTextField.text];
            // 库存为0 且 用户修改的库存大于0
            if ((rightIndex == 3)&&([self.groupNameTextField.text intValue] > 0)) {
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

#pragma mark - UITableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == filtView.tableView) {
        return filtArray.count;
    }else {
        return self.arrProductList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == filtView.tableView) {
        ComboxViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuIdentifier];
        cell.separatorHidden = NO;
        cell.textLabel.font = fontSystem(qwFont4);
        cell.textLabel.textColor = RGBHex(qwColor1);
        
        switch (filtView.tag / 100) {
            case 1:
            {
                InternalProductCateModel *modelCate = self.arrCateList[indexPath.row];
                [cell setCellWithContent:modelCate.name showImage:leftIndex == indexPath.row];
            }
                break;
            case 2:
            {
                NSString *content = self.arrStatusList[indexPath.row];
                [cell setCellWithContent:content showImage:rightIndex == indexPath.row];
            }
                break;
            default:
                break;
        }
        return cell;
    }else  {
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
        cell.tag = indexPath.row+100;
        cell.delegate = self;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == filtView.tableView) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,0,APP_W, 0.5)];
        line.backgroundColor = RGBHex(qwColor10);
        return line;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == filtView.tableView) {
        UIView *bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 8)];
        bkView.backgroundColor = [UIColor clearColor];
        return bkView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == filtView.tableView) {
        return 0.0;
    }else {
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == filtView.tableView) {
        return 0.0;
    }else {
        return 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == filtView.tableView) {
        //点击筛选条件，筛选按钮相应变化
        NSInteger index = filtView.tag / 100;
        RightAccessButton *btn = (RightAccessButton *)[self.view viewWithTag:index];
        if (index == 1) {
            // 类别
            InternalProductCateModel *model = self.arrCateList[indexPath.row];
            [btn setButtonTitle:model.name];
            [btn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        } else {
            // 状态
            NSString *str = self.arrStatusList[indexPath.row];
            [btn setButtonTitle:str];
            [btn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        }
        
        
        [filtView dismissView];
        [btn toggleButtonWithAccessView];
        //记录哪个筛选框下选中的筛选条件位置
        switch (index) {
            case 1:
                leftIndex = indexPath.row;
                break;
            case 2:
                rightIndex = indexPath.row;
                break;
            default:
                break;
        }
        //根据筛选条件请求接口
        self.tbViewContent.footer.canLoadMore = YES;
        self.curPage = 1;
        [HttpClient sharedInstance].progressEnabled = YES;
        [self.arrProductList removeAllObjects];
        [self getProductList];
    }else {
        InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
        __block InternalProductModel *model = self.arrProductList[indexPath.row];
        vc.proId = model.proId;
        vc.updateModelBlock = ^(InternalProductModel *modelNew) {
            if (modelNew != nil) {
                [self.arrProductList replaceObjectAtIndex:indexPath.row withObject:modelNew];
                [self.tbViewContent reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
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
                [self.tbViewContent reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexFound inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
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
    [self showEditStackViewWithIndex:index];
}

@end
