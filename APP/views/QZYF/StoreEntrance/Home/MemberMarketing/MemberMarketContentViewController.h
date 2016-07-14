//
//  MemberMarketContentViewController.h
//  wenYao-store
//
//  Created by PerryChen on 5/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "CurSelectMarketModel.h"
#import "MemberMarketModel.h"

typedef void(^RechooseMemberMarket)();
typedef void(^CompleteMemberMarket)();

@interface MemberMarketContentViewController : QWBaseVC
@property (nonatomic, strong) CurSelectMarketModel *modelTicket;    // 选择的优惠券
@property (nonatomic, strong) CurSelectMarketModel *modelProduct;   // 选择的商品
@property (nonatomic, strong) CurSelectMarketModel *modelBrochure;  // 选择的海报
@property (nonatomic, strong) MemberCheckVo *modelCheck;            // 选择的会员营销
@property (nonatomic, strong) RechooseMemberMarket block;           // 重新选择会员营销的Block
@property (nonatomic, strong) CompleteMemberMarket blockComplete;   // 完成选择会员营销block
@end
