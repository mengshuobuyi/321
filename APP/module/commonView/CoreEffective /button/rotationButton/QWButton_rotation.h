//
//  MyClass.h
//  QWCore
//
//  Created by QW liang on 12-2-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    QWButtonRotationStateLeft,
    QWButtonRotationStateUp,
    QWButtonRotationStateRight,
    QWButtonRotationStateDown
}QWButtonRotationState;



@interface QWButton_rotation : UIButton
{
    //是否摇摆的标识
    bool isRocker;
    
}

- (id)initWithFrame:(CGRect)frame 
        centerState:(QWButtonRotationState)centerState;

-(void)startRocker;
-(void)stopRocker;

@end
