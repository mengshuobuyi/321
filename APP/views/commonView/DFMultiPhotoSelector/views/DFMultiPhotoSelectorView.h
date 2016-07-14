//
//  DFMultiPhotoSelectorView.h
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

//#import "DFBaseView.h"
#import "DFSelectorBar.h"

@interface DFMultiPhotoSelectorView : UIView
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DFSelectorBar *selectorBar;
@end
