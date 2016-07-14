//
//  DFMultiPhotoSelectorIOS5ViewController.m
//  DFace
//
//  Created by kabda on 8/4/14.
//
//

#import "DFMultiPhotoSelectorIOS5ViewController.h"
#import "DFMultiPhotoSelectorIOS5View.h"
#import "DFNavBarButtonItem.h"
#import "DFNavMenu.h"
#import "DFNavMenuButton.h"
#import "DFSelectedDisplayerViewController.h"
#import "DFSelectableIOS5Cell.h"

#define DEFAULT_COL_NUM 4
#define DEFAULT_MAX_ALLOWED_SELECTED_COUNT 4

@interface DFMultiPhotoSelectorIOS5ViewController () <UITableViewDataSource, UITableViewDelegate, DFSelectableIOS5CellDelegate, DFSelectorBarDelegate, DFSelectedDisplayerViewControllerDelegate>
@property (nonatomic, assign) NSInteger indexOfSelectedGroup;
@end

@implementation DFMultiPhotoSelectorIOS5ViewController

- (void)dealloc
{
    [AssetsHelper clearSelectedPhotos];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DFNavBarButtonItem *leftBarButtonItem = [[DFNavBarButtonItem alloc]initLeftWithTitle:@"关闭" target:self action:@selector(closeMultiSelector)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        
        DFNavBarButtonItem *rightBarButtonItem = [[DFNavBarButtonItem alloc]initRightWithTitle:@"预览" target:self action:@selector(preview)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.enabled = NO;

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
    
    DFMultiPhotoSelectorIOS5View *view = [[DFMultiPhotoSelectorIOS5View alloc]init];
    view.delegate = self;
    self.view = view;
}

- (DFMultiPhotoSelectorIOS5View *)selectorView
{
    return (DFMultiPhotoSelectorIOS5View *)self.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readGroupsOfAlbum:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self selectorView].tableView reloadData];
    [[self selectorView].selectorBar setSelectedPhotosCount:[AssetsHelper getSelectedPhotosCount] animated:YES];
    
    if ([AssetsHelper getSelectedPhotosCount]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger total = [AssetsHelper getPhotoCountOfCurrentGroup];
    if (total == 0) {
        return 0;
    }
    if (total % 4 == 0) {
        return total / 4 + 1;
    }
    return total / 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    DFSelectableIOS5Cell *cell = (DFSelectableIOS5Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DFSelectableIOS5Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell clearData];
    NSInteger index = indexPath.row;
    NSRange range;
    range.location = self.column * index;
    range.length = self.column;
    NSArray *photos = [AssetsHelper getPhotosByRange:range];
    NSInteger subIndex = 0;
    for (DFSelectablePhoto *photo in photos) {
        [cell addImage:[AssetsHelper getImageFromPhoto:photo wityType:ASSET_PHOTO_THUMBNAIL]];
        NSInteger selectedIndex = [AssetsHelper indexOfSelectedPhoto:photo];
        [cell setSelectedIndex:selectedIndex atSubIndex:subIndex animated:NO];
        cell.delegate = self;
        subIndex++;
    }
    cell.tag = index;
    return cell;
}

#pragma mark - DFSelectableIOS5CellDelegate
- (void)selectablePhotoIOS5CellDidMarked:(DFSelectableIOS5Cell *)cell atSubIndex:(NSInteger)subIndex
{
    if (self.maxAllowedSelectedCount == 0) {
        return;
    }
    if (AssetsHelper.selectedPhotos.count >= self.maxAllowedSelectedCount && self.maxAllowedSelectedCount > 0) {
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多只能选择 %d 张照片", self.maxAllowedSelectedCount]];
        return;
    }
    NSInteger index = cell.tag * self.column + subIndex;
    [AssetsHelper markPhotoSelectedAtIndex:index];
    DFSelectablePhoto *photo = [AssetsHelper getPhotoAtIndex:index];
    NSInteger selectedIndex = [AssetsHelper indexOfSelectedPhoto:photo];
    [cell setSelectedIndex:selectedIndex atSubIndex:subIndex animated:YES];
    [[self selectorView].selectorBar setSelectedPhotosCount:[AssetsHelper getSelectedPhotosCount] animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)selectablePhotoIOS5CellDidUnMarked:(DFSelectableIOS5Cell *)cell atSubIndex:(NSInteger)subIndex
{
    NSInteger index = cell.tag * self.column + subIndex;
    [AssetsHelper markPhotoUnSelectedAtIndex:index];
    NSInteger total = [AssetsHelper getSelectedPhotosCount];
    [[self selectorView].selectorBar setSelectedPhotosCount:total];
    [[self selectorView].tableView reloadData];
    if (total <= 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)selectablePhotoIOS5CellTappedToShowAllPhotos:(DFSelectableIOS5Cell *)cell atSubIndex:(NSInteger)subIndex;
{
    NSInteger index = cell.tag * self.column + subIndex;
    DFSelectedDisplayerViewController *displayerController = [[DFSelectedDisplayerViewController alloc]initWithMaxAllowedSelectedCount:self.maxAllowedSelectedCount];
    displayerController.showSelectedPhotos = NO;
    displayerController.delegate = self;
    displayerController.startIndex = index;
    [self.navigationController pushViewController:displayerController animated:YES];
}

#pragma mark - DFMultiPhotoSelectorViewController Methods
- (void)closeMultiSelector
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(multiPhotoSelectorDidCanceled:)]) {
        [AssetsHelper clearSelectedPhotos];
        [self.delegate multiPhotoSelectorIOS5DidCanceled:self];
    }
}

- (void)changeRollToIndex:(NSInteger)index
{
    if (self.indexOfSelectedGroup == index) {
        return;
    }
    self.indexOfSelectedGroup = index;
    [self readPhotosInGroup:self.indexOfSelectedGroup];
    [AssetsHelper clearSelectedPhotos];
    if ([AssetsHelper getSelectedPhotosCount]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

}

- (void)selectFinishedWithSelectedPhotos:(NSArray *)photos
{
    if (!photos || photos.count <= 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(multiPhotoSelector:didSelectedPhotos:)]) {
        [self.delegate multiPhotoSelectorIOS5:self didSelectedPhotos:photos];
    }
}

#pragma mark - Data Preparation
- (void)readPhotosInGroup:(NSInteger)index;
{
    __weak __typeof(self) weakSelf = self;
    [AssetsHelper getPhotoListOfGroupByIndex:index result:^(NSArray *aPhotos) {
        __typeof(weakSelf) strongSelf = weakSelf;
        [[strongSelf selectorView].tableView reloadData];
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
        barbutton.backgroundColor = [UIColor clearColor];
        barbutton.title = infoDict[@"name"];
        [barbutton addTarget:self action:@selector(showMenus:) forControlEvents:UIControlEventTouchUpInside];
        barbutton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [barbutton sizeToFit];
        self.navigationItem.titleView = barbutton;
    }
}

- (void)showMenus:(UIButton *)sender
{
    NSInteger total = [AssetsHelper getGroupCount];
    NSMutableArray *menuItems = [NSMutableArray arrayWithCapacity:total];
    for (int i = 0; i < total; i++) {
        NSDictionary *infoDict = [AssetsHelper getGroupInfo:i];
        DFNavMenuItem *menuItem = [DFNavMenuItem menuItem:infoDict[@"name"]
                                                    image:infoDict[@"poster"]
                                                   target:self
                                                   action:@selector(menuItemSelected:)];
        menuItem.tag = i;
        menuItem.count = [infoDict[@"count"] integerValue];
        menuItem.selected = (self.indexOfSelectedGroup == i);
        [menuItems addObject:menuItem];
    }
    
    CGRect windowRect = [self.navigationController.view convertRect:sender.frame toView:self.view.window];
    windowRect.origin.y += 18.0;
    [DFNavMenu showMenuInView:self.view.window
                     fromRect:windowRect
                    menuItems:menuItems
                       onShow:^(BOOL isShow) {
                           ((DFNavMenuButton *)self.navigationItem.titleView).active = YES;
                       }
                    orDismiss:^(BOOL isDismiss) {
                        ((DFNavMenuButton *)self.navigationItem.titleView).active = NO;
                    }];
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

#pragma mark - DFSelectorBarDelegate
- (void)preview
{
    DFSelectedDisplayerViewController *displayerController = [[DFSelectedDisplayerViewController alloc]initWithMaxAllowedSelectedCount:self.maxAllowedSelectedCount];
    displayerController.showSelectedPhotos = YES;
    displayerController.delegate = self;
    [self.navigationController pushViewController:displayerController animated:YES];
}

- (void)complete
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(multiPhotoSelector:didSelectedPhotos:)]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.titleView.userInteractionEnabled = NO;
        [self.delegate multiPhotoSelectorIOS5:self didSelectedPhotos:AssetsHelper.selectedPhotos];
    }
}

@end
