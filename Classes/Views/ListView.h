//
//  ListView.h
//  PhotoNotes
//
//  Created by Zeng Wang on 8/30/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppSharedUserInfo.h"
@class ListView;

@protocol ListViewDelegate <NSObject>
- (void)listView:(ListView *)listView didSelectPhoto:(UIImage *)image withComments:(NSString *)comments withAssetURL:(NSString *)assetURL withIndex:(NSIndexPath *)indexPath;

@end

@interface ListView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic)id<ListViewDelegate> listViewDelegate;
@end