//
//  AvatarViewController.m
//  Voila
//
//  Created by Leo on 20/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AvatarViewController.h"
#import "UserManager.h"
#import "UserSession.h"

@implementation AvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    [self setup];
}

- (IBAction)back:(id)sender {
    
    [self.captureSession stopRunning];
    [self.captureVideoPreviewLayer removeFromSuperlayer];
    
    if (self.isRegistration) {
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture"];
        [self.navigationController setViewControllers:@[vc] animated:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setup {
    
    AVCaptureDevice *inputDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
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
    self.captureVideoPreviewLayer.frame = self.previewView.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.previewView.layer addSublayer:self.captureVideoPreviewLayer];
    [self.captureSession startRunning];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.captureSession addOutput:self.stillImageOutput];
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
        
//        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], self.previewView.frame);
//        self.avatar = [UIImage imageWithCGImage:imageRef];
//        CGImageRelease(imageRef);
        self.avatar = [self scaleImage:image toSize:self.previewView.frame.size];
        
        UIImageView* avatarPreview = [[UIImageView alloc] initWithImage:self.avatar];
        avatarPreview.contentMode = UIViewContentModeScaleAspectFill;
        avatarPreview.frame = CGRectMake(0, 0, self.previewView.frame.size.width, self.previewView.frame.size.height);
        [self.previewView addSubview:avatarPreview];
        
        self.previewView.layer.borderWidth = 1.0f;
        self.previewView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        self.captureButton.hidden = YES;
        self.validateButton.hidden = NO;
    }];
}

- (IBAction)confirmUpload:(id)sender {
    UserManager* manager = [[UserManager alloc] init];
    
    [manager updateAvaterOfUser:[[UserSession sharedSession] user] withImage:self.avatar success:^(NSURL * avatarUrl) {
        [[UserSession sharedSession] setAvatarUrl:avatarUrl];
        [[UserSession sharedSession] store];
        [self back:sender];
    } failure:^{
        // ERROR
    }];
}

#pragma mark - Camera image compression

- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:scaledImage.CGImage
                               scale:scaledImage.scale
                         orientation:UIImageOrientationUpMirrored];
}

@end
