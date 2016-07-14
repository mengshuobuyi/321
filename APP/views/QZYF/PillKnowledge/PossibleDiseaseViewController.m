//
//  PossibleDiseaseViewController.m
//  quanzhi
//
//  Created by Meng on 14-8-7.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "PossibleDiseaseViewController.h"
#import "PossibleDiseaseCell.h"
#import "Constant.h"
#import "ZhPMethod.h"
#import "DiseaseDetailViewController.h"
#import "JGProgressHUD.h"
#import "Drug.h"

#define F_TITLE  14
#define F_DESC   12
#define NODATAVIEWTAG 14061010

@interface PossibleDiseaseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    PossibleDiseaseCell * myCell;
    UIFont *cellTitleFont;
    UIFont *cellContentFont;
    UIView *_nodataView;
    
    NSInteger m_descFont;
    NSInteger m_titleFont;
    BOOL m_collected;
    BOOL isUp;
    
}
@property (nonatomic ,strong) NSMutableArray * dataArray;

@end

@implementation PossibleDiseaseViewController

- (id)init{
    if (self = [super init]) {
        isUp = YES;
        m_descFont = F_DESC;
        m_titleFont = F_TITLE;
        m_collected = NO;
        cellTitleFont = [UIFont boldSystemFontOfSize:m_titleFont];
        cellContentFont = [UIFont systemFontOfSize:m_descFont];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)zoomClick{
    if (m_descFont == 18) {
        isUp = NO;
    }else if(m_descFont == 12){
        isUp = YES;
    }
    if (isUp) {
        m_descFont+=3;
        m_titleFont+=3;
    }else{
        m_descFont = 12;
        m_titleFont = 12;
    }
    cellTitleFont = [UIFont boldSystemFontOfSize:m_titleFont];
    cellContentFont = [UIFont systemFontOfSize:m_descFont];
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataArray.count) {
        return;
    }
    PossibleDiseaseR *model=[PossibleDiseaseR new];
    model.spmCode=self.spmCode;
    model.currPage=@"1";
    model.pageSize=@"0";
    [Drug queryAssociationDiseaseWithParams:model success:^(id resultOBJ) {
        DiseaseClassPage *mod=(DiseaseClassPage *)resultOBJ;
        self.dataArray = (NSMutableArray *)mod.list;
        if (self.dataArray.count > 0) {
            [_tableView reloadData];
        }else{
            [self showInfoView:@"暂无该可能的疾病" image:@"无可能疾病icon.png"];
            
        }
    } failure:^(HttpException *e) {
        [self showNoDataViewWithString:e.Edescription];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"可能疾病";
    self.dataArray = [NSMutableArray array];
    cellTitleFont = [UIFont boldSystemFontOfSize:m_titleFont];
    cellContentFont = [UIFont systemFontOfSize:m_descFont];
    [self makeUpTableView];
}

- (void)setUpRightBarButton{
    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(shareBtnClick)];
    self.navigationController.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)makeUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H-35)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PossibleDiseaseCell getCellHeight:self.dataArray[indexPath.row] withFont:cellTitleFont  descFont:cellContentFont];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellIdentifier";
    PossibleDiseaseCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        NSBundle * bundle = [NSBundle mainBundle];
        NSArray * cellViews = [bundle loadNibNamed:@"PossibleDiseaseCell" owner:self options:nil];
        cell = [cellViews objectAtIndex:0];
        }
    PossibleDisease *disease = self.dataArray[indexPath.row];

    [cell setPossibleCell:disease row:(NSInteger)indexPath.row fontSize:(UIFont *)cellTitleFont contentSize:(UIFont *)cellContentFont];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSIndexPath*    selection = [_tableView indexPathForSelectedRow];
    if (selection) {
        [_tableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    DiseaseDetailViewController* dvc = [[DiseaseDetailViewController alloc] initWithNibName:@"DiseaseDetailViewController" bundle:nil];
    PossibleDisease *model=self.dataArray[indexPath.row];
    
    dvc.diseaseType = model.type;
    dvc.diseaseId = model.diseaseId;
    dvc.title = model.name;
    dvc.containerViewController = self.containerViewController;
    if (self.containerViewController) {
        [self.containerViewController.navigationController pushViewController:dvc animated:YES];
    }else
    {
        [self.navigationController pushViewController:dvc animated:YES];
    }

}

- (void)viewDidCurrentView
{
    if (self.dataArray.count) {
        return;
    }
    PossibleDiseaseR *model=[PossibleDiseaseR new];
    model.spmCode=self.spmCode;
    [Drug queryAssociationDiseaseWithParams:model success:^(id resultOBJ) {
        DiseaseClassPage *mod=(DiseaseClassPage *)resultOBJ;
        self.dataArray = (NSMutableArray *)mod.list;
        if (self.dataArray.count > 0) {
            [_tableView reloadData];
        }else{
            [self showInfoView:@"暂无该可能的疾病" image:@"无可能疾病icon.png"];
        }

    } failure:^(HttpException *e) {
    [self showNoDataViewWithString:e.Edescription];
    }];
}

- (void)shareBtnClick
{
//    DebugLog(@"需要加入分享模块");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zoomOutSubViews
{
    CGFloat pointSize = cellTitleFont.pointSize;
    if (pointSize >= 20)
        return;
    ++pointSize;
    cellTitleFont = [UIFont boldSystemFontOfSize:pointSize];
    pointSize = cellContentFont.pointSize;
    ++pointSize;
    cellContentFont = [UIFont systemFontOfSize:pointSize];
    [_tableView reloadData];
}

- (void)zoomInSubViews
{
    CGFloat pointSize = cellTitleFont.pointSize;
    if (pointSize <= 8)
        return;
    --pointSize;
    cellTitleFont = [UIFont boldSystemFontOfSize:pointSize];
    pointSize = cellContentFont.pointSize;
    --pointSize;
    cellContentFont = [UIFont systemFontOfSize:pointSize];
    [_tableView reloadData];
}




#pragma mark - INDICTOR
-(void)showNoDataViewWithString:(NSString *)nodataPrompt
{
    if (nodataPrompt==nil) {
        nodataPrompt = @"暂无数据";
    }
    if (_nodataView==nil) {
        _nodataView = [[UIView alloc]initWithFrame:self.view.bounds];
        _nodataView.backgroundColor =RGBHex(qwColor11);
        
        UIImageView *dataEmpty = [[UIImageView alloc]initWithFrame:RECT(0, 0, 75, 75)];
        dataEmpty.center = CGPointMake(APP_W/2, 130);
        dataEmpty.image = [UIImage imageNamed:@"无可能疾病icon"];
        [_nodataView addSubview:dataEmpty];
        
        UILabel* lable_ = [[UILabel alloc]initWithFrame:RECT(0,200, nodataPrompt.length*20,30)];
        lable_.tag = 201405220;
        lable_.font = fontSystem(kFontS5);
        lable_.textColor = RGBHex(qwColor9);
        lable_.textAlignment = NSTextAlignmentCenter;
        lable_.center = CGPointMake(APP_W/2, 200);
        lable_.text = nodataPrompt;
        [_nodataView addSubview:lable_];
        [[UIApplication sharedApplication].keyWindow addSubview:_nodataView];
        [self.view insertSubview:_nodataView atIndex:self.view.subviews.count];
    }else{
        UILabel *label_ = (UILabel *)[_nodataView viewWithTag:201405220];
        label_.text = nodataPrompt;
        label_.textAlignment =NSTextAlignmentCenter;
        label_.frame = RECT(0,175, nodataPrompt.length*20,30);
        label_.center = CGPointMake(APP_W/2, label_.center.y);
        _nodataView.hidden = NO;
    }
}



@end
