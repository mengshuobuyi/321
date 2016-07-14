//
//  ExpandAnimateButton.m
//  DeformationButton
//
//  Created by garfield on 15/7/7.
//  Copyright (c) 2015年 MOZ. All rights reserved.
//

#import "ExpandAnimateButton.h"

#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface ExpandAnimateButton ()

@property (nonatomic, weak) IBOutlet   UILabel      *contentLabel;
@property (nonatomic, weak) IBOutlet    UIImageView  *arrowImage;
@property (nonatomic, strong)  NSLayoutConstraint       *xConstraint;

@end

@implementation ExpandAnimateButton






- (void)awakeFromNib
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 16;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBHex(0xefd8ac).CGColor;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _expanding = NO;
}

- (void)setHintText:(NSString *)text
{
    if(!text || [text isEqualToString:@""]) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    [self.contentLabel setText:text];
    [self.contentLabel sizeToFit];

    [self.contentLabel setNeedsLayout];
    [self.contentLabel layoutIfNeeded];
}


- (void)expand
{
    self.userInteractionEnabled = NO;
    if(iOSLowV7) {
        NSLog(@"%f",iOS_V);
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.2f options:0 animations:^{
        if(iOSLowV7) {
            CGRect rect = self.frame;
            rect.origin.x = APP_W - self.frame.size.width + 12;
            self.frame = rect;
            
        }else{
            _xConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:APP_W - self.frame.size.width + 12];
            _xConstraint.priority = 1000;
            [self.superview addConstraint:_xConstraint];
            [self.superview layoutIfNeeded];
            
        }
        _arrowImage.transform = CGAffineTransformMakeRotation(- 3.14 );
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        _expanding = YES;
    }];
}

- (void)close
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.2f options:0 animations:^{
        if(iOSLowV7) {
            CGRect rect = self.frame;
            rect.origin.x = APP_W - 50;
            self.frame = rect;
        }else{
            [self.superview removeConstraint:_xConstraint];
            [self.superview layoutIfNeeded];
        }
        _arrowImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        _expanding = NO;
        if(iOSLowV7) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
        }
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_expanding) {
        //收缩回去
        [self close];
    }else{
        //展开显示更多
        [self expand];
    }
}







@end
