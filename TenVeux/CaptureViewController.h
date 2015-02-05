//
//  CaptureViewController.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptureViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UINavigationController* menu;
@property (strong, nonatomic) IBOutlet UIImageView* notificationsLed;

- (void)menuRequestFullSize;
- (IBAction)closeMenu:(id)sender;

@end
