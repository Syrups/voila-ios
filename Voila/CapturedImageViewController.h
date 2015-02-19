//
//  CapturedImageViewController.h
//  TenVeux2
//
//  Created by Leo on 29/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CapturedImageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) UIImage* image;

@end
