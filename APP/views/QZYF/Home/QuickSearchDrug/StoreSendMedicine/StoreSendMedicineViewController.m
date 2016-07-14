//
//  StoreSendMedicineViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/6/21.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "StoreSendMedicineViewController.h"
#import "QCSlideSwitchView.h"
#import "ThreeChildrenViewController.h"
#import "MedicineListViewController.h"
#import "DiseaseDetailViewController.h"
#import "SymptomViewController.h"
#import "css.h"
#import "Drug.h"
#import "QuickSearchDrugListViewController.h"
#import "QuickScanDrugViewController.h"
#import "QYPhotoAlbum.h"
#import "StoreSendMedicineListViewController.h"

@interface StoreSendMedicineViewController ()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

{
    UISearchBar* m_searchBar;
    UITextField* m_searchField;
    
    UIView *  footView;
    NSInteger currentPage;
}

@property (nonatomic ,strong) UITableView * mTableView;

//搜索历史
@property (nonatomic ,strong) NSMutableArray * searchHistoryArray;

@end

@implementation StoreSendMedicineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mTableView.rowHeight = 35;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航蓝
    [self setNavgationBarView];
    
    //设置tableView
    [self setUpTableView];
    
    [self setUpTableViewFootView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
    [m_searchBar becomeFirstResponder];
    [self keyWordSet];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
    [m_searchField resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ---- 设置导航栏 ----
- (void)setNavgationBarView
{
    //设置搜索框
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
    m_searchBar.placeholder = @"请输入药品名称";
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
    
    //扫码
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:RECT(APP_W-50, STATUS_H, 60, NAV_H)];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setImage:[UIImage imageNamed:@"扫一扫icon"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 888;
    [self.view addSubview:cancelBtn];
    
    //返回按钮
    UIButton* backBtn = [[UIButton alloc] initWithFrame:RECT(0, STATUS_H, 30, 44)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_btn_back_sel"]  forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(popVCAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
- (void)popVCAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 扫码 ----
- (void)scanAction
{
    if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
        [QWGLOBALMANAGER getCramePrivate];
        return;
    }
    QuickScanDrugViewController *scanReaderViewController = [QuickScanDrugViewController new];
    scanReaderViewController.hidesBottomBarWhenPushed = YES;
    scanReaderViewController.sendMedicineByStore = YES;
    [self.navigationController pushViewController:scanReaderViewController animated:YES];
    
    if (self.returnValueBlock) {
        
        scanReaderViewController.block = ^(id model){
            productclassBykwId *product = model;
            self.returnValueBlock(product);
        };
    }
}

#pragma mark ---- 设置tableview -----
- (void)setUpTableView
{
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APP_W, SCREEN_H-64) style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.backgroundColor = RGBHex(qwColor11);
    self.mTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.mTableView];
}

#pragma mark ---- 设置footerView ----
- (void)setUpTableViewFootView
{
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APP_W, 45)];
    footView.backgroundColor = [UIColor whiteColor];
    footView.clipsToBounds = YES;
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"清空"]];
    image.frame = CGRectMake(APP_W*0.35 - 20, 15, 15, 15);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(APP_W*0.35, 15, 100, 15)];
    label.font = font(kFont4, kFontS1);
    label.textColor = RGBHex(qwColor7);
    label.text = @"清空搜索历史";
    
    UIButton * clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, APP_W, 45)];
    [clearBtn setBackgroundColor:[UIColor clearColor]];
    [clearBtn addTarget:self action:@selector(onClearBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:label];
    [footView addSubview:image];
    [footView addSubview:clearBtn];
    
    self.mTableView.tableFooterView.frame = footView.frame;
    self.mTableView.tableFooterView = footView;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == m_searchBar) {
        [m_searchField resignFirstResponder];
        [self loadDataWithKeyWord:searchBar.text];
    }
}


#pragma mark ------ Table view data source -------

- (NSInteger)tableView:(UITableView *)tawbleView numberOfRowsInSection:(NSInteger)section
{
    return self.searchHistoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //显示最近搜索
    return 39;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 39)];
    view.backgroundColor = RGBHex(qwColor11);
    
    //显示最近搜索
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 17, 17)];
    imageView.image = [UIImage imageNamed:@"ic_clock"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15+17+7, 0, APP_W-30, 39)];
    label.textColor = RGBHex(qwColor7);
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"最近搜索";
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = fontSystem(kFontS1);
    cell.textLabel.textColor = RGBHex(qwColor6);
    cell.textLabel.text = self.searchHistoryArray[indexPath.row];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, 44.5, APP_W - 14, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [cell addSubview:line];
    cell.selectedBackgroundView.backgroundColor=RGBHex(qwColor11);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //搜索历史
    NSString * historyKeyWord = self.searchHistoryArray[indexPath.row];
    m_searchField.text = historyKeyWord;
    [self loadDataWithKeyWord:historyKeyWord];
}

#pragma mark ---- 点击搜索跳转页面 ----
- (void)loadDataWithKeyWord:(NSString *)keyWord
{
    //搜索在下个页面进行，如果有搜索结果，加入缓存，如果没有展示无结果页面
    StoreSendMedicineListViewController *vc = [[StoreSendMedicineListViewController alloc] init];
    vc.keyWord = keyWord;
    vc.hidesBottomBarWhenPushed = YES;
    
    if (self.returnValueBlock) {
        vc.block = ^(id model){
            productclassBykwId *product = model;
            self.returnValueBlock(product);
        };
    }
    
    //关键字搜索有结果，加入缓存
    vc.historyBlock = ^(NSString *keyWord){
        if ([self.searchHistoryArray containsObject:keyWord]) {
            [self.searchHistoryArray removeObject:keyWord];
        }
        if (self.searchHistoryArray.count == 10) {
            [self.searchHistoryArray removeObjectAtIndex:self.searchHistoryArray.count-1];
        }
        [self.searchHistoryArray insertObject:keyWord atIndex:0];
        NSString *keyText = @"";
        keyText = @"medicineSearch_store";
        setHistoryConfig(keyText, self.searchHistoryArray);
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 清空搜索历史 ----
- (void)onClearBtnTouched:(UIButton *)button{
    [self.searchHistoryArray removeAllObjects];
    
    NSString *keyText = @"";
    keyText = @"medicineSearch_store";
    setHistoryConfig(keyText,nil);
    [self keyWordSet];
}

- (void)keyWordSet
{
    //判断搜索类型
    NSString *keyText = @"";
    keyText = @"medicineSearch_store";
    self.searchHistoryArray = [[NSMutableArray alloc] initWithArray:getHistoryConfig(keyText)];
    
    if (self.searchHistoryArray.count > 0) {
        [self removeInfoView];
        footView.hidden = NO;
        [footView setFrame:CGRectMake(0, self.mTableView.frame.size.height+self.mTableView.frame.origin.y, APP_W, 45)];
        [self.mTableView reloadData];
    }else{
        [self showInfoView:@"暂无搜索记录" image:@"img_search"];
    }
}


- (void)onCancelBtnTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    [btnClick addTarget:self action:@selector(viewInfoClickAction) forControlEvents:UIControlEventTouchUpInside];
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

- (void)viewInfoClickAction
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
