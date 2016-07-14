//
//  BaseChatViewController.h
//  wenYao-store
//
//  Created by 李坚 on 16/3/22.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "ChatHeader.h"

@interface BaseChatViewController : QWBaseVC

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, assign) BOOL isUserScrolling;

@property (nonatomic ,assign)BOOL  didScrollOrReload;

@property (nonatomic ,assign)BOOL  didScrollOrLoad;

@property (nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;//录音UI,按住说话,松开发送,拖拽出button 取消发送

@property (nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;//管理录音工具对象

@property (nonatomic) BOOL isMaxTimeStop;//判断是不是超出了录音最大时长
/**
 *  用于显示发送消息类型控制的工具条，在底部
 */
@property (nonatomic, strong, readonly) XHMessageInputView *messageInputView;
@property (nonatomic, assign) XHInputViewType textViewInputViewType;
@property (nonatomic, strong, readwrite) XHShareMenuView *shareMenuView;
/**
 *  管理第三方gif表情的控件
 */
@property (nonatomic, strong) XHEmotionManagerView *emotionManagerView;
/**
 *  表情数据源
 */
@property (nonatomic, strong) NSArray *emotionManagers;
/**
 *  第三方接入的功能，也包括系统自身的功能，比如拍照、发送地理位置
 */
@property (nonatomic, strong) NSArray *shareMenuItems;

- (void)layoutOtherMenuViewHiden:(BOOL)hide;

//表情键盘点击发送回调
- (void)didSendEmojiTextAction:(id)sender;
//Action发送语音触发，开发给子类使用
- (void)didSendVoiceFileAction:(MessageModel *)filePath;
//相册图片选择完成回调
-(void)didSendImageFileAction:(NSMutableArray *)imgArr;

- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)initKeyboardBlock;
- (void)hiddenKeyboard;

//XHShareMenuView初始化赋值，不调用默认有相机和相册
- (void)setupShareMenuViewImgArr:(NSArray *)imgArr andTitleArr:(NSArray *)titleArr;
//XHShareMenuView点击某个item触发
- (void)didSelectedShareMenuViewAtIndex:(NSInteger)index;

- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView;
- (void)pushToDrugDetailWithDrugID:(NSString *)drugId promotionId:(NSString *)promotionID;
//打开本地相册
- (void)LocalPhoto;
//打开照相机
-(void)takePhoto;

@end
