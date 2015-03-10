//
//  PlaygroundViewController.m
//  Voila
//
//  Created by Leo on 20/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "PlaygroundViewController.h"
#import "PKAIDecoder.h"

@interface PlaygroundViewController ()

@end

@implementation PlaygroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [PKAIDecoder builAnimatedImageIn:self.image fromFile:@"loader"];
}


@end
