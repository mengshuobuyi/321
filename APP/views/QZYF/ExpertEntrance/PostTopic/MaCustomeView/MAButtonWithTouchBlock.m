//
//  MAButtonWithTouchBlock.m
//  APP
//
//  Created by Martin.Liu on 15/12/7.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "MAButtonWithTouchBlock.h"
@interface MAButtonWithTouchBlock()
@property (nonatomic, strong) UILongPressGestureRecognizer* longPressGesture;
@end;

@implementation MAButtonWithTouchBlock

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void) setup
{
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addGestureRecognizer:self.longPressGesture];
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    }
    return _longPressGesture;
}

- (void)longPressEvent:(UILongPressGestureRecognizer*)longTapGesture
{
    if (longTapGesture.state == UIGestureRecognizerStateBegan) {
        if (self.longTouchUpInsideBlock) {
            self.longTouchUpInsideBlock();
        }
    }
}

- (void) touchUpInside:(id)sender
{
    if (self.touchUpInsideBlock) {
        self.touchUpInsideBlock();
    }
}

- (void)dealloc
{
    [self removeTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self removeGestureRecognizer:_longPressGesture];
    _longPressGesture = nil;
    self.touchUpInsideBlock = NULL;
    self.longTouchUpInsideBlock = NULL;
}
@end
