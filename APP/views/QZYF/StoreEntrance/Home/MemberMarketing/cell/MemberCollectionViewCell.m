//
//  MemberCollectionViewCell.m
//  wenYao-store
//
//  Created by PerryChen on 5/6/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberCollectionViewCell.h"

@implementation MemberCollectionViewCell
- (void)setCellContent
{
    if (IS_IPHONE_6P) {
//        self.lblMemberInfo.font = fontSystem(kFontS1+5);
//        self.lblMemberCount.font = fontSystem(kFontS5+5);
    }
    self.imgViewCheckMark.hidden = YES;
    if (self.showBorder) {
        self.viewBorder.layer.borderColor = RGBHex(qwColor10).CGColor;
        self.viewBorder.layer.borderWidth = 0.5;
        self.viewBorder.layer.cornerRadius = 2.0f;
        self.viewBorder.layer.masksToBounds = YES;
        if (self.isSelected) {
            self.viewBorder.layer.borderColor = RGBHex(qwColor2).CGColor;
            self.imgViewCheckMark.hidden = NO;
        }
    }
}
@end
