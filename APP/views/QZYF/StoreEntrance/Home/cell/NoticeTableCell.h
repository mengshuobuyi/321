//
//  NoticeTableCell.h
//  wenYao-store
//
//  Created by caojing on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface NoticeTableCell : QWBaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *noticeContentLable;
@property (weak, nonatomic) IBOutlet UIImageView *noticeImageView;

@end
