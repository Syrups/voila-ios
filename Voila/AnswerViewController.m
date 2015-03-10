//
//  AnswerViewController.m
//  TenVeux
//
//  Created by Leo on 12/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AnswerViewController.h"
#import "NotificationStackViewController.h"
#import "AnswerManager.h"
#import "UIImageView+WebCache.h"
#import "Configuration.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:MediaUrl(self.answer.proposition.image)]];
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    self.okButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (self.answer.from.avatar != nil) {
        [self.fromProfileImage sd_setImageWithURL:[NSURL URLWithString:MediaUrl(self.answer.from.avatar)]];
    }
    
    if (self.answer.to.avatar != nil) {
        [self.toProfileImage sd_setImageWithURL:[NSURL URLWithString:MediaUrl(self.answer.to.avatar)]];
    }
    
    self.fromUsername.text = self.answer.from.username;
    self.toUsername.text = self.answer.to.username;
    
    AnswerManager* manager = [[AnswerManager alloc] init];
    [manager acknowledgeAnswer:self.answer withSuccess:^{
        
    } failure:^{
        
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(reveal) userInfo:nil repeats:NO];
}

- (void)reveal {
    [UIView animateWithDuration:0.5f animations:^{
        self.overlay.alpha = 0.7f;
//        self.topView.alpha = 0;
        self.okButton.alpha = 1;
        
        if ([self.answer.answer isEqualToString:@"yes"]) {
            self.positive.alpha = 1;
        } else {
            self.negative.alpha = 1;
        }
    }];
}

- (IBAction)requestNext:(id)sender {
    NotificationStackViewController* parent = (NotificationStackViewController*)self.parentViewController;
    
    [parent requestNextInStack:sender];
}


@end
