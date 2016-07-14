//
//  StoreSendMedicineListViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/6/21.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

typedef void (^PassValueBlock)(id model);
typedef void (^saveHistoryBlock)(NSString *keyWord);

@interface StoreSendMedicineListViewController : QWBaseVC

@property (strong, nonatomic)NSString *keyWord;
@property (nonatomic, copy) PassValueBlock block;
@property (nonatomic, copy) saveHistoryBlock historyBlock;

@end
