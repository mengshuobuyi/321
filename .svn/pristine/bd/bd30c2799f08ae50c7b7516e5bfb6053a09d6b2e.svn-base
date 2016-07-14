//
//  DFSelectedDisplayerView.m
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

#import "DFSelectedDisplayerView.h"
#import "Constant.h"
@interface DFSelectedDisplayerView ()

@end

@implementation DFSelectedDisplayerView

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
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.pagingEnabled = YES;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_tableView];
        
        _selectorNavBar = [[DFSelectorNavBar alloc]initWithFrame:CGRectZero];
        [self addSubview:_selectorNavBar];
        
        _selectorBar = [[DFSelectorBar alloc]initWithFrame:CGRectZero];
        //        _selectorBar.previewButton.hidden = YES;
        [self addSubview:_selectorBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    //    self.tableView.frame = bounds;
    self.selectorNavBar.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds)-44, CGRectGetWidth(bounds), 44.0);
    self.selectorNavBar.backgroundColor = RGBHex(0x222222);
    self.selectorBar.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds) - 50.0, CGRectGetWidth(bounds), 50.0);
    //    self.selectorBar.backgroundColor = [UIColor redColor];
    self.selectorBar.hidden = YES;
    
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.tableView.dataSource = _delegate;
    self.tableView.delegate = _delegate;
    self.selectorNavBar.delegate = _delegate;
    self.selectorBar.delegate = _delegate;
}

- (void)setBarHidden:(BOOL)barHidden
{
    //    _barHidden = barHidden;
    //    NSTimeInterval duration = 0.5;
    //    if (_barHidden) {
    //        [UIView animateWithDuration:duration animations:^{
    //            CGRect frame1 = self.selectorNavBar.frame;
    //            frame1.origin.y = -64.0;
    //            self.selectorNavBar.frame = frame1;
    //            CGRect frame2 = self.selectorBar.frame;
    //            frame2.origin.y = self.selectorBar.frame.origin.y + self.selectorBar.frame.size.height;
    //            self.selectorBar.frame = frame2;
    //        }completion:nil];
    //    } else {
    //        [UIView animateWithDuration:duration animations:^{
    //            CGRect frame1 = self.selectorNavBar.frame;
    //            frame1.origin.y = 0.0;
    //            self.selectorNavBar.frame = frame1;
    //            CGRect frame2 = self.selectorBar.frame;
    //            frame2.origin.y = self.selectorBar.frame.origin.y - self.selectorBar.frame.size.height;
    //            self.selectorBar.frame = frame2;
    //        }completion:nil];
    //    }
}
@end
