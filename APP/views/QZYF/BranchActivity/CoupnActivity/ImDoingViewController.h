//
//  DoingViewController.h
//  wenYao-store
//
//  Created by caojing on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "Activity.h"

@interface ImDoingViewController : QWBaseVC
@property (nonatomic, copy) void(^SendNewCoupn)(BranchNewPromotionModel *dict);//聊天用的block
@end
