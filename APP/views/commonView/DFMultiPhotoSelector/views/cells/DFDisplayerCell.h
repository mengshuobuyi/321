//
//  DFDisplayerCell.h
//  DFace
//
//  Created by kabda on 7/23/14.
//
//

#import <UIKit/UIKit.h>

@protocol DFDisplayerCellDelegate <NSObject>
- (void)photoViewTapped;
@end

@interface DFDisplayerCell : UITableViewCell
@property (nonatomic, weak) id<DFDisplayerCellDelegate> delegate;
@property (nonatomic, strong) UIImage *photo;
@end
