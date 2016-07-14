 //
//  SearchDefineViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-29.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "SearchDefineViewController.h"
#import "MyDefineCell.h"
#import "MGSwipeButton.h"
#import "SetLabelViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "Customer.h"
#import "CustomerModelR.h"
#import "MyCustomerBaseModel.h"
#import "ClientInfoViewController.h"
#import "QWGlobalManager.h"
#import "ClientMMDetailViewController.h"

@interface SearchDefineViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,changeLabeldelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *text_search;
@property (strong, nonatomic) IBOutlet UIView *searchContentV;

@property (strong, nonatomic) NSMutableArray *labelListArr;
@property (strong, nonatomic) NSMutableArray *hasChoseArr;
@property (strong, nonatomic) UIView *labelView;
@property (strong, nonatomic) NSMutableArray *mydefineArr;
@property (strong, nonatomic) UITableView *searchTable;
@property (strong, nonatomic) UILabel *mydefine;

@property (weak, nonatomic) IBOutlet UILabel *linelables;

@property (strong, nonatomic) UIImage *resizeImage;
@property (strong, nonatomic) UIImage *resizeImagetwo;

@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;

@end

@implementation SearchDefineViewController

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
    
    if (self.fromWechatMemberMarket) {
        self.title = @"搜索会员";
        self.text_search.placeholder = @"输入会员名称";
    } else {
        self.title = @"会员";
    }
    
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    CGRect lineLabelFrame = self.linelables.frame;

    lineLabelFrame.size.height = 0.5;
    self.linelables.frame = lineLabelFrame;
    self.linelables.backgroundColor = RGBHex(qwColor10);
    self.text_search.textColor=RGBHex(0x333333);
    self.labelView = [[UIView alloc] init];
    self.labelListArr = [NSMutableArray array];
    self.hasChoseArr = [NSMutableArray array];
    self.mydefineArr = [NSMutableArray array];
    self.mydefine = [[UILabel alloc] init];
    self.searchTable = [[UITableView alloc] init];
    [self.searchTable setSeparatorColor:[UIColor clearColor]];
    self.searchTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.resizeImage = [UIImage imageNamed:@"标签背景"];
    self.resizeImage = [self.resizeImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
    self.resizeImagetwo = [UIImage imageNamed:@"标签背景-兰"];
    self.resizeImagetwo = [self.resizeImagetwo resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
    [self setUpForDismissKeyboard];
    
    self.searchImageView.layer.cornerRadius = 5;
    self.searchImageView.layer.masksToBounds = YES;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self setUpSearchview];
    [self setUptableViewList];
    [self searchmydefineAction];
    
//    [self.text_search becomeFirstResponder];
    
}

//点击空白 收起键盘

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
    } completion:^(BOOL finished) {
        
    }];
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.text_search) {
        [self.text_search resignFirstResponder];
        [self searchmydefineAction];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.text_search) {
        textField.returnKeyType = UIReturnKeySearch;
        [self searchmydefineAction];
    }
}

//获取标签数据,并且布局

-(void)setUpSearchview{
    
    if (QWGLOBALMANAGER.currentNetWork != NotReachable) {
        
        CustomerTagsModelR *tagModelR = [CustomerTagsModelR new];
        tagModelR.token = QWGLOBALMANAGER.configure.userToken;
        [Customer QueryCustomerTagsWithParams:tagModelR success:^(id obj) {
            [self.labelListArr removeAllObjects];
            NSArray *arrTemp = (NSArray *)obj;
            self.labelListArr = [NSMutableArray arrayWithArray:arrTemp];
            //缓存标签数据
            [QWUserDefault setObject:self.labelListArr key:@"defineTag"];
            
            [self setUplabelTag];
        } failue:^(HttpException *e) {
            
        }];
        
    } else
    {
        self.labelListArr = [QWUserDefault getObjectBy:@"defineTag"];
        [self setUplabelTag];
    }
}




//标签的布局

-(void)setUplabelTag
{
    for (UIView *subView in self.labelView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat startWidth;
    CGFloat width;
    startWidth = 0 ;
    width = 0;
    int j = 0;
    self.labelView.userInteractionEnabled = YES;
    for (int i =0; i < self.labelListArr.count;  i++) {
        UIImageView *imageBg = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        CGSize constraint = CGSizeMake(20000.0f, 40.0f);
        NSAttributedString *questionAttributedText = [[NSAttributedString alloc]initWithString:[self.labelListArr objectAtIndex:i]
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        CGRect rect = [questionAttributedText boundingRectWithSize:constraint
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
        CGSize tempSize = rect.size;
        width= tempSize.width+startWidth;
        if (width > APP_W-27) {
            j++;
            startWidth = 0;
            width = 0;
        }
       
        label.frame = CGRectMake(12+startWidth, 40*j+10, tempSize.width+10,tempSize.height+5);
        label.layer.borderColor=[UIColor clearColor].CGColor;
        imageBg.frame = CGRectMake(10+startWidth, 40*j+8, tempSize.width+15,tempSize.height+10);
        startWidth  =label.frame.origin.x+tempSize.width+15;
        label.text = [self.labelListArr objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:13]];
        if (![self.hasChoseArr containsObject:label.text]) {
            label.textColor =[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
            label.backgroundColor = [UIColor clearColor];
            imageBg.image = self.resizeImage;
            
        }else{
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            imageBg.image = self.resizeImagetwo;
            
        }
        
        
        label.tag = i+1;
        imageBg.tag = 10001+i;
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGest =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseLabel:)];
     
        
        [label addGestureRecognizer:tapGest];
        [self.labelView addSubview:imageBg];
        [self.labelView addSubview:label];
        
    }
    
    self.labelView.frame = CGRectMake(0, 50, APP_W-10, j*40+32);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelView.frame)+15, APP_W, 10.0f)];
    backView.backgroundColor = RGBHex(qwColor11);
    
    [self.searchContentV addSubview:self.labelView];
    [self.searchContentV addSubview:backView];
    [self setUptableViewList];
}

#pragma mark ---- 点击label action ----

-(void)choseLabel:(UITapGestureRecognizer *)sender{
    
    [self.text_search resignFirstResponder];
    
    UILabel *label =(UILabel *) [self.view viewWithTag:sender.view.tag];
    
    UIImageView *imagevBG = (UIImageView *)[self.view viewWithTag:sender.view.tag+10000];
    if (self.hasChoseArr.count > 0) {
        if ([self.hasChoseArr containsObject:label.text]) {
            label.textColor = [UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0f];
            [self.hasChoseArr removeObject:label.text];
            label.backgroundColor = [UIColor clearColor];
          
            label.layer.borderColor= [UIColor clearColor].CGColor;
            imagevBG.image = self.resizeImage;
        }else{
            label.textColor = [UIColor whiteColor];
            [self.hasChoseArr addObject:label.text];
            label.backgroundColor = RGBHex(qwColor1);
            label.layer.borderWidth=2.0;
            label.layer.borderColor = RGBHex(qwColor1).CGColor;
            imagevBG.image = self.resizeImagetwo;
        }
    }else{
        label.backgroundColor = RGBHex(qwColor1);
        label.layer.borderWidth=2.0;
        label.layer.borderColor = RGBHex(qwColor1).CGColor;
        label.textColor = [UIColor whiteColor];
        [self.hasChoseArr addObject:[self.labelListArr objectAtIndex:sender.view.tag-1]];
        imagevBG.image = self.resizeImagetwo;
    }
    [self searchmydefineAction];
}

#pragma mark ---- 搜索Action ----

-(void)searchmydefineAction{
    CustomerQueryIndexModelR *modelR = [CustomerQueryIndexModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    NSString *tags =@"";
    if (self.hasChoseArr) {
        for (int i = 0; i < self.hasChoseArr.count; i++) {
            if (i == 0) {
                tags = [NSString stringWithFormat:@"%@",[self.hasChoseArr objectAtIndex:i]];
            }else{
                tags = [NSString stringWithFormat:@"%@%@%@",[self.hasChoseArr objectAtIndex:i],SeparateStr,tags];
            }
        }
    }
    modelR.tags = tags;
    modelR.item = [self.text_search.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (tags.length >0 || self.text_search.text.length >0) {
        
        
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            
            //有网搜索
            
            [Customer QueryCustomerWithParams:modelR success:^(id obj) {
                [self.mydefineArr removeAllObjects];
                NSDictionary *subDict = (NSDictionary *)obj;
                NSMutableArray *arr = (NSMutableArray *)[subDict allValues];
                for (NSMutableArray *subArr in arr) {
                    for (NSDictionary *dic in subArr) {
                        [self.mydefineArr addObject:dic];
                    }
                }
                if (self.mydefineArr.count > 0) {
                    self.mydefine.hidden = NO;
                    self.searchTable.hidden = NO;
                    [self.searchTable reloadData];
                }else{
                    self.mydefine.hidden = YES;
                    self.searchTable.hidden =YES;
                }
            } failure:^(HttpException *e) {
                
            }];
            
        }else
        {
            //断网搜索
            
            NSMutableArray *cacheArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            NSMutableDictionary *subDict = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"myDefineOne%@",QWGLOBALMANAGER.configure.groupId]];
            
            NSMutableArray *arr = (NSMutableArray *)[subDict allValues];
            for (NSMutableArray *subArr in arr) {
                for (NSDictionary *dic in subArr) {
                    [cacheArray addObject:dic];
                }
            }
            
            NSMutableArray *searchArr = [NSMutableArray arrayWithCapacity:100];
            int length = self.text_search.text.length;
            for (NSDictionary *dic in cacheArray)
            {
                BOOL isOK = YES;
                if (self.hasChoseArr.count == 0) {
                    isOK = YES;
                }else
                {
                    if ([dic[@"tags"] isEqualToString:@""]) {
                        isOK = NO;
                    }else
                    {
                        for (NSString * str in self.hasChoseArr)
                        {
                            BOOL pppp;
                            if ([dic[@"tags"] rangeOfString:str].location !=NSNotFound) {
                                pppp = YES;
                            }else
                            {
                                pppp = NO;
                            }
                            isOK = isOK && pppp;
                        }
                    }
                    
                }
                NSString *mstr = dic[@"indexName"];
                if (mstr.length >= length)
                {
                    mstr = [mstr substringToIndex:length];
                    
                    BOOL isContain = [mstr isEqualToString:self.text_search.text];
                    if (self.text_search.text.length == 0) {
                        isContain = YES;
                    }
                    
                    if ( isContain == YES && isOK == YES) {
                        NSLog(@"YES");
                        [searchArr addObject:dic];
                    }
                }
                
            }
            [self.mydefineArr removeAllObjects];
            self.mydefineArr = [NSMutableArray arrayWithArray:searchArr];
            
            if (self.mydefineArr.count > 0) {
                self.mydefine.hidden = NO;
                self.searchTable.hidden = NO;
                [self.searchTable reloadData];
            }else{
                self.mydefine.hidden = YES;
                self.searchTable.hidden =YES;
                
            }
        }
        
    }else{
        [self.mydefineArr removeAllObjects];
        self.mydefine.hidden = YES;
        self.searchTable.hidden =YES;
        [self.searchTable reloadData];
    }
}

- (BOOL)SearchString:(NSString *)searchString fromString:(NSString *)fromString
{
    if (!searchString || !fromString || (fromString.length == 0 && searchString.length != 0)) {
        return NO;
    }
    if (searchString.length == 0) {
        return YES;
    }
    
    NSUInteger location = [[fromString lowercaseString] rangeOfString:[searchString lowercaseString]].location;
    return (location == NSNotFound ? NO : YES);
}
-(void)setUptableViewList
{
    self.mydefine.frame = CGRectMake(10, self.labelView.frame.size.height+60+25, 110, 30);
    self.mydefine.text = @"会员";
    self.mydefine.textColor = RGBHex(qwColor8);
    self.mydefine.font = fontSystem(kFontS5);
    self.mydefine.textAlignment = NSTextAlignmentLeft;
    self.searchTable.frame = CGRectMake(0, self.mydefine.frame.origin.y + 35, APP_W, [UIScreen mainScreen].applicationFrame.size.height - NAV_H - self.searchContentV.frame.origin.y - 35 - self.mydefine.frame.origin.y);
    self.searchTable.delegate = self;
    self.searchTable.dataSource =self;
    self.searchTable.hidden = YES;
    self.mydefine.hidden = YES;
    [self.searchContentV addSubview:self.searchTable];
    [self.searchContentV addSubview:self.mydefine];
}

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mydefineArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyDefineCellIdentifier = @"MyDefineCellIdentifier";
    MyDefineCell*cell = (MyDefineCell *)[tableView dequeueReusableCellWithIdentifier:MyDefineCellIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"MyDefineCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:MyDefineCellIdentifier];
        cell = (MyDefineCell *)[tableView dequeueReusableCellWithIdentifier:MyDefineCellIdentifier];
    }else {
        cell.lbl_one.text = @"";
        cell.img_lblone.hidden = YES;
        cell.lbl_two.text = @"";
        cell.img_lbltwo.hidden = YES;
        cell.lbl_three.text = @"";
        cell.img_lblthree.hidden = YES;
        cell.lbl_four.text = @"";
        cell.img_lblfour.hidden = YES;
        cell.lbl_username.text= @"";
        [cell.img_user setImage:nil];
        [cell.img_logo setImage:nil];
    }
    
    cell.selectButton.hidden = YES;
    cell.backgroundColor=[UIColor whiteColor];
    NSString *title = self.mydefineArr[indexPath.row][@"indexName"];
    NSDictionary *grayAttrs = @{
                                NSForegroundColorAttributeName: RGBHex(qwColor1)};
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:title];
    [aString setAttributes:grayAttrs range:NSMakeRange(0,[[self.text_search.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length])];
    
    cell.lbl_username.attributedText = aString;
    [cell.img_user setImageWithURL:[NSURL URLWithString:self.mydefineArr[indexPath.row][@"headImgUrl"]] placeholderImage:[UIImage imageNamed:@"个人资料_头像"]];
    cell.img_user.layer.cornerRadius = 22.0f;
    cell.img_user.layer.masksToBounds = YES;
    if ([self.mydefineArr[indexPath.row][@"sex"]intValue ] == 0) {
        cell.lbl_gender.text = @"男";
        cell.lbl_gender.textColor = RGBHex(qwColor5);
    }else if ([self.mydefineArr[indexPath.row][@"sex"]intValue ] == 1){
        cell.lbl_gender.text = @"女";
        cell.lbl_gender.textColor = RGBHex(qwColor3);
    }else{
        cell.lbl_gender.text = @"";
    }
    
    NSMutableArray *labelArr = [NSMutableArray array];
    if( [self.mydefineArr[indexPath.row][@"tags"] length] > 0) {
        labelArr =[NSMutableArray arrayWithArray:
                   [self.mydefineArr[indexPath.row][@"tags"] componentsSeparatedByString:SeparateStr]];
    }
    
    NSMutableArray *showArr = [NSMutableArray array];
    showArr = [NSMutableArray arrayWithArray:self.hasChoseArr];
    for (int i = 0; i< self.hasChoseArr.count; i++) {
        if ([labelArr containsObject:[self.hasChoseArr objectAtIndex:i]]) {
            [labelArr removeObject:[self.hasChoseArr objectAtIndex:i]];
        }
    }
    
    for (int i = 0; i< labelArr.count; i++) {
        [showArr addObject:[labelArr objectAtIndex:i]];
    }
    
    //showArray 是白色标签， hasChooseArray 是绿色标签
    
    UIImage *resizeImage = nil;
    resizeImage = [UIImage imageNamed:@"标签背景"];
    resizeImage = [resizeImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
    UIImage *resizeImagetwo = nil;
    resizeImagetwo = [UIImage imageNamed:@"标签背景-兰"];
    resizeImagetwo = [resizeImagetwo resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
    
    if (IS_IPHONE_6P) {
        
        if (self.hasChoseArr.count == 1) {
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor whiteColor];
            cell.img_lblone.image = resizeImagetwo;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor  blackColor];
            cell.img_lbltwo.image = resizeImage;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor blackColor];
            cell.img_lblthree.image = resizeImage;
            
            cell.tagViewFour.hidden = NO;
            cell.lbl_four.textColor = [UIColor blackColor];
            cell.img_lblfour.image = resizeImage;
            
        }else if(self.hasChoseArr.count == 2){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor whiteColor];
            cell.img_lblone.image = resizeImagetwo;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor whiteColor];
            cell.img_lbltwo.image = resizeImagetwo;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor blackColor];
            cell.img_lblthree.image = resizeImage;
            
            cell.tagViewFour.hidden = NO;
            cell.lbl_four.textColor = [UIColor blackColor];
            cell.img_lblfour.image = resizeImage;
            
        }else if(self.hasChoseArr.count == 3){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor whiteColor];
            cell.img_lblone.image = resizeImagetwo;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor whiteColor];
            cell.img_lbltwo.image = resizeImagetwo;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor whiteColor];
            cell.img_lblthree.image =resizeImagetwo;
            
            cell.tagViewFour.hidden = NO;
            cell.lbl_four.textColor = [UIColor blackColor];
            cell.img_lblfour.image = resizeImage;
            
        }else if(self.hasChoseArr.count > 3){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor whiteColor];
            cell.img_lblone.image = resizeImagetwo;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor whiteColor];
            cell.img_lbltwo.image = resizeImagetwo;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor whiteColor];
            cell.img_lblthree.image =resizeImagetwo;
            
            cell.tagViewFour.hidden = NO;
            cell.lbl_four.textColor = [UIColor whiteColor];
            cell.img_lblfour.image =resizeImagetwo;
            
        }else{
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor blackColor];
            cell.img_lblone.image = resizeImage;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor  blackColor];
            cell.img_lbltwo.image = resizeImage;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor blackColor];
            cell.img_lblthree.image = resizeImage;
            
            cell.tagViewFour.hidden = NO;
            cell.lbl_four.textColor = [UIColor blackColor];
            cell.img_lblfour.image = resizeImage;
        }
        
        
        if (showArr.count == 1) {
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.hidden = NO;
            cell.img_lblone.hidden= NO;
            cell.lbl_one.text = [showArr objectAtIndex:0];
            cell.tagViewOneWidth.constant = [self getWidthWithtext:cell.lbl_one.text];
            
            cell.tagViewTwo.hidden = YES;
            cell.tagViewThree.hidden = YES;
            cell.tagViewFour.hidden = YES;
            
        }else if (showArr.count == 2){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.hidden = NO;
            cell.img_lblone.hidden= NO;
            cell.lbl_one.text = [showArr objectAtIndex:0];
            cell.tagViewOneWidth.constant = [self getWidthWithtext:cell.lbl_one.text];
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.hidden = NO;
            cell.img_lbltwo.hidden= NO;
            cell.lbl_two.text = [showArr objectAtIndex:1];
            cell.tagViewTwoWidth.constant = [self getWidthWithtext:cell.lbl_two.text];
            
            cell.tagViewThree.hidden = YES;
            cell.tagViewFour.hidden = YES;
            
        }else if(showArr.count == 3){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.hidden = NO;
            cell.img_lblone.hidden= NO;
            cell.lbl_one.text = [showArr objectAtIndex:0];
            cell.tagViewOneWidth.constant = [self getWidthWithtext:cell.lbl_one.text];
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.hidden = NO;
            cell.img_lbltwo.hidden= NO;
            cell.lbl_two.text = [showArr objectAtIndex:1];
            cell.tagViewTwoWidth.constant = [self getWidthWithtext:cell.lbl_two.text];
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.hidden = NO;
            cell.img_lblthree.hidden= NO;
            cell.lbl_three.text = [showArr objectAtIndex:2];
            cell.tagViewThreeWidth.constant = [self getWidthWithtext:cell.lbl_three.text];
            
            cell.tagViewFour.hidden = YES;
            
        }else if(showArr.count > 3){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.hidden = NO;
            cell.img_lblone.hidden= NO;
            cell.lbl_one.text = [showArr objectAtIndex:0];
            cell.tagViewOneWidth.constant = [self getWidthWithtext:cell.lbl_one.text];
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.hidden = NO;
            cell.img_lbltwo.hidden= NO;
            cell.lbl_two.text = [showArr objectAtIndex:1];
            cell.tagViewTwoWidth.constant = [self getWidthWithtext:cell.lbl_two.text];
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.hidden = NO;
            cell.img_lblthree.hidden= NO;
            cell.lbl_three.text = [showArr objectAtIndex:2];
            cell.tagViewThreeWidth.constant = [self getWidthWithtext:cell.lbl_three.text];
            
            cell.tagViewFour.hidden = NO;
            cell.lbl_four.hidden = NO;
            cell.img_lblfour.hidden = NO;
            cell.lbl_four.text = [showArr objectAtIndex:3];
            cell.tagViewFourWidth.constant = [self getWidthWithtext:cell.lbl_four.text];
            
        }else{
            cell.tagViewOne.hidden = YES;
            cell.lbl_one.hidden = YES;
            cell.img_lblone.hidden= YES;
            
            cell.tagViewTwo.hidden = YES;
            cell.lbl_two.hidden = YES;
            cell.img_lbltwo.hidden= YES;
            
            cell.tagViewThree.hidden = YES;
            cell.lbl_three.hidden = YES;
            cell.img_lblthree.hidden= YES;
            
            cell.tagViewFour.hidden = YES;
            cell.lbl_four.hidden = YES;
            cell.img_lblfour.hidden = YES;

        }
            

    }else
    {
        if (self.hasChoseArr.count == 1) {
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor whiteColor];
            cell.img_lblone.image = resizeImagetwo;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor  blackColor];
            cell.img_lbltwo.image = resizeImage;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor blackColor];
            cell.img_lblthree.image = resizeImage;
            
        }else if(self.hasChoseArr.count == 2){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor whiteColor];
            cell.img_lblone.image = resizeImagetwo;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor whiteColor];
            cell.img_lbltwo.image = resizeImagetwo;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor blackColor];
            cell.img_lblthree.image = resizeImage;
            
        }else if(self.hasChoseArr.count > 2){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor whiteColor];
            cell.img_lblone.image = resizeImagetwo;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor whiteColor];
            cell.img_lbltwo.image = resizeImagetwo;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor whiteColor];
            cell.img_lblthree.image =resizeImagetwo;
            
        }else{
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.textColor = [UIColor blackColor];
            cell.img_lblone.image = resizeImage;
            
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.textColor = [UIColor  blackColor];
            cell.img_lbltwo.image = resizeImage;
            
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.textColor = [UIColor blackColor];
            cell.img_lblthree.image = resizeImage;
        }
        
        
        if (showArr.count == 1) {
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.hidden = NO;
            cell.img_lblone.hidden= NO;
            cell.lbl_one.text = [showArr objectAtIndex:0];
            cell.tagViewOneWidth.constant = [self getWidthWithtext:cell.lbl_one.text];
            cell.tagViewTwo.hidden = YES;
            cell.tagViewThree.hidden = YES;
            cell.tagViewFour.hidden = YES;
            
        }else if (showArr.count == 2){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.hidden = NO;
            cell.img_lblone.hidden= NO;
            cell.lbl_one.text = [showArr objectAtIndex:0];
            cell.tagViewOneWidth.constant = [self getWidthWithtext:cell.lbl_one.text];
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.hidden = NO;
            cell.img_lbltwo.hidden= NO;
            cell.lbl_two.text = [showArr objectAtIndex:1];
            cell.tagViewTwoWidth.constant = [self getWidthWithtext:cell.lbl_two.text];
            cell.tagViewThree.hidden = YES;
            cell.tagViewFour.hidden = YES;
            
        }else if(showArr.count >2){
            
            cell.tagViewOne.hidden = NO;
            cell.lbl_one.hidden = NO;
            cell.img_lblone.hidden= NO;
            cell.lbl_one.text = [showArr objectAtIndex:0];
            cell.tagViewOneWidth.constant = [self getWidthWithtext:cell.lbl_one.text];
            cell.tagViewTwo.hidden = NO;
            cell.lbl_two.hidden = NO;
            cell.img_lbltwo.hidden= NO;
            cell.lbl_two.text = [showArr objectAtIndex:1];
            cell.tagViewTwoWidth.constant = [self getWidthWithtext:cell.lbl_two.text];
            cell.tagViewThree.hidden = NO;
            cell.lbl_three.hidden = NO;
            cell.img_lblthree.hidden= NO;
            cell.lbl_three.text = [showArr objectAtIndex:2];
            cell.tagViewThreeWidth.constant = [self getWidthWithtext:cell.lbl_three.text];
            cell.tagViewFour.hidden = YES;
            
        }else
        {
            cell.tagViewOne.hidden = YES;
            cell.lbl_one.hidden = YES;
            cell.img_lblone.hidden= YES;
            
            cell.tagViewTwo.hidden = YES;
            cell.lbl_two.hidden = YES;
            cell.img_lbltwo.hidden= YES;
            
            cell.tagViewThree.hidden = YES;
            cell.lbl_three.hidden = YES;
            cell.img_lblthree.hidden= YES;
            
            cell.tagViewFour.hidden = YES;

        }

    }
    
    
    if (AUTHORITY_ROOT) {
        cell.swipeDelegate = self;
    }
    return cell;
}

- (CGFloat)getWidthWithtext:(NSString *)text
{
    CGSize size1 =[text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(100, CGFLOAT_MAX)];
    return size1.width+17;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [self showError:@"网络异常，请稍后重试"];
        return;
    }

    if (QWGLOBALMANAGER.configure.storeType == 3) {
        ClientMMDetailViewController *info = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientMMDetailViewController"];
        info.customerId = self.mydefineArr[indexPath.row][@"passportId"];
        [self.navigationController pushViewController:info animated:YES];
    } else {
        ClientInfoViewController *info = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientInfoViewController"];
        info.dic = [self.mydefineArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:info animated:YES];
    }
}

#pragma mark ---- MGSwipeTableCellDelegate ----

-(NSArray*) swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    if (direction == MGSwipeDirectionRightToLeft) {
        return [self createRightButtons:2];
    }
    return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = nil;
    if (index == 1) {
        indexPath = [self.searchTable indexPathForCell:cell];
        SetLabelViewController *setVC = [[SetLabelViewController alloc] initWithNibName:@"SetLabelViewController" bundle:nil];
        NSDictionary *dicUser = self.mydefineArr[indexPath.row];
        MyCustomerInfoModel *modelCustomer = [MyCustomerInfoModel parse:dicUser];
        setVC.modelUserInfo = modelCustomer;
        setVC.delegate = self;
        [self.navigationController pushViewController:setVC animated:YES];
    }else{
        
        indexPath = [self.searchTable indexPathForCell:cell];
        CustomerDeleteModelR *modelR = [CustomerDeleteModelR new];
        modelR.token = QWGLOBALMANAGER.configure.userToken;
        modelR.customer = self.mydefineArr[indexPath.row][@"passportId"];
        __weak SearchDefineViewController *weakSelf = self;
        [Customer DeleteCustomerWithParams:modelR success:^(id obj) {
            [weakSelf.mydefineArr removeObject:weakSelf.mydefineArr[indexPath.row]];
            [weakSelf.searchTable reloadData];
            
        } failure:^(HttpException *e) {
        }];
    }
    return YES;
}

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"删除", @"设置"};
    UIColor * colors[2] = {[UIColor redColor], [UIColor grayColor]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}


-(void)changeLabeldelegate{
    
    [self searchmydefineAction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
