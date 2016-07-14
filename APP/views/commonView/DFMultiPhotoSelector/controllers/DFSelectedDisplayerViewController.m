//
//  DFSelectedDisplayerViewController.m
//  DFace
//
//  Created by kabda on 7/1/14.
//
//

#import "DFSelectedDisplayerViewController.h"
#import "DFSelectedDisplayerView.h"
#import "DFAssetsHelper.H"
#import "DFDisplayerCell.h"
#import "UIImage+Ex.h"
#import "XHMessageTableViewController.h"
@interface DFSelectedDisplayerViewController () <UITableViewDataSource, UITableViewDelegate, DFSelectorBarDelegate, DFSelectorNavBarDelegate, DFDisplayerCellDelegate>
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *tmpSelectedArray;
@end

@implementation DFSelectedDisplayerViewController

- (id)init
{
    self = [super init];
    if (self) {
        _maxAllowedSelectedCount = 0;
        _showSelectedPhotos = NO;
        _startIndex = 0;
        _currentIndex = 0;
        _tmpSelectedArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (id)initWithMaxAllowedSelectedCount:(NSInteger)maxAllowedSelectedCount
{
    self = [self init];
    if (self) {
        _maxAllowedSelectedCount = maxAllowedSelectedCount;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    DFSelectedDisplayerView *view = [[DFSelectedDisplayerView alloc]init];
    view.delegate = self;
    self.view = view;
}

- (DFSelectedDisplayerView *)displayerView
{
    return (DFSelectedDisplayerView *)self.view;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.title = @"预览";
    [self.tmpSelectedArray setArray:[AssetsHelper selectedPhotos]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self displayerView].tableView reloadData];
    UITableView *tableView = [self displayerView].tableView;
    CGPoint offsetPoint = CGPointMake(0.0, (CGRectGetWidth(tableView.frame) * self.startIndex));
    [tableView setContentOffset:offsetPoint];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isShowSelectedPhotos) {
        return self.tmpSelectedArray.count;
    } else {
        return [AssetsHelper getPhotoCountOfCurrentGroup];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = CGRectGetWidth(tableView.frame);
    if (indexPath.row == 0) {
        return MAX(w - 0.1, 0.0); // 通过 0.1 个像素让 tableView 提前准备好下一下Cell;
    }
    return w;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"displayer";
    DFDisplayerCell *cell = (DFDisplayerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DFDisplayerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSInteger index = indexPath.row;
    if (self.isShowSelectedPhotos) {
        DFSelectablePhoto *photo = (DFSelectablePhoto *)self.tmpSelectedArray[index];
        cell.photo = [AssetsHelper getImageFromPhoto:photo wityType:ASSET_PHOTO_SCREEN_SIZE];
    } else {
        cell.photo = [AssetsHelper getImageAtIndex:index type:ASSET_PHOTO_SCREEN_SIZE];
    }
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self setNavBarSelectionAtIndex:0 animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xOffset = scrollView.contentOffset.y;
    NSInteger index = (int)(xOffset / 320);
    (xOffset > ((index * 320.0) + 160.0)) ? (index += 1) : (index += 0);
    self.currentIndex = index;
    [self setNavBarSelectionAtIndex:self.currentIndex animated:NO];
}

- (void)setNavBarSelectionAtIndex:(NSInteger)index animated:(BOOL)animated
{
    DFSelectablePhoto *photo = nil;
    if (self.isShowSelectedPhotos) {
        if (index < 0 || index >= self.tmpSelectedArray.count) {
            return;
        }
        photo = (DFSelectablePhoto *)self.tmpSelectedArray[index];
    } else {
        if (index < 0 || index >= [AssetsHelper getPhotoCountOfCurrentGroup]) {
            return;
        }
        photo = [AssetsHelper getPhotoAtIndex:index];
    }
    //    [[self displayerView].selectorNavBar setSelectedIndex:[AssetsHelper indexOfSelectedPhoto:photo] animated:animated];
    //    [[self displayerView].selectorBar setSelectedPhotosCount:[AssetsHelper getSelectedPhotosCount] animated:animated];
}

#pragma mark - DFSelectorBarDelegate
- (void)preview
{
    //do nothing
}

- (void)complete
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayerViewControllerDidFinished)]) {
        [self displayerView].tableView.scrollEnabled = NO;
        [self displayerView].selectorNavBar.actionButton.enabled = NO;
        [self displayerView].selectorNavBar.backButton.enabled = NO;
        [self.delegate performSelector:@selector(displayerViewControllerDidFinished)];
    }
}

#pragma mark - DFSelectorNavBarDelegate
- (void)back
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        if ([temp isKindOfClass:[XHMessageTableViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)markSelected
{
    DFSelectablePhoto *photo =nil;
    //    if (AssetsHelper.selectedPhotos.count >= self.maxAllowedSelectedCount && self.maxAllowedSelectedCount > 0) {
    ////        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多只能选择 %d 张照片", self.maxAllowedSelectedCount]];
    //        return;
    //    }
    NSLog(@"------selectedPhotos.count---->%ld",(unsigned long)AssetsHelper.selectedPhotos.count);
    if (self.isShowSelectedPhotos) {
        photo = (DFSelectablePhoto *)self.tmpSelectedArray[self.currentIndex];
        [AssetsHelper markPhoto:photo selected:YES];
    } else {
        [AssetsHelper markPhotoSelectedAtIndex:self.currentIndex];
        photo =   [AssetsHelper.selectedPhotos objectAtIndex:0];
    }
    
    
    UIImage *image = [AssetsHelper getImageFromPhoto:photo wityType:ASSET_PHOTO_SCREEN_SIZE];
    
    image = [image imageByScalingToMinSize];
      image = [UIImage scaleAndRotateImage:image];
    NSString *fileUrl = [photo.asset.defaultRepresentation.url absoluteString];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:NO];
    });
    
    [self.delegate sendPhoto:image];
    //    [[self displayerView].selectorBar setSelectedPhotosCount:[AssetsHelper getSelectedPhotosCount]];
    //    [self setNavBarSelectionAtIndex:self.currentIndex animated:YES];
    
}

- (void)markUnSelected
{
    if (self.isShowSelectedPhotos) {
        DFSelectablePhoto *photo = (DFSelectablePhoto *)self.tmpSelectedArray[self.currentIndex];
        [AssetsHelper markPhoto:photo selected:NO];
    } else {
        [AssetsHelper markPhotoUnSelectedAtIndex:self.currentIndex];
    }
    //    [[self displayerView].selectorBar setSelectedPhotosCount:[AssetsHelper getSelectedPhotosCount]];
    //    [self setNavBarSelectionAtIndex:self.currentIndex animated:NO];
}

#pragma mark - DFDisplayerCellDelegate
- (void)photoViewTapped
{
    [self displayerView].barHidden = ![self displayerView].isBarHidden;
}
@end
