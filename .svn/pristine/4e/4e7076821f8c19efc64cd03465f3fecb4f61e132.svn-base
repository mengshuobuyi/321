//
//  MessageSegmentControl.m
//  wenYao-store
//  自定义UISegementControl控件
//  Created by 李坚 on 16/3/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MessageSegmentControl.h"

@implementation MessageSegmentControl

- (instancetype)init{
    
    if(self == [super init]){
        self.selectedSegmentIndex = 0;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}

- (void)segementSelectAtIndex:(NSInteger)selectedSegmentIndex{
    
    UIButton *btn = [self viewWithTag:(selectedSegmentIndex + 100)];
    [self didClickBtn:btn];
}


- (void)setDataource:(id<MessageSegmentControlDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    if ([_datasource numberOfItems] == 0) {
        return;
    }
    [self loadData];
}

- (void)loadData
{
    //从当前控件上移除所有的subview
    NSArray *subViews = [self subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (int i = 0; i < [_datasource numberOfItems]; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * 55, 0, 55, 30)];
        btn.tag = i + 100;
        [btn setTitle:[_datasource titleForItem:i] forState:UIControlStateNormal];
        if(self.titleFont){
            btn.titleLabel.font = self.titleFont;
        }else{
            btn.titleLabel.font = fontSystem(kFontS4);
        }
        btn.titleLabel.font = fontSystem(kFontS4);
        if(i == self.selectedSegmentIndex){
            [self changeButton:btn Status:YES];
        }else{
            [self changeButton:btn Status:NO];
        }

        UIView *messageLabel = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.size.width - 12, 4, 6, 6)];
        messageLabel.tag = i + 200;
        messageLabel.backgroundColor = RGBHex(qwColor3);
        messageLabel.hidden = YES;
        messageLabel.layer.masksToBounds = YES;
        messageLabel.layer.cornerRadius = 3.0f;
        [btn addSubview:messageLabel];
        
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if(i != 0){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(i * 55, 0, 1.0f, btn.frame.size.height)];
            line.backgroundColor = RGBHex(qwColor4);
            [self addSubview:line];
        }
    }
    CGRect rect = self.frame;
    rect.size.width = [_datasource numberOfItems] * 55.0f;
    rect.size.height = 30.0f;
    self.frame = rect;
}

- (void)showBadgePoint:(BOOL)enabled itemTag:(NSInteger)itemTag{
    
    UILabel *msgLabel = [self viewWithTag:(itemTag + 200)];
    if(enabled){
        msgLabel.hidden = NO;
    }else{
        msgLabel.hidden = YES;
    }
    
}

- (void)didClickBtn:(UIButton *)button{
    
    self.selectedSegmentIndex = button.tag - 100;
    
    for (int i = 0; i < [_datasource numberOfItems]; i++) {
        
        UIButton *btn = [self viewWithTag:(i + 100)];
        if([btn isEqual:button]){
            [self changeButton:btn Status:YES];
        }else{
            [self changeButton:btn Status:NO];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(didCilckItemAtIndex:atIndex:)]){
        [self.delegate didCilckItemAtIndex:self atIndex:(button.tag - 100)];
    }
}

- (void)changeButton:(UIButton *)btn Status:(BOOL)selected{
    
    if(selected){
        //选中状态
        if([_datasource respondsToSelector:@selector(itemTitleSelectedColor)]){
            [btn setTitleColor:[_datasource itemTitleSelectedColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        }
        if([_datasource respondsToSelector:@selector(itemBackgroundSelectedColor)]){
            [btn setBackgroundColor:[_datasource itemBackgroundSelectedColor]];
        }else{
            [btn setBackgroundColor:RGBHex(qwColor4)];
        }
    }else{
        //普通状态
        if([_datasource respondsToSelector:@selector(itemTitleNormalColor)]){
            [btn setTitleColor:[_datasource itemTitleNormalColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
        }
        if([_datasource respondsToSelector:@selector(itemBackgroundNormalColor)]){
            [btn setBackgroundColor:[_datasource itemBackgroundNormalColor]];
        }else{
            [btn setBackgroundColor:RGBHex(qwColor1)];
        }
    }
}

@end
