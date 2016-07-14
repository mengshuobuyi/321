//
//  PhotoViewer.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/6/2.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoViewer.h"
#import "QYPhotoAlbum.h"
#import "UIImageView+WebCache.h"
#import "ScrollTouch.h"
//#import "PhotoZoomScroll.h"
//#import "UIScrollView+EX.h"
//static float kMargin = 30.f;


@interface PhotoViewer()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PhotoViewerDelegate>
{
    
    IBOutlet UIView *vTop,*vBottom;
    IBOutlet UICollectionView *collectMain;
    IBOutlet UIButton *btnSelect,*btnOK;
    NSCache *cache;
    IBOutlet UILabel *lblSelected;
    NSInteger loadIndex,curIndex,lastIndex;
//    NSIndexPath *curIndexPath;
    BOOL enabledBtn;
    dispatch_queue_t queueOpenPhoto;
    UIImage *curPhoto;
    
    NSString *memeUrl;
}

@end

@implementation PhotoViewer
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
    [self dataInit];
//    [self invokeAsyncVoidBlock:^{
//        [self show:_indexSelected];
//    } success:^{
//        //
//    }];
}

- (void)dataInit{
    memeUrl=nil;
    queueOpenPhoto=dispatch_queue_create("QPhotoViewer", NULL);
    
    loadIndex=-1;
    curIndex=-1;
    lastIndex=-1;
    enabledBtn=YES;
    //    [self setupPhotos];
    [self showNum];
    [self show:_indexSelected];
}

- (void)UIGlobal{
    [super UIGlobal];

  
    _barHide = NO;
    self.navigationController.navigationBarHidden=YES;
    
    CGRect frm=self.view.bounds;
    collectMain.frame=frm;
    

    
    collectMain.pagingEnabled=YES;
    collectMain.backgroundColor=RGBHex(qwColor6);
    
    vTop.backgroundColor=RGBHex(qwColor1);
    
    [btnOK setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    [btnOK setTitleColor:RGBHex(qwColor8) forState:UIControlStateDisabled];
    
    lblSelected.hidden=YES;
//    collectMain.decelerationRate = 1.0;
//    DebugLog(@"FFFFFFFFFFFFFFFFFFFv %f %f",UIScrollViewDecelerationRateNormal,UIScrollViewDecelerationRateFast);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DebugLog(@"!!!!!!!!!!!!!!! didReceiveMemoryWarning !!!!!!!!!!!!!!!!!!");
    
    [cache removeAllObjects];
    
    curPhoto=nil;
    [PhotosAlbum cleanPhotosQueue];
    
    collectMain.scrollEnabled=NO;
    [self performSelector:@selector(scrollEnabled) withObject:nil afterDelay:.5];
//    cache.totalCostLimit
//    [cache removeAllObjects];
}

- (void)scrollEnabled{
    collectMain.scrollEnabled=YES;
}
#pragma mark -
- (void)barStatus{
    _barHide=!_barHide;
    if (_barHide) {
        vTop.hidden=YES;
        vBottom.hidden=YES;
    }
    else {
        vTop.hidden=NO;
        vBottom.hidden=NO;
    }
}

- (void)checkSelected:(NSInteger)row{
    if (curIndex==row) {
        return;
    }
    
    curIndex=row;
    if (curIndex<self.arrPhotos.count) {
        ALAsset *ass=[self.arrPhotos objectAtIndex:curIndex];
        NSString *url=[ass.defaultRepresentation.url absoluteString];
//        cell.imgPhoto.image=[UIImage imageWithCGImage:ass.thumbnail];
//        cell.url=[ass.defaultRepresentation.url absoluteString];
//        cell.index=row;
        btnSelect.selected=NO;
        for (PhotoModel *mode in self.arrSelected) {
            if ([mode.url isEqualToString:url]) {
                btnSelect.selected=YES;
                break;
            }
        }
    }
}

- (void)showNum{
//    lblSelected.text=[NSString stringWithFormat:@"完成（%lu）",(unsigned long)_arrSelected.count];
    NSString *str=[NSString stringWithFormat:@"完成（%lu）",(unsigned long)_arrSelected.count];
    [btnOK setTitle:str forState:UIControlStateNormal];
}

- (void)show:(NSInteger)index{
    if (index>=0) {
        lastIndex=index;
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        [collectMain scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        [self checkSelected:index];
        [self loadPhotoForCell:indexPath];
    }
}

- (void)invokeAsyncVoidBlock:(void(^)())block
                     success:(void(^)())success
{
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^(void) {
        if (block) {
            block();
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (success) {
                                   success();
                               }
                           });
        }
    });
}

- (void)invokeAsyncQueueBlock:(id (^)())block
                      success:(void (^)(id obj))success
{
    dispatch_async(queueOpenPhoto, ^(void) {
//        DebugLog(@"打开图片----%@",[NSThread currentThread]);
        id retVal = nil;
        if (block) {
            retVal = block();
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (success) {
                                   success(retVal);
                               }
                           });
        }
    });
}

- (void)OKSuccess{
    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:_arrSelected.count];
    for (PhotoModel *mode in _arrSelected) {
        [tmp addObject:mode.asset];
        mode.fullImage=nil;
    }
    [PhotosAlbum getFullImageByAssetList:tmp photoBlock:^(UIImage *fullResolutionImage) {
        UIImage *imgTmp=[PhotosAlbum photoToMin:fullResolutionImage];
        int i = 0;
        for (PhotoModel *mode in _arrSelected) {
            if (mode.fullImage==nil) {
                mode.fullImage=imgTmp;
                break;
            }
            i++;
        }
        if ((i+1)==_arrSelected.count) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [self closeAction:nil];
                               if (_photosBlock) {
                                   _photosBlock(_arrSelected);
                               }
                               QWLOADING.closeLoading;
                           });
        }
        
    } failure:nil];
}
#pragma mark - action
- (IBAction)OK:(id)sender{
    if (PhotosAlbum.isOpening) {
        DebugLog(@"正在载入");
        return;
    }
    else {
        DebugLog(@"可以发送");
        btnOK.enabled=NO;
    }
    btnOK.enabled=NO;
    QWLOADING.showLoading;
    
    [self invokeAsyncVoidBlock:^{
        if (_arrSelected.count==0) {
//            [_arrSelected addObject:nil];
            if (lastIndex>=0 && lastIndex<self.arrPhotos.count) {
                ALAsset *ass=[self.arrPhotos objectAtIndex:lastIndex];
                NSString *url=[ass.defaultRepresentation.url absoluteString];
                
                PhotoModel *mode=[PhotoModel new];
                mode.thumbnail=[UIImage imageWithCGImage:ass.thumbnail];
                mode.url=url;
                mode.asset=ass;
                
                
                [_arrSelected addObject:mode];
            }
        }
    } success:^{
        [self OKSuccess];
    }];
}



- (IBAction)closeAction:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
            //
        }];
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:NO completion:^{
            //
        }];
    }
    
}
- (IBAction)popVCAction:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [super popVCAction:sender];
//    [self performSelector:@selector(tt) withObject:nil afterDelay:0.25];
    
}

- (IBAction)selectAction:(id)sender{
    if (!enabledBtn) {
        return;
    }
    
    if (!btnSelect.selected && _arrSelected.count==_maxPhotos ) {
        [self showError:kWarningAlbum];
        return;
    }
    
    if (lastIndex<0||lastIndex>=self.arrPhotos.count) {
        return;
    }
    
    ALAsset *ass=[self.arrPhotos objectAtIndex:lastIndex];
    NSString *url=[ass.defaultRepresentation.url absoluteString];
    
    if (btnSelect.selected) {
        btnSelect.selected=false;
        
        BOOL canMove=false;
        int i = 0;
        for (PhotoModel *mode in _arrSelected) {
            if ([mode.url isEqualToString:url]) {
                canMove=YES;
                break;
            }
            i++;
        }
        if (canMove) {
            [_arrSelected removeObjectAtIndex:i];
        }
    }
    else {
        btnSelect.selected=YES;
        PhotoModel *mode=[PhotoModel new];
        mode.thumbnail=[UIImage imageWithCGImage:ass.thumbnail];
        mode.url=url;
        mode.asset=ass;

        
        
        [_arrSelected addObject:mode];
    }
    
    [self showNum];
    
}

#pragma mark --UICollectionView
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrPhotos.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString * CellIdentifier = @"kPhotoViewerCell";
    PhotoViewerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate=self;

    if (row<self.arrPhotos.count) {
//        [self checkSelected:row];
        [cell setCell:[self preLoadThumbnail:row]];
        
        //预加载
        if (row+1<self.arrPhotos.count) {
            [self preLoadThumbnail:row+1];
        }
        if (row - 1 > 0) {
            [self preLoadThumbnail:row-1];
        }
        
        return  cell;
        
       
    }
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self checkSelected:indexPath.row];
//}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PhotoViewerCell getCellSize:nil];
}

////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
//}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 滑动停止,加载


- (void)loadPhotoForCell:(NSIndexPath *)indexPath{
//    if (PhotosAlbum.isOpening) {
//        DebugLog(@"滑动停止,PhotoAlbum正在载入");
////        return;
//    }
    if (loadIndex==indexPath.row) {
        return;
    }
    
    loadIndex=indexPath.row;
    ALAsset *ass=self.arrPhotos[loadIndex];
    
//    if ([memeUrl isEqualToString:ass.defaultRepresentation.url.absoluteString]) {
//        return;
//    }
//    else memeUrl=ass.defaultRepresentation.url.absoluteString;
    
    curPhoto=[self getCacheImage:ass.defaultRepresentation.url.absoluteString];
    if (curPhoto) {
        [self cellIndexPath:indexPath loadImage:curPhoto];
        return;
    }
    
//    if (PhotosAlbum.isOpening) {
//        DebugLog(@"滑动停止,PhotoAlbum正在载入");
//        return;
//    }
    
    [PhotosAlbum cleanPhotosQueue];
    [PhotosAlbum getFullImageByAsset:ass photoBlock:^(UIImage *fullResolutionImage) {
        [self invokeAsyncQueueBlock:^id{
            curPhoto = fullResolutionImage;

            if (curPhoto.size.width*curPhoto.size.height>1200*1200) {
                curPhoto = [curPhoto imageByScalingToMinSize];
                
            }
            [self setCacheImage:curPhoto key:ass.defaultRepresentation.url.absoluteString];
            return curPhoto;
        } success:^(id obj) {
            [self cellIndexPath:indexPath loadImage:obj];
        }];
    } failure:^(NSError *error) {
        //
    }];

}

- (void)cellIndexPath:(NSIndexPath *)indexPath loadImage:(UIImage*)image{
    PhotoViewerCell *cell = (PhotoViewerCell *)[collectMain cellForItemAtIndexPath:indexPath];
    [cell setCell:curPhoto];
    
}

- (void)scrollDidEnd {
    enabledBtn=YES;
    
    NSArray *visibleCells = [collectMain visibleCells];
    for (PhotoViewerCell *cell in visibleCells) {
        NSIndexPath *indexPath = [collectMain indexPathForCell:cell];
        
        [self loadPhotoForCell:indexPath];
    }
}

- (void)isScrolling {
    
    
    float mm = CGRectGetWidth(collectMain.frame)/2;
    NSArray *visibleCells = [collectMain visibleCells];
    for (PhotoViewerCell *cell in visibleCells) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        CGRect frm=[cell convertRect:cell.bounds toView:window];
        NSIndexPath *indexPath = [collectMain indexPathForCell:cell];

        if (frm.origin.x <= mm && frm.origin.x >= -mm) {
//            DebugLog(@"%d:%@",indexPath.row,NSStringFromCGRect(frm));
            [self checkSelected:indexPath.row];
        }
        if (frm.origin.x==0) {
            lastIndex=indexPath.row;
            enabledBtn=YES;
        }
        else enabledBtn=NO;
    }
}

- (NSUInteger)getCurIndex{
    if (lastIndex<0) {
        return 0;
    }
    else  if (lastIndex>=self.arrPhotos.count) {
        return self.arrPhotos.count;
    }
    else return lastIndex;
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self scrollDidEnd];
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    enabledBtn=YES;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self isScrolling];
}


#pragma mark -  preload
- (UIImage *)loadCellImage:(NSInteger)index{
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    ALAsset *ass=self.arrPhotos[index];
    UIImage *img=[self getCacheImage:ass.defaultRepresentation.url.absoluteString];
    if (img) {
        return img;
    }
    img=[self preLoadThumbnail:index];
    return img;
}

- (UIImage *)getCacheImage:(NSString*)key{
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    id obj = [cache objectForKey:key];
    if (obj && [obj isKindOfClass:[UIImage class]]) {
        return obj;
    }
    return nil;
}

- (void)setCacheImage:(UIImage*)image key:(NSString*)key{
    if (image) [cache setObject:image forKey:key];
}

- (UIImage *)preLoadThumbnail:(NSInteger)index{
    if (!cache) {
        cache = [[NSCache alloc] init];
        //        cache.countLimit = 3;
    }
    id obj = [cache objectForKey:@(index)];
    if (obj && [obj isKindOfClass:[UIImage class]]) {
        return obj;
    }
    
    UIImage *image = [self getThumbnailByObject:self.arrPhotos[index]];
    if (image) [cache setObject:image forKey:@(index)];
    
    return image;

}

- (BOOL)checkCache:(NSUInteger)index{
    if (cache) {
        id obj = [cache objectForKey:@(index)];
        if (obj && [obj isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark -  get photo

- (UIImage*)getThumbnailByObject:(ALAsset *)obj{
//    return nil;
    ALAsset *ass=obj;
    UIImage *img=[UIImage imageWithCGImage:ass.aspectRatioThumbnail];
    return img;
}

#pragma mark - PhotoViewerDelegate
- (void)PhotoViewerDelegate:(PhotoViewerCell*)cell{
    [self oneTap];
}

- (void)PhotoViewerSaveImage:(UIImage*)photo{
    [self saveImage:photo];
}
#pragma mark 单击屏幕
- (void)oneTap{
    [self barStatus];
}

- (void)saveImage:(UIImage*)photo{
    
}
@end


@interface PhotoViewerCell()
<UIScrollViewDelegate,ScrollTouchesDelegate>
{
    IBOutlet ScrollTouch *scroll;
//    UIImage *photo;
//    UIButton *btn;
}

- (void)setPhotoSize:(CGSize)photoSize;
@end

@implementation PhotoViewerCell
+ (CGSize)getCellSize:(id)data{
    CGSize sz = [UIScreen mainScreen].bounds.size;

    return sz;
}



- (void)UIGlobal{
    [super UIGlobal]; 
}

- (void)setCell:(id)data{
    NSString *uuid=nil;
    UIImage *photo=nil;
    if ([data isKindOfClass:[UIImage class]])
        photo=data;
    else if([data isKindOfClass:[NSString class]]){
        uuid=data;
    }
    else return;
    
    scroll.minimumZoomScale = 1;
    scroll.maximumZoomScale = 2;
    scroll.zoomScale = 1;
    scroll.delegateTouch=self;
    
    if (self.imgPhoto==nil) {
        self.imgPhoto = [[UIImageView alloc]init];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    longPress.minimumPressDuration = 1.25;
    [self addGestureRecognizer:longPress];
    
    if (photo) {
//        [self.imgPhoto setImage:nil];
//        return;
        [self.imgPhoto setImage:photo];
        [self setPhotoSize:photo.size];
    }
    else if(uuid){
        photo = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:uuid];
        if (photo) {
            [self.imgPhoto setImage:photo];
            [self setPhotoSize:photo.size];
        }
        else {
            __weak typeof (self) weakSelf = self;
            [self.imgPhoto setImageWithURL:[NSURL URLWithString:uuid]
                          placeholderImage:nil
                                   options:SDWebImageRetryFailed|SDWebImageContinueInBackground|SDWebImageProgressiveDownload
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      //                                  DebugLog(@"%d %d",receivedSize,expectedSize);
                                  }
                                 completed:^(UIImage *photo, NSError *error, SDImageCacheType cacheType) {
                                     //                                 [self.imgPhoto setImage:photo];
                                     [weakSelf setPhotoSize:photo.size];
                                 }];
        }
    }
    
    
//    [self.imgPhoto setImage:photo];
}

- (void)saveImage:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {

    }
    else if (sender.state == UIGestureRecognizerStateBegan){

        if ([self.delegate respondsToSelector:@selector(PhotoViewerSaveImage:)]) {
            [self.delegate PhotoViewerSaveImage:self.imgPhoto.image];
        }
    }
}

- (void)setPhotoSize:(CGSize)photoSize{
    CGSize sz=[self originSize:photoSize fitInSize:[UIScreen mainScreen].bounds.size];
    
    CGRect frm = [UIScreen mainScreen].bounds;
    frm.origin.x=(frm.size.width-sz.width)/2;
    frm.origin.y=(frm.size.height-sz.height)/2;
    frm.size=sz;
    self.imgPhoto.frame=frm;
    //    self.imgPhoto.alpha=0.25;
    [scroll addSubview:self.imgPhoto];
}


#pragma mark CGSize适配大小
- (CGSize)originSize:(CGSize)oSize fitInSize:(CGSize)fSize{
    if (oSize.height<=0 || oSize.width<=0) {
        return fSize;
    }
    
    float os=oSize.width/oSize.height;
    float fs=fSize.width/fSize.height;
    
    float ww,hh;
    if (os>fs) {
        ww=fSize.width;
        hh=oSize.height*fSize.width/oSize.width;
    }
    else {
        ww=oSize.width*fSize.height/oSize.height;
        hh=fSize.height;
    }
    
    return CGSizeMake(ww, hh);
}


#pragma mark - UIScrollViewDelegate
//返回需要缩放对象
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imgPhoto;
}

//缩放时保持居中
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;

    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ?scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    
    [self.imgPhoto setCenter:CGPointMake(xcenter, ycenter)];
}


-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(id)scrollView{
    if ([self.delegate respondsToSelector:@selector(PhotoViewerDelegate:)]) {
        [self.delegate PhotoViewerDelegate:self];
    }
}

@end