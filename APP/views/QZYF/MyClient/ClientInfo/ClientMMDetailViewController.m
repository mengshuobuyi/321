//
//  ClientMMDetailViewController.m
//  wenYao-store
//
//  开通微商的会员详情
//  api/im/customer
//  Created by PerryChen on 5/16/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "ClientMMDetailViewController.h"
#import "ClientInfoCell.h"
#import "RatingView.h"
#import "Customer.h"
#import "CustomerModelR.h"
#import "CustomerModel.h"
#import "SJAvatarBrowser.h"
#import "MyCustomerBaseModel.h"
#import "SetLabelViewController.h"
#import "ClientOrderListViewController.h"
#import "ClientAppraiseListViewController.h"
#import "ConsultHistoryViewController.h"
#import "ChatViewController.h"
@interface ClientMMDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    int lblnamey;
    int lblnumby;
    int lblnicky;
}
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;

@property (strong, nonatomic) IBOutlet UIView *headerView;

//个人信息约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblNameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblnameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexImgeViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberTop;

//用户信息
@property (strong, nonatomic) IBOutlet UIImageView *img_head;
@property (strong, nonatomic) IBOutlet UILabel *lbl_definename;
@property (weak, nonatomic) IBOutlet UILabel *lbl_defineNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_defineNick;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;

//性别
@property (strong, nonatomic) IBOutlet UIImageView *img_sex;

//标签
@property (strong, nonatomic) UIImage *resizeImage;
@property (strong, nonatomic) MyCustomerInfoModel *modelCustomerInfo;
@property (strong, nonatomic) CustomerCountListModel *countModel;

@property (strong, nonatomic) UIView *tagBgView;
@property (strong, nonatomic) NSMutableArray *titleArray;

@property (strong, nonatomic) UILabel *footerSource;

@end

@implementation ClientMMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详细资料";
    
    self.view.backgroundColor = RGBHex(qwColor11);
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"新设置标签"]style:UIBarButtonItemStylePlain target:self action:@selector(setremarkAction)];
    
    if(AUTHORITY_ROOT) {
        self.navigationItem.rightBarButtonItem = rightBtn;
//        self.titleArray = [@[@"订单",@"评价",@"咨询",@"手机号"] mutableCopy];
    }else
    {
//        self.titleArray = [@[@"订单",@"评价",@"手机号"] mutableCopy];
    }
    
    
    [self setUpTableFooterView];
    self.tbViewContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置标签
    self.resizeImage = [UIImage imageNamed:@"标签背景"];
    self.resizeImage = [self.resizeImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 8, 10, 8) resizingMode:UIImageResizingModeStretch];
    
    //设置头像
    self.img_head.layer.masksToBounds = YES;
    self.img_head.layer.cornerRadius = 5.0f;
    self.img_head.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(headerImageViewClick:)];
    [self.img_head addGestureRecognizer:tap];
    
    self.view.userInteractionEnabled = YES;
    self.tbViewContent.userInteractionEnabled = YES;
    
    lblnamey=self.lbl_definename.frame.origin.y;
    lblnumby=self.lbl_defineNumber.frame.origin.y;
    lblnicky=self.lbl_defineNick.frame.origin.y;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //店员主账号与子账号区别
    if(AUTHORITY_ROOT) {
//        self.navigationItem.rightBarButtonItem = rightBtn;
        self.titleArray = [@[@"订单",@"评价",@"咨询",@"手机号"] mutableCopy];
    }else
    {
        self.titleArray = [@[@"订单",@"评价",@"手机号"] mutableCopy];
    }
    [self getViewListInfo];
    [self getCountList];
    [self.tbViewContent reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableFooterView
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 44)];
    footer.backgroundColor = [UIColor clearColor];
    self.footerSource = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
    self.footerSource.text = @"";
    self.footerSource.textColor = RGBHex(qwColor8);
    self.footerSource.font = fontSystem(kFontS4);
    [footer addSubview:self.footerSource];
    self.tbViewContent.tableFooterView = footer;
}

#pragma mark ----
#pragma mark ---- 点击头像看大图

- (void)headerImageViewClick:(UITapGestureRecognizer*)sender{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ----
#pragma mark ---- 请求个人信息数据

-(void)getViewListInfo
{
    CustomerDetailInfoModelR *modelInfoR = [CustomerDetailInfoModelR new];
    modelInfoR.token = QWGLOBALMANAGER.configure.userToken;
    modelInfoR.customer = self.customerId;
    __weak ClientMMDetailViewController *weakSelf = self;
    
    [Customer QueryCustomerInfoWithParams:modelInfoR success:^(id obj) {
        MyCustomerInfoModel *modelInfo = (MyCustomerInfoModel *)obj;
        
        if ([modelInfo.apiStatus integerValue] == 0) {
            weakSelf.modelCustomerInfo = modelInfo;
            NSString *strMobile = modelInfo.mobile;
            NSString *strname = modelInfo.remark;
            NSString *strNick= modelInfo.nick;
            NSString *strLevel  = @"";
            strLevel = [NSString stringWithFormat:@"V%@",modelInfo.lvl];
            if (![strMobile isEqualToString:@""]) {
                strMobile = [strMobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            } else {
                // 去除手机号
                [self.titleArray removeLastObject];
            }
            NSDictionary *orangeAttrs = @{NSForegroundColorAttributeName: RGBHex(qwColor2)};
            NSDictionary *grayAttrs = @{NSForegroundColorAttributeName: RGBHex(qwColor8)};
            NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:@""];
            NSAttributedString *strCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",strLevel] attributes:orangeAttrs];
            NSAttributedString *strPlace = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"等级 "] attributes:grayAttrs];
            [strContent appendAttributedString:strPlace];
            [strContent appendAttributedString:strCount];
            
            NSString *lblFirst=@"";
            if (strname.length==0&&strNick.length==0) {
                // 既没有名字也没有昵称，则将手机号居中显示
                lblFirst=strMobile;
                weakSelf.lblnameTop.constant = lblnumby;
                weakSelf.sexImgeViewTop.constant = lblnumby;
                weakSelf.lbl_defineNick.hidden=YES;
                weakSelf.lbl_defineNumber.hidden=YES;
            }else if (strname.length!=0&&strNick.length==0){
                // 有名字没昵称
                lblFirst=strname;
                weakSelf.lblnameTop.constant=lblnamey+8;
                weakSelf.sexImgeViewTop.constant=lblnamey+8;
                weakSelf.numberTop.constant=lblnumby+8;
                
//                weakSelf.lbl_defineNumber.text=[NSString stringWithFormat:@"手机号:%@",strMobile];
                weakSelf.lbl_defineNumber.attributedText = strContent;
                weakSelf.lbl_defineNick.hidden=YES;
                weakSelf.lbl_defineNumber.hidden=NO;
            }else if(strname.length==0&&strNick.length!=0){
                // 有昵称名字
                lblFirst=strNick;
                weakSelf.lblnameTop.constant=lblnamey+8;
                weakSelf.sexImgeViewTop.constant=lblnamey+8;
                weakSelf.numberTop.constant=lblnumby+8;
//                weakSelf.lbl_defineNumber.text=[NSString stringWithFormat:@"手机号:%@",strMobile];
                weakSelf.lbl_defineNumber.attributedText = strContent;
                weakSelf.lbl_defineNick.hidden=YES;
            }else{
                // 有昵称有名字
                lblFirst=strname;
                weakSelf.lblnameTop.constant=lblnamey;
                weakSelf.sexImgeViewTop.constant=lblnamey;
                weakSelf.numberTop.constant=lblnumby;
//                weakSelf.lbl_defineNumber.text=[NSString stringWithFormat:@"手机号:%@",strMobile];
                weakSelf.lbl_defineNumber.attributedText = strContent;
                weakSelf.lbl_defineNick.text=[NSString stringWithFormat:@"昵称:%@",strNick];
                weakSelf.lbl_defineNick.hidden=NO;
            }
            
            CGSize size = [lblFirst sizeWithFont:fontSystem(kFontS3) constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)];
            self.lblNameWidth.constant = size.width+2;
            weakSelf.lbl_definename.text =lblFirst;
            
            [weakSelf.img_head setImageWithURL:[NSURL URLWithString:modelInfo.headImgUrl] placeholderImage:[UIImage imageNamed:@"个人资料_头像"]];
            weakSelf.img_head.layer.cornerRadius = 25.0f;
            weakSelf.img_head.layer.masksToBounds = YES;
            if ([modelInfo.sex intValue] == 0) {
                weakSelf.lblGender.text = @"男";
                weakSelf.lblGender.textColor = RGBHex(qwColor5);
            }else if([modelInfo.sex intValue] == 1){
                weakSelf.lblGender.text = @"女";
                weakSelf.lblGender.textColor = RGBHex(qwColor3);
            }else{
                weakSelf.lblGender.text = @"";
            }
            
            
            
            // 来源
            self.footerSource.text = [NSString stringWithFormat:@"来源: %@",modelInfo.sourceDescription];
            
            NSArray *labelArr = [modelInfo.tags componentsSeparatedByString:SeparateStr];
            NSString * str = modelInfo.tags;
            if (str.length == 0) {
                labelArr  = [NSArray array];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setlabel:labelArr andNcdArr:modelInfo.ncdTags];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tbViewContent reloadData];
            });
        }else
        {
            [SVProgressHUD showErrorWithStatus:modelInfo.apiMessage duration:0.8];
        }
        
    } failue:^(HttpException *e) {
        
    }];
}

#pragma mark ----
#pragma mark ---- 获取列表的count

- (void)getCountList
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    setting[@"passportId"] = self.customerId;
    
    [Customer CustomerCountListWithParams:setting success:^(id obj) {
        
        self.countModel = (CustomerCountListModel *)obj;
        if ([self.countModel.apiStatus integerValue] == 0) {
            [self.tbViewContent reloadData];
        }else
        {
            self.tbViewContent.hidden = YES;
            [SVProgressHUD showErrorWithStatus:self.countModel.apiMessage duration:0.8];
        }
        
    } failue:^(HttpException *e) {
        
    }];
}

#pragma mark ----
#pragma mark ---- 设置标签的布局

-(void)setlabel:(NSArray *)arr andNcdArr:(NSArray *)arrNcd{
    
    [self.tagBgView removeFromSuperview];
    if (self.tagBgView) {
        self.tagBgView = nil;
    }
    self.tagBgView = [[UIView alloc] init];
    CGFloat startWidth;
    CGFloat width;
    startWidth = 0 ;
    width = 0;
    int j = 0;
    for (int i =0; i < arr.count;  i++) {
        UIImageView *imageBg = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        CGSize constraint = CGSizeMake(20000.0f, 40.0f);
        NSAttributedString *questionAttributedText = [[NSAttributedString alloc]initWithString:[arr objectAtIndex:i]
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        CGRect rect = [questionAttributedText boundingRectWithSize:constraint
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
        CGSize tempSize = rect.size;
        width= tempSize.width+startWidth;
        if (width > APP_W-35) {
            j++;
            startWidth = 0;
            width = 0;
        }
        label.frame = CGRectMake(20+startWidth, 40*j+10, tempSize.width+10,tempSize.height+5);
        imageBg.frame = CGRectMake(15+startWidth, 40*j+7, tempSize.width+20,tempSize.height+10);
        
        imageBg.image =  self.resizeImage;
        startWidth  =label.frame.origin.x+tempSize.width+15;
        label.text = [arr objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:13]];
        label.textColor = [UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0f];
        label.tag = i+1;
        label.userInteractionEnabled = YES;
        [self.tagBgView addSubview:imageBg];
        [self.tagBgView addSubview:label];
        
    }
    CGFloat heightLabel = 44+j*40;
    if (arr.count > 0) {
        heightLabel = 44 + j*40;
    } else {
        heightLabel = 0;
    }
    
    
    if (arrNcd.count > 0) {
        if (arr.count > 0) {
            UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightLabel, APP_W, 0.5)];
            seperatorLine.backgroundColor = RGBHex(qwColor10);
            [self.tagBgView addSubview:seperatorLine];
        } else {
            
        }

        heightLabel += 1;
        startWidth = 0 ;
        width = 0;
        int k = 0;
        for (int i =0; i < arrNcd.count;  i++) {
            MyCustomerNcdLabelModel *modelN = arrNcd[i];
            UIImageView *imageBg = [[UIImageView alloc] init];
            UILabel *label = [[UILabel alloc] init];
            CGSize constraint = CGSizeMake(20000.0f, 40.0f);
            NSAttributedString *questionAttributedText = [[NSAttributedString alloc]initWithString:modelN.ncdName
                                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            CGRect rect = [questionAttributedText boundingRectWithSize:constraint
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                               context:nil];
            CGSize tempSize = rect.size;
            width= tempSize.width+startWidth;
            if (width > APP_W-35) {
                k++;
                startWidth = 0;
                width = 0;
            }
            label.frame = CGRectMake(20+startWidth, 40*k+10+heightLabel, tempSize.width+10,tempSize.height+5);
            imageBg.frame = CGRectMake(15+startWidth, 40*k+7+heightLabel, tempSize.width+20,tempSize.height+10);
            
            imageBg.image =  self.resizeImage;
            startWidth  =label.frame.origin.x+tempSize.width+15;
            label.text = modelN.ncdName;
            label.textAlignment = NSTextAlignmentCenter;
            [label setFont:[UIFont systemFontOfSize:13]];
            label.textColor = [UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0f];
            label.tag = i+1;
            label.userInteractionEnabled = YES;
            [self.tagBgView addSubview:imageBg];
            [self.tagBgView addSubview:label];
        }
        heightLabel += 44+k*40;
    }
    self.tagBgView.frame = CGRectMake(0, 80, APP_W, heightLabel);
    
    self.tagBgView.backgroundColor = [UIColor whiteColor];
    
//    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
//    titleLabel.text  = @"标签";
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.textColor = RGBHex(qwColor8);
//    [titleLabel setFont:fontSystem(kFontS5)];
//    [self.tagBgView addSubview:titleLabel];
    
    if (arr.count == 0 && arrNcd.count == 0) {
        self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, 75+self.tagBgView.frame.size.height);
    } else {
        self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, 75+self.tagBgView.frame.size.height+10);
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.headerView addSubview:self.tagBgView];
    } completion:^(BOOL finished) {
        
    }];
    
    self.tbViewContent.tableHeaderView = self.headerView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tbViewContent reloadData];
    });
}


#pragma makr - UITableView Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClientInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.title.text = self.titleArray[indexPath.row];
    cell.constraintContentTrail.constant = 29.0f;
    cell.content.textColor = RGBHex(qwColor8);
    cell.content.font = fontSystem(kFontS5);
    cell.imgViewRightArrow.hidden = NO;
    if (AUTHORITY_ROOT) {
        
        if (indexPath.row == 0) {
            cell.content.text = [NSString stringWithFormat:@"共%d单",[self.countModel.orderCount intValue]];//[NSString stringWithFormat:@"共%d次咨询",[self.countModel.consultCount intValue]];
        }else if (indexPath.row == 1){  // 点赞
            cell.content.text = [NSString stringWithFormat:@"共%d条",[self.countModel.appraiseCounts intValue]];//[NSString stringWithFormat:@"共%d笔订单",[self.countModel.orderCount intValue]];
        }else if (indexPath.row == 2){  // 咨询
            cell.content.text = [NSString stringWithFormat:@""];//[NSString stringWithFormat:@"共%d条评价",[self.countModel.appraiseCounts intValue]];
        } else if (indexPath.row == 3) {
            cell.content.text = self.modelCustomerInfo.mobile;
            cell.constraintContentTrail.constant = 15.0f;
            cell.content.textColor = RGBHex(qwColor7);
            cell.content.font = fontSystem(kFontS11);
            cell.imgViewRightArrow.hidden = YES;
        }
        
    }else
    {
        if (indexPath.row == 0) {
            cell.content.text = [NSString stringWithFormat:@"共%d单",[self.countModel.orderCount intValue]];
        }else if (indexPath.row == 1){
            cell.content.text = [NSString stringWithFormat:@"共%d条",[self.countModel.appraiseCounts intValue]];
        }else if (indexPath.row == 2) {
            cell.content.text = self.modelCustomerInfo.mobile;
            cell.constraintContentTrail.constant = 15.0f;
            cell.content.textColor = RGBHex(qwColor7);
            cell.content.font = fontSystem(kFontS11);
            cell.imgViewRightArrow.hidden = YES;
        }
    }
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 8)];
    vi.backgroundColor=[UIColor clearColor];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    lab1.backgroundColor = RGBHex(qwColor10);
    [vi addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 7.5, 320, 0.5)];
    lab2.backgroundColor = RGBHex(qwColor10);
    [vi addSubview:lab2];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (AUTHORITY_ROOT) {
        if (indexPath.row == 0) {
            // 订单
            [self pushToOrderList];
        }else if (indexPath.row == 1){
            // 评价
            [self pushToAppraiseList];
        }else if (indexPath.row == 2){
            // 咨询
            [QWGLOBALMANAGER statisticsEventId:@"会员详情_咨询" withLable:@"会员营销" withParams:nil];
//            ConsultHistoryViewController *vc = [[UIStoryboard storyboardWithName:@"ConsultHistory" bundle:nil] instantiateViewControllerWithIdentifier:@"ConsultHistoryViewController"];
//            vc.passport = self.customerId;
//            [self.navigationController pushViewController:vc animated:YES];
            
//            if (![self.modelCustomerInfo.sessionId isEqualToString:@""]) {
            if ([self.modelCustomerInfo.sessionId intValue] > 0) {
                ChatViewController *vcPTP = nil;
                vcPTP= [[UIStoryboard storyboardWithName:@"ChatViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ChatViewController"];;
                
                vcPTP.hidesBottomBarWhenPushed = YES;
                vcPTP.branchId=self.customerId;
                vcPTP.sessionID=[NSString stringWithFormat:@"%@",self.modelCustomerInfo.sessionId];
                vcPTP.chatType=IMTypePTPStore;
                //            vcPTP.customerSessionVo = ptpModel;
                //        vcPTP.pharSessionVo=ptpModel;
                [self.navigationController pushViewController:vcPTP animated:YES];
                
                //设置未读数
                //            ptpModel.unreadCounts = @"0";
                //            [PharSessionVo updateObjToDB:ptpModel WithKey:[NSString stringWithFormat:@"%@",ptpModel.sessionId]];
                
                //报告未读数
                //            [QWGLOBALMANAGER updateUnreadCount];
            } else {
                [self showError:@"该会员暂未咨询过"];
            }

        }else if (indexPath.row == 3) {
            // 打手机
            [self callMobilePhone];
        }
        
    }else
    {
        if (indexPath.row == 0) {
            //订单历史
            [self pushToOrderList];
        }else if (indexPath.row == 1){
            
            // 本店评价  判断是否开通微商
            [self pushToAppraiseList];
        }else if (indexPath.row == 2){
            [self callMobilePhone];
        }
    }
    
}

- (void)pushToOrderList
{
    [QWGLOBALMANAGER statisticsEventId:@"s_hyxq_dd" withLable:@"会员营销" withParams:nil];
    ClientOrderListViewController *vc = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientOrderListViewController"];
    vc.customerId = self.customerId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToAppraiseList
{
    [QWGLOBALMANAGER statisticsEventId:@"s_hyxq_pj" withLable:@"会员营销" withParams:nil];
    ClientAppraiseListViewController *vc = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientAppraiseListViewController"];
    vc.customerId = self.customerId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)callMobilePhone
{
    [QWGLOBALMANAGER statisticsEventId:@"s_hyxq_sj" withLable:@"会员营销" withParams:nil];
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:StrFromObj(self.modelCustomerInfo.mobile)];

    [actionSheet showInView:self.view];
//    NSString *number = [NSString stringWithFormat:@"tel://%@",self.modelCustomerInfo.mobile];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.modelCustomerInfo.mobile]]];
    }
}

#pragma mark ----
#pragma mark ---- 新设置标签

- (void)setremarkAction{
    [QWGLOBALMANAGER statisticsEventId:@"s_hyxq_bj" withLable:@"会员营销" withParams:nil];
    SetLabelViewController *setVC = [[SetLabelViewController alloc] initWithNibName:@"SetLabelViewController" bundle:nil];
    setVC.modelUserInfo = self.modelCustomerInfo;
    [self.navigationController pushViewController:setVC animated:YES];
}

@end
