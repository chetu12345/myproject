//
//  Globals.m
//  Dick Tracy Communicator
//
//  Created by Chetna Ranipa on 02/06/15.
//  Copyright (c) 2015 Chetna Ranipa. All rights reserved.
//

#import "Globals.h"
#import "Reachability.h"

NSInteger selectPhoto;

@implementation Globals
@synthesize arrFeeds_TW_Fetching;

NSString *const kNavigationBarColor=@"F1C40F";
NSString *const kTabColor=@"2BB0E3";

+ (Globals *)sharedInstance {
    static dispatch_once_t onceToken;
    static Globals *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Globals alloc] init];
    });
    return instance;
}

-(id)init{
    self = [super init];
    if (self) {
        arrFeeds_TW_Fetching = [[NSMutableArray alloc] init];
    }
    return self;
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(NSMutableDictionary *)checkForNullinDic:(NSMutableDictionary *)dict
{
    NSMutableDictionary *temp=[[NSMutableDictionary alloc]initWithDictionary:dict];
    NSArray *keys=[temp allKeys];
    for (int i=0; i<[keys count]; i++) {
        if ([temp objectForKey:[keys objectAtIndex:i]] == [NSNull null]) {
            [temp setValue:@"" forKey:[keys objectAtIndex:i]];
        }
    }
    return temp;
}
-(NSString *)convertHTML:(NSString *)html
{
    //NSLog(@"%@",html);
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    while ([myScanner isAtEnd] == NO) {
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        [myScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    html  = [html stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
    html  = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
    html  = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
    html  = [html stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"o"];
    html  = [html stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    html  = [html stringByReplacingOccurrencesOfString:@"&#8230;" withString:@"..."];
    html  = [html stringByReplacingOccurrencesOfString:@"&#8594;" withString:@"->"];
    html  = [html stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    return html;
}


- (BOOL) validateEmail:(NSString *) text
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:text];
}
-(BOOL) validatePassword:(NSString *)pwd {
    
    //NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    
    //NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if ( [pwd length]<6 || [pwd length]>20 )
        return NO;  // too long or too short
    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
        return NO;  // no letter
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )
        return NO;  // no number;
    /*rang = [pwd rangeOfCharacterFromSet:upperCaseChars];
     if ( !rang.length )
     return NO;  // no uppercase letter;*/
    rang = [pwd rangeOfCharacterFromSet:lowerCaseChars];
    if ( !rang.length )
        return NO;  // no lowerCase Chars;
    return YES;
}

-(NSString *)checkNetworkConnectivity
{
    NSString *networkValue;
    Reachability *rc = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [rc currentReachabilityStatus];
    
    if(internetStatus==0)
    {
        networkValue = @"NoAccess";
    }
    else if(internetStatus==1)
    {
        networkValue = @"ReachableViaWiFi";
        
    } else if(internetStatus==2)
    {
        networkValue = @"ReachableViaWWAN";
    }
    else  if(internetStatus>2)
    {
        networkValue = @"Reachable";
    }
    return networkValue;
}
@end
