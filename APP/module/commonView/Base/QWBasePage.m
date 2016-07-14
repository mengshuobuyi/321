//
//  basePage.m
//  Show
//
//  Created by YAN Qingyang on 15-2-11.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "QWBasePage.h"

//#import "QYGlobal.h"
//#import "setting.h"

@interface QWBasePage ()
{
    UIView *vQLog;
    UITextView *txtQLog;
}
@end

@implementation QWBasePage
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self UIGlobal];
}

#pragma mark -
#pragma mark UI
- (void)UIGlobal{
    [super UIGlobal];
    
    self.view.backgroundColor=RGBHex(kColor3);
}

#pragma mark Loading
- (void)showLoading {
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [self.view bringSubviewToFront:HUD];
        
        HUD.delegate = self;
    }
    
    [HUD show:YES];
}

- (void)didLoad{
    
    [HUD hide:YES];
}

#pragma mark alert
- (void)showAlert:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion{
    
}

#pragma mark Message
- (void)showMessage:(NSString*)txt{
    [self showMessage:txt afterDelay:1.5];
}

- (void)showMessage:(NSString*)txt afterDelay:(double)delay{
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = txt;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    double dl=(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}

- (void)showErrorMessage:(NSError*)error{
//    NSDictionary *errs=error.userInfo;
//    NSString *code=[self getErrCode:[errs objectForKey:@"errors"]];
//    NSString *err_code=[NSString stringWithFormat:@"ERR_%@",code];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[AppDelegate localized:@"ERROR" defaultValue:nil]
//                                                       message:[AppDelegate localized:err_code defaultValue:code]
//                                                      delegate:self
//                                             cancelButtonTitle:[AppDelegate localized:@"btnClose" defaultValue:nil]
//                                             otherButtonTitles:nil, nil];
//    
//    [alertView show];
}

#pragma mark 错误处理
- (NSString*)getErrCode:(id)obj{
    NSMutableString *str=[NSMutableString stringWithString:@"UNKNOW"];
//    NSArray *arrErrs;
//    if (!ObjClass(obj, [NSArray class])) {
//        return str;
//    }
//    arrErrs=(NSArray*)obj;
//    if (arrErrs.count) {
//        NSDictionary *dd=[arrErrs objectAtIndex:0];
//        if ([dd objectForKey:@"err_code"]) {
//            return [dd objectForKey:@"err_code"];
//            //[str appendString:[dd objectForKey:@"err_code"]];
//            //            [str stringByAppendingString:[dd objectForKey:@"err_code"]];
//        }
//    }
    
    return str;
}
#pragma mark 控制台
- (void)showLog:(NSString*)firstObject, ...{

    NSMutableString *allStr=[[NSMutableString alloc]initWithCapacity:0];
    
    NSString *eachObject=nil;
    va_list argumentList;
    if (firstObject>=0)
    {
        [allStr appendFormat:@"%@",firstObject];
        
        va_start(argumentList, firstObject);          // scan for arguments after firstObject.
        eachObject = va_arg(argumentList, NSString*);
        while (eachObject!=nil) // get rest of the objects until nil is found
        {
//            NSLog(@"%@",eachObject);
            [allStr appendFormat:@"\n-------------------------------------------------\n%@",eachObject];
            
            eachObject = va_arg(argumentList, NSString*);
        }
        va_end(argumentList);
    }
    
    CGRect frm=self.view.bounds;
    if (vQLog==nil) {
        vQLog=[[UIView alloc]initWithFrame:frm];
        
        frm.size.height-=80;
        frm.size.width-=2;
        frm.origin.x=1;
        frm.origin.y=20;
        txtQLog=[[UITextView alloc]initWithFrame:frm];
        txtQLog.editable=NO;
        [vQLog addSubview:txtQLog];
        
        frm.size.height=60;
        
        frm.origin.y=CGRectGetMaxY(txtQLog.frame)+1;
        UIButton *btn=[[UIButton alloc]initWithFrame:frm];
        [btn addTarget:self action:@selector(hideLogAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor redColor];//[QYGlobal colorWithHexString:kMainColor alpha:1];
        [btn setTitle:@"关........闭" forState:UIControlStateNormal];
        [vQLog addSubview:btn];
        
        [self.view addSubview:vQLog];
    }
    
//    NSString *ss=allStr;
    if ([txtQLog.text length]) {
        [allStr appendFormat:@"\n\n++++++++++++++++++++++++++++++++++++++++++++++\n\n%@",txtQLog.text];
    }
    txtQLog.text=allStr;
    vQLog.hidden=NO;
}

- (void)hideLogAction:(id)sender{
    vQLog.hidden=YES;
    txtQLog.text=nil;
}

#pragma mark Delegate
#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark Action
#pragma mark 返回上一页
- (IBAction)popVCAction:(id)sender{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
}

@end
