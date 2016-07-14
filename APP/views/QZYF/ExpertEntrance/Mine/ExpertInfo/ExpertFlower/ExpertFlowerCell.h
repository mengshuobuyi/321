//
//  ExpertFlowerCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "MGSwipeTableCell.h"
#import "QWView.h"
#import "QWButton.h"

@protocol ExpertFlowerCellDelegate <NSObject>

- (void)lookFlowerInfo:(NSIndexPath *)indexPath;

@end

@interface ExpertFlowerCell : MGSwipeTableCell

@property (assign, nonatomic) id <ExpertFlowerCellDelegate> expertFlowerCellDelegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *flowerNum;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *lookLabel;

@property (weak, nonatomic) IBOutlet UILabel *topicTitle;

@property (weak, nonatomic) IBOutlet QWView *topicBgView;

@property (weak, nonatomic) IBOutlet QWButton *lookButton;

- (IBAction)lookAction:(id)sender;

@end
