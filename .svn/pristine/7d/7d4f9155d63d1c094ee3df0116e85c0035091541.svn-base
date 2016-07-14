//
//  AddNewMarketActivityViewController.h
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"
#import "Activity.h"

@interface AddNewMarketActivityViewController : QWBaseVC<UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UIActionSheetDelegate>


@property (nonatomic, copy) void(^InsertNewMarketActivity)(QueryActivityInfo *dict);
//用来传值的model
@property (nonatomic, strong) QueryActivityInfo       *infoNewDict;
//用来接收得model
@property (nonatomic, strong) QueryActivityInfo       *oldDict;


@property (nonatomic, strong) IBOutlet UITextField               *titleTextField;
@property (nonatomic, strong) IBOutlet UITextView                *textView;
@property (nonatomic, strong) IBOutlet UIButton                  *delTitleButton;
@property (nonatomic, strong) IBOutlet UILabel                   *countLabel;
@property (nonatomic, strong) IBOutlet UILabel                   *hintLabel;
@property (nonatomic, strong) IBOutlet UIButton                  *addImageButton;
@property (nonatomic, strong) IBOutlet UIButton                  *delImageButton;
@property (nonatomic, strong) IBOutlet UIImageView               *previewImage;
@property (weak, nonatomic) IBOutlet UIView *topview;
@property (weak, nonatomic) IBOutlet UIView *centerview;

- (IBAction)postImage:(id)sender;
- (IBAction)deleteImage:(id)sender;
- (IBAction)deleteTitleField:(UIButton *)sender;



@end
