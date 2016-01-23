//
//  PostViewController.m
//
//
//  Created by Ratnakala Software on 18/12/15.
//
//

#import "PostViewController.h"
#import "CommonUtility.h"
#import "Constant.h"
#import "STTwitterAPI.h"
#import "clsFeed.h"
#import "Globals.h"
@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtPost;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnTweetClick:(id)sender;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.txtPost.layer setCornerRadius:5.0];
    [self.txtPost.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.txtPost.layer setBorderWidth:1.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)PostTweet
{
    [self.view endEditing:YES];
    NSString *strConsumerkey = CLIENTKEY_TWITTER;
    NSString *strConsumerSecret = SECRETKEY_TWITTER;
    STTwitterAPI *twitter1 = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strConsumerkey consumerSecret:strConsumerSecret oauthToken:self.strToken oauthTokenSecret:self.strSecret];
    [twitter1 verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        [twitter1 postStatusUpdate:self.txtPost.text
                 inReplyToStatusID:nil
                          latitude:nil
                         longitude:nil
                           placeID:nil
                displayCoordinates:nil
                          trimUser:nil
                      successBlock:^(NSDictionary *json)
         {
             NSString *strLoginId = self.strLogin;
             clsFeed *objfeed=[[clsFeed alloc]init];
             [objfeed setFeed_id:[json objectForKey:@"id_str"]];
             [objfeed setFeed_UserPicImageURL:[[json  objectForKey:@"user"] objectForKey:@"profile_image_url"]];
             [objfeed setFeed_ImageURL:[[json  objectForKey:@"user"] objectForKey:@"profile_image_url"]];
             [objfeed setFeed_Title:[[json  objectForKey:@"user"] objectForKey:@"name"]];
             [objfeed setFeed_Title_attr:[[json  objectForKey:@"user"] objectForKey:@"name"]];
             [objfeed setFeed_Description_attr:[json  objectForKey:@"text"]];
             [objfeed setFeed_Description:[json  objectForKey:@"text"]];
             [objfeed setFeed_LikeCount:[[json  objectForKey:@"favorite_count"] integerValue]];
             [objfeed setFeed_ScreenName:[[json  objectForKey:@"user"] objectForKey:@"screen_name"] ];
             [objfeed setFeed_isLike:[[json  objectForKey:@"favorited"] boolValue]];
             NSString *dateString = [json objectForKey:@"created_at"];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             NSDate *dateFromString = [[NSDate alloc] init];
             [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
             dateFromString = [dateFormatter dateFromString:dateString];
             [dateFormatter setDateFormat:@"eee MMM dd, yyyy hh:mm a"];
             NSString *strDate=[dateFormatter stringFromDate:dateFromString];
             [objfeed setFeed_Date:strDate];
             [objfeed setFeed_Type:@"Tw"];
             [objfeed setFeed_UserID:strLoginId];
             [objfeed setFeed_AccessToken:self.strToken];
             //                      [objfeed setFeed_UserID:obj.socialaccount_DisplayName];
             NSMutableArray *arrTweet = [[NSMutableArray alloc] init];
             arrTweet = [[Globals sharedInstance].arrFeeds_TW_Fetching mutableCopy];
             [[Globals sharedInstance].arrFeeds_TW_Fetching removeAllObjects];
             [[Globals sharedInstance].arrFeeds_TW_Fetching addObject:objfeed];
             for (int i =0; i<[arrTweet count]; i++) {
                 [[Globals sharedInstance].arrFeeds_TW_Fetching addObject:[arrTweet objectAtIndex:i]];
             }
             [CommonUtility showMessage:@"Tweet Successfully Post" withTitle:@""];
             self.txtPost.text = @"";
             
         } errorBlock:^(NSError *error) {
             
         }];
    }errorBlock:^(NSError *error) {
        
    }];
    
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTweetClick:(id)sender {
    [self PostTweet];
}
@end
