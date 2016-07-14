//
//  MsgBoxCellModel.h
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BasePrivateModel.h"
#import "MsgBox.h"

typedef NS_ENUM(NSUInteger, MsgBoxCellDestVCType) {
    MsgBoxCellDestVCTypeStoryboard,
    MsgBoxCellDestVCTypeXib,
    MsgBoxCellDestVCTypeAlloc
};

@interface MsgBoxCellModel : BasePrivateModel

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *hintText;
@property (nonatomic, assign) MsgBoxMessageType type;
@property (nonatomic, assign) BOOL redPointHidden;
@property (nonatomic, copy) void (^actionBlock)();

@end
