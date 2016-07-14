//
//  EditPostImageTextTableCell.h
//  APP
//
//  Created by Martin.Liu on 16/1/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTextView.h"
#import "MAButtonWithTouchBlock.h"
typedef void(^EditPostImageTextViewChangeHeihtBlock)();
@interface EditPostImageTextTableCell : UITableViewCell
@property (nonatomic, copy) EditPostImageTextViewChangeHeihtBlock changeHeightBlock;
@property (strong, nonatomic) IBOutlet TKTextView *textView;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *closeBtn;

@property (nonatomic, strong) NSIndexPath* indexPath;

- (void)setCell:(id)obj;

@end
