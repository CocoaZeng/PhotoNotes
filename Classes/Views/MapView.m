//
//  MapView.m
//  PhotoNotes
//
//  Created by Zeng Wang on 8/30/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import "MapView.h"
#import "constants.h"
@interface MapView()

@property (strong, nonatomic) NSMutableArray *mapAnnotations;

- (void)addAnnotations;

@end

@implementation MapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnnotations) name:kAssetLoadedNotification object:nil];
        self.delegate = self;
    }
    return self;
}

- (void)addAnnotations
{
    if (nil == self.mapAnnotations) {
        self.mapAnnotations = [[NSMutableArray alloc] init];
    }
    else
    {
        [self removeAnnotations:self.annotations];
        [self.mapAnnotations removeAllObjects];
    }
    NSMutableArray *userAssets = [[AppSharedUserInfo sharedData] userAssets];
    if (userAssets)
    {
        // For each asset in userAssert array, if asset has location information, add an annotation for it in map.
        for (int i = 0; i < [userAssets count]; i++)
        {
            NSDictionary *dict = [userAssets objectAtIndex:i];
            NSString *assetURL = [[dict allKeys] objectAtIndex:0];
            ALAsset *asset = [[dict objectForKey:assetURL] objectAtIndex:0];
            NSString *comments = [[dict objectForKey:assetURL] objectAtIndex:1];
            MapAnnotation *mapAnnotation = [[MapAnnotation alloc] initWithAsset:asset
                                                                   withComments:comments
                                                                   withAssetURL:assetURL];
            if (mapAnnotation.coordinate.latitude != 0 && mapAnnotation.coordinate.longitude != 0)
            {
                [self.mapAnnotations addObject:mapAnnotation];
                if (i == 0)
                {
                    MKCoordinateRegion mapRegion = MKCoordinateRegionMake([mapAnnotation coordinate], MKCoordinateSpanMake(2.0, 2.0));
                    [self setRegion:mapRegion animated:YES];
                }
            }
        }
    }
    [self addAnnotations:self.mapAnnotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = kAnnotationIdentifier;
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (pinAnnotationView == nil)
    {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        UIImageView *thumbnailImageView = [[UIImageView alloc] init];
        pinAnnotationView.leftCalloutAccessoryView = thumbnailImageView;
    }
    
    pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.canShowCallout = YES;
    
    // add left callout accessory view
    ALAsset *asset = [(MapAnnotation *)annotation asset];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    [(UIImageView *)pinAnnotationView.leftCalloutAccessoryView setImage:thumbnail];
    CGRect newBounds = CGRectMake(0.0, 0.0, 32.0, 32.0);
    [(UIImageView *)pinAnnotationView.leftCalloutAccessoryView setBounds:newBounds];
    
    // add right callout accessory view
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinAnnotationView.rightCalloutAccessoryView = detailButton;
    
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (nil == self.mapViewDelegate) {
        return;
    }
    ALAsset *asset = [(MapAnnotation *)view.annotation asset];
    UIImage *image = [[UIImage alloc] initWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    NSString *assetURL = [(MapAnnotation *)view.annotation assetURL];
    NSString *comments =[(MapAnnotation *)view.annotation comments];
    if ([comments isEqualToString:@""])
    {
        comments = kDefaultComments;
    }
    
    [self.mapViewDelegate mapView:self didSelectPhoto:image withComments:comments withAssetURL:assetURL];
}

@end
