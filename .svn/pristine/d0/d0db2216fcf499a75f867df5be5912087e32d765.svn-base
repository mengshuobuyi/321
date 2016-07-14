//
//  EditInformationCell.h
//  wenyao-store
//
//  Created by qwfy0006 on 15/4/30.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol EditInformationCellDelegate <NSObject>

- (void)addImageAction:(NSInteger)indexPath;
- (void)deleteImageAction:(NSInteger)indexPath;
- (void)pushToNextDelegate:(id)sender;

@end

@interface EditInformationCell : QWBaseTableCell

@property (assign, nonatomic) id <EditInformationCellDelegate>delegaet;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *addImage;

@property (weak, nonatomic) IBOutlet UIImageView *deleteImage;

@property (weak, nonatomic) IBOutlet UIImageView *addTapBg;

@property (weak, nonatomic) IBOutlet UIImageView *deleteTapBg;

@property (weak, nonatomic) IBOutlet QWButton *pushButton;

- (IBAction)pushToNext:(id)sender;

@end
