//
//  TKTextView.m
//  Created by Devin Ross on 5/18/13.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#ifndef kiPhone6Plus
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

@interface MarToolBar : UIToolbar

@end

@implementation MarToolBar

@end

#import "TKTextView.h"

@interface TKTextView()
@property (nonatomic, strong) MarToolBar* toolBar;
@end

@implementation TKTextView


#pragma mark Init & Friends
- (instancetype) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	[self _setupView];
    return self;
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder{
	if(!(self=[super initWithCoder:aDecoder])) return nil;
	[self _setupView];
    return self;
}
- (void) awakeFromNib{
    [super awakeFromNib];
	[self _setupView];
}
- (void) _setupView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}
- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) drawRect:(CGRect)rect{
	[super drawRect:rect];
	
	
	if(_placeHolderLabel){
		if(self.placeHolderLabel.superview==nil){
			[self addSubview:self.placeHolderLabel];
			[self sendSubviewToBack:self.placeHolderLabel];
		}
		
		if([self respondsToSelector:@selector(textContainer)])
			self.placeHolderLabel.frame = CGRectMake(4, self.textContainerInset.top, CGRectGetWidth(self.bounds) - 8, 0);
		else
			self.placeHolderLabel.frame = CGRectMake(8,8,CGRectGetWidth(self.bounds) - 16,0);
		
		
		
		
		[self.placeHolderLabel sizeToFit];
		
	}
    
	_placeHolderLabel.alpha = self.text.length < 1 ? 1 : 0;
	
}


- (void) _textChanged:(NSNotification *)notification{
    if(self.placeholder.length == 0) return;
	_placeHolderLabel.alpha = self.text.length < 1 ? 1 : 0;
}


#pragma mark Properties
- (void) setFont:(UIFont *)font{
	[super setFont:font];
	self.placeHolderLabel.font = font;
	[self setNeedsDisplay];
}
- (void) setText:(NSString *)text{
    [super setText:text];
    [self _textChanged:nil];
}
- (void) setPlaceholder:(NSString *)placeholder{
	
	if(placeholder.length < 1){
		_placeHolderLabel.text = placeholder;
		[self setNeedsDisplay];
		return;
	}
	
	self.placeHolderLabel.text = placeholder;
	[self setNeedsDisplay];
}
- (NSString*) placeholder{
	return _placeHolderLabel.text;
}
- (void) setPlaceholderColor:(UIColor *)placeholderColor{
	self.placeHolderLabel.textColor = placeholderColor;
	[self setNeedsDisplay];
}
- (UIColor*) placeholderColor{
	return _placeHolderLabel.textColor;
}
- (UILabel*) placeHolderLabel{
	if(_placeHolderLabel) return _placeHolderLabel;
	
	_placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,CGRectGetWidth(self.bounds) - 16,0)];
	_placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
	_placeHolderLabel.numberOfLines = 0;
	_placeHolderLabel.font = self.font;
	_placeHolderLabel.backgroundColor = [UIColor clearColor];
	_placeHolderLabel.textColor = [UIColor lightGrayColor];
	
	
	if([self respondsToSelector:@selector(textContainer)]){
		
		_placeHolderLabel.textColor = [UIColor colorWithWhite:0.80 alpha:1];
		_placeHolderLabel.frame = CGRectMake(2, 8, CGRectGetWidth(self.bounds) - 8, 0);
		
	}
	
	
	
	
	_placeHolderLabel.alpha = 0;
	return _placeHolderLabel;
}

- (MarToolBar *)toolBar
{
    if (!_toolBar) {
        float toolBarHeight = 44;
        _toolBar = [[MarToolBar alloc] initWithFrame:CGRectMake(0, 0, APP_W, toolBarHeight)];
        _toolBar.translucent = NO;
        _toolBar.tintColor = [UIColor whiteColor];
        [[UIBarButtonItem appearanceWhenContainedIn:[MarToolBar class], nil] setTintColor:RGBHex(0x999999)];
        UIBarButtonItem* chooseImageBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_post_photo"] style:UIBarButtonItemStyleDone target:self action:@selector(chooseImageBtnAction:)];
        
        UIBarButtonItem* fixedSpaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceBtn.width = 50;
        
        UIBarButtonItem* takePhotoBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_post_camera"] style:UIBarButtonItemStyleDone target:self action:@selector(takePhotoBarBtnAction:)];
        
        UIBarButtonItem* spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        UIBarButtonItem* hiddenKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_post_keyboard"] style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
        [_toolBar setItems:@[chooseImageBarBtn,fixedSpaceBtn,takePhotoBarBtn,spaceBtn,hiddenKeyboard]];
    }
    return _toolBar;
}

- (void)setSendPost:(BOOL)isSendPost
{
    if (isSendPost) {
        self.inputAccessoryView = self.toolBar;
    }
    else
    {
        self.inputAccessoryView = nil;
        self.toolBar = nil;
    }
}

- (void)chooseImageBtnAction:(id)sender
{
    if (self.chooseImageBlock) {
        self.chooseImageBlock();
    }
}

- (void)takePhotoBarBtnAction:(id)sender
{
    if(self.takePhotoBlock)
    {
        self.takePhotoBlock();
    }
}

- (void)resignFirstResponder:(id)sender
{
    [self resignFirstResponder];
}

- (void)done:(id)sender
{
    [self resignFirstResponder];
    if (self.doneBlock) {
        self.doneBlock();
    }
}

@end
