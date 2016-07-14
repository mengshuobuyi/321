//
//  QuickSearchDrugViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/8.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "DiscountSearchDrugViewController.h"
#import "QYPhotoAlbum.h"
#import "SecondProductTableViewCell.h"
#import "DiscountScanDrugViewController.h"
#import "WebDirectViewController.h"
#import "BranchViewController.h"
#import "ChatViewController.h"
#import "XPChatViewController.h"

@interface DiscountSearchDrugViewController ()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar* m_searchBar;
    UITextField* m_searchField;

    UIView * bgView;
    NSInteger currentPage;
    BOOL isScan;
}

@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic ,assign) BOOL loadMore;

@end

@implementation DiscountSearchDrugViewController

- (void)popVCAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:m_searchBar];
    isScan=NO;
    self.loadMore = NO;
    currentPage = 1;
    
    self.dataSource=[NSMutableArray array];
    
    // 设置搜索框 导航栏
    [self setUpNavBarTitleView];
    
    // 设置 tableView
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [m_searchBar becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
    
    if([self.typeSearch isEqualToString:@"1"]){
        // 扫码
        [self loadDataScan];
    }else{
        // 关键字搜索
        [self loadDataWithKeyWord:self.keyWord];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [m_searchField resignFirstResponder];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

#pragma mark ---- 设置 tableView ----

- (void)setUpTableView
{
    self.tableMain.frame = CGRectMake(0, 64, APP_W, APP_H-NAV_H);
    self.tableMain.delegate = self;
    self.tableMain.dataSource = self;
    self.tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableMain.backgroundColor = RGBHex(qwColor11);
    [self.view addSubview:self.tableMain];
}

#pragma mark ---- 设置搜索框 导航栏 ----

- (void)setUpNavBarTitleView
{
    UIView* status_bg = [[UIView alloc] initWithFrame:RECT(0, 0, APP_W, STATUS_H)];
    status_bg.backgroundColor = RGBHex(qwColor1);
    [self.view addSubview:status_bg];
    
    UIView* searchbg = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_H, APP_W, NAV_H)];
    searchbg.backgroundColor=RGBHex(qwColor1);
    [self.view addSubview:searchbg];
    
    m_searchField.delegate = self;
    m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, STATUS_H, APP_W-70, NAV_H)];
    m_searchBar.tintColor = [UIColor blueColor];
    m_searchBar.backgroundColor = RGBHex(qwColor1);
    m_searchBar.placeholder = @"优惠商品搜索";
    m_searchBar.delegate = self;
    [self.view addSubview:m_searchBar];
    
    if (iOSv7) {
        UIView* barView = [m_searchBar.subviews objectAtIndex:0];
        [[barView.subviews objectAtIndex:0] removeFromSuperview];
        UITextField* searchField = [barView.subviews objectAtIndex:0];
        searchField.font = [UIFont systemFontOfSize:13.0f];
        [searchField setReturnKeyType:UIReturnKeySearch];
        m_searchField = searchField;
    } else {
        [[m_searchBar.subviews objectAtIndex:0] removeFromSuperview];
        UITextField* searchField = [m_searchBar.subviews objectAtIndex:0];
        searchField.delegate = self;
        searchField.font = [UIFont systemFontOfSize:13.0f];
        [searchField setReturnKeyType:UIReturnKeySearch];
        m_searchField = searchField;
    }
    
    UIButton* scanBtn = [[UIButton alloc] initWithFrame:RECT(0, STATUS_H, 36, 44)];
    scanBtn.backgroundColor = [UIColor clearColor];
    [scanBtn setImage:[UIImage imageNamed:@"navBar_icon_scanCode"] forState:UIControlStateNormal];
    [scanBtn setImage:[UIImage imageNamed:@"navBar_icon_scanCode_click"] forState:UIControlStateHighlighted];
    [scanBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:RECT(APP_W-50, STATUS_H, 50, NAV_H)];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.font = fontSystem(kFontS3);
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:0];
    [cancelBtn addTarget:self action:@selector(onCancelBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 888;
    [self.view addSubview:cancelBtn];
}

#pragma mark ---- 扫码 Action ----

- (void)scanAction
{
    // 是否开启相机使用权限
    if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
        [QWGLOBALMANAGER getCramePrivate];
        return;
    }
    DiscountScanDrugViewController *scanReaderViewController = [[DiscountScanDrugViewController alloc] init];
    scanReaderViewController.HoldSendNewProduct = self.SendNewProduct;
    scanReaderViewController.holdViewController = self;
    scanReaderViewController.hidesBottomBarWhenPushed = YES;

    if(self.SendNewProduct){
        scanReaderViewController.SendNewScan= ^(NSMutableArray *productModel){
            if (productModel.count>0) {
                isScan=YES;
                BranchSearchPromotionProVO *mode=(BranchSearchPromotionProVO*)productModel[0];
                m_searchBar.text=mode.proName;
                [self.dataSource addObjectsFromArray:productModel];
                [self.tableMain reloadData];
            }else{
                m_searchBar.text=@"";
                [self showInfoView:@"很遗憾，您搜索的药品本店暂时没做优惠~" image:@"img_search"];
            }
            self.tableMain.footerHidden=YES;
        };
    }
    [self.navigationController pushViewController:scanReaderViewController animated:YES];
}

#pragma mark ---- 取消 Action ----

- (void)onCancelBtnTouched:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    __block UIViewController *popViewController = nil;
    __block NSArray *viewControllers = self.navigationController.viewControllers;
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        if([vc isKindOfClass:[DiscountSearchDrugViewController class]]) {
            *stop = YES;
            popViewController = viewControllers[idx-1];
        }
    }];
    if(popViewController) {
        [self.navigationController popToViewController:popViewController animated:YES];
    }else{
        [super popVCAction:sender];
    }
}

#pragma mark ---- 扫码获取数据 ----

- (void)loadDataScan
{
    if (self.scanSource.count>0) {
        [self removeInfoView];
        isScan=YES;
        BranchSearchPromotionProVO *mode=(BranchSearchPromotionProVO*)self.scanSource[0];
        m_searchBar.text=mode.proName;
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:self.scanSource];
        [self.tableMain reloadData];
    }else{
        m_searchBar.text=@"";
        [self showInfoView:@"很遗憾，您搜索的药品本店暂时没做优惠~" image:@"img_search"];
    }
    
    self.tableMain.footerHidden=YES;
}

#pragma mark ---- 关键字搜索数据 ----

- (void)loadDataWithKeyWord:(NSString *)keyWord
{
    if(isScan)
    {
        [self.tableMain footerEndRefreshing];
    }else
    {
        if(keyWord && keyWord.length > 0)
        {
            GetCoupnSearchKeywordR *paramModel = [GetCoupnSearchKeywordR new];
            paramModel.keyword=keyWord;
            paramModel.branchId=QWGLOBALMANAGER.configure.groupId;
            if(!self.loadMore){
                currentPage=1;
            }
            paramModel.currPage=[NSString stringWithFormat:@"%@",@(currentPage)];
            paramModel.pageSize=[NSString stringWithFormat:@"%i",10];
            
            [self removeInfoView];
            [Drug getsearchCoupnKeywordsWithParam:paramModel Success:^(id DFUserModel) {
                
                GetSearchKeywordsModel *searchModel = DFUserModel;
                if(self.loadMore)
                {
                    NSArray *array = searchModel.list;
                    if(array.count > 0)
                        [self.dataSource addObjectsFromArray:searchModel.list];
                }else{
                    self.dataSource = [NSMutableArray array];
                    [self.dataSource addObjectsFromArray:searchModel.list];
                }
                if (searchModel.list.count > 0) {
                    currentPage++;
                    [self removeInfoView];
                }else{
                    if(currentPage==1){
                        [self showInfoView:@"很遗憾，您搜索的药品本店暂时没做优惠~" image:@"img_search"];
                    }else{
                        [self removeInfoView];
                    }
                }
                [self.tableMain footerEndRefreshing];
                [self.tableMain reloadData];
                
            } failure:^(HttpException *e) {
            }];
        }
        else
        {
            // 没有搜索关键字
            [self.dataSource removeAllObjects];
            [self removeInfoView];
            [self.tableMain reloadData];
        }
    }
}

#pragma mark ---- UISearchBar Delegate ----

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == m_searchBar) {
        [m_searchField resignFirstResponder];
        [self loadDataWithKeyWord:self.keyWord];
    }
}

#pragma mark ---- 尾部刷新 ----

- (void)footerRereshing
{
    self.loadMore=YES;
    [self loadDataWithKeyWord:self.keyWord];
}

#pragma mark ---- 列表代理 ----

- (NSInteger)tableView:(UITableView *)tawbleView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SecondProductTableViewCell getCellHeight:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SecondProductCell = @"SecondProductCell";
    SecondProductTableViewCell *cell = (SecondProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondProductCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"SecondProductTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:SecondProductCell];
        cell = (SecondProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondProductCell];
    }
    
    BranchSearchPromotionProVO *model=self.dataSource[indexPath.row];
    [cell setSearchProductCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BranchSearchPromotionProVO *model=self.dataSource[indexPath.row];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    
    if(self.SendNewProduct)
    {
        // IM 发送优惠
        self.SendNewProduct(model);
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *viewController=(UIViewController *)obj;
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            if ([viewController isKindOfClass:[XPChatViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
            }else if([viewController isKindOfClass:[ChatViewController class]]){
                [self.navigationController popToViewController:viewController animated:YES];
            }else if(idx == (self.navigationController.viewControllers.count - 1)){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        return;
    }
    
   // 进入药品详情
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = model.proId;
    modelDrug.promotionID = model.promotionId;
    
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}

#pragma mark ---- 监听文本变化 ----

- (void)textFieldValueChanged:(NSNotification *)notification
{
    UISearchBar * searchBar = (UISearchBar *)notification.object;
    NSString * key = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.keyWord = key;
    isScan=NO;
    [self loadDataWithKeyWord:self.keyWord];
}


#pragma mark ---- 不知道在哪里用 ----

- (void)hidekeyboard
{
    CGRect rect = m_searchField.frame;
    [m_searchField resignFirstResponder];
    m_searchField.frame = rect;
    m_searchBar.tintColor = [UIColor blueColor];
}

-(void)showInfoView:(NSString *)text image:(NSString*)imageName {
    [self showInfoView:text image:imageName tag:0];
}

-(void)showInfoView:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfo==nil) {
        self.vInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 64, APP_W, APP_H-NAV_H)];
        self.vInfo.backgroundColor = RGBHex(qwColor11);
    }
    
    for (id obj in self.vInfo.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfo addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS1);
    lblInfo.textColor = RGBHex(qwColor7);//0x89889b 0x6a7985
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:lblInfo];
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=tag;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:btnClick];
    
    
    float vw=CGRectGetWidth(self.vInfo.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:140;
    CGSize sz=[QWGLOBALMANAGER sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    
    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
