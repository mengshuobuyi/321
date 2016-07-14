//
//  IndexTopCollectionCell.h
//  wenYao-store
//
//  Created by YYX on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IndexTopCollectionCellDelegate <NSObject>

- (void)scanVerifyCodeAction;

- (void)uploadReceiptAction;

@end

@interface IndexTopCollectionCell : UICollectionViewCell

@property (assign, nonatomic) id<IndexTopCollectionCellDelegate>indexTopCollectionCellDelegate;

@property (weak, nonatomic) IBOutlet UIView *redDotOrder;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadLeftConstraint;


// 扫码验证
- (IBAction)scanVerifyAction:(id)sender;

// 上传小票
- (IBAction)uploadReceiptAction:(id)sender;

@end
