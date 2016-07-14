//
//  SearchParentViewController.m
//  wenyao
//
//  Created by Meng on 14-9-20.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "SearchRootViewController.h"
#import "Drug.h"
#import "DiseaseDetailViewController.h"
#import "SearchDisease_SymptomListViewController.h"
#import "SearchMedicineListViewController.h"


@interface SearchRootViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *  footView;
    UIView * bgView;
    NSInteger currentPage;
    
    NSString *keyNewWord;
}
@property (nonatomic ,strong) UITableView * mTableView;
@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic ,strong) NSMutableArray * searchHistoryArray;
@end

@implementation SearchRootViewController
@synthesize searchBar = _searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        self.mTableView.rowHeight = 35;
        self.dataSource = [NSMutableArray array];
        keyNewWord=@"";
        
    }
    return self;
}

- (void)setSearchBar:(UISearchBar *)searchBar
{
    _searchBar = searchBar;
    
}

- (void)setKeyWord:(NSString *)keyWord{
    _keyWord = keyWord;
    [self keyWordSet];
}

- (void)keyWordSet
{
    
    if (self.keyWord.length == 0 || self.keyWord == nil) {
        
        if (bgView) {
            [bgView removeFromSuperview];
            bgView = nil;
        }
        //判断搜索类型
        switch (self.histroySearchType)
        {
            case 0:
                self.searchHistoryArray = [[NSMutableArray alloc] initWithArray:[QWUserDefault getObjectBy:@"medicineSearch"]];
                break;
            case 1:
                self.searchHistoryArray = [[NSMutableArray alloc] initWithArray:[QWUserDefault getObjectBy:@"diseaseSearch"]];
                break;
            case 2:
                self.searchHistoryArray = [[NSMutableArray alloc] initWithArray:[QWUserDefault getObjectBy:@"symptomSearch"]];
                break;
            default:
                break;
        }
        if (self.searchHistoryArray.count > 0) {
            footView.hidden = NO;
            [footView setFrame:CGRectMake(0, self.mTableView.frame.size.height+self.mTableView.frame.origin.y, APP_W, 45)];
            [self.mTableView reloadData];
        }else{
            [self showNoSearchHistory];
        }
    }else{
        if (bgView) {
            [bgView removeFromSuperview];
            bgView = nil;
        }
        
        [footView setFrame:CGRectMake(0, self.mTableView.frame.size.height+self.mTableView.frame.origin.y, APP_W, 0)];
        footView.hidden = YES;
        self.mTableView.frame = CGRectMake(0, 0, APP_W, APP_H-35-NAV_H);
        currentPage = 1;
        [self.mTableView addFooterWithTarget:self action:@selector(footerRereshing)];
        self.mTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
        self.mTableView.footerReleaseToRefreshText = @"松开加载更多数据了";
        self.mTableView.footerRefreshingText = @"正在帮你加载中";
//        self.mTableView.footerNoDataText = kWaring55;
        self.loadMore = NO;
//        self.mTableView.footer.canLoadMore=YES;
        [self loadDataWithKeyWord:self.keyWord];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpTableViewFootView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}

#pragma mark ------ setup ------
- (void)setUpTableView{
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H + 20) style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.backgroundColor = RGBHex(qwColor11);
    [self.view addSubview:self.mTableView];
}

- (void)setUpTableViewFootView{
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 20)];
    footView.backgroundColor = [UIColor whiteColor];
    footView.clipsToBounds = YES;
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"清空"]];
    image.frame = CGRectMake(APP_W*0.4 - 20, 15, 15, 15);
    UIButton * clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_W*0.4, 15, 100, 15)];
    clearBtn.titleLabel.font = font(kFont4, kFontS1);
    [clearBtn setTitle:@"清空搜索历史" forState:0];
    [clearBtn setTitleColor:RGBHex(qwColor7) forState:0];
    [clearBtn setBackgroundColor:[UIColor clearColor]];
    [clearBtn addTarget:self action:@selector(onClearBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:image];
    [footView addSubview:clearBtn];
    NSLog(@"高度%f",footView.frame.size.height);
   
    self.mTableView.tableFooterView.frame = footView.frame;
    self.mTableView.tableFooterView = footView;
}

#pragma mark ------数据请求------
- (void)loadDataWithKeyWord:(NSString *)keyWord
{
    GetSearchKeywordsR *keywords=[GetSearchKeywordsR new];
    keywords.keyword=keyWord;
    keywords.currPage=[NSString stringWithFormat:@"%@",@(currentPage)];
    keywords.pageSize=[NSString stringWithFormat:@"%i",15];
    NSLog(@"%@%@",[keywords dictionaryModel],QWGLOBALMANAGER.configure.userToken);
    if (self.histroySearchType == 0){
        keywords.type = @"0";
    }else if (self.histroySearchType == 1){
        keywords.type = @"1";
    }else if (self.histroySearchType == 2){
        keywords.type = @"2";
    }
    [self removeInfoView];
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
    }
    
    [Drug getsearchKeywordsWithParam:keywords Success:^(id DFUserModel) {
        GetSearchKeywordsModel *searchkey=DFUserModel;
        if(self.loadMore)
            {
                NSArray *array = searchkey.list;
                if(array.count > 0)
                    for (GetSearchKeywordsclassModel *key in searchkey.list) {
                        [self.dataSource addObject:key];
                    }
            }else{
                self.dataSource = [NSMutableArray array];
                for (GetSearchKeywordsclassModel *key in searchkey.list) {
                    [self.dataSource addObject:key];
                }
            }
        if (searchkey.list.count > 0) {
            [self.mTableView reloadData];
            currentPage++;
        }else{
            if(currentPage==1){
                [self showInfoView:@"没有搜索结果" image:@"img_search"];
            }else{
                //没有搜索结果
//                self.mTableView.footer.canLoadMore=NO;
            }
        }
         [self.mTableView footerEndRefreshing];
    } failure:^(HttpException *e) {
          [self.mTableView footerEndRefreshing];
    }];

}


- (void)footerRereshing
{
    self.loadMore = YES;
    [self loadDataWithKeyWord:self.keyWord];
}

#pragma mark ------ Table view data source -------

- (NSInteger)tableView:(UITableView *)tawbleView numberOfRowsInSection:(NSInteger)section{
    if(self.keyWord.length == 0 &&self.searchHistoryArray.count>0){
        return self.searchHistoryArray.count;
    }else{
        if(self.dataSource.count>0){
         return self.dataSource.count;
        }else{
            return 0;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = fontSystem(kFontS1);
    cell.textLabel.textColor = RGBHex(qwColor6);
    if (self.keyWord.length > 0 && self.dataSource.count>0&&self.dataSource.count>indexPath.row) {
        cell.textLabel.frame = CGRectMake(14, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height);
        GetSearchKeywordsclassModel *key=self.dataSource[indexPath.row];
        cell.textLabel.text=key.gswCname;
        UIView *bkView = [[UIView alloc]initWithFrame:cell.frame];
        bkView.backgroundColor = RGBHex(qwColor10);
        cell.selectedBackgroundView = bkView;
        
    }else{
        if(self.searchHistoryArray.count>indexPath.row){
            GetSearchKeywordsclassModel *model = self.searchHistoryArray[indexPath.row];
            cell.textLabel.text = model.gswCname;
        }
        
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, 44.5, APP_W - 14, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [cell addSubview:line];
    cell.selectedBackgroundView.backgroundColor=RGBHex(qwColor11);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        return;
    }
    
    NSIndexPath*    selection = [self.mTableView indexPathForSelectedRow];
    if (selection) {
        [self.mTableView deselectRowAtIndexPath:selection animated:YES];
    }
    if (self.keyWord.length > 0 && self.dataSource.count>0) {
        if(self.dataSource.count>indexPath.row){
        GetSearchKeywordsclassModel *key = self.dataSource[indexPath.row];
        if(key){
            keyNewWord=key.gswCname;
        }else{
            keyNewWord=self.keyWord;
        }
        
        
        //搜索表
        if ([self.searchHistoryArray containsObject:key]) {
            [self.searchHistoryArray removeObject:key];
        }
        if (self.searchHistoryArray.count == 5) {
            [self.searchHistoryArray removeObjectAtIndex:self.searchHistoryArray.count-1];
        }
        
        [self.searchHistoryArray insertObject:key atIndex:0];
        switch (self.histroySearchType) {
            case 0:
            {
                [QWUserDefault setObject:self.searchHistoryArray key:@"medicineSearch"];
                SearchMedicineListViewController * medicineList = [[SearchMedicineListViewController alloc] init];
                medicineList.kwId = key.gswId;
                medicineList.title = key.gswCname;
                [self.navigation pushViewController:medicineList animated:YES];
            }
                break;
            case 1:
            {
                [QWUserDefault setObject:self.searchHistoryArray key:@"diseaseSearch"];
                SearchDisease_SymptomListViewController * searchDisease_Symptom = [[SearchDisease_SymptomListViewController alloc] init];
                searchDisease_Symptom.requsetType = RequsetTypeDisease;
                searchDisease_Symptom.kwId = key.gswId;
                searchDisease_Symptom.title = key.gswCname;
                [self.navigation pushViewController:searchDisease_Symptom animated:YES];
            }
                break;
            case 2:
            {
                [QWUserDefault setObject:self.searchHistoryArray key:@"symptomSearch"];
                SearchDisease_SymptomListViewController * searchDisease_Symptom = [[SearchDisease_SymptomListViewController alloc] init];
                searchDisease_Symptom.requsetType = RequsetTypeSymptom;
                searchDisease_Symptom.kwId = key.gswId;
                searchDisease_Symptom.title = key.gswCname;
                
                searchDisease_Symptom.containerViewController = self.containerViewController;
                if (self.containerViewController) {
                    [self.containerViewController.navigationController pushViewController:searchDisease_Symptom animated:YES];
                }else
                {
                    [self.navigationController pushViewController:searchDisease_Symptom animated:YES];
                }
            }
                break;
            default:
                break;
        }
        }
    }else{
        if(self.searchHistoryArray.count>0){
            if(self.searchHistoryArray.count>indexPath.row){
                GetSearchKeywordsclassModel *key = self.searchHistoryArray[indexPath.row];
                switch (self.histroySearchType) {
                    case 0:
                    {
                        [QWUserDefault setObject:self.searchHistoryArray key:@"medicineSearch"];
                        SearchMedicineListViewController * medicineList = [[SearchMedicineListViewController alloc] init];
                        medicineList.kwId = key.gswId;
                        medicineList.title = key.gswCname;
                        [self.navigation pushViewController:medicineList animated:YES];
                    }
                        break;
                    case 1:
                    {
                        [QWUserDefault setObject:self.searchHistoryArray key:@"diseaseSearch"];
                        SearchDisease_SymptomListViewController * searchDisease_Symptom = [[SearchDisease_SymptomListViewController alloc] init];
                        searchDisease_Symptom.requsetType = RequsetTypeDisease;
                        searchDisease_Symptom.kwId = key.gswId;
                        searchDisease_Symptom.title = key.gswCname;
                        [self.navigation pushViewController:searchDisease_Symptom animated:YES];
                    }
                        break;
                    case 2:
                    {
                        [QWUserDefault setObject:self.searchHistoryArray key:@"symptomSearch"];
                        SearchDisease_SymptomListViewController * searchDisease_Symptom = [[SearchDisease_SymptomListViewController alloc] init];
                        searchDisease_Symptom.requsetType = RequsetTypeSymptom;
                        searchDisease_Symptom.kwId = key.gswId;
                        searchDisease_Symptom.title = key.gswCname;
                        
                        searchDisease_Symptom.containerViewController = self.containerViewController;
                        if (self.containerViewController) {
                            [self.containerViewController.navigationController pushViewController:searchDisease_Symptom animated:YES];
                        }else
                        {
                            [self.navigationController pushViewController:searchDisease_Symptom animated:YES];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

- (void)onClearBtnTouched:(UIButton *)button{
    [self.searchHistoryArray removeAllObjects];
    switch (self.histroySearchType) {
        case 0://清除药品搜索历史
            [QWUserDefault removeObjectBy:@"medicineSearch"];
            break;
        case 1://清除疾病搜索历史
            [QWUserDefault removeObjectBy:@"diseaseSearch"];
            break;
        case 2://清除症状搜索历史
            [QWUserDefault removeObjectBy:@"symptomSearch"];
            break;
        default:
            break;
    }
    self.keyWord = @"";
    [self keyWordSet];
}

#pragma mark ------其他函数方法------
- (void)viewDidCurrentView{
    
}

//显示没有搜索记录

- (void)showNoSearchHistory
{
    if (bgView) {
        [bgView removeFromSuperview];
        bgView = nil;
    }
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = RGBHex(qwColor11);
    
    UILabel* lable_ = [[UILabel alloc]initWithFrame:RECT(0,80, APP_W, 30)];
    lable_.font = fontSystem(kFontS1);
    lable_.textColor = RGBHex(qwColor8);
    lable_.textAlignment = NSTextAlignmentCenter;
    lable_.center = CGPointMake(APP_W/2, lable_.center.y);
    lable_.text = @"暂无搜索记录";
    [bgView addSubview:lable_];
    [self.view insertSubview:bgView atIndex:self.view.subviews.count];
}

- (void)keyboardHidenClick{
    if (self.scrollBlock) {
        self.scrollBlock();
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollBlock) {
        self.scrollBlock();
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
