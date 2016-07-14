//
//  CheckNewsViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-10.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "CheckNewsViewController.h"
#import "QuickRegisterPerfectViewController.h"
#import "Store.h"
#import "StoreModelR.h"

@interface CheckNewsViewController ()<UITextFieldDelegate>
- (IBAction)QuickNextAction:(id)sender;
- (IBAction)QuickLastAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_next;
@property (strong, nonatomic) IBOutlet UIButton *btn_last;

@property (strong, nonatomic) IBOutlet UITextField *lbl_institutionNum;
@property (strong, nonatomic) IBOutlet UITextField *lbl_institutionName;
@property (strong, nonatomic) IBOutlet UITextField *lbl_institutionAdress;
@property(strong,nonatomic) NSString *latitude;
@end

@implementation CheckNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    self.lbl_institutionNum.delegate = self;
    self.lbl_institutionName.delegate = self;
    self.lbl_institutionAdress.delegate = self;
    self.btn_last.layer.masksToBounds = YES;
    self.btn_last.layer.cornerRadius =3.0f;
    self.btn_last.backgroundColor=RGBHex(qwColor9);
    self.btn_next.layer.masksToBounds = YES;
    self.btn_next.layer.cornerRadius =3.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.btn_next.userInteractionEnabled = YES;
    BranchGroupModel * companyDic = [QWUserDefault getModelBy:QUICK_COMPANY];
    self.lbl_institutionName.text = companyDic.name;
    self.lbl_institutionNum.text = companyDic.groupCode;
    self.lbl_institutionAdress.text = companyDic.address;
    self.latitude = companyDic.latitude;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.lbl_institutionNum resignFirstResponder];
    [self.lbl_institutionName resignFirstResponder];
    [self.lbl_institutionAdress resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进行下一步操作
- (IBAction)QuickNextAction:(id)sender {
    if ([QWGlobalManager sharedInstance].currentNetWork == kNotReachable) {
        [self showError:kWaring33];
        return;
    }
    self.btn_next.userInteractionEnabled = NO;
    BranchGroupModel *branchModel=[QWUserDefault getModelBy:QUICK_COMPANY];
    StoreCodeModelR *model=[StoreCodeModelR new];
    model.sequence=branchModel.sequence;
    
    
    [Store QueryStoreCodeWithParams:model success:^(id UFModel){
        
        QuickRegisterPerfectViewController *perfectVC = [[QuickRegisterPerfectViewController alloc]initWithNibName:@"QuickRegisterPerfectViewController" bundle:nil];
        if (self.latitude.length == 0) {
            [QWUserDefault setBool:NO key:QUICK_HASLATITUDE];
        }else {
            [QWUserDefault setBool:YES key:QUICK_HASLATITUDE];
        }
        [self.navigationController pushViewController:perfectVC animated:YES];
        self.btn_next.userInteractionEnabled = YES;
        
    } failure:^(HttpException *e){
        self.btn_next.userInteractionEnabled = YES;
        
    }];
}

- (IBAction)QuickLastAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.btn_next.userInteractionEnabled = YES;
}

@end
