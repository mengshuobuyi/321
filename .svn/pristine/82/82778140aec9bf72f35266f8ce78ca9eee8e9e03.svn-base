//
//  PhotoPreView.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoPreView.h"

@interface PhotoPreView ()

@end

@implementation PhotoPreView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_toSelection) {
        [self barStatus];
    }
}
- (void)dataInit{
    [self show:self.indexSelected];
}
- (void)UIGlobal{
    [super UIGlobal];
    self.barHide=YES;
}

#pragma mark - UICollectionView
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString * CellIdentifier = @"kPhotoViewerCell";
    PhotoViewerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    
    if (row<self.arrPhotos.count) {
        [cell setCell:self.arrPhotos[row]];
        /*
        //预加载
        UIImageView *pre=[[UIImageView alloc]init];
        if (row+1<self.arrPhotos.count) {
            id url=self.arrPhotos[row+1];
            if ([url isKindOfClass:[NSString class]]) {
                [pre setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
            }
        }
        if (row - 1 > 0) {
            id url=self.arrPhotos[row-1];
            if ([url isKindOfClass:[NSString class]]) {
                [pre setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
            }
        }
        */
        
        
        return  cell;
        
        
    }
    
    return cell;
}
#pragma mark - 页面滑动
- (void)checkSelected:(NSInteger)row{
    
}
- (void)loadPhotoForCell:(NSIndexPath *)indexPath{
    
}

#pragma mark - action
- (IBAction)deleteAction:(id)sender{
    if (_blockSelect) {
        _blockSelect([self getCurIndex]);
    }
    [self closeAction:nil];
}
#pragma mark 单击屏幕
- (void)oneTap{
    if (_toSelection) {
        [self barStatus];
    }
    else
        [self closeAction:nil];
}

- (void)saveImage:(UIImage*)photo{
    if (_dontSave) {
        return;
    }
    QWGLOBALMANAGER.saveImage = photo;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:QWGLOBALMANAGER cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles: nil];
    [sheet showInView:self.view];
}

@end
