//
//  MapAnnotation.h
//  PhotoNotes
//
//  Created by Zeng Wang on 9/17/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "imageDataSource.h"

@interface MapAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (strong, nonatomic) ALAsset *asset;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) NSString *assetURL;

- (id)initWithAsset:(ALAsset *)asset withComments:(NSString *)comments withAssetURL:(NSString *)assetURL;

@end
