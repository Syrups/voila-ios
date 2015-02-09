//
//  Configuration.h
//  TenVeux2
//
//  Created by Leo on 27/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#ifndef TenVeux2_Configuration_h
#define TenVeux2_Configuration_h

//#define kApiRootUrl     @"http://tenveux.herokuapp.com/api"
//#define kMediaUploadUrl @"http://tenveux.herokuapp.com/images"
//#define kMediaUrl       @"http://tenveux.herokuapp.com/media/"
#define kApiRootUrl     @"http://localhost:5000/api"
#define kMediaUploadUrl @"http://localhost:5000/images"
#define kMediaUrl       @"http://localhost:5000/media/"

#define kSessionStoreId @"user.id"
#define kSessionStoreToken @"user.token"

#define kImageUploadHttpParameterName @"photo"
#define kImageUploadHttpFileName    @"photo.jpg"

#define kDebug YES


// Macros

#define RgbColorAlpha(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define ErrorAlert(msg) UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]; \
[alert show];

#endif
