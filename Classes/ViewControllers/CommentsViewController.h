//
//  CommentsViewController.h
//  PhotoNotes
//
//  Created by Zeng Wang on 9/22/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UITableViewController
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) NSString *assetURL;

@end