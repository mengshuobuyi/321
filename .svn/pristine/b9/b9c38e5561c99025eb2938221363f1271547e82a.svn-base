//
//  MARStatisticsDateView.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MARStatisticsDateView.h"
#import "MARDateTextField.h"
#import "NSDate+TKCategory.h"
@interface MARStatisticsDateView()<UITextFieldDelegate>
@property (nonatomic, strong) UIView* topContainerView;
@property (nonatomic, strong) UIView* middleContainerView;
@property (nonatomic, strong) UIView* bottomContainerView;

@property (nonatomic, strong) UILabel* topTipLabel;             // 请选择起始日期查询 标签
@property (nonatomic, strong) UILabel* topTIpLabel2;            // (时间区间不能超过30天) 标签
@property (nonatomic, strong) MARDateTextField* startDateTF;    // 起始时间控件
@property (nonatomic, strong) MARDateTextField* endDateTF;      // 结束时间控件
@property (nonatomic, strong) UIButton* queryBtn;               // 查询按钮
@end
@implementation MARStatisticsDateView
{
    BOOL hasSetup;
}
@synthesize topTipString = _topTipString;
- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        [self setup];
//    }
//    return self;
//}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setTopTipString:(NSString *)topTipString
{
    _topTipString = topTipString;
    self.topTipLabel.text = _topTipString;
}

- (UILabel *)topTipLabel
{
    if (!_topTipLabel) {
        _topTipLabel = [[UILabel alloc] init];
        _topTipLabel.font = [UIFont systemFontOfSize:kFontS4];
        _topTipLabel.textColor = RGBHex(qwColor6);
        _topTipLabel.text = self.topTipString;
    }
    return _topTipLabel;
}

- (UILabel *)topTIpLabel2
{
    if (!_topTIpLabel2) {
        _topTIpLabel2 = [[UILabel alloc] init];
        _topTIpLabel2.font = [UIFont systemFontOfSize:kFontS5];
        _topTIpLabel2.textColor = RGBHex(qwColor8);
        _topTIpLabel2.text = _topTipString2;
    }
    return _topTIpLabel2;
}

- (MARDateTextField *)startDateTF
{
    if (!_startDateTF) {
        _startDateTF = [[MARDateTextField alloc] init];
        _startDateTF.date = [NSDate yesterday];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *minDate = [formatter dateFromString:@"2015-01-01"];
        _startDateTF.minimumDate = minDate;
        _startDateTF.maximumDate = [NSDate yesterday];
        _startDateTF.font = [UIFont systemFontOfSize:kFontS4];
        _startDateTF.textColor = RGBHex(qwColor6);
        _startDateTF.delegate = self;
    }
    return _startDateTF;
}

- (MARDateTextField *)endDateTF
{
    if (!_endDateTF) {
        _endDateTF = [[MARDateTextField alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *minDate = [formatter dateFromString:@"2015-01-01"];
        _endDateTF.minimumDate = minDate;
        _endDateTF.date = [NSDate yesterday];
        _endDateTF.maximumDate = [NSDate yesterday];
        _endDateTF.font = [UIFont systemFontOfSize:kFontS4];
        _endDateTF.textColor = RGBHex(qwColor6);
        _endDateTF.delegate = self;
    }
    return _endDateTF;
}

- (UIButton *)queryBtn
{
    if (!_queryBtn) {
        _queryBtn = [[UIButton alloc] init];
        [_queryBtn setTitle:@"查询" forState:UIControlStateNormal];
        [_queryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _queryBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS4];
        _queryBtn.backgroundColor = RGBHex(qwColor2);
        [_queryBtn addTarget:self action:@selector(clickQueryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _queryBtn.layer.masksToBounds = YES;
        _queryBtn.layer.cornerRadius = 4.0;
    }
    return _queryBtn;
}

- (void)clickQueryBtnAction:(id)sender
{
    NSLog(@"click the query button");
    if (self.delegate && [self.delegate respondsToSelector:@selector(marDateView:didClickQueryBtnStartDate:endDate:)]) {
        [self.delegate marDateView:self didClickQueryBtnStartDate:self.startDateTF.date endDate:self.endDateTF.date];
    }
}

- (UIView *)topContainerView
{
    if (!_topContainerView) {
        _topContainerView = [UIView new];
    }
    return _topContainerView;
}

- (UIView *)middleContainerView
{
    if (!_middleContainerView) {
        _middleContainerView = [UIView new];
    }
    return _middleContainerView;
}

- (UIView *)bottomContainerView
{
    if (!_bottomContainerView) {
        _bottomContainerView = [[UIView alloc] init];
    }
    return _bottomContainerView;
}

- (void)setup
{
    if (hasSetup) {
        return;
    }
    hasSetup = YES;
    // 初始化
    _topTipString = @"请选择起始日期查询";
    _topTipString2 = @"(时间区间不能超过30天)";
    
    // 上部视图
    [self addSubview:self.topContainerView];
    
    PREPCONSTRAINTS(self.topContainerView);
    ALIGN_TOP(self.topContainerView, 0);
    ALIGN_LEADING(self.topContainerView, 0);
    ALIGN_TRAILING(self.topContainerView, 0);
    CONSTRAIN_HEIGHT(self.topContainerView, 35);
    
    [self.topContainerView addSubview:self.topTipLabel];
    PREPCONSTRAINTS(self.topTipLabel);
    ALIGN_LEADING(self.topTipLabel, 12);
    CENTER_V(self.topTipLabel);
    
    [self.topContainerView addSubview:self.topTIpLabel2];
    PREPCONSTRAINTS(self.topTIpLabel2);
    LAYOUT_H(self.topTipLabel, 2, self.topTIpLabel2);
    
    [self addBottomHrlineInView:self.topContainerView];
    
    // 中间日期视图
    [self addSubview:self.middleContainerView];
    
    PREPCONSTRAINTS(self.middleContainerView);
    LAYOUT_V(self.topContainerView, 0, self.middleContainerView);
    ALIGN_LEADING(self.middleContainerView, 0);
    CONSTRAIN_HEIGHT(self.middleContainerView, 50);

    UIView* leftInMiddelView = [UIView view];
    [self.middleContainerView addSubview:leftInMiddelView];
    PREPCONSTRAINTS(leftInMiddelView);
    ALIGN_TOP(leftInMiddelView, 0);
    ALIGN_LEADING(leftInMiddelView, 0);
    ALIGN_BOTTOM(leftInMiddelView, 0);
    CONSTRAIN_WIDTH(leftInMiddelView, APP_W/2);
    
    [leftInMiddelView addSubview:self.startDateTF];
    PREPCONSTRAINTS(self.startDateTF);
    CENTER_H(self.startDateTF);
    ALIGN_TOP(self.startDateTF, 0);
    CONSTRAIN_MIN_WIDTH(self.startDateTF, 100, 888);
    ALIGN_BOTTOM(self.startDateTF, 0);
    if ([OS_VERSION floatValue] >= 8.0) {
        UIImageView* imageView1 = [[UIImageView alloc] init];
        imageView1.image = [UIImage imageNamed:@"icon_arrow"];
        [self.startDateTF addSubview:imageView1];
        PREPCONSTRAINTS(imageView1);
        CENTER_V(imageView1);
        ALIGN_TRAILING(imageView1, 0);
    }
    else
    {
        UIImageView* imageView1 = [[UIImageView alloc] init];
        imageView1.image = [UIImage imageNamed:@"icon_arrow"];
        [leftInMiddelView addSubview:imageView1];
        PREPCONSTRAINTS(imageView1);
        LAYOUT_H(self.startDateTF, -20, imageView1);
    }
    
    UIView* vrLine = [[UIView alloc] init];
    vrLine.backgroundColor = RGBHex(qwColor10);
    [leftInMiddelView addSubview:vrLine];
    PREPCONSTRAINTS(vrLine);
    ALIGN_TOP(vrLine, 8);
    CENTER_V(vrLine);
    ALIGN_TRAILING(vrLine, 0);
    CONSTRAIN_WIDTH(vrLine, 1.0/[UIScreen mainScreen].scale);
    
    UIView* rightInMiddelViewView = [[UIView alloc] init];
    [self.middleContainerView addSubview:rightInMiddelViewView];
    PREPCONSTRAINTS(rightInMiddelViewView);
    ALIGN_TOP(rightInMiddelViewView, 0);
    ALIGN_TRAILING(rightInMiddelViewView, 0);
    ALIGN_BOTTOM(rightInMiddelViewView, 0);
    CONSTRAIN_WIDTH(rightInMiddelViewView, APP_W/2);
    
    [rightInMiddelViewView addSubview:self.endDateTF];
    PREPCONSTRAINTS(self.endDateTF);
    CENTER_H(self.endDateTF);
    ALIGN_TOP(self.endDateTF, 0);
    CONSTRAIN_MIN_WIDTH(self.endDateTF, 100, 888);
    ALIGN_BOTTOM(self.endDateTF, 0);
    if ([OS_VERSION floatValue] >= 8.0) {
        UIImageView* imageView2 = [[UIImageView alloc] init];
        imageView2.image = [UIImage imageNamed:@"icon_arrow"];
        [self.endDateTF addSubview:imageView2];
        PREPCONSTRAINTS(imageView2);
        CENTER_V(imageView2);
        ALIGN_TRAILING(imageView2, 0);
    }
    else
    {
        UIImageView* imageView2 = [[UIImageView alloc] init];
        imageView2.image = [UIImage imageNamed:@"icon_arrow"];
        [rightInMiddelViewView addSubview:imageView2];
        PREPCONSTRAINTS(imageView2);
        LAYOUT_H(self.endDateTF, -20, imageView2);

    }
    
    // 底部视图
    [self addSubview:self.bottomContainerView];
    
    PREPCONSTRAINTS(self.bottomContainerView);
    LAYOUT_V(self.middleContainerView, 0, self.bottomContainerView);
    ALIGN_LEADING(self.bottomContainerView, 0);
    [CONSTRAINT_SETTING_HEIGHT(self.bottomContainerView, 50) install:999];
    ALIGN_BOTTOM(self.bottomContainerView, 0);
    
    [self addBottomHrlineInView:self.middleContainerView];
    
    [self.bottomContainerView addSubview:self.queryBtn];
    PREPCONSTRAINTS(self.queryBtn);
    CENTER(self.queryBtn);
    CONSTRAIN_SIZE(self.queryBtn, 160, 35);
}

// 在视图下增加一条下划线
- (void)addBottomHrlineInView:(UIView*)inView
{
    if (inView) {
        // 增加一个下划线
        UIView* hrline = [[UIView alloc] init];
        hrline.backgroundColor = RGBHex(qwColor10);
        [inView addSubview:hrline];
        PREPCONSTRAINTS(hrline);
        ALIGN_BOTTOM(hrline, 0);
        ALIGN_LEADING(hrline, 10);
        ALIGN_TRAILING(hrline, 10);
        CONSTRAIN_HEIGHT(hrline, 1.0/[UIScreen mainScreen].scale);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSDate *)startDate
{
    return self.startDateTF.date;
}

- (NSDate *)endDate
{
    return self.endDateTF.date;
}

- (NSString *)startDateString
{
    return self.startDateTF.text;
}

- (NSString *)endDateString
{
    return self.endDateTF.text;
}

#pragma UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(marDateViewBecomResponder:)]) {
        [self.delegate marDateViewBecomResponder:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(marDateViewResignResponder:)]) {
        [self.delegate marDateViewResignResponder:self];
    }
}

@end
