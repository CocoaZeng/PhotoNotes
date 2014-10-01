//
//  CommentsViewController.m
//  PhotoNotes
//
//  Created by Zeng Wang on 9/22/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import "CommentsViewController.h"
#import "AppSharedUserInfo.h"
#import "constants.h"

@interface CommentsViewController ()

- (void)updatePhotoComments;

@end

@implementation CommentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *ImageCellIdentifier = kImageCellIdentifier;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellIdentifier];
        if (cell)
        {
            [cell prepareForReuse];
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageCellIdentifier];
            float imageViewWidth = self.view.frame.size.width;
            float imageViewHeight = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y)*0.75;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = self.image;
            [cell.contentView addSubview:imageView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        static NSString *CommentCellIdentifier = kCommentCellIdentifier;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
        if (cell)
        {
            [cell prepareForReuse];
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentCellIdentifier];
            float commentViewWidth = self.view.frame.size.width;
            float commentViewHeight = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y)*0.15;
            self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, commentViewWidth, commentViewHeight)];
            self.textView.font = [UIFont systemFontOfSize:18];
            self.textView.text = self.comments;
            [cell.contentView addSubview:self.textView];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float viewHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y;
    if (indexPath.row == 0)
    {
        return viewHeight * 0.8;
    }
    else
    {
        return viewHeight * 0.2;
    }
}

- (void)updatePhotoComments
{
    self.comments = self.textView.text;
    if ((nil != self.comments) && (nil != self.assetURL)) {
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:self.comments, self.assetURL, nil];
        [[AppSharedUserInfo sharedData] addPhoto:userInfo];
        [[AppSharedUserInfo sharedData] loadUserPhotos];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
