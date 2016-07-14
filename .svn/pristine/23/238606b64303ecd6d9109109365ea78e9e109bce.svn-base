//
//  InputCodeViewController.m
//  wenYao-store
//
//  Created by caojing on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InputCodeViewController.h"
#import "RectangleVerify.h"
#import "Verify.h"
#import "VerifyDetailViewController.h"
@interface InputCodeViewController ()<RectangleVerifyDelegate,UITextFieldDelegate>
@property (nonatomic)RectangleVerify *codeKeyView;//键盘的控件
@property (nonatomic, strong) NSMutableString *strContent;

@end

@implementation InputCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"请输入验证码/收货码/兑换码";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.codeKeyView = [RectangleVerify getInstanceWithDelegate:self withCurView:self.centerView];
    [self.centerView addSubview:self.codeKeyView];
    if(IS_IPHONE_6){
        self.headerHeight.constant = 93.f;
        self.footHeight.constant=60.0f;
        [self.codeTextField setValue:[UIFont systemFontOfSize:27] forKeyPath:@"_placeholderLabel.font"];
    }else if(IS_IPHONE_6P){
        self.headerHeight.constant = 93.f;
        self.footHeight.constant=60.0f;
        [self.codeTextField setValue:[UIFont systemFontOfSize:27] forKeyPath:@"_placeholderLabel.font"];
    }else if(IS_IPHONE_4_OR_LESS){
        self.headerHeight.constant = 60.0f;
        self.footHeight.constant=44.0f;
        [self.codeTextField setValue:[UIFont systemFontOfSize:23] forKeyPath:@"_placeholderLabel.font"];
    }else{
        self.headerHeight.constant = 93.f;
        self.footHeight.constant=44.0f;
        [self.codeTextField setValue:[UIFont systemFontOfSize:24] forKeyPath:@"_placeholderLabel.font"];
    }
    
    [self.codeTextField setValue:RGBHex(0xffffff) forKeyPath:@"_placeholderLabel.textColor"];
    self.strContent = [@"" mutableCopy];
    self.codeTextField.text = self.strContent;
    self.deleButton.hidden = YES;
    self.codeTextField.inputView = UIView.new;
    [self.codeTextField becomeFirstResponder];
    
    [self.view layoutSubviews];
    [self.view layoutIfNeeded];

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.codeTextField resignFirstResponder];
}

#pragma mark ---- 点击自定义键盘 ----

- (void)clickBtnIndex:(RectangleTagClicked)clickIndex
{
    NSInteger intClicked = [self convertVerifyPadToValue:clickIndex];
    if (intClicked < 0) { //点击验证按钮
        [self confirmVerifyCode];
        return;
    }
    if (self.strContent.length >= 12) {
        return;
    }
    
    NSRange cursorRange = [self getInputPanelCursorPosition:self.codeTextField];
    if(cursorRange.location==4){
        [self.strContent insertString:[NSString stringWithFormat:@"%@",@" "] atIndex:cursorRange.location];
        cursorRange.location=cursorRange.location+1;
        [self.strContent insertString:[NSString stringWithFormat:@"%ld",(long)intClicked] atIndex:cursorRange.location];
        
    }else if(cursorRange.location==9){
        [self.strContent insertString:[NSString stringWithFormat:@"%@",@" "] atIndex:cursorRange.location];
        cursorRange.location=cursorRange.location+1;
        [self.strContent insertString:[NSString stringWithFormat:@"%ld",(long)intClicked] atIndex:cursorRange.location];
    }else{
        [self.strContent insertString:[NSString stringWithFormat:@"%ld",(long)intClicked] atIndex:cursorRange.location];
    }
    self.codeTextField.text = self.strContent;
    [self setTextFieldCursorPosition:YES withCurRange:cursorRange];
}

//判断是神马数字
- (NSInteger)convertVerifyPadToValue:(RectangleTagClicked)tagClick
{
    NSInteger intNum = 0;
    switch (tagClick) {
        case RectangleTagOneClick:
            intNum = 1;
            break;
        case RectangleTagTwoClick:
            intNum = 2;
            break;
        case RectangleTagThreeClick:
            intNum = 3;
            break;
        case RectangleTagFourClick:
            intNum = 4;
            break;
        case RectangleTagFiveClick:
            intNum = 5;
            break;
        case RectangleTagSixClick:
            intNum = 6;
            break;
        case RectangleTagSevenClick:
            intNum = 7;
            break;
        case RectangleTagEightClick:
            intNum = 8;
            break;
        case RectangleTagNineClick:
            intNum = 9;
            break;
        case RectangleTagZeroClick:
            intNum = 0;
            break;
        case RectangleTagConfirmClick:
            intNum = -1;
            break;
        case RectangleTagCancleClick:
            intNum = 12;
            break;
        default:
            break;
    }
    return intNum;
}
#pragma mark ---- 点击验证按钮 Action ----

- (void)confirmVerifyCode
{
    
    if (self.strContent.length == 0) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N54 duration:0.8];
        return;
    }
    
    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8];
        return;
    }
    
    InputVerifyModelR *modelR = [InputVerifyModelR new];
    NSString *code=self.strContent;
    code = [self.strContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    modelR.code = code;
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    
    [Verify GetVerifyWithParams:modelR success:^(id UFModel) {
        
        InputVerifyModel *resonModel = (InputVerifyModel *)UFModel;
        //增加收货码
        if([resonModel.apiStatus intValue] == 0)
        {
            //验证成功之后，输入框内容删除
            self.deleButton.hidden = YES;
            self.codeTextField.text = @"";
            if ([resonModel.scope intValue]==4) {//订单收货码的确认
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确认成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag=Enum_CAlert_Verify;
                [alert show];
                return ;
            }else if ([resonModel.scope intValue]==3) {  // 兑换商品
                
                NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                setting[@"orderId"] = StrFromObj(resonModel.mallOrder.orderId);
                [Order mallOrderCompleteWithParams:setting success:^(id obj) {
                    
                    if ([obj[@"apiStatus"] integerValue] == 0) {
                        self.deleButton.hidden = YES;
                        self.strContent = [@"" mutableCopy];
                        self.codeTextField.text = self.strContent;
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:obj[@"apiMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    return ;
                } failure:^(HttpException *e) {
                    [SVProgressHUD showErrorWithStatus:@"服务器异常，请稍后重试"];
                }];
                
            }else{
                VerifyDetailViewController *vc = [[VerifyDetailViewController alloc] initWithNibName:@"VerifyDetailViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                if([resonModel.scope intValue]==1){ //优惠券
                    vc.typeCell=@"1";
                    vc.CoupnList=resonModel.coupon;
                }else if([resonModel.scope intValue]==2){ // 优惠商品
                    vc.typeCell=@"2";
                    vc.drugList=resonModel.promotion;
                }
                self.deleButton.hidden = YES;
                vc.scope = resonModel.coupon.scope;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:resonModel.apiMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag=Enum_CAlert_Verify;
            [alert show];
            return ;
        }
    } failure:^(HttpException *e) {
        
    }];
}
// 获取键盘光标所在位置
- (NSRange)getInputPanelCursorPosition:(UITextField *)tfInput
{
    UITextRange *selectedTextRange = tfInput.selectedTextRange;
    NSUInteger location = [tfInput offsetFromPosition:tfInput.beginningOfDocument
                                           toPosition:selectedTextRange.start];
    NSUInteger length = [tfInput offsetFromPosition:selectedTextRange.start
                                         toPosition:selectedTextRange.end];
    NSRange selectedRange = NSMakeRange(location, length);
    return selectedRange;
}

- (void)setTextFieldCursorPosition:(BOOL)isAppend withCurRange:(NSRange)curRange
{
    if (self.strContent.length == 0) {
        return;
    }
    self.deleButton.hidden=NO;
    UITextPosition *beginning = self.codeTextField.beginningOfDocument;
    UITextPosition *start = beginning;
    if (isAppend) {
        start = [self.codeTextField positionFromPosition:beginning offset:curRange.location+1];
    } else {
        start = [self.codeTextField positionFromPosition:beginning offset:curRange.location-1];
    }
    UITextPosition *end = [self.codeTextField positionFromPosition:start offset:curRange.length];
    UITextRange *textRange = [self.codeTextField textRangeFromPosition:start toPosition:end];
    [self.codeTextField setSelectedTextRange:textRange];
}

- (IBAction)returnAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)delButton:(id)sender {
    self.strContent = [@"" mutableCopy];
    self.codeTextField.text = self.strContent;
    self.deleButton.hidden=YES;
    [self setTextFieldCursorPosition:NO withCurRange:NSMakeRange(0, 0)];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
