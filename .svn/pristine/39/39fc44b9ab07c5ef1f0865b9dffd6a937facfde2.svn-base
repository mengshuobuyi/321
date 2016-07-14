//
//  UILabel+MAAttributeString.m
//  tcmerchant
//
//  Created by Martin.Liu on 15/5/25.
//  Copyright (c) 2015年 TC. All rights reserved.
//

#import "UILabel+MAAttributeString.h"

@implementation UILabel (MAAttributeString)
- (void)ma_setAttributeText:(NSString*)string
{
    if (StrIsEmpty(string)) {
        string = @"";
    }
    NSMutableAttributedString* attributeString = [self.attributedText mutableCopy];
    [attributeString replaceCharactersInRange:NSMakeRange(0, attributeString.length) withString:string];
    self.attributedText = attributeString;
}

- (void)ma_setAttributeText:(NSString*)string attributes:(NSDictionary*)attrs
{
    if (StrIsEmpty(string)) {
        string = @"";
    }
    if (!attrs) {
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        attrs = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, self.textColor, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];

    }
    self.attributedText = [[NSAttributedString alloc] initWithString:string attributes:attrs];
}

@end
