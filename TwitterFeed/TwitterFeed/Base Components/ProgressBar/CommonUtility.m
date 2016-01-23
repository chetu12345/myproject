//
//  CommonUtility.m
//  BrentBrown
//
//  Created by Siddharth on 27/10/14.
//  Copyright (c) 2014 Ajeet Singh. All rights reserved.
//

#import "CommonUtility.h"

@implementation CommonUtility

static CommonUtility* _sharedSingleton = nil;

+(CommonUtility*)sharedSingleton
{
    @synchronized([CommonUtility class])
    {
        if (!_sharedSingleton)
            _sharedSingleton = [[self alloc] init];
        
        return _sharedSingleton;
    }	
    
    return nil;
}

+ (void)showMessage:(NSString*)message
          withTitle:(NSString*)title {
 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}
@end
