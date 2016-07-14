//
//  MemberSelectReusableView.m
//  wenYao-store
//
//  Created by PerryChen on 5/9/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberSelectReusableView.h"

@implementation MemberSelectReusableView

- (IBAction)allGenderAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(chooseGender:)]) {
        [self.delegate chooseGender:1];
    }
}

- (IBAction)maleSelectAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(chooseGender:)]) {
        [self.delegate chooseGender:2];
    }
}

- (IBAction)femaleSelectAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(chooseGender:)]) {
        [self.delegate chooseGender:3];
    }
}

- (IBAction)selectOrderNumAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(chooseOrderNum)]) {
        [self.delegate chooseOrderNum];
    }
}
@end
