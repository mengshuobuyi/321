//
//  CampAsignViewController.m
//  wenYao-store
//
//  Created by caojing on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PurchaseViewController.h"
#import "PurchaseTableViewCell.h"
#import "Coupn.h"
@interface PurchaseViewController()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger currentPage;
}
@property (weak,nonatomic) IBOutlet UITableView *recordTableView;
@property (strong,nonatomic) NSMutableArray *listArray;
@property (strong,nonatomic)NSMutableArray *imageArray;

@end

@implementation PurchaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"赠送记录";
    [self setUpTableView];
    if (QWGLOBALMANAGER.currentNetWork==kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }else{
        [self removeInfoView];
    }
}

#pragma mark ---- 设置 tableView ----

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    currentPage = 1;
    self.listArray = [NSMutableArray array];
    [self queryRecord];

}

- (void)queryRecord
{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }else{
        [self removeInfoView];
    }
    
    RecordModelR *activitR=[RecordModelR new];
    activitR.token=QWGLOBALMANAGER.configure.userToken;
    activitR.page=[NSString stringWithFormat:@"%ld",(long)currentPage];
    activitR.pageSize=@"20";
    [Coupn couponPresentRecordWithParams:activitR success:^(id resultObj) {
        RecordListModel *record=[RecordListModel parse:resultObj];
        if(record.logs.count>0){
            [self.listArray addObjectsFromArray:record.logs];
            [self removeInfoView];
            self.recordTableView.footer.canLoadMore=YES;
            [self.recordTableView reloadData];
            currentPage++;
        }else{
            if(currentPage==1){
                [self showInfoView:@"暂无记录" image:@"img_vouchers"];
            }else{
                self.recordTableView.footer.canLoadMore=NO;
                [self removeInfoView];
            }
        }
        [self.recordTableView footerEndRefreshing];
    } failure:^(HttpException *e) {
        [self.recordTableView footerEndRefreshing];
        
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"img_vouchers"];
            }else{
                [self showInfoView:kWarning215N0 image:@"img_vouchers"];
            }
        }
    }];
}


- (void)footerRereshing
{
    HttpClientMgr.progressEnabled = NO;
    [self queryRecord];
}



- (void)setUpTableView
{
    self.recordTableView.delegate=self;
    self.recordTableView.dataSource=self;
    self.recordTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.recordTableView.backgroundColor=RGBHex(qwColor4);
    [self.recordTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark ---- 列表代理 ----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *circleDetailCell = @"PurchaseCell";
    PurchaseTableViewCell *cell = (PurchaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"PurchaseTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:circleDetailCell];
        cell = (PurchaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    }
    RecordModel *model=[RecordModel parse:self.listArray[indexPath.row]];
    cell.dateLabel.text=model.date;
    cell.telLabel.text=model.mobile;
    cell.contentLabel.text=model.intro;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
