//
//  OAuth2ViewController.h
//  OAuthLogin
//
//  Created by orBIDme on 7/4/14.


#import <UIKit/UIKit.h>
#import "AuthViewController.h"

typedef enum OAUTH2_SOCIALMEDIA: NSUInteger {
    OAUTH2_FACEBOOK,
    OAUTH2_LINKEDIN,
    OAUTH2_INSTAGRAM,
    OAUTH2_GOOGLEPLUS,
    OAUTH2_SOUNDCLOUD
} OAUTH2_SOCIALMEDIA;

@class OAuth2ViewController;
@protocol OAuth2ViewControllerDelegate <NSObject>
@optional
- (void) oauth2ViewController:(OAuth2ViewController *)oauthViewController token:(NSDictionary*) accessToken;
- (void) oauth2ViewController:(OAuth2ViewController *)oauthViewController failed:(NSError *)error;
@end

@interface OAuth2ViewController : AuthViewController
{
    OAUTH2_SOCIALMEDIA socialMedia;
    
    NSMutableData *receivedData;
    NSDictionary *tokenData;
    
    NSString *authorizeUrl;
    NSString *accessTokenUrl;
    
    NSString *clientKey;
    NSString *secretKey;
    NSString *callbackUrl;
    NSString *scope;
    NSString *state;
    
    id <OAuth2ViewControllerDelegate> delegate;
    
//    MBProgressHUD           *hud;
}

- (id)initWithMedia:(OAUTH2_SOCIALMEDIA) media
          ClientKey:(NSString *)clientKey
          SecretKey:(NSString *)secretKey
        CallbackUrl:(NSString *)callbackUrl
              Scope:(NSString *)scope
              State:(NSString *)state;

@property(nonatomic)BOOL ISYouTubeORGoogle;
@property (strong, nonatomic) NSDictionary *tokenData;
@property (strong, nonatomic) NSString *secretKey;
@property (strong, nonatomic) id <OAuth2ViewControllerDelegate> delegate;
@end
