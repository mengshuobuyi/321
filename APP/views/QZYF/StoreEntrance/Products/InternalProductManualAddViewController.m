//
//  InternalProductManualAddViewController.m
//  wenYao-store
//
//  手输条形码页面
//  h5/bmmall/queryQwProduct
//
//  Created by PerryChen on 6/13/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductManualAddViewController.h"
#import "CustomProductInputTF.h"
#import "InternalProductSelectCell.h"
#import "InternalProductSubmitViewController.h"
#import "InternalProduct.h"

@interface InternalProductManualAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSearchHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet CustomProductInputTF *tfInputNumber;
@property (weak, nonatomic) IBOutlet UIView *viewNoContent;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (assign, nonatomic) NSInteger intSelectItem;

@property (nonatomic, strong) NSMutableArray *arrProducts;

@end

@implementation InternalProductManualAddViewController
static NSString *const InterProIdentifier = @"InternalProductSelectCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrProducts = [@[] mutableCopy];
    [self setupViewContent];
    [self.tbViewContent registerNib:[UINib nibWithNibName:@"InternalProductSelectCell" bundle:nil] forCellReuseIdentifier:InterProIdentifier];
    self.tbViewContent.rowHeight = 96.0f;
    self.intSelectItem = 0;
    [self.tfInputNumber becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)setupViewContent
{
    self.navigationItem.title = @"手输条形码";
    self.tfInputNumber.layer.cornerRadius = 4.0f;
    self.tfInputNumber.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.tfInputNumber.layer.borderWidth = 0.5;
    self.btnSearch.layer.cornerRadius = 4.0f;
}

/**
 *  获取接口内容
 */
- (void)getProducts
{
    InternalProductQueryQwProductModelR *modelR = [InternalProductQueryQwProductModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.barcode = self.tfInputNumber.text;
    [InternalProduct queryQwProduct:modelR success:^(InternalProductQueryQwProductListModel *responseModel) {
        if (responseModel.products.count > 0) {
//            [self.arrProducts addObjectsFromArray:responseModel.products];
            self.arrProducts = [NSMutableArray arrayWithArray:responseModel.products];
            self.intSelectItem = 0;
            [self showContentView:YES];
        } else {
            [self showContentView:NO];
        }
    } failure:^(HttpException *e) {
        
    }];
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

#pragma mark - Action methods
- (void)showContentView:(BOOL)show
{
    self.viewContent.hidden = YES;
    self.viewNoContent.hidden = YES;
    if (show) {
        self.viewContent.hidden = NO;
        [self.tbViewContent reloadData];
    } else {
        self.viewNoContent.hidden = NO;
    }
}

- (IBAction)actionSubmit:(id)sender {
    
    [self.tfInputNumber resignFirstResponder];
    if ([[self.tfInputNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        
        [self getProducts];
    } else {
        
    }
}

// 检查是否可以提交
- (BOOL)checkCanSubmit:(InternalProductQueryProductModel *)model
{
    BOOL canSubmit = YES;
    NSString *strAlert = @"";
    
    if ([model.flagForbid isEqualToString:@"Y"]) {
        strAlert = @"该商品已被禁售，不能添加";
        canSubmit = NO;
    } else {
        if (model.branchProId.length == 0)
        {
        } else {
            if ([model.status intValue] == 1) {
                strAlert = @"该商品已为待上架状态，不能重复添加";
                canSubmit = NO;
            } else if ([model.status intValue] == 2) {
                strAlert = @"该商品已在售，不能重复添加";
                canSubmit = NO;
            }
        }
    }

    if (canSubmit == NO) {
        [[[UIAlertView alloc] initWithTitle:@"" message:strAlert delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
    }
    return canSubmit;
}

/**
 *  添加商品走的函数
 *
 *  @param sender
 */
- (IBAction)actionAddProduct:(id)sender {
    if (self.intSelectItem >= 0) {
        InternalProductQueryProductModel *model = self.arrProducts[self.intSelectItem];
        if ([self checkCanSubmit:model] == YES) {
            InternalProductSubmitViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductSubmitViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.modelProduct = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [self showError:@"请先选择商品"];
    }
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InternalProductSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:InterProIdentifier];
    InternalProductQueryProductModel *model = [self.arrProducts objectAtIndex:indexPath.row];
    [cell setCell:model];
    cell.imgViewSelect.highlighted = NO;
    if (indexPath.row == self.intSelectItem) {
        cell.imgViewSelect.highlighted = YES;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrProducts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.intSelectItem) {
        if (self.intSelectItem >= 0) {
            self.intSelectItem = -1;
        } else {
            self.intSelectItem = indexPath.row;
        }
    } else {
        self.intSelectItem = indexPath.row;
    }
    [tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
