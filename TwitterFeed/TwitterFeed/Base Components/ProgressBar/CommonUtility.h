//
//  CommonUtility.h
//  BrentBrown
//
//  Created by Siddharth on 27/10/14.
//  Copyright (c) 2014 Ajeet Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtility : NSObject

+(CommonUtility*)sharedSingleton;
+ (void)showMessage:(NSString*)message
          withTitle:(NSString*)title;

@end
