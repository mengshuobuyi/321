//
//  EditPostTextViewTableCell.h
//  APP
//
//  Created by Martin.Liu on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTextView.h"
#import "SendPostViewController.h"
#import "MAButtonWithTouchBlock.h"
typedef void(^EditPostTextViewChangeHeihtBlock)();
@interface EditPostTextViewTableCell : UITableViewCell
@property (nonatomic, copy) EditPostTextViewChangeHeihtBlock changeHeightBlock;
@property (strong, nonatomic) IBOutlet TKTextView *textView;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *closeBtn;

@property (nonatomic, strong) NSIndexPath* indexPath;

- (void)setCell:(id)obj;
@end
