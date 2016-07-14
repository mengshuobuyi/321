//
//  SendPostViewController.h
//  APP
//
//  Created by Martin.Liu on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "Forum.h"
//@interface PostCellModel : BaseAPIModel
//@property (nonatomic, assign) NSInteger postType;  // 0.文字   1：图文（未编辑）
//@property (nonatomic, strong) NSString* contentString;
//@property (nonatomic, strong) NSString* imageURL;
//@property (nonatomic, strong) UIImage* fullImage;
//@end
@interface SendPostViewController : QWBaseVC
@property (nonatomic, strong) QWCircleModel* sendCircle;
@property (nonatomic, assign) BOOL needChooseCircle;        // default is NO
// 编辑帖子
@property (nonatomic, assign) BOOL              isStoreCircle;          // 4.0.0是否是从商家圈进来的
@property (nonatomic, assign) BOOL isEditing;               // default is NO
@property (nonatomic, assign) PostStatusType postStatusType;  // 进入发送帖子时候不用赋值， 如果从草稿箱进来的需要把草稿箱中的model的postStatusType赋值过来，如果从详情点击编辑
@property (nonatomic, strong) QWPostDetailModel* postDetail;
@property (nonatomic, strong) NSMutableArray* reminderExpertArray;
@end
