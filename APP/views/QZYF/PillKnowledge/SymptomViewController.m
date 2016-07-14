//
//  SymptomViewController.m
//  APP
//
//  Created by qwfy0006 on 15/3/11.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SymptomViewController.h"
#import "Constant.h"
#import "SymptomDetailViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
//#import "ChineseString.h"
#import "UIViewController+isNetwork.h"
#import "Order.h"
#import "OrderMedelR.h"
#import "OrderModel.h"
#import "SymptomListCell.h"

@interface SymptomViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,BATableViewDelegate>

{
    BATableView * myTableView;
    UIView * _nodataView;
}
@property (nonatomic ,strong) NSMutableArray *rightIndexArray;
//设置每个section下的cell内容
@property (nonatomic ,strong) NSMutableArray *LetterResultArr;

@property (nonatomic ,strong) NSMutableArray * usualArray;
@property (nonatomic ,strong) NSMutableArray * unusualArray;
@property (nonatomic ,strong) NSMutableArray * dataSource;

@end

@implementation SymptomViewController

@synthesize rightIndexArray,LetterResultArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)backToPreviousController:(id)sender
{
    //    if(self.containerViewController) {
    //        [self.containerViewController.navigationController popViewControllerAnimated:YES];
    //    }else{
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
    }
    //}
}

- (void)dealloc
{
    
}


- (void)BtnClick{
    
    if(![self isNetWorking]){
        for(UIView *v in [self.view subviews]){
            if(v.tag == 999){
                [v removeFromSuperview];
            }
        }
        [self subViewWillAppear];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self isNetWorking]){
        [self addNetView];
        return;
    }
    [self subViewWillAppear];
    
}
- (void)httpRequestResult:(id)resultObj
{
    if (_nodataView) {
        [_nodataView removeFromSuperview];
        _nodataView = nil;
    }
    
    self.dataSource = (NSMutableArray *)resultObj;
    if (self.dataSource.count == 0) {
        //[self showNoDataViewWithString:@"暂无相关症状"];
        [self showInfoView:@"暂无相关症状" image:@"无可能疾病icon.png"];
        
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (SpmListModel *model in self.dataSource) {
            if ([model.usual integerValue] == 1) {
                [self.usualArray addObject:model];//常见
            }
            else{
                [self.unusualArray addObject:model];//不常见
            }
        }
        
        if (self.usualArray.count > 0) {
            [self.rightIndexArray insertObject:@"常" atIndex:0];
            [self.LetterResultArr insertObject:self.usualArray atIndex:0];
        }
        NSArray * letters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        NSMutableArray * currArray = [[NSMutableArray alloc]initWithArray:self.unusualArray];
        for (int i=0; i<letters.count; i++) {
            NSMutableArray * arr = [NSMutableArray array];//存放当前字母所对应dic的数组
            for (int j = 0; j < self.unusualArray.count; j++) {
                SpmListModel *model = self.unusualArray[j];
                if ([model.liter isEqualToString:letters[i]]) {
                    [arr addObject:model];
                    [currArray removeObject:model];
                }else
                    continue;
            }
            //遍历完一次之后
            if (arr.count > 0) {
                [self.rightIndexArray addObject:letters[i]];
                [self.LetterResultArr addObject:arr];
            }
        }
        
        if (currArray.count > 0) {
            [self.rightIndexArray addObject:@"#"];
            [self.LetterResultArr addObject:currArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [myTableView reloadData];
        });
    });
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.requestType == wikiSym) {
        self.title = @"症状百科";
    }
    if (iOSv7 && self.view.frame.origin.y==0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.dataSource = [NSMutableArray array];
    self.usualArray = [NSMutableArray array];
    self.unusualArray = [NSMutableArray array];
    self.rightIndexArray = [NSMutableArray array];
    self.LetterResultArr = [NSMutableArray array];
    [self makeTableView];
    // Do any additional setup after loading the view.
}

- (void)makeTableView
{
    myTableView = [[BATableView alloc] init];
    if (self.requestType == wikiSym) {
        myTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H-35)];
    }else{
        myTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    }
    
    myTableView.backgroundColor = RGBHex(qwColor11);
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
}

#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    return self.rightIndexArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SymptomListCell getCellHeight:nil];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rightIndexArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.LetterResultArr[section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellName = @"SymptomListCell";
    SymptomListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[SymptomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    SpmListModel *model = self.LetterResultArr[indexPath.section][indexPath.row];
    [cell setCell:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , APP_W, 28)];
    v.backgroundColor = RGBHex(qwColor11);
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 28)];
    label.font = fontSystem(kFontS5);
    label.textColor = RGBHex(qwColor7);
    if (section == 0 && self.usualArray.count > 0) {
        label.text = @"常见症状";
    }else{
        label.text = self.rightIndexArray[section];
    }
    [v addSubview:label];
    return v;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath*    selection = [myTableView.tableView indexPathForSelectedRow];
    if (selection) {
        [myTableView.tableView deselectRowAtIndexPath:selection animated:YES];
    }
    //    if (app.currentNetWork == kNotReachable) {
    //        [SVProgressHUD showErrorWithStatus:@"当前暂无网络,请稍后重试!" duration:0.8f];
    //        return;
    //    }
    
    SpmListModel *model = self.LetterResultArr[indexPath.section][indexPath.row];
    SymptomDetailViewController * symptomDetailViewController = [[SymptomDetailViewController alloc] init];
    symptomDetailViewController.title = model.name;
    symptomDetailViewController.spmCode = model.spmCode;
    symptomDetailViewController.containerViewController = self.containerViewController;
    
    if (self.containerViewController) {
        [self.containerViewController.navigationController pushViewController:symptomDetailViewController animated:YES];
    }else{
        [self.navigationController pushViewController:symptomDetailViewController animated:YES];
    }
}

- (NSString *)getCachedSymptomListPath
{
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/symptomList.plist"]];
    return homePath;
}

- (void)cacheAllSymptom:(NSDictionary *)dicCache
{
    NSFileManager *fmManager = [NSFileManager defaultManager];
    NSString *strCacheList = [self getCachedSymptomListPath];
    if ([fmManager fileExistsAtPath:strCacheList]) {
        [fmManager removeItemAtPath:strCacheList error:nil];
    }
    [dicCache writeToFile:strCacheList atomically:YES];
}

- (NSDictionary *)getCachedSymptom
{
    NSString *strCacheList = [self getCachedSymptomListPath];
    NSDictionary *dicCache = [NSDictionary dictionaryWithContentsOfFile:strCacheList];
    return dicCache;
}

- (void)refresh
{
    if (self.dataSource.count) {
        return;
    }
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        NSDictionary *dicCached = [self getCachedSymptom];
        [self httpRequestResult:dicCached];
        if(!self.dataSource.count > 0){
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
            return;
        }
    } else {
        [self getDataFromVikiSpm];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollBlock) {
        self.scrollBlock();
    }
}

#pragma mark - INDICTOR
//-(void)showNoDataViewWithString:(NSString *)nodataPrompt
//{
//    if (_nodataView) {
//        [_nodataView removeFromSuperview];
//        _nodataView = nil;
//    }
//    if (_nodataView==nil) {
//        _nodataView = [[UIView alloc]initWithFrame:self.view.bounds];
//        _nodataView.backgroundColor = RGBHex(qwColor11);
//        
//        UIImageView *dataEmpty = [[UIImageView alloc]initWithFrame:RECT(0, 0, 75, 75)];
//        dataEmpty.center = CGPointMake(APP_W/2, 130);
//        dataEmpty.image = [UIImage imageNamed:@"无可能疾病icon.png"];
//        [_nodataView addSubview:dataEmpty];
//        
//        UILabel* lable_ = [[UILabel alloc]initWithFrame:RECT(0,200, nodataPrompt.length*20,30)];
//        lable_.tag = 201405220;
//        lable_.font = fontSystem(kFontS1);
//        lable_.textColor = RGBHex(qwColor9);
//        lable_.textAlignment = NSTextAlignmentCenter;
//        lable_.center = CGPointMake(APP_W/2, 200);
//        lable_.text = nodataPrompt;
//        
//        [_nodataView addSubview:lable_];
//        [[UIApplication sharedApplication].keyWindow addSubview:_nodataView];
//        [self.view insertSubview:_nodataView atIndex:self.view.subviews.count];
//    }else
//    {
//        UILabel *label_ = (UILabel *)[_nodataView viewWithTag:201405220];
//        label_.text = nodataPrompt;
//        label_.textAlignment =NSTextAlignmentCenter;
//        label_.frame = RECT(0,175, nodataPrompt.length*20,30);
//        label_.center = CGPointMake(APP_W/2, label_.center.y);
//        _nodataView.hidden = NO;
//    }
//}

#pragma mark====
#pragma mark ---------数据请求--------
- (void)subViewWillAppear{
    
    if (self.dataSource.count > 0) {
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    if (self.requestType == wikiSym) {
        
        //[weakSelf getDataFromVikiSpm];
        
    }else if (self.requestType == bodySym){
        
        [weakSelf getDataFromBodySym];
        
    }else if (self.requestType == searchSym){
        
        [weakSelf getDataFromsearchSym];
        
    }
    
}

- (void)getDataFromVikiSpm
{
    SpmListModelR *model = [SpmListModelR new];
    model.currPage = @"1";
    model.pageSize = @"0";
    
    [Order QuerySpmInfoListWithParams:model success:^(id obj) {
        
        SpmListPage *page = obj;
        if ([page.apiStatus intValue] == 0) {
            NSArray *array = page.list;
            [self httpRequestResult:array];
            //[self cacheAllSymptom:resultObj];
        }else{
            [SVProgressHUD showErrorWithStatus:page.apiMessage duration:1.5f];
        }
        
    } failure:^(HttpException *e) {
        NSLog(@"请求失败");
        
    }];
    
}

- (void)getDataFromBodySym
{
    SpmListByBodyModelR *model = [SpmListByBodyModelR new];
    model.currPage = @"1";
    model.pageSize = @"0";
    model.bodyCode = self.requsetDic[@"bodyCode"];
    model.population = self.requsetDic[@"population"];
    model.position = self.requsetDic[@"position"];
    model.sex = self.requsetDic[@"sex"];
    if (self.spmCode.length > 0) {
        model.bodyCode = self.spmCode;
    }
    
    [Order QuerySpmInfoListByBodyWithParams:model success:^(id obj) {
        
        SpmListByBodyPage *page = obj;
        NSArray *array = page.list;
        [self httpRequestResult:array];
        
        
    } failure:^(HttpException *e) {
        
    }];
    
}

- (void)getDataFromsearchSym
{
    
}



@end
