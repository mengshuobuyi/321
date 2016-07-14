//
//  HealthQASearchViewController.m
//  wenyao-store
//
//  Created by chenzhipeng on 4/1/15.
//  Copyright (c) 2015 xiezhenghong. All rights reserved.
//

#import "HealthQASearchViewController.h"
#import "HealthQAResultListViewController.h"
#import "HealthQASearchCountCell.h"
#import "QALibraryModel.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#import "QALibraryModel.h"
#import "QALibrary.h"
#import "QALibraryModelR.h"
static CGFloat heightIndicatorHeight_5 = 201.0f;
static CGFloat heightIndicatorHeight_6 = 223.0f;
static CGFloat heightIndicatorHeight_6P = 231.0f;

static CGFloat heightViewHelperHeight_5 = 90.0f;
static CGFloat heightViewHelperHeight_6 = 113.0f;
static CGFloat heightViewHelperHeight_6P = 120.0f;


@interface HealthQASearchViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSearchHisBottom;


@property (weak, nonatomic) IBOutlet UITableView *tbViewSearchList;
@property (weak, nonatomic) IBOutlet UITableView *tbViewSearchHistory;
@property (weak, nonatomic) IBOutlet UIView *viewNoSearchHistory;
@property (weak, nonatomic) IBOutlet UIView *viewNoSearchContent;
@property (weak, nonatomic) IBOutlet UIView *viewShowHelper;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewShowHelper;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintIndicatorViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHelpHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_SearchHint;

@property (strong, nonatomic) IBOutlet UIView *viewClearHistory;

@property (nonatomic, strong) NSMutableArray* arrSearchHis;
@property (nonatomic, strong) NSArray* arrLibCountList;

- (IBAction)btnPressed_clearHistory:(id)sender;
- (IBAction)btnPressed_showHelper:(id)sender;


@end

@implementation HealthQASearchViewController

typedef enum ViewStatus
{
    ViewStatusInitial,      // 初始状态
    ViewStatusContent,      // 有搜索字，显示正常
    ViewStatusNoHistory,    // 无搜索字，无历史数据
    ViewStatusHasHistory,   // 无搜索字，有历史数据
    ViewStatusNoContent     // 有搜索字，无内容
}ViewStatus;

static int maxHis = 5;

- (void)setViewStatus:(ViewStatus)status
{
    if (status == ViewStatusContent) {
        self.tbViewSearchList.hidden = NO;
        self.tbViewSearchHistory.hidden = YES;
        self.viewNoSearchHistory.hidden = YES;
        self.viewNoSearchContent.hidden = YES;
    } else if (status == ViewStatusNoContent) {
        self.tbViewSearchList.hidden = YES;
        self.tbViewSearchHistory.hidden = YES;
        self.viewNoSearchHistory.hidden = YES;
        self.viewNoSearchContent.hidden = NO;
    } else if (status == ViewStatusHasHistory) {
        self.tbViewSearchList.hidden = YES;
        self.viewNoSearchHistory.hidden = YES;
        self.tbViewSearchHistory.hidden = NO;
        self.viewNoSearchContent.hidden = YES;
    } else if (status == ViewStatusNoHistory) {
        self.tbViewSearchList.hidden = YES;
        self.viewNoSearchHistory.hidden = NO;
        self.tbViewSearchHistory.hidden = YES;
        self.viewNoSearchContent.hidden = YES;
    } else if (status == ViewStatusInitial) {
        
    }
}

// 帮助页面设置
- (void)setupHelperScrollView
{
    NSLayoutConstraint *constraintImgTop = nil;
    NSLayoutConstraint *constraintImgLeading = nil;
    NSLayoutConstraint *constraintImgBottom = nil;
    UIView *previousView = nil;
    for (int i = 0; i < 4; i++) {
        UIView *tempView = [[UIView alloc] init];
        tempView.backgroundColor = [UIColor clearColor];
        tempView.translatesAutoresizingMaskIntoConstraints = NO;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        UIImage *imgCon = nil;
        if (i == 0) {
            if (IS_IPHONE_6) {
                imgCon = [UIImage imageNamed:@"search_img_drugs-guide-667"];
            } else {
                imgCon = [UIImage imageNamed:@"search_img_drugs-guide"];
            }
            imgView.image = imgCon;//[UIImage imageNamed:@"search_img_drugs-guide"];
        } else if (i == 1) {
            if (IS_IPHONE_6) {
                imgCon = [UIImage imageNamed:@"search_img_disease-guide-667"];
            } else {
                imgCon = [UIImage imageNamed:@"search_img_disease-guide"];
            }
            imgView.image = imgCon;//[UIImage imageNamed:@"search_img_disease-guide"];
        } else if (i == 2) {
            if (IS_IPHONE_6) {
                imgCon = [UIImage imageNamed:@"search_img_nutrition-guide-667"];
            } else {
                imgCon = [UIImage imageNamed:@"search_img_nutrition-guide"];
            }
            imgView.image = imgCon;//[UIImage imageNamed:@"search_img_nutrition-guide"];
        } else if (i == 3) {
            if (IS_IPHONE_6) {
                imgCon = [UIImage imageNamed:@"search_img_nursing-guide-667"];
            } else {
                imgCon = [UIImage imageNamed:@"search_img_nursing-guide"];
            }
            imgView.image = imgCon;//[UIImage imageNamed:@"search_img_nursing-guide"];
        }
      
        if (!previousView) {
            constraintImgLeading = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollViewShowHelper attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        } else {
            constraintImgLeading = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        }
        constraintImgTop = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollViewShowHelper attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0];
        constraintImgBottom = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollViewShowHelper attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0];
        [self.scrollViewShowHelper addSubview:tempView];
        [self.scrollViewShowHelper addConstraints:@[constraintImgTop,constraintImgLeading,constraintImgBottom]];
        // 增加imageView 的约束
        [tempView addSubview:imgView];
        [tempView addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [tempView addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [tempView addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [tempView addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        
        // 增加button的约束
        UIButton *btnCloseHelper = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCloseHelper.translatesAutoresizingMaskIntoConstraints = NO;
        [btnCloseHelper setTitle:@"我知道了" forState:UIControlStateNormal];
        [btnCloseHelper setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tempView addSubview:btnCloseHelper];
        [btnCloseHelper addTarget:self
                           action:@selector(hideHelperView) forControlEvents:UIControlEventTouchUpInside];
        if (HIGH_RESOLUTION) {
            if (IS_IPHONE_6) {
                [tempView addConstraint:[NSLayoutConstraint constraintWithItem:btnCloseHelper attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-125.0]];
            } else if (IS_IPHONE_6P) {
                [tempView addConstraint:[NSLayoutConstraint constraintWithItem:btnCloseHelper attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-154.0]];
            } else {
                [tempView addConstraint:[NSLayoutConstraint constraintWithItem:btnCloseHelper attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-88.0]];
            }
            
        } else {
            [tempView addConstraint:[NSLayoutConstraint constraintWithItem:btnCloseHelper attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-56.0]];
        }
        
        [btnCloseHelper addConstraint:[NSLayoutConstraint constraintWithItem:btnCloseHelper attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:214.0]];
        [btnCloseHelper addConstraint:[NSLayoutConstraint constraintWithItem:btnCloseHelper attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:42.5]];
        [tempView addConstraint:[NSLayoutConstraint constraintWithItem:btnCloseHelper attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        
        previousView = tempView;
        
    }
    [self.scrollViewShowHelper addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollViewShowHelper attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void)setHelperViewStatus:(BOOL)isShow
{
    
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    if (isShow) {
        self.scrollViewShowHelper.contentOffset = CGPointZero;
        [frontWindow addSubview:self.viewShowHelper];
        self.viewShowHelper.frame = CGRectMake(0, frontWindow.frame.size.height, frontWindow.frame.size.width, frontWindow.frame.size.height);
        [self.searchBar resignFirstResponder];
        self.viewShowHelper.frame = CGRectMake(0, 0, frontWindow.frame.size.width, frontWindow.frame.size.height);
        self.scrollViewShowHelper.frame = self.viewShowHelper.frame;
//        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:nil animations:^{
//            
//        } completion:^(BOOL finished) {
//            
//        }];
        
    } else {
        [self.searchBar becomeFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            self.viewShowHelper.frame = CGRectMake(0, frontWindow.frame.size.height, frontWindow.frame.size.width, frontWindow.frame.size.height);
        }];
        [self.viewShowHelper removeFromSuperview];
    }
}

- (void)hideHelperView
{
    [self setHelperViewStatus:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrSearchHis = [@[] mutableCopy];
    self.arrLibCountList = [@[] mutableCopy];
    self.navigationItem.leftBarButtonItems = nil;
    [self convertButtonTitle:@"Cancel" toTitle:@"取消" inView:self.searchBar];
    
    // 设置偏移量
    if (iOSv8) {
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x + 5.0, self.searchBar.frame.origin.y, self.view.frame.size.width - 5.0, self.searchBar.frame.size.height);
    } else {
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x , self.searchBar.frame.origin.y, self.view.frame.size.width , self.searchBar.frame.size.height);
    }
    
    if (IS_IPHONE_6P) {
        self.constraintIndicatorViewHeight.constant = heightIndicatorHeight_6P;
        self.constraintViewHelpHeight.constant = heightViewHelperHeight_6P;
    } else if (IS_IPHONE_6) {
        self.imgView_SearchHint.image = [UIImage imageNamed:@"search_image-667"];
        self.constraintIndicatorViewHeight.constant = heightIndicatorHeight_6;
        self.constraintViewHelpHeight.constant = heightViewHelperHeight_6;
    } else {
        self.constraintIndicatorViewHeight.constant = heightIndicatorHeight_5;
        self.constraintViewHelpHeight.constant = heightViewHelperHeight_5;
    }
    
    [self setupHelperScrollView];
    [self getHealthQAHistory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.keyBoardShow = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.searchBar resignFirstResponder];
    [[self.navigationController.navigationBar viewWithTag:1008] removeFromSuperview];
    [self.searchBar removeFromSuperview];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBar methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        [self getHealthQAHistory];
    } else {
        [self queryHealthQizCount];
    }
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tbViewSearchList) {
        HealthQASearchCountCell *cellCon = [tableView dequeueReusableCellWithIdentifier:@"searchContentCell"];
        QALibraryQuestionClassifyModel *modelCount = self.arrLibCountList[indexPath.row];
        [cellCon setCell:modelCount];
        return cellCon;
    } else {
        UITableViewCell *cellHis = [tableView dequeueReusableCellWithIdentifier:@"searchHisCell"];
        QALibrarySearchResultModel *modelHis = self.arrSearchHis[indexPath.row];
        cellHis.textLabel.text = [NSString stringWithFormat:@"%@",modelHis.quizStr];
        return cellHis;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tbViewSearchList) {
        return self.arrLibCountList.count;
    } else {
        return self.arrSearchHis.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.tbViewSearchHistory) {
        return 51.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == self.tbViewSearchHistory) {
        return self.viewClearHistory;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tbViewSearchList) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tbViewSearchList) {
        
    } else if (tableView == self.tbViewSearchHistory) {
        QALibrarySearchResultModel *modelHis = self.arrSearchHis[indexPath.row];
        self.searchBar.text = modelHis.quizStr;
        [self queryHealthQizCount];
    }
}

#pragma mark - view model delegate
- (void)queryHealthQizCount
{
    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        return;
    }
    NSString *strSearch = self.searchBar.text;
    strSearch = [strSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strSearch isEqualToString:@""]) {
        return;
    }
    QALibraryCountModelR *modelR = [[QALibraryCountModelR alloc] init];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.keyword = strSearch;
    __weak HealthQASearchViewController *weakSelf = self;
    [QALibrary getQALibraryCountWithParams:modelR success:^(id obj) {
        QALibraryQuestionClassifyListModel *listModel = (QALibraryQuestionClassifyListModel *)obj;
        NSInteger intTotalCount = 0;
        for (QALibraryQuestionClassifyModel *modelCount in listModel.list) {
            intTotalCount += [modelCount.totalNum intValue];
        }
        if (intTotalCount == 0) {
            [weakSelf setViewStatus:ViewStatusNoContent];
        } else {
            [weakSelf setViewStatus:ViewStatusContent];
            weakSelf.arrLibCountList = listModel.list;
            [weakSelf.tbViewSearchList reloadData];
        }
    } failure:^(HttpException *e) {
        [weakSelf setViewStatus:ViewStatusNoContent];
    }];
}

- (void)getHealthQAHistory
{
    self.arrSearchHis = [[QALibrarySearchResultModel getArrayFromDBWithWhere:nil WithorderBy:@"rowid desc"] mutableCopy];
    if (self.arrSearchHis.count > 0) {
        // 有搜索历史
        [self setViewStatus:ViewStatusHasHistory];
        [self.tbViewSearchHistory reloadData];
    } else {
        // 无搜索历史
        [self setViewStatus:ViewStatusNoHistory];
    }
}

// 清除历史搜索记录
- (IBAction)btnPressed_clearHistory:(id)sender {
    [QALibrarySearchResultModel deleteAllObjFromDB];
    [self.arrSearchHis removeAllObjects];
    [self setViewStatus:ViewStatusNoHistory];
}

- (IBAction)btnPressed_showHelper:(id)sender {
    [self setHelperViewStatus:YES];
}

#pragma mark - the methods of keyboard
- (void)keyboardChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    [UIView animateWithDuration:animationDuration animations:^{
        self.constraintBottom.constant = height;
        self.constraintSearchHisBottom.constant = height;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.constraintBottom.constant = 0;
    self.constraintSearchHisBottom.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueResultList"]) {
        UITableViewCell *cellSelect = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tbViewSearchList indexPathForCell:cellSelect];
        NSString *strSearch = self.searchBar.text;
        strSearch = [strSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // 同步搜索历史
        for (int i = 0; i< self.arrSearchHis.count; i++) {
            QALibrarySearchResultModel *model = self.arrSearchHis[i];
            if ([model.quizStr isEqualToString:strSearch]) {
                [self.arrSearchHis removeObjectAtIndex:i];
                break;
            }
        }
//        if ([self.arrSearchHis containsObject:strSearch]) {
//            [self.arrSearchHis removeObject:strSearch];
//        }
        //如果一个超过5个  那么删除最后面一个
        if (self.arrSearchHis.count == maxHis) {
            [self.arrSearchHis removeObjectAtIndex:self.arrSearchHis.count-1];
        }
        //加到最顶端
        QALibrarySearchResultModel *modelSearch = [[QALibrarySearchResultModel alloc] init];
        modelSearch.quizStr = strSearch;
        [self.arrSearchHis insertObject:modelSearch atIndex:0];
        [QALibrarySearchResultModel deleteAllObjFromDB];
        [QALibrarySearchResultModel saveObjToDBWithArray:self.arrSearchHis];
        // 跳转页面
        HealthQAResultListViewController *viewControllerResult = (HealthQAResultListViewController *)segue.destinationViewController;
        viewControllerResult.delegatePopVC = self.delegatePopVC;
        viewControllerResult.strKeyWord = strSearch;
        viewControllerResult.modelCount = self.arrLibCountList[indexPath.row];
    }
}

@end
