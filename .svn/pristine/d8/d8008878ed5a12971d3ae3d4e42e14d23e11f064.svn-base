//
//  CustomPopListView.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/18.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "CustomPopListView.h"
#import "AppDelegate.h"
//#import "Constant.h"
#import "CustomPopListCell.h"

#define  BOUNDS [[UIScreen mainScreen] bounds]

@interface CustomPopListView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CustomPopListView

+ (CustomPopListView *)sharedManagerWithtitleList:(NSArray *)titles
{
    return [[self alloc] initWithtitle:titles];
}

- (id)initWithtitle:(NSArray *)titles
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomPopListView" owner:nil options:nil];
        self = array[0];
        self.titleArray = (NSMutableArray *)[NSArray arrayWithArray:titles];
        [self setUpTableView];
    }
    return self;
}

- (void)show
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.frame = CGRectMake(0, 0, BOUNDS.size.width, BOUNDS.size.height);
    [UIView animateWithDuration:0.8 animations:^{
        [app.window addSubview:self];
    }];
    self.bgView.frame = self.frame;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self.bgView addGestureRecognizer:tap];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    right.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.bgView addGestureRecognizer:right];

    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft; //默认向右
    [self.bgView addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    up.direction = UISwipeGestureRecognizerDirectionUp; //默认向上
    [self.bgView addGestureRecognizer:up];
    
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    down.direction = UISwipeGestureRecognizerDirectionDown; //默认向下
    [self.bgView addGestureRecognizer:down];
}

-(void)swipeGesture:(id)sender
{
    
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self dismissSelf];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self dismissSelf];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self dismissSelf];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self dismissSelf];
    }
}

- (void)dismissSelf
{
    [self hide];
}

- (void)hide
{
    [UIView animateWithDuration:0.8 animations:^{
        self.delegate = nil;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

#pragma mark ---- 设置列表 ----
- (void)setUpTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(APP_W-109, 64, 108, 30*self.titleArray.count) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    self.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = RGBHex(qwColor4);
    self.tableView.scrollEnabled = NO;
    [self.tableView reloadData];
}

#pragma mark ---- 列表代理 ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomPopListCellIdentifier = @"CustomPopListCell";
    CustomPopListCell *cell = (CustomPopListCell *)[tableView dequeueReusableCellWithIdentifier:CustomPopListCellIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"CustomPopListCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomPopListCellIdentifier];
        cell = (CustomPopListCell *)[tableView dequeueReusableCellWithIdentifier:CustomPopListCellIdentifier];
    }
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(customPopListView:didSelectedIndex:)]) {
        [self.delegate customPopListView:self didSelectedIndex:indexPath];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
