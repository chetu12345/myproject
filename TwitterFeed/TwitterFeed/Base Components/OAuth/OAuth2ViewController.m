//
//  OAuth2ViewController.m
//  OAuthLogin
//
// Created by orBIDme on 7/4/14.


#import "OAuth2ViewController.h"
#import "CommonUtility.h"
#import "DejalActivityView.h"
#import "SBJsonParser.h"
@interface OAuth2ViewController ()

@end

@implementation OAuth2ViewController

@synthesize tokenData,secretKey;
@synthesize delegate;
@synthesize ISYouTubeORGoogle;

- (id)initWithMedia:(OAUTH2_SOCIALMEDIA)_media
          ClientKey:(NSString *)_clientKey
          SecretKey:(NSString *)_secretKey
        CallbackUrl:(NSString *)_callbackUrl
              Scope:(NSString *)_scope
              State:(NSString *)_state
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
        scope = _scope;
        state = _state;
        
        socialMedia = _media;
        
        switch (socialMedia) {
            case OAUTH2_FACEBOOK:
                authorizeUrl = @"https://www.facebook.com/dialog/oauth";
                accessTokenUrl = @"https://graph.facebook.com/oauth/access_token";
                break;
            case OAUTH2_GOOGLEPLUS:
            {
                authorizeUrl = @"https://accounts.google.com/o/oauth2/auth";
                accessTokenUrl = @"https://accounts.google.com/o/oauth2/token";
                ISYouTubeORGoogle = true;
            }
                break;
            case OAUTH2_INSTAGRAM:
                authorizeUrl = @"https://api.instagram.com/oauth/authorize";
                accessTokenUrl = @"https://api.instagram.com/oauth/access_token";
                break;
            case OAUTH2_LINKEDIN:
                authorizeUrl = @"https://www.linkedin.com/uas/oauth2/authorization";
                accessTokenUrl = @"https://www.linkedin.com/uas/oauth2/accessToken";
                break;
            case OAUTH2_SOUNDCLOUD:
                authorizeUrl = @"https://soundcloud.com/connect";
                accessTokenUrl = @"https://api.soundcloud.com/oauth2/token";
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
    NSString *url=@"";
    
    switch (socialMedia) {
        case OAUTH2_FACEBOOK:
        {
            [super.lblTitle setText:@"Facebook"];
            
            url = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&state=%@", authorizeUrl, clientKey, callbackUrl, scope,state];
            
        }
    
            break;
        case OAUTH2_GOOGLEPLUS:
        {
            [super.lblTitle setText:@"Google"];
            if(ISYouTubeORGoogle)
            {
                url = [NSString stringWithFormat:@"%@?redirect_uri=%@&response_type=code&client_id=%@&scope=%@&access_type=offline",authorizeUrl,callbackUrl, clientKey, scope];
                ISYouTubeORGoogle = false;
            }
          
        
        }
            
         
            break;
        case OAUTH2_INSTAGRAM:
        {
            [super.lblTitle setText:@"Instagram"];
               url = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&state=%@", authorizeUrl, clientKey, callbackUrl, scope,state];
        }
         
            break;
        case OAUTH2_LINKEDIN:
        {
            [super.lblTitle setText:@"Linkedin"];
            url = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&state=%@", authorizeUrl, clientKey, callbackUrl, scope,state];
        }
            break;
        case OAUTH2_SOUNDCLOUD:
        {
             [super.lblTitle setText:@"SoundCloud"];
            
//                 https://soundcloud.com/connect?scope=non-expiring&response_type=code&display=popup&client_id=YOUR_CLIENT_ID&redirect_uri=http%3A%2F%2Fexample.com%2Fsoundcloud-callback.html
            url = [NSString stringWithFormat:@"%@?scope=%@&response_type=code&client_id=%@&redirect_uri=%@",authorizeUrl,scope,clientKey,callbackUrl];
         }
            break;
            
            
        default:
            break;
    }
    
    
//    if(ISYouTubeORGoogle)
//    {
//        url = [NSString stringWithFormat:@"%@?redirect_uri=%@&response_type=code&client_id=%@&scope=%@&access_type=offline",authorizeUrl,callbackUrl, clientKey, scope];
//        ISYouTubeORGoogle = false;
//    }
//    else
//    {
//         url = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&state=%@", authorizeUrl, clientKey, callbackUrl, scope,state];
//     
//    }
////

    url=[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url=[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSLog(@"url is %@",url);
    
  
    NSURL *urlSt=[[NSURL alloc]initWithString:url ];
    
    NSURLRequest *req=[NSURLRequest requestWithURL:urlSt];
    
    [webview setDelegate:self];
    [webview loadRequest:req];
    
    [CommonUtility showMessage:@"Authorizing" withTitle:@""];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Authorizing"];
    
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

    [DejalBezelActivityView removeViewAnimated:YES];
    NSString *URLString = [request.URL absoluteString];
    
    if ([URLString hasPrefix:callbackUrl]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                verifier = [keyValue objectAtIndex:1];
                NSLog(@"verifier %@",verifier);
                break;             }
        }
        
        if (verifier) {
            
           
            NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", verifier, clientKey, secretKey, callbackUrl];
            
            NSLog(@"data %@",data);
            
            NSLog(@"accessToken URl %@?%@",accessTokenUrl,data);
      
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:accessTokenUrl]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
        
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];

            NSLog(@"req is %@",request);
            
        }
        else
        {
            // ERROR!
           // hud.labelText = @"Failed!";
          [DejalBezelActivityView removeViewAnimated:YES];
            if (delegate && [delegate respondsToSelector:@selector(oauth2ViewController:failed:)]) {
                [delegate oauth2ViewController:self failed:nil];
            }
        }

        return NO;
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
    NSLog(@"verifier %@",receivedData);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    // ERROR!
    [CommonUtility showMessage:@"Failed" withTitle:@""];

    if (delegate && [delegate respondsToSelector:@selector(oauth2ViewController:failed:)]) {
        [delegate oauth2ViewController:self failed:nil];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    tokenData = [[NSMutableDictionary alloc] init];
    switch (socialMedia) {
        case OAUTH2_FACEBOOK:
        {
            NSArray* urlParams = [response componentsSeparatedByString:@"&"];
            for (NSString* param in urlParams) {
                NSArray* keyValue = [param componentsSeparatedByString:@"="];
                [tokenData setValue:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
            }
        }
            break;
        default:
        {
            SBJsonParser *jResponse = [[SBJsonParser alloc]init];
            tokenData = [jResponse objectWithString:response];
        }
            break;
    }
    
    // SUCCEDED!
//    hud.labelText = @"Succeded!";
    [DejalBezelActivityView removeViewAnimated:YES];
 
    if (delegate && [delegate respondsToSelector:@selector(oauth2ViewController:token:)]) {
        [delegate oauth2ViewController:self token:tokenData];
    }
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    // ERROR!
   // hud.labelText = @"Failed!";
    [DejalBezelActivityView removeViewAnimated:YES];
    
    if (delegate && [delegate respondsToSelector:@selector(oauth2ViewController:failed:)]) {
        [delegate oauth2ViewController:self failed:error];
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
