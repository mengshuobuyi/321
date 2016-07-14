//
//  CreditEnhanceAlertView.m
//  wenYao-store
//
//  Created by carret on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CreditEnhanceAlertView.h"
#import "QWGlobalManager.h"
#import "IphoneAutoSizeHelper.h"

 const NSString *kCreditEnhanceInfoAlertType = @"kCreditEnhanceInfoAlertType";
 const NSString *kCreditEnhanceInfoName = @"kCreditEnhanceInfoName";
 const NSString *kCreditEnhanceInfoCredits = @"kCreditEnhanceInfoCredits";
 const NSString *kCreditEnhanceInfoCreditInc = @"kCreditEnhanceInfoCreditInc";
 const NSString *kCreditEnhanceInfoRankNum = @"kCreditEnhanceInfoRankNum";

@interface CreditEnhanceAlertHostView : UIView
@end

@implementation CreditEnhanceAlertHostView
@end

@interface CreditEnhanceAlertView ()

@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *bottomDailyView;
@property (weak, nonatomic) IBOutlet UIView *bottomOnceView;
@property (weak, nonatomic) IBOutlet UIButton *onceActionBtn;
@property (weak, nonatomic) IBOutlet UIButton *fillBtn;

@property (strong, nonatomic) CreditEnhanceAlertHostView *transfromHostView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greetingLabelLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkLabelTopMargin;

@end

@implementation CreditEnhanceAlertView

+ (instancetype)alertViewWithInfo:(NSDictionary *)infoDict
{
    CreditEnhanceAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"CreditEnhanceAlertView" owner:nil options:nil] lastObject];
    view.infoDict = infoDict;
    view.translatesAutoresizingMaskIntoConstraints = YES;
    CGFloat scale = QWAutoShrinkScale;
    view.bounds = CGRectMake(0, 0, 290 * scale,  430 * scale);
    [view configViewWithInfo:view.infoDict];
    return view;
}

- (void)awakeFromNib
{
    self.containerView.layer.cornerRadius = IS_IPHONE_6P ? 10.0f : 5.0f;
    self.containerView.layer.masksToBounds = YES;
    self.greetingLabel.font = self.detailLabel.font = fontSystem(QWAutoShrinkFontSize(QWFontS1));
    self.greetingLabel.textColor = self.detailLabel.textColor = self.creditsLabel.textColor = RGBHex(qwColor4);
    self.creditsLabel.font = fontSystem(QWAutoShrinkFontSize(QWFontS7));
    self.remarkLabel.font = fontSystem(QWAutoShrinkFontSize(QWFontS4));
    self.remarkLabel.textColor = RGBHex(qwColor6);
    self.actionBtn.titleLabel.font = fontSystem(QWAutoShrinkFontSize(QWFontS3));
    [self.actionBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    [self.actionBtn addTarget:self action:@selector(actionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.onceActionBtn.titleLabel.font = fontSystem(QWAutoShrinkFontSize(QWFontS3));
    [self.onceActionBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    [self.onceActionBtn addTarget:self action:@selector(actionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.fillBtn.titleLabel.font = fontSystem(QWAutoShrinkFontSize(QWFontS3));
    [self.fillBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    [self.fillBtn addTarget:self action:@selector(fillBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    
    self.topBgImageView.image = [self tilableImageNamed:@"my_integral_bg"];
    self.topBgImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.actionBtn setBackgroundImage:[self strechableImageNamed:@"btn_normal_one"] forState:UIControlStateNormal];
    [self.actionBtn setBackgroundImage:[self strechableImageNamed:@"btn_pressed_one"] forState:UIControlStateHighlighted];
    [self insertSubview:self.closeBtn aboveSubview:self.containerView];
    
    if (IS_IPHONE_4_OR_LESS) {
        self.greetingLabelLeftMargin.constant =  20.f;
        [self.detailLabel setContentCompressionResistancePriority:950 forAxis:UILayoutConstraintAxisHorizontal];
        [self.remarkLabel setContentCompressionResistancePriority:950 forAxis:UILayoutConstraintAxisHorizontal];
        self.remarkLabelTopMargin.constant = 15.f;
    }
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[self keyWindow].bounds];
        _bgView.backgroundColor = [UIColor blackColor];
    }
    return _bgView;
}

- (CreditEnhanceAlertHostView *)transfromHostView
{
    if (!_transfromHostView) {
        _transfromHostView = [[CreditEnhanceAlertHostView alloc] initWithFrame:self.bounds];
        _transfromHostView.backgroundColor = [UIColor clearColor];
    }
    return _transfromHostView;
}

- (void)configViewWithInfo:(NSDictionary *)infoDict
{
    int type = [infoDict[kCreditEnhanceInfoAlertType] intValue];
    NSString *name = infoDict[kCreditEnhanceInfoName];
    NSString *credits = infoDict[kCreditEnhanceInfoCredits];
    self.greetingLabel.text = [NSString stringWithFormat:@"亲爱的%@:", name];
    self.creditsLabel.text = credits;
    switch (type) {
        case CreditEnhanceAlertViewTypeOnce:
        {
            if (AUTHORITY_ROOT) {
                self.bottomOnceView.hidden = NO;
                self.bottomDailyView.hidden = YES;
            }else {
                self.bottomOnceView.hidden = YES;
                self.bottomDailyView.hidden = NO;
            }
            self.detailLabel.text = @"初次见面，我们赠送积分给您";
            self.remarkLabel.text = @"您还可通过日常任务来赚取积分，还有更多惊喜等您来发现哦!";
            [self.actionBtn setTitle:@"如何赚取积分" forState:UIControlStateNormal];
            break;
        }
        case CreditEnhanceAlertViewTypeDailyHappy:
        {
            self.bottomOnceView.hidden = YES;
            self.bottomDailyView.hidden = NO;
            NSString *creditInc = infoDict[kCreditEnhanceInfoCreditInc];
            NSString *rankNum = infoDict[kCreditEnhanceInfoRankNum];
            self.remarkLabel.text = [NSString stringWithFormat:@"您昨天共获得%@积分,非常出色！\n当前排名第%@名", creditInc, rankNum];
            self.detailLabel.text = @"您的当前积分";
            [self.actionBtn setTitle:@"继续加油" forState:UIControlStateNormal];
            break;
        }
        case CreditEnhanceAlertViewTypeDailySad:
        {
            self.bottomOnceView.hidden = YES;
            self.bottomDailyView.hidden = NO;
            NSString *creditInc = infoDict[kCreditEnhanceInfoCreditInc];
            NSString *rankNum = infoDict[kCreditEnhanceInfoRankNum];
            self.remarkLabel.text = [NSString stringWithFormat:@"太悲伤了！您昨天才获得%@积分\n当前排名第%@名", creditInc, rankNum];
            self.detailLabel.text = @"您的当前积分";
            [self.actionBtn setTitle:@"力争上游吧" forState:UIControlStateNormal];
            break;
        }
        default:
            DebugLog(@"[%@ %s]:alertType invalid", NSStringFromClass([self class]), __func__);
            break;
    }
}

#pragma mark - Interaction method

- (void)actionBtnClicked
{
    if (self.actionBtnClickBlock) {
        self.actionBtnClickBlock();
    }
    
    int type = [self.infoDict[kCreditEnhanceInfoAlertType] intValue];
    if (type == CreditEnhanceAlertViewTypeOnce) {
        [QWGLOBALMANAGER statisticsEventId:@"s_scdl_zqjf" withLable:@"积分强化" withParams:nil];
    } else {
        [QWGLOBALMANAGER statisticsEventId:@"s_rcjf_jx" withLable:@"积分强化" withParams:nil];
    }
}

-(void)fillBtnClicked {
    if (self.fillStoreInfoBlock) {
        self.fillStoreInfoBlock();
    }
}

- (void)closeBtnClicked
{
    [self dismiss];
    int type = [self.infoDict[kCreditEnhanceInfoAlertType] intValue];
    if (type == CreditEnhanceAlertViewTypeOnce) {
        [QWGLOBALMANAGER statisticsEventId:@"s_scdl_gb" withLable:@"积分强化" withParams:nil];
    } else{
        [QWGLOBALMANAGER statisticsEventId:@"s_rcjf_gb" withLable:@"积分强化" withParams:nil];
    }
}

// REMARK:外部检查弹窗冲突
- (void)show
{
    [self showIn:[self keyWindow]];
}

- (void)showIn:(UIView *)view
{
    int type = [self.infoDict[kCreditEnhanceInfoAlertType] intValue];
    if (type == CreditEnhanceAlertViewTypeOnce) {
        [QWGLOBALMANAGER statisticsEventId:@"s_scdl_cx" withLable:@"积分强化" withParams:nil];
    } else {
        [QWGLOBALMANAGER statisticsEventId:@"s_rcjf_cx" withLable:@"积分强化" withParams:nil];
    }

    self.bgView.alpha = 0;
    [view insertSubview:self.bgView aboveSubview:view.subviews.lastObject];
    UIView *hostView = self.transfromHostView;
    [view insertSubview:hostView aboveSubview:self.bgView];
    hostView.center =  CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    hostView.translatesAutoresizingMaskIntoConstraints = NO;
    hostView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[hostView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hostView)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[hostView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hostView)]];
    self.autoresizingMask= UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.frame = hostView.bounds;
    [hostView addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0.7;         hostView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            hostView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                hostView.transform = CGAffineTransformIdentity;
                [self layoutIfNeeded];
            }];
        }];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.transfromHostView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.transfromHostView removeFromSuperview];
        [QWGLOBALMANAGER postNotif:NotiTaskViewDismissed data:nil
                            object:nil];
        if(self.dismissBlock) self.dismissBlock();
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(CGRectInset(self.bounds, 0, -43), point);
}

#pragma mark - Assist method

- (UIImage *)strechableImageNamed:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)];
}

- (UIImage *)tilableImageNamed:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    return [img  resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, 0, img.size.height/2 - 1, 0) resizingMode:UIImageResizingModeTile];

}

- (UIView *)keyWindow
{
    return self.window ? self.window : [UIApplication sharedApplication].keyWindow;
}
@end
