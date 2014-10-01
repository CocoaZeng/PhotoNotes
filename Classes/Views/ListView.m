//
//  ListView.m
//  PhotoNotes
//
//  Created by Zeng Wang on 8/30/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import "ListView.h"
#import "constants.h"

@interface ListView()

@property (strong, nonatomic) NSDictionary *userAssetDict;

- (NSDictionary *)getAssetAndCommentFromIndex:(int)index;
- (NSString *)stringFormatedFromDate:(id)assertDate;

@end

@implementation ListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.userAssetDict = [[NSDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kAssetLoadedNotification object:nil];
    }
    return self;
}


- (NSDictionary *)getAssetAndCommentFromIndex:(int)index
{
    NSMutableArray *userAssets = [[AppSharedUserInfo sharedData] userAssets];
    NSDictionary *userAssetDict;
    int maxIndex = [userAssets count] - 1;
    int dictIndex = maxIndex - index;
    if (dictIndex <= maxIndex && dictIndex >= 0)
    {
        self.userAssetDict = [userAssets objectAtIndex:dictIndex];
        NSString *assetURL = [[self.userAssetDict allKeys] objectAtIndex:0];
        ALAsset *asset = [[self.userAssetDict objectForKey:assetURL] objectAtIndex:0];
        NSString *comments = [[self.userAssetDict objectForKey:assetURL] objectAtIndex:1];
        userAssetDict = [[NSDictionary alloc] initWithObjectsAndKeys:asset, kAssetKey, comments, kCommentsKey, assetURL, kAssetURLKey, nil];
    }
    return userAssetDict;
}

- (NSString *)stringFormatedFromDate:(id)assertDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [[NSDate alloc] init];
    date = (NSDate *)assertDate;
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:kTimeZone]];
    [formatter setDateFormat:kDateFormat];
    NSString *dateString = [[NSString alloc] initWithString:[formatter stringFromDate:date]];
    return dateString;
}


#pragma mark - Implement UITableViewSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppSharedUserInfo sharedData] userAssets] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int numberOfRow = [tableView numberOfRowsInSection:indexPath.section];
    static NSString *cellIdentifier = kListTableCellIdentifier;
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell)
    {
        [cell prepareForReuse];
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *userAssetDict = [self getAssetAndCommentFromIndex:indexPath.row];
    if (nil != userAssetDict) {
        ALAsset *asset = [userAssetDict objectForKey:kAssetKey];
        NSString *comments = [userAssetDict objectForKey:kCommentsKey];
        // add image to cell's imageView
        CGImageRef thumbnailImageRef = [asset thumbnail];
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        cell.imageView.image = thumbnail;
        
        // set cell's title
        id assertDate = [asset valueForProperty:ALAssetPropertyDate];
        if (assertDate)
        {
            cell.textLabel.text = [self stringFormatedFromDate:assertDate];
        }
        // set cell's subtitle
        cell.detailTextLabel.text = comments;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma mark - Implement UITableViewController methods
// select a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (nil == self.listViewDelegate)
    {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *userAssetDict = [self getAssetAndCommentFromIndex:indexPath.row];
    if (nil != userAssetDict)
    {
        ALAsset *asset = [userAssetDict objectForKey:kAssetKey];
        UIImage *image = [[UIImage alloc] initWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        NSString *assetURL = [userAssetDict objectForKey:kAssetURLKey];
        NSString *comments = [userAssetDict objectForKey:kCommentsKey];
        if ([comments isEqualToString:@""])
        {
            comments = kDefaultComments;
        }
        [self.listViewDelegate listView:self didSelectPhoto:image withComments:comments withAssetURL:(NSString *)assetURL withIndex:(NSIndexPath *)indexPath];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
