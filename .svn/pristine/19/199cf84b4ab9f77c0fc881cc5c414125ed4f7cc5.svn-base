//
//  HealthQAResultListViewController.m
//  wenyao-store
//
//  Created by chenzhipeng on 4/3/15.
//  Copyright (c) 2015 xiezhenghong. All rights reserved.
//

#import "HealthQAResultListViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "HealthQADetailViewController.h"
#import "HealthQAResultCell.h"
#import "SVProgressHUD.h"

#import "QALibrary.h"
#import "QALibraryModel.h"
#import "QALibraryModelR.h"

@interface HealthQAResultListViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{

}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tbViewResult;
@property (weak, nonatomic) IBOutlet UIView *viewNoContent;
@property (assign, nonatomic) NSInteger curPage;
@property (nonatomic, strong) NSMutableArray *arrLibraryResultList;
@end

@implementation HealthQAResultListViewController
static int pageSize = 15;
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnCancel setFrame:CGRectMake(0, 0, 40, 40)];
//    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
//    btnCancel.titleLabel.textAlignment = NSTextAlignmentRight;
//    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    [btnCancel addTarget:self action:@selector(popToRoot) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barBtnItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
//    self.navigationItem.rightBarButtonItem = barBtnItemRight;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    
//    UIBarButtonItem *barBtnItemRight = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot)];
//    self.navigationItem.rightBarButtonItem = barBtnItemRight;
    self.arrLibraryResultList = [@[] mutableCopy];
    self.curPage = 1;
    [self queryQAResultList];
    self.navigationItem.title = self.strKeyWord;
    __weak HealthQAResultListViewController *weakSelf = self;
    [self.tbViewResult addFooterWithCallback:^{
        weakSelf.curPage ++;
        [weakSelf queryQAResultList];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    NSIndexPath *indexPath = [self.tbViewResult indexPathForSelectedRow];
    if(indexPath) {
        [self.tbViewResult deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)popToRoot
{
    [self.navigationController popToViewController:self.delegatePopVC animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchbar methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popToViewController:self.delegatePopVC animated:YES];
}
#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthQAResultCell *cellHis = [tableView dequeueReusableCellWithIdentifier:@"cellResultList"];
    QALibraryHIQuestionModel *model = self.arrLibraryResultList[indexPath.row];
    NSString *oriStrContent = model.question;
    NSDictionary *greenAttrs = @{NSForegroundColorAttributeName: RGBHex(qwColor1)};
    NSMutableAttributedString *strQiz = [[NSMutableAttributedString alloc] initWithString:oriStrContent];
    
    for (QALibraryHIPositionsModel *modelPosition in model.hlPositions) {
        [strQiz setAttributes:greenAttrs range:NSMakeRange([modelPosition.start intValue], [modelPosition.length intValue])];
    }
    cellHis.lblQuizContent.attributedText = strQiz;
    return cellHis;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrLibraryResultList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark - view model methods
- (void)queryQAResultList
{
    if(QWGLOBALMANAGER.currentNetWork == NotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        return;
    }
    QALibraryListModelR *modelR = [[QALibraryListModelR alloc] init];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.keyword = self.strKeyWord;
    modelR.classifyName = self.modelCount.classifyName;
    modelR.currPage = [NSString stringWithFormat:@"%d",self.curPage];
    modelR.pageSize = [NSString stringWithFormat:@"%d",pageSize];
    __weak HealthQAResultListViewController *weakSelf = self;
    [QALibrary getQALibraryListWithParams:modelR success:^(id obj) {
        [weakSelf.tbViewResult footerEndRefreshing];
        QALibraryHIQuestionListModel *model = (QALibraryHIQuestionListModel *)obj;
        
        if (weakSelf.curPage == 1) {
            [weakSelf.arrLibraryResultList removeAllObjects];
        }
        
        [weakSelf.arrLibraryResultList addObjectsFromArray:model.list];
        if (weakSelf.arrLibraryResultList.count == 0) {
            weakSelf.tbViewResult.hidden = YES;
            weakSelf.viewNoContent.hidden = NO;
            return;
        }
        
        self.tbViewResult.hidden = NO;
        self.viewNoContent.hidden = YES;
        [self.tbViewResult reloadData];
    } failure:^(HttpException *e) {
        [weakSelf.tbViewResult footerEndRefreshing];
        if (weakSelf.curPage == 1) {
            weakSelf.tbViewResult.hidden = YES;
            weakSelf.viewNoContent.hidden = NO;
        }

    }];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueQADetail"]) {
        if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
            return;
        }
        
        UITableViewCell *cellSelect = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tbViewResult indexPathForCell:cellSelect];
        HealthQADetailViewController *viewControllerDetail = (HealthQADetailViewController *)segue.destinationViewController;
        QALibraryHIQuestionModel *modelList = self.arrLibraryResultList[indexPath.row];
        viewControllerDetail.questionID = modelList.id;
        viewControllerDetail.questionTitle = modelList.question;
    }
}
@end
