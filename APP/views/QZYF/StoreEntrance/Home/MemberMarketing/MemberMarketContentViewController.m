//
//  MemberMarketContentViewController.m
//  wenYao-store
//
//  选择会员营销内容页面
//  h5/mmall/mktg/submit/act
//  h5/mmall/mktg/submit/dm
//  h5/mmall/mktg/submit/coupon
//
//  Created by PerryChen on 5/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberMarketContentViewController.h"
#import "MemberPointShortageView.h"
#import "MemberMarketConfirmView.h"
#import "PushDatePicker.h"
#import "FirstCoupnTableViewCell.h"
#import "ThreeCoupnTableViewCell.h"
#import "MarketingActivityTableViewCell.h"
#import "CoupnModel.h"
#import "ActivityModel.h"
#import "WechatActivityModel.h"
#import "MarketingActivityTableViewCell.h"
#import "WechatActivityCell.h"
#import "MarketSelectTicketViewController.h"
#import "MarketSelectProductViewController.h"
#import "MarketSelectBrochureViewController.h"
#import "MemberMarket.h"
static NSInteger maxTextNum = 20;     // 最大文字数
#define ThreeCoupnCell @"ThreeCoupnCell"
#define FirstCoupnCell @"FirstCoupnCell"
#define MarketingActivityTableViewCellIdentifier @"MarketingActivityTableViewCellIdentifier"
#define WechatActivityCellIdentifier @"WechatActivityCell"
@interface MemberMarketContentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, MmeberPointShortageDelegate, MemberConfirmDelegate, PushDatePickerDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewTableFooter;
@property (strong, nonatomic) IBOutlet UIView *viewTableHeader;
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (weak, nonatomic) IBOutlet UIView *viewStepOne;
@property (weak, nonatomic) IBOutlet UIView *viewStepTwo;

@property (weak, nonatomic) IBOutlet UILabel *lblChooseMember;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewTikectBack;
@property (weak, nonatomic) IBOutlet UILabel *lblChooseTicket;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProductBack;
@property (weak, nonatomic) IBOutlet UILabel *lblChooseProduct;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBrochureBack;
@property (weak, nonatomic) IBOutlet UILabel *lblChooseBrochure;

@property (weak, nonatomic) IBOutlet UIButton *btnChoossTag;

@property (weak, nonatomic) IBOutlet UIView *viewMarketContent;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketCount;
@property (weak, nonatomic) IBOutlet UITextView *tvMarketContent;

@property (weak, nonatomic) IBOutlet UIView *viewChooseNotiDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPushNotiDate;
@property (weak, nonatomic) IBOutlet UIView *viewConfirm;

@property (assign, nonatomic) NSInteger intMarketType;  // 0 优惠券 1 商品 2 海报

@property (assign, nonatomic) BOOL clickOnce;           // 防止网络过慢，重复点击

@end

@implementation MemberMarketContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择营销内容";
    self.modelTicket = [CurSelectMarketModel new];
    self.modelProduct = [CurSelectMarketModel new];
    self.modelBrochure = [CurSelectMarketModel new];
    self.modelTicket.arrMarketSelect = [NSMutableArray array];
    self.modelProduct.arrMarketSelect = [NSMutableArray array];
    self.modelBrochure.arrMarketSelect = [NSMutableArray array];
    self.tbViewContent.tableHeaderView = self.viewTableHeader;
    self.tbViewContent.tableFooterView = self.viewTableFooter;
    UINib *nibOne = [UINib nibWithNibName:@"FirstCoupnTableViewCell" bundle:nil];
    [self.tbViewContent registerNib:nibOne forCellReuseIdentifier:FirstCoupnCell];
    UINib *nibTwo = [UINib nibWithNibName:@"ThreeCoupnTableViewCell" bundle:nil];
    [self.tbViewContent registerNib:nibTwo forCellReuseIdentifier:ThreeCoupnCell];
    UINib *nibThree = [UINib nibWithNibName:@"MarketingActivityTableViewCell" bundle:nil];
    [self.tbViewContent registerNib:nibThree forCellReuseIdentifier:MarketingActivityTableViewCellIdentifier];
    UINib *nibFour = [UINib nibWithNibName:@"WechatActivityCell" bundle:nil];
    [self.tbViewContent registerNib:nibFour forCellReuseIdentifier:WechatActivityCellIdentifier];
    self.intMarketType = 0;
    [self setViewContent];
    self.lblMarketPlaceholder.hidden = NO;
    self.lblMarketCount.text = [NSString stringWithFormat:@"0/%d",maxTextNum];

    self.modelTicket.selectType = 0;
    self.modelProduct.selectType = 1;
    self.modelBrochure.selectType = 2;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewEditChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (NSDate *)dateFromCustomString:(NSString *)strDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy 年 MM 月 dd 日"];
    return [formatter dateFromString:strDate];
}

- (NSString *)stringFromCustomDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy 年 MM 月 dd 日"];
    return [formatter stringFromDate:date];
}

/**
 *  设置页面初始状态
 */
- (void)setViewContent
{
    self.viewStepTwo.layer.cornerRadius = self.viewStepOne.layer.cornerRadius = 2.0f;
    self.imgViewBackground.layer.cornerRadius = 2.0f;
    self.btnChoossTag.layer.cornerRadius = 4.0f;
    self.btnChoossTag.layer.borderColor = RGBHex(qwColor2).CGColor;
    self.btnChoossTag.layer.borderWidth = 1.0f;
    self.btnChoossTag.layer.masksToBounds = YES;
    self.viewMarketContent.layer.cornerRadius = 2.0f;
    self.viewMarketContent.layer.borderWidth = 0.5f;
    self.viewMarketContent.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.viewChooseNotiDate.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.viewChooseNotiDate.layer.cornerRadius = 2.0f;
    self.viewChooseNotiDate.layer.borderWidth = 0.5f;
    self.viewConfirm.layer.cornerRadius = 2.0f;
    self.viewConfirm.backgroundColor = RGBHex(qwColor9);
    self.btnConfirm.enabled = NO;
    NSDate *date = [NSDate date];
    NSDate *tomorrow =[NSDate dateWithTimeInterval:+60*60*24 sinceDate:date];
    self.lblPushNotiDate.text = [self stringFromCustomDate:tomorrow];
    self.modelTicket.notiDate = tomorrow;
    self.modelProduct.notiDate = tomorrow;
    self.modelBrochure.notiDate = tomorrow;
    self.lblChooseMember.text = [NSString stringWithFormat:@"共选择了%@人，需消耗商家%@积分",self.modelCheck.counts,self.modelCheck.score];
    [self setMarketContentType];
}

/**
 *  点击了按钮后，重新设置选择券或者商品或者海报UI, 顶部的tab
 */
- (void)setMarketContentType
{
    self.imgViewTikectBack.hidden = self.imgViewProductBack.hidden = self.imgViewBrochureBack.hidden = YES;
    self.lblChooseTicket.textColor = self.lblChooseProduct.textColor = self.lblChooseBrochure.textColor = [UIColor whiteColor];
    if (self.intMarketType == 0) {
        self.imgViewTikectBack.hidden = NO;
        self.lblChooseTicket.textColor = RGBHex(qwColor6);
    } else if (self.intMarketType == 1) {
        self.imgViewProductBack.hidden = NO;
        self.lblChooseProduct.textColor = RGBHex(qwColor6);
    } else {
        self.imgViewBrochureBack.hidden = NO;
        self.lblChooseBrochure.textColor = RGBHex(qwColor6);
    }
}

/**
 *  根据选择好的Model设置页面
 *
 *  @param model
 */
- (void)setCurViewStatusWithModel:(CurSelectMarketModel *)model
{
    if (model.strMarketName.length > 0) {
        self.tvMarketContent.text = model.strMarketName;
        self.lblMarketPlaceholder.hidden = YES;
        self.lblMarketCount.text = [NSString stringWithFormat:@"%d/%d",self.tvMarketContent.text.length,maxTextNum];
    } else {
        self.tvMarketContent.text = @"";
        self.lblMarketPlaceholder.hidden = NO;
        self.lblMarketCount.text = [NSString stringWithFormat:@"0/%d",maxTextNum];
    }
    if (model.notiDate == nil) {
        NSDate *date = [NSDate date];
        NSDate *tomorrow =[NSDate dateWithTimeInterval:+60*60*24 sinceDate:date];
        self.lblPushNotiDate.text = [self stringFromCustomDate:tomorrow];
    } else {
        self.lblPushNotiDate.text = [self stringFromCustomDate:model.notiDate];
    }
    
    if (self.intMarketType == 0) {      // 优惠券
        if (self.modelTicket.arrMarketSelect.count > 0) {
            [self.btnChoossTag setTitle:@"重新选择优惠券" forState:UIControlStateNormal];
            self.viewConfirm.backgroundColor = RGBHex(qwColor2);
            self.btnConfirm.enabled = YES;
        } else {
            [self.btnChoossTag setTitle:@"选择优惠券" forState:UIControlStateNormal];
            self.viewConfirm.backgroundColor = RGBHex(qwColor9);
            self.btnConfirm.enabled = NO;
        }
    } else if (self.intMarketType == 1) {       // 优惠商品
        if (self.modelProduct.arrMarketSelect.count > 0) {
            [self.btnChoossTag setTitle:@"重新选择商品" forState:UIControlStateNormal];
            self.viewConfirm.backgroundColor = RGBHex(qwColor2);
            self.btnConfirm.enabled = YES;
        } else {
            [self.btnChoossTag setTitle:@"选择商品" forState:UIControlStateNormal];
            self.viewConfirm.backgroundColor = RGBHex(qwColor9);
            self.btnConfirm.enabled = NO;
        }
    } else if (self.intMarketType == 2) {       // 门店海报
        if (self.modelBrochure.arrMarketSelect.count > 0) {
            [self.btnChoossTag setTitle:@"重新选择营销海报" forState:UIControlStateNormal];
            self.viewConfirm.backgroundColor = RGBHex(qwColor2);
            self.btnConfirm.enabled = YES;
        } else {
            [self.btnChoossTag setTitle:@"选择营销海报" forState:UIControlStateNormal];
            self.viewConfirm.backgroundColor = RGBHex(qwColor9);
            self.btnConfirm.enabled = NO;
        }
    }
    [self.tbViewContent reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    __weak typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"segueTicket"]) {    // 跳转到选择优惠券
        MarketSelectTicketViewController *vc = segue.destinationViewController;
        if (self.modelTicket.arrMarketSelect.count > 0) {
            vc.modelVo = self.modelTicket.arrMarketSelect[0];
        }
        vc.block = ^(OnlineBaseCouponDetailVo *model) {
            [weakSelf.modelTicket.arrMarketSelect removeAllObjects];
            [weakSelf.modelTicket.arrMarketSelect addObject:model];
            [weakSelf setCurViewStatusWithModel:weakSelf.modelTicket];
            [weakSelf.tbViewContent reloadData];
        };
    } else if ([segue.identifier isEqualToString:@"segueProduct"]) {        // 跳转到选择商品
        MarketSelectProductViewController *vc = segue.destinationViewController;
        if (self.modelProduct.arrMarketSelect.count > 0) {
            vc.arrPre = [self.modelProduct.arrMarketSelect mutableCopy];
        }
        vc.block = ^(NSMutableArray *arrSelected) {
            [weakSelf.modelProduct.arrMarketSelect removeAllObjects];
            [weakSelf.modelProduct.arrMarketSelect addObjectsFromArray:arrSelected];
            [weakSelf setCurViewStatusWithModel:weakSelf.modelProduct];
            [weakSelf.tbViewContent reloadData];
        };
    } else if ([segue.identifier isEqualToString:@"segueBrochure"]) {       // 跳转到选择海报
        MarketSelectBrochureViewController *vc = segue.destinationViewController;
        if (self.modelBrochure.arrMarketSelect.count > 0) {
            vc.modelVo = self.modelBrochure.arrMarketSelect[0];
        }
        vc.block = ^(QueryActivityInfo *model) {
            [weakSelf.modelBrochure.arrMarketSelect removeAllObjects];
            [weakSelf.modelBrochure.arrMarketSelect addObject:model];
            [weakSelf setCurViewStatusWithModel:weakSelf.modelBrochure];
            [weakSelf.tbViewContent reloadData];
        };
    }
}

- (void)actionSubmit
{
    MarketMemberSubmitModelR *modelR = [MarketMemberSubmitModelR new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if (self.intMarketType == 0) {  // 优惠券
        [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_xzyx_yhqtj" withLable:@"会员营销" withParams:nil];
        OnlineBaseCouponDetailVo *model = self.modelTicket.arrMarketSelect[0];
        modelR.title = self.modelTicket.strMarketName;
        modelR.day = [formatter stringFromDate:self.modelTicket.notiDate];
        modelR.couponId = model.couponId;
        modelR.token = QWGLOBALMANAGER.configure.userToken;
        [MemberMarket postMktgSubmitCoupon:modelR success:^(MemberMarketModel *responseModel) {
            self.clickOnce = NO;
            if ([responseModel.apiStatus intValue] != 0) {
                if ([responseModel.apiStatus intValue] == 2020001) {
                    [self showShortagePointView];
                } else {
                    [self showError:responseModel.apiMessage];
                }
            } else {
                self.blockComplete();
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(HttpException *e) {
            self.clickOnce = NO;
        }];
    } else if (self.intMarketType == 1) {       // 优惠商品
        [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_xzyx_sqytj" withLable:@"会员营销" withParams:nil];
        NSMutableArray *arrIds = [NSMutableArray array];
        for (MicroMallActivityVO *model in self.modelProduct.arrMarketSelect) {
//            [arrIds addObject:model.actId];
            NSDictionary *dic = @{@"id":model.actId,@"type":model.type};
            [arrIds addObject:dic];
        }
        NSDictionary *dicId = @{@"act":arrIds};
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicId options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        modelR.title = self.modelProduct.strMarketName;
        modelR.day = [formatter stringFromDate:self.modelProduct.notiDate];
        modelR.actJson = jsonString;
        modelR.token = QWGLOBALMANAGER.configure.userToken;
        [MemberMarket postMktgSubmitAct:modelR success:^(MemberMarketModel *responseModel) {
            self.clickOnce = NO;
            if ([responseModel.apiStatus intValue] != 0) {
                if ([responseModel.apiStatus intValue] == 2020001) {
                    [self showShortagePointView];
                } else {
                    [self showError:responseModel.apiMessage];
                }
            } else {
                self.blockComplete();
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(HttpException *e) {
            self.clickOnce = NO;
        }];
    } else if (self.intMarketType == 2) {       // 海报
        [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_xzyx_mdhbtj" withLable:@"会员营销" withParams:nil];
        QueryActivityInfo *model = self.modelBrochure.arrMarketSelect[0];
        modelR.title = self.modelBrochure.strMarketName;
        modelR.day = [formatter stringFromDate:self.modelBrochure.notiDate];
        modelR.dmId = model.id;
        modelR.token = QWGLOBALMANAGER.configure.userToken;
        [MemberMarket postMktgSubmitDm:modelR success:^(MemberMarketModel *responseModel) {
            self.clickOnce = NO;
            if ([responseModel.apiStatus intValue] != 0) {
                if ([responseModel.apiStatus intValue] == 2020001) {
                    [self showShortagePointView];
                } else {
                    [self showError:responseModel.apiMessage];
                }
            } else {
                self.blockComplete();
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(HttpException *e) {
            self.clickOnce = NO;
        }];
    }
}

/**
 *  显示积分不足页面
 */
- (void)showShortagePointView
{
    MemberPointShortageView *view = [[NSBundle mainBundle]loadNibNamed:@"MemberPointShortageView" owner:nil options:nil][0];
    view.viewBg.alpha = 0;
    view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:view];
    view.delegate = self;
    [UIView animateWithDuration:0.25 animations:^{
        view.viewBg.alpha = 0.4;
    }];

}

#pragma mark - UIButton methods
// 选择了会员营销内容的点击方法
// 优惠券
- (IBAction)chooseTicketAction:(UIButton *)sender {
    [self.tvMarketContent resignFirstResponder];
    self.intMarketType = 0;
    [self setMarketContentType];
    [self setCurViewStatusWithModel:self.modelTicket];
}

// 优惠商品
- (IBAction)chooseProductAction:(UIButton *)sender {
    [self.tvMarketContent resignFirstResponder];
    self.intMarketType = 1;
    [self setMarketContentType];
    [self setCurViewStatusWithModel:self.modelProduct];
}

// 海报
- (IBAction)chooseBrochureAction:(UIButton *)sender {
    [self.tvMarketContent resignFirstResponder];
    self.intMarketType = 2;
    [self setMarketContentType];
    [self setCurViewStatusWithModel:self.modelBrochure];
}

// 选择营销内容页面
- (IBAction)chooseTagAction:(id)sender {
    [self.tvMarketContent resignFirstResponder];
    if (self.intMarketType == 0) {
        [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_xzyx_xzyhq" withLable:@"会员营销" withParams:nil];
        [self performSegueWithIdentifier:@"segueTicket" sender:sender];
    } else if (self.intMarketType == 1) {
        [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_xzyx_xzsp" withLable:@"会员营销" withParams:nil];
        [self performSegueWithIdentifier:@"segueProduct" sender:sender];
    } else if (self.intMarketType == 2) {
        [QWGLOBALMANAGER statisticsEventId:@"s_hyyx_xzyx_xzmdhb" withLable:@"会员营销" withParams:nil];
        [self performSegueWithIdentifier:@"segueBrochure" sender:sender];
    }
    
}


- (IBAction)choosePushDateAction:(id)sender {
    [self.tvMarketContent resignFirstResponder];
    PushDatePicker *datePicker = [[PushDatePicker alloc] initWithButtonType:0];
    datePicker.delegate = self;
    if (self.lblPushNotiDate.text.length > 0) {
        NSDate *selDate = [self dateFromCustomString:self.lblPushNotiDate.text];
        [datePicker setCurDate:selDate];
    }
    [datePicker show];
}

- (IBAction)confirmMarketAction:(UIButton *)sender {
    [self.tvMarketContent resignFirstResponder];
    [self checkPostContent];
}

#pragma mark - UITextView methods
// 监听文本改变
-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxTextNum) {
                textView.text = [toBeString substringToIndex:maxTextNum];
            }
            [self setRemainWord:textView.text.length];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxTextNum) {
            textView.text = [toBeString substringToIndex:maxTextNum];
        }
        [self setRemainWord:textView.text.length];
    }
}

// 设置剩余输入字数
- (void)setRemainWord:(NSInteger)wordInputted
{
    self.lblMarketCount.text = [NSString stringWithFormat:@"%d/%d",self.tvMarketContent.text.length,maxTextNum];
    if (self.intMarketType == 0) {
        self.modelTicket.strMarketName = self.tvMarketContent.text;
    } else if (self.intMarketType == 1) {
        self.modelProduct.strMarketName = self.tvMarketContent.text;
    } else if (self.intMarketType == 2) {
        self.modelBrochure.strMarketName = self.tvMarketContent.text;
    }
    if (self.tvMarketContent.text.length == 0) {
        self.lblMarketPlaceholder.hidden = NO;
    } else {
        self.lblMarketPlaceholder.hidden = YES;
    }
}

- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    
    if (self.tbViewContent.contentSize.height > self.tbViewContent.bounds.size.height) {
        yOffset = self.tbViewContent.contentSize.height - self.tbViewContent.bounds.size.height;
    }
    
    [self.tbViewContent setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (void)keyboardChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.constraintBottom.constant = height;
        [self.view layoutIfNeeded];
        [self scrollToBottom];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.constraintBottom.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark - custom delegate methods
- (NSString *)judgeContent:(NSString *)title notiDate:(NSDate *)nDate
{
    NSString *strErr = @"";
    if (title.length == 0) {
        strErr = @"请填写营销主题";
    }
    NSDate * today = [NSDate date];
    NSComparisonResult result = [today compare:nDate];
    switch (result)
    {
        case NSOrderedAscending:
            
            break;
        case NSOrderedDescending:
            strErr = @"抱歉您选择的日期已经过去了，请重新编辑日期哟!";
            break;
        case NSOrderedSame:
            strErr = @"抱歉您选择的日期已经过去了，请重新编辑日期哟!"; //Not sure why This is case when null/wrong date is passed
            break;
        default:
            strErr = @"抱歉您选择的日期已经过去了，请重新编辑日期哟!";
            break;
    }
    return strErr;
}

- (void)checkPostContent
{
    BOOL canSubmit = NO;
    NSString *strReturn = @"";
    if (self.intMarketType == 0) {
        strReturn = [self judgeContent:self.modelTicket.strMarketName notiDate:self.modelTicket.notiDate];
        if (strReturn.length > 0) {
            canSubmit = NO;
        } else {
            canSubmit = YES;
        }
    } else if (self.intMarketType == 1) {
        strReturn = [self judgeContent:self.modelProduct.strMarketName notiDate:self.modelProduct.notiDate];
        if (strReturn.length > 0) {
            canSubmit = NO;
        } else {
            canSubmit = YES;
        }
    } else if (self.intMarketType == 2) {
        strReturn = [self judgeContent:self.modelBrochure.strMarketName notiDate:self.modelBrochure.notiDate];
        if (strReturn.length > 0) {
            canSubmit = NO;
        } else {
            canSubmit = YES;
        }
    }
    if (!canSubmit) {
        [self showError:strReturn];
    } else {
        MemberMarketConfirmView *view = [[NSBundle mainBundle]loadNibNamed:@"MemberMarketConfirmView" owner:nil options:nil][0];
        view.viewBg.alpha = 0;
        view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        view.lblMemberScore.text = [NSString stringWithFormat:@"此次营销将消耗商家%@积分",self.modelCheck.score];
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        [win addSubview:view];
        view.delegate = self;
        [UIView animateWithDuration:0.25 animations:^{
            view.viewBg.alpha = 0.4;
        }];
    }
}

- (void)confirmSelect
{
    if (!self.clickOnce) {
        self.clickOnce = YES;
        [self actionSubmit];
    }
}

- (void)cancelSelect
{
    
}
// 时间控件选择回调函数
- (void)makeSureDateActionWithDate:(NSDate *)date type:(int)buttontype
{
    self.lblPushNotiDate.text = [self stringFromCustomDate:date];
    if (self.intMarketType == 0) {
        self.modelTicket.notiDate = date;
    } else if (self.intMarketType == 1) {
        self.modelProduct.notiDate = date;
    } else if (self.intMarketType == 2) {
        self.modelBrochure.notiDate = date;
    }
}

- (void)RechooseMember
{
    self.block();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.intMarketType == 0) {
        return self.modelTicket.arrMarketSelect.count;
    } else if (self.intMarketType == 1) {
        return self.modelProduct.arrMarketSelect.count;
    } else if (self.intMarketType == 2) {
        return self.modelBrochure.arrMarketSelect.count;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.intMarketType == 0) {
        // ticket
        OnlineBaseCouponDetailVo *model = self.modelTicket.arrMarketSelect[indexPath.row];
        if (!StrIsEmpty(model.giftImgUrl)) {
            ThreeCoupnTableViewCell *threeCell = (ThreeCoupnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThreeCoupnCell];
            [threeCell setCoupnOtherDetailCell:model];
            threeCell.constraintViewTop.constant = 0;
            [threeCell setNeedsLayout];
            [threeCell layoutIfNeeded];
            UIView *placeHolderViewLead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, threeCell.bounds.size.height)];
            UIView *placeHolderViewTrail = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 5, 0, 5, threeCell.bounds.size.height)];
            
            placeHolderViewLead.backgroundColor = RGBHex(qwColor11);
            placeHolderViewTrail.backgroundColor = RGBHex(qwColor11);
            threeCell.contentView.backgroundColor = [UIColor whiteColor];
            [threeCell.contentView addSubview:placeHolderViewLead];
            [threeCell.contentView addSubview:placeHolderViewTrail];
            return threeCell;
        } else {
            FirstCoupnTableViewCell *firstCell = (FirstCoupnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FirstCoupnCell];
            [firstCell setCoupnOtherDetailCell:model];
            firstCell.constraintViewTop.constant = 0;
            [firstCell setNeedsLayout];
            [firstCell layoutIfNeeded];
            UIView *placeHolderViewLead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, firstCell.bounds.size.height)];
            UIView *placeHolderViewTrail = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 5, 0, 5, firstCell.bounds.size.height)];
            
            placeHolderViewLead.backgroundColor = RGBHex(qwColor11);
            placeHolderViewTrail.backgroundColor = RGBHex(qwColor11);
            firstCell.contentView.backgroundColor = [UIColor whiteColor];
            [firstCell.contentView addSubview:placeHolderViewLead];
            [firstCell.contentView addSubview:placeHolderViewTrail];
            return firstCell;
        }
    } else if (self.intMarketType == 1) {
        MicroMallActivityVO *model = self.modelProduct.arrMarketSelect[indexPath.row]; //[MicroMallActivityVO new];
        WechatActivityCell *marketCell = (WechatActivityCell *)[tableView dequeueReusableCellWithIdentifier:WechatActivityCellIdentifier];
        [marketCell setCell:model];
        UIView *placeHolderViewLead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, marketCell.bounds.size.height)];
        UIView *placeHolderViewTrail = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 5, 0, 5, marketCell.bounds.size.height)];
        
        placeHolderViewLead.backgroundColor = RGBHex(qwColor11);
        placeHolderViewTrail.backgroundColor = RGBHex(qwColor11);
        marketCell.contentView.backgroundColor = [UIColor whiteColor];
        [marketCell.contentView addSubview:placeHolderViewLead];
        [marketCell.contentView addSubview:placeHolderViewTrail];
        return marketCell;
    } else if (self.intMarketType == 2) {
        QueryActivityInfo *model = self.modelBrochure.arrMarketSelect[0];//[QueryActivityInfo new];
        MarketingActivityTableViewCell *marketCell = (MarketingActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MarketingActivityTableViewCellIdentifier];
        marketCell.titleLabel.text = model.title;
        marketCell.contentLabel.text = [QWGLOBALMANAGER replaceSpecialStringWith:model.content];
        marketCell.avatarImage.contentMode = UIViewContentModeScaleAspectFit;
        [marketCell.avatarImage setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"]];
        marketCell.avatarImage.hidden = NO;
        NSString *strSource = @"";
        NSString *strSourceAndDate=@"";
        if ([model.source intValue] == 1) {
            strSource = @"全维";
        } else if ([model.source intValue] == 2) {
            strSource = @"商户";
        } else if ([model.source intValue] == 3){
            strSource = @"门店";
        }
        if(strSource==nil||[strSource isEqualToString:@""]){
            strSourceAndDate = [NSString stringWithFormat:@""];
        }else{
            strSourceAndDate = [NSString stringWithFormat:@"来源: %@",strSource];
        }
        
        marketCell.sourceLable.text = strSourceAndDate;
        marketCell.dateLabel.text=model.publish;
        marketCell.separatorHidden = YES;
        UIView *placeHolderViewLead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, marketCell.bounds.size.height)];
        UIView *placeHolderViewTrail = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 5, 0, 5, marketCell.bounds.size.height)];
        
        placeHolderViewLead.backgroundColor = RGBHex(qwColor11);
        placeHolderViewTrail.backgroundColor = RGBHex(qwColor11);
        marketCell.contentView.backgroundColor = [UIColor whiteColor];
        [marketCell.contentView addSubview:placeHolderViewLead];
        [marketCell.contentView addSubview:placeHolderViewTrail];
        return marketCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *placeHolderViewLead = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 5, cell.bounds.size.height)];
    UIView *placeHolderViewTrail = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 15, 0, 10, cell.bounds.size.height)];
    
    placeHolderViewLead.backgroundColor = [UIColor blueColor];
    placeHolderViewTrail.backgroundColor = [UIColor blueColor];
    [cell.contentView addSubview:placeHolderViewLead];
    [cell.contentView addSubview:placeHolderViewTrail];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.intMarketType == 0) {
        return 117.0f;
    } else if (self.intMarketType == 1) {
        return 94.0f;
    } else if (self.intMarketType == 2) {
        return 104.0f;
    } else {
        return 0;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (IBAction)actionDismissKeyboard:(id)sender {
    [self.tvMarketContent resignFirstResponder];
}
@end
