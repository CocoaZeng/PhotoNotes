//
//  imageDataSources.h
//  PhotoNotes
//
//  Created by Zeng Wang on 9/12/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "ImagePickerController.h"
#import "CLLocation+EXIFGPS.h"

@interface imageDataSource : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)savePhoto:(ImagePickerController *)imagePickerController withImageInfo:(NSDictionary *)imageInfo withImage:(UIImage *)pickedImage withComments:(NSString *)comments;

@end
