//
//  StoreSendMedicineViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/6/21.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

typedef void (^ReturnValueBlock)(id model);

@interface StoreSendMedicineViewController : QWBaseVC

@property (nonatomic, assign) BOOL  loadMore;

@property (nonatomic, copy) ReturnValueBlock returnValueBlock;

@end
