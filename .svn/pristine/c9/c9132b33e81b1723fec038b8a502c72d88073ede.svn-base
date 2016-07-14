//
//  DFMultiPhotoSelectorIOS5View.m
//  DFace
//
//  Created by kabda on 8/4/14.
//
//

#import "DFMultiPhotoSelectorIOS5View.h"

@implementation DFMultiPhotoSelectorIOS5View

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        _selectorBar = [[DFSelectorBar alloc]initWithFrame:CGRectZero];
        [self addSubview:_selectorBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.tableView.frame = bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 58.0, 0.0);
    self.selectorBar.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - 50.0, CGRectGetWidth(bounds), 50.0);
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.tableView.dataSource = _delegate;
    self.tableView.delegate = _delegate;
    self.selectorBar.delegate = _delegate;
}

@end
