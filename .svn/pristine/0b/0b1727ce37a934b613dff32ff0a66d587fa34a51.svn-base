//
//  TKTextView.h
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


//判断iphone6
#define kMariPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6+
#define kMariPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kMarPostImageTextViewWidth (kMariPhone6 ? 263 : (kMariPhone6Plus ? 302 : 0))
#define kMarPostTextViewWidth (kMariPhone6 ? 329 : (kMariPhone6Plus ? 360 : 0))

@import UIKit;
/** This class creates a `UITextView` with placeholder text. */
@interface TKTextView : UITextView

///----------------------------
/// @name Properties
///----------------------------

/** The placeholder label. */
@property (nonatomic,strong) UILabel *placeHolderLabel;


/** The placeholder text. */
@property (nonatomic,strong) NSString *placeholder;

/** The text color of the placehold text. */
@property (nonatomic,strong) UIColor *placeholderColor;

@property (nonatomic,assign,setter=setSendPost:) BOOL isSendPost;
@property (nonatomic,copy) void (^doneBlock)();
@property (nonatomic,copy) void (^chooseImageBlock)();
@property (nonatomic,copy) void (^takePhotoBlock)();
@end