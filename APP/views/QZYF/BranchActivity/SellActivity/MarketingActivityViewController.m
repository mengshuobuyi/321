
//
//  MarketingActivityViewController.m
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "MarketingActivityViewController.h"
#import "MarketingActivityTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MGSwipeButton.h"
#import "MarketDetailViewController.h"
#import "AddNewMarketActivityViewController.h"

@interface MarketingActivityViewController ()<MGSwipeTableCellDelegate>
{
    NSInteger currentPage;
}
@property (nonatomic, strong) NSMutableArray        *marketingList;
@end

@implementation MarketingActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"门店海报";
    CGRect rect = self.view.frame;
    rect.size.height -= 64;
    [self.tableMain setFrame:rect];
    self.tableMain.delegate = self;
    self.tableMain.dataSource = self;
    self.tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableMain.footerNoDataText=kWaring55;
    [self.tableMain setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableMain];
    if (QWGLOBALMANAGER.currentNetWork==kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }else{
        [self removeInfoView];
    }
    
    if (AUTHORITY_ROOT) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addMarketActivity:)];

    }
}


- (void)addMarketActivity:(id)sender
{
    //添加活动的时候网络的判断
    if (QWGLOBALMANAGER.currentNetWork==kNotReachable) {
        [self showError:kWaring12];
        return;
    }
    
    AddNewMarketActivityViewController *addNewMarketActivityViewController = [[AddNewMarketActivityViewController alloc] initWithNibName:@"AddNewMarketActivityViewController" bundle:nil];
    [self.navigationController pushViewController:addNewMarketActivityViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentPage = 1;
    self.marketingList = [NSMutableArray array];
    [self queryBranchActivity];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

- (void)footerRereshing
{
    HttpClientMgr.progressEnabled = NO;
    [self queryBranchActivity];
}

- (void)queryBranchActivity
{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }else{
        [self removeInfoView];
    }
    
        QueryActivitysR *activitR=[QueryActivitysR new];
        activitR.groupId=QWGLOBALMANAGER.configure.groupId;
        activitR.currPage=[NSString stringWithFormat:@"%ld",(long)currentPage];
        activitR.pageSize=@"10";
        [Activity QueryActivityListWithParams:activitR success:^(id resultObj) {
            QueryActivityList *activitys=(QueryActivityList*)resultObj;
            if(activitys.list.count>0){
                [self.marketingList addObjectsFromArray:activitys.list];
                [self removeInfoView];
                 self.tableMain.footer.canLoadMore=YES;
                [self.tableMain reloadData];
                currentPage++;
            }else{
                 if(currentPage==1){
                     [self showInfoView:@"暂无门店海报" image:@"img_preferential" flatY:20];
//                [self showInfoView:@"暂无门店海报" image:@"ic_img_fail"];
                 }else{
                      self.tableMain.footer.canLoadMore=NO;
                     [self removeInfoView];
                 }
            }
            [self.tableMain footerEndRefreshing];
        } failure:^(HttpException *e) {
            [self.tableMain footerEndRefreshing];
            
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }];
}


-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* title = @" 删除 ";
    UIColor * color = [UIColor redColor];
    MGSwipeButton * button = [MGSwipeButton buttonWithTitle:title backgroundColor:color callback:^BOOL(MGSwipeTableCell * sender){
        return YES;
    }];
    [result addObject:button];
    return result;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSInteger tag=alertView.tag;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        QueryActivityInfo *dict = self.marketingList[tag];
        DeleteActivitysR *deleteR=[DeleteActivitysR new];
        deleteR.token=QWGLOBALMANAGER.configure.userToken;
        deleteR.activityId=dict.activityId;
        [Activity DeleteActivitWithParams:deleteR success:^(id resultOBJ) {
            [self showSuccess:kWaring29];
            [self.marketingList removeObjectAtIndex:tag];
//            [self.tableMain deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if(self.marketingList.count == 0) {
                [self showInfoView:@"暂无门店海报" image:@"img_preferential" flatY:20];
//                [self showInfoView:@"暂无门店海报" image:@"ic_img_fail"];
            }else{
                [self removeInfoView];
            }
            [self.tableMain reloadData];
            
        } failure:^(HttpException *e) {
        }];
    }
}






#pragma mark MGSwipeTableCellDelegate

-(NSArray*) swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    if(AUTHORITY_ROOT){//是店长
        if(!self.SendActivity){//非im
        if (direction == MGSwipeDirectionRightToLeft) {
            return [self createRightButtons:1];
        }
        }
    }else{
        return nil;
    }
    return nil;
}



-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = [self.tableMain indexPathForCell:cell];
    QueryActivityInfo *dict = self.marketingList[indexPath.row];
    if (([dict.source intValue] == 1)||([dict.source intValue] == 2)) {
        [self showError:kWaring20];
        return true;
    }
    if(index == 0 && AUTHORITY_ROOT) {
        
        if (QWGLOBALMANAGER.currentNetWork==kNotReachable) {
            [self showError:kWaring12];
        }else{
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该门店海报吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=indexPath.row;
        [alertView show];
        }
    }
    return YES;
    
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QueryActivityInfo *dict = self.marketingList[indexPath.row];
    return [MarketingActivityTableViewCell getCellHeight:dict];
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{

    return self.marketingList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MarketingActivityTableViewCellIdentifier = @"MarketingActivityTableViewCellIdentifier";
    MarketingActivityTableViewCell *cell = (MarketingActivityTableViewCell *)[atableView dequeueReusableCellWithIdentifier:MarketingActivityTableViewCellIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"MarketingActivityTableViewCell" bundle:nil];
        [atableView registerNib:nib forCellReuseIdentifier:MarketingActivityTableViewCellIdentifier];
        cell = (MarketingActivityTableViewCell *)[atableView dequeueReusableCellWithIdentifier:MarketingActivityTableViewCellIdentifier];
        cell.selectedBackgroundView.backgroundColor=RGBHex(qwColor11);
        
    }
    
    QueryActivityInfo *dict = self.marketingList[indexPath.row];
    cell.swipeDelegate = self;
    cell.titleLabel.text = dict.title;
    cell.contentLabel.text = [QWGLOBALMANAGER replaceSpecialStringWith:dict.content];
    cell.avatarImage.contentMode = UIViewContentModeScaleAspectFit;
    [cell.avatarImage setImageWithURL:[NSURL URLWithString:dict.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"]];
    cell.avatarImage.hidden = NO;
    NSString *strSource = @"";
    NSString *strSourceAndDate=@"";
    if ([dict.source intValue] == 1) {
        strSource = @"全维";
    } else if ([dict.source intValue] == 2) {
        strSource = @"商户";
    } else if ([dict.source intValue] == 3){
        strSource = @"门店";
    }
    if(strSource==nil||[strSource isEqualToString:@""]){
        strSourceAndDate = [NSString stringWithFormat:@""];
    }else{
        strSourceAndDate = [NSString stringWithFormat:@"来源: %@",strSource];
    }
    
    cell.sourceLable.text = strSourceAndDate;
    cell.dateLabel.text=dict.publishTime;
    return cell;
}


- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加活动的时候网络的判断
//    if (QWGLOBALMANAGER.currentNetWork==kNotReachable) {
//        [self showError:kWaring12];
//        return;
//    }
    
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    QueryActivityInfo *dict = self.marketingList[indexPath.row];
    
    
    if(self.SendActivity){
        self.SendActivity(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        MarketDetailViewController *marketDetailViewController = nil;
        marketDetailViewController = [[MarketDetailViewController alloc] initWithNibName:@"MarketDetailViewController" bundle:nil];
        marketDetailViewController.infoDict = dict;
        //从列表页面进入
        marketDetailViewController.userType=USETYPE_ME;
        [self.navigationController pushViewController:marketDetailViewController animated:YES];
        
    }
    
    
    
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
