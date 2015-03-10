//
//  AvatarViewController.h
//  Voila
//
//  Created by Leo on 20/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AvatarViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(strong, nonatomic) AVCaptureSession *captureSession;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(strong, nonatomic) AVCaptureDevice *backCamera;
@property(strong, nonatomic) AVCaptureDevice *frontCamera;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property BOOL isRegistration;
@property (strong, nonatomic) UIImage* avatar;
@property (strong, nonatomic) IBOutlet UIView* previewView;
@property (strong, nonatomic) IBOutlet UIButton* captureButton;
@property (strong, nonatomic) IBOutlet UIButton* validateButton;

@end
