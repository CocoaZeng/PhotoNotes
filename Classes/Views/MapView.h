//
//  MapView.h
//  PhotoNotes
//
//  Created by Zeng Wang on 8/30/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppSharedUserInfo.h"
#import "MapAnnotation.h"

@class MapView;
@protocol mapViewDelegate <NSObject>

- (void)mapView:(MapView *)mapView didSelectPhoto:(UIImage *)image withComments:(NSString *)comments withAssetURL:(NSString *)assetURL;
@end

@interface MapView : MKMapView <MKMapViewDelegate>
@property (assign, nonatomic)id<mapViewDelegate> mapViewDelegate;

@end