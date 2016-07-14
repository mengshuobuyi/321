//
//  LevelInfoTableViewCell.h
//  wenYao-store
//
//  Created by qw_imac on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ShowType) {
    ShowTypeTop,
    ShowTypeMid,
    ShowTypeBottom,
    ShowTypeOnlyOne,
};
@interface LevelInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
-(void)setCell:(NSString *)str With:(ShowType)type;
@end
