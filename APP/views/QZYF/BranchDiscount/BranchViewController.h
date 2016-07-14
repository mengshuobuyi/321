//
//  newConsultPharmacyViewController.h
//  APP
//
//  Created by 李坚 on 15/8/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"
#import "CoupnModel.h"

typedef void (^SendNewBranchBlock)(BranchCouponVo *coupnModel,DrugVo *productModel);
  
@interface BranchViewController : QWBaseVC

// 聊天发送优惠
@property (nonatomic, copy, readwrite) SendNewBranchBlock SendNewBranch;

@property (strong, nonatomic) NSString * isFromIM; // 是否从im进入  1yes

@end
