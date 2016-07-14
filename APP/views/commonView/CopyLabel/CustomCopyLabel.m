//
//  CustomCopyLabel.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CustomCopyLabel.h"

@implementation CustomCopyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 给Label添加长按手势
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(labelLongPress)]];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    // 给Label添加手势
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(labelLongPress)]];
}

- (void)labelLongPress
{
    // 让label成为第一响应者
    [self becomeFirstResponder];
    
    // 获得菜单
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    // 设置菜单内容，显示中文，所以要手动设置app支持中文
    menu.menuItems = @[
                       [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyyyy:)],
                       ];
    
    // 菜单最终显示的位置
    [menu setTargetRect:self.bounds inView:self];
    
    // 显示菜单
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - UIMenuController相关
/**
 * 让Label具备成为第一响应者的资格
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/**
 * 通过第一响应者的这个方法告诉UIMenuController可以显示什么内容
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ( (action == @selector(copyyyy:) && self.text) // 需要有文字才能支持复制
       ) return YES;
    
    return NO;
}

#pragma mark - 监听MenuItem的点击事件
- (void)copyyyy:(UIMenuController *)menu
{
    // 将label的文字存储到粘贴板
    
    if (!StrIsEmpty(self.text)) {
        if ([self.text hasPrefix:@"回帖："]) {
            NSString *str = [self.text substringFromIndex:3];
            [UIPasteboard generalPasteboard].string = str;
        }else{
            [UIPasteboard generalPasteboard].string = self.text;
        }
    }
}

@end
