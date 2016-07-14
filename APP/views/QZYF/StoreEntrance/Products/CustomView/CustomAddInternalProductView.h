//
//  CustomAddInternalProductView.h
//  wenYao-store
//
//  Created by PerryChen on 6/13/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAddInternalProductView : UIView

@property (nonatomic, copy) void(^ blockManual)();
@property (nonatomic, copy) void(^ blockScan)();

- (IBAction)actionDismiss:(id)sender;
- (IBAction)actionInputManual:(id)sender;
- (IBAction)actionInputScan:(id)sender;

@end
