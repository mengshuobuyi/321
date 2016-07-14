//
//  PostCommentViewController.h
//  APP
//
//  Created by Martin.Liu on 16/4/18.
//  Copyright © 2016年 carret. All rights reserved.
//

typedef NS_ENUM(NSInteger, QWPostCommentType) {
    QWPostCommentTypeReplyPost,
    QWPostCommentTypeReplyComment,
};

#import "QWBaseVC.h"

@interface PostCommentViewController : QWBaseVC
@property (nonatomic, assign) QWPostCommentType postCommentType;
@property (nonatomic, strong) NSString *teamId;     // 圈子ID
@property (nonatomic, strong) NSString *postId;     // 帖子ID
@property (nonatomic, strong) NSString *postTitle;  // 帖子标题
@property (nonatomic, strong) NSString *replyId;    // 评论的ID， 如果是评论帖子则设置为空
@end
