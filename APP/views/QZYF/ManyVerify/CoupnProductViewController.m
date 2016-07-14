//
//  CoupnProductViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CoupnProductViewController.h"
#import "SeachProductViewController.h"
//#import "AddScanReaderViewController.h"
#import "AllScanReaderViewController.h"
#import "QYPhotoAlbum.h"
#import "AddProductTableViewCell.h"
#import "Coupn.h"
#import "VerifyDetailViewController.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
@interface CoupnProductViewController ()<UIActionSheetDelegate,MyCustomCellDelegate>{
    int indexP;
}
@property(nonatomic,strong)NSMutableArray *dateSource;
@end

@implementation CoupnProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"所购商品";
    indexP=0;
    self.addTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.dateSource=[NSMutableArray array];
    self.addTableView.tableFooterView=self.centerView;//中间的添加按钮的显示
    //界面布局刚开始进入的布局
    if(self.addDateSource.count>0){
        self.dateSource=self.addDateSource;
        self.noneView.hidden=YES;
        self.addTableView.tableFooterView.hidden=NO;
        self.footView.hidden=NO;
        self.completeButton.backgroundColor=[UIColor orangeColor];
        if(indexP==0){
         [self registerLJWKeyboardHandler];
          indexP++;
        }
    }else{
        self.noneView.hidden=NO;
        self.footView.hidden=YES;
        self.addTableView.tableFooterView.hidden=YES;
        self.completeButton.backgroundColor=[UIColor grayColor];
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnEmptyView)];
    [self.view addGestureRecognizer:tap];
    
   
}
//键盘消失
- (void)tapOnEmptyView
{
    [self.total resignFirstResponder];
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated{
    [self.total resignFirstResponder];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(self.totalSum&&self.totalSum.length>0){//前面有値带过来
        self.total.text=self.totalSum;
    }else{
        self.totalSum=self.total.text;
    }

    if(self.total.text.length>0){
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete"] forState:UIControlStateNormal];
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete_click"] forState:UIControlStateHighlighted];
    }else{
        self.completeButton.backgroundColor=RGBHex(qwColor9);
    }

    self.total.keyboardType =  UIKeyboardTypeDecimalPad;
    self.total.delegate = self;
    
    //设置圆角和点击时候的颜色,橘黄色的（空数组时候的按钮）
    self.addSome.layer.masksToBounds=YES;
    self.addSome.layer.cornerRadius=3.0f;
    [self.addSome setBackgroundImage:[UIImage imageNamed:@"add_product"] forState:UIControlStateHighlighted];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@""]){//删除
        if(range.location==0){
            self.completeButton.backgroundColor=RGBHex(qwColor9);
            [self.completeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.completeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        }else {
            [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete"] forState:UIControlStateNormal];
            [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete_click"] forState:UIControlStateHighlighted];
        }
        
    }else if([string isEqualToString:@"."]||[string isEqualToString:@"0"]){
        if(range.location==0){
            self.completeButton.backgroundColor=RGBHex(qwColor9);
            [self.completeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.completeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        }else{
            [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete"] forState:UIControlStateNormal];
            [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete_click"] forState:UIControlStateHighlighted];
        }
        
    }else{
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete"] forState:UIControlStateNormal];
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete_click"] forState:UIControlStateHighlighted];
    }
    
    
    
    if(textField == self.total){
        
        if([string isEqualToString:@"."]){
            if(range.location==0){
                return NO;
            }else{
                if([self.total.text rangeOfString:@"."].location ==NSNotFound){
                    return YES;
                }else{
                    return NO;
                }
            } 
        }
        
        if([self stringNumber:string] || [string isEqualToString:@""]){
            NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
            if([string isEqualToString:@"0"]&&range.location==0){
                return NO;
            }else if(range.location>19){
                return NO;
            }
            [futureString  insertString:string atIndex:range.location];
            NSInteger flag=0;
            const NSInteger limited = 2;
            for (int i = futureString.length - 1; i>=0; i--) {
                if ([futureString characterAtIndex:i] == '.') {
                    if (flag > limited) {
                        return NO;
                    }
                    break;
                }
                flag++;
            }
            return YES;
        }
        else{
            return NO;
        }    }
    return YES;
}

- (BOOL)stringNumber:(NSString *)str{
    
    NSString *c = @"^[0-9.]+$";
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",c];
    return [pre evaluateWithObject:str];
    
}



//table加载时的情况
-(void)tablereload{
    if(self.dateSource.count>0){
        self.noneView.hidden=YES;
        self.addTableView.tableFooterView.hidden=NO;
        self.footView.hidden=NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        if(indexP==0){
            [self registerLJWKeyboardHandler];
            indexP++;
        }
    }else{
//        VerifyDetailViewController *vc=[[VerifyDetailViewController alloc] initWithNibName:@"VerifyDetailViewController" bundle:nil];
//        vc.array=[NSMutableArray array];
//        vc.total=@"";
        self.total.text=@"";
        self.totalSum=@"";
        self.completeButton.backgroundColor=RGBHex(qwColor9);
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        self.noneView.hidden=NO;
        self.addTableView.tableFooterView.hidden=YES;
        self.footView.hidden=YES;
    }
    [self.addTableView reloadData];

}

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag andField:(NSString*)quantity
{
    NSIndexPath *index = [self.addTableView indexPathForCell:cell];
    switch (flag) {
        case 11:
        {
            CouponProductVo *model=(CouponProductVo*)self.dateSource[index.row];
            if([quantity intValue]>1){
                model.quantity=quantity.intValue;
                model.quantity--;
            }
        }
            break;
        case 12:
        {
            //做加法
            CouponProductVo *model=(CouponProductVo*)self.dateSource[index.row];
            model.quantity=quantity.intValue;
            model.quantity ++;
        }
            break;
        default:
            break;
    }
    //刷新表格
    [self tablereload];
    
}
-(void)btnChange:(UITableViewCell *)cell andField:(NSString*)quantity{
    NSIndexPath *index = [self.addTableView indexPathForCell:cell];
    CouponProductVo *model=(CouponProductVo*)self.dateSource[index.row];
    if(quantity.length>0){
        model.quantity=quantity.intValue;
    }else{
        model.quantity=1;
    }
    
    
}

- (void)popVCAction:(id)sender
{

    if(self.CheckProduct){
        self.CheckProduct(self.dateSource,self.total.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}



//#define Kwarning220N75  @"顾客消费金额未达到此优惠劵使用标准，验证通过可能会影响结算"
- (IBAction)completeAction:(id)sender {
    [self.total resignFirstResponder];
    
    if(self.total.text&&self.dateSource){
        if(self.CoupnList.limitConsume<=[self.total.text intValue]){
            if(self.dateSource.count>0){
            if(self.CheckProduct){
                self.CheckProduct(self.dateSource,self.total.text);
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            }else{
                [SVProgressHUD showErrorWithStatus:@"未添加商品" duration:0.5];
            }
//            VerifyDetailViewController *vc=[[VerifyDetailViewController alloc] initWithNibName:@"VerifyDetailViewController" bundle:nil];
//            vc.hidesBottomBarWhenPushed=YES;
//            if(self.dateSource.count>0){
//                vc.array=self.dateSource;
//                vc.total=self.total.text;
//                vc.CoupnList=self.CoupnList;
//                vc.drugList=self.drugList;
//                vc.typeCell=self.typeCell;
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                [SVProgressHUD showErrorWithStatus:@"未添加商品" duration:0.5];
//            }
        }else{
            [SVProgressHUD showErrorWithStatus:Kwarning220N75 duration:2.0];
        }
    }

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)touchAdd:(id)sender {
    
     UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择添加来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从药品库搜索",@"扫描条形码",@"手动添加", nil];
    [sheet showInView:self.view];
}

-(BOOL)checkIshas:(CouponProductVo*)model{
    for (CouponProductVo *mod in self.dateSource) {
        if(model.productId){//不是手动添加的商品
            if([model.productId isEqualToString:mod.productId]){
                mod.quantity++;
                return YES;
            }
        }else{//是手动添加的商品
            if([model.productName isEqualToString:mod.productName]&&[model.spec isEqualToString:mod.spec]){
                mod.quantity++;
                return YES;
            }
        }
        
    }
    return NO;
}
-(CouponProductVo *)changeModel:(ProductModel*)model{
    CouponProductVo *mod=[CouponProductVo new];
    mod.productId=model.proId;
    mod.productName=model.proName;
    mod.spec=model.spec;
    mod.factory=model.factory;
    mod.quantity=1;
    mod.productLogo=model.imgUrl;
    return mod;
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {//从药品库添加药品
        SeachProductViewController *searchMedicineViewController = [[SeachProductViewController alloc] init];
        searchMedicineViewController.selectBlock = ^(CouponProductVo* dataRow){
            CouponProductVo *model=dataRow;
            BOOL ifhas=[self checkIshas:model];//NO不存在
            //没有是NO，然后就要添加，所以非
            if(!ifhas){
                [self.dateSource addObject:dataRow];
            }
            [self tablereload];
           
        };
        [self.navigationController pushViewController:searchMedicineViewController animated:NO];
    }else if (buttonIndex == 1){//扫描药品
        
        if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
            [QWGLOBALMANAGER getCramePrivate];
            return;
        }
        AllScanReaderViewController *vc = [[AllScanReaderViewController alloc]init];
        vc.scanType=Enum_Scan_Items_Common;
        vc.addCommonMedicineBlock= ^(ProductModel *productModel){
            CouponProductVo *model=[CouponProductVo new];
            model=[self changeModel:productModel];
            BOOL ifhas=[self checkIshas:model];
            //没有是NO，然后就要添加，所以非
            if(!ifhas){
                [self.dateSource addObject:model];
            }
            [self tablereload];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (buttonIndex == 2){//手动添加
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"secondCustomAlertView" owner:self options:nil];
        
        self.customAlertView = [nibViews objectAtIndex: 0];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [alertView setValue:self.customAlertView forKey:@"accessoryView"];
            
        }else{
            [alertView addSubview:self.customAlertView];
        }
        alertView.tag=56;
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==56){
        if(buttonIndex == 1)
        {
            NSString *drugName = self.customAlertView.textFieldName.text;
            drugName = [drugName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(drugName.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"药品名称的不能为空!" duration:0.8f];
                return;
            }else if(drugName.length > 20){
                [SVProgressHUD showErrorWithStatus:@"药品名称不能超过二十位!" duration:0.8f];
                return;
            }
            
            
            NSString *spec = self.customAlertView.specField.text;
            spec = [spec stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(spec.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"药品规格的不能为空!" duration:0.8f];
                return;
            }else if(spec.length > 20){
                [SVProgressHUD showErrorWithStatus:@"药品规格不能超过二十位!" duration:0.8f];
                return;
            }
            CouponProductVo *model=[CouponProductVo new];
            model.productName=drugName;
            model.spec=spec;

            BOOL ifhas=[self checkIshas:model];
            //没有是NO，然后就要添加，所以非
            if(!ifhas){
                [self.dateSource addObject:model];
            }
            [self.customAlertView removeFromSuperview];
            [self tablereload];
          
            
        }
    }
    
}


//tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateSource.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [AddProductTableViewCell getCellHeight:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CoupnIdentifier = @"AddProductCell";
    AddProductTableViewCell *cell = (AddProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CoupnIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"AddProductTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CoupnIdentifier];
        cell = (AddProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CoupnIdentifier];
    }
    cell.delegate=self;
    CouponProductVo *model=(CouponProductVo*)self.dateSource[indexPath.row];
    [cell setCell:model];
    return cell;

}



//////////滑动删除//////////

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:kWaring33];
        return;
    }
    [self.dateSource removeObjectAtIndex:indexPath.row];
    [self.addTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self tablereload];
}

@end
