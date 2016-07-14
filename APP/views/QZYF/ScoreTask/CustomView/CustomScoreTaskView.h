//
//  CustomScoreTaskView.h
//  wenYao-store
//
//  Created by PerryChen on 6/15/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskScoreModel.h"

@interface CustomScoreTaskView : UIView
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, copy) void(^ blockConfirm)(NSString *tapKey);
@property (nonatomic, copy) void(^ blockCancel)();
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;

@property (nonatomic, strong) TaskScoreModel *modelScore;
@end
