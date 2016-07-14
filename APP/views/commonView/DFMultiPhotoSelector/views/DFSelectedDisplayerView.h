//
//  DFSelectedDisplayerView.h
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

//#import "DFBaseView.h"
#import "DFSelectorBar.h"
#import "DFSelectorNavBar.h"

@interface DFSelectedDisplayerView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DFSelectorBar *selectorBar;
@property (nonatomic, strong) DFSelectorNavBar *selectorNavBar;
@property (nonatomic, assign, getter = isBarHidden) BOOL barHidden;
@property (nonatomic, weak) id delegate;
@end
