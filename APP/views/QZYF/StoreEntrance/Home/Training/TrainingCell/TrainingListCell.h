//
//  TrainingListCell.h
//  wenYao-store
//
//  Created by PerryChen on 5/4/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"
#import "TagListView.h"

@interface TrainingListCell : QWBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewTop;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewTag;
@property (weak, nonatomic) IBOutlet TagListView *viewTagList;
@property (weak, nonatomic) IBOutlet UILabel *lblAwardContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgQuestionnaIRE;

@end
