//
//  MemberMarketSuccessStepTwoView.m
//  wenYao-store
//
//  Created by PerryChen on 6/24/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberMarketSuccessStepTwoView.h"

@implementation MemberMarketSuccessStepTwoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)actionConfirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(actionConfirm)]) {
        [self.delegate actionConfirm];
    }
    [self removeFromSuperview];
}

- (void)setViewContent:(NSString *)str
{
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:str];
    UIFont *font = [UIFont systemFontOfSize:kFontS4];
    
    [strAttr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, strAttr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:10.0f];
    [strAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttr.length)];
    self.lblMarketTipContent.attributedText = strAttr;
    self.lblMarketTipContent.textColor = RGBHex(qwColor7);
    [self.viewSuccessContent layoutIfNeeded];
    [self.viewSuccessContent setNeedsLayout];
    self.viewSuccessContent.layer.cornerRadius = 4.0f;
}

@end
