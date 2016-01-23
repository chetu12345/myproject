//
//  OAuth1ViewController.m
//  OAuthLogin
//
// Created by orBIDme on 7/4/14.


#import "OAuth1ViewController.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
@interface OAuth1ViewController ()

@end

@implementation OAuth1ViewController

@synthesize accessToken;
@synthesize delegate;

- (id)initWithMedia:(OAUTH1_SOCIALMEDIA)_media
          ClientKey:(NSString *)_clientKey
          SecretKey:(NSString *)_secretKey
        CallbackUrl:(NSString *)_callbackUrl
{
    self = [super initWithNibName:@"AuthViewController" bundle:nil];
    if (self) {
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        clientKey = _clientKey;
        secretKey = _secretKey;
        callbackUrl = _callbackUrl;
        socialMedia = _media;
        
        switch (socialMedia) {
            case OAUTH1_TWITTER:
                [self.lblTitle setText:@"Twitter"];
                requestTokenUrl = @"https://api.twitter.com/oauth/request_token";
                authorizeUrl = @"https://api.twitter.com/oauth/authorize";
                accessTokenUrl = @"https://api.twitter.com/oauth/access_token";
                break;
            case OAUTH1_TUMBLR:
                [self.lblTitle setText:@"Tumblr"];
                requestTokenUrl = @"https://www.tumblr.com/oauth/request_token";
                authorizeUrl = @"https://www.tumblr.com/oauth/authorize";
                accessTokenUrl = @"https://www.tumblr.com/oauth/access_token";
                break;
            case OAUTH1_SOUNDCLOUD:
                [self.lblTitle setText:@"SoundCloud"];
                requestTokenUrl = @"http://api.soundcloud.com/oauth/request_token";
                authorizeUrl = @"http://api.soundcloud.com/oauth/authorize";
                accessTokenUrl = @"http://api.soundcloud.com/oauth/access_token";
                break;
                
            case OAUTH1_LINKEDIN:
                [self.lblTitle setText:@"LinkedIn"];
                requestTokenUrl = @"http://api.linkedin.com/oauth/request_token";
                authorizeUrl = @"http://api.linkedin.com/oauth/authorize";
                accessTokenUrl = @"http://api.linkedin.com/oauth/access_token";
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    switch (socialMedia) {
        case OAUTH1_TWITTER:
            [super.lblTitle setText:@"Twitter"];
            break;
        case OAUTH1_TUMBLR:
            [super.lblTitle setText:@"Tumblr"];
            break;
        case OAUTH1_SOUNDCLOUD:
            [super.lblTitle setText:@"SoundCloud"];
            break;
        case OAUTH1_LINKEDIN:
            [super.lblTitle setText:@"LinkedIn"];
            break;
        default:
            break;
    }
    consumer = [[OAConsumer alloc] initWithKey:clientKey secret:secretKey];
    OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestTokenUrl]
                                                                                consumer:consumer
                                                                                   token:nil
                                                                                   realm:nil
                                                                       signatureProvider:nil];
    OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:callbackUrl];
    [requestTokenRequest setHTTPMethod:@"POST"];
    [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
    [dataFetcher fetchDataWithRequest:requestTokenRequest
                             delegate:self
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
                      didFailSelector:@selector(didFailOAuth:error:)];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Authorizing"];
    
}

- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data
{
    /*NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];

    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authorizeUrl]
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    [webview loadRequest:authorizeRequest];*/
    
    
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authorizeUrl]
                                                                             consumer:nil
                                                                                token:nil
                                                                                realm:nil
                                                                    signatureProvider:nil];
    NSString* oauthToken = requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    webview.delegate = self;
    [webview loadRequest:authorizeRequest];

} 

- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data
{
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];

    // SUCCEDED!
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Succeded"];
    [DejalBezelActivityView removeViewAnimated:YES];
    
    if (delegate && [delegate respondsToSelector:@selector(oauth1ViewController:token:)]) {
        [delegate oauth1ViewController:self token:accessToken];
    }
}

- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
    // ERROR!
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Failed"];

    [DejalBezelActivityView removeViewAnimated:YES];
    if (delegate && [delegate respondsToSelector:@selector(oauth1ViewController:failed:)]) {
        [delegate oauth1ViewController:self failed:nil];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

    [DejalBezelActivityView removeViewAnimated:YES];
    
    NSString *URLString = [request.URL absoluteString];
    
    if([URLString hasPrefix:callbackUrl]){
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"oauth_verifier"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        if (verifier) {
            OAMutableURLRequest* accessTokenRequest = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:accessTokenUrl]
                                                                                       consumer:consumer
                                                                                          token:requestToken
                                                                                          realm:nil
                                                                              signatureProvider:nil] autorelease];
            OARequestParameter* verifierParam = [[[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier] autorelease];
            [accessTokenRequest setHTTPMethod:@"POST"];
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            OADataFetcher* dataFetcher = [[[OADataFetcher alloc] init] autorelease];
            [dataFetcher fetchDataWithRequest:accessTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
        } else {
            // ERROR!
            [DejalBezelActivityView removeViewAnimated:YES];
            if (delegate && [delegate respondsToSelector:@selector(oauth1ViewController:failed:)]) {
                [delegate oauth1ViewController:self failed:nil];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    // ERROR!
    //hud.labelText = @"Failed!";
    [DejalBezelActivityView removeViewAnimated:YES];
    
    if (delegate && [delegate respondsToSelector:@selector(oauth1ViewController:failed:)]) {
        [delegate oauth1ViewController:self failed:nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//        
//        [webview setFrame:CGRectMake(0, 64, 320, 504)];
//        
//    }
//    else
//    {
//        [webview setFrame:CGRectMake(0, 64, 320, 416)];
//        
//    }

    [DejalBezelActivityView removeViewAnimated:YES];
}

@end
