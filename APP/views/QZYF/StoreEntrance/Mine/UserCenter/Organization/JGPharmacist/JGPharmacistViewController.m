//
//  JGPharmacistViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "JGPharmacistViewController.h"
#import "JGCell.h"
#import "EditPharmacistViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Store.h"
#import "StoreModel.h"
#import "PharmacistModel.h"

#define kJGPharmacistViewControllerDefaultNameModel  @"kJGPharmacistViewControllerDefaultNameModel"

@interface JGPharmacistViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *bgView;
}
@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic ,strong) NSMutableArray * checkArr;

@property (nonatomic ,strong) UIImageView * noPharmacistView;
@property (nonatomic ,strong) UILabel * pharmacistLabel;

@end

@implementation JGPharmacistViewController

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
        [self loadData];
    }else{
        NSArray *arr = [QWUserDefault getObjectBy:kJGPharmacistViewControllerDefaultNameModel];
        if (arr == nil || arr.count == 0) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else{
            if (bgView) {
                [bgView removeFromSuperview];
            }
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:arr];
            [self.tableMain reloadData];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableMain.rowHeight = 50;
    self.dataSource = [NSMutableArray array];
    self.checkArr = [NSMutableArray array];
    self.tableMain.delegate = self;
    self.tableMain.dataSource = self;
    self.tableMain.backgroundColor = [UIColor clearColor];
    [self.tableMain setFrame:CGRectMake(0, 0, self.tableMain.frame.size.width, APP_H-NAV_H)];
    [self.tableMain removeFooter];
    self.tableMain.scrollEnabled=YES;
    
    [self getNotifType:NotifQuitOut data:nil target:self];
    
    [self.view addSubview:self.tableMain];
    [self setUpFootView];
    
}

- (void)showNoData
{
    if (bgView) {
        [bgView removeFromSuperview];
        bgView = nil;
    }
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = RGBHex(qwColor11);
    
    UIImage * pharmacistImage = [UIImage imageNamed:@"img_no_pharmacist_tips"];
    self.noPharmacistView = [[UIImageView alloc] init];
    if (IS_IPHONE_6) {
        self.noPharmacistView.frame = CGRectMake((APP_W-142)/2, 140, 142, 123);
    }else if (IS_IPHONE_6P){
        self.noPharmacistView.frame = CGRectMake((APP_W-142)/2, 170, 142, 123);
    }else{
        self.noPharmacistView.frame = CGRectMake((APP_W-142)/2, 80, 142, 123);
    }

    self.noPharmacistView.image = pharmacistImage;
    [bgView addSubview:self.noPharmacistView];
    
    NSString * str = @"您还没有药师,快来添加吧!";
    CGSize strSize = [QWGLOBALMANAGER sizeText:str font:fontSystem(kFontS3)];
    
    self.pharmacistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.noPharmacistView.frame.origin.y + self.noPharmacistView.frame.size.height, APP_W, strSize.height)];
    self.pharmacistLabel.font = fontSystem(kFontS1);
    self.pharmacistLabel.textAlignment = NSTextAlignmentCenter;
    
    self.pharmacistLabel.textColor = RGBHex(qwColor8);
    self.pharmacistLabel.text = str;
    [bgView addSubview:self.pharmacistLabel];
    
    [self.view insertSubview:bgView atIndex:self.view.subviews.count-1];
}

- (void)setUpFootView
{
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    foot.backgroundColor = [UIColor clearColor];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 8, APP_W, 46)];
    [foot addSubview:bg];
    bg.backgroundColor = [UIColor whiteColor];
    
    UIView *xx = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 46)];
    xx.center = CGPointMake(APP_W/2, 23);
    [bg addSubview:xx];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 20, 20)];
    image.image = [UIImage imageNamed:@"btn_img_add_green"];
    [xx addSubview:image];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 64, 46)];
    lab.text = @"添加药师";
    lab.font = fontSystem(kFontS3);
    lab.textColor = RGBHex(qwColor1);
    [xx addSubview:lab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPharmacistClick)];
    [bg addGestureRecognizer:tap];
    
    self.tableMain.tableFooterView = foot;
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotifQuitOut) {
        [self.dataSource removeAllObjects];
        [self.checkArr removeAllObjects];
        [self.tableMain reloadData];
    }
}

- (void)loadData
{
    if (!QWGLOBALMANAGER.configure.groupId) {
        return;
    }
    
    [Store queryPharmacistNewWithGroupId:QWGLOBALMANAGER.configure.groupId success:^(id responseObj) {
        PharmacistListModel *listModel = (PharmacistListModel *)responseObj;
        if ([listModel.apiStatus integerValue] == 0) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:listModel.list];
            if (self.dataSource.count >0) {
                if (bgView) {
                    [bgView removeFromSuperview];
                }
                [QWUserDefault setObject:self.dataSource key:kJGPharmacistViewControllerDefaultNameModel];
                [self.tableMain reloadData];
            }else{
                [self showNoData];
            }
        }else if ([listModel.apiStatus integerValue ] == 1){
            [self showNoData];
        }

    } failure:^(HttpException *e) {
        
    }];
}

- (void)addPharmacistClick
{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }

    EditPharmacistViewController *editPharmacist = [[EditPharmacistViewController alloc] initWithNibName:@"EditPharmacistViewController" bundle:nil];
    editPharmacist.title = @"添加药师";
    editPharmacist.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editPharmacist animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellIdentifier";
    JGCell *cell =(JGCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"JGCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PharmacistMemberModel *memberModel = self.dataSource[indexPath.row];
    
    //approveStatus (int, optional): 审核状态 (0:未审核,1:审核不通过,2:审核通过),
    NSInteger approveStatus = [memberModel.approveStatus integerValue];
    
    switch (approveStatus) {
        case 0://0:审核中
        {
            cell.waitStatus.hidden = NO;
        }
            break;
        case 1://1:审核不通过
        {
            cell.noPassStatus.hidden = NO;
        }
            break;
        case 2://2:审核通过
        {
            if ([memberModel.validResult isEqualToString:@"0"]) {//过期
                cell.timeOverStatus.hidden = NO;
            }
        }
            break;
        case 3://3:未完善
        {
            cell.notPerfectLabel.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    cell.titleLabel.text = memberModel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PharmacistMemberModel *memberModel = self.dataSource[indexPath.row];
    
    EditPharmacistViewController *editPharmacist = [[EditPharmacistViewController alloc] initWithNibName:@"EditPharmacistViewController" bundle:nil];
    editPharmacist.title = memberModel.name;
    editPharmacist.memberModel = memberModel;
    editPharmacist.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editPharmacist animated:YES];
}



@end
