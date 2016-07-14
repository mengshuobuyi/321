//
//  OffSellViewController.h
//  wenYao-store
//
//  Created by qw_imac on 16/3/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface OffSellViewController : QWBaseVC
@property (nonatomic,copy) void(^refresh)();
@property (nonatomic,strong)NSString *actId;
@property (nonatomic,assign)NSInteger type;
@end
