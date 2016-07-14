//
//  ShowLocationViewController.m
//  wenyao
//
//  Created by garfield on 15/3/3.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "ShowLocationViewController.h"
#import "CustomAnnotationView.h"
#import "AppDelegate.h"

@interface ShowLocationViewController ()<MAMapViewDelegate>

@end

@implementation ShowLocationViewController

- (void)initMapView
{
    [QWGLOBALMANAGER.mapView removeAnnotations:QWGLOBALMANAGER.mapView.annotations];
    QWGLOBALMANAGER.mapView.showsUserLocation = NO;
    QWGLOBALMANAGER.mapView.frame = self.view.bounds;
    QWGLOBALMANAGER.mapView.delegate = self;
    [self.view addSubview:QWGLOBALMANAGER.mapView];
}

- (void)unloadMapView
{
    QWGLOBALMANAGER.mapView.delegate = nil;
    QWGLOBALMANAGER.mapView.mapType = MAMapTypeStandard;
    [QWGLOBALMANAGER.mapView removeAnnotations:QWGLOBALMANAGER.mapView.annotations];
    [QWGLOBALMANAGER.mapView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的位置";
    [self initMapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CLLocationDegrees latitude = self.coordinate.latitude;
    CLLocationDegrees longitude = self.coordinate.longitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [QWGLOBALMANAGER.mapView setRegion:MACoordinateRegionMake(coordinate, MACoordinateSpanMake(0.005328, 0.008454)) animated:NO];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = coordinate;
    pointAnnotation.title = self.address;
    [QWGLOBALMANAGER.mapView addAnnotation:pointAnnotation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self unloadMapView];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[QWGLOBALMANAGER.mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
        }
        annotationView.portrait = [UIImage imageNamed:@"currentpoint.png"];
        
        return annotationView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
