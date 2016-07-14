//
//  MapViewController.h
//  wenyao-store
//
//  Created by Meng on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "QWBaseVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapCommonObj.h>

@protocol MapViewControllerDelegate <NSObject>


- (void)pickUserLocation:(NSDictionary *)location;

@end

@interface MapViewController : QWBaseVC

@property (nonatomic ,strong) NSDictionary * userLocationDic;

@property (nonatomic ,assign) id<MapViewControllerDelegate>delegate;
@property(assign,nonatomic)BOOL ComfromQuick;

@end





@interface MyAnnotation : MAPointAnnotation<MAAnnotation>


- (id)initWithGeocode:(AMapGeocode *)geocode;

@property (nonatomic, strong) AMapGeocode *geocode;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;

@end


@interface MyAnnotationView : MAAnnotationView

@property (nonatomic, retain) NSMutableDictionary* store;
@property (nonatomic ,strong) UIImageView * iconView;

@end