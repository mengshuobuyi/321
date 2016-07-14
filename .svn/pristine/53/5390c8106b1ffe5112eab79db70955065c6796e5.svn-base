//
//  quickRegisterViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-10.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "quickRegisterViewController.h"
#import "CheckNewsViewController.h"
#import "Store.h"


@interface quickRegisterViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *text_XLNum;
- (IBAction)CheckAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_check;
@property (weak, nonatomic) IBOutlet UIImageView *backline_view;

@end

@implementation quickRegisterViewController

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
     [self setUpForDismissKeyboard];
    self.backline_view.layer.borderWidth=0.5f;
    self.backline_view.layer.borderColor=RGBHex(qwColor10).CGColor;
    self.view.backgroundColor=RGBHex(qwColor11);
    self.btn_check.layer.cornerRadius = 3.0f;
    self.btn_check.layer.masksToBounds = YES;
    self.title = @"注册";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    if (textField == self.text_XLNum) {
        [self.text_XLNum resignFirstResponder];
    }
    return YES;
}

//验证序列号!
- (IBAction)CheckAction:(id)sender {
    if ([QWGlobalManager sharedInstance].currentNetWork == kNotReachable) {
        [self showError:kWaring33];
        return;
    }
    StoreCodeModelR *param=[StoreCodeModelR new];
    param.sequence=[self.text_XLNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([self.text_XLNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
            [self showError:kWaring36];
            return;
        }else{
            self.btn_check.userInteractionEnabled = NO;
        [Store QueryStoreCodeWithParams:param success:^(id UFModel){
            
            StoreCodeModel *modelAll=(StoreCodeModel *)UFModel;
            
           //序列号通过
            if([modelAll.apiStatus intValue]==0){
            BranchGroupModelR *param=[BranchGroupModelR new];
            param.branchId=modelAll.groupId;
            
            [Store GetBranchGroupWithParams:param success:^(id DFModel){
                self.btn_check.userInteractionEnabled = YES;
                CheckNewsViewController *checkVC = [[CheckNewsViewController alloc] initWithNibName:@"CheckNewsViewController" bundle:nil];
                BranchGroupModel* subModel=(BranchGroupModel*)DFModel;
                subModel.sequence=[self.text_XLNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                QWGLOBALMANAGER.configure.groupId=modelAll.groupId;
                [QWGLOBALMANAGER saveAppConfigure];
                
                [QWUserDefault setModel:subModel key:QUICK_COMPANY];
                [self.navigationController pushViewController:checkVC animated:YES];
            } failure:^(HttpException *e){
                self.btn_check.userInteractionEnabled = YES;
            }];
            }else{
            [self showError:modelAll.apiMessage];
            self.btn_check.userInteractionEnabled = YES;

            }
        } failure:^(HttpException *e){
            self.btn_check.userInteractionEnabled = YES;        
        }];
  
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
