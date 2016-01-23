//
//  OAuth1ViewController.h
//  OAuthLogin
//
//  Created by orBIDme on7/4/14.


#import <UIKit/UIKit.h>
#import "AuthViewController.h"
#import "OAConsumer.h"
#import "OAToken.h"
#import "DejalActivityView.h"
#import "CommonUtility.h"
typedef enum OAUTH1_SOCIALMEDIA: NSUInteger {
    OAUTH1_TWITTER,
    OAUTH1_TUMBLR,
    OAUTH1_SOUNDCLOUD,
    OAUTH1_LINKEDIN,
} OAUTH1_SOCIALMEDIA;

@class OAuth1ViewController;
@protocol OAuth1ViewControllerDelegate <NSObject>
@optional
- (void) oauth1ViewController:(OAuth1ViewController *)oauthViewController token:(OAToken*) accessToken;
- (void) oauth1ViewController:(OAuth1ViewController *)oauthViewController failed:(NSError *)error;
@end


@interface OAuth1ViewController : AuthViewController
{
    OAUTH1_SOCIALMEDIA socialMedia;
    
    OAConsumer* consumer;
    OAToken* requestToken;
    OAToken* accessToken;
    
    NSString *requestTokenUrl;
    NSString *authorizeUrl;
    NSString *accessTokenUrl;
    
    NSString *clientKey;
    NSString *secretKey;
    NSString *callbackUrl;
    
    id <OAuth1ViewControllerDelegate> delegate;
    
}

- (id)initWithMedia:(OAUTH1_SOCIALMEDIA) media
          ClientKey:(NSString *)clientKey
          SecretKey:(NSString *)secretKey
        CallbackUrl:(NSString *)callbackUrl;

@property (nonatomic,strong) OAToken* accessToken;
@property (strong, nonatomic) id <OAuth1ViewControllerDelegate> delegate;

@end
