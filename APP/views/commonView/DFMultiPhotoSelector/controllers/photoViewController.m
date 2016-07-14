//
//  photoViewController.m
//  wenyao-store
//
//  Created by carret on 15/4/7.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "photoViewController.h"
#import "DFNavMenu.h"
#import "DFAssetsHelper.h"
#import "DFNavMenuButton.h"
#import "DFNavMenuCell.h"
#import "XHMessageTableViewController.h"
@interface photoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *menuItems ;
}
@end

@implementation photoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToChat)];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
    [self showMenus:nil];
    self.view = [self mkContentView];
    [self setupBackBarButtonItem];
    // Do any additional setup after loading the view from its nib.
}
-(void)backToChat
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        if ([temp isKindOfClass:[XHMessageTableViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
    
    
}
- (void)setupBackBarButtonItem
{
    
    self.backButtonEnabled = NO;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton =YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)naviBackBotton
{}

-(void)donoth
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showMenus:(UIButton *)sender
{
    //    photoViewController *vc  = [[photoViewController alloc]initWithNibName:@"photoViewController" bundle:nil];;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    NSInteger total = [AssetsHelper getGroupCount];
    menuItems = [NSMutableArray arrayWithCapacity:total];
    for (int i = 0; i < total; i++) {
        NSDictionary *infoDict = [AssetsHelper getGroupInfo:i];
        DFNavMenuItem *menuItem = [DFNavMenuItem menuItem:infoDict[@"name"]
                                                    image:infoDict[@"poster"]
                                                   target:_father
                                                   action:@selector(menuItemSelected:)];
        menuItem.tag = i;
        menuItem.count = [infoDict[@"count"] integerValue];
        menuItem.selected = (self.indexOfSelectedGroup == i);
        [menuItems addObject:menuItem];
    }
    
    
    //    CGRect windowRect =self.view.bounds;
    //    windowRect.origin.y -= 60.0;
    //    windowRect.size.height  -=60;
    //    [DFNavMenu showMenuInView:self.view
    //                     fromRect:windowRect
    //                    menuItems:menuItems
    //                       onShow:^(BOOL isShow) {
    //                           ((DFNavMenuButton *)self.navigationItem.titleView).active = YES;
    //                       }
    //                    orDismiss:^(BOOL isDismiss) {
    //                        ((DFNavMenuButton *)self.navigationItem.titleView).active = NO;
    //                    }];
}

- (UIView *)mkContentView
{
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    if (!menuItems.count) {
        return nil;
    }
    
    CGFloat rowHeight = 60.0;
    CGRect bounds = CGRectMake(0.0, 0.0, 280, rowHeight);
    UITableView *tableView = [[UITableView alloc]initWithFrame:bounds];
    tableView.autoresizingMask = UIViewAutoresizingNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.clipsToBounds = YES;
    tableView.layer.cornerRadius = 4.0;
    tableView.opaque = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = rowHeight;
    return tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    DFNavMenuCell *cell = (DFNavMenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DFNavMenuCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    DFNavMenuItem *item = menuItems[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld 张照片", (long)item.count];
    cell.imageView.image = item.image;
    cell.backgroundColor = [UIColor clearColor];
    cell.checked = item.isSelected;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFNavMenuItem *item = menuItems[indexPath.row];
    if (item && item.target && [item.target respondsToSelector:item.action]) {
        [item.target performSelectorOnMainThread:item.action withObject:item waitUntilDone:YES];
    }
    //    [DFNavMenu dismissMenu];
    [self.navigationController popViewControllerAnimated:NO];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
