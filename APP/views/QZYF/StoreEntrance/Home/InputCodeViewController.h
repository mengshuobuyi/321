//
//  InputCodeViewController.h
//  wenYao-store
//
//  Created by caojing on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "CustomVerifyTextField.h"
typedef enum  Enum_CAlert_Items {
    
    Enum_CAlert_Quite   = 1,                       //退出界面
    Enum_CAlert_Verify  = 2,                       //验证码的提示
    
}CAlert_Items;

@interface InputCodeViewController : QWBaseVC
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet CustomVerifyTextField *codeTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footHeight;
@property (weak, nonatomic) IBOutlet UIButton *deleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@end
