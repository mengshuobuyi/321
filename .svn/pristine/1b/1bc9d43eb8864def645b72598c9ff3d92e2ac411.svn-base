//
//  PhotoAlbum.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoAlbum.h"
#import "PhotoAlbumCell.h"
#import "PhotoAlbumList.h"
#import "PhotoViewer.h"
#import "QYPhotoAlbum.h"

//#import "SJAvatarBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>

static float kMargin = 4.f;
@interface PhotoAlbum ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PhotoAlbumCellDelegate>
{
    IBOutlet UICollectionView *collectMain;
    IBOutlet UIView *vBottom;
//    IBOutlet UILabel *lblSelected;
    IBOutlet UIButton *btnPreview,*btnOK;
    
    PhotoAlbumBlock photosBlock;
    void (^failureBlock)(NSError *error) ;
    
    /////////////////////////////////////

    NSArray *arrGroups;
    NSArray *arrPhotos;
    
    NSMutableArray *arrSelected;
    NSMutableArray *arrTemp;
    NSInteger maxPhotos;
}
@end

@implementation PhotoAlbum

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    
    [PhotosAlbum getPhotosGroupsBlock:^(NSArray *groups) {
        arrGroups=[groups copy];
//        DebugLog(@"%@",arrGroups);
        if (arrGroups.count) {
            ALAssetsGroup *grp=arrGroups.firstObject;
            [self showGroup:grp];
        }
    } failure:failureBlock];
    
    [self showNum];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=NO;

    [self naviLeftBottonImage:[UIImage imageNamed:@"nav_btn_back"] highlighted:[UIImage imageNamed:@"nav_btn_back_sel"] action:@selector(leftAction:)];
    [collectMain reloadData];
    [self showNum];
}



- (void)UIGlobal{
    [super UIGlobal];
    
    self.title=@"相机胶卷";
    collectMain.backgroundColor=[UIColor clearColor];
    [collectMain setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
    
    vBottom.backgroundColor=RGBAHex(qwColor4, .8f);
//    lblSelected.textColor=RGBHex(qwColor1);
//    btnSelect.backgroundColor=[UIColor clearColor];
    
 
    [btnPreview setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    [btnPreview setTitleColor:RGBHex(qwColor8) forState:UIControlStateDisabled];
    
    [btnOK setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    [btnOK setTitleColor:RGBHex(qwColor8) forState:UIControlStateDisabled];
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
#pragma mark - init
- (void)showGroup:(ALAssetsGroup*)grp{
    self.title=[grp valueForProperty:ALAssetsGroupPropertyName];
    [PhotosAlbum getPhotoAssetsByGroup:grp resultBlock:^(NSArray *arrAssets) {
        arrPhotos=arrAssets;
//        DebugLog(@"%i",arrPhotos.count);
        [collectMain reloadData];
        if (arrPhotos.count){
            [collectMain scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:arrPhotos.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            [self removeInfoView];
        }
        else {
            //没有照片
            [self showInfoView:@"相册为空" image:nil];
        }
    }];
}
#pragma mark - fct
- (void)selectPhotos:(NSInteger)maxNum selected:(NSMutableArray*)list block:(PhotoAlbumBlock)block failure:(void(^)(NSError *error))failure{
    failureBlock=failure;
    
    photosBlock=block;
    maxPhotos=maxNum;
    

    if (arrSelected==nil)
        arrSelected=[[NSMutableArray alloc]initWithArray:list];
   
    
    [self showNum];
}

- (void)showNum{
    NSString *str=[NSString stringWithFormat:@"完成（%lu）",(unsigned long)arrSelected.count];
    [btnOK setTitle:str forState:UIControlStateNormal];
    
    if (arrSelected.count>0) {
        btnPreview.enabled=YES;
        btnOK.enabled=YES;
    }
    else {
        btnPreview.enabled=NO;
        btnOK.enabled=NO;
    }
}

- (void)clean{
    arrGroups=nil;
    arrPhotos=nil;
    
//    [arrSelected removeAllObjects];
//    arrSelected=nil;
}

- (void)close{
    [self closeAction:nil];
}
#pragma mark - action
- (IBAction)closeAction:(id)sender{
    if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [PhotosAlbum clean];
            [self clean];
        }];
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [PhotosAlbum clean];
            [self clean];
        }];
    }
    
}

- (IBAction)leftAction:(id)sender{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
    PhotoAlbumList* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAlbumList"];

    CATransition *animation = [CATransition animation];
    [animation setDuration:.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];
    
    [vc showList:arrGroups block:^(ALAssetsGroup *grp) {

        [self showGroup:grp];
    }];
}

- (IBAction)OKAction:(id)sender{
    QWLOADING.showLoading;
    btnOK.enabled=NO;
    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:arrSelected.count];
    for (PhotoModel *mode in arrSelected) {
        [tmp addObject:mode.asset];
        mode.fullImage=nil;
    }
    [PhotosAlbum getFullImageByAssetList:tmp photoBlock:^(UIImage *fullResolutionImage) {
        UIImage *imgTmp=[PhotosAlbum photoToMin:fullResolutionImage];
        int i = 0;
        for (PhotoModel *mode in arrSelected) {
            if (mode.fullImage==nil) {
                mode.fullImage=imgTmp;
                break;
            }
            i++;
        }
        if ((i+1)==arrSelected.count) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [self closeAction:nil];
                               if (photosBlock) {
                                   photosBlock(arrSelected);
                               }
                               QWLOADING.closeLoading;
                           });
        }
        
    } failure:nil];
    
}

- (IBAction)previewAction:(id)sender{
    if (arrSelected.count==0) {
        return;
    }
    arrTemp=nil;
    arrTemp=[[NSMutableArray alloc]initWithCapacity:maxPhotos];
    for (PhotoModel *mode in arrSelected) {
        [arrTemp addObject:mode.asset];
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
//    PhotoPreView* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoPreView"];
    PhotoViewer* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoViewer"];
    vc.arrPhotos = arrTemp;
    vc.arrSelected= arrSelected;
    vc.maxPhotos=maxPhotos;
    vc.indexSelected = 0;
    vc.photosBlock=photosBlock;

    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --UICollectionView
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrPhotos.count;
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
    static NSString * CellIdentifier = @"kPhotoAlbumCell";
    PhotoAlbumCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    if (row<arrPhotos.count) {
        ALAsset *ass=[arrPhotos objectAtIndex:row];
        cell.imgPhoto.image=[UIImage imageWithCGImage:ass.thumbnail];
        cell.url=[ass.defaultRepresentation.url absoluteString];
        cell.index=row;
        cell.btnSelect.selected=NO;
        
        
        for (id mode in arrSelected) {
            
            if([mode isKindOfClass:[PhotoModel class]]){
                PhotoModel *model=(PhotoModel*)mode;
                if ([model.url isEqualToString:cell.url]) {
                    cell.btnSelect.selected=YES;
                    break;
                }
            }
            
        }
    }

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return AutoSize(101, 101);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float ss=AutoValue(kMargin);//kMargin*AUTOSIZE.autoSizeScale;
    return UIEdgeInsetsMake(ss, ss, ss, ss);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return AutoValue(kMargin);
}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //PhotoPreView
    NSInteger row=indexPath.row;
  
    if (row<arrPhotos.count) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
        PhotoViewer* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoViewer"];
        vc.arrPhotos = arrPhotos;
        vc.arrSelected= arrSelected;
        vc.maxPhotos=maxPhotos;
        vc.indexSelected = row;
        vc.photosBlock=photosBlock;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        /*
        arrTemp=nil;
        arrTemp=[[NSMutableArray alloc]initWithCapacity:maxPhotos];
        
        BOOL canAdd=YES;
        ALAsset *ass=[arrPhotos objectAtIndex:row];
        for (PhotoModel *mode in arrSelected) {
            [arrTemp addObject:mode.asset];
            
            if ([mode.url isEqualToString:[ass.defaultRepresentation.url absoluteString]]) {
                canAdd=NO;
            }
        }
        if (canAdd) {
            [arrTemp insertObject:ass atIndex:0];
        }
        vc.arrPhotos = arrTemp;
        
        vc.arrSelected= arrSelected;
        vc.maxPhotos=maxPhotos;
        vc.indexSelected = 0;
        vc.photosBlock=photosBlock;
     
        [self.navigationController pushViewController:vc animated:YES];
        */

    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - PhotoAlbumCellDelegate
- (void)PhotoAlbumCellDelegate:(PhotoAlbumCell*)cell{
    if (!cell.btnSelect.selected && arrSelected.count==maxPhotos ) {
        [self showError:[NSString stringWithFormat:@"最多可选择%d张照片",maxPhotos]];
        return;
    }
    if (cell.btnSelect.selected) {
        cell.btnSelect.selected=false;
        
        BOOL canMove=false;
        int i = 0;
        for (PhotoModel *mode in arrSelected) {
            if ([mode.url isEqualToString:cell.url]) {
                canMove=YES;
                break;
            }
            i++;
        }
        if (canMove) {
            [arrSelected removeObjectAtIndex:i];
        }
    }
    else {
        cell.btnSelect.selected=YES;
        PhotoModel *mode=[PhotoModel new];
        mode.thumbnail=cell.imgPhoto.image;
        mode.url=cell.url;
        
        if (cell.index<arrPhotos.count) {
            ALAsset *ass=[arrPhotos objectAtIndex:cell.index];
            mode.asset=ass;
            

        }
        [arrSelected addObject:mode];
    }
    
    [self showNum];
}
@end
