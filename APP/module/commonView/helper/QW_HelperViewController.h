//
//  QW_HelperViewController.h
//  APP
//
//  Created by carret on 15/2/12.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QW_HelperViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabled;
@property (weak, nonatomic) IBOutlet UITableViewCell *setCell;
@property (weak, nonatomic) IBOutlet UISwitch *offOrOn;
-(IBAction)setLOG:(id)sender;
@end
