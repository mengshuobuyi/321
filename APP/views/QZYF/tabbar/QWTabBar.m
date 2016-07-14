//
//  QWTabBar.m
//  APP
//
//  Created by Yan Qingyang on 15/2/28.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWTabBar.h"
#import "AppDelegate.h"
#import "UserCenterViewController.h"
#import "ConsultationMainViewController.h"
//
//#import "StoreHomeViewController.h"
//#import "MyIndentViewController.h"
//#import "InternalProductListViewController.h"
//#import "MyStatiticsViewController.h"
//#import "StoreMineViewController.h"

@interface QWTabBar ()
{

}
@end

@implementation QWTabBar

- (id)initWithDelegate:(id)dlg{
    self = [super init];
    if (self) {
        self.delegate=dlg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [QWGLOBALMANAGER postNotif:NotiQWTabBarDidChangeAppear data:@{@"hidden":@(NO)} object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [QWGLOBALMANAGER postNotif:NotiQWTabBarDidChangeAppear data:@{@"hidden":@(YES)} object:nil];
}

/**
 *  初始化tab标签样式
 */
- (void)initTabBar
{
    // 门店
    
    QWTabbarItem *bar1=[QWTabbarItem new];
    bar1.title=@"首页";
    bar1.clazz=@"StoreHomeViewController";
    bar1.storyBoardName = @"StoreHome";
    bar1.picNormal=@"menubar_home";
    bar1.picSelected=@"menubar_home_sel";
    bar1.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_HomePage];
    
    QWTabbarItem *bar2=[QWTabbarItem new];
    bar2.title=@"订单";
    if (QWGLOBALMANAGER.configure.storeType == 3){//开通微商
        bar2.clazz=@"MyIndentViewController";
        bar2.storyBoardName = @"";
    }else{//未开通微商
        bar2.clazz=@"AllTipsViewController";
        bar2.storyBoardName=@"";
    }
    bar2.picNormal=@"menubar_order";
    bar2.picSelected=@"menubar_order_sel";
    bar2.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_MyOrders];
    
    QWTabbarItem *bar3=[QWTabbarItem new];
    bar3.title=@"商品";
    if (QWGLOBALMANAGER.configure.storeType == 3){//开通微商
        bar3.clazz=@"InternalProductListViewController";
        bar3.storyBoardName = @"InternalProduct";
    }else{//未开通微商
        bar3.clazz=@"BranchProductViewController";
        bar3.storyBoardName=@"";
    }
    bar3.picNormal=@"menubar_goods";
    bar3.picSelected=@"menubar_goods_sel";
    bar3.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Product];
    
    QWTabbarItem *bar4=[QWTabbarItem new];
    bar4.title=@"统计";
    bar4.clazz=@"MyStatiticsViewController";
    bar4.storyBoardName = @"MyStatistics";
    bar4.picNormal=@"menubar_statistical";
    bar4.picSelected=@"menubar_statistical_sel";
    bar4.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Statistics];
    
    QWTabbarItem *bar5=[QWTabbarItem new];
    bar5.title=@"我的";
    bar5.clazz=@"UserCenterViewController";
    bar5.storyBoardName = @"";
    bar5.picNormal=@"menubar_mine";
    bar5.picSelected=@"menubar_mine_sel";
    bar5.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_UserCenter];
    
    
    // 专家
    
    QWTabbarItem *bar6=[QWTabbarItem new];
    bar6.title=@"圈子";
    bar6.clazz=@"CircleViewController";
    bar6.storyBoardName = @"Circle";
    bar6.picNormal=@"ic_quanzi";
    bar6.picSelected=@"ic_quanzigreen";
    bar6.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_ExpertIndex];
        
    QWTabbarItem *bar7=[QWTabbarItem new];
    bar7.title=@"咨询";
    bar7.clazz=@"ConsultationMainViewController";
    bar7.storyBoardName = @"";
    bar7.picNormal=@"ic_chat";
    bar7.picSelected=@"ic_chatgreen";
    bar7.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_ExpertChat];
    
    QWTabbarItem *bar8=[QWTabbarItem new];
    bar8.title=@"我的";
    bar8.clazz=@"MineViewController";
    bar8.storyBoardName = @"Mine";
    bar8.picNormal=@"ic_my1";
    bar8.picSelected=@"ic_mygreen";
    bar8.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_ExpertMine];
    
    if (IS_EXPERT_ENTRANCE) {
        [self addTabBarItem:bar6,bar7,bar8, nil];
    }else{
        [QWGLOBALMANAGER statisticsEventId:@"s_sy_tabsy" withLable:@"首页" withParams:nil];
        [self addTabBarItem:bar1,bar2,bar3,bar4,bar5, nil];
    }
    
    [self backgroundColor:RGBHex(qwColor4)];
    [self separatorLine:RGBHex(qwColor1)];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%lu",(unsigned long)item.tag);
    
    if (item.tag == 0)
    {
        [QWGLOBALMANAGER statisticsEventId:@"s_sy_tabsy" withLable:@"首页" withParams:nil];
    }else if (item.tag == 1)
    {
        [QWGLOBALMANAGER statisticsEventId:@"s_sy_tabdd" withLable:@"订单" withParams:nil];
    }else if (item.tag == 2)
    {
        [QWGLOBALMANAGER statisticsEventId:@"s_sy_tabsp" withLable:@"商品" withParams:nil];
    }else if (item.tag == 3)
    {
        [QWGLOBALMANAGER statisticsEventId:@"s_sy_tabtj" withLable:@"统计" withParams:nil];
    }else if (item.tag == 4)
    {
        [QWGLOBALMANAGER statisticsEventId:@"s_sy_tabwd" withLable:@"我的" withParams:nil];
    }
    
}
@end
