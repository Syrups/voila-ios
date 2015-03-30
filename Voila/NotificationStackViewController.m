//
//  NotificationStackViewController.m
//  TenVeux2
//
//  Created by Leo on 29/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NotificationStackViewController.h"
#import "PendingPropositionViewController.h"
#import "AnswerViewController.h"

@implementation NotificationStackViewController {
    NSUInteger currentIndex;
}

- (void)viewDidLoad {

    self.notifCountLabel.text = [NSString stringWithFormat:@"%lu", self.propositionStack.count + self.answersStack.count];
    currentIndex = 0;
    
    [self next];
}

- (void)next {
    
    // NSLog(@"Next");
    
    self.notifCountLabel.text = [NSString stringWithFormat:@"%lu", self.propositionStack.count + self.answersStack.count - currentIndex];
    
    // If there's no more notifications to show, go back
    if (currentIndex == self.propositionStack.count + self.answersStack.count) {
        self.mainViewController.notificationsLed.hidden = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    if (self.childViewController != nil) {
        self.mainViewController.notificationsLed.hidden = YES;
//        self.mainViewController.notificationsButton.enabled = NO;
        [self.childViewController.view removeFromSuperview];
        [self.childViewController removeFromParentViewController];
    }
    
    if (currentIndex < self.propositionStack.count && [self.propositionStack objectAtIndex:currentIndex] != nil) { // proposition
        PendingPropositionViewController* child = (PendingPropositionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PendingProposition"];
        child.proposition = [self.propositionStack objectAtIndex:currentIndex];
        [self addChildViewController:child];
        [self.view addSubview:child.view];
        [self.view sendSubviewToBack:child.view];
        
        self.childViewController = child;
    } else { // answer
        AnswerViewController* child = (AnswerViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Answer"];
        child.answer = [self.answersStack objectAtIndex:labs(self.propositionStack.count-currentIndex)];
        [self addChildViewController:child];
        [self.view addSubview:child.view];
        [self.view sendSubviewToBack:child.view];
        
        self.childViewController = child;
    }
}

- (IBAction)requestNextInStack:(id)sender {
    currentIndex++;
    [self next];
}

- (IBAction)dismiss {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)hideTopControls {
    self.notifCountLabel.hidden = YES;
    self.backButton.hidden = YES;
}

- (void)showTopControls {
//    self.notifCountLabel.hidden = NO;
    self.backButton.hidden = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
