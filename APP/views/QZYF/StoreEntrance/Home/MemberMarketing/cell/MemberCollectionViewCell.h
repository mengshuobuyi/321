//
//  MemberCollectionViewCell.h
//  wenYao-store
//
//  Created by PerryChen on 5/6/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMemberInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberCount;
@property (weak, nonatomic) IBOutlet UIView *viewBorder;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCheckMark;

@property (assign, nonatomic) BOOL showBorder;
@property (assign, nonatomic) BOOL isSelected;

- (void)setCellContent;

@end
