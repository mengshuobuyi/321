//
//  InternalProductSubmitViewController.m
//  wenYao-store
//
//  提交页面
//
//  Created by PerryChen on 6/13/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductSubmitViewController.h"
#import "XHImageViewer.h"
#import "XLCycleScrollView.h"
#import "InternalProductSubmitInfoCell.h"
#import "InternalProductSubmitCategoryCell.h"
#import "InternalProductSubmitPriceCell.h"
#import "InternalProductSubmitInventoryCell.h"
#import "CustomInternalProductSubmitCategoryView.h"
#import "InternalProduct.h"
#import "InternalProduct.h"
@interface InternalProductSubmitViewController ()<UITableViewDelegate, UITableViewDataSource,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,XHImageViewerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    UIImageView *brannerImage;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (strong, nonatomic) IBOutlet UIView *tfInputAssistView;
@property (weak, nonatomic) IBOutlet UILabel *lblTFAssistView;
@property (strong, nonatomic) XLCycleScrollView *cycleScrollView;

@property (strong, nonatomic) CustomInternalProductSubmitCategoryView *viewCategory;    // 选择类别页面
@property (assign, nonatomic) NSInteger intSelectItem;  // 选择的类别
@property (strong, nonatomic) NSString *priceStr;       // 价格
@property (strong, nonatomic) NSString *inventoryStr;   // 库存
@property (nonatomic, strong) NSMutableArray *arrCateList;      // 类别列表

@end

@implementation InternalProductSubmitViewController
typedef enum TableViewNumEnum
{
    Enum_productTitle = 0,      // 药品内容
    Enum_productCategory ,      // 类别
    Enum_productPrice,          // 价格
    Enum_productInventory,      // 库存
    Enum_tableCount             // cell 个数
}Enum_tableProduct;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeaderView];
    [self.tbViewContent reloadData];
    [self.cycleScrollView reloadData];
    self.navigationItem.title = @"添加商品";
    self.intSelectItem = -1;
    self.arrCateList = [@[] mutableCopy];
    self.viewCategory = (CustomInternalProductSubmitCategoryView *)[[NSBundle mainBundle] loadNibNamed:@"CustomInternalProductSubmitCategoryView" owner:self options:nil][0];
    [self getAllProductCateList];
    __weak typeof(self) wself = self;
    self.viewCategory.blockConfirm = ^(NSInteger idx) {
        wself.intSelectItem = idx;
        [wself.tbViewContent reloadData];
    };
    self.viewCategory.blockCancel = ^(){
        
    };
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textViewEditChanged:)
//                                                 name:UITextViewTextDidChangeNotification
//                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popVCAction:(id)sender
{
    [self showCancelConfirmation];
}

- (void)showCancelConfirmation
{
    UIAlertView *alertCancel = [[UIAlertView alloc] initWithTitle:@"" message:@"确定放弃添加商品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertCancel show];
}

#pragma mark - UIAlert view methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
        InternalProductCateModel *modelReco = [InternalProductCateModel new];
        modelReco.classifyId = self.modelProduct.categoryId;
        modelReco.name = self.modelProduct.categoryName;
        modelReco.isRecommend = YES;
        [self.arrCateList addObject:modelReco];
        [self.arrCateList addObjectsFromArray:responseModel.list];
        [self.viewCategory reloadPickerViewData:self.arrCateList];
    } failure:^(HttpException *e) {
    }];
}

/**
 *  设置键盘顶部view
 */
- (void)setTextFieldAssociateView:(UITextField *)tfView
{
    self.tfInputAssistView.frame = CGRectMake(0, 0, APP_W
                                              , 44.0f);
    tfView.inputAccessoryView = self.tfInputAssistView;
}

#pragma mark - UITableView methods
#pragma mark - 建立tableHeaderView
- (void)setupHeaderView{
    self.headerView.frame = CGRectMake(0, 0, APP_W, APP_W);
    self.cycleScrollView = [[XLCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_W)];
    self.cycleScrollView.tag = 1008;
    self.cycleScrollView.datasource = self;
    self.cycleScrollView.delegate = self;
    [self.cycleScrollView setupUIControl];
    CGFloat PCFrameX = (APP_W - self.cycleScrollView.pageControl.frame.size.width)/2;
    CGRect rect = self.cycleScrollView.pageControl.frame;
    rect.origin.x = PCFrameX;
    self.cycleScrollView.pageControl.frame = rect;

    [self.headerView addSubview:self.cycleScrollView];
    self.tbViewContent.tableHeaderView = self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == Enum_productTitle) {
        InternalProductSubmitInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InternalProductSubmitInfoCell"];
        cell.lblProductTitle.text = self.modelProduct.proName;
        cell.lblProductSpec.text = self.modelProduct.spec;
        cell.lblProductFactory.text = self.modelProduct.factory;
        return cell;
    } else if (indexPath.row == Enum_productCategory) {
        InternalProductSubmitCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InternalProductSubmitCategoryCell"];
        if (self.intSelectItem >= 0) {
            InternalProductCateModel *model = self.arrCateList[self.intSelectItem];
            cell.lblCategoryContent.text = model.name;
        } else {
            cell.lblCategoryContent.text = @"";
        }
        return cell;
    } else if (indexPath.row == Enum_productPrice) {
        InternalProductSubmitPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InternalProductSubmitPriceCell"];
        cell.tfPriceContent.delegate = self;
        cell.tfPriceContent.tag = Enum_productPrice;
        if (cell.tfPriceContent.inputAccessoryView == nil) {
            [self setTextFieldAssociateView:cell.tfPriceContent];
        }
        return cell;
    } else if (indexPath.row == Enum_productInventory) {
        InternalProductSubmitInventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InternalProductSubmitInventoryCell"];
        cell.tfProductInventory.delegate = self;
        cell.tfProductInventory.tag = Enum_productInventory;
        if (cell.tfProductInventory.inputAccessoryView == nil) {
            [self setTextFieldAssociateView:cell.tfProductInventory];
        }
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Enum_tableCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == Enum_productTitle) {
        return 91.0f;
    } else if (indexPath.row == Enum_productCategory) {
        return 44.0f;
    } else if (indexPath.row == Enum_productPrice) {
        return 44.0f;
    } else if (indexPath.row == Enum_productInventory) {
        return 44.0f;
    }
    return 0.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tbViewSelectRows:indexPath];
}

- (void)tbViewSelectRows:(NSIndexPath *)idxPath
{
    if (idxPath.row == Enum_productCategory) {
        [self showSelectCategoryView];
    } else if (idxPath.row == Enum_productPrice) {
        InternalProductSubmitPriceCell *cell = (InternalProductSubmitPriceCell *)[self.tbViewContent cellForRowAtIndexPath:idxPath];
        [cell.tfPriceContent becomeFirstResponder];
    } else if (idxPath.row == Enum_productInventory) {
        InternalProductSubmitInventoryCell *cell = (InternalProductSubmitInventoryCell *)[self.tbViewContent cellForRowAtIndexPath:idxPath];
        [cell.tfProductInventory becomeFirstResponder];
    }
}

- (void)showSelectCategoryView
{
    [self.view endEditing:YES];
    CGRect rectFrame = [[UIScreen mainScreen] bounds];
    self.viewCategory.frame = rectFrame;
    [[UIApplication sharedApplication].keyWindow addSubview:self.viewCategory];
    self.viewCategory.alpha = 0;
    [self.viewCategory reloadPickerViewData:self.arrCateList];
    [UIView animateWithDuration:0.5f animations:^{
        self.viewCategory.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - XLCycleScrollViewDataSource
- (NSInteger)numberOfPages{
    
    if(self.modelProduct!=nil){
        if(self.modelProduct.imgUrls.count == 0){
            return 1;
        }else{
            return self.modelProduct.imgUrls.count;
        }
    }else{
        return 1;
    }
}

- (UIView *)pageAtIndex:(NSInteger)index{
    
    brannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,APP_W, APP_W)];
    brannerImage.contentMode = UIViewContentModeScaleAspectFit;
    if(self.modelProduct!=nil){
        if(self.modelProduct.imgUrls.count == 0){
            [brannerImage setImage:[UIImage imageNamed:@"news_placeholder"]];
        }else{
            [brannerImage setImageWithURL:[NSURL URLWithString:self.modelProduct.imgUrls[index]] placeholderImage:[UIImage imageNamed:@"news_placeholder"]];
        }
    }else{
        [brannerImage setImage:[UIImage imageNamed:@"news_placeholder"]];
    }
        return brannerImage;
}
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    [self showFullScreenImage:index];
}

#pragma mark - Banner药品图片点击Action
- (void)showFullScreenImage:(NSInteger)currentIndex
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *imageList = [NSMutableArray array];
        for(NSString *imgUrl in self.modelProduct.imgUrls) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,APP_W, self.cycleScrollView.frame.size.height)];
            [imageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"news_placeholder"]];
            [imageList addObject:imageView];
            imageView.tag = [self.modelProduct.imgUrls indexOfObject:imgUrl];
        }

        UIImageView *imageView =  [self.cycleScrollView.curViews objectAtIndex:1];
        imageView.tag = currentIndex;
        [imageList replaceObjectAtIndex:currentIndex withObject:imageView];
        XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
        imageViewer.delegate = self;
        [imageViewer showWithImageViews:imageList selectedView:imageList[currentIndex]];
    });
}

#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView
{
    NSInteger index = selectedView.tag;
    if(index == self.cycleScrollView.currentPage) {
        return;
    }
    [self.cycleScrollView scrollAtIndex:index];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextField methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.viewCategory.superview != nil) {
        [self.viewCategory removeFromSuperview];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == Enum_productPrice) {
        // 不让其在第一位输入东西
        if (range.location == 0) {
            return NO;
        }
        if ( [string length] == 0 && range.length>1 ) return NO;    // 防止长按全部删除
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length == 0) {    // 不让其删除价格符号
            return NO;
        }
        
        if (textField.text.length == 2) {
            NSString *prefixStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
            if ([prefixStr isEqualToString:@"0"]) {
                // 当第一位是0时，只可以输入小数点
                if ([string isEqualToString:@"."]) {
                    
                } else {
                    // 替换掉0
                    NSString *replaceStr = [textField.text stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:string];
                    textField.text = replaceStr;
                    return NO;
                }
            }
        } else if (textField.text.length < 2) {
            // 当输入小数点时，前面默认加0
            if ([string isEqualToString:@"."]) {
                textField.text = @"￥0.";
                return NO;
            }
        }
        
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        // 不能输入两个或以上的点
        if([sep count] == 2)
        {
            NSString *sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
            return !([sepStr length]>2);
        } else if ([sep count] > 2) {
            return NO;
        }
        return YES;
    } else if (textField.tag == Enum_productInventory) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (textField.text.length == 1) {
            NSString *prefixStr = [textField.text substringWithRange:NSMakeRange(0, 1)];
            if ([prefixStr isEqualToString:@"0"]) {
                NSString *replaceStr = [textField.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:string];
                textField.text = replaceStr;
                return NO;
            }
        } else if (newString.length > 5) {
            return NO;
        }
        return YES;
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == Enum_productPrice) {
        // 价格默认小数点后两位
        if (textField.text.length > 1) {
            double floatValue = [textField.text substringFromIndex:1].doubleValue;
            NSString *newStr = [NSString stringWithFormat:@"￥%.2f",floatValue];
            textField.text = newStr;
            self.priceStr = [newStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
        }
    } else if (textField.tag == Enum_productInventory) {
        if (textField.text.length > 0) {
            self.inventoryStr = textField.text;
        }
    }
}

#pragma mark - action methods
- (BOOL)checkSubmitContent
{
    if (self.intSelectItem < 0) {
        [self showError:@"请选择商品分类"];
//        [self tbViewSelectRows:[NSIndexPath indexPathForRow:Enum_productCategory inSection:0]];
        return NO;
    }
    if (self.priceStr.length <= 0) {
        [self showError:@"请设置商品价格"];
//        [self tbViewSelectRows:[NSIndexPath indexPathForRow:Enum_productPrice inSection:0]];
        return NO;
    }
    if (self.inventoryStr.length <= 0) {
        [self showError:@"请设置商品库存"];
//        [self tbViewSelectRows:[NSIndexPath indexPathForRow:Enum_productInventory inSection:0]];
        return NO;
    }
    if (self.priceStr.floatValue == 0) {
        [self showError:@"商品价格不能为0"];
        return NO;
    }
    if (self.inventoryStr.intValue == 0) {
        [self showError:@"商品库存不能为0"];
        return NO;
    }
    return YES;
}

- (void)submitProduct
{

    InternalProductReleaseGoodsModelR *modelR = [InternalProductReleaseGoodsModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.proCode = self.modelProduct.proId;
    InternalProductCateModel *cateModel = self.arrCateList[self.intSelectItem];
    if (cateModel.isRecommend == YES) {
        modelR.recommendedCategory = @"Y";
    } else {
        modelR.recommendedCategory = @"N";
    }
    modelR.classId = cateModel.classifyId;
    modelR.price = self.priceStr;
    modelR.store = self.inventoryStr;
    [InternalProduct submitProduct:modelR success:^(InternalProductSubmitModel *responseModel) {
        if ([responseModel.apiStatus intValue] == 0) {
            [QWGLOBALMANAGER statisticsEventId:@"添加商品_发布商品" withLable:@"添加商品" withParams:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [QWGLOBALMANAGER postNotif:NotiAddProductSuccessCallback data:nil object:nil];
        } else {
            [self showError:responseModel.apiMessage];
        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];
}

- (IBAction)actionSubmit:(id)sender {
    [self.view endEditing:YES];
    if ([self checkSubmitContent]) {
        [QWGLOBALMANAGER statisticsEventId:@"s_tjsp_fbsp" withLable:@"本店商品" withParams:nil];
        [self submitProduct];
    } else {
        
    }
}

#pragma mark - Keyboard methods
- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    
    if (self.tbViewContent.contentSize.height > self.tbViewContent.bounds.size.height) {
        yOffset = self.tbViewContent.contentSize.height - self.tbViewContent.bounds.size.height;
    }
    
    [self.tbViewContent setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (void)keyboardChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.constraintBottom.constant = height;
        [self.view layoutIfNeeded];
        [self scrollToBottom];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.constraintBottom.constant = 0;
    [self.view layoutIfNeeded];
}

- (IBAction)actionDismissInput:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)actionConfirmInput:(id)sender {
    [self.view endEditing:YES];
}

@end
