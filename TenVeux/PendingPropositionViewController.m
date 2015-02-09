//
//  PendingPropositionViewController.m
//  TenVeux2
//
//  Created by Leo on 29/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "PendingPropositionViewController.h"
#import "NotificationStackViewController.h"
#import "FriendPickerViewController.h"
#import "Configuration.h"
#import "ChoiceSlider.h"
#import "UIImageView+WebCache.h"

@implementation PendingPropositionViewController

- (void)viewDidLoad {
    [self.image sd_setImageWithURL:[NSURL URLWithString:[kMediaUrl stringByAppendingString:self.proposition.image]]];
    self.senderNameLabel.text = self.proposition.sender.username;
    self.okButton.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated {
    NotificationStackViewController* parent = (NotificationStackViewController*)self.parentViewController;
    [parent showTopControls];
}

- (void)didAnswerYesToCurrentProposition {

}

- (void)didAnswerNoToCurrentProposition {
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(requestNext:) userInfo:nil repeats:NO];
}

- (IBAction)presentFriendPicker:(id)sender {
    FriendPickerViewController* picker = (FriendPickerViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FriendPicker"];
    [self addChildViewController:picker];
    [self.view addSubview:picker.view];
    [picker didMoveToParentViewController:self];
    
    NotificationStackViewController* parent = (NotificationStackViewController*)self.parentViewController;
    [parent hideTopControls];
    
    picker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    picker.image = self.image.image;
    picker.isOriginal = NO;
    picker.originalProposition = self.proposition;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        picker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

- (IBAction)requestNext:(id)sender {
    NotificationStackViewController* parent = (NotificationStackViewController*)self.parentViewController;

    [parent requestNextInStack:sender];
}


@end
