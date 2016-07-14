//
//  ClientGroupViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ClientGroupViewController.h"
#import "ClientGroupCell.h"
#import "SVProgressHUD.h"
#import "MGSwipeButton.h"
#import "GroupMemberViewController.h"
#import "Customer.h"
#import "CustomerModel.h"
#import "ClientGroupAlertView.h"

@interface ClientGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MGSwipeTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;         // 客户分组的数组
@property (strong, nonatomic) UITextField *groupNameTextField;  // 弹出新建框

@end

@implementation ClientGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部分组";
    
    self.dataList = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //店员账号
    
    if (AUTHORITY_ROOT) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(newCreateGroup)];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable)
    {
        //断网缓存
        NSArray *list = [CustomerGroupModel getArrayFromDBWithWhere:nil];
        if (list.count == 0) {
            self.tableView.hidden = YES;
            [self showInfoView:kWarning215N6 image:@"img_network"];
        }else
        {
            [self.dataList removeAllObjects];
            self.dataList = [NSMutableArray arrayWithArray:list];
            [self removeInfoView];
            [self.tableView reloadData];
        }
        
    }else
    {
        //服务器获取数据
        [self queryGroupList];
    }
}

#pragma mark ---- 请求客户分组列表 ----

- (void)queryGroupList
{
    [self removeInfoView];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    
    [Customer CustomerGroupListWithParams:setting success:^(id obj) {
        
        NSArray *list = (NSArray *)obj;
        if (list.count == 0) {
            [self.dataList removeAllObjects];
            self.dataList = [NSMutableArray arrayWithArray:list];
            self.tableView.hidden = YES;
            [self showInfoView:@"暂无分组" image:@"img_nogroup_people"];
        }else
        {
            [self.dataList removeAllObjects];
            self.dataList = [NSMutableArray arrayWithArray:list];
            [self.tableView reloadData];
        }
        
        //缓存数据
        [CustomerGroupModel deleteAllObjFromDB];
        [CustomerGroupModel saveObjToDBWithArray:list];
        
    } failue:^(HttpException *e) {
        
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
            }else{
                [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
            }
        }
        
    }];
    
}

#pragma mark ---- 新建分组 ----

- (void)newCreateGroup
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWarning215N6 duration:0.8];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    
    UIView *bgView = [[UIView alloc] init];
    self.groupNameTextField = [[UITextField alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
        bgView.frame = CGRectMake(0, 0, 270, 44);
        self.groupNameTextField.frame = CGRectMake(15 , 0, 240, 44);
        [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.8];
    }else{
        bgView.frame = CGRectMake(0, 0, 270, 84);
        self.groupNameTextField.frame = CGRectMake(15 , 20, 240, 44);
        [self.groupNameTextField becomeFirstResponder];
    }
    
    self.groupNameTextField.placeholder = @"请输入分组名称";
    self.groupNameTextField.font = fontSystem(14.0f);
    self.groupNameTextField.textColor = RGBHex(0x333333);
    self.groupNameTextField.layer.masksToBounds = YES;
    self.groupNameTextField.layer.borderWidth = 0.5;
    self.groupNameTextField.layer.borderColor = RGBHex(0xcccccc).CGColor;
    self.groupNameTextField.layer.cornerRadius = 5.0f;
    self.groupNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.groupNameTextField.delegate = self;
    [self.groupNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.groupNameTextField.backgroundColor = [UIColor whiteColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.groupNameTextField.leftView = paddingView;
    self.groupNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:self.groupNameTextField];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        [alert setValue:bgView forKey:@"accessoryView"];
    }else{
        [alert addSubview:bgView];
    }
    
    [alert show];
}

#pragma mark ---- alert框 弹出键盘 ----

- (void)showKeyboard
{
    [self.groupNameTextField becomeFirstResponder];
}

#pragma mark ---- UIAlertViewDelegate ----

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        switch (alertView.tag) {
            case 1001:
            {
                //新建分组
                
                if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                    [SVProgressHUD showErrorWithStatus:kWarning215N49 duration:0.8];
                    return;
                }
                
                if (self.groupNameTextField.text.length == 0) {
                    [SVProgressHUD showErrorWithStatus:kWarning215N48 duration:0.8];
                    return;
                }
                
                for (int i=0; i<self.dataList.count; i++) {
                    CustomerGroupModel *model = self.dataList[i];
                    if ([model.name isEqualToString:self.groupNameTextField.text]) {
                        [SVProgressHUD showErrorWithStatus:kWarning215N50 duration:0.8];
                        return;
                    }
                }
                
                 //上传至服务器
                NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                setting[@"name"] = self.groupNameTextField.text;
                
                [Customer CustomerGroupCreateWithParams:setting success:^(id obj) {
                    
                    if ([obj[@"apiStatus"] integerValue] == 0) {
                        
                        self.tableView.hidden = NO;
                        [self removeInfoView];
                        [self queryGroupList];
                        [self.tableView reloadData];
                        
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
                    }
                    
                } failue:^(HttpException *e) {
                    
                }];
            }
                
                break;
            case 1002:
            {
                //修改分组名称
                
                UITextField *nameField = self.groupNameTextField;
                if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                    [SVProgressHUD showErrorWithStatus:kWarning215N6 duration:0.8];
                    return;
                }
                
                if (nameField.text.length == 0) {
                    [SVProgressHUD showErrorWithStatus:kWarning215N48 duration:0.8];
                    return;
                }
                
                for (int i=0; i<self.dataList.count; i++) {
                    CustomerGroupModel *model = self.dataList[i];
                    if ([model.name isEqualToString:nameField.text]) {
                        [SVProgressHUD showErrorWithStatus:kWarning215N50 duration:0.8];
                        return;
                    }
                }
                
                //上传至服务器
                
                ClientGroupAlertView *alert = (ClientGroupAlertView *)alertView;
                NSIndexPath *indexPath = alert.obj;
                CustomerGroupModel *model = self.dataList[indexPath.row];
                
                NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                setting[@"customerGroupId"] = model.customerGroupId;
                setting[@"name"] = nameField.text;
                
                [Customer CustomerGroupUpdateWithParams:setting success:^(id obj) {
                    
                    if ([obj[@"apiStatus"] integerValue] == 0) {
                        
                        [self queryGroupList];
                        self.tableView.hidden = NO;
                        [self removeInfoView];
                        [self.tableView reloadData];
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:obj[@"apiMessage" ] duration:0.8];
                    }
                } failue:^(HttpException *e) {
                    
                }];
 
            }
                break;
            case 1003:
            {
                //删除分组
                
                //删除本地数据库

                ClientGroupAlertView *alert = (ClientGroupAlertView *)alertView;
                NSIndexPath *indexPath = alert.obj;
                CustomerGroupModel *model = self.dataList[indexPath.row];
                
                [CustomerGroupModel deleteObjFromDBWithWhere:[NSString stringWithFormat:@"customerGroupId = '%@'",model.customerGroupId]];
                
                NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                setting[@"customerGroupId"] = model.customerGroupId;
                
                [Customer CustomerGroupRemoveWithParams:setting success:^(id obj) {
                    if ([obj[@"apiStatus"] integerValue] == 0) {
                        [self queryGroupList];
                        [self.tableView reloadData];
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
                    }
                    
                } failue:^(HttpException *e) {
                    
                }];
                
            }
                break;
                
            default:
                break;
        }
    
    }
}

#pragma mark ---- 监听文本变化 不超过10个字 ----

- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > 10) {
                textView.text = [toBeString substringToIndex:10];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (toBeString.length > 10) {
            textView.text = [toBeString substringToIndex:10];
        }
    }
}


#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClientGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClientGroupCell"];
    
    CustomerGroupModel *model = self.dataList[indexPath.row];
    cell.groupName.text = [NSString stringWithFormat:@"%@（%d）",model.name,[model.num integerValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //店员账号 左滑代理
    
    if (AUTHORITY_ROOT) {
        cell.swipeDelegate = self;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CustomerGroupModel *model = self.dataList[indexPath.row];
    GroupMemberViewController *vc = [[UIStoryboard storyboardWithName:@"ClientGroup" bundle:nil] instantiateViewControllerWithIdentifier:@"GroupMemberViewController"];
    vc.title = model.name;
    vc.customerGroupId = model.customerGroupId;
    [self.navigationController pushViewController:vc animated:YES];
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
    indexPath = [self.tableView indexPathForCell:cell];
    
    if (index == 1) {
        if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
            [self showError:@"网络异常，请稍后重试"];
            return YES;
        }
        
        //修改分组
        
        CustomerGroupModel *groupModel = self.dataList[indexPath.row];
        
        ClientGroupAlertView *alert = [[ClientGroupAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1002;
        alert.obj = indexPath;
        
        UIView *bgView = [[UIView alloc] init];
        self.groupNameTextField = [[UITextField alloc] init];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
            bgView.frame = CGRectMake(0, 0, 270, 44);
            self.groupNameTextField.frame = CGRectMake(15 , 0, 240, 44);
            [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.8];
        }else{
            bgView.frame = CGRectMake(0, 0, 270, 84);
            self.groupNameTextField.frame = CGRectMake(15 , 20, 240, 44);
            [self.groupNameTextField becomeFirstResponder];
        }
        
        self.groupNameTextField.placeholder = @"请输入分组名称";
        self.groupNameTextField.font = fontSystem(14.0f);
        self.groupNameTextField.textColor = RGBHex(0x333333);
        self.groupNameTextField.text = groupModel.name;
        self.groupNameTextField.layer.masksToBounds = YES;
        self.groupNameTextField.layer.borderWidth = 0.5;
        self.groupNameTextField.layer.borderColor = RGBHex(0xcccccc).CGColor;
        self.groupNameTextField.layer.cornerRadius = 5.0f;
        self.groupNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.groupNameTextField.delegate = self;
        [self.groupNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
        self.groupNameTextField.leftView = paddingView;
        self.groupNameTextField.leftViewMode = UITextFieldViewModeAlways;
        [bgView addSubview:self.groupNameTextField];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
            [alert setValue:bgView forKey:@"accessoryView"];
        }else{
            [alert addSubview:bgView];
        }
        
        [alert show];

    }else{
        
        //删除分组
        
        if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
            [self showError:@"网络异常，请稍后重试"];
            return YES;
        }
        
        ClientGroupAlertView *alert = [[ClientGroupAlertView alloc] initWithTitle:nil message:kWarning215N51 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1003;
        alert.obj = indexPath;
        [alert show];
    
    }
    return YES;
}

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"删除", @"编辑"};
    UIColor * colors[2] = {RGBHex(qwColor3), RGBHex(qwColor9)};
    UIColor *titlecolor[2] = {RGBHex(qwColor4),RGBHex(qwColor4)};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        [button setTitleColor:titlecolor[i] forState:UIControlStateNormal];
        [result addObject:button];
    }
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
