//
//  PhotoAlbumListCell.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface PhotoAlbumListCell : QWBaseTableCell
{
    IBOutlet UIImageView *photo;
    IBOutlet UILabel *lblTTL,*lblNum;
}
- (void)setCellImage:(UIImage*)image title:(NSString*)title numberOfAssets:(NSInteger)numberOfAssets;
@end
