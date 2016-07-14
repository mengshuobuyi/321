//
//  AddlenseViewController.h
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@protocol finishlenseInfoDelegate <NSObject>

-(void)finishlenseInfoDelegate;

@end
/*!  枚举
 @brief 页面来源
 */
typedef enum {
    shop_typeone, //药品经营许可证
    shop_typetwo, //营业执照
    shop_typethree, //GSP认证执照
    medical_typeone,//医疗机构执业许可证
    addlense,//其他证件添加
}type;


@interface AddlenseViewController : QWBaseVC

@property (assign, nonatomic) type lenseclass;
@property (strong, nonatomic) NSString *lensename;
@property (strong, nonatomic) NSString *titleStr;
@property (weak, nonatomic) id<finishlenseInfoDelegate> finishlenseInfoDelegate;

@end
