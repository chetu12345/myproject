//
//  Constants.h
//  GalGal
//
//  Created by Ajeet Singh on 8/23/12.
//
//


#define FONT_NEXA_BOLD @"Nexa Bold"
#define FONT_NEXA_LIGHT @"Nexa Light"
#define NC_TWILIO_ERROR @"NC_TWILIO_ERROR"

#define COLOR_GREEN_DRIVE360 [UIColor colorWithRed:138.0/255.0 green:200.0/255.0 blue:38.0/255.0 alpha:1.0]
#define COLOR_BLUE_DRIVE360 [UIColor colorWithRed:0.0/255.0 green:116.0/255.0 blue:191.0/255.0 alpha:1.0]

#define SCREEN_SIZE [UIScreen mainScreen].bounds



#define OFFSET_SLIDE 51.0f
//Use For Orientation
#define isPotrait [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown
//#define isPotrait [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown
#ifdef __OBJC__
//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#endif

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)


#define FONT_NEXA_BOLD @"Nexa Bold"
#define FONT_NEXA_LIGHT @"Nexa Light"
#define COLOR_BLUE_DRIVE360 [UIColor colorWithRed:0.0/255.0 green:116.0/255.0 blue:191.0/255.0 alpha:1.0]

//Alignment Left
#ifdef IS_OS_6_OR_LATER
# define ALIGN_LEFT NSTextAlignmentLeft
#else
# define ALIGN_LEFT UITextAlignmentLeft
#endif

//Alignment Center
#ifdef IS_OS_6_OR_LATER
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

//Alignment Right
#ifdef IS_OS_6_OR_LATER
# define ALIGN_RIGHT NSTextAlignmentRight
#else
# define ALIGN_RIGHT UITextAlignmentRight
#endif

#ifdef IS_OS_6_OR_LATER
# define LINE_BREAK NSLineBreakByWordWrapping
#else
# define LINE_BREAK UILineBreakModeWordWrap
#endif


#ifdef IS_OS_6_OR_LATER
# define WANTSFULLSCREENLAYOUT edgesForExtendedLayout
#else
# define WANTSFULLSCREENLAYOUT wantsFullScreenLayout
#endif


#ifdef IS_OS_6_OR_LATER
# define SEGMENTEDCONTROLSTYLE YES
#else
# define SEGMENTEDCONTROLSTYLE self.segmentedControlStyle == UISegmentedControlStyleBordered || self.segmentedControlStyle == UISegmentedControlStylePlain
#endif

//Number of recode Show in task and lead lasy loading
#define NumberPageRecode 50