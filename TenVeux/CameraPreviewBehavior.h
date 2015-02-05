//
//  CameraPreviewBehavior.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SRBehavior.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraPreviewBehavior : SRBehavior <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) IBOutlet UIView* view;
@property (strong, nonatomic) IBOutlet UIButton* captureButton;
@property (strong, nonatomic) IBOutlet UIButton* switchCameraButton;

@property(strong, nonatomic) AVCaptureSession *captureSession;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(strong, nonatomic) AVCaptureDevice *backCamera;
@property(strong, nonatomic) AVCaptureDevice *frontCamera;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@end
