//
//  JGInfomationViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "JGInfomationViewController.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "SVProgressHUD.h"
#import "SBJson.h"
#import "MapViewController.h"
#import "ZhPMethod.h"
#import "HttpClient.h"
#import "UIImage+Utility.h"
#import "Store.h"
#import "AFNetworking.h"
#import "MADateView.h"
#import "CusTapGestureRecognizer.h"
#import "UIImage+Ex.h"
#import "NLImageCropper.h"
//键盘高度 = 216
#define KEYBOARD_HEIGHT 252

#define TAG_NAME    555
#define TAG_ADDRESS 556
#define TAG_NUMBER  557
#define TAG_SHORTNAME 558

#define kJGInfomationViewControllerTagArr  @"JGInfomationViewControllerTagArr"

#define kColumnName     @"columnName"
#define kOldValue       @"oldValue"
#define kNewValue       @"newValue"

typedef enum : NSUInteger {
    JGImageTypeHeader = 0, //机构门头照
    JGImageTypeLogo, //机构logo
} JGImageType;

@interface JGInfomationViewController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MapViewControllerDelegate,UIScrollViewDelegate>
{
    BOOL haveLogoImage;
    BOOL changeLogoImage;
    NSArray * tagArr;
    UIBarButtonItem *rightBarButton;
    
    
    JGImageType imageType; //辨别是机构门头照or机构logo   门头照 = 1   机构logo = 2  默认为0
}

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

/**
 *  header
 */
@property (weak, nonatomic) IBOutlet UILabel *noOkHeader;
@property (weak, nonatomic) IBOutlet UIView *headerStatus;
@property (weak, nonatomic) IBOutlet UIImageView *addHeader;
@property (weak, nonatomic) IBOutlet UIImageView *deleteHeader;
@property (weak, nonatomic) IBOutlet UIButton *deleteHeaderButton;

/**
 *  name
 */
@property (weak, nonatomic) IBOutlet UILabel *noOkName;
@property (weak, nonatomic) IBOutlet UIView *nameStatus;
@property (weak, nonatomic) IBOutlet UITextField *name;

/**
 *  shortName
 */
@property (weak, nonatomic) IBOutlet UITextField *shortName;
@property (weak, nonatomic) IBOutlet UIView *shortNameStatuView;

/**
 *  startName endName
 */
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;

/**
 *  address
 */
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UIView *addressStatus;
@property (weak, nonatomic) IBOutlet UILabel *noOkAddress;

/**
 *  location
 */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *lalongtStatus;
@property (weak, nonatomic) IBOutlet UILabel *noOkLocation;
- (IBAction)locationButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *loactionImageView;
/**
 *  tags
 */
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UIView *tagStatus;

@property (weak, nonatomic) IBOutlet UIView *tagStatusView2;


/**
 *  tel
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIView *phoneStatus;
@property (weak, nonatomic) IBOutlet UILabel *noOkTel;

/**
 *  logo
 */
@property (weak, nonatomic) IBOutlet UIImageView *addLogo;
@property (weak, nonatomic) IBOutlet UIImageView *deleteLogo;
@property (weak, nonatomic) IBOutlet UIView *logoStatus;
@property (weak, nonatomic) IBOutlet UILabel *noOkLogo;
- (IBAction)deleteTapClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
/**
 *  desc
 */
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *wordNumber;
@property (weak, nonatomic) IBOutlet UIView *descStatus;
@property (weak, nonatomic) IBOutlet UILabel *noOkDesc;

@property (nonatomic ,strong) BranchMapModel *branchMapModel;
@property (nonatomic ,strong) SaveBranchInfoModel *saveModel;


//test
@property (weak, nonatomic) IBOutlet UIScrollView *testScrollView;
@property (strong, nonatomic) IBOutlet UIView *testView;

@end

@implementation JGInfomationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"机构信息";

    if (IS_IPHONE_5 || IS_IPHONE_6) {
        [self.testScrollView addSubview:self.testView];
        [self.testScrollView setContentSize:self.testView.bounds.size];
    }else if (IS_IPHONE_6P)
    {
        [self.testScrollView addSubview:self.testView];
        [self.testScrollView setContentSize:CGSizeMake(self.testView.bounds.size.width, self.testView.bounds.size.height+33)];
    }
    
    //机构名称 设为不可编辑
    self.name.userInteractionEnabled = NO;
    
    //隐藏所有的审核功能
    self.headerStatus.hidden = YES;
    self.nameStatus.hidden = YES;
    self.shortNameStatuView.hidden = YES;
    self.addressStatus.hidden = YES;
    self.lalongtStatus.hidden = YES;
    self.tagStatus.hidden = YES;
    self.phoneStatus.hidden = YES;
    self.logoStatus.hidden = YES;
    self.descStatus.hidden = YES;
    
    //滑动隐藏键盘
    changeLogoImage = NO;
    
    rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    
    
    //定义手势
    [self defineTapGuesture];
    
    
    
    if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
        //请求服务器tag
        [self queryTag];
    }
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        tagArr = [QWUserDefault getObjectBy:kJGInfomationViewControllerTagArr];
        [self managerJGTag];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册监听键盘弹出 收起通知
    [self registerNotification];
     ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

/**
 *  定义隐藏键盘,添加图片,删除图片,跳转地图Viewcontrollor点击手势
 */
- (void)defineTapGuesture
{
    //如果键盘被调出   点击背景隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(hidenKeyboard)];
    [self.bgScrollView addGestureRecognizer:tap];
    
    //点击添加logo图片手势
    UITapGestureRecognizer * addLogoTap = [[UITapGestureRecognizer alloc] init];
    [self.addLogo addGestureRecognizer:addLogoTap];
    [addLogoTap addTarget:self action:@selector(addLogoTapClick:)];
    
    //点击添加门口照图片手势
    UITapGestureRecognizer * addHeaderTap = [[UITapGestureRecognizer alloc] init];
    [self.addHeader addGestureRecognizer:addHeaderTap];
    [addHeaderTap addTarget:self action:@selector(addHeaderImageTapClick:)];
    
    //跳转地图手势
    UITapGestureRecognizer * locationTap = [[UITapGestureRecognizer alloc] init];
    [self.loactionImageView addGestureRecognizer:locationTap];
    [locationTap addTarget:self action:@selector(locationButtonClick:)];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(JGInfomationViewControllerKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(JGInfomationViewControllerKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    rightBarButton.enabled = YES;
    if (!HIGH_RESOLUTION) {
        [self.bgScrollView setContentSize:CGSizeMake(APP_W,480 + 20 + 50 - 8 + 50 + 50)];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
    rightBarButton.enabled = YES;
}

#pragma mark
#pragma mark ---- 调出键盘and隐藏键盘 相关----

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hidenKeyboard];
}
//计算调出键盘时scrollView的偏移量
- (void)JGInfomationViewControllerKeyboardWillShow:(NSNotification *)notification
{
    CGFloat height = 0;
    CGFloat scrollHeight = 0;
    if ([self.name isEditing]) {
        height = 0;
        scrollHeight = 0;
    }else if ([self.shortName isEditing]){
        height = 0;
        scrollHeight = 0;
    } else if ([self.address isEditing]) {
        height = 0;
        scrollHeight = 0;
    }else if ([self.phoneNumber isEditing]){
        height = 80;
        if (HIGH_RESOLUTION) {
            scrollHeight = height + 50 + 70;
        }else{
            scrollHeight = height + 60 + 70;
        }
    }else{
        height = KEYBOARD_HEIGHT;
        if (HIGH_RESOLUTION) {
            scrollHeight = height + 50 + 70;
        }else{
            scrollHeight = height + 100 + 70;
        }
    }
    [self.bgScrollView setContentOffset:CGPointMake(0, scrollHeight) animated:YES];
}


- (void)JGInfomationViewControllerKeyboardWillHide:(NSNotification *)notification{
    [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//查询机构所有的标签
- (void)queryTag
{
    
    [Store SearchTagQueryWithParams:@{} success:^(id responseObj) {
        
        if (responseObj){
            tagArr = responseObj;
            [QWUserDefault setObject:tagArr key:kJGInfomationViewControllerTagArr];
            [self managerJGTag];
        }
        
    } failure:^(HttpException *e) {
        NSLog(@"%@->%@",NSStringFromClass([self class]),e);
    }];
}

- (void)managerJGTag
{
    //最多显示3个标签
    NSInteger count = tagArr.count > 3 ? 3 : tagArr.count;
    CGFloat x = APP_W-20;//动态设置每个button的x坐标
    for (int  i = (int)(count - 1); i>=0; i--)
//    for (int  i=0; i<count; i++)
    {
        StoreTagModel *tagModel = tagArr[i];
        NSString *tagTitle = tagModel.tag;
        
        CGFloat width = [QWGLOBALMANAGER getTextSizeWithContent:tagTitle WithUIFont:fontSystem(kFontS5) WithWidth:1000].width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //305 = 213 + 50 - 8 + 50
        x = x - width - 10;
        [button setFrame:CGRectMake(x, (50-19)/2, width+6, 19)];
    
        button.titleLabel.font = fontSystem(kFontS5);
        //标题颜色

        [button setTitleColor:RGBHex(qwColor8) forState:UIControlStateNormal];

        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.tag = [tagModel.key integerValue];
        [button setTitle:tagTitle forState:UIControlStateNormal];
        //背景图片
        [button setBackgroundImage:[[UIImage imageNamed:@"instatute_storeTag_selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]forState:UIControlStateSelected];
        [button setBackgroundImage:[[UIImage imageNamed:@"药店标签"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tagImageView addSubview:button];
    }
    [self showMessage];
}

//点击标签按钮 触发方法(0表示未选中,1表示选中)
- (void)tagButtonClick:(UIButton *)button{
//    if (self.tagStatus.hidden == NO) {
//        [SVProgressHUD showErrorWithStatus:kWaring51 duration:DURATION_SHORT];
//        return;
//    }
    NSString *keyString = [NSString stringWithFormat:@"%ld",(long)button.tag];
    if (button.selected)
    {
        [button setSelected:NO];
        //从选中的tag数组中删除该tag
        SaveItemModel *tagItem = self.saveModel.tags;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if (!StrIsEmpty(tagItem.newValue)) {
            NSArray *fenhao = [tagItem.newValue componentsSeparatedByString:@";"];
            if (fenhao.count > 0) {
                [arr addObjectsFromArray:fenhao];
            }
        }
        [arr removeObject:keyString];
        NSString *tagStr = [arr componentsJoinedByString:@";"];
        tagItem.newValue = tagStr;
    }else
    {
        [button setSelected:YES];
        SaveItemModel *tagItem = self.saveModel.tags;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if (!StrIsEmpty(tagItem.newValue)) {
            NSArray *fenhao = [tagItem.newValue componentsSeparatedByString:@";"];
            if (fenhao.count > 0) {
                [arr addObjectsFromArray:fenhao];
            }
        }
        [arr addObject:keyString];
        NSString *tagStr = [arr componentsJoinedByString:@";"];
        tagItem.newValue = tagStr;
    }
}


- (void)showMessage
{
    self.saveModel = [[SaveBranchInfoModel alloc] init];
    self.branchMapModel = [[BranchMapModel alloc] init];
    SaveItemModel *itemModel = nil;
    
    //机构门头照----------------------------------------------------------------------------
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *photoItem = self.branchInfoModel.photo;
    NSInteger photoStatus = [photoItem.status integerValue];
    switch (photoStatus) {
        case 0://0 正常
        {
            NSString *url = StrFromObj(photoItem.oldValue);
            [self.addHeader setImageWithURL:[NSURL URLWithString:url]];
            [self deleteHeaderOptionHidden:NO];
            itemModel.oldValue = photoItem.oldValue;
        }
            break;
        case 1://待审
        {
            NSString *url = StrFromObj(photoItem.newValue);
            [self deleteHeaderOptionHidden:NO];
//            self.headerStatus.hidden = NO;
            [self.addHeader setImageWithURL:[NSURL URLWithString:url]];
            self.addHeader.userInteractionEnabled = YES;
            itemModel.oldValue = photoItem.newValue;
        }
            break;
        case 2://2未完善
        {
            self.noOkHeader.hidden = NO;
            [self deleteHeaderOptionHidden:YES];
        }
            break;
        default:
            break;
    }
    self.saveModel.photo = itemModel;
    
    
    //机构名称 name----------------------------------------------------------------------------
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *nameItem = self.branchInfoModel.name;
    NSInteger nameStatus = [nameItem.status integerValue];
    switch (nameStatus) {
        case 0://0 正常
        {
            self.name.text = nameItem.oldValue;
            itemModel.oldValue = nameItem.oldValue;
            self.branchMapModel.title = nameItem.oldValue;
        }
            break;
        case 1://待审
        {
//            self.nameStatus.hidden = NO;
//            self.name.userInteractionEnabled = NO;
            self.name.text = nameItem.newValue;
            itemModel.oldValue = nameItem.newValue;
            self.branchMapModel.title = nameItem.newValue;
        }
            break;
        case 2://2未完善
        {
            self.noOkName.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.saveModel.name = itemModel;
    
    //机构简称 shortName----------------------------------------------------------------------------
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *shortNameItem = self.branchInfoModel.shortName;
    NSInteger shortNameStatus = [shortNameItem.status integerValue];
    switch (shortNameStatus) {
        case 0://0 正常
        {
            self.shortName.text = shortNameItem.oldValue;
            itemModel.oldValue = shortNameItem.oldValue;
        }
            break;
        case 1://待审
        {
//            self.shortNameStatuView.hidden = NO;
//            self.shortName.userInteractionEnabled = NO;
            self.shortName.text = shortNameItem.newValue;
            itemModel.oldValue = shortNameItem.newValue;
        }
            break;
        case 2://2未完善
        {
            
        }
            break;
        default:
            break;
    }
    self.saveModel.shortName = itemModel;
    
    //营业时间----------------------------------------------------------------------------
    
    //1.开始营业时间
    itemModel = [[SaveItemModel alloc] init];
    NSString *bizBegin = self.branchInfoModel.bizBegin;
    if (!StrIsEmpty(bizBegin)) {
        self.startTimeField.text = bizBegin;
        itemModel.oldValue = bizBegin;
    }
    self.saveModel.bizBegin = itemModel;
    
    
    //2.结束营业时间
    
    itemModel = [[SaveItemModel alloc] init];
    NSString *bizEnd = self.branchInfoModel.bizEnd;
    if (!StrIsEmpty(bizEnd)) {
        self.endTimeField.text = bizEnd;
        itemModel.oldValue = bizEnd;
    }
    self.saveModel.bizEnd = itemModel;
    
    
    //机构地址 address----------------------------------------------------------------------------
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *addressItem = self.branchInfoModel.address;
    NSInteger addressStatus = [addressItem.status integerValue];
    switch (addressStatus) {
        case 0://0 正常
        {
            self.address.text = addressItem.oldValue;
            itemModel.oldValue = addressItem.oldValue;
        }
            break;
        case 1://待审
        {
//            self.addressStatus.hidden = NO;
//            self.address.userInteractionEnabled = NO;
            self.address.text = addressItem.newValue;
            itemModel.oldValue = addressItem.newValue;
        }
            break;
        case 2://2未完善
        {
            self.noOkAddress.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.saveModel.address = itemModel;
    
    //latitude and longitude----------------------------------------------------------------------------
    BranchItemModel *latitudeItem = self.branchInfoModel.latitude;
    BranchItemModel *longitudeItem = self.branchInfoModel.longitude;
    
    NSInteger laStatus = [latitudeItem.status integerValue];
    NSInteger loStatus = [longitudeItem.status integerValue];
    //latitude
    NSString *oldLatitude = [self interceptStringWith:latitudeItem.oldValue];
    NSString *theNewLatitude = [self interceptStringWith:latitudeItem.newValue];
    //longitude
    NSString *oldLongitude = [self interceptStringWith:longitudeItem.oldValue];
    NSString *theNewLongitude = [self interceptStringWith:longitudeItem.newValue];
    
    SaveItemModel *laItemModel = [[SaveItemModel alloc] init];
    SaveItemModel *loItemModel = [[SaveItemModel alloc] init];
    if (laStatus == 1 || loStatus == 1) { //有一个待审
//        self.lalongtStatus.hidden = NO;
        self.locationLabel.text = [NSString stringWithFormat:@"经度:%@ 纬度%@",theNewLongitude,theNewLatitude];
        
        laItemModel.oldValue = latitudeItem.newValue;
        loItemModel.oldValue = longitudeItem.newValue;
        
        self.branchMapModel.latitude = latitudeItem.newValue;
        self.branchMapModel.longitude = longitudeItem.newValue;
        
    }else if(laStatus == 2 || loStatus == 2){ //有一个是未完善
        self.noOkLocation.hidden = NO;
        self.locationLabel.text = [NSString stringWithFormat:@"经度:%@ 纬度%@",oldLongitude,oldLatitude];
        laItemModel.oldValue = latitudeItem.oldValue;
        loItemModel.oldValue = longitudeItem.oldValue;
        
        self.branchMapModel.latitude = latitudeItem.oldValue;
        self.branchMapModel.longitude = longitudeItem.oldValue;
    }else{ //正常
        self.locationLabel.text = [NSString stringWithFormat:@"经度:%@ 纬度%@",oldLongitude,oldLatitude];
        laItemModel.oldValue = latitudeItem.oldValue;
        loItemModel.oldValue = longitudeItem.oldValue;
        
        self.branchMapModel.latitude = latitudeItem.oldValue;
        self.branchMapModel.longitude = longitudeItem.oldValue;
    }
    self.saveModel.latitude = laItemModel;
    self.saveModel.longitude = loItemModel;
    
    //机构标签----------------------------------------------------------------------------
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *tagsItem = self.branchInfoModel.tags;
    NSInteger tagsStatus = [tagsItem.status integerValue];
    switch (tagsStatus) {   //展示规则：如果是正常，就使用branchTagList里的数据；如果是审核中，就用tags model里的数据
        case 0://0 正常
        {
            NSArray  *branchTagList = self.branchInfoModel.branchTagList;
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i< branchTagList.count; i++) {
                StoreTagModel *tagModel = branchTagList[i];
                [arr addObject:tagModel.key];
            }
            NSString *tagStr = [arr componentsJoinedByString:@";"];
            itemModel.oldValue = tagStr;
            itemModel.newValue = tagStr;
        }
            break;
        case 1://待审
        {
//            self.tagStatus.hidden = NO;
            itemModel.oldValue = tagsItem.newValue;
            itemModel.newValue = tagsItem.newValue;
        }
            break;
        case 2://2未完善
        {
            self.tagStatusView2.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.saveModel.tags = itemModel;
    NSInteger tagCount = tagArr.count > 3 ? 3 : tagArr.count;
    //遍历两个arr,比较是否key相等,相等则选中,不相等则跳过
    NSArray *tagList = [itemModel.oldValue componentsSeparatedByString:@";"];
    if (tagList.count > 0) {
        for (NSString *key in tagList)
        {
            for (int i = 0; i<tagCount; i++)
            {
                StoreTagModel *tagModel = tagArr[i];
                if ([key isEqualToString:tagModel.key]) {
                    UIButton * button = (UIButton *)[self.view viewWithTag:[tagModel.key integerValue]];
                    [button setSelected:YES];
                }
            }
        }
    }

    
    
    //机构座机----------------------------------------------------------------------------
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *telItem = self.branchInfoModel.tel;
    NSInteger telStatus = [telItem.status integerValue];
    switch (telStatus) {
        case 0://0 正常
        {
            self.phoneNumber.text = telItem.oldValue;
            itemModel.oldValue = telItem.oldValue;
        }
            break;
        case 1://待审
        {
//            self.phoneStatus.hidden = NO;
//            self.phoneNumber.userInteractionEnabled = NO;
            self.phoneNumber.text = telItem.newValue;
            itemModel.oldValue = telItem.newValue;
        }
            break;
        case 2://2未完善
        {
            self.noOkTel.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.saveModel.tel = itemModel;
    
    //机构logo----------------------------------------------------------------------------
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *logoItem = self.branchInfoModel.logo;
    NSInteger logoStatus = [logoItem.status integerValue];
    switch (logoStatus) {
        case 0://0 正常
        {
            NSString *url = StrFromObj(logoItem.oldValue);
            [self.addLogo setImageWithURL:[NSURL URLWithString:url]];
            [self deleteOptionHidden:NO];
            itemModel.oldValue = logoItem.oldValue;
        }
            break;
        case 1://待审
        {
            NSString *url = StrFromObj(logoItem.newValue);
            [self deleteOptionHidden:NO];
//            self.logoStatus.hidden = NO;
            [self.addLogo setImageWithURL:[NSURL URLWithString:url]];
            self.addLogo.userInteractionEnabled = YES;
            itemModel.oldValue = logoItem.newValue;
        }
            break;
        case 2://2未完善
        {
            self.noOkLogo.hidden = NO;
            [self deleteOptionHidden:YES];
        }
            break;
        default:
            break;
    }
    self.saveModel.logo = itemModel;
    
    //机构简介----------------------------------------------------------------------------
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *descItem = self.branchInfoModel.desc;
    NSInteger descStatus = [descItem.status integerValue];
    switch (descStatus) {
        case 0://0 正常
        {
            NSString *desc = descItem.oldValue;
            self.textViewPlaceholder.text = @"";
            self.descTextView.text = desc;
            NSInteger length = [NSString stringWithFormat:@"%@",desc].length;
            self.wordNumber.text = [NSString stringWithFormat:@"%ld/80",(long)length];
            itemModel.oldValue = descItem.oldValue;
        }
            break;
        case 1://待审
        {
            NSString *desc = descItem.newValue;
//            self.descStatus.hidden = NO;
            self.textViewPlaceholder.text = @"";
//            self.descTextView.userInteractionEnabled = NO;
            self.descTextView.text = desc;
            NSInteger length = [NSString stringWithFormat:@"%@",desc].length;
            //            int len = 80-length;
            self.wordNumber.text = [NSString stringWithFormat:@"%ld/80",(long)length];
            itemModel.oldValue = descItem.newValue;
        }
            break;
        case 2://2未完善
        {
            self.noOkDesc.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.saveModel.desc = itemModel;
    
}

//截取字符串
- (NSString *)interceptStringWith:(NSString *)str
{
    NSRange range = [str rangeOfString:@"."];
    if (range.location != NSNotFound) {
        if (str.length - range.location - 1 > 3) {
            str = [str substringToIndex:range.location + 3];
        }
    }
    return str;
}

#pragma mark -------点击手势事件-------

- (void)addHeaderImageTapClick:(UITapGestureRecognizer *)tap
{
    [self hidenKeyboard];
    SaveItemModel *photoItem = self.saveModel.photo;
    
    if (photoItem.change == NO) {
        if (StrIsEmpty(photoItem.oldValue)) {
            //设置机构门头照
            imageType = JGImageTypeHeader;
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
            [actionSheet showInView:self.view];
        }else{
            [SJAvatarBrowser showImage:(UIImageView *)tap.view];
        }
    }else if(photoItem.change == YES){
        if (StrIsEmpty(photoItem.newValue)) {
            imageType = JGImageTypeHeader;
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
            [actionSheet showInView:self.view];
        }else{
            [SJAvatarBrowser showImage:(UIImageView *)tap.view];
        }
    }
//    if (self.headerStatus.hidden == NO) {
//        if (!StrIsEmpty(photoItem.oldValue)) {
//           [SJAvatarBrowser showImage:(UIImageView *)tap.view];
//        }
//    }else{
//        if (photoItem.change == NO) {
//            if (StrIsEmpty(photoItem.oldValue)) {
//                //设置机构门头照
//                imageType = JGImageTypeHeader;
//                UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
//                [actionSheet showInView:self.view];
//            }else{
//                [SJAvatarBrowser showImage:(UIImageView *)tap.view];
//            }
//        }else if(photoItem.change == YES){
//            if (StrIsEmpty(photoItem.newValue)) {
//                imageType = JGImageTypeHeader;
//                UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
//                [actionSheet showInView:self.view];
//            }else{
//                [SJAvatarBrowser showImage:(UIImageView *)tap.view];
//            }
//        }
//    }
}

- (void)addLogoTapClick:(UITapGestureRecognizer *)tap{
    [self hidenKeyboard];
    SaveItemModel *logoItem = self.saveModel.logo;
    
    if (logoItem.change == NO) {
        if (StrIsEmpty(logoItem.oldValue)) {
            //设置机构logo
            imageType = JGImageTypeLogo;
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
            [actionSheet showInView:self.view];
        }else{
            [SJAvatarBrowser showImage:(UIImageView *)tap.view];
        }
    }else if(logoItem.change == YES){
        if (StrIsEmpty(logoItem.newValue)) {
            //设置机构logo
            imageType = JGImageTypeLogo;
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
            [actionSheet showInView:self.view];
        }else{
            [SJAvatarBrowser showImage:(UIImageView *)tap.view];
        }
    }
    
//    if (self.logoStatus.hidden == NO) {
//        if (!StrIsEmpty(logoItem.oldValue)) {
//            [SJAvatarBrowser showImage:(UIImageView *)tap.view];
//        }
//    }else{
//        if (logoItem.change == NO) {
//            if (StrIsEmpty(logoItem.oldValue)) {
//                //设置机构logo
//                imageType = JGImageTypeLogo;
//                UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
//                [actionSheet showInView:self.view];
//            }else{
//                [SJAvatarBrowser showImage:(UIImageView *)tap.view];
//            }
//        }else if(logoItem.change == YES){
//            if (StrIsEmpty(logoItem.newValue)) {
//                //设置机构logo
//                imageType = JGImageTypeLogo;
//                UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
//                [actionSheet showInView:self.view];
//            }else{
//                [SJAvatarBrowser showImage:(UIImageView *)tap.view];
//            }
//        }
//    }
}


- (IBAction)deleteTapClick:(UIButton *)sender {
    [self hidenKeyboard];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = sender.tag;
    [alertView show];
}

- (void)deleteHeaderOptionHidden:(BOOL)hidden
{
    self.deleteHeaderButton.hidden = hidden;
    self.deleteHeader.hidden = hidden;
}

- (void)deleteOptionHidden:(BOOL)hidden
{
    self.deleteLogo.hidden = hidden;
    self.deleteButton.hidden = hidden;
}

#pragma mark
#pragma mark 地图代理返回值
- (void)pickUserLocation:(NSDictionary *)location
{
    NSString *latitude = [NSString stringWithFormat:@"%@",location[@"latitude"]];
    NSString *longitude = [NSString stringWithFormat:@"%@",location[@"longitude"]];
    self.branchMapModel.latitude = latitude;
    self.branchMapModel.longitude = longitude;
    latitude = [self interceptStringWith:latitude];
    longitude = [self interceptStringWith:longitude];
    self.locationLabel.text = [NSString stringWithFormat:@"经度:%@ 纬度%@",longitude,latitude];
    
    SaveItemModel *laItemModel = self.saveModel.latitude;
    laItemModel.newValue = latitude;
    self.saveModel.latitude = laItemModel;
    
    SaveItemModel *loItemModel = self.saveModel.longitude;
    loItemModel.newValue = longitude;
    self.saveModel.longitude = loItemModel;
}


#pragma mark
#pragma mark -------提示框代理--------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 1111:
        {
            [self updateBranch];
        }
            break;
        case 333: //机构门头照
        {
            if (buttonIndex == 1) {
                UIImage * defaultImage = [UIImage imageNamed:@"添加图片.png"];
                self.addHeader.image = defaultImage;
                SaveItemModel *headItem = self.saveModel.photo;
                if (headItem.change == YES) {
                    headItem.newValue = @"";
                    if (StrIsEmpty(headItem.oldValue)) {
                        headItem.change = NO;
                    }else{
                        headItem.change = YES;
                    }
                }else{
                    headItem.newValue = @"";
                    headItem.change = YES;
                }
                [self deleteHeaderOptionHidden:YES];
            }
        }
            break;
        case 444: //机构logo
        {
            if (buttonIndex == 1) {
                UIImage * defaultImage = [UIImage imageNamed:@"添加图片.png"];
                self.addLogo.image = defaultImage;
                SaveItemModel *logoItem = self.saveModel.logo;
                if (logoItem.change == YES) {
                    logoItem.newValue = @"";
                    if (StrIsEmpty(logoItem.oldValue)) {
                        logoItem.change = NO;
                    }else{
                        logoItem.change = YES;
                    }
                }else{
                    logoItem.newValue = @"";
                    logoItem.change = YES;
                }
                [self deleteOptionHidden:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.8f];
        return;
    }
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
        //相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex == 2){
        //取消
        return;
    }
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"Sorry,您的设备不支持该功能!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark ---------textFieldDelegate----------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.startTimeField || textField == self.endTimeField) {
        [self timeButtonClick:textField];
        return NO;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([QWGLOBALMANAGER judgeTheKeyboardInputModeIsEmojiOrNot:textField]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hidenKeyboard];
    return YES;
}


#pragma mark ---------textViewDelegate--------

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.textViewPlaceholder.text = @"请输入机构简介";
        self.wordNumber.text = [NSString stringWithFormat:@"0/80"];
    }else{
        self.textViewPlaceholder.text = @"";
        NSUInteger length = textView.text.length;
        self.wordNumber.text = [NSString stringWithFormat:@"%lu/80",(unsigned long)length];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([QWGLOBALMANAGER judgeTheKeyboardInputModeIsEmojiOrNot:textView]) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 80) {
        textView.text = [temp substringToIndex:80];
        self.wordNumber.text = @"80/80";
        self.textViewPlaceholder.text = @"";
        return NO;
    }
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hidenKeyboard];
}

#pragma mark --------相册相机图片回调--------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    /**
     *1.通过相册和相机获取的图片都在此代理中
     *
     *2.图片选择已完成,在此处选择传送至服务器
     */
    UIImage *aimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIView *view;
    if (HIGH_RESOLUTION) {
        view = self.testView;
    }else{
        view = self.view;
    }
    
        
        switch (imageType) {
            case JGImageTypeHeader:
            {
                
                [NLImageCropper imageSelecter:[UIApplication sharedApplication].keyWindow andImage:aimage callBack:^(UIImage *image) {
   
                    self.addHeader.image = image;
                    [self deleteHeaderOptionHidden:NO];
                    [self saveImage];
                }];
                
            }
                break;
            case JGImageTypeLogo:
            {
                
                self.addLogo.image = aimage;
                [self deleteOptionHidden:NO];
                [self saveImage];
            }
                break;
            default:
                break;
        }

   

    
}
#pragma mark --------保存--------
//保存
- (void)rightBarButtonClick{
    
    [self hidenKeyboard];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    //name
    if (StrIsEmpty(self.name.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入机构名称" duration:DURATION_SHORT];
        return;
    }else if (self.name.text.length > 42){
        [SVProgressHUD showErrorWithStatus:@"机构名称不能超过42个字" duration:DURATION_SHORT];
        return;
    }
    //shortName
    if (self.shortName.text.length > 10) {
        [SVProgressHUD showErrorWithStatus:@"机构简称不能超过10个字" duration:DURATION_SHORT];
        return;
    }
    //营业时间
    if (StrIsEmpty(self.startTimeField.text) || StrIsEmpty(self.endTimeField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入营业时间" duration:DURATION_SHORT];
        return;
    }
    
    if (!StrIsEmpty(self.startTimeField.text) && !StrIsEmpty(self.endTimeField.text)) {
        NSArray *startArr = [self.startTimeField.text componentsSeparatedByString:@":"];
        NSInteger startTime = [[startArr objectAtIndex:0] integerValue] * 60 + [[startArr objectAtIndex:1] integerValue];
        
        NSArray *endArr = [self.endTimeField.text componentsSeparatedByString:@":"];
        NSInteger endTime = [[endArr objectAtIndex:0] integerValue] * 60 + [[endArr objectAtIndex:1] integerValue];
        
        if (endTime <= startTime) {
            [SVProgressHUD showErrorWithStatus:@"请设置正确的营业时间" duration:DURATION_SHORT];
            return;
        }
    }
    //address
    if (StrIsEmpty(self.address.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入机构地址" duration:DURATION_SHORT];
        return;
    }else if (self.address.text.length > 50) {
        [SVProgressHUD showErrorWithStatus:@"机构地址不能超过50个字" duration:DURATION_SHORT];
        return;
    }
    //phoneNumber
    if (StrIsEmpty(self.phoneNumber.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入机构座机" duration:DURATION_SHORT];
        return;
    }else if (![QWGLOBALMANAGER isTelPhoneNumber:self.phoneNumber.text]){
        [SVProgressHUD showErrorWithStatus:@"机构座机格式不正确" duration:DURATION_SHORT];
        return;
    }
    //desc
    if (self.descTextView.text.length > 80) {
        [SVProgressHUD showErrorWithStatus:@"机构简介不能超过80字哦!" duration:DURATION_SHORT];
        return;
    }
    
    //判断
    //机构名称 name   布尔值:如果改变 bool = YES   否则 bool = NO
    SaveItemModel *itemMod = nil;
    
    //门头照----------------------------------------------------------------------------
    itemMod = self.saveModel.photo;
    BOOL photoChange = itemMod.change;
//    if (StrIsEmpty(itemMod.oldValue)) {
//        if (StrIsEmpty(itemMod.newValue)) {
//            photoChange = NO;
//        }else{
//            photoChange = YES;
//        }
//    }else{
//        if (StrIsEmpty(itemMod.newValue)) {
//            photoChange = NO;
//        }else if([itemMod.oldValue isEqualToString:itemMod.newValue]){
//            photoChange = NO;
//        }else{
//            photoChange = YES;
//        }
//    }
//    itemMod.change = photoChange;
    
    //name----------------------------------------------------------------------------
    itemMod = self.saveModel.name;
    BOOL nameChange = NO; //未改变
    
    if (StrIsEmpty(itemMod.oldValue)) {
        nameChange = YES;
    }else if([itemMod.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.name.text]]){
        nameChange = NO;
    }else{
        nameChange = YES;
    }
    itemMod.change = nameChange;
    
    //shortName----------------------------------------------------------------------------
    itemMod = self.saveModel.shortName;
    BOOL shortNameChange = NO;//未改变
    if (StrIsEmpty(itemMod.oldValue)) {
        if ([QWGLOBALMANAGER removeSpace:self.shortName.text].length == 0) {
            shortNameChange = NO;
        }else{
            shortNameChange = YES;
        }
    }else{
        if ([itemMod.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.shortName.text]]) {
            shortNameChange = NO;
        }else{
            shortNameChange = YES;
        }
    }
    itemMod.change = shortNameChange;
    
    //bizBegin----------------------------------------------------------------------------
    itemMod = self.saveModel.bizBegin;
    BOOL bizBeginChange = NO;
    if (StrIsEmpty(itemMod.oldValue)) {
        if (self.startTimeField.text.length == 0) {
            bizBeginChange = NO;
        }else{
            bizBeginChange = YES;
        }
    }else{
        if ([itemMod.oldValue isEqualToString:self.startTimeField.text]) {
            bizBeginChange = NO;
        }else{
            bizBeginChange = YES;
        }
    }
    itemMod.change = bizBeginChange;
    
    
    //bizEnd----------------------------------------------------------------------------
    itemMod = self.saveModel.bizEnd;
    BOOL bizEndChange = NO;
    if (StrIsEmpty(itemMod.oldValue)) {
        if (self.endTimeField.text.length == 0) {
            bizEndChange = NO;
        }else{
            bizEndChange = YES;
        }
    }else{
        if ([itemMod.oldValue isEqualToString:self.endTimeField.text]) {
            bizEndChange = NO;
        }else{
            bizEndChange = YES;
        }
    }
    itemMod.change = bizEndChange;
    
    //latitude----------------------------------------------------------------------------
    itemMod = self.saveModel.latitude;
    BOOL latitudeChange = NO;
    if (StrIsEmpty(itemMod.oldValue)) {
        if (StrIsEmpty(self.branchMapModel.latitude)) {
            latitudeChange = NO;
        }else{
            latitudeChange = YES;
        }
    }else{
        if (StrIsEmpty(self.branchMapModel.latitude)) {
            latitudeChange = YES;
        }else if ([itemMod.oldValue isEqualToString:self.branchMapModel.latitude]){
            latitudeChange = NO;
        }else{
            latitudeChange = YES;
        }
    }
    itemMod.change = latitudeChange;
    
    //longitude----------------------------------------------------------------------------
    itemMod = self.saveModel.longitude;
    BOOL longitudeChange = NO;
    if (StrIsEmpty(itemMod.oldValue)) {
        if (StrIsEmpty(self.branchMapModel.longitude)) {
            longitudeChange = NO;
        }else{
            longitudeChange = YES;
        }
    }else{
        if (StrIsEmpty(self.branchMapModel.longitude)) {
            longitudeChange = YES;
        }else if ([itemMod.oldValue isEqualToString:self.branchMapModel.longitude]){
            longitudeChange = NO;
        }else{
            longitudeChange = YES;
        }
    }
    itemMod.change = longitudeChange;
    
    //address----------------------------------------------------------------------------
    itemMod = self.saveModel.address;
    BOOL addressChange = NO;
    if (StrIsEmpty(itemMod.oldValue)) {
        addressChange = YES;
    }else if([itemMod.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.address.text]]){
        addressChange = NO;
    }else{
        addressChange = YES;
    }
    itemMod.change = addressChange;
    
    //tags----------------------------------------------------------------------------
    itemMod = self.saveModel.tags;
    BOOL tagsChange = NO;
    NSString *tagOld = itemMod.oldValue;
    NSString *tagNew  =itemMod.newValue;
    
    if (StrIsEmpty(tagOld) && StrIsEmpty(tagNew)) {
        tagsChange = NO;
    }else if (StrIsEmpty(tagOld) && !StrIsEmpty(tagNew)){
        tagsChange = YES;
    }else if (!StrIsEmpty(tagOld) && StrIsEmpty(tagNew)){
        tagsChange = YES;
    }else{
        if (tagOld.length != tagNew.length) {
            tagsChange = YES;
        }else{
            NSArray *tagOldArr = [tagOld componentsSeparatedByString:@";"];
            NSArray *tagNewArr = [tagNew componentsSeparatedByString:@";"];
            
            NSInteger tagOldNum = 0;
            for (int i = 0; i < tagOldArr.count ; i++) {
                NSString *strOld = tagOldArr[i];
                tagOldNum += [strOld integerValue];
            }
            
            NSInteger tagNewNum = 0;
            for (int i = 0; i < tagNewArr.count ; i++) {
                NSString *strNew = tagNewArr[i];
                tagNewNum += [strNew integerValue];
            }
            
            if (tagNewNum == tagOldNum) {
                tagsChange = NO;
            }else{
                tagsChange = YES;
            }
        }
    }
    itemMod.change = tagsChange;
    
    //tel----------------------------------------------------------------------------
    itemMod = self.saveModel.tel;
    BOOL telChange = NO;
    if (StrIsEmpty(itemMod.oldValue)) {
        telChange = YES;
    }else if([itemMod.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.phoneNumber.text]]){
        telChange = NO;
    }else{
        telChange = YES;
    }
    itemMod.change = telChange;
    
    //logo
    itemMod = self.saveModel.logo;
    BOOL logoChange = itemMod.change;
//    if (StrIsEmpty(itemMod.oldValue)) {
//        if (StrIsEmpty(itemMod.newValue)) {
//            logoChange = NO;
//        }else{
//            logoChange = YES;
//        }
//    }else{
//        if (StrIsEmpty(itemMod.newValue)) {
//            logoChange = NO;
//        }else if([itemMod.oldValue isEqualToString:itemMod.newValue]){
//            logoChange = NO;
//        }else{
//            logoChange = YES;
//        }
//    }
//    itemMod.change = logoChange;
    
    //desc----------------------------------------------------------------------------
    itemMod = self.saveModel.desc;
    BOOL descChange = NO;
    if (StrIsEmpty(itemMod.oldValue)) {
        if ([QWGLOBALMANAGER removeSpace:self.descTextView.text].length == 0) {
            descChange = NO;
        }else{
            descChange = YES;
        }
    }else{
        if ([itemMod.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.descTextView.text]]) {
            descChange = NO;
        }else{
            descChange = YES;
        }
    }
    itemMod.change = descChange;
    
    
    //如果全部与之前的数据相等，则说明维修改任何信息，给出提示
    if (!photoChange && !nameChange && !shortNameChange && !bizBeginChange && !bizEndChange && !latitudeChange && !longitudeChange && !addressChange && ! tagsChange && !telChange && !logoChange && !descChange)
    {
        [SVProgressHUD showErrorWithStatus:kWaring49 duration:DURATION_SHORT];
        return;
    }
    
    rightBarButton.enabled = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:kWaring48 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = 1111;
    [alertView show];
}

- (void)saveImage
{
    UIImage * image = nil;
    switch (imageType) {
        case JGImageTypeHeader:
        {
            image = self.addHeader.image;
        }
            break;
        case JGImageTypeLogo:
        {
            image = self.addLogo.image;
        }
            break;
        default:
            break;
    }
        if (image) {
            //传到服务器
            rightBarButton.enabled = NO;//794620 222652
//            image = [UIImage compressImage:image];
            image = [image imageByScalingToMinSize];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
            NSMutableArray *array = [NSMutableArray arrayWithObject:imageData];
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"type"] = @"3";
            [SVProgressHUD showWithStatus:@"图片上传中..." maskType:SVProgressHUDMaskTypeClear];
            [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
                [SVProgressHUD  dismiss];
                rightBarButton.enabled = YES;
                if (!StrIsEmpty(StrFromObj(responseObj[@"body"][@"url"]))) {
                    
                    switch (imageType) {
                        case JGImageTypeHeader:
                        {
                            SaveItemModel *headItem = self.saveModel.photo;
                            headItem.change = YES;
                            headItem.newValue = [NSString stringWithFormat:@"%@",responseObj[@"body"][@"url"]];
                        }
                            break;
                        case JGImageTypeLogo:
                        {
                            SaveItemModel *logoItem = self.saveModel.logo;
                            logoItem.change = YES;
                            logoItem.newValue = [NSString stringWithFormat:@"%@",responseObj[@"body"][@"url"]];
                        }
                            break;
                        default:
                            break;
                    }
                }
            } failure:^(HttpException *e) {
                [SVProgressHUD  dismiss];
                rightBarButton.enabled = YES;
            } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {

            }];
        }
}
- (BOOL)containsSubString:(NSString *)myString subString:(NSString*)subString {
    NSRange range = [myString rangeOfString:subString];
    return range.length != 0;
}
#pragma mark
#pragma mark post上传数据
- (void)updateBranch{
    
    [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeNone];
    
    NSMutableDictionary * setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = QWGLOBALMANAGER.configure.groupId;
    //营业时间
    if ([self containsSubString:self.startTimeField.text subString:@":"]) {
        setting[@"begin"] = StrFromObj(self.startTimeField.text);
    }
    if ([self containsSubString:self.endTimeField.text subString:@":"]) {
        setting[@"end"] = StrFromObj(self.endTimeField.text);
    }
    NSMutableArray *columnArr = [[NSMutableArray alloc] init];
    NSMutableArray *newValueArr = [[NSMutableArray alloc] init];
    NSMutableArray *oldValueArr = [[NSMutableArray alloc] init];
    
    SaveItemModel *itemMod = nil;
    
    //门头照
    itemMod = self.saveModel.photo;
    if (itemMod.change == YES) {
        NSString *url = itemMod.newValue;
        [columnArr addObject:@"branch.photo"];
        [oldValueArr addObject:itemMod.oldValue];
        if (StrIsEmpty(url)) {
            [newValueArr addObject:@""];
        }else{
            [newValueArr addObject:url];
        }
    }
    
    //名字
    itemMod = self.saveModel.name;
    if (itemMod.change == YES) {
        [columnArr addObject:@"branch.name"];
        [oldValueArr addObject:StrFromObj(itemMod.oldValue)];
        [newValueArr addObject:[QWGLOBALMANAGER removeSpace:self.name.text]];
    }
    
    //地址
    itemMod = self.saveModel.address;
    if (itemMod.change == YES) {
        
        [columnArr addObject:@"branch.addr"];
        [oldValueArr addObject:StrFromObj(itemMod.oldValue)];
        [newValueArr addObject:[QWGLOBALMANAGER removeSpace:self.address.text]];
    }
    
    //经度
    itemMod = self.saveModel.latitude;
    if (itemMod.change == YES) {
        [columnArr addObject:@"branch.latitude"];
        [oldValueArr addObject:StrFromObj(itemMod.oldValue)];
        [newValueArr addObject:StrFromObj(self.branchMapModel.latitude)];
    }
    
    //经度
    itemMod = self.saveModel.longitude;
    if (itemMod.change == YES) {
        [columnArr addObject:@"branch.longitude"];
        [oldValueArr addObject:StrFromObj(itemMod.oldValue)];
        [newValueArr addObject:StrFromObj(self.branchMapModel.longitude)];
    }
    
    //手机
    itemMod = self.saveModel.tel;
    if (itemMod.change == YES) {
        [columnArr addObject:@"branch.tel"];
        [oldValueArr addObject:StrFromObj(itemMod.oldValue)];
        [newValueArr addObject:[QWGLOBALMANAGER removeSpace:self.phoneNumber.text]];
    }
    
    ////////////////////////////////////////////
    //添加标签
    itemMod = self.saveModel.tags;
    if (itemMod.change == YES) {
        [columnArr addObject:@"branch.tags"];
        [oldValueArr addObject:itemMod.oldValue];
        [newValueArr addObject:itemMod.newValue];
        
    }
    
    //logo
    itemMod = self.saveModel.logo;
    if (itemMod.change == YES) {
        NSString *url = itemMod.newValue;
        [columnArr addObject:@"branch.logo"];
        [oldValueArr addObject:itemMod.oldValue];
        if (StrIsEmpty(url)) {
            [newValueArr addObject:@""];
        }else{
            [newValueArr addObject:url];
        }
    }
    
    ////////////////////////////////////////////
    //机构简介
    itemMod = self.saveModel.desc;
    if (itemMod.change == YES) {
        [columnArr addObject:@"branch.desc"];
        [oldValueArr addObject:itemMod.oldValue];
        [newValueArr addObject:[QWGLOBALMANAGER removeSpace:self.descTextView.text]];
    }
    
    //机构简称
    itemMod = self.saveModel.shortName;
    if (itemMod.change == YES) {
        [columnArr addObject:@"branch.shortName"];
        [oldValueArr addObject:itemMod.oldValue];
        [newValueArr addObject:[QWGLOBALMANAGER removeSpace:self.shortName.text]];
    }
    
#pragma mark
#pragma mark setting
    
    NSString *column = [columnArr componentsJoinedByString:SeparateStr];
    NSString *oldValue = [oldValueArr componentsJoinedByString:SeparateStr];
    NSString *newValue = [newValueArr componentsJoinedByString:SeparateStr];
    
    setting[@"column"] = column;
    setting[@"oldValue"] = oldValue;
    setting[@"newValue"] = newValue;
    rightBarButton.enabled = NO;
    NSLog(@"infoSetting = %@",setting);
    
    [Store UpdateBranchWithParams:setting success:^(id responseObj) {
        [SVProgressHUD dismiss];
        rightBarButton.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"修改成功！" duration:DURATION_SHORT];
//        [SVProgressHUD showSuccessWithStatus:kWaring50 duration:DURATION_LONG];
    } failure:^(HttpException *e) {
        [SVProgressHUD dismiss];
        rightBarButton.enabled = YES;
    }];
}

- (NSString *)checkStr:(id)obj
{
    if (([obj isKindOfClass:[NSString class]])&&[(NSString *)obj length]>0) {
        return (NSString *)obj;
    } else {
        return @"";
    }
}
- (IBAction)locationButtonClick:(id)sender {
    [self hidenKeyboard];
    if(QWGLOBALMANAGER.currentNetWork == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
        return;
    }
//    if (self.lalongtStatus.hidden == NO) {
//        [SVProgressHUD showErrorWithStatus:@"审核中不可修改" duration:DURATION_SHORT];
//        return;
//    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.branchInfoModel.provinceName forKey:@"provinceName"];
    [dic setObject:self.branchInfoModel.cityName forKey:@"cityName"];
    [dic setObject:self.branchInfoModel.countyName forKey:@"countryName"];
    [dic setObject:self.branchMapModel.title forKey:@"title"];
    [dic setObject:self.branchMapModel.latitude forKey:@"latitude"];
    [dic setObject:self.branchMapModel.longitude forKey:@"longitude"];
    
    MapViewController * mapView = [[MapViewController alloc] init];
    mapView.delegate = self;
    mapView.userLocationDic = [dic copy];
    [self.navigationController pushViewController:mapView animated:YES];
}

#pragma mark
#pragma mark 营业时间

- (void)timeButtonClick:(UITextField *)textField
{
    NSString *buttonTitle = textField.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [dateFormatter dateFromString:buttonTitle];
    
    NSInteger textFieldTag = textField.tag;
    __block JGInfomationViewController *weakSelf = self;
    [MADateView showDateViewWithDate:date Style:DateViewStyleTime CallBack:^(MyWindowClick buttonIndex, NSString *timeStr) {
        switch (buttonIndex) {
            case MyWindowClickForOK:
            {
                NSLog(@"time = %@",timeStr);
                switch (textFieldTag) {
                    case 333: //开始时间
                    {
                        weakSelf.startTimeField.text = timeStr;
                    }
                        break;
                    case 444: //结束时间
                    {
                        weakSelf.endTimeField.text = timeStr;
                    }
                    default:
                        break;
                }
            }
                break;
            case MyWindowClickForCancel:
            {
                NSLog(@"cancle!");
            }
                break;
            default:
                break;
        }
    }];
}


/**
 *  @brief 隐藏键盘
 */
- (void)hidenKeyboard
{
    [self.name resignFirstResponder];
    [self.address resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.descTextView resignFirstResponder];
    [self.shortName resignFirstResponder];
}

- (void)dealloc
{
    //移除监听键盘 调出与收起 notification
    [self unregisterNotification];
}

- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
