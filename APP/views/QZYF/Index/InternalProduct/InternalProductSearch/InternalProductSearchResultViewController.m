//
//  InternalProductSearchResultViewController.m
//  wenYao-store
//
//  本店商品搜索结果页面
//  调用接口:
//  维护库存: UpdateInternalProductStock        h5/bmmall/updateStock
//
//  Created by PerryChen on 3/8/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductSearchResultViewController.h"
#import "InternalProductListCell.h"
#import "InternalProductDetailViewController.h"

@interface InternalProductSearchResultViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ProductlistCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (strong, nonatomic) UITextField *groupNameTextField;  // 弹出库存框
@property (assign, nonatomic) NSInteger curPage;
@end

@implementation InternalProductSearchResultViewController
static NSString *const InterProIdentifier = @"InternalProductListCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbViewContent registerNib:[UINib nibWithNibName:@"InternalProductListCell" bundle:nil] forCellReuseIdentifier:InterProIdentifier];
    self.tbViewContent.rowHeight = 85.0f;
    if (self.comeFromScan) {
        self.navigationItem.title = @"扫描结果";
    } else {
        self.navigationItem.title = @"搜索结果";
    }
    if (self.arrProduct.count == 0) {
        [self showInfoView:@"未能在此药房搜索到" image:@"ic_img_fail"];
    } else {
        [self.tbViewContent reloadData];
    }
    
    // Do any additional setup after loading the view.
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
    return self.arrProduct.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InternalProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:InterProIdentifier];
    InternalProductModel *model = self.arrProduct[indexPath.row];
    [cell setCell:model];
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
    __block InternalProductModel *model = self.arrProduct[indexPath.row];
    vc.proId = model.proId;
    vc.updateModelBlock = ^(InternalProductModel *modelNew) {
        [self.arrProduct replaceObjectAtIndex:indexPath.row withObject:modelNew];
        [self.tbViewContent reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 修改库存
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
        [self showError:kWaring12];
        return;
    }
    if (self.groupNameTextField.text.length == 0) {
        [self showError:@"请输入库存"];
        return;
    }
    
    InternalProductStockModelR *modelR = [InternalProductStockModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.stock = [self.groupNameTextField.text intValue];
    InternalProductModel *model = self.arrProduct[idx];
    modelR.proId = model.proId;
    [InternalProduct changeStock:modelR success:^(BaseAPIModel *responseModel) {
        if ([responseModel.apiStatus intValue] == 0) {
            InternalProductListCell *cell = [self.tbViewContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            cell.productStackLbl.text = [NSString stringWithFormat:@"库存%@",self.groupNameTextField.text];
            model.stock = [NSString stringWithFormat:@"%d",[self.groupNameTextField.text intValue]];
            [QWGLOBALMANAGER postNotif:NotiInternalProductRefresh data:model object:nil];
            [self showSuccess:@"修改成功"];
        } else {
            [self showError:responseModel.apiMessage];
        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];
}


#pragma mark - UITableview cell delegate
- (void)editStackAction:(NSInteger)index
{
    [self showEditStackViewWithIndex:index];
}

@end
