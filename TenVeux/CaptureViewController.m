//
//  CaptureViewController.m
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CaptureViewController.h"
#import "PropositionManager.h"
#import "NotificationStackViewController.h"
#import "MenuViewController.h"
#import "CapturedImageViewController.h"
#import "Proposition.h"
#import "SDWebImagePrefetcher.h"
#import "Configuration.h"
#import "UserSession.h"
#import "UserManager.h"

@implementation CaptureViewController {
    NSArray* pendingPropositions;
    NSArray* pendingAnswers;
    BOOL isFrontCamera;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.backCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
    self.frontCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
    
    [self createMenu];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PropositionManager* manager = [[PropositionManager alloc] init];
    
    [manager findPendingPropositionsAndAnswersWithSuccess:^(NSArray* propositions, NSArray* answers){
        
        NSMutableArray* urls = [NSMutableArray array];
        
        for (Proposition* p in propositions) {
            [urls addObject:[NSURL URLWithString:[kMediaUrl stringByAppendingString:p.image]]];
        }
        
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls progress:nil completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
            if (propositions.count > 0 || answers.count > 0) {
                self.notificationsLed.hidden = NO;
            } else {
                self.notificationsButton.enabled = NO;
            }
        }];
        
        pendingAnswers = answers;
        pendingPropositions = propositions;
    } failure:^{
        
    }];
    
    UserManager* userManager = [[UserManager alloc] init];
    
    [userManager getFriendRequestsForUser:[[UserSession sharedSession] user] withSuccess:^(NSArray *requests) {
        if (requests.count > 0) {
            self.friendRequestsLed.hidden = NO;
            [[UserSession sharedSession] setHasPendingFriendRequests:YES];
        }
    } failure:^{
        // error
    }];
    
}

- (void) presentCapturedImage:(UIImage*)image {
    CapturedImageViewController* vc = (CapturedImageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CapturedImage"];
    vc.image = [self scaleImage:image toSize:CGSizeMake(image.size.width/2, image.size.height/2)];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Image picking

- (IBAction)requestImagePicker:(id)sender {
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self presentCapturedImage:image];
}

#pragma mark - Main menu

- (IBAction)displayMenu:(id)sender {
    if (self.menu.view.frame.origin.x != -self.view.frame.size.width) return;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect f = self.menu.view.frame;
        f.origin.x += 200;
        self.menu.view.frame = f;
    } completion:nil];
}

- (IBAction)closeMenu:(id)sender {
    if (self.menu.view.frame.origin.x == -self.view.frame.size.width) {
        [self performSegueWithIdentifier:@"ToNotificationsSegue" sender:sender];
    } else {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect f = self.menu.view.frame;
            f.origin.x = -self.view.frame.size.width;
            self.menu.view.frame = f;
        } completion:^(BOOL finished) {
            UIViewController* menuEntry = [self.menu.viewControllers objectAtIndex:0];
            [self.menu setViewControllers:@[menuEntry]];
        }];
    }
}

- (void)createMenu {
    UINavigationController* menu = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    [self addChildViewController:menu];
    menu.view.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:menu.view];
    [menu didMoveToParentViewController:self];
    self.menu = menu;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(menu.view.frame.size.width-1, 0, 1, menu.view.frame.size.height);
    border.backgroundColor = [UIColor grayColor].CGColor;
    [menu.view.layer addSublayer:border];
    
    MenuViewController* menuVc = (MenuViewController*) menu.viewControllers[0];
    menuVc.masterViewController = self;
}

- (void)menuRequestFullSize {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect f = self.menu.view.frame;
        f.origin.x = 0;
        self.menu.view.frame = f;
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToNotificationsSegue"]) {
        NotificationStackViewController* vc = (NotificationStackViewController*)[segue destinationViewController];
        vc.propositionStack = pendingPropositions;
        vc.answersStack = pendingAnswers;
    }
}

#pragma mark - Camera image compression

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)setup {
    isFrontCamera = NO;
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if (!captureInput) {
        NSLog(@"No capture input available.");
        
        return;
    }
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    /* captureOutput:didOutputSampleBuffer:fromConnection delegate method !*/
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    self.captureSession = [[AVCaptureSession alloc] init];
    NSString* preset = 0;
    if (!preset) {
        preset = AVCaptureSessionPresetHigh;
    }
    self.captureSession.sessionPreset = preset;
    if ([self.captureSession canAddInput:captureInput]) {
        [self.captureSession addInput:captureInput];
    }
    if ([self.captureSession canAddOutput:captureOutput]) {
        [self.captureSession addOutput:captureOutput];
    }
    
    //handle prevLayer
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    
    //if you want to adjust the previewlayer frame, here!
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    UIView* capturePreviewView = [[UIView alloc] initWithFrame:self.view.frame];
    [capturePreviewView.layer addSublayer: self.captureVideoPreviewLayer];
    [self.captureSession startRunning];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.captureSession addOutput:self.stillImageOutput];
    
    [self.view addSubview:capturePreviewView];
    [self.view sendSubviewToBack:capturePreviewView];
    
    [self.captureButton addTarget:self action:@selector(captureNow) forControlEvents:UIControlEventTouchUpInside];
    [self.switchCameraButton addTarget:self action:@selector(switchCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction) captureNow
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections){
        for (AVCaptureInputPort *port in [connection inputPorts]){
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error){
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        [self presentCapturedImage:image];
    }];
}

- (IBAction)switchCameraDevice:(id)sender {
    AVCaptureDevice *device;
    device = isFrontCamera ? self.backCamera : self.frontCamera;
    NSLog(@"Switching camera.");
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    
    [self.captureSession removeInput:self.captureSession.inputs.firstObject];
    [self.captureSession addInput:input];
    
    isFrontCamera = !isFrontCamera;
    
    [self.captureSession commitConfiguration];
}

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
