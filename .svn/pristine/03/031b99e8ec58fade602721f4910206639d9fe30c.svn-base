//
//  SilenceAppealViewController.m
//  APP
//
//  Created by Martin.Liu on 16/7/12.
//  Copyright © 2016年 carret. All rights reserved.
//

// 9、禁言申诉字数，上限100字；
#import "SilenceAppealViewController.h"
#import "TKTextView.h"
#import "NSString+MarCategory.h"

@interface SilenceAppealViewController ()
@property (strong, nonatomic) IBOutlet TKTextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *appealBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_appealBtnBottom;
- (IBAction)appealBtnAction:(id)sender;

@end

@implementation SilenceAppealViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"禁言申诉";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBHex(qwColor11);
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 4;
    self.textView.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    self.textView.layer.borderColor = RGBHex(qwColor10).CGColor;
    
    self.appealBtn.layer.masksToBounds = YES;
    self.appealBtn.layer.cornerRadius = 4;
    self.appealBtn.backgroundColor = RGBHex(qwColor2);
    self.appealBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.appealBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    
    self.textView.placeholder = @"请填写您的申诉理由";
    self.textView.font = [UIFont systemFontOfSize:kFontS1];
    self.textView.textColor = RGBHex(qwColor7);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoardWillShow:(NSNotification*)noti
{
    NSValue* keyRectVal = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyFrame = [keyRectVal CGRectValue];
    CGFloat height = CGRectGetHeight(keyFrame);
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        strongSelf.constraint_appealBtnBottom.constant = height + 10;
        [strongSelf.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillHiden:(NSNotification*)noti
{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        strongSelf.constraint_appealBtnBottom.constant = 0;
        [strongSelf.view layoutIfNeeded];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)appealBtnAction:(id)sender {
    if ([self.textView.text mar_trim].length == 0) {
        
        return;
    }
    if (self.textView.text.length > 100) {
        
        return;
    }
}
@end
