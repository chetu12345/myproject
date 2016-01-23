//
//  Globals.h
//  Meritok Moments
//
//  Created by Chetna Ranipa on 02/06/15.
//  Copyright (c) 2015 Chetna Ranipa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSInteger selectPhoto;
@interface Globals : NSObject
{
    NSMutableArray *_arrFeeds_TW_Fetching;
}
@property(nonatomic,retain)NSMutableArray *arrFeeds_TW_Fetching;

+(Globals *)sharedInstance;
-(UIColor*)colorWithHexString:(NSString*)hex;
-(NSMutableDictionary *)checkForNullinDic:(NSMutableDictionary *)dict;
-(NSString *)convertHTML:(NSString *)html;
- (BOOL) validateEmail:(NSString *) text;
-(BOOL) validatePassword:(NSString *)pwd ;
-(NSString *)checkNetworkConnectivity;

FOUNDATION_EXPORT NSString *const kNavigationBarColor;
FOUNDATION_EXPORT NSString *const kTabColor;

@end
