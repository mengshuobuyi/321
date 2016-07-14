//
//  IndexViewController.h
//  wenYao-store
//
//  Created by YYX on 15/8/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "CustomVerifyTextField.h"

typedef enum  Enum_TypeAlert_Items {
    
    Enum_TypeAlert_Quite   = 1,                       //退出界面
    Enum_TypeAlert_Verify  = 2,                       //验证码的提示
    
}TypeAlert_Items;

@interface IndexViewController : QWBaseVC

@property (weak, nonatomic) IBOutlet UIView *codeKeyView;
@property (weak, nonatomic) IBOutlet UIButton *deleteCodeButton;
@property (weak, nonatomic) IBOutlet CustomVerifyTextField *codeInputFiled;

@end
