//
//  AddLabelViewController.h
//  wenyao-store
//
//  Created by Meng on 14-10-27.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"
@protocol addLabeldelegate <NSObject>

-(void)addLabeldelegate:(NSString *)labeltext;

@end

@interface AddLabelViewController : QWBaseVC

@property (weak,nonatomic) id<addLabeldelegate>delegate;
@property (strong, nonatomic) NSMutableArray *labelArray;

@end
