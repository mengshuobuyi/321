//
//  WechatActivitySearchViewController.m
//  wenYao-store
//  商品活动搜索
//  Created by qw_imac on 16/3/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "WechatActivitySearchViewController.h"
#import "SearchActivityResultViewController.h"
@implementation WechatActivitySearchModel

@end

@interface WechatActivitySearchViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *searchHistory;
}

@end

@implementation WechatActivitySearchViewController
static NSInteger const masSearchHis = 10;
- (void)viewDidLoad {
    [super viewDidLoad];
    searchHistory = [@[] mutableCopy];
    self.searchBarView.placeholder = @"输入品牌、商品名称";
    self.tableMain =[[UITableView alloc] initWithFrame:CGRectMake(0, 0 , APP_W, [[UIScreen mainScreen] bounds].size.height - 64) style:UITableViewStylePlain];
    self.tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableMain.delegate = self;
    self.tableMain.dataSource = self;
    self.tableMain.backgroundColor = [UIColor clearColor];
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 39)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, APP_W/2, 39)];
    label.text = @"搜索历史";
    label.font = fontSystem(kFontS4);
    label.textColor = RGBHex(qwColor8);
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(APP_W - 15 -50, 0, 50, 39)];
    [btn setTitle:@"清空" forState:UIControlStateNormal];
    btn.titleLabel.font = fontSystem(kFontS4);
    [btn setTitleColor:RGBHex(qwColor8) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearAllSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 38.5, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [header addSubview:label];
    [header addSubview:btn];
    [header addSubview:line];
    self.tableMain.tableHeaderView = header;
    [self.view addSubview:self.tableMain];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchBarView.text = @"";
    [self getSearchHistory];
}
//存搜索历史
- (void)saveSearchHistory:(NSString *)searchStr {
    if (searchHistory.count == masSearchHis ) {
        [searchHistory removeLastObject];
    }
    WechatActivitySearchModel *modelSearch = [WechatActivitySearchModel new];
    modelSearch.searchItem = searchStr;
    [searchHistory insertObject:modelSearch atIndex:0];
    [WechatActivitySearchModel deleteAllObjFromDB];
    [WechatActivitySearchModel saveObjToDBWithArray:searchHistory];
}
//获取搜索历史
- (void)getSearchHistory {
    searchHistory = (NSMutableArray *)[WechatActivitySearchModel getArrayFromDBWithWhere:nil WithorderBy:@"rowid desc"];
    if (searchHistory.count >0) {
        self.tableMain.hidden = NO;
        [self removeInfoView];
    }else {
        self.tableMain.hidden = YES;
        [self showInfoView:@"暂无搜索历史" image:@"img_search" flatY:40.0f];
    }
    [self.tableMain reloadData];
}

- (void)clearAllSearchHistory {
    [searchHistory removeAllObjects];
    [WechatActivitySearchModel deleteAllObjFromDB];
    [self getSearchHistory];
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableMain dequeueReusableCellWithIdentifier:@"ActivitySearchCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivitySearchCell"];
    }
    WechatActivitySearchModel *model = searchHistory[indexPath.row];
    cell.textLabel.text = model.searchItem;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 46, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [cell.contentView addSubview:line];
    cell.textLabel.font = fontSystem(kFontS1);
    cell.textLabel.textColor = RGBHex(qwColor6);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WechatActivitySearchModel *searchWord = searchHistory[indexPath.row];
    //将该搜索词移至第一个
    [searchHistory removeObjectAtIndex:indexPath.row];
    [self saveSearchHistory:searchWord.searchItem];
    [self searchWithKeyword:searchWord.searchItem];
}

#pragma mark - searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchword = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (StrIsEmpty(searchword)) {
        [SVProgressHUD showErrorWithStatus:@"搜索词不能为空" duration:0.8];
        return;
    }
    [self saveSearchHistory:searchBar.text];
    [self searchWithKeyword:searchBar.text];
}

- (void)searchWithKeyword:(NSString *)keyword {
    SearchActivityResultViewController *vc = [[SearchActivityResultViewController alloc]initWithNibName:@"SearchActivityResultViewController" bundle:nil];
    vc.searchWord = keyword;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
    [self.searchBarView resignFirstResponder];
}
@end
