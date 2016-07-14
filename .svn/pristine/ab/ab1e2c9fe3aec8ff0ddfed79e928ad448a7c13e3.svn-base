//
//  InternalProductDetailViewController.m
//  wenYao-store
//
//  本店商品详情页面
//  调用接口：查询详情：QueryInternalProductDetail       h5/bmmall/queryProductDetail
//          上架下架：UpdateInternalProductStatus      h5/bmmall/updateStatus
//          修改库存：UpdateInternalProductStock       h5/bmmall/updateStock
//          生成商品二维码URL：GetRefCode               h5/rpt/ref/getRefCode
//
//
//  Created by PerryChen on 3/8/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductDetailViewController.h"
#import "InternalProductSubtitleCell.h"
#import "InternalProductSubtitleWithAccessoryCell.h"
#import "InternalProductImgCell.h"
#import "InternalProductFootCell.h"
#import "InternalProductQRCodeViewController.h"
#import "RefCode.h"


#define CellStyleSubtitle           @"ProductSubtitleCell"
#define CellStyleSubAndAccessory    @"ProductSubtitleWithAcceCell"
#define CellStyleOnlyImg            @"ProductImgCell"
#define CellStyleFoot               @"ProductFootCell"


@interface InternalProductDetailViewController ()<UITableViewDataSource, UITableViewDelegate, InternalProductFootDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (strong, nonatomic) UITextField *groupNameTextField;  // 弹出库存框

@end

@implementation InternalProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tbViewContent.rowHeight = UITableViewAutomaticDimension;
    self.tbViewContent.estimatedRowHeight = 44.0f;
    self.navigationItem.title = @"商品详情";
    [self setupRightItem];
    if (self.productModel == nil) {
        [self getProductDetail];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
}

/**
 *  设置导航栏右上角
 */
- (void)setupRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 5, 50, 50);
    [button setImage:[UIImage imageNamed:@"icon_product_share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[fixed,rightItem];
}
/**
 *  分享
 */
- (void)shareAction
{
    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [self showError:@"网络异常，请稍后重试"];
    } else {
        [self getRefIDRequestWithChannel:@"2" Block:^(NSString *strRefID) {
            NSString *str = strRefID;
            ShareContentModel *modelShare = [ShareContentModel new];
            modelShare.title = self.productModel.name;
            modelShare.imgURL = self.productModel.imgUrl;
            modelShare.shareLink = str;
            modelShare.typeShare = ShareTypeInternalProduct;
            [self popUpShareView:modelShare];
        }];
    }
}

#pragma mark - UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.productModel == nil) {
        return 0;
    } else {
        return 9;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {   // 图片cell
        return [self calculateOnlyImgCellHeightWithIndexPath:indexPath];
    } else if (indexPath.row == 8) {    // 底部按钮cell
        return [self calculateFootCellHeightWithIndex:indexPath];
    } else if (indexPath.row != 4) {    // 非库存cell
        return [self calculateSubtitleCellHeightWithIndexPath:indexPath];
    } else {    // 库存cell
        return [self calculateSubAndAccessoryCellHeightWithIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 图片cell
        InternalProductImgCell *cell = [self setOnlyImgCellContentWithIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 8) {
        // 底部按钮cell
        InternalProductFootCell *cell = [self setFootCellContentWithIndexPath:indexPath];
        return cell;
    } else if (indexPath.row != 4) {
        // 非库存cell
        InternalProductSubtitleCell *cell = [self setSubtitleCellContentWithIndexPath:indexPath];
        return cell;
    } else {
        // 库存cell
        InternalProductSubtitleWithAccessoryCell *cell = [self setSubAndAccessoryCellContentWithIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        if (AUTHORITY_ROOT) {
            // 店长
            [self showEditStackViewWithIndex];
        }
    }
}

#pragma mark - tableview assist methods
/**
 *  设置仅带副标题的cell
 *
 *  @param idxPath index
 */
- (InternalProductSubtitleCell *)setSubtitleCellContentWithIndexPath:(NSIndexPath *)idxPath
{
    InternalProductSubtitleCell *cellSubtitle = [self.tbViewContent dequeueReusableCellWithIdentifier:CellStyleSubtitle];
    [self configureSubtitleCell:cellSubtitle withIndex:idxPath];
    return cellSubtitle;
}

/**
 *  设置带副标题和向右箭头的cell 如库存
 *
 *  @param idxPath index
 */
- (InternalProductSubtitleWithAccessoryCell *)setSubAndAccessoryCellContentWithIndexPath:(NSIndexPath *)idxPath
{
    InternalProductSubtitleWithAccessoryCell *cell = [self.tbViewContent dequeueReusableCellWithIdentifier:CellStyleSubAndAccessory];
    [self configureSubAndAccessCell:cell withIndex:idxPath];
    return cell;
}

/**
 *  设置图片cell
 *
 *  @param idxPath index
 */
- (InternalProductImgCell *)setOnlyImgCellContentWithIndexPath:(NSIndexPath *)idxPath
{
    InternalProductImgCell *cell = [self.tbViewContent dequeueReusableCellWithIdentifier:CellStyleOnlyImg];
    [self configureImgCell:cell withIndex:idxPath];
    return cell;
}

/**
 *  设置底部cell
 *
 *  @return
 */
- (InternalProductFootCell *)setFootCellContentWithIndexPath:(NSIndexPath *)idxPath
{
    InternalProductFootCell *cell = [self.tbViewContent dequeueReusableCellWithIdentifier:CellStyleFoot];
    cell.delegate = self;
    if ([self.productModel.status intValue] == 2) {
        // 上架状态
        cell.switchOnLabel.text = @"下架";
    } else {
        // 下架状态
        cell.switchOnLabel.text = @"上架";
    }
    [self configureFooterCell:cell withIndex:idxPath];
    
    return cell;
}

/**
 *  计算带副标题的cell高度
 *
 *  @param idxPath index
 *
 *  @return height
 */
- (CGFloat)calculateSubtitleCellHeightWithIndexPath:(NSIndexPath *)idxPath
{
    static InternalProductSubtitleCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tbViewContent dequeueReusableCellWithIdentifier:CellStyleSubtitle];
    });
    [self configureSubtitleCell:sizingCell withIndex:idxPath];
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tbViewContent.bounds), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize sizeFinal = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return sizeFinal.height+1;
}

/**
 *  计算带副标题和右箭头的cell高度
 *
 *  @param idxPath index
 *
 *  @return height
 */
- (CGFloat)calculateSubAndAccessoryCellHeightWithIndexPath:(NSIndexPath *)idxPath
{
    static InternalProductSubtitleWithAccessoryCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tbViewContent dequeueReusableCellWithIdentifier:CellStyleSubAndAccessory];
    });
    [self configureSubAndAccessCell:sizingCell withIndex:idxPath];
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tbViewContent.bounds), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize sizeFinal = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return sizeFinal.height+1;
}

/**
 *  计算只带图片的cell高度
 *
 *  @param idxPath index
 *
 *  @return height
 */
- (CGFloat)calculateOnlyImgCellHeightWithIndexPath:(NSIndexPath *)idxPath
{
    static InternalProductImgCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tbViewContent dequeueReusableCellWithIdentifier:CellStyleOnlyImg];
    });
    [self configureImgCell:sizingCell withIndex:idxPath];
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tbViewContent.bounds), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize sizeFinal = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return sizeFinal.height;
}

/**
 *  计算底部cell高度
 *
 *  @return height
 */
- (CGFloat)calculateFootCellHeightWithIndex:(NSIndexPath *)idxPath
{
    static InternalProductFootCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tbViewContent dequeueReusableCellWithIdentifier:CellStyleFoot];
    });
    [self configureFooterCell:sizingCell withIndex:idxPath];
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tbViewContent.bounds), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize sizeFinal = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return sizeFinal.height;
}

/**
 *  设置图片cell内容
 *
 *  @param cell
 *  @param idxPath
 */
- (void)configureImgCell:(InternalProductImgCell *)cell withIndex:(NSIndexPath *)idxPath
{
//    cell.constraintHeight.constant = APP_W * 215.0 / 320.0;
    [cell.imgViewContent setImageWithURL:[NSURL URLWithString:self.productModel.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"]];
    if ([self.productModel.status intValue] == 2) { // 上架
        cell.imgViewSwitchOff.hidden = YES;
    } else {
        cell.imgViewSwitchOff.hidden = NO;
    }
}

/**
 *  设置子标题cell内容
 *
 *  @param cell
 *  @param idxPath
 */
- (void)configureSubtitleCell:(InternalProductSubtitleCell *)cell withIndex:(NSIndexPath *)idxPath
{

    switch (idxPath.row) {
        case 1:     // 商品cell
        {
            cell.titleLabel.text = @"商品";
            cell.contentLabel.text = self.productModel.name;
        }
            break;
        case 2:     // 规格cell
        {
            cell.titleLabel.text = @"规格";
            cell.contentLabel.text = self.productModel.spec;
        }
            break;
        case 3:     // 单价cell
        {
            cell.titleLabel.text = @"单价";
            cell.contentLabel.text = [NSString stringWithFormat:@"￥ %@",self.productModel.price];
        }
            break;
        case 5:     // 优惠cell
        {
            cell.titleLabel.text = @"优惠";
            if ([self.productModel.inPromotion boolValue]) {
                cell.contentLabel.text = @"有";
            } else {
                cell.contentLabel.text = @"无";
            }
        }
            break;
        case 6:     // 国际条码cell
        {
            cell.titleLabel.text = @"国际条码";
            cell.contentLabel.text = self.productModel.barcode;
        }
            break;
        case 7:     // 生产企业cell
        {
            cell.titleLabel.text = @"生产企业";
            cell.contentLabel.text = self.productModel.factory;
        }
            break;
        default:
            break;
    }
}

/**
 *  设置带右箭头子标题cell内容
 *
 *  @param cell
 *  @param idxPath
 */
- (void)configureSubAndAccessCell:(InternalProductSubtitleWithAccessoryCell *)cell withIndex:(NSIndexPath *)idxPath
{
    cell.titleLabel.text = @"库存";
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.productModel.stock];
    if (AUTHORITY_ROOT) {
        // 店长
        cell.rightArrowImgView.hidden = NO;
    } else {
        cell.rightArrowImgView.hidden = YES;
    }
}

/**
 *  设置底部的上下架cell
 *
 *  @param cell
 *  @param idxPath
 */
- (void)configureFooterCell:(InternalProductFootCell *)cell withIndex:(NSIndexPath *)idxPath
{
    if (AUTHORITY_ROOT) {
        // 店长
        cell.constraintSwitchViewHeight.constant = 40.0f;
        cell.constraintSwitchViewBottom.constant = 22.0f;
        cell.constraintSwitchViewTop.constant = 15.0f;
        cell.switchOnView.hidden = NO;
        if ([self.productModel.inPromotion boolValue]) {
            // 有优惠下架按钮置灰
            cell.btnSwitchOn.enabled = NO;
            cell.switchOnLabel.textColor = RGBHex(qwMcolor4);
            cell.switchOnView.backgroundColor = RGBHex(qwGcolor9);
            cell.switchOnView.layer.borderColor = RGBHex(qwGcolor9).CGColor;
        } else {
            // 没优惠
            cell.btnSwitchOn.enabled = YES;
            cell.switchOnLabel.textColor = RGBHex(qwMcolor2);
            cell.switchOnView.backgroundColor = RGBHex(qwGcolor11);
            cell.switchOnView.layer.borderColor = RGBHex(qwMcolor2).CGColor;
        }
    } else {
        // 子账号隐藏下架按钮
        cell.constraintSwitchViewHeight.constant = 0.0f;
        cell.constraintSwitchViewBottom.constant = 0.0f;
        cell.constraintSwitchViewTop.constant = 15.0f;
        cell.switchOnView.hidden = YES;
    }
}

#pragma mark - cell delegate
/**
 *  生成二维码的点击事件
 */
- (void)generateAction
{
    [self getRefIDRequestWithChannel:@"1" Block:^(NSString *strRefID) {
        InternalProductQRCodeViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductQRCodeViewController"];
        vc.qrCodeURL = strRefID;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

/**
 *  上下架操作
 */
- (void)switchAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    alert.tag = 1002;
    if ([self.productModel.status intValue] == 2) {
        // 商品已上架
        alert.title = @"确认下架该商品吗?";
    } else {
        // 商品已下架
        alert.title = @"确认上架该商品吗?";
    }
    [alert show];
}

/**
 *  获取商品详情
 *
 *  @return
 */
- (void)getProductDetail
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    InternalProductDetailModelR *modelR = [InternalProductDetailModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.proId = self.proId;
    [InternalProduct queryInternalProductDetail:modelR success:^(InternalProductModel *responseModel) {
        [self removeInfoView];
        if (responseModel!= nil) {
            self.productModel = responseModel;
            [self.tbViewContent reloadData];
        } else {
            [self showInfoView:@"暂无数据" image:@"ic_img_fail"];
        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];
}

#pragma mark - 修改库存
/**
 *  展示修改库存页面
 */
- (void)showEditStackViewWithIndex
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
    [bgView addSubview:self.groupNameTextField];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        [alert setValue:bgView forKey:@"accessoryView"];
    }else{
        [alert addSubview:bgView];
    }
    [alert show];
}

#pragma mark ---- UIAlertViewDelegate ----
- (void)showKeyboard
{
    [self.groupNameTextField becomeFirstResponder];
}

/**
 *  修改库存的接口和界面操作
 */
- (void)changeStock
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:@"系统异常，请稍后再试"];
        return;
    }
    if (self.groupNameTextField.text.length == 0) {
        [self showError:@"请输入库存"];
        return;
    }
    InternalProductStockModelR *modelR = [InternalProductStockModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.stock = [self.groupNameTextField.text intValue];
    modelR.proId = self.productModel.proId;
    [InternalProduct changeStock:modelR success:^(BaseAPIModel *responseModel) {
        
        if ([responseModel.apiStatus intValue] == 0) {
            [self showSuccess:@"修改成功"];
            InternalProductSubtitleWithAccessoryCell *cell = [self.tbViewContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            cell.contentLabel.text = self.groupNameTextField.text;
            self.productModel.stock = self.groupNameTextField.text;
            if (self.updateModelBlock) {
                self.updateModelBlock(self.productModel);
            }
        } else {
            [self showError:responseModel.apiMessage];
        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];
}

/**
 *  获取refID的请求
 *
 *  @param getRefIDBlock 回调block
 */
- (void)getRefIDRequestWithChannel:(NSString *)channel Block:(void (^)(NSString *strRefID))getRefIDBlock
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:kWaring12];
        return;
    }
    RefCodeModelR *modelR = [RefCodeModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.objType = @"2";
    modelR.objId = self.productModel.proId;
    modelR.channel = channel;
    [RefCode queryRefCode:modelR success:^(RefCodeModel *responseModel) {
        if ([responseModel.apiStatus intValue] == 0) {
            if (getRefIDBlock) {
                getRefIDBlock(responseModel.url);
            }
        } else {
            [self showError:responseModel.apiMessage];
        }
    } failure:^(HttpException *e) {
        [self showError:@"系统异常，请稍后再试"];
    }];

}

/**
 *  修改商品状态的接口和界面操作
 */
- (void)changeStatus
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:kWaring12];

        return;
    }
    InternalProductStatusModelR *modelR = [InternalProductStatusModelR new];
    modelR.proId = self.productModel.proId;
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    if ([self.productModel.status intValue] == 2) {
        modelR.status = @"3"; // 下架操作
    } else {
        modelR.status = @"2"; // 上架操作
    }
    [InternalProduct changeStatus:modelR success:^(BaseAPIModel *responseModel) {
        if ([responseModel.apiStatus intValue] == 0) {
            if ([self.productModel.status intValue] == 2) {
                self.productModel.status = @"3"; // 显示下架状态
            } else {
                self.productModel.status = @"2"; // 显示上架状态
            }
//            [self.tbViewContent reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tbViewContent reloadData];
            [self.tbViewContent scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            if (self.updateModelBlock) {
                self.updateModelBlock(self.productModel);
            }
            [self showSuccess:responseModel.apiMessage];
        } else {
            [self showError:responseModel.apiMessage];
        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        // 修改库存alert
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self changeStock];
        }
    } else if (alertView.tag == 1002) {
        // 修改商品状态alert
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self changeStatus];
        }
    }
}

@end
