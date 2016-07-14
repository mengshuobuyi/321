//
//  TrainingListViewController.m
//  wenYao-store
//
//  培训列表
//  h5/train/trainList
//  h5/train/trainDetails
//  Created by PerryChen on 5/4/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "TrainingListViewController.h"
#import "TagView.h"
#import "TagListView.h"
#import "TrainingCell/TrainingListCell.h"
#import "WebDirectViewController.h"
#import "Train.h"
#import "WebDirectModel.h"
#import "WebDirectMacro.h"
#import "FinderSearchViewController.h"
#import "CustomTrainingListFilterView.h"
@interface TrainingListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *arrTraningList;
@property (nonatomic, assign) NSInteger preLoadIndex;
@property (nonatomic, assign) NSInteger storedLoadNum;
@property (strong, nonatomic) IBOutlet UIView *viewNavTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNaviTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;

@property (nonatomic, assign) BOOL isShowFilter;
@property (nonatomic, assign) NSInteger intSelectType;
@property (nonatomic, strong) CustomTrainingListFilterView *viewFilter;
@end

@implementation TrainingListViewController
static NSString *const TrainingListIdentifier = @"TrainingListCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrTraningList = [NSMutableArray array];
    self.navigationItem.titleView = self.viewNavTitle;
    self.intSelectType = 0;
    self.pageSize = 10;
    self.preLoadIndex = -1;
    self.storedLoadNum = 0;
    self.curPage = 1;
    self.isShowFilter = NO;
    self.viewFilter = (CustomTrainingListFilterView *)[[NSBundle mainBundle] loadNibNamed:@"CustomTrainingListFilterView" owner:self options:nil][0];
    __block typeof(self) wself = self;
    self.viewFilter.imgTickAll.hidden = NO;
    self.viewFilter.lblAll.textColor = RGBHex(qwColor1);
    self.viewFilter.blockCancel = ^(){
        wself.isShowFilter = !wself.isShowFilter;
        [wself rotateArrow];
    };
    self.viewFilter.blockConfirm = ^(NSInteger idx) {
        wself.intSelectType = idx;
        wself.isShowFilter = !wself.isShowFilter;
        if (idx == 0) {
            [QWGLOBALMANAGER statisticsEventId:@"培训_筛选_看全部" withLable:@"培训" withParams:nil];
        } else {
            [QWGLOBALMANAGER statisticsEventId:@"培训_筛选_看本商家" withLable:@"培训" withParams:nil];
        }
        [wself setNaviHeader];
        wself.preLoadIndex = -1;
        wself.storedLoadNum = 0;
        wself.curPage = 1;
        [wself.tbViewContent reloadData];
        wself.tbViewContent.footer.canLoadMore = YES;
        [wself getTrainingList];
    };
    [self.tbViewContent addFooterWithCallback:^{
        [HttpClient sharedInstance].progressEnabled = NO;
        self.curPage ++;
        [self getTrainingList];
    }];
    [HttpClient sharedInstance].progressEnabled = YES;
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
    } else {
        [self getTrainingList];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpRightItemSeven];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isShowFilter = NO;
    [self.viewFilter removeFromSuperview];
}

- (IBAction)actionFilter:(id)sender {
    
    if (self.isShowFilter == NO) {
        CGRect rectFrame = self.view.frame;
        self.viewFilter.frame = CGRectMake(rectFrame.origin.x, 0, rectFrame.size.width, rectFrame.size.height);
        [self.view addSubview:self.viewFilter];
        self.viewFilter.alpha = 0;
        [UIView animateWithDuration:0.5f animations:^{
            self.viewFilter.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.imgArrow.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [self.viewFilter removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            self.imgArrow.transform = CGAffineTransformMakeRotation(M_PI*2);
        }];
    }
    self.isShowFilter = !self.isShowFilter;
    [QWGLOBALMANAGER statisticsEventId:@"培训_筛选按键" withLable:@"培训" withParams:nil];
}

- (void)setNaviHeader
{
    if (self.intSelectType == 0) {
        self.lblNaviTitle.text = @"全部";
    } else if (self.intSelectType == 1) {
        self.lblNaviTitle.text = @"本商家";
    }

    [self rotateArrow];
    [self.viewNavTitle layoutIfNeeded];
    [self.viewNavTitle setNeedsLayout];
}

- (void)rotateArrow
{
    if (self.isShowFilter) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imgArrow.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.imgArrow.transform = CGAffineTransformMakeRotation(M_PI*2);
        }];
    }
}

- (void)setUpRightItemSeven {
 
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0,70, 44)];
    bg.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 0, 60, 44);
    [btn setTitle:@"知识库" forState:UIControlStateNormal];
    btn.titleLabel.font = fontSystem(kFontS1);
    [btn addTarget:self action:@selector(pushToYBZ) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
    self.navigationItem.rightBarButtonItems = @[fixed,item];
    
    
}

-(void)pushToYBZ{
    // 药病症问答库
    
    [QWGLOBALMANAGER statisticsEventId:@"培训_知识库" withLable:@"培训" withParams:nil];
    
    FinderSearchViewController * searchViewController = [[FinderSearchViewController alloc] initWithNibName:@"FinderSearchViewController" bundle:nil];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self.tbViewContent viewWithTag:1018] == nil) {
        [self enableSimpleRefresh:self.tbViewContent block:^(SRRefreshView *sender) {
            self.curPage = 1;
            [HttpClient sharedInstance].progressEnabled = NO;
//            [self.arrTraningList removeAllObjects];
//            [self.tbViewContent reloadData];
            self.tbViewContent.footer.canLoadMore = YES;
            [self getTrainingList];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  获取培训列表
 */
- (void)getTrainingList
{

    TrainListModelR *modelR = [TrainListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.viewType = @"0";
    if (self.intSelectType == 0) {
        modelR.searchSource = @"1";
    } else {
        modelR.searchSource = @"2";
    }
    modelR.page = [NSString stringWithFormat:@"%d",self.curPage];
    modelR.pageSize = [NSString stringWithFormat:@"%d",self.pageSize];
    [Train queryTrainList:modelR success:^(TrainListVoModel *responseModel) {
        [self.tbViewContent.footer endRefreshing];
        [self removeInfoView];
        self.pageSize = 10;
        if (self.curPage == 1) {
//            self.tbViewContent.footer.canLoadMore = YES;
            [self.arrTraningList removeAllObjects];
        }
        if (responseModel.trainList.count > 0) {
            [self.arrTraningList addObjectsFromArray:responseModel.trainList];
        } else {
            if (self.curPage == 1) {
                [self showInfoView:@"暂无数据" image:@"ic_img_fail"];
            } else {
                self.tbViewContent.footer.canLoadMore = NO;
            }
        }
        [self.tbViewContent reloadData];
        if (self.preLoadIndex > 0) {
            [self.tbViewContent scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.preLoadIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    } failure:^(HttpException *e) {
        [self.tbViewContent.footer endRefreshing];
    }];
}

- (void)refreshList
{
//    self.curPage = 1;
//    self.pageSize = self.storedLoadNum;
//    [self.arrTraningList removeAllObjects];
//    [self getTrainingList];

    TrainDetailModelR *modelR = [TrainDetailModelR new];
    __block TrainVoModel *model = self.arrTraningList[self.preLoadIndex];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.trainId = model.trainId;
    modelR.reqChannel = @"0";
    [Train queryTrainDetail:modelR success:^(TrainVoModel *responseModel) {
        if (responseModel != nil) {
            model.score = responseModel.score;
            model.flagfinis = responseModel.flagfinis;
            [self.tbViewContent reloadData];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark - UITableView Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainVoModel *model = self.arrTraningList[indexPath.section];
    TrainingListCell *cell = [tableView dequeueReusableCellWithIdentifier:TrainingListIdentifier];
    cell.viewTagList.textFont = fontSystem(kFontS5);
    cell.lblContent.textColor = RGBHex(qwColor6);
    cell.lblTimeContent.textColor = RGBHex(qwColor9);
    cell.lblContent.font = fontSystem(kFontS2);
    cell.lblTimeContent.font = fontSystem(kFontS5);
    cell.lblAwardContent.font = fontSystem(kFontS4);
    cell.lblTop.hidden = YES;
    cell.lblTop.layer.borderColor = RGBHex(qwColor9).CGColor;
    cell.lblTop.layer.borderWidth = 0.5f;
    cell.lblTop.layer.cornerRadius = 2.0f;
    if ([model.flagTop boolValue] == YES) {
        cell.lblTop.hidden = NO;
    }
    NSArray *arrTags = [model.tag componentsSeparatedByString:SeparateStr];
    [cell.viewTagList removeAllTags];
    NSInteger intMax = MIN(arrTags.count, 2);
    for (int i = 0; i < intMax; i++) {
        [cell.viewTagList addTag:arrTags[i]];
    }
    cell.lblContent.text = model.title;
    cell.lblAwardContent.text = @"";
    cell.lblTimeContent.text = model.publishDate;
    if ([model.score intValue] > 0) {
        if ([model.flagfinis boolValue] == YES) {
            cell.lblAwardContent.textColor = RGBHex(qwColor9);
            cell.lblAwardContent.text = [NSString stringWithFormat:@"已完成，获得%@积分",model.score];
        } else {
            cell.lblAwardContent.textColor = RGBHex(qwColor2);
            if ([model.type intValue] == 1) {
                cell.lblAwardContent.text = [NSString stringWithFormat:@"答对奖励%@积分",model.score];
            } else {
                cell.lblAwardContent.text = [NSString stringWithFormat:@"点击学习奖励%@积分",model.score];
            }
        }
    } else {
        cell.lblAwardContent.text = @"";
    }

    [cell.imgViewContent setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"img_goods_default"]];
    cell.imgQuestionnaIRE.hidden = YES;
    if ([model.type intValue] == 1) {
        cell.imgQuestionnaIRE.hidden = NO;
    } else {
        
    }
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrTraningList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10.0f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainVoModel *model = self.arrTraningList[indexPath.section];
    [QWGLOBALMANAGER statisticsEventId:@"培训_列表点击" withLable:@"培训" withParams:nil];
    if ([model.type intValue] == 1) {
        WebQuestionnaireDetailModel *modelQuestion = [WebQuestionnaireDetailModel new];
        modelQuestion.trainingId = model.trainId;
        WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
        modelLocal.modelQuestionnaire = modelQuestion;
//        modelLocal.title = model.title;
        modelLocal.typeLocalWeb = WebLocalTypeQuestionnaireDetail;
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        [vcWebDirect setWVWithLocalModel:modelLocal];
        NSInteger intSelected = indexPath.section;
        self.storedLoadNum = (intSelected / 10 + 1) * 10;
        self.preLoadIndex = indexPath.section;
        __weak typeof(self) weakSelf = self;
        vcWebDirect.blockRefresh = ^(){
//            TrainVoModel *model = self.arrTraningList[indexPath.section];
//            model.title = @"aaa";
            [weakSelf refreshList];
//            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [tableView reloadData];
        };
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    } else {
        WebQuestionnaireDetailModel *modelQuestion = [WebQuestionnaireDetailModel new];
        modelQuestion.trainingId = model.trainId;
        WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
        modelLocal.modelQuestionnaire = modelQuestion;
//        modelLocal.title = model.title;
        modelLocal.typeLocalWeb = WebLocalTypeTrainingDetail;
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        [vcWebDirect setWVWithLocalModel:modelLocal];
//        NSInteger intSelected = indexPath.section;
//        self.storedLoadNum = (intSelected / 10 + 1) * 10;
        self.preLoadIndex = indexPath.section;
        __weak typeof(self) weakSelf = self;
        vcWebDirect.blockRefresh = ^(){
            //            TrainVoModel *model = self.arrTraningList[indexPath.section];
            //            model.title = @"aaa";
            [weakSelf refreshList];
            //            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            //            [tableView reloadData];
        };
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }

}

@end
