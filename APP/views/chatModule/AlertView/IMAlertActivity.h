//
//  IMAlertActivity.h
//  wenYao-store
//
//  Created by Yan Qingyang on 15/9/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseAlert.h"
#import "QWTextFieldMargin.h"
@interface IMAlertActivity : QWBaseAlert<UITextFieldDelegate>
{
    IBOutlet UILabel *lblTTL,*lblContent;
    IBOutlet UIImageView *imgPhoto;
    IBOutlet QWTextFieldMargin *txtWord;
}

+(id)instance;
@end
