//
//  test3.m
//  APP
//
//  Created by Yan Qingyang on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "test3.h"
#import "test3Cell.h"

//#import "HealthinfoModel.h"
//#import "Healthinfo.h"

@interface test3 ()
{
    NSMutableArray *arrTmp;
}
@end

@implementation test3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self test];

//    [self getHealthyAdviceList];
    
//    [self showLoading];
    NSLog(@"%@",HUD);
}



- (void)UIGlobal{
    [super UIGlobal];
    
    [btnPopVC setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    [btnPopVC setTitleColor:RGBAHex(qwColor4, 0.85) forState:UIControlStateHighlighted];
    btnPopVC.titleLabel.font=font(kFont4, kFontS6);
    
    btnPopVC.layer.borderWidth=1.f;
    btnPopVC.layer.borderColor=RGBHex(qwColor1).CGColor;
    btnPopVC.layer.cornerRadius=4;
   
    self.tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableMain.separatorColor=RGBAHex(0, 0);
    [self.tableMain reloadData];
    
//    textView.editable = YES;
//    textView.lineSpacing = 8.0f;
    
}

- (void)popVCAction:(id)sender{
    if (self.delegatePopVC) {
        [self.navigationController popToViewController:self.delegatePopVC animated:YES];
    }
    else {
        [super popVCAction:sender];
    }
}

#pragma mark 数据
- (void)getHealthyAdviceList
{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"channelId"] = @"8392b5c8778a428b9bc1c5c37cd89e3e";//f613670d8d554152938b09a359947ca0
//    param[@"currPage"] = @"1";
//    param[@"pageSize"] = kTablePageSize;
//    
//    NSString * key = [NSString stringWithFormat:@"%@_%@",param[@"channelId"],param[@"currPage"]];
//    
//    HealthinfoAdvicelPage* page = [HealthinfoAdvicelPage getObjFromDBWithKey:key];
//    
//    if (page) {
//        
//        [self dataLoad:page.data];
//   
//    }
//    else
//    {
////        __weak InformationListViewController *weakSelf = self;
//        
////        [Healthinfo QueryHealthAdviceListWithParams:param
////                                            success:^(id obj){
////                                                
////                                                if (obj) {
////                                                    HealthinfoAdvicelPage* page = obj;
////                                                    page.advicePageId = key;
////                                                    [HealthinfoAdvicelPage saveObjToDB:page];
////                                                    [self dataLoad:page.data];
////                                                }
////                                            }
////                                            failure:^(HttpException *e){
////                                                NSLog(@"获取AdvicelList失败");
////                                            
////                                            }];
//    }
}
- (void)test{
//    NSMutableArray *arr=[NSMutableArray array];
//    
//    int i = 16;
//    while (i>=0) {
//        HealthinfoAdvicel *m1=[HealthinfoAdvicel new];
//        m1.title=[NSString stringWithFormat:@"%i. Title",i];
//        m1.introduction=@"测试内容";
//        [arr addObject:m1];
//        i--;
//    }
//    
//    [self dataLoad:arr];
}
- (void)dataLoad:(NSArray*)arr{
//    NSLog(@"%@",arr);
    if (arrTmp) {
        [arrTmp removeAllObjects];
    }
    else arrTmp=[NSMutableArray array];
    
    for(id obj in arr) {
        [arrTmp addObject:obj];
    }
    
    [self.tableMain reloadData];
}

#pragma mark 表格
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [test3Cell getCellHeight:[arrTmp objectAtIndex:indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTmp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableID3 = @"tableID31111";
    
    test3Cell *cell;
    cell = (test3Cell*)[tableView dequeueReusableCellWithIdentifier:tableID3];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"test3Cell" owner:self options:nil];
        cell = [nib firstObject];
        cell.delegate=self;
//        [cell setSelectedBGColor:RGBHex(qwColor1)];
    }
    
    id mod=[arrTmp objectAtIndex:indexPath.row];
    [cell setCell:mod];
    
    if (indexPath.row+1==arrTmp.count) {
        cell.separatorHidden=YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",indexPath);
    
    //测试代码
//    [QWGLOBALMANAGER postNotif:NotifMessageNeedUpdate data:[arrTmp objectAtIndex:indexPath.row] object:self];
    
    [QWGLOBALMANAGER postNotif:NotifMessageOfficial data:[arrTmp objectAtIndex:indexPath.row] object:nil];
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    if (NotifMessageOfficial == type) {
        NSLog(@"NotifMessageOfficial:%@",data);
    }
}
@end
