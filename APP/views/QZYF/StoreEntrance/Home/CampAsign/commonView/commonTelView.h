//
//  commonTelView.h
//  wenYao-store
//
//  Created by caojing on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^disMissCallback) (id obj);

@interface commonTelView : UIView<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *bkView;
@property (weak, nonatomic) IBOutlet UIView *CustomAlertView;
- (IBAction)dimissView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UITextField *texdFie;
@property (copy,nonatomic) disMissCallback dismissCallback;


@property(strong,nonatomic)NSString *promotionType;
@property(strong,nonatomic)NSString *promotionId;

+ (commonTelView *)showAlertViewAtView:(UIWindow *)aView withType:(NSString *)promotionType andId:(NSString *)promotionId callBack:(disMissCallback)callBack;

@end