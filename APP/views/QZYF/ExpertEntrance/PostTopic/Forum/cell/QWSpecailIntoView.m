//
//  QWSpecailIntoView.m
//  APP
//
//  Created by Martin.Liu on 16/3/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWSpecailIntoView.h"
#import "ConstraintsUtility.h"

@interface QWSpecailIntoView()
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* detailLabel;
@property (nonatomic, strong) NSDictionary* detailAttributeDic;
@end

@implementation QWSpecailIntoView

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title detail:(NSString *)detail
{
    if (self = [super init]) {
        self.imageName = imageName;
        self.title = title;
        self.detail = detail;
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = RGBHex(qwColor11);
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    
    PREPCONSTRAINTS(self.imageView);
    PREPCONSTRAINTS(self.titleLabel);
    PREPCONSTRAINTS(self.detailLabel);
    
    CENTER_H(self.imageView);
    ALIGN_TOP(self.imageView, 25);
    CONSTRAIN_SIZE(self.imageView, 120, 120);
    
    LAYOUT_V(self.imageView, 8, self.titleLabel);
    [[NSLayoutConstraint constraintWithItem:self.titleLabel attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute: NSLayoutAttributeLeading multiplier:1.0f constant:15] install:1000];
    
    LAYOUT_V(self.titleLabel, 40, self.detailLabel);
    [[NSLayoutConstraint constraintWithItem:self.detailLabel attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute: NSLayoutAttributeLeading multiplier:1.0f constant:15] install:1000];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:kFontS3];
        _titleLabel.textColor = RGBHex(qwColor7);
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (NSDictionary *)detailAttributeDic
{
    if (!_detailAttributeDic) {
        
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 8;
        _detailAttributeDic = @{NSForegroundColorAttributeName:RGBHex(qwColor7),
                                NSFontAttributeName:[UIFont systemFontOfSize:kFontS4],
                                NSParagraphStyleAttributeName:style};
    }
    return _detailAttributeDic;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    self.imageView.image = [UIImage imageNamed:_imageName];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleLabel.text = _title;
}

- (void)setDetail:(NSString *)detail
{
    _detail = [detail copy];
    self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:_detail attributes:self.detailAttributeDic];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
