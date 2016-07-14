//
//  IndexAuthCollectionCell.h
//  wenYao-store
//
//  Created by YYX on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IndexAuthCollectionCellDelegate <NSObject>

- (void)goToAuthAction;

@end

@interface IndexAuthCollectionCell : UICollectionViewCell

@property (assign, nonatomic) id <IndexAuthCollectionCellDelegate> indexAuthCollectionCellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UIButton *authButton;

// 立即认证
- (IBAction)authAction:(id)sender;


@end
