//
//  CameraController.h
//  PhotoNotes
//
//  Created by Zeng Wang on 8/27/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "ListView.h"
#import "ImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>
#import "imageDataSource.h"
#import "CommentsViewController.h"

@interface AppRootViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, ListViewDelegate, mapViewDelegate>

@end
