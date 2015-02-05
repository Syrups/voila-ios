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

@implementation CaptureViewController {
    NSArray* pendingPropositions;
    NSArray* pendingAnswers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createMenu];
    
    PropositionManager* manager = [[PropositionManager alloc] init];
    
    [manager findPendingPropositionsAndAnswersWithSuccess:^(NSArray* propositions, NSArray* answers){
        NSLog(@"%@", propositions);
        if (propositions.count > 0 || answers.count > 0) {
            self.notificationsLed.hidden = NO;
        }
    } failure:^{
        
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
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect f = self.menu.view.frame;
        f.origin.x += 200;
        self.menu.view.frame = f;
    } completion:nil];
}

- (IBAction)closeMenu:(id)sender {
    if (self.menu.view.frame.origin.x == self.view.frame.size.width) {
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
    [menu didMoveToParentViewController:self];
    menu.view.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:menu.view];
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


@end
