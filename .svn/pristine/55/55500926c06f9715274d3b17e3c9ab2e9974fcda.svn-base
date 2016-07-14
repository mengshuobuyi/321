//
//  IphoneAutoSizeHelper.h
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/19.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "css.h"
#import "Constant.h"

// project convention

#define QWFontS1    kFontS1
#define QWFontS2    kFontS2
#define QWFontS3    kFontS3
#define QWFontS4    kFontS4
#define QWFontS5    kFontS5
#define QWFontS6    kFontS6
#define QWFontS7    kFontS7
#define QWFontS8    kFontS8
#define QWFontS9    kFontS9
#define QWFontS10   kFontS10
#define QWFontS11   kFontS11
#define QWFontS12   kFontS12
#define QWFontS13   33
#define QWFontS14   31
#define QWFontS15   23
#define QWFontS16   21
#define QWFontS17   126
#define QWFontS18   52
#define QWFontS19   39
#define QWFontS20   25

#define QWFontS1_6P 29
#define QWFontS2_6P QWFontS13
#define QWFontS3_6P QWFontS14
#define QWFontS4_6P 27
#define QWFontS5_6P QWFontS15
#define QWFontS6_6P QWFontS16
#define QWFontS7_6P QWFontS17
#define QWFontS8_6P QWFontS18
#define QWFontS9_6P 18
#define QWFontS10_6P QWFontS19
#define QWFontS11_6P QWFontS20

#define QWAutoFontS1 (IS_IPHONE_6P ? QWFontS1_6P : QWFontS1)
#define QWAutoFontS2 (IS_IPHONE_6P ? QWFontS2_6P : QWFontS2)
#define QWAutoFontS3 (IS_IPHONE_6P ? QWFontS3_6P : QWFontS3)
#define QWAutoFontS4 (IS_IPHONE_6P ? QWFontS4_6P : QWFontS4)
#define QWAutoFontS5 (IS_IPHONE_6P ? QWFontS5_6P : QWFontS5)
#define QWAutoFontS6 (IS_IPHONE_6P ? QWFontS6_6P : QWFontS6)
#define QWAutoFontS7 (IS_IPHONE_6P ? QWFontS7_6P : QWFontS7)
#define QWAutoFontS8 (IS_IPHONE_6P ? QWFontS8_6P : QWFontS8)
#define QWAutoFontS9 (IS_IPHONE_6P ? QWFontS9_6P : QWFontS9)
#define QWAutoFontS10 (IS_IPHONE_6P ? QWFontS10_6P :QWFontS10)
#define QWAutoFontS11 (IS_IPHONE_6P ? QWFontS11_6P :QWFontS11)



#define QWAutoShrinkFontSize(pointSize) (IS_IPHONE_6P ? pointSize*1.1 : pointSize)

#define QWAutolayoutValue(vN,vP) (IS_IPHONE_6P ? vP : vN)

#define QWAutoShrinkScale (IS_IPHONE_6P ? 1.2 : (IS_IPHONE_4_OR_LESS ? 0.8 : 1))

#define IS_IPAD_DEVICE      ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"])

extern BOOL IphoneAutoSizeHelper_isIPhone4OrLess;
extern BOOL IphoneAutoSizeHelper_isIPhone5;
extern BOOL IphoneAutoSizeHelper_isIPhone6;
extern BOOL IphoneAutoSizeHelper_isIPhone6p;

// may try font lib

@interface IphoneAutoSizeHelper : NSObject

@end

