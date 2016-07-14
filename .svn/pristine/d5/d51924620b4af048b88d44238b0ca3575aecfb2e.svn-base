//
//  InterlocutionTableViewCell.h
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterlocutionTableViewCellDelegate <NSObject>

@required
- (void)ignoreMessageAtIndexPath:(NSIndexPath *)indexPath;
- (void)answerMessageAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface InterlocutionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *ignoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;

@property (assign, nonatomic) id<InterlocutionTableViewCellDelegate> btnDelegate;

@property (strong, nonatomic) NSIndexPath *path;

+ (CGFloat)getCellHeight:(id)sender;

@end
