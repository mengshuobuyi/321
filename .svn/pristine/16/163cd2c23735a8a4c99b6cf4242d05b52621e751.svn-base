//
//  QWInputTextField.m
//  PayPassWord
//
//  Created by 度周末网络-王腾 on 16/4/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "QWInputTextField.h"

@implementation QWInputTextField

- (void)drawRect:(CGRect)rect {
    
    
    CGFloat width  = rect.size.width ;
    CGFloat height = rect.size.height;

    CGFloat lineSpace = 15.0f;
    CGFloat lineWidth = (width-((self.inputCount-1)*lineSpace))/self.inputCount;
    
    // 创建存储坐标的数组
    NSMutableArray <NSValue *>*frameArr = [NSMutableArray array];
    
    // 绘制横线
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 1; i <= self.inputCount; i++) {
        
        // 绘制横线
        [self.lineColor setStroke];
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, (i-1) *(lineWidth + lineSpace), height-height/4-7);
        CGContextAddLineToPoint(context, (i-1) *(lineWidth + lineSpace) +lineWidth , height-height/4-7);
        CGContextStrokePath(context);
        
        [frameArr addObject:[NSValue valueWithCGRect:CGRectMake((i-1) *(lineWidth + lineSpace),0, lineWidth, height-height/4)]];
    }
  
    
    // 绘制文字
    if (self.text.length) {
        for (int i = 0; i < self.text.length; i++) {
            NSString *text  = [self.text substringWithRange:NSMakeRange(i, 1)];
            if (self.isPassWord) {
                text = @"*";
            }
            
            CGRect textRect =  [frameArr[i] CGRectValue];
            
            NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            NSDictionary*attribute = @{NSFontAttributeName:self.font,
                                       NSParagraphStyleAttributeName:paragraphStyle,
                                       NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            
            [text drawWithRect:textRect options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
            
        }
        
    }else{
        
        
        for (NSInteger i =0; i < frameArr.count; i ++) {
            NSString *text  = @"";
            CGRect textRect =  [frameArr[i] CGRectValue];
            
            NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            NSDictionary*attribute = @{NSFontAttributeName:self.font,
                                       NSParagraphStyleAttributeName:paragraphStyle,
                                       NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            
            [text drawWithRect:textRect options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        }
    }
}

/**
 *  清除内容
 */
-(void)clearText{
    self.text = nil;
    [self setNeedsDisplay];
}

/**
 *  监听文字的变化,当文字变化后重绘视图
 *
 *  @param sender
 */
- (void)passWordDidChange:(UITextField *)sender{
    if (sender.text.length > self.inputCount) {
        NSRange range = NSMakeRange(0, self.inputCount);
        sender.text = [sender.text substringWithRange:range];
    }
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}


-(void)initData{
    
    // 让光标永远是透明色
    self.tintColor = [UIColor clearColor];
    
    // 让文字永远是透明色
    self.textColor = [UIColor clearColor];
    
    // 英文键盘
    self.keyboardType = UIKeyboardTypePhonePad;
    
    // 监听文字变化
    [self addTarget:self action:@selector(passWordDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.lineColor = [UIColor darkGrayColor];
}


-(void)awakeFromNib{
    [self initData];
}

/**
 *  是否是密码
 *
 *  @param isPassWord
 */
-(void)setIsPassWord:(BOOL)isPassWord{
    _isPassWord = isPassWord;
    [self setNeedsDisplay];
}

/**
 *  不显示placeholder
 *
 *  @param placeholder
 */
-(void)setPlaceholder:(NSString *)placeholder{
    
}

/**
 *  让光标永远是透明色
 *
 *  @param tintColor
 */
-(void)setTintColor:(UIColor *)tintColor{
    tintColor = [UIColor clearColor];
    [super setTintColor:tintColor];
}

/**
 *  让文字永远是透明色
 *
 *  @param textColor
 */
-(void)setTextColor:(UIColor *)textColor{
    textColor = [UIColor clearColor];
    [super setTextColor:textColor];
}


/**
 *  禁用复制粘贴的功能
 *
 *  @param action
 *  @param sender
 *
 *  @return
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

/**
 *  英文键盘
 *
 *  @param keyboardType
 */
-(void)setKeyboardType:(UIKeyboardType)keyboardType{
    keyboardType = UIKeyboardTypePhonePad;
    [super setKeyboardType:keyboardType];
}

@end
