//
//  CoupnProductViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SlowCoupnProductViewController.h"
#import "SeachProductViewController.h"
#import "QYPhotoAlbum.h"
#import "SlowAddProductTableViewCell.h"
#import "Coupn.h"
#import "VerifyDetailViewController.h"
#import "AllScanReaderViewController.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"

#import "ShareContentModel.h"

@interface SlowCoupnProductViewController ()<UIActionSheetDelegate,UITextFieldDelegate,MyCustomCellDelegate>
{
    UISearchBar                 *searchBar;
    UIBarButtonItem             *searchBarButton;
}
@property(nonatomic,strong)NSMutableArray *dateSource;
@property(nonatomic,strong)NSMutableArray *addDataSource;//用来存放数组的传到前面的页面
@property(nonatomic,strong)NSMutableArray *hasSource;//用来判断扫码
@property(nonatomic,strong)NSString *json;
@end

@implementation SlowCoupnProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"所购商品";
    self.addTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.dateSource=[NSMutableArray array];
    self.addDataSource=[NSMutableArray array];
    self.hasSource=[NSMutableArray array];
    [self querySuit];
    
    self.textFiled.keyboardType =  UIKeyboardTypeDecimalPad;
    self.textFiled.delegate = self;
    
    searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBar_icon_scanCode"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonClick)];

    self.navigationItem.rightBarButtonItems = @[searchBarButton];
    
    
    
//    self.footView.frame = CGRectMake(0,SCREEN_H - 64 - 40, self.footView.frame.size.width, self.footView.frame.size.height);
//    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
//    line.backgroundColor=RGBHex(qwColor10);
//    [self.footView addSubview:line];
//    
//    [self.view addSubview:self.footView];
    
    [self registerLJWKeyboardHandler];
    
}

-(CouponProductVo *)changeModel:(ProductModel*)model{
    CouponProductVo *mod=[CouponProductVo new];
    mod.productId=model.proId;
    mod.productName=model.proName;
    mod.spec=model.spec;
    mod.factory=model.factory;
    mod.quantity=1;
    return mod;
}

-(BOOL)checkIshas:(CouponProductVo*)model{
    int j=0;
    for (CouponProductVo *mod in self.dateSource) {
        if([model.productId isEqualToString:mod.productId]){
            if(mod.isSelect){//如果以前被选中了
                 mod.isSelect=YES;
                 mod.quantity++;
            }else{
                 mod.isSelect=YES;
                 mod.quantity=1;
            }
            [self.dateSource insertObject:mod atIndex:0];
            [self.dateSource removeObjectAtIndex:j+1];
            return YES;
            break;
        }
        j++;
    }
    if(j==self.dateSource.count){
        return NO;
    }else{
        return YES;
    }
}
-(void)tablereload{
    [self.addTableView reloadData];
}

- (void)searchBarButtonClick
{
    if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
        [QWGLOBALMANAGER getCramePrivate];
        return;
    }
    AllScanReaderViewController *vc = [[AllScanReaderViewController alloc] init];
    vc.scanType=Enum_Scan_Items_Slow;
    vc.addSlowHasBlock = ^(ProductModel *productModel){
        CouponProductVo *model=[CouponProductVo new];
        model=[self changeModel:productModel];
        BOOL flag=[self checkIshas:model];//存在
        [self.addTableView reloadData];
        if(!flag){//不在
            return 1;
        }else{
            return 2;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
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
    
    
    if(textField == self.textFiled){
        
        if([string isEqualToString:@"."]){
            if(range.location==0){
                return NO;
            }else{
                if([self.textFiled.text rangeOfString:@"."].location ==NSNotFound){
                    return YES;
                }else{
                    return NO;
                }
            }
            
            
            
        }
        
        if([self stringNumber:string] || [string isEqualToString:@""]){
            NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
            if(range.location>19){
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
        }
    }
   
    
    
    return YES;
}


- (BOOL)stringNumber:(NSString *)str{
    
    NSString *c = @"^[0-9.]+$";
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",c];
    return [pre evaluateWithObject:str];
    
}


-(void)btnClick:(QWBaseTableCell *)cell andFlag:(int)flag andField:(NSString*)quantity

{
    
    NSIndexPath *index = [self.addTableView indexPathForCell:cell];
    switch (flag) {
        case 10:
        {
            CouponProductVo *model=(CouponProductVo*)self.dateSource[index.row];
            if(model.isSelect){
                model.isSelect=NO;
            }else{
                model.isSelect=YES;
                
                // 选中之后增加置顶功能
                
                [self.dateSource removeObject:model];
                [self.dateSource insertObject:model atIndex:0];
                [self.addTableView reloadData];

            }
        }
            break;
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
    
    [self.addTableView reloadData];
    
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(self.totalSum&&self.totalSum.length>0){
        self.textFiled.text=self.totalSum;
    }else{
       self.totalSum=self.textFiled.text;
    }
    
    if(self.textFiled.text.length>0){
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete"] forState:UIControlStateNormal];
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"btn_complete_click"] forState:UIControlStateHighlighted];
    }else{
        self.completeButton.backgroundColor=RGBHex(qwColor9);
    }
    [self.addTableView reloadData];
//    self.keyboardOpen = NO;
//    
//    if (self.viewBottomBarY == 0) {
//        self.viewBottomBarY = self.view.frame.size.height - self.footView.frame.size.height;
//        self.viewBottomBaRect =  CGRectMake(0,self.viewBottomBarY,
//                                            self.footView.frame.size.width,
//                                            self.footView.frame.size.height);
//        [self.footView setFrame:self.viewBottomBaRect];
//    }
    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnEmptyView)];
//    [self.view addGestureRecognizer:tap];
}
//键盘消失
- (void)tapOnEmptyView
{
    [self.textFiled resignFirstResponder];
}
//键盘相关
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    
//}


//- (void)keyboardWillShow:(NSNotification*)aNotification
//{
//    [self scrollViewForKeyboard:aNotification up:YES];
//}
//
//- (void)keyboardWillHide:(NSNotification*)aNotification
//{
//    [self scrollViewForKeyboard:aNotification up:NO];
//}


//- (void)scrollViewForKeyboard:(NSNotification*)aNotification up:(BOOL) up{
//    
//    if (aNotification!=nil) {
//        NSDictionary* userInfo = [aNotification userInfo];
//        
//        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
//        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
//        [[userInfo valueForKey:@"UIKeyboardCenterBeginUserInfoKey"] CGPointValue];
//        [[userInfo valueForKey:@"UIKeyboardCenterEndUserInfoKey"] CGPointValue];
//        
//        self.keyboardFrame = [[userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
//    }
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:self.animationDuration];
//    [UIView setAnimationCurve:self.animationCurve];
//    
//    float nowViewBottomBarY = (self.keyboardOpen && !up)?self.footView.frame.origin.y:self.viewBottomBarY;
//    
//    [self.footView setFrame:CGRectMake(self.footView.frame.origin.x,  nowViewBottomBarY + ((self.keyboardFrame.size.height) * (up?-1:1)), self.footView.frame.size.width, self.footView.frame.size.height)];
//    
//    self.keyboardOpen = up;
//    [UIView commitAnimations];
//}

- (void)popVCAction:(id)sender
{
    
    if(self.SlowCheckProduct){
        for (CouponProductVo *model in self.dateSource) {
            if(model.isSelect){
                [self.addDataSource addObject:model];
            }
        }
        self.SlowCheckProduct(self.addDataSource,self.textFiled.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma 完成订单
- (IBAction)compeleAction:(id)sender {
    //键盘收起
    [self.textFiled resignFirstResponder];
    
    
    if(self.textFiled.text){
        if(self.CoupnList.limitConsume<=[self.textFiled.text intValue]){
            for (CouponProductVo *model in self.dateSource) {
                if(model.isSelect){
                    [self.addDataSource addObject:model];
                }
            }
            
            if(self.addDataSource.count>0){
                if(self.SlowCheckProduct){
                    self.SlowCheckProduct(self.addDataSource,self.textFiled.text);
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"未添加商品" duration:0.5];
            }
            
            
            
//        VerifyDetailViewController *vc=[[VerifyDetailViewController alloc] initWithNibName:@"VerifyDetailViewController" bundle:nil];
//        vc.hidesBottomBarWhenPushed=YES;
//        for (CouponProductVo *model in self.dateSource) {
//            if(model.isSelect){
//                [self.addDataSource addObject:model];
//            }
//        }
//            if(self.addDataSource.count>0){
//                vc.array=self.addDataSource;
//                vc.total=self.textFiled.text;
//                vc.CoupnList=self.CoupnList;
//                vc.drugList=self.drugList;
//                vc.typeCell=self.typeCell;
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                [self showError:@"未选择商品"];
//            }
        }else{
            [SVProgressHUD showErrorWithStatus:Kwarning220N75 duration:2.0];
        }
    }

    
}
-(void)autoAdd{
    if(self.addDataSource){
        if(self.addDateSource.count){//从前面带过来的
            for(int i=0;i<self.addDateSource.count;i++)
            {
                int j=0;
                for (CouponProductVo *mod in self.dateSource) {
                    CouponProductVo *model=(CouponProductVo *)self.addDateSource[i];
                    if([model.productId isEqualToString:mod.productId]){
                        mod.quantity=model.quantity;
                        mod.isSelect=YES;
                        [self.dateSource exchangeObjectAtIndex:i withObjectAtIndex:j];
                        break;
                    }else{
                        j++;
                    }
                }
                
            }
        }
    }
    
}


-(void)querySuit{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    CoupnSuitModelR * modelR=[CoupnSuitModelR new];
    modelR.couponId=self.coupnId;
    
    [Coupn GetAllSuitableParams:modelR success:^(id responseObj) {
        CouponProductArrayVo *model = [CouponProductArrayVo parse:responseObj Elements:[CouponProductVo class] forAttribute:@"suitableProducts"];
        if(model.suitableProducts.count>0){
            [self.dateSource removeAllObjects];
            [self.dateSource addObjectsFromArray:model.suitableProducts];
            
            [self autoAdd];//自动赋值
            
            [self.addTableView reloadData];
        }else{
            [self showInfoView:@"暂无该慢病优惠券适用的商品" image:@"ic_img_fail"];
            
        }
        [self.addTableView.footer endRefreshing];
    } failure:^(HttpException *e) {
        [self.addTableView.footer endRefreshing];
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateSource.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [SlowAddProductTableViewCell getCellHeight:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CoupnIdentifier = @"AddProductCell";
    SlowAddProductTableViewCell *cell = (SlowAddProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CoupnIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"SlowAddProductTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CoupnIdentifier];
        cell = (SlowAddProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CoupnIdentifier];
       
    }
    cell.delegate=self;
    CouponProductVo *model=(CouponProductVo*)self.dateSource[indexPath.row];
    [cell setCell:model];
    return cell;

}


@end
