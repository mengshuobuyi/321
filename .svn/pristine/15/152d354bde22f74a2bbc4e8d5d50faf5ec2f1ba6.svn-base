//
//  DFSelectedDisplayerViewController.h
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

#import "QWBaseVC.h"

@protocol DFSelectedDisplayerViewControllerDelegate <NSObject>
- (void)displayerViewControllerDidFinished;
-(void)sendPhoto:(UIImage *)img;
@end

@interface DFSelectedDisplayerViewController :  QWBaseVC
@property (nonatomic, weak) id<DFSelectedDisplayerViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger maxAllowedSelectedCount;
@property (nonatomic, assign, getter = isShowSelectedPhotos) BOOL showSelectedPhotos;
@property (nonatomic, assign) NSInteger startIndex;

- (id)initWithMaxAllowedSelectedCount:(NSInteger)maxAllowedSelectedCount;

@end
