//
//  WebViewController.h
//  Voila
//
//  Created by Leo on 25/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) IBOutlet UIWebView* webview;

@end
