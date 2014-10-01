//
//  MapAnnotation.m
//  PhotoNotes
//
//  Created by Zeng Wang on 9/17/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import "MapAnnotation.h"
#import "constants.h"

@implementation MapAnnotation
- (id)initWithAsset:(ALAsset *)asset withComments:(NSString *)comments withAssetURL:(NSString *)assetURL
{
    self = [super init];
    if (self)
    {
        self.comments = [[NSString alloc] initWithString:comments];
        self.asset = asset;
        //self.coordinate = nil;
        id assetLocation = [asset valueForProperty:ALAssetPropertyLocation];
        if (assetLocation)
        {
            CLLocation *location = (CLLocation *) assetLocation;
            self.coordinate = [location coordinate];
        }
        id assertdate = [asset valueForProperty:ALAssetPropertyDate];
        if (assertdate)
        {
            NSDate *date = [[NSDate alloc] init];
            date = (NSDate *)assertdate;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:kTimeZone]];
            [formatter setDateFormat:kDateFormat];
            self.title = [[NSString alloc] initWithString:[formatter stringFromDate:date]];
            self.subtitle = [[NSString alloc] initWithString:comments];
        }
    }
    return self;
}

@end
