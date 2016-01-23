//
//  AuthViewController.h
//  OAuthLogin
//
//  Created by orBIDme on 7/4/14.
//   
//

#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController
{
    IBOutlet UIWebView *webview;
    IBOutlet UILabel *lblTitle;
}

@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;


@property (strong, nonatomic) IBOutlet UIView *vwNavi;

- (IBAction)btnBack_Click:(id)sender;

@end
