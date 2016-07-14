//
//  AddLabelViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-27.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "AddLabelViewController.h"
#import "AppDelegate.h"
#import "Customer.h"
#import "CustomerModelR.h"
#import "SVProgressHUD.h"

@interface AddLabelViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *img_text;
@property (strong, nonatomic) IBOutlet UITextField *text_add;

@end

@implementation AddLabelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新建标签";
    
    UIBarButtonItem *Rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveLabelInfo)];
    self.navigationItem.rightBarButtonItem = Rightbtn;
    [self setUpForDismissKeyboard];
    [self.text_add becomeFirstResponder];
    
}

#pragma mark ---- 保存标签信息 ----

-(void)saveLabelInfo{

    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [self showError:@"网络异常，请稍后重试"];
        return;
    }
    
    for (NSString *tempTag in self.labelArray) {
        if ([tempTag isEqualToString:self.text_add.text]) {
            [self showError:@"此标签已存在"];
            return;
        }
    }
    
    if (self.text_add.text.length > 5) {
        [self showError:@"不能超过5个字"];
        return;
    }
    
    if (self.text_add.text.length  == 0) {
        [self showError:@"您没有输入任何内容"];
        return;
    }
    __weak AddLabelViewController *weakSelf = self;
    
    CustomerAddTagModelR *modelR = [CustomerAddTagModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.tag = self.text_add.text;
    
    [Customer AddCustomerTagWithParams:modelR success:^(id obj) {
        
        [weakSelf.delegate addLabeldelegate:self.text_add.text];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failue:^(HttpException *e) {
        
    }];
}

//点击空白 收起键盘

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
    } completion:^(BOOL finished) {
        
    }];
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.text_add) {
        [self.text_add resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    self.img_text.image = [ UIImage imageNamed:@"输入框-输入"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
