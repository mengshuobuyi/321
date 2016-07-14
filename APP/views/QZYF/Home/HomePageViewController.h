//
//  HomePageViewController.h
//  wenYao-store
//
//  Created by garfield on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"


@interface HomePageViewController : QWBaseVC

@property (nonatomic, strong) IBOutlet  UITableView     *tableView;
//@property (nonatomic, strong) IBOutlet  UISegmentedControl     *segmentedControl;
@property (nonatomic, strong) NSString *roomID;

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)changeMessageType:(id)sender;
//隐藏解答中的未读数
- (void)dismissBadgeView;
//隐藏已关闭红点
- (void)dismissClosedHintImage;
//隐藏待抢答红点
- (void)dismissRacingHintImage;
//显示解答中的未读数
- (void)showBadgeValue:(NSUInteger)num;
//显示已关闭红点
- (void)showClosedHintImage;
//显示待抢答红点
- (void)showRacingHintImage;
//隐藏全维药师红点
- (void)dismissOfficialHintImage;
//显示全维药师红点
- (void)showOfficialHintImage;

- (void)checkAllHint;
- (BOOL)checkMaskHidden;
@end
