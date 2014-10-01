//
//  imageDataSources.m
//  PhotoNotes
//
//  Created by Zeng Wang on 9/12/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import "imageDataSource.h"
#import "CLLocation+EXIFGPS.h"
#import "imageDataSource.h"
#import "AppSharedUserInfo.h"

@interface imageDataSource()

@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation imageDataSource

@synthesize currentLocation = _currentLocation;

- (id)init
{
    self = [super init];
    if (self)
    {
        _currentLocation = [[CLLocation alloc] init];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
    }
    return self;
}

// save photo to photo object
- (void)savePhoto:(ImagePickerController *)imagePickerController
   withImageInfo:(NSDictionary *)imageInfo
       withImage:(UIImage *)pickedImage
    withComments:(NSString *)comments
{
    __block NSString *photoAssetURL = nil;
    if (imagePickerController.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        photoAssetURL =  [NSString stringWithFormat:@"%@",[imageInfo objectForKey:UIImagePickerControllerReferenceURL]];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:comments, photoAssetURL, nil];
        [[AppSharedUserInfo sharedData] addPhoto:userInfo];
        [[AppSharedUserInfo sharedData] loadUserPhotos];
    }
    else
    {
        // get photo's photo assetURL
        ALAssetsLibraryWriteImageCompletionBlock completeBlock = ^(NSURL *assetURL, NSError *error)
        {
            if (!error)
            {
                #pragma mark get image url from camera capture.
                photoAssetURL = [NSString stringWithFormat:@"%@",assetURL];
                NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:comments, photoAssetURL, nil];
                [[AppSharedUserInfo sharedData] addPhoto:userInfo];
                [[AppSharedUserInfo sharedData] loadUserPhotos];
            }
            else
            {
                NSLog(@"%@", error);
            }
        };
        if (_currentLocation == nil)
        {
            ALAssetsLibrary *library = [[AppSharedUserInfo sharedData] assetsLibrary];
            [library writeImageToSavedPhotosAlbum:[pickedImage CGImage]
                                      orientation:(ALAssetOrientation)[pickedImage imageOrientation]
                                  completionBlock:completeBlock];
        }
        else
        {
            ALAssetsLibrary *library = [[AppSharedUserInfo sharedData] assetsLibrary];
            NSMutableDictionary *metaDic = [[NSMutableDictionary alloc] initWithDictionary:[imageInfo objectForKey:UIImagePickerControllerMediaMetadata]];
            NSDictionary *gpsDic = [_currentLocation EXIFMetadata];
            [metaDic setValue:gpsDic forKey:(NSString *)kCGImagePropertyGPSDictionary];
            [library writeImageToSavedPhotosAlbum:[pickedImage CGImage]
                                         metadata:metaDic
                                  completionBlock:completeBlock];
        }
    }
    _currentLocation = nil;
}

// location service is turned on and gets returned location information
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = [locations lastObject];
    [manager stopUpdatingLocation];
}

// location service is turned off or location info can't be retained
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _currentLocation = nil;
    [manager stopUpdatingLocation];
}

@end