//
//  NotifyMsgDetailViewController.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NotifyMsgDetailViewController.h"

@interface NotifyMsgDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation NotifyMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    self.titleLabel.font = fontSystem(kFontS3);
    self.titleLabel.textColor = RGBHex(qwColor6);
    self.timeLabel.font = fontSystem(kFontS5);
    self.timeLabel.textColor = RGBHex(qwColor8);
    self.contentLabel.font = fontSystem(kFontS4);
    self.contentLabel.textColor = RGBHex(qwColor7);
     
    self.titleLabel.text = self.msgModel.title;
    self.contentLabel.text = self.msgModel.content;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm";
    NSString *timeStamp = [self.msgModel.createTime substringToIndex:10];
    self.timeLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue]];
}

@end
