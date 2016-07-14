//
//  CloseMedicineTableViewCell.h
//  wenYao-store
//
//  Created by garfield on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseCell.h"
#import "MKNumberBadgeView.h"
#import "XHMessage.h"
#import "MGSwipeTableCell.h"
#import "QWMessage.h"
@interface CloseMedicineTableViewCell : MGSwipeTableCell
{
    IBOutlet UIView *vContent;
}
@property (nonatomic, strong) IBOutlet MKNumberBadgeView     *vBadge;
@property (nonatomic, strong) IBOutlet QWImageView      *customerAvatarUrl;
@property (nonatomic, strong) IBOutlet QWLabel          *phoneNum;
@property (nonatomic, strong) IBOutlet QWLabel          *consultCreateTime;
@property (nonatomic, strong) IBOutlet QWLabel          *customerDistance;
@property (nonatomic, strong) IBOutlet QWLabel          *consultTitle;
@property (nonatomic, strong) IBOutlet QWLabel          *closeStatus;
@property (nonatomic, strong) IBOutlet UIImageView      *failureStatus;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView      *sendingActivity;
//@property (weak, nonatomic) IBOutlet   QWImageView        *iconRed;

- (void)setCell:(id)data status:(int)status body:(NSString*)body;

@end
