//
//  CaptureViewController.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CaptureViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) UINavigationController* menu;
@property (strong, nonatomic) IBOutlet UIImageView* notificationsLed;
@property (strong, nonatomic) IBOutlet UIImageView* outboxLed;
@property (strong, nonatomic) IBOutlet UIImageView* friendRequestsLed;
@property(strong, nonatomic) AVCaptureSession *captureSession;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(strong, nonatomic) AVCaptureDevice *backCamera;
@property(strong, nonatomic) AVCaptureDevice *frontCamera;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (strong, nonatomic) IBOutlet UIButton* notificationsButton;
@property (strong, nonatomic) IBOutlet UIButton* captureButton;
@property (strong, nonatomic) IBOutlet UIButton* switchCameraButton;

- (void)menuRequestFullSize;
- (IBAction)closeMenu:(id)sender;

@end
