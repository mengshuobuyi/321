//
//  PhotoAlbumList.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoAlbumList.h"
#import "PhotoAlbumListCell.h"
@interface PhotoAlbumList ()
{
    NSArray *arrData;
    PhotoAlbumListSelectedBlock groupBlock;
}
@end

@implementation PhotoAlbumList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self naviLeftBottonImage:nil highlighted:nil action:nil];
}

- (IBAction)closeAction:(id)sender{
    if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    
}

- (void)UIGlobal{
    [super UIGlobal];
    
    self.title=@"照片";
    self.view.backgroundColor=RGBHex(qwColor4);
}

- (void)showList:(NSArray*)list block:(PhotoAlbumListSelectedBlock)block{
    DebugLog(@"########### %@",list);
    groupBlock=block;
    arrData=list;
    
}

#pragma mark 表格
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PhotoAlbumListCell getCellHeight:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString *tableID = @"PhotoAlbumListCell";
    
    PhotoAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    cell.delegate=self;
    if (row<arrData.count) {
        ALAssetsGroup *grp=[arrData objectAtIndex:row];
        [cell setCellImage:[UIImage imageWithCGImage:grp.posterImage] title:[grp valueForProperty:ALAssetsGroupPropertyName] numberOfAssets:grp.numberOfAssets];
        
//        cell.imageView.image=[UIImage imageWithCGImage:grp.posterImage];
//        cell.textLabel.text=[grp valueForProperty:ALAssetsGroupPropertyName];
//        [cell setCell:nil];
        return cell;
    }
    
    
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"%@",indexPath);
    
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
    if (indexPath.row<arrData.count && groupBlock) {
        groupBlock([arrData objectAtIndex:indexPath.row]);
    }
}

#pragma mark - 页面滑动
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    
}
@end
