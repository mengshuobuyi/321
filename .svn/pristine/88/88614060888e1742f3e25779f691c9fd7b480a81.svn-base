//
//  HealthIndicatorDetailViewController.m
//  quanzhi
//
//  Created by xiezhenghong on 14-7-3.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "MarketDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "AddNewMarketActivityViewController.h"
#import "MarketingActivityViewController.h"
#import "System.h"
#import "SystemModel.h"
#import "SystemModelR.h"

@interface MarketDetailViewController ()
{
    float imageViewheight;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kly;

@property (strong, nonatomic) QueryActivityInfo *shareModelPassValue;

@end

@implementation MarketDetailViewController

- (id)init
{
    if (self = [super init])
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.widthcontraint.constant=APP_W;
    self.activiDic=[QueryActivityInfo new];
    imageViewheight=0;
    self.setimageViews.backgroundColor= RGBHex(qwColor4);
    self.scrollView.backgroundColor=RGBHex(qwColor4);
    if (iOSv7 && self.view.frame.origin.y==0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.contentLabel.textColor=RGBHex(qwColor7);
    self.titleLabel.textColor=RGBHex(qwColor6);
    if(self.previewMode == 1){
        self.title=@"预览门店海报";
        NSDateFormatter *formate=[[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy-MM-dd"];
        NSString *darte=[NSString stringWithFormat:@"%@",[formate stringFromDate:[NSDate date]]];
        self.dateLabel.text=darte;
        [self setSourceLabel];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(gotoback:)];
    }else{
        
        if(self.userType == USETYPE_PE) {
            self.navigationItem.rightBarButtonItem = nil;
            self.title = @"门店海报详情";
        }else if(self.userType == USETYPE_ME) {
            self.title = @"门店海报详情";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
        }else if(self.userType == USETYPE_XM){
            self.title = @"活动详情";
        }
    }
}

#pragma mark ---- 分享操作 ----

- (void)shareAction
{
    if (QWGLOBALMANAGER.currentNetWork==kNotReachable) {
        [self showError:kWaring12];
        return;
    }
    
    [QWGLOBALMANAGER statisticsEventId:@"s_mdhb_fx" withLable:@"门店海报-分享" withParams:nil];
    
    ShareContentModel *modelShare = [ShareContentModel new];
    modelShare.imgURL = self.shareModelPassValue.imgUrl;
    modelShare.typeShare = ShareTypeStorePoster;
    modelShare.shareID = [NSString stringWithFormat:@"%@%@%@",self.shareModelPassValue.activityId,SeparateStr,QWGLOBALMANAGER.configure.groupId];
    modelShare.title = self.shareModelPassValue.title;
    modelShare.content = self.shareModelPassValue.content;
    ShareSaveLogModel *modelR = [ShareSaveLogModel new];
    modelR.shareObj = @"6"; // 门店海报分享统计
    modelR.shareObjId = self.shareModelPassValue.activityId;
    modelR.city = @"";
    modelShare.modelSavelog = modelR;
    
    [self popUpShareView:modelShare];
    
    
    
    
}

- (void)setSourceLabel
{
    if ([self.infoDict.source intValue]==1) {
        self.lblSource.text = @"来源: 全维";
    } else if ([self.infoDict.source intValue]==2) {
        self.lblSource.text = @"来源: 商户";
    } else if ([self.infoDict.source intValue]==3) {
        self.lblSource.text = @"来源: 门店";
    } else {
        self.kly.priority = 601;
        self.dateLabel.textAlignment=NSTextAlignmentLeft;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageArrayUrl=[NSMutableArray array];
    [self getInfomation];
}

-(void)gotoback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeCons{

    if(imageViewheight!=0){
        CGFloat heightMIn=self.contentLabel.frame.size.height;
        //遍历view约束
        NSArray* constrains2 = self.setimageViews.constraints;
        for (NSLayoutConstraint* constraint in constrains2) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = imageViewheight;
            }
        }
        self.viewHeight.constant=imageViewheight+heightMIn+100;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if(imageViewheight!=0){
        CGFloat heightMIn=self.contentLabel.frame.size.height;
        //遍历view约束
        NSArray* constrains2 = self.setimageViews.constraints;
        for (NSLayoutConstraint* constraint in constrains2) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = imageViewheight;
            }
        }
        self.viewHeight.constant=imageViewheight+heightMIn+100;
    }
}

-(void)getInfomation{
    //预览模式
    if (self.userType==USETYPE_PE){
        if(self.infoDict.title) {
            self.contentLabel.text =[QWGLOBALMANAGER replaceSpecialStringWith:self.infoDict.content];
            self.dateLabel.text = [self.infoDict.publishTime substringToIndex:10];
            self.titleLabel.text = [QWGLOBALMANAGER replaceSpecialStringWith:self.infoDict.title];
            [self setSourceLabel];
            if([self.infoDict.imageSrc isKindOfClass:[UIImage class]]) {
                self.setimageViews.hidden = NO;
                [self getPreviewimages];
            }else{
                if(self.infoDict.imgs){
                    self.setimageViews.hidden = NO;
                    [self.imageArrayUrl addObjectsFromArray:self.infoDict.imgs];
                    [self getimages];
                }
            }
        }
    }else{
    QueryActivityR* modelR=[QueryActivityR new];
    modelR.activityId=self.infoDict.activityId;
//    modelR.groupId=QWGLOBALMANAGER.configure.groupId;
    [Activity GetActivityWithParams:modelR success:^(id UFModel){
        QueryActivityInfo *mode=(QueryActivityInfo *)UFModel;
        self.shareModelPassValue = mode;
        //body 为空（从后台物理删除了）
        if(mode.activityId==nil){
            [self newHistory];
            if (self.userType==USETYPE_XM){
                UIImageView *deleted=[[UIImageView alloc]initWithFrame:CGRectMake(APP_W-120, 100, 100, 100)];
                [deleted setImage:[UIImage imageNamed:@"bg-activity delete.PNG"]];
                [self.view addSubview:deleted];
            }
            return;
        }else{
            self.activiDic= mode;
            self.contentLabel.text = [QWGLOBALMANAGER replaceSpecialStringWith:mode.content];
            if(mode.publishTime&&mode.publishTime.length>9){
                self.dateLabel.text = [mode.publishTime substringToIndex:10];
            }

            if ([mode.source intValue]==1) {
                self.lblSource.text = @"来源: 全维";
            } else if ([mode.source intValue]==2) {
                self.lblSource.text = @"来源: 商户";
            } else if ([mode.source intValue]==3) {
                self.lblSource.text = @"来源: 门店";
            } else {
                self.kly.priority = 601;
                self.dateLabel.textAlignment=NSTextAlignmentLeft;
            }
            self.titleLabel.text = [QWGLOBALMANAGER replaceSpecialStringWith:mode.title];
            if (self.userType==USETYPE_XM){
                UIImageView *deleted=[[UIImageView alloc]initWithFrame:CGRectMake(APP_W-120, 100, 100, 100)];
                if([mode.deleted intValue]==1){
                    [deleted setImage:[UIImage imageNamed:@"bg-activity delete.PNG"]];
                    [self.view addSubview:deleted];
                }else{
                    if([mode.expired intValue]==1){
                        [deleted setImage:[UIImage imageNamed:@"bg-activity expired.PNG"]];
                        [self.view addSubview:deleted];
                    }
                }
            }
            if(mode.imgs.count==0) {
                self.setimageViews.hidden = YES;
            }else{
                self.setimageViews.hidden = NO;
                [self.imageArrayUrl addObjectsFromArray:mode.imgs];
                [self getimages];
            }
        }
    } failure:^(HttpException* e){
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];

    }
}



//图片的显示
-(void)getimages
{
    imageViewheight=0;
    for (int j=0; j<self.imageArrayUrl.count; j++) {
        UIImageView *imageView=[[UIImageView alloc] init];
        [self.setimageViews addSubview:imageView];
        __weak UIImageView *weakImgView = imageView;
        __weak MarketDetailViewController *weakSelf = self;
        QueryActivityImage *imageModel=(QueryActivityImage*)self.imageArrayUrl[j];
        NSURL *imageNewUrl=nil;
        if([imageModel isKindOfClass:[QueryActivityImage class]]){
            imageNewUrl=(NSURL*)imageModel.normalImg;
        }else{
            imageNewUrl=(NSURL*)self.imageArrayUrl[j][@"normalImg"];
        }
        [imageView setImageWithURL:imageNewUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            if (image.size.width>weakSelf.setimageViews.frame.size.width) {
                CGFloat imageh=image.size.height*weakSelf.setimageViews.frame.size.width/image.size.width;
                weakImgView.frame=CGRectMake(0,0+imageViewheight, weakSelf.setimageViews.frame.size.width, imageh);
                imageViewheight+=imageh+8;
            }else{
                weakImgView.frame=CGRectMake((weakSelf.setimageViews.frame.size.width-image.size.width)/2, 0+imageViewheight, image.size.width , image.size.height);;
                imageViewheight+=image.size.height+8;
            }
            [weakImgView setImage:image];
            [self changeCons];
        }];
    }
}
//预览模式的image
-(void)getPreviewimages{
    imageViewheight=0;
    UIImageView *imageView=[[UIImageView alloc] init];
    UIImage *image=self.infoDict.imageSrc;
    if (image.size.width>self.setimageViews.frame.size.width) {
        CGFloat imageh=image.size.height*self.setimageViews.frame.size.width/image.size.width;
        imageView.frame=CGRectMake(0,0+imageViewheight, self.setimageViews.frame.size.width, imageh);
        imageViewheight+=imageh+8;
    }else{
        imageView.frame=CGRectMake((self.setimageViews.frame.size.width-image.size.width)/2, 0+imageViewheight, image.size.width , image.size.height);;
        imageViewheight+=image.size.height+8;
    }
    [imageView setImage:image];
    [self.setimageViews addSubview:imageView];
    [self changeCons];

}

//物理删除了后台的数据，获取的时候只给他文字
-(void)newHistory{
    self.titleLabel.text = [QWGLOBALMANAGER replaceSpecialStringWith:self.infoNewDict.title];
    [self setSourceLabel];
    self.dateLabel.text = [self.infoNewDict.publishTime substringToIndex:10];
    self.contentLabel.text =[QWGLOBALMANAGER replaceSpecialStringWith:self.infoNewDict.content];
}


#pragma mark ---- 删除活动 2.2.2 暂时注释，改为分享 yyx ----

-(void)deleteMarketActivity:(id)sender{
    
    if (QWGLOBALMANAGER.currentNetWork==kNotReachable) {
        [self showError:kWaring12];
        return;
    }
    
    if (([self.infoDict.source intValue]==1)||([self.infoDict.source intValue]==2)) {
        [self showError:kWaring20];
        return;
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该门店海报吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    
    
}


#pragma mark ---------代理事件---------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        DeleteActivitysR *deleteR=[DeleteActivitysR new];
        deleteR.token=QWGLOBALMANAGER.configure.userToken;
        deleteR.activityId=self.infoDict.activityId;
        [Activity DeleteActivitWithParams:deleteR success:^(id resultOBJ) {
            [self showSuccess:kWaring29];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MarketActivityDelete" object:nil];
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIViewController *viewController=(UIViewController *)obj;
                if ([viewController isKindOfClass:[MarketingActivityViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                }else if(idx == (self.navigationController.viewControllers.count - 1)){
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        } failure:^(HttpException *e) {
        }];
    }
}





- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)dealloc{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
