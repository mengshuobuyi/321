//
//  OrderPhoneViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

/*
    接单电话
    h5/branch/queryOrderLinks   获取接单电话
    h5/branch/updateOrderLinks  更新接单电话
 */

#import "OrderPhoneViewController.h"
#import "Branch.h"
#import "ExpertModel.h"

@interface OrderPhoneViewController ()

@property (weak, nonatomic) IBOutlet UIView *oneBgView;
@property (weak, nonatomic) IBOutlet UIView *twoBgView;
@property (weak, nonatomic) IBOutlet UIView *threeBgView;

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneView_layout_top;

@end

@implementation OrderPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"接单电话";
    
    //设置UI
    [self configureUI];
    
    //键盘down
    [self setUpForDismissKeyboard];
    
    //查询接单电话
    [self queryInfo];
    
}

#pragma mark ---- 获取接单电话 ----
- (void)queryInfo
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    [Branch BranchQueryOrderLinksWithParams:setting success:^(id obj) {
        PharmacistOrderPhoneModel *model = [PharmacistOrderPhoneModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            NSString *phoneOne = @"";
            NSString *phoneTwo = @"";
            NSString *phoneThree = @"";
            
            //如果links为空，第一个电话取mobile，如果links有值，则取links里的电话，有几个取几个，最多三个
            if (model.links && model.links.count == 0)
            {
                phoneOne = model.mobile;
            }else
            {
                if (model.links && model.links.count > 0)
                {
                    if (model.links.count == 1)
                    {
                        phoneOne = model.links[0];
                    }else if (model.links.count == 2)
                    {
                        phoneOne = model.links[0];
                        phoneTwo = model.links[1];
                    }else if (model.links.count >= 3)
                    {
                        phoneOne = model.links[0];
                        phoneTwo = model.links[1];
                        phoneThree = model.links[2];
                    }
                }
            }
            
            self.oneTextField.text = phoneOne;
            self.twoTextField.text = phoneTwo;
            self.threeTextField.text = phoneThree;
            
            //子账号有几个电话，显示几个
            if (!AUTHORITY_ROOT) {
                if (phoneThree.length == 0) {
                    self.threeBgView.hidden = YES;
                }
                
                if (phoneTwo.length == 0) {
                    self.threeBgView.hidden = YES;
                    self.twoBgView.hidden = YES;
                }
                
                if (phoneOne.length == 0) {
                    self.oneBgView.hidden = YES;
                    self.twoBgView.hidden = YES;
                    self.threeBgView.hidden = YES;
                }
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable){
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode != -999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
}

#pragma mark ---- 设置UI ----
- (void)configureUI
{
    if (AUTHORITY_ROOT)
    {
        //主账号可以保存、编辑
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
        
        self.tipLabel.hidden = NO;
        self.oneView_layout_top.constant = 44;
        
        self.oneTextField.userInteractionEnabled = YES;
        self.twoTextField.userInteractionEnabled = YES;
        self.threeTextField.userInteractionEnabled = YES;
    }else
    {
        //子账号只可以展示
        self.tipLabel.hidden = YES;
        self.oneView_layout_top.constant = 0;
        
        self.oneTextField.userInteractionEnabled = NO;
        self.twoTextField.userInteractionEnabled = NO;
        self.threeTextField.userInteractionEnabled = NO;
    }
    
    self.oneTextField.delegate = self;
    self.twoTextField.delegate = self;
    self.threeTextField.delegate = self;
    self.oneTextField.tag = 1;
    self.twoTextField.tag = 2;
    self.threeTextField.tag = 3;
    
    UIButton *textFiledClearButton1 = [self.oneTextField valueForKey:@"_clearButton"];
    [textFiledClearButton1 setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [textFiledClearButton1 setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateHighlighted];
    
    UIButton *textFiledClearButton2 = [self.twoTextField valueForKey:@"_clearButton"];
    [textFiledClearButton2 setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [textFiledClearButton2 setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateHighlighted];
    
    UIButton *textFiledClearButton3 = [self.threeTextField valueForKey:@"_clearButton"];
    [textFiledClearButton3 setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [textFiledClearButton3 setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateHighlighted];
    
    [self.oneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.twoTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.threeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark ---- 点击空白 收起键盘 ----
- (void)setUpForDismissKeyboard
{
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [self.view addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
    }];
    [self.view endEditing:YES];
}

#pragma mark ---- 监听文本变化 ----

- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            [self judgeTextFieldChange:textView];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self judgeTextFieldChange:textView];
    }
}

- (void)judgeTextFieldChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    int maxNum;
    maxNum = 13;
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

#pragma mark ---- 保存 ----
- (void)saveAction
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSString *onePhoneStr = [self.oneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *twoPhoneStr = [self.twoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *threePhoneStr = [self.threeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (onePhoneStr.length == 0 && twoPhoneStr.length == 0 && threePhoneStr.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请填写接单电话"];
        return;
    }
    
    if ((!StrIsEmpty(onePhoneStr) && ![QWGLOBALMANAGER isTelPhoneNumber:onePhoneStr]) || (!StrIsEmpty(twoPhoneStr) && ![QWGLOBALMANAGER isTelPhoneNumber:twoPhoneStr]) || (!StrIsEmpty(threePhoneStr) && ![QWGLOBALMANAGER isTelPhoneNumber:threePhoneStr])) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的接单电话"];
        return;
    }
    
    NSString *links = @"";
    if (onePhoneStr.length == 0 && twoPhoneStr.length > 0 && threePhoneStr.length > 0)
    {
        links = [NSString stringWithFormat:@"%@%@%@",twoPhoneStr,SeparateStr,threePhoneStr];
        
    }else if (twoPhoneStr.length == 0 && onePhoneStr.length > 0 && threePhoneStr.length > 0)
    {
        links = [NSString stringWithFormat:@"%@%@%@",onePhoneStr,SeparateStr,threePhoneStr];
        
    }else if (threePhoneStr.length == 0 && onePhoneStr.length > 0 && twoPhoneStr.length > 0)
    {
        links = [NSString stringWithFormat:@"%@%@%@",onePhoneStr,SeparateStr,twoPhoneStr];
        
    }else if (onePhoneStr.length == 0 && twoPhoneStr.length == 0 && threePhoneStr.length > 0)
    {
        links = threePhoneStr;
        
    }else if (onePhoneStr.length == 0 && threePhoneStr.length == 0 && twoPhoneStr.length > 0)
    {
        links = twoPhoneStr;
        
    }else if (twoPhoneStr.length == 0 && threePhoneStr.length == 0 && onePhoneStr.length > 0)
    {
        links = onePhoneStr;
        
    }else if (onePhoneStr.length > 0 && twoPhoneStr.length > 0 && threePhoneStr.length > 0)
    {
        links = [NSString stringWithFormat:@"%@%@%@%@%@",onePhoneStr,SeparateStr,twoPhoneStr,SeparateStr,threePhoneStr];
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"links"] = StrFromObj(links);
    
    [Branch BranchUpdateOrderLinksWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
