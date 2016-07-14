//
//  SymptomViewController.h
//  APP
//
//  Created by qwfy0006 on 15/3/11.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "BATableView.h"

/*!  枚举
 @brief 页面来源
 */
typedef enum {
    wikiSym, //来自百科
    bodySym, //来自人体图
    searchSym //来自搜索
}type;

@interface SymptomViewController : QWBaseVC

@property (nonatomic ,assign) type requestType;

@property (nonatomic, strong) UIViewController  *containerViewController;
@property (nonatomic ,strong) NSString *spmCode;
@property (nonatomic, strong) NSDictionary  *requsetDic;
@property (nonatomic ,copy) __block void(^scrollBlock)(void);

- (void)refresh;

@end
