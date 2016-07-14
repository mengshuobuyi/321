//
//  SendPostViewController.m
//  APP
//  发帖页面
//  Created by Martin.Liu on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "SendPostViewController.h"
#import "TKTextView.h"
#import "XHMessageTextView.h"
#import "PhotoAlbum.h"
#import "MAButtonWithTouchBlock.h"
#import "ChooseExpertViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "EditPostTextViewTableCell.h"
#import "EditPostImageTextTableCell.h"
#import "MAAllCircleViewController.h"
#import "SVProgressHUD.h"
#import "uploadFile.h"
#import "SBJson.h"
#import "PostDetailViewController.h"
#import "LoginViewController.h"
#import "HttpClient.h"
#import "NSString+MarCategory.h"

#import "ConstraintsUtility.h"
#import "APPDelegate.h"
#import "QWUserDefault.h"
#import "QWProgressHUD.h"
#import "ChooseCircleViewController.h"          // 选择圈子
#import "AppealUtil.h"
//@implementation PostCellModel
//@end
#define SendPost_MaxPicTotalSize 30     // 帖子中最多发图片的数量
#define SendPost_MaxPicSizeOneTime 9    // 一次选择图片的最大数量

#define CRChange_SendGotoNextPage       // 是否点击发帖就跳到下个页面,不管是否发帖成功

@interface SendPostViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *circleTitleLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_chooseCircleViewHeight; // default is 50
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet TKTextView *postTitleTV;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_postTitleTVHeight; // default is 33

@property (strong, nonatomic) IBOutlet UILabel *reminderExpertTipLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_SendPostTextViewBottom;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;

@property (nonatomic, strong) NSString* postId;   //如果为空，自动生成32位的帖子随机号
@property (nonatomic, strong) NSMutableArray* postCellArray;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)saveToDrafts:(id)sender;
- (IBAction)sendBtnAction:(id)sender;
- (void)choosePhotosBtnAction:(id)sender;
- (void)takePhotoBtnAction:(id)sender;
- (IBAction)chooseCircleBtnAction:(id)sender;

/**
 *  4.0.0 增加
 */
@property (nonatomic, strong) QWCircleModel     *sharedCircle;
@property (strong, nonatomic) IBOutlet UIButton *anonymousBtn;
- (IBAction)anonymousBtnAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *anonymousChooseImageView;

@property (strong, nonatomic) IBOutlet UIView *bottomContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomTipImageView;
@property (strong, nonatomic) IBOutlet UILabel *bottomTipLabel;     // 提醒专家 分享至公共圈

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_bottomViewHeight;  // 下面匿名发帖视图。 编辑或者从草稿箱进入要隐藏设置0  ， default is 48
- (IBAction)reminderExpertOrShareCircleBtnAction:(id)sender;

@end

@implementation SendPostViewController
{
    TKTextView* selectTextView;
    NSInteger selectedIndex;
    NSInteger tmpChooseImageSelectedIndex;
    
    BOOL isDeleteKey;
    BOOL isModify;  // 是否修改了内容（包括选择圈子，修改标题，修改内容,选择提示的专家,上传图片）
}

@synthesize postDetail = _postDetail;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isStoreCircle = _isStoreCircle;   // 底下视图根据商家圈和公共全配置不同的文案。
    if (self.postCellArray.count > 0) {
        QWPostContentInfo* postContentInfo = [self.postCellArray lastObject];
        if (postContentInfo.postContentType != 1) {
            QWPostContentInfo* modelTV = [QWPostContentInfo new];
            modelTV.postContentType = 1;
            [self.postCellArray addObject:modelTV];
        }
    }
    else
    {
        QWPostContentInfo* modelTV = [QWPostContentInfo new];
        modelTV.postContentType = 1;
        [self.postCellArray addObject:modelTV];
    }
    

    selectedIndex = -1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EditPostTextViewTableCell" bundle:nil] forCellReuseIdentifier:@"EditPostTextViewTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditPostImageTextTableCell" bundle:nil] forCellReuseIdentifier:@"EditPostImageTextTableCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self setSendBtnState];
}

- (void)UIGlobal
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(sendBtnAction:)];
    
    self.postTitleTV.placeholder = @"请输入您的文章标题";
    self.postTitleTV.placeholderColor = RGBHex(qwColor8);
    self.postTitleTV.font = [UIFont systemFontOfSize:kFontS1];
    self.postTitleTV.text = _postDetail.postTitle;
    self.postTitleTV.delegate = self;
    self.postTitleTV.isSendPost = YES;
    if (self.needChooseCircle || ((self.sendCircle == nil) && StrIsEmpty(self.postDetail.teamId))) {
        self.constraint_chooseCircleViewHeight.constant = 50;
    }
    else
    {
        // 隐藏选择发帖的圈子
        self.constraint_chooseCircleViewHeight.constant = 0;
    }
    
    if (self.sendCircle) {
        self.circleTitleLabel.text = _sendCircle.teamName;
    }
    else
    {
        if (_postDetail && _postDetail.teamId && _postDetail.teamName) {
            QWCircleModel* tmpSendCircle = [QWCircleModel new];
            tmpSendCircle.teamId = _postDetail.teamId;
            tmpSendCircle.teamName = _postDetail.teamName;
            self.sendCircle = tmpSendCircle;
            self.circleTitleLabel.text = _sendCircle.teamName;
        }
    }
    
    if (self.reminderExpertArray.count > 0) {
        self.reminderExpertTipLabel.text = [NSString stringWithFormat:@"@已提醒%ld位专家", (long)self.reminderExpertArray.count];
    }
    if (self.postStatusType == PostStatusType_None) {
        self.constraint_bottomViewHeight.constant = 48;
    }
    else
    {
        self.constraint_bottomViewHeight.constant = 0;
    }

    self.bottomContainerView.backgroundColor = RGBHex(qwColor1);
    [self.sendBtn setTitleColor:RGBAHex(0xffffff, 0.3) forState:UIControlStateDisabled];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testTapTableView:)];
    [self.tableView addGestureRecognizer:tapGesture];
}

// 当点击下面空白的地方选中最后一个cell
- (void)testTapTableView:(UITapGestureRecognizer*)tapGesture
{
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:[tapGesture locationInView:tapGesture.view]];
    if (indexPath && self.postCellArray.count > indexPath.row) {
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        // 选中最后一个
        if (self.postCellArray.count > 0) {
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.postCellArray.count - 1 inSection:0]];
        }
    }
}

- (QWPostDetailModel *)postDetail
{
    if (!_postDetail) {
        _postDetail = [QWPostDetailModel new];
        _postDetail.postId = self.postId;
        _postDetail.postId = QWGLOBALMANAGER.configure.expertPassportId;
    }
    return _postDetail;
}

- (void)setIsStoreCircle:(BOOL)isStoreCircle
{
    _isStoreCircle = isStoreCircle;
    if (isStoreCircle) {
        self.bottomTipImageView.image = [UIImage imageNamed:@"ic_post_quanzi"];
        self.bottomTipLabel.text = @"分享至公共圈";
    }
    else
    {
//        self.bottomTipImageView.image = [UIImage imageNamed:@"ic_post_pepole"];
//        self.bottomTipLabel.text = @"@提醒专家看";
        self.constraint_bottomViewHeight.constant = 0;
    }
}

- (void)setPostDetail:(QWPostDetailModel *)postDetail
{
    _postDetail = postDetail;
    self.postId = _postDetail.postId;
    self.postCellArray = [NSMutableArray arrayWithArray:_postDetail.postContentList];
}

- (NSString *)postId
{
    if (!_postId) {
        _postId = [QWGLOBALMANAGER randomUUID];
    }
    return _postId;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy.MM.dd hh:mm";
    }
    return _dateFormatter;
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 3.1优化如果标题中点击换行，自动跳到内容下面的第一个cell
    if (textView == self.postTitleTV) {
        if ([text isEqualToString:@"\n"]) {
            selectedIndex = 0;
            [self p_reloadTata];
            return NO;
        }
    }
    isDeleteKey = text.length == 0;
    return YES;
}

- (void)textViewChanged:(NSNotification*)noti
{
    isModify = YES;
    [self setSendBtnState];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.postTitleTV) {
        // 发布按钮状态
        // 字数限制
        if (textView.text.length > 35) {
            textView.text = [textView.text substringToIndex:35];
        }
        else
        {
            // 适配高度
            CGFloat height = textView.frame.size.height;
            CGSize fitSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
            if (fitSize.height > height || (isDeleteKey && height > 33 && height > fitSize.height)) {
                self.constraint_postTitleTVHeight.constant = fitSize.height;
                CGFloat tableHeaderViewHeight = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                CGRect tableHeaderViewFrame = self.tableHeaderView.frame;
                tableHeaderViewFrame.size.height = tableHeaderViewHeight;
                self.tableHeaderView.frame = tableHeaderViewFrame;
                [self.tableView beginUpdates];
                self.tableView.tableHeaderView = self.tableHeaderView;
                [self.tableView endUpdates];
            }
        }
    }
}

- (void)setSendBtnState
{
    self.sendBtn.enabled = [self checkSendabel];
    self.saveBtn.enabled = self.sendBtn.enabled;
}

// 检查标题和内容是否为空
- (BOOL)checkSendabel
{
    return !StrIsEmpty([self.postTitleTV.text mar_trim]) && [self checkPostContent];
}

// 如果帖子有内容返回YES
- (BOOL)checkPostContent
{
    if (self.postCellArray.count > 1) {
        return YES;
    }
    if (self.postCellArray.count > 0)
    {
        QWPostContentInfo* postContent = [self.postCellArray firstObject];
        if (!StrIsEmpty([postContent.postContent mar_trim])) {
            return YES;
        }
    }
    return NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self textViewDidChange:self.postTitleTV];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (NSMutableArray *)postCellArray
{
    if (!_postCellArray) {
        _postCellArray = [[NSMutableArray alloc] init];
    }
    return _postCellArray;
}

- (void)setSharedCircle:(QWCircleModel *)sharedCircle
{
    _sharedCircle = sharedCircle;
    self.bottomTipLabel.text = [NSString stringWithFormat:@"分享至: %@", _sharedCircle.teamName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 键盘推出，隐藏动作
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSValue* keyRectVal = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyFrame = [keyRectVal CGRectValue];
    UIEdgeInsets tableViewInsets = UIEdgeInsetsZero;
    tableViewInsets.bottom += (keyFrame.size.height - self.constraint_bottomViewHeight.constant);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.constraint_SendPostTextViewBottom.constant = keyFrame.size.height;
//        [self.view layoutIfNeeded];
        _tableView.contentInset = tableViewInsets;
    } completion:nil];

}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _tableView.contentInset = UIEdgeInsetsZero;
//        self.constraint_SendPostTextViewBottom.constant = 0;
    } completion:nil];
}

#pragma mark - UITableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postCellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
//    PostCellModel* model = self.postCellArray[row];
    QWPostContentInfo* model = self.postCellArray[row];
    NSString* identifier;
    if (row == self.postCellArray.count - 1 || model.postContentType == 1) {
        identifier = @"EditPostTextViewTableCell";
    }
    else
    {
        identifier = @"EditPostImageTextTableCell";
    }
    return [tableView fd_heightForCellWithIdentifier:identifier configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
//    return 100;
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
//    __block PostCellModel* model = self.postCellArray[row];
    __block QWPostContentInfo* model = self.postCellArray[row];
    __block NSIndexPath* indexPathBlock = indexPath;
    __weak __typeof(self)weakSelf = self;
    if (row == self.postCellArray.count - 1) {
        EditPostTextViewTableCell* textCell = cell;
        __weak EditPostTextViewTableCell* weakTextCell = textCell;
        textCell.indexPath = indexPath;
        textCell.closeBtn.hidden = YES;
        if (self.postCellArray.count > 1) {
            textCell.textView.placeholder = nil;
        }
        else
            textCell.textView.placeholder = @"请输入您的文章内容";
        [textCell.textView setSendPost:YES];
        textCell.textView.text = model.postContent;
        [textCell setCell:model];
        if (selectedIndex == row) {
            [textCell.textView becomeFirstResponder];
        }
        textCell.closeBtn.touchUpInsideBlock = nil;
        textCell.textView.doneBlock = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->selectedIndex = -1;
        };
        textCell.textView.chooseImageBlock = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf choosePhotosBtnAction:nil];
        };
        textCell.textView.takePhotoBlock = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf takePhotoBtnAction:nil];
        };
        textCell.changeHeightBlock = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf->selectedIndex = indexPathBlock.row;
            model.postContent = weakTextCell.textView.text;
            [strongSelf.tableView reloadData];

        };
    }
    else
    {
        if (model.postContentType == 1) {
            EditPostTextViewTableCell* textCell = cell;
            __weak EditPostTextViewTableCell* weakTextCell = textCell;
            textCell.indexPath = indexPath;
            textCell.closeBtn.hidden = YES;
            if (self.postCellArray.count > 1) {
                textCell.textView.placeholder = nil;
            }
            else
                textCell.textView.placeholder = @"请输入您的文章内容";
            [textCell.textView setSendPost:YES];
            textCell.textView.text = model.postContent;
            [textCell setCell:model];
            if (selectedIndex == row) {
                [textCell.textView becomeFirstResponder];
            }
            textCell.closeBtn.touchUpInsideBlock = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                strongSelf->selectedIndex = -1;
                DebugLog(@"indexrow : %d", indexPathBlock.row);
                [strongSelf removePostModelIndexPath:indexPathBlock];
            };
            textCell.textView.doneBlock = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                strongSelf->selectedIndex = -1;
                model.postContent = weakTextCell.textView.text;
                [strongSelf.tableView reloadData];
            };
            textCell.changeHeightBlock = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                model.postContent = weakTextCell.textView.text;
                strongSelf->selectedIndex = indexPathBlock.row;
//                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPathBlock] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.tableView reloadData];
                
            };
        }
        else if (model.postContentType == 2)
        {
            EditPostImageTextTableCell* textImageCell = cell;
            __weak EditPostImageTextTableCell* weakTextImageCell = cell;
            textImageCell.indexPath = indexPath;
            textImageCell.closeBtn.hidden = NO;
            textImageCell.textView.placeholder = @"请添加图片描述";
            [textImageCell.textView setSendPost:YES];
            textImageCell.textView.text = model.postContent;
            [textImageCell setCell:model];
            if (selectedIndex == row) {
                [textImageCell.textView becomeFirstResponder];
            }
            textImageCell.closeBtn.touchUpInsideBlock = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                strongSelf->selectedIndex = -1;
                [weakSelf removePostModelIndexPath:indexPathBlock];
            };
            textImageCell.textView.doneBlock = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                strongSelf->selectedIndex = -1;
                model.postContentDesc = weakTextImageCell.textView.text;
                [strongSelf.tableView reloadData];
            };
            textImageCell.changeHeightBlock = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                model.postContentDesc = weakTextImageCell.textView.text;
                strongSelf->selectedIndex = indexPathBlock.row;
//                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPathBlock] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.tableView reloadData];
            };
        }
    }
    
    [cell setCell:model];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
//    PostCellModel* model = self.postCellArray[row];
    QWPostContentInfo* model = self.postCellArray[row];
    NSString* identifier;
    if (row == self.postCellArray.count - 1 || model.postContentType == 1) {
        identifier = @"EditPostTextViewTableCell";
    }
    else
    {
        identifier = @"EditPostImageTextTableCell";
    }

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (void)removePostModelIndexPath:(NSIndexPath*)indexPath
{
    if (self.postCellArray.count > indexPath.row) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(p_reloadTata) object:nil];
        [self.postCellArray removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self p_reloadTata];
        // 避免连续点击发生问题
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self performSelector:@selector(p_reloadTata) withObject:nil afterDelay:0.01];
    }

}

- (void)removePostModelIndex:(NSInteger)index
{
    if (self.postCellArray.count > index) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(p_reloadTata) object:nil];
        [self.postCellArray removeObjectAtIndex:index];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self p_reloadTata];
        // 避免连续点击发生问题
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self performSelector:@selector(p_reloadTata) withObject:nil afterDelay:0.01];
    }
}

- (void)p_reloadTata
{
    [self handlePostCellArray];
    [self.tableView reloadData];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [self setSendBtnState];
}

- (void)handlePostCellArray
{
    for (int i = 0; i < self.postCellArray.count - 1; i++) {
//        PostCellModel* currentModel = self.postCellArray[i];
//        PostCellModel* nextModel = self.postCellArray[i+1];
        QWPostContentInfo* currentModel = self.postCellArray[i];
        QWPostContentInfo* nextModel = self.postCellArray[i+1];
        if (currentModel.postContentType == 1 && nextModel.postContentType == 1) {
            // 都不为空
            if (!StrIsEmpty(currentModel.postContent) && !StrIsEmpty(nextModel.postContent)) {
                currentModel.postContent = [currentModel.postContent stringByAppendingString:[NSString stringWithFormat:@"\n%@",nextModel.postContent]];
            }
            // 当前是空的，下一个不是空的
            else if (StrIsEmpty(currentModel.postContent) && !StrIsEmpty(nextModel.postContent))
            {
                currentModel.postContent = nextModel.postContent;
            }
            [self.postCellArray removeObject:nextModel];
            [self handlePostCellArray];
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [self.tableView reloadData];
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)editPostCell
{
    [self performSelector:@selector(enabelTheLastCellBecomeFirstResponder) withObject:nil afterDelay:0.5];
}
- (void)enabelTheLastCellBecomeFirstResponder
{
    NSInteger cellCount = [self tableView:self.tableView numberOfRowsInSection:0];
    if (cellCount > 0) {
        NSIndexPath* lastIndexPath = [NSIndexPath indexPathForItem:cellCount - 1 inSection:0];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
        TKTextView* textView = (id)[cell viewWithTag:1];
        if ([textView isKindOfClass:[TKTextView class]]) {
            [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [textView becomeFirstResponder];
        }
    }
}


- (void)LocalPhoto
{
    int photosNumber = [self photosNumberInPost];  // 帖子中图片的数量
    if (photosNumber >= SendPost_MaxPicTotalSize) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"一次最多可发%ld张图片", (long)SendPost_MaxPicTotalSize]];
        return;
    }
    tmpChooseImageSelectedIndex = selectedIndex;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
    PhotoAlbum* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAlbum"];
    __weak __typeof(self) weakSelf = self;
    [vc selectPhotos:MIN(SendPost_MaxPicSizeOneTime, SendPost_MaxPicTotalSize - photosNumber) selected:nil block:^(NSMutableArray *list) {
        [weakSelf handlePhotos:list];
    } failure:^(NSError *error) {
        DebugLog(@"%@",error);
        [vc closeAction:nil];
    }];
    
    UINavigationController *nav = [[QWBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

// 帖子中图片的数量
- (int)photosNumberInPost
{
    int totalPhotoNumber = 0;
    for (QWPostContentInfo* postCellModel in self.postCellArray) {
        if (postCellModel.postContentType == 2) {
            totalPhotoNumber++;
        }
    }
    return totalPhotoNumber;
}

// 上传图片数组， 返回图片model的数组
- (void)handlePhotos:(NSMutableArray*)list
{
    NSMutableArray* imageData = [NSMutableArray array];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"token"] = QWGLOBALMANAGER.configure.expertToken;
    param[@"type"] = @(4);
    for (PhotoModel* photoModel in list) {
        [imageData addObject:UIImageJPEGRepresentation(photoModel.fullImage, 0.1)];
    }
    [[HttpClient sharedInstance] ma_uploaderImg:imageData params:param withUrl:NW_uploadFile success:^(NSMutableArray *uploadFileArray) {
        NSLog(@"uploadFIleArray : %@", uploadFileArray);
        isModify = YES;
        // 排序
        NSArray* fileList =[uploadFileArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 isKindOfClass:[uploadFile class]] && [obj2 isKindOfClass:[uploadFile class]]) {
                uploadFile* file1 = obj1;
                uploadFile* file2 = obj2;
                if (file1.imageIndex < file2.imageIndex) {
                    return NSOrderedDescending;
                }
                else if (file1.imageIndex > file2.imageIndex) {
                    return NSOrderedAscending;
                }
            }
            return NSOrderedSame;
        }];
        NSLog(@"uploadFIleArray : %@", fileList);
        if (fileList.count == list.count) {
            for (int i = 0; i < fileList.count; i++) {
                uploadFile* file = fileList[i];
                if (!file.uploadSuccess) {
                    [list removeObjectAtIndex:i];
                    continue;
                }
                PhotoModel* photoModel = list[i];
                photoModel.imgURL = file.url;
            }
            [self handleUploadPhotos:list];
        }
        else
        {
            NSLog(@"upload imagearray  error : 上传的文件个数不正确");
        }
        
    } failure:^(HttpException *e) {
        ;
    } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        ;
    }];
    
    
}

// 上传图片后，添加图片帖子内容cell
- (void)handleUploadPhotos:(NSArray*)photoList
{
    /**
     *  4.0.0 add
     */
    BOOL needToAddBlankCellAtFirst = NO;
    if (self.postCellArray.count == 1) {
        QWPostContentInfo* model = self.postCellArray[0];
        if (model.postContentType == 1 && StrIsEmpty(model.postContent)) {
            needToAddBlankCellAtFirst = YES;
        }
    }
    
    // 如何添加图片  默认插入在队列的倒数第二个中
    NSInteger insertIndex = self.postCellArray.count - 1;
    // 如果没选中textView，而且最后一个文本中有文字 ，则添加一个空文本在队列中，并将插入对面索引加一
    if (tmpChooseImageSelectedIndex == -1) {
        QWPostContentInfo* lastCellModel = self.postCellArray[insertIndex];
        if (!StrIsEmpty(lastCellModel.postContent)) {
            QWPostContentInfo* newCellModel = [QWPostContentInfo new];
            newCellModel.postContentType = 1;
            [self.postCellArray addObject:newCellModel];
            insertIndex++;
        }
    }
    
    // 如果有选中文本
    if (selectTextView && tmpChooseImageSelectedIndex >= 0 && tmpChooseImageSelectedIndex < self.postCellArray.count) {
        NSInteger cursorIndex = [selectTextView selectedRange].location;
        //            PostCellModel* cellModel = self.postCellArray[tmpChooseImageSelectedIndex];
        QWPostContentInfo* cellModel = self.postCellArray[tmpChooseImageSelectedIndex];
        // 如果选中的textview是图文的cell，在下面插入图片
        insertIndex = tmpChooseImageSelectedIndex;
        if (cellModel.postContentType == 2) {
            insertIndex = tmpChooseImageSelectedIndex + 1;
        }
        // 如果光标在文本的第一位， 插入索引放在该位置上，即在该文本上方插入图片
        else if (cursorIndex == 0)
        {
            insertIndex = tmpChooseImageSelectedIndex;
        }
        else
        {
            // 如果光标在文本的最后，而且该文本是最后一个，则先加入一个空文本在队列中，并将插入索引加一
            if (cursorIndex == cellModel.postContent.length) {
                // 选择的是最后一个cell
                if (tmpChooseImageSelectedIndex == self.postCellArray.count - 1) {
                    QWPostContentInfo* newCellModel = [QWPostContentInfo new];
                    newCellModel.postContentType = 1;
                    [self.postCellArray addObject:newCellModel];
                }
                insertIndex = tmpChooseImageSelectedIndex+1;
            }
            // 光标在文本的中间， 则把该文本分成两个文本， 并将图片插入在中间
            else if (cursorIndex > 0 && cursorIndex < cellModel.postContent.length) {
                QWPostContentInfo* newCellModel = [QWPostContentInfo new];
                newCellModel.postContentType = 1;
                newCellModel.postContent = [cellModel.postContent substringToIndex:cursorIndex];
                [self.postCellArray insertObject:newCellModel atIndex:insertIndex];
                cellModel.postContent = [cellModel.postContent substringFromIndex:cursorIndex];
                insertIndex++;
            }
        }
    }
    selectTextView = nil;
    selectedIndex = -1;
    
    // 倒着加入
    for (int i = 0; i < photoList.count ; i++) {
        //            int index = MAX(0, weakSelf.postCellArray.count - 1);
        NSInteger index = insertIndex;
        PhotoModel *pohtomode = photoList[i];
        QWPostContentInfo* model = [QWPostContentInfo new];
        model.postContentType = 2;
        model.postContent = pohtomode.imgURL;
//        model.fullImage = pohtomode.fullImage;
        [self.postCellArray insertObject:model atIndex:index];
    }
    [self setSendBtnState];
    /**
     *  4.0.0 add
     */
    if (needToAddBlankCellAtFirst) {
        QWPostContentInfo* model = [QWPostContentInfo new];
        model.postContentType = 1;
        [self.postCellArray insertObject:model atIndex:0];
    }

    [self.tableView reloadData];
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotiEditPostTextViewBeginEdit) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            selectedIndex = ((NSIndexPath*)obj[@"indexPath"]).row;
            selectTextView = obj[@"textView"];
        }
        else
        {
            selectedIndex = -1;
            selectTextView = nil;
        }
    }
    else if (type == NotiEditPostTextViewDidEndEdit)
    {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath* indexPath = obj;
            NSLog(@"indexPahtrow : %d", indexPath.row);
        }
//        selectedIndex = -1;
    }
#ifndef CRChange_SendGotoNextPage
    else if (type == NotifSendPostResult) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"apiStatus"] integerValue] == 0) {
                PostDetailViewController* postDetailVC = (PostDetailViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
                postDetailVC.hidesBottomBarWhenPushed = YES;
                postDetailVC.postId = _postDetail.postId;
//                postDetailVC.postDetail = _postDetail;
//                postDetailVC.isSending = YES;
                postDetailVC.isFromSendPostVC = YES;
                postDetailVC.reminderExperts = [self expertIdsParamValue];
                postDetailVC.jumpType = @"sendPost";
                NSArray* viewControllers = self.navigationController.viewControllers;
                
                // 如果是从帖子详情里面过来的，删掉当前发送VC，和详情VC
                if (viewControllers.count > 2) {
                    UIViewController* preVC = viewControllers[viewControllers.count - 2];
                    if ([preVC isKindOfClass:[PostDetailViewController class]]) {
                        viewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, viewControllers.count - 2)];
                        viewControllers = [viewControllers arrayByAddingObject:postDetailVC];
                        self.navigationController.viewControllers = viewControllers;
                    }
                    else
                    {
                        viewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, viewControllers.count - 1)];
                        viewControllers = [viewControllers arrayByAddingObject:postDetailVC];
                        self.navigationController.viewControllers = viewControllers;
                    }
                }
                // 移除发送VC
                else if (viewControllers.count > 1) {
                    viewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, viewControllers.count - 1)];
                    viewControllers = [viewControllers arrayByAddingObject:postDetailVC];
                    self.navigationController.viewControllers = viewControllers;
                    
                }
                else
                {
                    self.navigationController.viewControllers = @[postDetailVC];
                }
            }
            else
            {
                
            }
        }
    }
#else
    else if (type == NotifSendPostCheckResult)
    {
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            PostDetailViewController* postDetailVC = (PostDetailViewController*)[[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
            postDetailVC.hidesBottomBarWhenPushed = YES;
            postDetailVC.postId = _postDetail.postId;
            postDetailVC.postDetail = _postDetail;
            postDetailVC.isSending = YES;
            postDetailVC.isFromSendPostVC = YES;
            postDetailVC.reminderExperts = [self expertIdsParamValue];
            postDetailVC.jumpType = @"sendPost";
            
            NSArray* viewControllers = self.navigationController.viewControllers;
            // 如果是从帖子详情里面过来的，删掉当前发送VC，和详情VC
            if (viewControllers.count > 2) {
                UIViewController* preVC = viewControllers[viewControllers.count - 2];
                if ([preVC isKindOfClass:[PostDetailViewController class]]) {
                    viewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, viewControllers.count - 2)];
                    viewControllers = [viewControllers arrayByAddingObject:postDetailVC];
                    self.navigationController.viewControllers = viewControllers;
                }
                else
                {
                    viewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, viewControllers.count - 1)];
                    viewControllers = [viewControllers arrayByAddingObject:postDetailVC];
                    self.navigationController.viewControllers = viewControllers;
                }
            }
            // 移除发送VC
            else if (viewControllers.count > 1) {
                viewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, viewControllers.count - 1)];
                viewControllers = [viewControllers arrayByAddingObject:postDetailVC];
                self.navigationController.viewControllers = viewControllers;
                
            }
            else
            {
                self.navigationController.viewControllers = @[postDetailVC];
            }
        }
    }
#endif
}


- (void)popVCAction:(id)sender
{
    // 判断是否修改，标题或者内容是否写了，时候有内容
    if (isModify && (!StrIsEmpty([self.postTitleTV.text mar_trim]) || [self checkPostContent])) {
        [self.view endEditing:YES];
        //    保存草稿箱
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"保存草稿", @"不保存", @"取消操作", nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        [super popVCAction:sender];
    }
}

- (BOOL)checkImageDesriptionLength:(NSArray*)postCellArray
{
    // 4.0.0 无文字描述，不需要check了。
//    int imageNum = 0;
//    for (QWPostContentInfo* postContentInfo in postCellArray) {
//        if (postContentInfo.postContentType == 2) {
//            imageNum ++;
//            if (postContentInfo.postContentDesc.length > 500) {
//                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"第%d张图片描述超字了，最大支持500字", imageNum] duration:DURATION_LONG];
//                return NO;
//            }
//        }
//    }
    return YES;
}

#pragma mark - 4.0.1 增加发帖字数限制： 标题字数<5字或正文字数<10字，
#pragma mark   点击“发布”按键，toast提示“标题不得少于5字，内容不得少于10字”
#pragma mark   当字数限制与时间间隔限制同时未满足时，字数限制的优先级高于时间间隔限制
- (BOOL)checkPostWordNumberLimit
{
    BOOL titleLimit = self.postTitleTV.text.length < 5;
    NSInteger wordNum = 0;
    for (QWPostContentInfo* postContentInfo in self.postCellArray) {
        if (postContentInfo.postContentType == 1) {
            wordNum += postContentInfo.postContent.length;
        }
    }
    BOOL contentLimit = wordNum < 10;
    if (titleLimit || contentLimit) {
        [SVProgressHUD showErrorWithStatus:@"标题不得少于5字，内容不得少于10字" duration:DURATION_LONG];
        return NO;
    }
    return YES;
}

- (IBAction)saveToDrafts:(id)sender {
//    if (StrIsEmpty(self.postTitleTV.text)) {
//        [SVProgressHUD showErrorWithStatus:@"请输入帖子标题"];
//        return;
//    }
//    
//    if(self.postCellArray.count == 1)
//    {
//        QWPostContentInfo* lastPostContent = [self.postCellArray lastObject];
//        if (lastPostContent.postContentType == 1 && StrIsEmpty(lastPostContent.postContent)) {
//            [SVProgressHUD showErrorWithStatus:@"请输入帖子内容"];
//            return;
//        }
//    }
    
    if (![self checkLogin]) { return; }
    if (![self checkImageDesriptionLength:self.postCellArray]) {
        return;
    }

    [self configPostDetailModel];
    QWPostDrafts* postDraft = [QWPostDrafts new];
    postDraft.postId = self.postDetail.postId;
    postDraft.passPort = self.postDetail.posterId;
    postDraft.postDetail = self.postDetail;
    postDraft.sendCircle = self.sendCircle;
    postDraft.reminderExperts = self.reminderExpertArray;
    if (self.postStatusType == PostStatusType_Editing) {
        postDraft.postStatus = PostStatusType_Editing;
    }
    else
    {
        if (sender) {
            postDraft.postStatus = PostStatusType_SaveDraft;
        }
        else
        {
            postDraft.postStatus = PostStatusType_WaitForPost;
        }
    }
    
    BOOL saveFlag = [postDraft saveToDB];
    if (sender) {
        if (saveFlag) {
            [SVProgressHUD showSuccessWithStatus:@"草稿保存成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            DDLogInfo(@"保存草稿失败 postid: %@", _postDetail.postId);
        }
    }
    DDLogInfo(@"save postId: %@, ok? : %d", self.postId, saveFlag);
    
}

- (IBAction)sendBtnAction:(id)sender {
    if (!self.sendCircle && StrIsEmpty(_postDetail.teamId)) {
        [SVProgressHUD showErrorWithStatus:@"请选择发帖的圈子"];
        return;
    }

    if (![self checkLogin]) { return; }
    if (![[AppealUtil sharedInstance] checkSilenceStatusWithVC:self]) {  return ; }
    if (![self checkPostWordNumberLimit]) { return; }
    if (![self checkImageDesriptionLength:self.postCellArray]) {
        return;
    }
    // 隐藏键盘
    [self.view endEditing:YES];
//    [self configPostDetailModel];
    [self saveToDrafts:nil];
    
    [Forum sendPostWithPostDetail:self.postDetail isEditing:(self.postStatusType == PostStatusType_Editing) reminderExperts:[self expertIdsParamValue]];
#ifndef CRChange_SendGotoNextPage
    // 发帖成功才跳到帖子详情
    return;
#endif
//    [self.navigationController pushViewController:postDetailVC animated:YES];

}

- (NSString*)expertIdsParamValue
{
    NSMutableString* expertIdsValue = [NSMutableString stringWithString:@""];
    for (QWExpertInfoModel* expert in self.reminderExpertArray) {
        if (expert == [self.reminderExpertArray firstObject]) {
            [expertIdsValue appendString:expert.id];
        }
        else
            [expertIdsValue appendFormat:@"%@%@", SeparateStr, expert.id];
    }
    return expertIdsValue;
}

- (QWPostDetailModel*)configPostDetailModel
{
    self.postDetail.postId = self.postId;
    _postDetail.postTitle = self.postTitleTV.text;
    _postDetail.posterId = QWGLOBALMANAGER.configure.expertPassportId;
    _postDetail.postStrDate = @"发布中...";
    if (self.sendCircle) {
        _postDetail.teamId = self.sendCircle.teamId;
        _postDetail.teamName = self.sendCircle.teamName;
    }
    NSString* userName = nil;
    if (!StrIsEmpty(QWGLOBALMANAGER.configure.expertNickName)) {
        userName = QWGLOBALMANAGER.configure.expertNickName;
    }
    else if (!StrIsEmpty(QWGLOBALMANAGER.configure.expertMobile))
    {
        userName = QWGLOBALMANAGER.configure.expertMobile;
    }
    else
    {
        userName = QWGLOBALMANAGER.configure.expertUserName;
    }
    _postDetail.nickname = userName;
    _postDetail.headUrl = QWGLOBALMANAGER.configure.expertAvatarUrl;
    _postDetail.posterType = QWGLOBALMANAGER.configure.expertType;;
    _postDetail.postStatus = PostStatusType_WaitForPost;  // 帖子状态
    _postDetail.flagAttn = self.sendCircle.flagAttn;
    _postDetail.flagMaster = self.sendCircle.flagMaster;
    _postDetail.postDate = [self.dateFormatter stringFromDate:[NSDate new]];
    // 4.0.0 增加
    _postDetail.flagAnon = self.anonymousBtn.selected;
    _postDetail.syncTeamId = self.sharedCircle.teamId;
    // 如果最后一个纯文本框中内容为空，删掉队列中的该
    NSMutableArray* tempPostCellArray = [self.postCellArray mutableCopy];
    QWPostContentInfo* lastPostContent = [tempPostCellArray lastObject];
    if (lastPostContent.postContentType == 1 && StrIsEmpty([lastPostContent.postContent mar_trim])) {
        [tempPostCellArray removeObject:lastPostContent];
    }
    // 如果第一个纯文本为空，则删掉
    if (self.postCellArray.count > 1) {
        QWPostContentInfo* firstPostContent = [tempPostCellArray firstObject];
        if (firstPostContent.postContentType == 1 && StrIsEmpty([firstPostContent.postContent mar_trim])) {
            [tempPostCellArray removeObject:firstPostContent];
        }
    }
    _postDetail.postContentList = tempPostCellArray;
    return _postDetail;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 保存草稿
        [self saveToDrafts:self.saveBtn]; // 保存成功自动返回上一级页面
//        [super popVCAction:nil];
    }
    else if (buttonIndex == 1)
    {
        // 不保存
        [super popVCAction:nil];
    }
    NSLog(@"did selected button index : %ld", (long)buttonIndex);
}


- (IBAction)chooseCircleBtnAction:(id)sender {
    MAAllCircleViewController* chooseCircleVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"MAAllCircleViewController"];
    __weak __typeof(self) weakSelf = self;
    chooseCircleVC.title = @"选择发帖的圈子";
    chooseCircleVC.selectedCircle = self.sendCircle;
    chooseCircleVC.selectCircleBlock = ^(QWCircleModel* circleModel){
        weakSelf.sendCircle = circleModel;
        isModify = YES;
    };
    [self.navigationController pushViewController:chooseCircleVC animated:YES];
}

- (void)choosePhotosBtnAction:(id)sender {
    [self LocalPhoto];
}

#pragma mark - 拍照的行为
- (void)takePhotoBtnAction:(id)sender {
    int photosNumber = [self photosNumberInPost];  // 帖子中图片的数量
    if (photosNumber >= SendPost_MaxPicTotalSize) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"一次最多可发%ld张图片", (long)SendPost_MaxPicTotalSize]];
        return;
    }
    tmpChooseImageSelectedIndex = selectedIndex;
    [self pickImageFromCamera];
}

- (IBAction)reminderExpertBtnAction:(id)sender {
//    if (self.isEditing) {
//        self.reminderExpertTipLabel.text = @"处于编辑状态不可用";
//        return;
//    }
    ChooseExpertViewController* chooseExpertVC = [[ChooseExpertViewController alloc] init];
    chooseExpertVC.selectedExpertArray = self.reminderExpertArray;
    __weak __typeof(self)weakSelf = self;
    chooseExpertVC.CallBackBlock = ^(NSMutableArray* expertArray){
        isModify = YES;
        weakSelf.reminderExpertArray = expertArray;
        if (weakSelf.reminderExpertArray.count > 0) {
            weakSelf.reminderExpertTipLabel.text = [NSString stringWithFormat:@"@已提醒%ld位专家", (long)weakSelf.reminderExpertArray.count];
        }
        else
        {
            weakSelf.reminderExpertTipLabel.text = @"@提醒专家看";
        }
        
    };
    [self.navigationController pushViewController:chooseExpertVC animated:YES];
}

- (BOOL)checkLogin
{
    if (!QWGLOBALMANAGER.loginStatus) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

//        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        UINavigationController *navgationController = [[QWBaseNavigationController alloc] initWithRootViewController:loginViewController];
//        loginViewController.isPresentType = YES;
//        [self presentViewController:navgationController animated:YES completion:NULL];
        return NO;
    }
    return YES;
}

#pragma mark - 拍照相关
// 拍照
- (void) pickImageFromCamera
{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerContrllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image;
    image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    PhotoModel* photoModel = [[PhotoModel alloc] init];
    photoModel.fullImage = image;
    [self handlePhotos:[NSMutableArray arrayWithObjects:photoModel, nil]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView delegete
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag >= 0) {
        [self removePostModelIndex:alertView.tag];
    }
}

- (IBAction)reminderExpertOrShareCircleBtnAction:(id)sender
{
    if (self.isStoreCircle) {
        if (self.sharedCircle) {
            [QWGLOBALMANAGER statisticsEventId:[NSString stringWithFormat:@"发帖_分享至%@按键", self.sharedCircle.teamName] withLable:nil withParams:nil];
        }
        else
        {
            [QWGLOBALMANAGER statisticsEventId:@"发帖_分享至公共圈按键" withLable:nil withParams:nil];
        }
        
        if (![self checkLogin]) { return; }
        ChooseCircleViewController* chooseCircleVC = [[ChooseCircleViewController alloc] init];
        chooseCircleVC.selectedCircleModel = self.sharedCircle;
        __weak __typeof(self) weakSelf = self;
        chooseCircleVC.SelectCircleBlock = ^(QWCircleModel* circle)
        {
            weakSelf.sharedCircle = circle;
        };
        [self.navigationController pushViewController:chooseCircleVC animated:YES];
    }
    else
    {
        if (![self checkLogin]) { return; }
        ChooseExpertViewController* chooseExpertVC = [[ChooseExpertViewController alloc] init];
        chooseExpertVC.selectedExpertArray = self.reminderExpertArray;
        __weak __typeof(self)weakSelf = self;
        chooseExpertVC.CallBackBlock = ^(NSMutableArray* expertArray){
            if (self.reminderExpertArray.count > 0) {
                NSMutableString* expertNames = [NSMutableString string];
                for (int index = 0; index < self.reminderExpertArray.count; index++) {
                    QWExpertInfoModel* expertInfo = self.reminderExpertArray[index];
                    if (index == self.reminderExpertArray.count - 1) {
                        [expertNames appendString:StrDFString(expertInfo.nickName, @"")];
                    }
                    else
                    {
                        [expertNames appendString:[NSString stringWithFormat:@"%@、",StrDFString(expertInfo.nickName, @"")]];
                    }
                }
            }

            isModify = YES;
            weakSelf.reminderExpertArray = expertArray;
            if (weakSelf.reminderExpertArray.count > 0) {
                weakSelf.bottomTipLabel.text = [NSString stringWithFormat:@"@已提醒%ld位专家", (long)weakSelf.reminderExpertArray.count];
            }
            else
            {
                weakSelf.bottomTipLabel.text = @"@提醒专家看";
            }
            
        };
        [self.navigationController pushViewController:chooseExpertVC animated:YES];
    }
}

- (IBAction)anonymousBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.anonymousChooseImageView.hidden = !sender.selected;
}

@end
