//
//  AddMemberViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AddMemberViewController.h"
#import "BATableView.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "CustomerModelR.h"
#import "Customer.h"
#import "MyCustomerBaseModel.h"
#import "MyDefineCell.h"

@interface AddMemberViewController ()<UITableViewDataSource,UITableViewDelegate,BATableViewDelegate,MyDefineCellDelegate,UISearchBarDelegate>

{
    BATableView * myTableView;
    NSInteger totalCount;           //确定的数量
    int dataType;                   //请求的数据类型
    BOOL isFirstRequest;            //是否第一次加载所有客户
    BOOL noDataBySearch;            //搜索无数据
}

//记录选择的所有客户
@property (strong, nonatomic) NSMutableArray *oldSelectedClientList;
@property (strong, nonatomic) NSMutableArray *newwSelectedClientList;

//type 1
@property (nonatomic ,strong) NSMutableArray *rightIndexArray;
@property (nonatomic ,strong) NSMutableArray *LetterResultArr;

//type 2
@property (nonatomic ,strong) NSMutableArray *searchClientList;

@property (nonatomic ,strong) UIView *noDataView;
@property (strong, nonatomic) UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加组员";
    self.view.backgroundColor = RGBHex(qwColor11);
    isFirstRequest = YES;
    noDataBySearch = NO;
    
    self.oldSelectedClientList = [NSMutableArray array];
    self.newwSelectedClientList = [NSMutableArray array];
    
    self.rightIndexArray = [NSMutableArray array];
    self.LetterResultArr = [NSMutableArray array];
    
    self.searchClientList = [NSMutableArray array];
    
    [self setNoDataView];
    [self setUpRightItem];
    
    self.searchBar.delegate = self;
    [self setUpForDismissKeyboard];
    
}

#pragma mark ---- 点击空白 收起键盘 ----

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
    
    if (noDataBySearch){
        
        //搜索无数据，显示断网页面，点击空白,键盘down，不需要请求所有的客户数据
        noDataBySearch = NO;
        
    }else{
        
        //其他，点击空白，加载所有客户数据
        [self queryCustomer];
        [myTableView.tableView reloadData];
    }
    [self.view endEditing:YES];
}


#pragma mark ---- 创建tableView ----

- (void)makeTableView
{
    if(myTableView){
        [myTableView removeFromSuperview];
    }
    myTableView = [[BATableView alloc]init];
    myTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height-44-44)];
    myTableView.delegate = self;
    myTableView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.tableView.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
    [self.view addSubview:myTableView];
    
    myTableView.tableView.headerPullToRefreshText = @"下拉刷新";
    myTableView.tableView.headerReleaseToRefreshText = @"松开刷新";
    myTableView.tableView.headerRefreshingText = @"正在刷新";
    
    __weak AddMemberViewController *weakSelf = self;
    
//    [myTableView.tableView addHeaderWithCallback:^{
//        
//        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
//            
//            if (dataType == Enum_DataType_ByAll_Items)
//            {
//                [weakSelf getMydefineList];
//            }else if (dataType == Enum_DataType_BySearch_Items)
//            {
//                [weakSelf searchmydefineAction:weakSelf.searchBar.text];
//            }
//        }else{
//            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
//        }
//        [myTableView.tableView headerEndRefreshing];
//    }];
    [self enableSimpleRefresh:myTableView.tableView block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            
            if (dataType == Enum_DataType_ByAll_Items)
            {
                [weakSelf getMydefineList];
            }else if (dataType == Enum_DataType_BySearch_Items)
            {
                [weakSelf searchmydefineAction:weakSelf.searchBar.text];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
        [myTableView.tableView headerEndRefreshing];
    }];
    
}


#pragma mark ---- 右侧按钮 ----

- (void)setUpRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    totalCount = 0;
    NSString *rightTitleCount;
    
    if (totalCount == 0) {
        rightTitleCount = @"确定";
    }else{
        rightTitleCount = [NSString stringWithFormat:@"确定 (%d)",totalCount];
    }
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 70, 30);
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightButton setTitle:rightTitleCount forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(makeSureAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItems = @[fixed,rightBarButtonItem];
    
    if (totalCount == 0) {
        
        // 选择的客户数量 为0
        self.rightButton.enabled = NO;
        [self.rightButton setTitleColor:RGBAHex(qwColor4, 0.5) forState:UIControlStateNormal];
    }else
    {
        self.rightButton.enabled = YES;
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark ---- 确定 action ----

- (void)makeSureAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWarning215N6 duration:0.8];
        return;
    }
    
    // 拼接 参数 customerIds
    
    NSMutableArray *customerIdArray = [NSMutableArray array];
    
    for (int i=0; i<self.newwSelectedClientList.count; i++) {
        NSDictionary *dic = self.newwSelectedClientList[i];
        [customerIdArray addObject:dic[@"passportId"]];
    }
    
    NSString *customerIds =@"";
    
    if (customerIdArray)
    {
        for (int i = 0; i < customerIdArray.count; i++) {
            if (i == 0) {
                customerIds = [NSString stringWithFormat:@"%@",[customerIdArray objectAtIndex:i]];
            }else{
                customerIds = [NSString stringWithFormat:@"%@%@%@",[customerIdArray objectAtIndex:i],SeparateStr,customerIds];
            }
        }
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"customerGroupId"] = StrFromObj(self.customerGroupId);
    setting[@"customerIds"] = customerIds;
    
    [Customer CustomerGroupCustAddWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
        }
        
    } failue:^(HttpException *e) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        
        //断网缓存
        
        if(self.rightIndexArray.count > 0)
            return;
        NSMutableDictionary *subDict = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"myDefineOne%@",QWGLOBALMANAGER.configure.groupId]];
        [self sortIndexPerson:subDict];
        
    }else
    {
        [self getMydefineList];
    }
}

-(void)getMydefineList
{
    if (!QWGLOBALMANAGER.loginStatus) {
        return;
    }
    [self queryCustomer];
}

#pragma mark ---- 请求客户数据 ----

- (void)queryCustomer
{
    dataType = Enum_DataType_ByAll_Items;
    myTableView.tableViewIndex.hidden = NO;
    
    CustomerQueryIndexModelR *model = [[CustomerQueryIndexModelR alloc] init];
    model.token = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    model.tags = @"";
    model.item = @"";
    [Customer QueryCustomerWithParams:model success:^(id obj) {
        NSDictionary *subDict = (NSDictionary *)obj;
        if([[subDict allKeys] count] == 0) {
            self.noDataView.hidden = NO;
            myTableView.hidden = YES;
            return;
        }
        
        self.noDataView.hidden = YES;
        if (isFirstRequest == YES)
        {
            NSMutableArray *totalArray = [NSMutableArray array];
            NSArray *originalArray = [obj allValues];
            for (int i=0; i<originalArray.count; i++) {
                NSArray *temp = originalArray[i];
                for (int j=0; j<temp.count; j++) {
                    NSDictionary *dic = temp[j];
                    [totalArray addObject:dic];
                }
                
            }
            
            for (NSDictionary *totalDic in totalArray) {
                for (NSDictionary *tempDic in self.tempArray) {
                    if ([totalDic[@"id"] isEqualToString:tempDic[@"id"]]) {
                        
                        [self.oldSelectedClientList addObject:totalDic];
                    }
                }
            }
            
            isFirstRequest = NO;
        }else
        {
            
        }
        
        [QWUserDefault setObject:subDict key:[NSString stringWithFormat:@"myDefineOne%@",QWGLOBALMANAGER.configure.groupId]];
        [self sortIndexPerson:subDict];
        [self.searchBar resignFirstResponder];
        
    } failure:^(HttpException *e) {
        
    }];
}


#pragma mark ----
#pragma mark ---- 无数据提示

- (void)setNoDataView
{
    self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 320, 500)];
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((APP_W-72)/2, 60, 72, 72)];
    image.image=[UIImage imageNamed:@"noData"];
    [self.noDataView addSubview:image];
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60+72+25, APP_W-20, 15)];
    [noDataLabel setFont:[UIFont systemFontOfSize:15]];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.text = @"暂无会员!";
    noDataLabel.textColor = RGBHex(0x6a7985);
    [self.noDataView addSubview:noDataLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noSearchkeyBoardDown)];
    [self.noDataView addGestureRecognizer:tap];
}

#pragma mark ---- 无数据 点击空白 keyBoardDismiss ----

- (void)noSearchkeyBoardDown
{
    [UIView animateWithDuration:1 animations:^{
    } completion:^(BOOL finished) {
        
    }];
    [self.view endEditing:YES];
}

#pragma mark ---- 修改标签delegate ----

-(void)changeLabeldelegate
{
    [self getMydefineList];
}

#pragma mark ---- 索引条排序 ----

- (void)sortIndexPerson:(NSDictionary *)subDict
{
    [self.rightIndexArray removeAllObjects];
    [self.LetterResultArr removeAllObjects];
    self.rightIndexArray  = [[subDict allKeys] mutableCopy];
    [self.rightIndexArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *string1 = (NSString *)obj1;
        NSString *string2 = (NSString *)obj2;
        if([string1 isEqualToString:@"#"]) {
            return 1;
        }else if([string2 isEqualToString:@"#"]) {
            return -1;
        }
        return [string1 compare:string2];
    }];
    for(NSString *keyValue in self.rightIndexArray)
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:15];
        for(NSDictionary *singlePerson in subDict[keyValue])
        {
            [array addObject:singlePerson];
        }
        [self.LetterResultArr addObject:array];
    }
    
    if (self.rightIndexArray .count == 0)
    {
        self.noDataView.hidden = NO;
        myTableView.hidden = YES;
    }else
    {
        self.noDataView.hidden = YES;
        [self makeTableView];
    }
}



#pragma mark ---- 列表代理 ----

- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView
{
    return self.rightIndexArray;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (dataType == Enum_DataType_ByAll_Items) {
        return 23.0f;
    }else{
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataType == Enum_DataType_ByAll_Items) {
        return self.rightIndexArray.count;
    }else{
        return 1;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataType == Enum_DataType_ByAll_Items) {
        return  [(NSArray *)self.LetterResultArr[section] count];
    }else{
        return self.searchClientList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyDefineCellIdentifier = @"MyDefineCellIdentifier";
    MyDefineCell *cell = (MyDefineCell *)[tableView dequeueReusableCellWithIdentifier:MyDefineCellIdentifier];
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
        cell.lbl_username.text= @"";
        [cell.img_user setImage:nil];
        [cell.img_logo setImage:nil];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [NSDictionary dictionary];
    if (dataType == Enum_DataType_ByAll_Items){
        dic = self.LetterResultArr[indexPath.section][indexPath.row];
    }else if (dataType == Enum_DataType_BySearch_Items){
        dic = self.searchClientList[indexPath.row];
    }
    [cell configureCellData:dic];

    
    if (dataType == Enum_DataType_ByAll_Items) {
        if ([(NSArray *)self.LetterResultArr[indexPath.section] count]-1==indexPath.row) {
            cell.backline.hidden=YES;
        }else{
            cell.backline.hidden=NO;
        }
    }else if (dataType == Enum_DataType_BySearch_Items){
        cell.backline.hidden = NO;
    }
    
    //是否选中cell
    
    if (dataType == Enum_DataType_ByAll_Items)
    {
        
        NSDictionary *allDic = self.LetterResultArr[indexPath.section][indexPath.row];
        
        if ([self.newwSelectedClientList containsObject:allDic])
        {
            cell.selectButton.enabled = YES;
            cell.selectImageView.image = [UIImage imageNamed:@"icon_client_addMember_selected"];
            
        }else if([self.oldSelectedClientList containsObject:allDic])
        {
            cell.selectButton.enabled = NO;
            cell.selectImageView.image = [UIImage imageNamed:@"img_checkbook_select_"];
            
        }else{
            cell.selectButton.enabled = YES;
            cell.selectImageView.image = [UIImage imageNamed:@"img_checkbook"];
        }
        
    }else if (dataType == Enum_DataType_BySearch_Items)
    {
        NSDictionary *selectDic = self.searchClientList[indexPath.row];
        
        if ([self.newwSelectedClientList containsObject:selectDic])
        {
            cell.selectButton.enabled = YES;
            cell.selectImageView.image = [UIImage imageNamed:@"icon_client_addMember_selected"];
            
        }else if ([self.oldSelectedClientList containsObject:selectDic])
        {
            cell.selectButton.enabled = NO;
            cell.selectImageView.image = [UIImage imageNamed:@"img_checkbook_select_"];
            
        }else{
            cell.selectButton.enabled = YES;
            cell.selectImageView.image = [UIImage imageNamed:@"img_checkbook"];
        }
        
    }
    
    cell.selectDelegate = self;
    cell.selectButton.obj = indexPath;
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    if (dataType == Enum_DataType_ByAll_Items)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , [UIScreen mainScreen].applicationFrame.size.width, 23)];
        view.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 23)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = RGBHex(0x999999);
        if ( [self.rightIndexArray[section] isEqualToString:@"#"]) {
            label.text  =@"#未分类";
        }else {
            label.text = self.rightIndexArray[section];
        }
        [view addSubview:label];
    }else{
        view = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---- cell选择框的代理 ----

- (void)selectClientMemberDelegate:(id)sender
{
    QWButton *button = (QWButton *)sender;
    NSIndexPath *indexPath = button.obj;
    
    NSDictionary *clientDic = [NSDictionary dictionary];
    if (dataType == Enum_DataType_ByAll_Items)
    {
        clientDic = self.LetterResultArr[indexPath.section][indexPath.row];
    }else if(dataType == Enum_DataType_BySearch_Items)
    {
        clientDic = self.searchClientList[indexPath.row];
    }
    
    if ( [self.newwSelectedClientList containsObject:clientDic]) {
        [self.newwSelectedClientList removeObject:clientDic];
    }else{
        [self.newwSelectedClientList addObject:clientDic];
    }
    
    [myTableView.tableView reloadData];
    
    
    //计算确定的客户数
    totalCount = self.newwSelectedClientList.count;
    NSString *rightTitleCount;
    if (totalCount == 0) {
        rightTitleCount = @"确定";
    }else{
        rightTitleCount = [NSString stringWithFormat:@"确定 (%d)",totalCount];
    }
    if (totalCount == 0) {
        self.rightButton.enabled = NO;
        [self.rightButton setTitleColor:RGBAHex(qwColor4, 0.5) forState:UIControlStateNormal];
    }else
    {
        self.rightButton.enabled = YES;
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    [self.rightButton setTitle:rightTitleCount forState:UIControlStateNormal];

    
}

#pragma mark ---- UISearchBarDelegaet ----

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        myTableView.tableView.hidden = YES;
        myTableView.tableViewIndex.hidden = YES;
    }
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchBar.text isEqualToString:@""]||self.searchBar.text == nil||[self.searchBar.text isEqual:[NSNull class]]) {
        [self getMydefineList];
    }else
    {
        [self searchmydefineAction:self.searchBar.text];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        [self searchmydefineAction:searchBar.text];
    }
}

#pragma mark ---- 搜索Action ----

-(void)searchmydefineAction:(NSString *)keyWord
{
    dataType = Enum_DataType_BySearch_Items;
    myTableView.tableViewIndex.hidden = YES;
    
    CustomerQueryIndexModelR *modelR = [CustomerQueryIndexModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.item = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (keyWord.length >0) {
        
        [Customer QueryCustomerWithParams:modelR success:^(id obj) {
            
            [self.searchClientList removeAllObjects];
            NSDictionary *subDict = (NSDictionary *)obj;
            NSMutableArray *arr = (NSMutableArray *)[subDict allValues];
            for (NSMutableArray *subArr in arr) {
                for (NSDictionary *dic in subArr) {
                    [self.searchClientList addObject:dic];
                }
            }
            if (self.searchClientList.count > 0) {
                
                myTableView.tableView.hidden = NO;
                [myTableView.tableView reloadData];
            }else{
                
                noDataBySearch = YES;
                self.noDataView.hidden = NO;
                myTableView.tableView.hidden =YES;
            }
            
            
        } failure:^(HttpException *e) {
            
        }];
    }
}

#pragma mark ---- 通知 ----

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotifQuitOut) {
        [self logoutAction];
    } else if (type == NotifContactUpdate) {
        [self delayQueryCustomer];
    } else if (type == NotifContactUpdateImmediate) {
        [self queryCustomer];
    }
}

- (void)logoutAction
{
    [self.rightIndexArray removeAllObjects];
    [self.LetterResultArr removeAllObjects];
    [self.searchClientList removeAllObjects];
    [myTableView reloadData];
}

- (void)delayQueryCustomer
{
    [self performSelector:@selector(queryCustomer) withObject:nil afterDelay:6.0f];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
