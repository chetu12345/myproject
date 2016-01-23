//
//  ViewController.m
//  TwitterFeed
//
//  Created by Ratnakala Software on 17/12/15.
//  Copyright (c) 2015 Chetna Ranipa. All rights reserved.
//

#import "ViewController.h"
#import "OAuth1ViewController.h"
#import "Constant.h"
#import "FeedViewController.h"
#import "STTwitterAPI.h"

@interface ViewController ()<OAuth1ViewControllerDelegate,UIActionSheetDelegate>
{
    UIActionSheet *twitterSheet;
}
@property (nonatomic, retain) NSArray *twitterAccounts;
- (IBAction)btnSignUpWithTwitterClick:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnSignUpWithTwitterClick:(id)sender {
    [self twitter];
//    FeedViewController *feedView = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedViewController"];
//    feedView.strLogin = @"3223177442";
//    feedView.strSecret = @"MT6QW4GbWKyOYNHxmtSm5Eu9MRXMDAapCKFHH8z4gLKra";
//    feedView.strToken = @"3223177442-DaSOKtnQeyWXH7wmhzVY1YLfSBSR1D3NBmUWJnh";
//    [self.navigationController pushViewController:feedView animated:YES];

}

- (void)twitter {
    OAuth1ViewController * auth = [[OAuth1ViewController alloc] initWithMedia:OAUTH1_TWITTER ClientKey:CLIENTKEY_TWITTER SecretKey:SECRETKEY_TWITTER CallbackUrl:CallbackUrl_TWITTER];
    auth.delegate = self;
    auth.navigationItem.title = @"Twitter Auth";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:auth];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark OAuth1 OAuth2 Delegate

- (void)oauth1ViewController:(OAuth1ViewController *)oauthViewController token:(OAToken *)accessToken {
   
    FeedViewController *feedView = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedViewController"];
    feedView.strLogin = accessToken.userid;
    feedView.strSecret = accessToken.secret;
    feedView.strToken = accessToken.key;
    
        STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerName:@"SoBuz" consumerKey:CLIENTKEY_TWITTER consumerSecret:SECRETKEY_TWITTER];
    
        [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
            
            NSLog(@"bearerToken %@",bearerToken);
            
            [twitter getUsersShowForUserID:accessToken.userid orScreenName:nil includeEntities:nil successBlock:^(NSDictionary *user) {
                
            NSLog(@"user is %@",user);
                
//               NSString *email = user[@"screen_name"];
//               NSString *fname= user[@"name"];
               NSString * id1 = [@"" stringByAppendingFormat:@"%@",[user objectForKey:@"id"]];
                if (id1.length >0) {
                    [oauthViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController pushViewController:feedView animated:YES];
                }
            } errorBlock:^(NSError *error) {
                //
                NSLog(@"Error %@",error.description);
            }];
            
        } errorBlock:^(NSError *error) {
            //
            NSLog(@"Error %@",error.description);
        }];


}
- (void) oauth1ViewController:(OAuth1ViewController *)oauthViewController failed:(NSError *)error
{
    
}
@end
