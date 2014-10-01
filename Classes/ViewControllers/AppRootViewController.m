//
//  CameraController.m
//  PhotoNotes
//
//  Created by Zeng Wang on 8/27/13.
//  Copyright (c) 2013 Zeng Wang. All rights reserved.
//

#import "AppRootViewController.h"
#import "CLLocation+EXIFGPS.h"
#import "constants.h"

@interface AppRootViewController ()
@property (strong, nonatomic) UISegmentedControl* segmentedControl; // switch from MapView or ListView of photos
@property (strong, nonatomic) MapView* mapView;
@property (strong, nonatomic) ListView* listView;
@property (strong, nonatomic) ImagePickerController *imagePickerController;
@property (strong, nonatomic) NSDictionary *imageInfo;
@property (strong, nonatomic) imageDataSource *pickedPhotoToSave;
@property (strong, nonatomic) CommentsViewController *imageCommentsViewController;


- (void)reloadUserPhotos;
- (void)switchView;
- (void)addNewPhoto;
- (void)cancelAddPhoto;
- (void)presentImageDetails:(UIImage *)image withComments:(NSString *)comments withURL:assetURL withIndex:indexPath;

@end

@implementation AppRootViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserPhotos) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    CGRect navFrame = self.navigationController.navigationBar.frame;
    CGRect toolBarFrame = self.navigationController.toolbar.frame;
    CGRect frame = self.view.frame;
    frame.origin.y = navFrame.origin.y + navFrame.size.height;
    frame.size.height = self.view.frame.size.height - frame.origin.y - toolBarFrame.size.height;
    [self.mapView setFrame:frame];
    [self.listView setFrame:frame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // initilize properties
    // create frame with the nav bar and toolbar in mind.
    self.mapView = [[MapView alloc] init];
    self.mapView.mapViewDelegate = self;
    self.listView = [[ListView alloc] init];
    self.listView.listViewDelegate = self;
    
    self.imagePickerController = [[ImagePickerController alloc] init];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:kSegmentControlMap, kSegmentControlList, nil]];
    
    self.imageInfo = [[NSDictionary alloc] init];
    
    self.pickedPhotoToSave = [[imageDataSource alloc] init];
    self.segmentedControl.frame = CGRectMake(0, 0, 120, 30);
    [self.segmentedControl  setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self.segmentedControl setTintColor:[self.navigationController.navigationBar tintColor]];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl addTarget:self action:@selector(switchView) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.listView];
    [self switchView];
}

- (void)reloadUserPhotos
{
    [[AppSharedUserInfo sharedData] loadUserPhotos];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // enable toolbar and add segement control to it
    if (nil == self.toolbarItems || [self.toolbarItems count] == 0)
    {
        self.navigationController.toolbarHidden = NO;
        UIBarButtonItem* flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                target:nil
                                action:nil];
        UIBarButtonItem* segmentedControlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];
        [self setToolbarItems:[NSArray arrayWithObjects:flexItem, segmentedControlBarButtonItem, flexItem, nil]];
    }
    if (self.navigationController.toolbarHidden == YES)
    {
        self.navigationController.toolbarHidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// switch to main view (photo notes)
- (void)switchView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kAddButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(addNewPhoto)];
    self.navigationItem.title = kPhotoNavigationTitle;
    
    // if user selected mapview(index 0), show mapview
    if ([self.segmentedControl selectedSegmentIndex] == 0)
    {
        self.mapView.hidden = NO;
        self.listView.hidden = YES;
        [self.mapView setBackgroundColor:[UIColor whiteColor]];
    }
    
    // if user selected listview(index 1), show listview
    else
    {
        self.mapView.hidden = YES;
        self.listView.hidden = NO;
        [self.listView setBackgroundColor:[UIColor whiteColor]];
    }
    
    // show tool bar
    if (self.navigationController.toolbarHidden == YES)
    {
        self.navigationController.toolbarHidden = NO;
    }
    
    self.navigationItem.leftBarButtonItem = nil;
}

// add new photo
- (void)addNewPhoto
{
    self.imagePickerController.delegate = self;
    
    // if device has camera, use camara to take new photo
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    // if device doesn't have camera, let user to choose from photo library
    else
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

// cancel saving photo
- (void)cancelAddPhoto
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.imageCommentsViewController = nil;
    [self switchView];
}

//save photo
- (void)savePhoto
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.pickedPhotoToSave savePhoto:self.imagePickerController
                        withImageInfo:self.imageInfo
                            withImage:self.imageCommentsViewController.image
                         withComments:self.imageCommentsViewController.textView.text];
    [self switchView];
    self.navigationItem.leftBarButtonItem = nil;
    self.imageCommentsViewController = nil;
}

// cancel picking picture(camera roll)
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

// Use picked picture
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // selected image
    self.imageInfo = info;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerMediaType];
    }
    else
    {
        [self.pickedPhotoToSave.locationManager startUpdatingLocation];
        [self.pickedPhotoToSave.locationManager startUpdatingHeading];
    }
    
    self.imageCommentsViewController = [[CommentsViewController alloc] initWithStyle:UITableViewStylePlain];
    self.imageCommentsViewController.image = image;
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UINavigationController *commentNavigation = [[UINavigationController alloc] initWithRootViewController:self.imageCommentsViewController];
    self.imageCommentsViewController.navigationItem.title = kCommentNavigationTitle;
    self.imageCommentsViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kCancalButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddPhoto)];
    self.imageCommentsViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kSaveButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(savePhoto)];
    [self.navigationController presentViewController:commentNavigation animated:NO completion:nil];
}

#pragma mark - MapView and Listview delegate
// implement ListViewDelegate method. It brings up view to show image's details
- (void)listView:(ListView *)listView didSelectPhoto:(UIImage *)image withComments:(NSString *)comments withAssetURL:(NSString *)assetURL withIndex:(NSIndexPath *)indexPath
{
    [self presentImageDetails:image withComments:comments withURL:assetURL withIndex:indexPath];
}

// implement MapViewDelegate method. It brings up view to show image's details
- (void)mapView:(MapView *)mapView didSelectPhoto:(UIImage *)image withComments:(NSString *)comments withAssetURL:(NSString *)assetURL
{
    [self presentImageDetails:image withComments:comments withURL:assetURL withIndex:nil];
}

// Bring up view to show image's details
- (void)presentImageDetails:(UIImage *)image withComments:(NSString *)comments withURL:assetURL withIndex:indexPath
{
    CommentsViewController *commentViewController = [[CommentsViewController alloc] initWithStyle:UITableViewStylePlain];
    commentViewController.image = image;
    commentViewController.comments = comments;
    if (nil != indexPath) {
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:indexPath, kKeyforIndexPath, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCommentsNotification object:nil userInfo:userInfo];
    }
    [self.navigationController  pushViewController:commentViewController animated:YES];
    self.navigationController.toolbarHidden = YES;
}

//- (void)saveComments
//{
//    
//}
//- (void)dismissKeyboard
@end