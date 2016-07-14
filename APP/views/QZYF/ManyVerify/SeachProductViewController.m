//
//  SeachProductViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SeachProductViewController.h"
#import "SuitProductTableViewCell.h"
#import "SVProgressHUD.h"
#import "TagCollectionView.h"
#import "MJRefresh.h"
#import "Drug.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
@interface SeachProductViewController ()<UISearchBarDelegate,
UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,
UITextFieldDelegate>
{
    UITextField         *alertTextField;
    UIButton *contentView;
    UILabel *lable;
    int currentPage;
    //搜索历史
    UIView *  footView;
    
}
@property (nonatomic, strong) UISearchBar   *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *resultArray;
@property (nonatomic, strong) CouponProductVo    *model;
@property (nonatomic, strong) NSMutableArray    *searchHistoryArray;

@end

@implementation SeachProductViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
    //隐藏左上角的返回
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItems = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (iOSv7 && self.view.frame.origin.y==0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.resultArray = [NSMutableArray arrayWithCapacity:15];
    self.searchHistoryArray = [NSMutableArray arrayWithCapacity:15];
    
    [self setupTableView];
    [self setupHeaderView];
    [self setUpTableViewFootView];
    
    
    [self setupSearchBar];
    //控制搜索历史
    [self keyWordSet];
    [self.navigationItem setHidesBackButton:YES];
    [self registerNotification];
    
}


- (void)setupTableView
{
  
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H - NAV_H) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:RGBHex(qwColor11)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开加载更多数据了";
    self.tableView.footerRefreshingText = @"正在帮你加载中";
    currentPage = 1;
    [self.view addSubview:self.tableView];
}
//设置搜索历史
- (void)keyWordSet
{
    //搜索关键字不存在
    if (self.searchBar.text == nil ||self.searchBar.text.length == 0)  {
        self.searchHistoryArray = [[NSMutableArray alloc] initWithArray:getHistoryConfig(@"coupnSearch")];
        //如果有搜索历史
        if (self.searchHistoryArray.count > 0) {
            self.tableView.tableFooterView=footView;
        }else{
            self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        }
    }else{
        self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        currentPage = 1;
        [self queryMedicineWithKeyword:self.searchBar.text];
    }
    [self.tableView reloadData];
}

- (void)setupHeaderView
{
    contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, APP_W, 44)];
    [contentView setBackgroundColor:RGBHex(qwColor15)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 260, 20)];
    label.font = [UIFont systemFontOfSize:kFontS1];
    label.text = @"搜索不到？试试手动添加吧~";
    label.textColor = RGBHex(qwColor4);
    [contentView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W-30,15, 15, 15)];
    imageView.image=[UIImage imageNamed:@"ic_btn_listarrow"];
    [contentView addSubview:imageView];
    
    [contentView addTarget:self action:@selector(showManualInput:) forControlEvents:UIControlEventTouchDown];
}


//进入的时候关键字为空，加入最近搜索的lable
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , APP_W, 39)];
    v.backgroundColor = RGBHex(qwColor11);
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15,18,200,12)];
    label.font = [UIFont systemFontOfSize:kFontS5];
    label.textColor=RGBHex(qwColor8);
    label.text = @"搜索历史";
    [v addSubview:label];
    return v;
}


- (void)onClearBtnTouched:(UIButton *)button{
    [self.searchHistoryArray removeAllObjects];
    self.searchBar.text = @"";
    setHistoryConfig(@"coupnSearch",nil);
    [self keyWordSet];
}

- (void)setUpTableViewFootView{
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 46)];
    footView.backgroundColor = [UIColor whiteColor];
    footView.clipsToBounds = YES;
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_trash"]];
    image.frame = CGRectMake(APP_W*0.35 - 20, 15, 15, 15);
    
    UIButton * clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(image.frame.origin.x + 7, 15, 100, 15)];
    clearBtn.titleLabel.font = fontSystem(kFontS1);
    [clearBtn setTitle:@"清空搜索历史" forState:0];
    [clearBtn setTitleColor:RGBHex(qwColor8) forState:0];
    [clearBtn setBackgroundColor:[UIColor clearColor]];
    [clearBtn addTarget:self action:@selector(onClearBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:image];
    [footView addSubview:clearBtn];
}


- (void)setupSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 265,44)];
    self.searchBar.placeholder = @"请输入搜索名称";
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = RGBHex(qwColor4);
    self.searchBar.tintColor = [UIColor blueColor];
    self.navigationItem.titleView = self.searchBar;
    
    //回退按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToPrevious:)];
}


- (void)backToPrevious:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)footerRereshing{
    currentPage ++;
    [self queryMedicineWithKeyword:self.searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self queryMedicineWithKeyword:searchText];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(searchBar.text.length == 0 && ![text isEqualToString:@""]) {
        [self.tableView reloadData];
    }else if(searchBar.text.length == 1 && [text isEqualToString:@""]) {
        [self.tableView reloadData];
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}



- (void)queryMedicineWithKeyword:(NSString *)keyword
{
    if([keyword isEqualToString:@""]) {
        [self.resultArray removeAllObjects];
         self.tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView reloadData];
        return;
    }
    __weak SeachProductViewController *weakSelf = self;
    
    QueryProductByKeywordModelR *queryProductByKeywordModelR = [QueryProductByKeywordModelR new];
    queryProductByKeywordModelR.keyword = keyword;
    queryProductByKeywordModelR.currPage = [NSString stringWithFormat:@"%d",currentPage];
    queryProductByKeywordModelR.pageSize = @"10";
    queryProductByKeywordModelR.type = @"1";
    //新增城市和省
    queryProductByKeywordModelR.province=@"江苏省";
    queryProductByKeywordModelR.city=@"苏州市";
    
    [Drug queryProductByKeywordWithParam:queryProductByKeywordModelR Success:^(id array) {
        if(currentPage == 1){
            [weakSelf.resultArray removeAllObjects];
        }
        [weakSelf.resultArray addObjectsFromArray:array];
        [weakSelf.tableView footerEndRefreshing];
        if(weakSelf.resultArray.count==0){
          self.tableView.tableHeaderView=contentView;
        }else{
          self.tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        }
         self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [weakSelf.tableView reloadData];
    } failure:^(HttpException *e) {
        [weakSelf.tableView footerEndRefreshing];
    }];
}



- (void)dealloc
{
    [self unregisterNotification];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    CGFloat keyboardHeight = keyboardBounds.size.height;
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    rect.size.height -= keyboardHeight;
    self.tableView.frame = rect;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.tableView.frame = rect;
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length >= 20 && ![string isEqualToString:@""])
        return NO;
    return YES;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchBar.text==nil||self.searchBar.text.length == 0) {
        return 46.0f;
    }else{
        return [SuitProductTableViewCell getCellHeight:nil];
    }
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.searchBar.text==nil||self.searchBar.text.length == 0) {
        return self.searchHistoryArray.count;
    }else{
        return self.resultArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(atableView.contentOffset.y != 0){
        [self.searchBar resignFirstResponder];
    }
    if (self.searchBar.text==nil||self.searchBar.text.length == 0) {
        static NSString * cellIdentifier = @"cellIdentifier";
        UITableViewCell * cell = [atableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            CGRect rect = cell.textLabel.frame;
            rect.origin.x = 15.0f;
            cell.textLabel.frame = rect;
        }
        cell.textLabel.text = self.searchHistoryArray[indexPath.row];
        cell.textLabel.font = fontSystem(kFontS1);
        cell.textLabel.textColor = RGBHex(qwColor6);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45.5, APP_W, 0.5)];
        line.backgroundColor = RGBHex(qwColor10);
        [cell addSubview:line];
        return cell;
    }else{
        static NSString *SecondProductCell = @"SuitProductCell";
        SuitProductTableViewCell *cell = (SuitProductTableViewCell *)[atableView dequeueReusableCellWithIdentifier:SecondProductCell];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"SuitProductTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:SecondProductCell];
            cell = (SuitProductTableViewCell *)[atableView dequeueReusableCellWithIdentifier:SecondProductCell];
        }
        QueryProductByKeywordModel *model=self.resultArray[indexPath.row];
        [cell setSearchCell:model];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
     if (self.searchBar.text==nil||self.searchBar.text.length == 0) {
         NSString * historyKeyWord = self.searchHistoryArray[indexPath.row];
         self.searchBar.text = historyKeyWord;
         [self keyWordSet];
         if ([self.delegate respondsToSelector:@selector(searchBarText:)]) {
             [self.delegate searchBarText:historyKeyWord];
         }
    }else{
//        #define Kwarning220N66  @"商品添加成功"
        QueryProductByKeywordModel *productByKeywordModel = self.resultArray[indexPath.row];
        if(self.selectBlock)
        {
            self.selectBlock([self changeModel:productByKeywordModel]);
            [SVProgressHUD showSuccessWithStatus:Kwarning220N66 duration:0.8];
            if ([self.searchHistoryArray containsObject:self.searchBar.text]) {
                [self.searchHistoryArray removeObject:self.searchBar.text];
            }
            if (self.searchHistoryArray.count == 5) {
                [self.searchHistoryArray removeObjectAtIndex:self.searchHistoryArray.count-1];
            }
            
            [self.searchHistoryArray insertObject:self.searchBar.text atIndex:0];
            setHistoryConfig(@"coupnSearch", self.searchHistoryArray);
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }


}

- (void)searchBarText:(NSString *)text
{
    self.searchBar.text = text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchBar.text==nil||self.searchBar.text.length == 0) {
        if(self.searchHistoryArray.count>0){
            return 39;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}



-(CouponProductVo *)changeModel:(QueryProductByKeywordModel*)model{
    CouponProductVo *mod=[CouponProductVo new];
    mod.productId=model.proId;
    mod.productName=model.proName;
    mod.productLogo=model.imgUrl;
    mod.factory=model.factory;
    mod.spec=model.spec;
    mod.quantity=1;
    return mod;
}


- (void)showManualInput:(id)sender
{
//    [self.searchBar resignFirstResponder];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"secondCustomAlertView" owner:self options:nil];
    
    self.customAlertView = [nibViews objectAtIndex: 0];
    
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [alertView setValue:self.customAlertView forKey:@"accessoryView"];
    }else{
        [alertView addSubview:self.customAlertView];
    }
    self.customAlertView.textFieldName.text = self.searchBar.text;
    alertView.tag=55;
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==55){
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
        [self.customAlertView removeFromSuperview];
        if(self.selectBlock) {
            CouponProductVo *model=[CouponProductVo new];
            model.productName=drugName;
            if(spec.length>0){
            model.spec=spec;
            }
            self.selectBlock(model);
            [SVProgressHUD showSuccessWithStatus:Kwarning220N66 duration:0.8];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
