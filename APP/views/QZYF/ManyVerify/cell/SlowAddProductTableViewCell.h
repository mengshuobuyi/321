//
//  ManageTableViewCell.h
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"

@protocol MyCustomCellDelegate <NSObject>

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag andField:(NSString*)quantity;
-(void)btnChange:(UITableViewCell *)cell andField:(NSString*)quantity;
@end

@interface SlowAddProductTableViewCell : QWBaseTableCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property (weak, nonatomic) IBOutlet QWImageView *productImage;
@property (weak, nonatomic) IBOutlet QWLabel *proName;
@property (weak, nonatomic) IBOutlet QWLabel *spec;
@property (weak, nonatomic) IBOutlet UIButton *deleButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@property(assign,nonatomic)BOOL selectState;//选中状态

@property(assign,nonatomic)id<MyCustomCellDelegate>delegate;





@end
