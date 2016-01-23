//
//  AuthViewController.m
//  OAuthLogin
//
//  Created by orBIDme on 7/4/14.
//
//

#import "AuthViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

@synthesize webview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
//    [self.lblTitle setText:self.navigationController.navigationItem.title.]
}

- (void)viewWillAppear:(BOOL)animated
{
   
    
    self.vwNavi.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
}


- (void)didReceiveMemoryWarningfe
{ 
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBack_Click:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}
@end
