//
//  RefCodeModelR.h
//  wenYao-store
//
//  Created by PerryChen on 3/23/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "BaseModel.h"

@interface RefCodeModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *objType;
@property (nonatomic, strong) NSString *objId;
@property (nonatomic, strong) NSString *channel;
@end
