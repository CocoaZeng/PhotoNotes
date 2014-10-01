//
//  AppSharedUserInfo.m
//  PhotoNotes
//
//  Created by Zeng Wang on 9/15/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import "AppSharedUserInfo.h"
#import "constants.h"

@interface AppSharedUserInfo()

- (void)addPhoto:(NSDictionary *)userinfo;
- (void)addAsset:(ALAsset *)asset withAssetURL:(NSString *)assetURL withComments:(NSString *)comments;
- (void)removePhoto:(NSDictionary *)deletedPhoto;
- (void)loadUserPhotos;

@end

@implementation AppSharedUserInfo

+(id)sharedData
{
    static dispatch_once_t once;
    static id sharedData;
    dispatch_once(&once, ^{sharedData = [[self alloc] init];});
    return sharedData;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // notification of a new photo is added
        self.userDefaults = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPhoto:) name:kPhotoAddedNotification object:nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.userDefaults = [userDefaults objectForKey:kPhotoListKey];
        if (nil == self.userDefaults)
        {
            self.userDefaults = [[NSMutableArray alloc] init];
        }
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.userAssets = [[NSMutableArray alloc] init];
    }
    return self;
}

// save new added photo into standardUserDefaults
// information of photos are saved in a dictionary for key 'kPhotoListKey'
- (void)addPhoto:(NSDictionary *)userinfo
{
    if (nil != userinfo) {
        [self.userDefaults addObject:userinfo];
        [[NSUserDefaults standardUserDefaults] setObject:self.userDefaults forKey:kPhotoListKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSLog(@"userInfo is nil.");
    }
}

// save exiting asset into userAsset
- (void)addAsset:(ALAsset *)asset withAssetURL:(NSString *)assetURL withComments:(NSString *)comments
{
    if ((nil != asset) && (nil != assetURL) && (nil != comments))
    {
        NSArray *array = [[NSArray alloc] initWithObjects:asset,comments, nil];
        NSDictionary *assetDict = [[NSDictionary alloc] initWithObjectsAndKeys:array, assetURL, nil];
        [self.userAssets addObject:assetDict];
    }
}

// remove deleted photo from userDefault
- (void)removePhoto:(NSDictionary *)deletedPhoto
{
    if (nil != deletedPhoto)
    {
        [self.userDefaults removeObject:deletedPhoto];
        [[NSUserDefaults standardUserDefaults] setObject:self.userDefaults forKey:kPhotoListKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// validate userDefaults and create userAssets
- (void)loadUserPhotos
{
    if (self.userDefaults)
    {
        [self.userAssets removeAllObjects];
        int totalNumofAssetURL = [self.userDefaults count];
        __block int count = 0;
        for (NSDictionary *dic in self.userDefaults)
        {
            NSString *assetURL = [[dic allKeys] objectAtIndex:0];
            NSString *comments = [dic objectForKey:assetURL];
            ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset)
            {
                count++;
                // if asset exits
                if (asset)
                {
                    [self addAsset:asset withAssetURL:assetURL withComments:comments];
                }
                
                // if asset doesn't exit
                else
                {
                    NSDictionary *deletedPhoto = [[NSDictionary alloc] initWithObjectsAndKeys:comments, assetURL, nil];
                    // notify CameraUserPhoto to remove deleted photo from userDefaults
                    [self removePhoto:deletedPhoto];
                }
                
                if (count == totalNumofAssetURL)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAssetLoadedNotification object:nil userInfo:nil];
                }
            };
            
            ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
            {
                NSLog(@"%@", error);
            };
            ALAssetsLibrary *library = [[AppSharedUserInfo sharedData] assetsLibrary];
            [library assetForURL:[NSURL URLWithString:assetURL] resultBlock:resultsBlock failureBlock:failureBlock];
        }
    }
}

@end
