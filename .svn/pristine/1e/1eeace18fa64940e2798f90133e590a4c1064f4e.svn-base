//
//  DFMultiPhotoSelectorViewController.m
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

#import "DFMultiPhotoSelectorViewController.h"
#import "DFMultiPhotoSelectorView.h"
#import "DFNavBarButtonItem.h"
#import "DFSelectablePhotoCell.h"
#import "DFNavMenu.h"
#import "DFNavMenuButton.h"
#import "DFSelectedDisplayerViewController.h"
#import "photoViewController.h"
#define DEFAULT_COL_NUM 3
#define DEFAULT_MAX_ALLOWED_SELECTED_COUNT 1

@interface DFMultiPhotoSelectorViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DFSelectablePhotoCellDelegate, DFSelectorBarDelegate, DFSelectedDisplayerViewControllerDelegate>
@property (nonatomic, assign) NSInteger indexOfSelectedGroup;
@end

@implementation DFMultiPhotoSelectorViewController

- (void)dealloc
{
    [AssetsHelper clearSelectedPhotos];
}

- (id)init
{
    self = [super init];
    if (self) {
        DFNavBarButtonItem *leftBarButtonItem = [[DFNavBarButtonItem alloc]initLeftWithTitle:@"" target:self action:@selector(closeMultiSelector)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        
        DFNavBarButtonItem *rightBarButtonItem = [[DFNavBarButtonItem alloc]initRightWithTitle:@"取消" target:self action:@selector(preview)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        _indexOfSelectedGroup = 0;
        _column = DEFAULT_COL_NUM;
        _maxAllowedSelectedCount = DEFAULT_MAX_ALLOWED_SELECTED_COUNT;
        
        [AssetsHelper clearSelectedPhotos];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    DFMultiPhotoSelectorView *view = [[DFMultiPhotoSelectorView alloc]init];
    view.delegate = self;
    self.view = view;
}

- (DFMultiPhotoSelectorView *)selectorView
{
    return (DFMultiPhotoSelectorView *)self.view;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self readGroupsOfAlbum:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self selectorView].collectionView.userInteractionEnabled = YES;
    [[self selectorView].collectionView reloadData];
    [[self selectorView].selectorBar setSelectedPhotosCount:[AssetsHelper getSelectedPhotosCount] animated:YES];
    if ([AssetsHelper getSelectedPhotosCount]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.title =@"相机胶卷";
    //      self.title = @"相机胶卷";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.column) {
        case 2:
            return CGSizeMake(151, 151);
        case 3:
            return CGSizeMake(101, 101);
        case 4:
            return CGSizeMake(75, 75);
        default:
            return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [AssetsHelper getPhotoCountOfCurrentGroup];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    DFSelectablePhoto *photo = [AssetsHelper getPhotoAtIndex:index];
    static NSString * cellIdentifier = @"cell";
    DFSelectablePhotoCell * cell = (DFSelectablePhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.column >= 3) {
        cell.image = [AssetsHelper getImageFromPhoto:photo wityType:ASSET_PHOTO_THUMBNAIL];
    } else {
        cell.image = [AssetsHelper getImageFromPhoto:photo wityType:ASSET_PHOTO_ASPECT_THUMBNAIL];
    }
    NSInteger selectedIndex = [AssetsHelper indexOfSelectedPhoto:photo];
    [cell setSelectedIndex:selectedIndex];
    cell.delegate = self;
    cell.tag = index;
    return cell;
}

#pragma mark - DFSelectablePhotoCellDelegate
- (void)selectablePhotoCellDidMarked:(DFSelectablePhotoCell *)cell
{
    if (self.maxAllowedSelectedCount == 0) {
        return;
    }
    if (AssetsHelper.selectedPhotos.count >= self.maxAllowedSelectedCount && self.maxAllowedSelectedCount > 0) {
        //        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多只能选择 %d 张照片", self.maxAllowedSelectedCount]];
        return;
    }
    NSInteger index = cell.tag;
    [AssetsHelper markPhotoSelectedAtIndex:index];
    DFSelectablePhoto *photo = [AssetsHelper getPhotoAtIndex:index];
    NSInteger selectedIndex = [AssetsHelper indexOfSelectedPhoto:photo];
    [cell setSelectedIndex:selectedIndex animated:YES];
    [[self selectorView].selectorBar setSelectedPhotosCount:[AssetsHelper getSelectedPhotosCount] animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)selectablePhotoCellDidUnMarked:(DFSelectablePhotoCell *)cell
{
    [AssetsHelper markPhotoUnSelectedAtIndex:cell.tag];
    [self reloadVisibleCells];
    NSInteger total = [AssetsHelper getSelectedPhotosCount];
    [[self selectorView].selectorBar setSelectedPhotosCount:total];
    if (total == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)reloadVisibleCells
{
    NSArray *cells = [self selectorView].collectionView.visibleCells;
    for (DFSelectablePhotoCell *cell in cells) {
        if (cell.isSelectedMode) {
            DFSelectablePhoto *photo = [AssetsHelper getPhotoAtIndex:cell.tag];
            NSInteger selectedIndex = [AssetsHelper indexOfSelectedPhoto:photo];
            [cell setSelectedIndex:selectedIndex];
        }
    }
}
- (void)selectablePhotoCellTappedToShowAllPhotos:(DFSelectablePhotoCell *)cell
{
    DFSelectedDisplayerViewController *displayerController = [[DFSelectedDisplayerViewController alloc]initWithMaxAllowedSelectedCount:self.maxAllowedSelectedCount];
    displayerController.showSelectedPhotos = NO;
    displayerController.delegate = self;
    displayerController.startIndex = cell.tag;
    [self.navigationController pushViewController:displayerController animated:YES];
}

#pragma mark - DFMultiPhotoSelectorViewController Methods
- (void)closeMultiSelector
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(multiPhotoSelectorDidCanceled:)]) {
        [AssetsHelper clearSelectedPhotos];
        [self.delegate multiPhotoSelectorDidCanceled:self];
    }
}

- (void)changeRollToIndex:(NSInteger)index
{
    if (self.indexOfSelectedGroup == index) {
        return;
    }
    self.indexOfSelectedGroup = index;
    [[self selectorView].selectorBar setSelectedPhotosCount:0];
    [self readPhotosInGroup:self.indexOfSelectedGroup];
    [AssetsHelper clearSelectedPhotos];
    if ([AssetsHelper getSelectedPhotosCount]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)selectFinishedWithSelectedPhotos:(NSArray *)photos
{
    if (!photos || photos.count <= 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(multiPhotoSelector:didSelectedPhotos:)]) {
        [self.delegate multiPhotoSelector:self didSelectedPhotos:photos];
    }
}

#pragma mark - Data Preparation
- (void)readPhotosInGroup:(NSInteger)index;
{
    __weak __typeof(self) weakSelf = self;
    [AssetsHelper getPhotoListOfGroupByIndex:index result:^(NSArray *aPhotos) {
        __typeof(weakSelf) strongSelf = weakSelf;
        [[strongSelf selectorView].collectionView reloadData];
    }];
}

- (void)readGroupsOfAlbum:(BOOL)isFirst
{
    __weak __typeof(self) weakSelf = self;
    [AssetsHelper getGroupList:^(NSArray *aGroups) {
        __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf initBarButton];
        [strongSelf readPhotosInGroup:self.indexOfSelectedGroup];
    }];
}

#pragma mark - popMenu
- (void)initBarButton
{
    if (self.navigationItem) {
        NSDictionary *infoDict = [AssetsHelper getGroupInfo:0];
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        DFNavMenuButton *barbutton = [[DFNavMenuButton alloc]initWithFrame:frame];
        //        barbutton.hidden = YES;
        barbutton.backgroundColor = [UIColor clearColor];
        barbutton.title =@"相片胶卷";
        //        [barbutton addTarget:self action:@selector(showMenus:) forControlEvents:UIControlEventTouchUpInside];
        barbutton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [barbutton sizeToFit];
        self.navigationItem.titleView = barbutton;
    }
}

- (void)showMenus:(UIButton *)sender
{

}

- (void)menuItemSelected:(DFNavMenuItem *)sender
{
    DFNavMenuButton *barbutton = (DFNavMenuButton *)self.navigationItem.titleView;
    if (![barbutton isKindOfClass:[DFNavMenuButton class]]) {
        return;
    }
    barbutton.title = sender.title;
    [self changeRollToIndex:sender.tag];
}

#pragma mark - DFSelectedDisplayerViewControllerDelegate
- (void)displayerViewControllerDidFinished
{
    [self complete];
}
-(void)sendPhoto:(UIImage *)img
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChoosePhoto:)]) {
        //        [self selectorView].collectionView.userInteractionEnabled = NO;
        //        self.navigationItem.rightBarButtonItem.enabled = NO;
        //        self.navigationItem.leftBarButtonItem.enabled = NO;
        //        self.navigationItem.titleView.userInteractionEnabled = NO;
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:NO];
        });
        
        [self.delegate didChoosePhoto:img];
        
    }
}
#pragma mark - DFSelectorBarDelegate
- (void)preview
{
    //    NSInteger total = [AssetsHelper getSelectedPhotosCount];
    //    if (total <= 0) {
    //        return;
    //    }
    //    [self selectorView].collectionView.userInteractionEnabled = NO;
    //    DFSelectedDisplayerViewController *displayerController = [[DFSelectedDisplayerViewController alloc]initWithMaxAllowedSelectedCount:self.maxAllowedSelectedCount];
    //    displayerController.showSelectedPhotos = YES;
    //    displayerController.delegate = self;
    //    [self.navigationController pushViewController:displayerController animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)complete
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(multiPhotoSelector:didSelectedPhotos:)]) {
        [self selectorView].collectionView.userInteractionEnabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.titleView.userInteractionEnabled = NO;
        [self.delegate multiPhotoSelector:self didSelectedPhotos:AssetsHelper.selectedPhotos];
    }
}

- (void)popVCAction:(id)sender
{
    photoViewController *vc  = [[photoViewController alloc]initWithNibName:@"photoViewController" bundle:nil];;
    vc.father = self;
    vc.backButtonEnabled = NO;
    vc.indexOfSelectedGroup = self.indexOfSelectedGroup;
    [self.navigationController pushViewController:vc animated:NO];
}
@end
