//
//  AnswerTableViewCell.h
//  wenYao-store
//
//  Created by 李坚 on 15/7/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseCell.h"
#import "MKNumberBadgeView.h"
#import "MGSwipeTableCell.h"
#import "QWMessage.h"
@interface AnswerTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) IBOutlet MKNumberBadgeView     *vBadge;
@property (nonatomic, strong) IBOutlet QWImageView      *customerAvatarUrl;
@property (nonatomic, strong) IBOutlet QWLabel          *phoneNum;
@property (nonatomic, strong) IBOutlet QWLabel          *consultCreateTime;
@property (nonatomic, strong) IBOutlet QWLabel          *consultTitle;
@property (nonatomic, strong) IBOutlet UIImageView      *failureStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingActivity;

- (void)setCell:(id)data msg:(QWMessage*)msg;
@end
