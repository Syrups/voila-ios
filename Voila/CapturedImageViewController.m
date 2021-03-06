//
//  CapturedImageViewController.m
//  TenVeux2
//
//  Created by Leo on 29/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CapturedImageViewController.h"
#import "FriendPickerViewController.h"

@implementation CapturedImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.image;
    
    // NSLog(@"%@", self.image);
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentFriendPicker:)];
    
    [self.imageView addGestureRecognizer:tap];
    self.imageView.userInteractionEnabled = YES;
    
    [self.view setNeedsDisplay];
}

- (IBAction)presentFriendPicker:(id)sender {
    FriendPickerViewController* picker = (FriendPickerViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FriendPicker"];
    picker.isOriginal = YES;
    picker.originalProposition = nil;
    [self addChildViewController:picker];
    [self.view addSubview:picker.view];
    [picker didMoveToParentViewController:self];
    
    picker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    picker.image = self.image;
    picker.isOriginal = YES;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        picker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
