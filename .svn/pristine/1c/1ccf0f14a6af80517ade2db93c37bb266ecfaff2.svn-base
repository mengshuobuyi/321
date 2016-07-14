//
//  MyReceiveAddressViewController.m
//  wenYao-store
//  收货地址列表
//  收货地址列表 GetRecieveAddressList
//  Created by qw_imac on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyReceiveAddressViewController.h"
#import "ReceiverAddressCell.h"
#import "EditAddressViewController.h"
#import "Address.h"
#import "NoAddrBKView.h"
@interface MyReceiveAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray  *dataSource;         //地址数组
    NoAddrBKView    *bkView;
}
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MyReceiveAddressViewController
static NSString *const cellIdentifier = @"ReceiverAddressCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    dataSource = [@[] mutableCopy];
    bkView = [NoAddrBKView noAddressBkView];
    bkView.frame = self.view.bounds;
    bkView.hidden = YES;
    [self.view insertSubview:bkView atIndex:0];
    _addBtn.layer.cornerRadius = 5.0;
    _addBtn.layer.masksToBounds = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"ReceiverAddressCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
    } else {
        [self queryAddressList];
    }
}

- (IBAction)addAddress:(UIButton *)sender {
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试"];
        return;
    }
    if (dataSource.count>=5) {
        [SVProgressHUD showErrorWithStatus:@"收货地址最多只可以添加5个哦~"];
        return;
    }
    EditAddressViewController *vc = [[EditAddressViewController alloc]initWithNibName:@"EditAddressViewController" bundle:nil];
    vc.pageType = AddressPageTypeAdd;
    vc.pageFrom = _pageFrom;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count < 5?dataSource.count:5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiverAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.changeBtn.tag = indexPath.row;
    [cell.changeBtn addTarget:self action:@selector(editAddressInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EmpAddressVo *vo = dataSource[indexPath.row];
    [cell setCellWith:vo];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_pageFrom == PageComeFromH5) {
        if (self.addressBlock) {
            EmpAddressVo *vo = dataSource[indexPath.row];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"lat"] = vo.receiverLat;
            params[@"lng"] = vo.receiverLng;
            params[@"address"] = vo.receiverAddr;
            params[@"cityName"] = vo.receiverCityName;
            params[@"countyName"] = vo.receiverDist;
            params[@"nick"] = vo.receiver;
            params[@"mobile"] = vo.receiverTel;
            params[@"sex"] = vo.receiverGender;
            params[@"village"] = vo.receiverVillage;
            params[@"provinceName"] = vo.receiverProvinceName;
            params[@"id"] = vo.id;
            NSString *jsonString = nil;
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
            if([jsonData length] > 0 && error == nil) {
                jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                self.addressBlock(jsonString);
            }
        }
        [self popVCAction:nil];
    }else {
        [self _editAddressInfo:indexPath.row];
    }
}

-(void)editAddressInfo:(UIButton *)sender {
    [self _editAddressInfo:sender.tag];
}

-(void)_editAddressInfo:(NSUInteger)index {
    EmpAddressVo *vo = dataSource[index];
    EditAddressViewController *vc = [[EditAddressViewController alloc]initWithNibName:@"EditAddressViewController" bundle:nil];
    vc.EmpAddressModel = vo;
    vc.pageFrom = _pageFrom;
    vc.pageType = AddressPageTypeEdit;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - networking
-(void)queryAddressList {
    RecieveAddressModelR *modelR = [RecieveAddressModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken?QWGLOBALMANAGER.configure.userToken:@"";
    [Address getAddressList:modelR success:^(EmpAddressListVo *responseModel) {
        dataSource = [responseModel.address mutableCopy];
        if (dataSource.count == 0) {
            bkView.hidden = NO;
        }else {
            bkView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(HttpException *e) {
        
    }];
}
@end
