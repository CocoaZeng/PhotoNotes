//
//  AppSharedUserInfo.h
//  PhotoNotes
//
//  Created by Zeng Wang on 9/15/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "imageDataSource.h"

@interface AppSharedUserInfo : NSObject
@property (strong, nonatomic) NSMutableArray *userDefaults; // Array of dictionary. Each dictionary has assetURl as key and comments as value
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *userAssets; // Array of dictionary. Each dictionary has assetURL as key. Array of asset

+(id)sharedData;
- (void)loadUserPhotos;
- (void)addPhoto:(NSDictionary *)userinfo;
- (void)addAsset:(ALAsset *)asset withAssetURL:(NSString *)assetURL withComments:(NSString *)comments;
@end
