//
//  QuickSearchDrugViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/8.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "StaSearchDrugViewController.h"
#import "QYPhotoAlbum.h"
#import "ProductStatiticsCellTableViewCell.h"
#import "StaScanDrugViewController.h"
#import "SellStatistics.h"
#import "PSStatiticsViewController.h"

@interface StaSearchDrugViewController ()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar* m_searchBar;
    UITextField* m_searchField;

    UIView * bgView;
    NSInteger currentPage;
    BOOL isScan;
}

@property (nonatomic ,strong) NSString *keyWord;
@property (nonatomic ,strong) NSMutableArray * dataSource;

@end

@implementation StaSearchDrugViewController

- (void)popVCAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:m_searchBar];
    
    self.dataSource=[NSMutableArray array];
    
    [self setUpSearchBarView];
    
    [self setUpTableView];
    
    if([self.typeSearch isEqualToString:@"1"]){
        [self loadDataScan];
    }else{
        [self loadDataWithKeyWord:self.keyWord];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [m_searchBar becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_searchField resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

#pragma mark ---- 设置 搜索框 ----

- (void)setUpSearchBarView
{
    UIView* status_bg = [[UIView alloc] initWithFrame:RECT(0, 0, APP_W, STATUS_H)];
    status_bg.backgroundColor = RGBHex(qwColor1);
    [self.view addSubview:status_bg];
    
    UIView* searchbg = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_H, APP_W, NAV_H)];
    searchbg.backgroundColor=RGBHex(qwColor1);
    [self.view addSubview:searchbg];
    
    m_searchField.delegate = self;
    m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, STATUS_H, APP_W-80, NAV_H)];
    m_searchBar.tintColor = [UIColor blueColor];
    m_searchBar.backgroundColor = RGBHex(qwColor1);
    m_searchBar.placeholder = @"优惠商品销量搜索";
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
    
    UIButton* backBtn = [[UIButton alloc] initWithFrame:RECT(10, STATUS_H, 24, 44)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"navBar_icon_scanCode"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navBar_icon_scanCode_click"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:RECT(APP_W-50, STATUS_H, 50, NAV_H)];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.font = fontSystem(kFontS1);
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:0];
    [cancelBtn addTarget:self action:@selector(onCancelBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 888;
    [self.view addSubview:cancelBtn];
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

#pragma mark ---- 扫码 Action ----

- (void)scanAction
{
    if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
        [QWGLOBALMANAGER getCramePrivate];
        return;
    }
    StaScanDrugViewController *scanReaderViewController = [[StaScanDrugViewController alloc] init];
    scanReaderViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanReaderViewController animated:YES];
}

#pragma mark ---- 取消 Action ----

- (void)onCancelBtnTouched:(id)sender
{
    __block UIViewController *popViewController = nil;
    __block NSArray *viewControllers = self.navigationController.viewControllers;
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        if([vc isKindOfClass:[StaSearchDrugViewController class]]) {
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

#pragma mark ---- 扫码数据请求 ----

- (void)loadDataScan
{
    if (self.scanSource.count>0) {
        isScan=YES;
        RptProductVo *model=self.scanSource[0];
        m_searchBar.text=model.productName;
        [self.dataSource addObjectsFromArray:self.scanSource];
        [self.tableMain reloadData];
    }else{
        m_searchBar.text=@"";
        [self showInfoView:@"暂无该商品的销量统计~" image:@"img_search"];
    }
    self.tableMain.footerHidden=YES;
}

#pragma mark ---- 根据关键字 搜索 ----

- (void)loadDataWithKeyWord:(NSString *)keyWord
{
    if(isScan){
        [self.tableMain footerEndRefreshing];
    }else
    {
        if(self.keyWord&&self.keyWord.length>0)
        {
            QuerySearchPSModelR *keywords=[QuerySearchPSModelR new];
            keywords.name=keyWord;
            keywords.token=QWGLOBALMANAGER.configure.userToken;
            keywords.page=[NSString stringWithFormat:@"%@",@(currentPage)];
            keywords.pageSize=[NSString stringWithFormat:@"%i",10];
            [self removeInfoView];
            [SellStatistics GetSearchPSWithParams:keywords success:^(id DFUserModel) {
                
                // 解析数据
                NSMutableArray *keyArray = [NSMutableArray array];
                [keyArray addObject:NSStringFromClass([RptProductVo class])];
                NSMutableArray *valueArray = [NSMutableArray array];
                [valueArray addObject:@"products"];
                RptProductArrayVo *scenarionList = [RptProductArrayVo parse:DFUserModel ClassArr:keyArray Elements:valueArray];
                
                if (scenarionList.products.count > 0) {
                    [self.dataSource addObjectsFromArray:scenarionList.products];
                    [self.tableMain reloadData];
                    currentPage++;
                }else{
                    if(currentPage==1){
                        //没有搜索结果
                        [self showInfoView:@"暂无该商品的销量统计~" image:@"img_search"];
                    }else{
                    }
                }
            } failure:^(HttpException *e) {
                [self.tableMain footerEndRefreshing];
            }];
        }else
        {
            [self.dataSource removeAllObjects];
            [self removeInfoView];
            [self.tableMain reloadData];
        }
    }
}

#pragma mark ---- 点击键盘搜索按钮 ----

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
    [self loadDataWithKeyWord:self.keyWord];
}

#pragma mark ---- 列表代理 ----

- (NSInteger)tableView:(UITableView *)tawbleView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProductStatiticsCellTableViewCell getCellHeight:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SecondProductCell = @"ProductIdentifier";
    ProductStatiticsCellTableViewCell *cell = (ProductStatiticsCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondProductCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"ProductStatiticsCellTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:SecondProductCell];
        cell = (ProductStatiticsCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondProductCell];
    }
    RptProductVo *model=self.dataSource[indexPath.row];
    [cell setCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RptProductVo *model=self.dataSource[indexPath.row];
    PSStatiticsViewController *vc=[[PSStatiticsViewController alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.proId=model.productId;
    vc.title = model.productName;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark ---- 暂时不用 ----

- (void)hidekeyboard
{
    CGRect rect = m_searchField.frame;
    [m_searchField resignFirstResponder];
    m_searchField.frame = rect;
    m_searchBar.tintColor = [UIColor blueColor];
}

-(void)showInfoView:(NSString *)text image:(NSString*)imageName
{
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
