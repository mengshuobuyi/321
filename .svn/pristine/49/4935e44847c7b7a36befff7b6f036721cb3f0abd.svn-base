//
//  SetLabelViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-25.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "SetLabelViewController.h"
#import "AddLabelViewController.h"
#import "AppDelegate.h"
#import "Customer.h"
#import "MyCustomerBaseModel.h"
#import "SVProgressHUD.h"

@interface SetLabelViewController ()<UIAlertViewDelegate,addLabeldelegate>

@property (strong, nonatomic) NSMutableArray *labelListArr;
@property (strong, nonatomic) NSMutableArray *hasChoseArr;
@property (strong, nonatomic) UIView *labelView;
@property (strong, nonatomic) UIImage *resizeImage;
@property (strong, nonatomic) UIImage *resizeImagetwo;

@property (strong, nonatomic) IBOutlet UITextField *text_remark;
@property (weak, nonatomic) IBOutlet UILabel *namelable;
@property (weak, nonatomic) IBOutlet UITextField *namedetails;

@end
@implementation SetLabelViewController

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
    
    self.title = @"设置";
//    self.scrollv.frame=CGRectMake(0, 0,APP_W, APP_H-NAV_H);
    self.namedetails.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    self.namelable.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    
    self.labelListArr = [NSMutableArray array];
    self.hasChoseArr = [NSMutableArray array];
    self.labelView = [[UIView alloc] init];
    if ([self.modelUserInfo.remark length] > 0) {
        self.text_remark.text = self.modelUserInfo.remark;
        self.img_write.image = [UIImage imageNamed:@"输入框-输入"];
    }
    if ([self.modelUserInfo.tags length] > 0) {
        self.hasChoseArr =[NSMutableArray arrayWithArray:[self.modelUserInfo.tags componentsSeparatedByString:SeparateStr]];
    }
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.text_remark.leftView = paddingView;
    self.text_remark.leftViewMode = UITextFieldViewModeAlways;
    [self getlabelList];
    UIBarButtonItem *Rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savenewsremark)];
    self.navigationItem.rightBarButtonItem = Rightbtn;
    [self setUpForDismissKeyboard];
    
    self.resizeImage = [UIImage imageNamed:@"标签背景"];
    self.resizeImage = [self.resizeImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
    self.resizeImagetwo = [UIImage imageNamed:@"标签背景-兰"];
    self.resizeImagetwo = [self.resizeImagetwo resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
 
}

#pragma mark ---- 点击空白 收起键盘 ----

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
        if (self.text_remark.text.length > 0) {
            self.img_write.image = [UIImage imageNamed:@"输入框-输入"];
        }else{
            self.img_write.image = [UIImage imageNamed:@"输入框-未输入"];
        }
    }];
    [self.view endEditing:YES];
    
}

#pragma mark ---- UITextField Delegate ----

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.text_remark) {
        [self.text_remark resignFirstResponder];
    }if (textField.text.length > 0) {
         self.img_write.image = [UIImage imageNamed:@"输入框-输入"];
    }else{
    self.img_write.image = [UIImage imageNamed:@"输入框-未输入"];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.img_write.image = [UIImage imageNamed:@"输入框-输入"];
}

#pragma mark ---- 服务器请求标签数据 ----

-(void)getlabelList{

    CustomerTagsModelR *tagModelR = [CustomerTagsModelR new];
    tagModelR.token = QWGLOBALMANAGER.configure.userToken;
    [Customer QueryCustomerTagsWithParams:tagModelR success:^(id obj) {
        [self.labelListArr removeAllObjects];
        NSArray *arrTemp = (NSArray *)obj;
        self.labelListArr = [NSMutableArray arrayWithArray:arrTemp];
        [self setUplabelTag];
    } failue:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 设置标签布局 ----

-(void)setUplabelTag{
    UIButton * netWorkButton = (UIButton *)[self.view viewWithTag:90001];
    [netWorkButton removeFromSuperview];
    
    
    for (UIView *subView in self.labelView.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat startWidth;
    CGFloat width;
    startWidth = 0 ;
    width = 0;
    int j = 0;
    self.labelView.userInteractionEnabled = YES;
    for (int i =0; i < self.labelListArr.count;  i++) {
        UIImageView *imageBg = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize constraint = CGSizeMake(20000.0f, 40.0f);
        NSAttributedString *questionAttributedText = [[NSAttributedString alloc]initWithString:[self.labelListArr objectAtIndex:i]
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        CGRect rect = [questionAttributedText boundingRectWithSize:constraint
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
        CGSize tempSize = rect.size;
        width= tempSize.width+startWidth;
        if (width > APP_W-27) {
            j++;
            startWidth = 0;
            width = 0;
        }
        label.frame = CGRectMake(12+startWidth, 40*j+4, tempSize.width+10,tempSize.height+5);
        imageBg.frame = CGRectMake(10+startWidth, 40*j+2, tempSize.width+15,tempSize.height+10);
        startWidth  =label.frame.origin.x+tempSize.width+15;
        label.text = [self.labelListArr objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:16]];
        if (![self.hasChoseArr containsObject:label.text]) {
            label.textColor =[UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0f];
            label.backgroundColor =[UIColor clearColor];
           
            imageBg.image = self.resizeImage;

        }else{
            
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            imageBg.image = self.resizeImagetwo;
            
        }
        
      
        label.tag = i+1;
        imageBg.tag = 10001+i;
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGest =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseLabel:)];
        [label addGestureRecognizer:tapGest];
        UILongPressGestureRecognizer *longGest =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletaLabel:)];
        [longGest setMinimumPressDuration:0.5f];
        [label addGestureRecognizer:longGest];
        
        [self.labelView addSubview:imageBg];
        [self.labelView addSubview:label];
    }
   
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 5.0;
    addBtn.backgroundColor = [UIColor whiteColor];
    if (self.labelListArr.count != 0) {
        addBtn.frame = CGRectMake(10, 42+j*40, 78.0f, 25);
    }else{
        addBtn.frame = CGRectMake(10, 10, 78.0f, 25);
    }
   
    [addBtn setTitle:@"添加标签" forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"添加标签背景"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"添加标签背景"] forState:UIControlStateHighlighted];
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [addBtn addTarget:self action:@selector(addLabelAction) forControlEvents:UIControlEventTouchUpInside];
    self.labelView.frame = CGRectMake(0,130, APP_W, j*40+70+addBtn.frame.size.height);
    [self.labelView addSubview:addBtn];
//    [self.scrollv addSubview:self.labelView];
    [self.view addSubview:self.labelView];
//    self.scrollv.contentSize=CGSizeMake(320, self.labelView.frame.origin.y+self.labelView.frame.size.height+20+64);
    
}

//点击标签的操作

-(void)choseLabel:(UITapGestureRecognizer *)sender{
    UILabel *label =(UILabel *) [self.view viewWithTag:sender.view.tag];
    UIImageView *imagevBG = (UIImageView *)[self.view viewWithTag:sender.view.tag+10000];
    if (self.hasChoseArr.count > 0) {
        if ([self.hasChoseArr containsObject:label.text]) {
            label.textColor = [UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0f];
            [self.hasChoseArr removeObject:label.text];
            label.backgroundColor = [UIColor clearColor];
           
            label.layer.borderColor=[UIColor clearColor].CGColor;
            imagevBG.image = self.resizeImage;
        }else{
            label.textColor = [UIColor whiteColor];
            
            [self.hasChoseArr addObject:label.text];
            label.backgroundColor = RGBHex(qwColor1);
            label.layer.borderColor=[UIColor clearColor].CGColor;
            imagevBG.image = self.resizeImagetwo;
        }
    }else{
        label.backgroundColor = RGBHex(qwColor1);
        label.textColor = [UIColor whiteColor];
        label.layer.borderColor=[UIColor whiteColor].CGColor;
        [self.hasChoseArr addObject:[self.labelListArr objectAtIndex:sender.view.tag-1]];
         imagevBG.image = self.resizeImagetwo;
    }
}


//长按删除标签

-(void)deletaLabel:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateEnded:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认清除所有对客户设置该标签的记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = gestureRecognizer.view.tag;
            [alert show];
        }
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            
            break;
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [self showError:@"网络异常，请稍后重试"];
        return;
    }
    if (buttonIndex == 1) {
        CustomerRemoveTagsModelR *modelR = [CustomerRemoveTagsModelR new];
        modelR.token = QWGLOBALMANAGER.configure.userToken;
        modelR.tag = [self.labelListArr objectAtIndex:alertView.tag-1];;
        [Customer RemoveCustomerTagsWithParams:modelR success:^(id obj) {
            [self.hasChoseArr removeObject:[self.labelListArr objectAtIndex:alertView.tag-1]];
            [self.labelListArr removeObjectAtIndex:alertView.tag-1];
            [self setUplabelTag];
        } failue:^(HttpException *e) {
            
        }];
    }
}

//添加标签action

-(void)addLabelAction{
    if (self.labelListArr.count >= 12){
        [SVProgressHUD showErrorWithStatus:@"添加的标签数最多为12个" duration:DURATION_SHORT];
        return;
    }
    
    AddLabelViewController *addlabel =[[AddLabelViewController alloc]initWithNibName:@"AddLabelViewController" bundle:nil];
    addlabel.delegate =self;
    addlabel.labelArray = self.labelListArr;
    [self.navigationController pushViewController:addlabel animated:YES];
}

-(void)addLabeldelegate:(NSString *)labeltext{
    [self.labelListArr addObject:labeltext];
    [self setUplabelTag];
}

//保存设置内容

-(void)savenewsremark{
    
    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [self showError:@"网络异常，请稍后重试"];
        return;
    }
    
    CustomerUpdateTagsModelR *modelR = [CustomerUpdateTagsModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.customer = self.modelUserInfo.passportId;
    
    if ([self.text_remark.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 8) {
        [self showError:@"备注姓名不超过8个字"];
        return;
    }
    
    if ([self.text_remark.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0 && [self.text_remark.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 9) {
        modelR.remark = [self.text_remark.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }else{
        modelR.remark = @"";
    }
    
    NSString *tags =@"";
    if (self.hasChoseArr) {
        for (int i = 0; i < self.hasChoseArr.count; i++) {
            if (i == 0) {
                tags = [NSString stringWithFormat:@"%@",[self.hasChoseArr objectAtIndex:i]];
            }else{
                tags = [NSString stringWithFormat:@"%@%@%@",[self.hasChoseArr objectAtIndex:i],SeparateStr,tags];
            }
        }
    }
    
    if (self.hasChoseArr.count > 8) {
        [self showError:@"选择的标签数最多为8个"];
        return;
    }
    
    modelR.tags = tags;
    
    __weak SetLabelViewController *weakself=self;
    [Customer UpdateCustomerTagsWithParams:modelR success:^(id obj) {
        
        [weakself.delegate changeLabeldelegate];
        [QWGLOBALMANAGER postNotif:NotifContactUpdateImmediate data:nil object:nil];
        [weakself.navigationController popViewControllerAnimated:NO];
        
    } failue:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
