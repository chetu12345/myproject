
//
//  FeedViewController.m
//  orBIDme
//
//  Created by orBIDme ons 6/4/14.

//@property(nonatomic,retain)NSString *feed_reblogKey;

#import "FeedViewController.h"
#import "FeedCell.h"
#import "STTwitterAPI.h"
#import "Constant.h"
#import "clsFeed.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "DejalActivityView.h"
#import "CommonUtility.h"
#import "Globals.h"
#import "PostViewController.h"
#import "Globals.h"
#define TOTAL_DATA_LOAD_COUNT 20

@interface FeedViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    NSInteger commentIndex;
    NSInteger intTotalDataToLoad;
}
- (IBAction)btnPostClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblFeed;
@end

@implementation FeedViewController

#pragma mark - Reload Initialize Methods


-(void)initializeAll_Variables
{
    
    [Globals sharedInstance].arrFeeds_TW_Fetching=[[NSMutableArray alloc]init];
    intTotalDataToLoad=TOTAL_DATA_LOAD_COUNT;
}

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeAll_Variables];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Fetching Twitter Feeds"];
    [self FetchTwitterData];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tblFeed reloadData];
}
#pragma mark -
#pragma mark TableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [Globals sharedInstance].arrFeeds_TW_Fetching.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    clsFeed *objFeed;
    objFeed=(clsFeed *)[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:indexPath.section];
    CGFloat rowHeight=0;
    if([objFeed.feed_PicImageURL isEqualToString:@""])
    {
        rowHeight= 306;
    }
    else
    {
        rowHeight= 306+225;
    }
    NSString *strType=objFeed.feed_Type;
    if ([strType isEqualToString:@"Tw"]) {
        
        if([objFeed.feed_PicImageURL isEqualToString:@""] || objFeed.feed_PicImageURL== nil)
        {
            rowHeight= 285;
        }
        else
        {
            rowHeight= 306+150;
        }
        rowHeight=rowHeight;
        
        if(objFeed.feed_dataComments.count > 0)
        {
            
            NSInteger totalRow;
            
            totalRow=MIN(objFeed.feed_dataComments.count,objFeed.feed_commentsToDisplay);
            
            int lastCommentHeight=0;
             NSMutableArray *dataComments=objFeed.feed_dataComments;
            
            for (int i=0;i<totalRow;i++)
            {
                NSString *strmessage=[[dataComments objectAtIndex:i]objectForKey:@"text"];
                NSString *strName =[[[dataComments objectAtIndex:i]  objectForKey:@"user"] objectForKey:@"name"];
                NSString *strPicURL =[[[dataComments objectAtIndex:i]  objectForKey:@"user"] objectForKey:@"profile_image_url"];
                NSString *strDate=[[dataComments objectAtIndex:i ] objectForKey:@"created_at"];
                UIView *view=[self createCommentView:indexPath.section lastCommentHeight:lastCommentHeight strImageURL:strPicURL strUserName:strName strComment:strmessage strDate:strDate strFeedType:objFeed.feed_Type];
                view.autoresizingMask =UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
                lastCommentHeight+=view.frame.size.height;
            }
            if (dataComments.count > 3) {
                rowHeight= rowHeight+20;
            }
            rowHeight=rowHeight+lastCommentHeight;
        }
    }
        return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *cell = (FeedCell *)[tableView  dequeueReusableCellWithIdentifier:@"FeedCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    CALayer* layer = cell.layer;
    [layer setCornerRadius:4.0f];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.imgFeedPic setImage:nil];
    [cell setTag:(1000000+indexPath.section)];
    [cell.btnLike setTag:indexPath.section];
    [cell.btnLike addTarget:self action:@selector(btnLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLoadMoreComment setTag:indexPath.section];
    [cell.btnLoadMoreComment addTarget:self action:@selector(btnLoadMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPost setTag:indexPath.section];
    [cell.btnPost addTarget:self action:@selector(btnPostCommentClick:) forControlEvents:UIControlEventTouchUpInside];

    UIToolbar* myTextToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 56)];
    myTextToolbar.barStyle = UIBarStyleBlackTranslucent;
    [myTextToolbar sizeToFit];
    NSMutableArray *textBarItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil ];
    UIBarButtonItem *textDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:cell.txtEmoji action:@selector(resignFirstResponder)];
    [textBarItems addObject:space];
    [textBarItems addObject:textDoneBtn];
    [cell.txtComment setText:@""];
    [cell.txtComment setTag:indexPath.section];
    [cell.txtComment setDelegate:self];
    [cell.btnLike setHidden:NO];
    [cell.btnLike_icon setHidden:NO];
    [cell.btnComment setHidden:YES];
    [cell.btnComment_icon setHidden:YES];
    [cell.btnShare setHidden:NO];
    [cell.btnSave_icon setHidden:NO];
    [cell.btnSave setHidden:NO];
    [cell.btnSave_icon setHidden:NO];
    [cell.lblLikeCount setHidden:NO];
    [cell.imgCountSeperatorLine setHidden:NO];
    
    cell.lblLikeCount.text=[@"" stringByAppendingFormat:@"0"];
    cell.lblCommentsCount.text=[@"" stringByAppendingFormat:@"0"];
    [cell.btnComment setTitle:@"      Comment" forState:UIControlStateNormal];
    [cell.btnComment setHidden:NO];
    [cell.btnComment_icon setHidden:NO];
    [cell.btnComment_icon setBackgroundImage:[UIImage imageNamed:@"icon_comment.png"] forState:UIControlStateNormal];
    [cell.btnLoadMoreComment setTitle:@"View more comments" forState:UIControlStateNormal];
    cell.imgThumbnail.image = [UIImage imageNamed:@"profile_pic"];
    cell.imgComment.image =[UIImage imageNamed:@"profile_pic"];
    [cell.imgFeedPic setHidden:YES];
    [cell.webviewImage setHidden:YES];
    [cell.webviewImage setBackgroundColor:[UIColor clearColor]];
    
    [cell.webviewImage.scrollView setScrollEnabled:NO];

    [cell.viewComments setFrame:CGRectMake(0, 204, [UIScreen mainScreen].bounds.size.width-12, 0)];
    [[cell.viewComments subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    clsFeed *objFeed;
    objFeed=(clsFeed *)[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:indexPath.section];
    NSString *strType=objFeed.feed_Type;
    NSString *typeIcon;
    if ([strType isEqualToString:@"Tw"]) {
        typeIcon = @"icon_t_1";
    }
    [cell.imgType setImage:[UIImage imageNamed:typeIcon]];
    
    [cell.btnFeedSelection setHidden:NO];
    [cell.btnLoadMoreComment setHidden:YES];
    cell.viewInnerCmtView.frame=CGRectMake(cell.viewInnerCmtView.frame.origin.x,2, cell.viewInnerCmtView.frame.size.width, cell.viewInnerCmtView.frame.size.height );
    
    cell.lblCommentsCount.adjustsFontSizeToFitWidth = YES;
    cell.lblLikeCount.adjustsFontSizeToFitWidth = YES;
    [cell.viewWriteComment setHidden:NO];
    [cell.viewInnerCmtView setHidden:NO];
    if ([strType isEqualToString:@"Tw"])
    {
        cell.lblTitle.text  = objFeed.feed_Title;
        cell.lblDate.text = objFeed.feed_Date;
        if (objFeed.feed_IsDeletable)
        {
            [cell.btnDeleteFeed setHidden:NO];
        }
        else
        {
            [cell.btnHideFeed setHidden:NO];
        }
        [cell.btnComment setHidden:YES];
        [cell.btnComment_icon setHidden:YES];
        
        NSString *str=@"";
        if (objFeed.feed_Title_attr !=nil) {
            str =[str stringByAppendingString:objFeed.feed_Title_attr];
            str=[str stringByAppendingString:@" "];
        }
        if (objFeed.feed_Description !=nil) {
            str =[@"" stringByAppendingString:objFeed.feed_Description];
        }
        else
        {
            str =[str stringByAppendingString:objFeed.feed_Description_attr];
        }
        cell.lblDescription.text=str;
        if (objFeed.feed_LikeCount > 1) {
            cell.lblLikeCount.text=[@"" stringByAppendingFormat:@"%ld",objFeed.feed_LikeCount];
        }
        else
        {
            cell.lblLikeCount.text=[@"" stringByAppendingFormat:@"%ld",objFeed.feed_LikeCount];
        }
        if (objFeed.feed_CommentCount > 1) {
            cell.lblCommentsCount.text=[@"" stringByAppendingFormat:@"%ld",objFeed.feed_CommentCount];
        }
        else
        {
            cell.lblCommentsCount.text=[@"" stringByAppendingFormat:@"%ld",objFeed.feed_CommentCount];
        }
        
        CGRect frame=cell.viewComments.frame;
        
        if(objFeed.feed_dataComments.count > 0)
        {
            if(objFeed.feed_commentsToDisplay < objFeed.feed_dataComments.count)
            {
                [cell.btnLoadMoreComment setHidden:NO];
                cell.viewInnerCmtView.frame=CGRectMake(cell.viewInnerCmtView.frame.origin.x, 22, cell.viewInnerCmtView.frame.size.width, cell.viewInnerCmtView.frame.size.height);
            }
            else
            {
                cell.viewInnerCmtView.frame=CGRectMake(cell.viewInnerCmtView.frame.origin.x, 2, cell.viewInnerCmtView.frame.size.width, cell.viewInnerCmtView.frame.size.height);
            }
            
            NSInteger totalRow=MIN(objFeed.feed_dataComments.count,objFeed.feed_commentsToDisplay);
            NSInteger startIndex=objFeed.feed_dataComments.count-totalRow;
            int lastCommentHeight=0;
            NSMutableArray *dataComments=objFeed.feed_dataComments;
            [[cell.viewComments subviews]
             makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (NSInteger i=startIndex;i<dataComments.count;i++)
            {
                
                NSString *strmessage=[[dataComments objectAtIndex:i]objectForKey:@"text"];
                NSString *strName =[[[dataComments objectAtIndex:i]  objectForKey:@"user"] objectForKey:@"name"];
                NSString *strPicURL =[[[dataComments objectAtIndex:i]  objectForKey:@"user"] objectForKey:@"profile_image_url"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSDate *dateFromString = [[NSDate alloc] init];
                NSString *strDate=[[dataComments objectAtIndex:i ] objectForKey:@"created_at"];
                [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
                dateFromString = [dateFormatter dateFromString:strDate];
                [dateFormatter setDateFormat:@"eee MMM dd, yyyy hh:mm a"];
                strDate=[dateFormatter stringFromDate:dateFromString];
                UIView *view=[self createCommentView:indexPath.section lastCommentHeight:lastCommentHeight strImageURL:strPicURL strUserName:strName strComment:strmessage strDate:strDate strFeedType:objFeed.feed_Type];
                
                [view setFrame:CGRectMake(0, lastCommentHeight, [UIScreen mainScreen].bounds.size.width-15, view.frame.size.height)];
                view.autoresizingMask =UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
                lastCommentHeight=lastCommentHeight+ view.frame.size.height ;
                [view setTag:i];
                [cell.viewComments addSubview:view];
            }
            frame.size.height=lastCommentHeight;
        }
        else
        {
            frame.size.height=0;
        }
        int heightFeedImage=0;
        
        if([objFeed.feed_PicImageURL isEqualToString:@""] || objFeed.feed_PicImageURL ==nil)
        {
            heightFeedImage=138;
        }
        else
        {
            heightFeedImage=cell.imgFeedPic.frame.origin.y +cell.imgFeedPic.frame.size.height;
        }
        
        //            hide write comment section
        [cell.viewBottom setFrame:CGRectMake(cell.viewBottom.frame.origin.x
                                             , heightFeedImage,
                                             cell.viewBottom.frame.size.width,
                                             cell.viewBottom.frame.size.height)];
        
        frame.origin.y=cell.viewBottom.frame.size.height +cell.viewBottom.frame.origin.y;
        
        [cell.viewComments setFrame:frame];
        
        [cell.viewWriteComment setFrame:CGRectMake(cell.viewWriteComment.frame.origin.x
                                                   ,cell.viewComments.frame
                                                   .origin.y +cell.viewComments.frame.size.height,
                                                   cell.viewWriteComment.frame.size.width,
                                                   cell.viewWriteComment.frame.size.height)];
    }
    [cell.btnLike setSelected:objFeed.feed_isLike];
    
    if ([objFeed.feed_ImageURL isEqualToString:@""]) {
        cell.imgThumbnail.image = [UIImage imageNamed:@"profile_pic"];
    }
    else
    {
        [cell.cellIndicator setTintColor:[UIColor blackColor]];
        [cell.imgThumbnail sd_setImageWithURL:[NSURL URLWithString:objFeed.feed_ImageURL] placeholderImage:[UIImage imageNamed:@"profile_pic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    
    if ([objFeed.feed_UserPicImageURL isEqualToString:@""] || objFeed.feed_UserPicImageURL == nil || objFeed.feed_UserPicImageURL == NULL )
    {
        cell.imgComment.image =[UIImage imageNamed:@"profile_pic"];
    }
    else
    {
        [cell.cellIndicator setTintColor:[UIColor blackColor]];
        [cell.imgComment sd_setImageWithURL:[NSURL URLWithString:objFeed.feed_UserPicImageURL] placeholderImage:[UIImage imageNamed:@"profile_pic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    // For PIc
    int heightFeedImage=0;
    if([objFeed.feed_PicImageURL isEqualToString:@""])
    {
        heightFeedImage=138;
    }
    else
    {
        heightFeedImage=cell.imgFeedPic.frame.origin.y +cell.imgFeedPic.frame.size.height;
    }
    if ([objFeed.feed_GIFImage isEqualToString:@""] || objFeed.feed_GIFImage== nil) {
        
        [cell.webviewImage setHidden:YES];
    }
    else
    {
        [cell.imgFeedPic setHidden:YES];
        [cell.webviewImage setHidden:NO];
        NSURLRequest *req =[NSURLRequest requestWithURL:[NSURL URLWithString:objFeed.feed_GIFImage]];
        [cell.webviewImage setDelegate:self];
        [cell.webviewImage loadRequest:req];
    }
    if (cell.webviewImage.hidden) {
        if([objFeed.feed_PicImageURL isEqualToString:@""]|| objFeed.feed_PicImageURL== nil )
        {
            [cell.imgprogress setHidden:YES];
            [cell.imgFeedPic setHidden:YES];
        }
        else
        {
            [cell.imgFeedPic setHidden:NO];
            [cell.imgFeedPic sd_setImageWithURL:[NSURL URLWithString:objFeed.feed_PicImageURL]];
        }
    }
    NSString *strDesc = cell.lblDescription.text;
    strDesc = [strDesc stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];//27-Nov
    cell.lblDescription.text = strDesc;
    
    if ([cell.lblDescription.text isEqualToString:@""]) {
        cell.lblDescription.text=objFeed.feed_Title;
    }
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:cell.lblDescription.text];
    
    NSRange range=[cell.lblDescription.text rangeOfString:cell.lblDescription.text];
    //            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0 green:87/255.0 blue:187.0/255.0 alpha:1.0f] range:range];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    [cell.lblDescription setAttributedText:string];
    
    NSArray *words=[cell.lblDescription.text componentsSeparatedByString:@" "];
    
    for (NSString *word in words) {
        if ([word hasPrefix:@"@"] || [word hasPrefix:@"#"]) {
            NSRange range=[cell.lblDescription.text rangeOfString:word];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:46/255.0 blue:0/255.0 alpha:1.0] range:range];
            [cell.lblDescription setAttributedText:string];
        }
    }
    
    [cell.btnFeedSelection setFrame:CGRectMake(cell.btnFeedSelection.frame.origin.x,
                                               cell.btnFeedSelection.frame.origin.y,
                                               cell.btnFeedSelection.frame.size.width, cell.viewBottom.frame.origin.y-64)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark - createCommentView


-(UIView *)createCommentView:(NSInteger)index
           lastCommentHeight:(CGFloat)lastCommentHeight
                 strImageURL:(NSString *) strImageURL
                 strUserName:(NSString *)strUserName
                  strComment:(NSString *)strComment
                     strDate:(NSString *)strDate
                 strFeedType:(NSString *)strFeedType
{
    
    UIFont * customFont = [UIFont systemFontOfSize:12]; //custom font
    UIView *view=[[UIView alloc]init];
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(5,5 , 30, 30)];
    
    if (strImageURL==(id)[NSNull null] || [strImageURL isEqualToString:@"<null>"] || [strImageURL isEqual:@""] || strImageURL.length == 0)    {
        UIImage *img=[UIImage imageNamed:@"profile_pic.png"];
        [imgview  setImage:img];
    } else {
        [imgview sd_setImageWithURL:[NSURL URLWithString:strImageURL] placeholderImage:[UIImage imageNamed:@"profile_pic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];//26-Nov
    }
    [view addSubview:imgview];
    
    UILabel *lblUsername = [[UILabel alloc]initWithFrame:CGRectMake(40, 5 , 250, 15)];
    [lblUsername setText:strUserName];
    lblUsername.font = customFont;
    lblUsername.numberOfLines = 1;
    lblUsername.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    lblUsername.adjustsFontSizeToFitWidth = YES;
    lblUsername.adjustsLetterSpacingToFitWidth = YES;
    lblUsername.minimumScaleFactor = 10.0f/12.0f;
    lblUsername.clipsToBounds = YES;
    lblUsername.backgroundColor = [UIColor clearColor];
    lblUsername.textColor = [UIColor lightGrayColor];
    lblUsername.textAlignment = NSTextAlignmentLeft;
    lblUsername.lineBreakMode=NSLineBreakByWordWrapping;
    // [lblUsername setTextColor:[UIColor colorWithRed:36.0/255.0 green:168.0/255.0 blue:109.0/255.0 alpha:1.0f]];
    [lblUsername setTextColor:[UIColor blackColor]];
    [view addSubview:lblUsername];
    
//    UIButton *btnUsername = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnUsername setFrame:CGRectMake(40, 5 , 245, 15)];
//    [btnUsername addTarget:self action:@selector(btnUsername_CommentClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btnUsername setTag:tagForUserName];
//    [view addSubview:btnUsername];
//    
    UILabel *lblComment = [[UILabel alloc]initWithFrame:CGRectMake(40, 20 , [UIScreen mainScreen].bounds.size.width-50, 30)];
    [lblComment setText:strComment];
    lblComment.font = customFont;
    lblComment.numberOfLines = 0;
    lblComment.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    lblComment.adjustsFontSizeToFitWidth = YES;
    lblComment.adjustsLetterSpacingToFitWidth = YES;
    lblComment.minimumScaleFactor = 10.0f/12.0f;
    lblComment.clipsToBounds = YES;
    lblComment.backgroundColor = [UIColor clearColor];
    lblComment.textColor = [UIColor grayColor];
    lblComment.textAlignment = NSTextAlignmentLeft;
    lblComment.lineBreakMode=NSLineBreakByWordWrapping;
    
    CGSize labelSize = [lblComment.text sizeWithFont:lblComment.font
                                   constrainedToSize: CGSizeMake(245, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat labelHeight = labelSize.height;
    int lines = labelHeight/10;
    [lblComment setFrame:CGRectMake(lblComment.frame.origin.x,lblComment.frame.origin.y, lblComment.frame.size.width,labelHeight )];
    [lblComment setNumberOfLines:lines];
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(40, lblComment.frame.origin.y+lblComment.frame.size.height , 245, 15)];
    [lblTime setText:strDate];
    lblTime.font = customFont;
    lblTime.numberOfLines = 1;
    lblTime.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    lblTime.adjustsFontSizeToFitWidth = YES;
    lblTime.adjustsLetterSpacingToFitWidth = YES;
    lblTime.minimumScaleFactor = 10.0f/12.0f;
    lblTime.clipsToBounds = YES;
    lblTime.backgroundColor = [UIColor clearColor];
    lblTime.textColor = [UIColor lightGrayColor];
    lblTime.textAlignment = NSTextAlignmentLeft;
    lblTime.lineBreakMode=NSLineBreakByWordWrapping;
    [lblTime setTextColor:[UIColor lightGrayColor]];
    
    [view addSubview:lblTime];
    
    view.autoresizingMask =UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    int maxHeight=MAX((lblTime.frame.origin.y+lblTime.frame.size.height),35);
    maxHeight=maxHeight;
    view.clipsToBounds=YES;
    [view addSubview:lblComment];
    // view Frame Set
    
    [view setFrame:CGRectMake(0, lastCommentHeight, [UIScreen mainScreen].bounds.size.width-15, maxHeight)];
    view.autoresizingMask =UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    return view;
}

#pragma mark -  Like Comment Share

-(IBAction)btnLikeClick:(id)sender
{
    
    NSString *netStr = [[Globals sharedInstance] checkNetworkConnectivity];
    if([netStr isEqualToString:@"NoAccess"])
    {
        [CommonUtility showMessage:@"No Data Connection." withTitle:@""];
        return;
    }
    UIButton *btnSelected = (UIButton *)sender;
    
    [btnSelected setAlpha:0.5];
    
    [btnSelected setUserInteractionEnabled:NO];
    
    NSMutableArray *arrAllFeeds=[[NSMutableArray alloc]init];
    clsFeed *feedObj;
    feedObj=(clsFeed *)[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:btnSelected.tag] ;
    arrAllFeeds=[Globals sharedInstance].arrFeeds_TW_Fetching;
    if ([feedObj.feed_Type isEqualToString:@"Tw"])
    {
        @try
        {
            //        {
            if (![feedObj.feed_AccessToken isEqualToString:nil]&&![feedObj.feed_AccessToken isEqualToString:@""])
            {
                
                NSString *strID=[@"" stringByAppendingFormat:@"%@",feedObj.feed_TweetPostID];//feedObj.feed_TweetPostID;
                NSString *strConsumerkey = CLIENTKEY_TWITTER;
                NSString *strConsumerSecret = SECRETKEY_TWITTER;
                
                if (feedObj.feed_isLike == NO)
                {
                    STTwitterAPI *twitter1 = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strConsumerkey consumerSecret:strConsumerSecret oauthToken:feedObj.feed_AccessToken oauthTokenSecret:feedObj.feed_SecretKey];
                    
                    [twitter1 verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
                    
                         [twitter1 postFavoriteCreateWithStatusID:strID includeEntities:nil successBlock:^(NSDictionary *estatus)
                          {
                              [self LikeIncrementCount:btnSelected.tag];
                              [btnSelected setUserInteractionEnabled:YES];
                              [btnSelected setAlpha:1.0];
                          }
                        errorBlock:^(NSError *error)
                          {
                              NSLog(@"Error :%@", error.description);
                          }];
                     } errorBlock:^(NSError *error)
                     {
                         NSLog(@"Error :%@", error.description);
                     }];
                }
                else
                {
                    STTwitterAPI *twitter1 = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strConsumerkey consumerSecret:strConsumerSecret oauthToken:feedObj.feed_AccessToken  oauthTokenSecret:feedObj.feed_SecretKey];
                    
                    [twitter1 verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
                         [twitter1 postFavoriteDestroyWithStatusID:strID includeEntities:nil
                                                      successBlock:^(NSDictionary *status)
                          {
                              [self LikeDecrementCount:btnSelected.tag];
                              
                          }
                                                        errorBlock:^(NSError *error)
                          {
                              NSLog(@"Error :%@", error.description);

                              [CommonUtility showMessage:@"Twitter rate limit exceeded. Try again after some time" withTitle:@""];
                          }];
                     }
                                                     errorBlock:^(NSError *error)
                     {                  ////NSLog (@" Twitter Error :%@",error);
                         NSLog(@"Error :%@", error.description);

                         [CommonUtility showMessage:@"Twitter rate limit exceeded. Try again after some time" withTitle:@""];
                     }];
                }
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception caught!");
        }
        @finally
        {
            
        }
    }
    [btnSelected setUserInteractionEnabled:YES];
    [btnSelected setAlpha:1.0];
}
#pragma mark - Like Count Methods
-(void)LikeDecrementCount:(NSInteger)intcommentIndex
{
    NSMutableArray *arrAllFeeds=[[NSMutableArray alloc]init];
    clsFeed *feedObj =(clsFeed *)[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:intcommentIndex] ;
    arrAllFeeds=[Globals sharedInstance].arrFeeds_TW_Fetching;
    [feedObj setFeed_isLike:NO];
    NSInteger cellTag=1000000+intcommentIndex;

    FeedCell* cell=(FeedCell*) [self.tblFeed viewWithTag:cellTag];
    [cell.btnLike setSelected:NO];
    feedObj.feed_LikeCount--;
    
    if (feedObj.feed_LikeCount > 1) {
        cell.lblLikeCount.text=[@"" stringByAppendingFormat:@"%ld",(long)feedObj.feed_LikeCount];
    }
    else
    {
        cell.lblLikeCount.text=[@"" stringByAppendingFormat:@"%ld",(long)feedObj.feed_LikeCount];
    }
    
    [self.tblFeed reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:intcommentIndex], nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)LikeIncrementCount:(NSInteger)intcommentIndex
{
    NSMutableArray *arrAllFeeds=[[NSMutableArray alloc]init];
    clsFeed *feedObj =(clsFeed *)[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:intcommentIndex] ;
    arrAllFeeds=[Globals sharedInstance].arrFeeds_TW_Fetching;
    [feedObj setFeed_isLike:YES];
    NSInteger cellTag=1000000+intcommentIndex;
    
    FeedCell* cell=(FeedCell*) [self.tblFeed viewWithTag:cellTag];
    
    [cell.btnLike setSelected:YES];
    feedObj.feed_LikeCount++;
    
    if (feedObj.feed_LikeCount > 1) {
        cell.lblLikeCount.text=[@"" stringByAppendingFormat:@"%ld",feedObj.feed_LikeCount];
    }
    else
    {
        cell.lblLikeCount.text=[@"" stringByAppendingFormat:@"%ld",feedObj.feed_LikeCount];
    }
    [self.tblFeed reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:intcommentIndex], nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(IBAction)btnCommentClick:(id)sender
{
    UIButton *btnSelected = (UIButton *)sender;
    ////NSLog (@"btnSelected tag %ld",btnSelected.tag);
    
    NSMutableArray *arrAllFeeds=[[NSMutableArray alloc]init];
    clsFeed *feedObj;
    
    feedObj=(clsFeed *)[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:btnSelected.tag] ;
    arrAllFeeds=[Globals sharedInstance].arrFeeds_TW_Fetching;
    if ([feedObj.feed_Type isEqualToString:@"Tw"]) {
        NSString *strID=feedObj.feed_TweetPostID;
        NSString *strConsumerkey = CLIENTKEY_TWITTER;
        NSString *strConsumerSecret = SECRETKEY_TWITTER;
        if (feedObj.feed_isTweet == NO) {
            STTwitterAPI *twitter1 = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strConsumerkey consumerSecret:strConsumerSecret oauthToken:feedObj.feed_AccessToken oauthTokenSecret:feedObj.feed_SecretKey];
            
            [twitter1 verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
                 [twitter1 postStatusRetweetWithID:strID successBlock:^(NSDictionary *status)
                  {
                      clsFeed *feedObj =(clsFeed *)[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:btnSelected.tag];
                      [feedObj setFeed_isTweet:YES];
                      NSInteger cellTag=1000000+(btnSelected.tag);
                      FeedCell* cell =(FeedCell*) [self.tblFeed viewWithTag:cellTag];
                      [cell.btnLike setSelected:NO];
                  }
                  errorBlock:^(NSError *error)
                  {
                      
                  }];
                 
             } errorBlock:^(NSError *error)
             {
                 NSLog (@" Twitter Error :%@",error);
             }];
        }
    }
}
-(IBAction)btnLoadMoreCommentClick:(id)sender
{
    UIButton *tmp = (UIButton *)sender;
    NSInteger intIndexForLoad=tmp.tag;
    clsFeed *feedObj=(clsFeed *)[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:intIndexForLoad] ;
    NSInteger tmp_total =  feedObj.feed_commentsToDisplay;
    NSInteger total_count = feedObj.feed_dataComments.count;
    tmp_total +=3;
    tmp_total=(MIN(tmp_total, total_count));
    [[[Globals sharedInstance].arrFeeds_TW_Fetching objectAtIndex:tmp.tag] setFeed_commentsToDisplay:tmp_total];
    NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:0 inSection:tmp.tag];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
    [self.tblFeed reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
}
- (IBAction)btnPostCommentClick:(id)sender {
    
    NSString *netStr = [[Globals sharedInstance] checkNetworkConnectivity];
    if([netStr isEqualToString:@"NoAccess"])
    {
        [CommonUtility showMessage:@"No Data Connection." withTitle:@""];
        return;
    }
    
    UIButton *btnSelected = (UIButton *)sender;
    NSInteger cellTag=1000000+(btnSelected.tag);
    NSMutableArray *arrAllFeeds=[[NSMutableArray alloc]init];
    FeedCell*cell =(FeedCell*) [self.tblFeed viewWithTag:cellTag];
    arrAllFeeds=[Globals sharedInstance].arrFeeds_TW_Fetching;
    NSString *strComment=cell.txtComment.text;
    if([strComment isEqualToString:@""])
    {
        [cell.txtComment resignFirstResponder];
        return;
    }
    cell.txtComment.text=@"";
    
    clsFeed *feedObj=(clsFeed *)[arrAllFeeds objectAtIndex:btnSelected.tag] ;
    [cell.txtComment resignFirstResponder];
    if ([feedObj.feed_Type isEqualToString:@"Tw"])
    {
        @try
        {
            //        {
            if (![feedObj.feed_AccessToken isEqualToString:nil]&&![feedObj.feed_AccessToken isEqualToString:@""])
            {
                
                NSString *strID= [@"" stringByAppendingFormat:@"%@",feedObj.feed_id];//take from id
                NSString *strConsumerkey = CLIENTKEY_TWITTER;
                NSString *strConsumerSecret =SECRETKEY_TWITTER;
                
                STTwitterAPI *twitter1 = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strConsumerkey consumerSecret:strConsumerSecret oauthToken:feedObj.feed_AccessToken oauthTokenSecret:feedObj.feed_SecretKey];
                
                [twitter1 verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {

                     NSString *strPost=[@"" stringByAppendingFormat:@"%@ %@",feedObj.feed_ScreenName,strComment];
                     [twitter1 postStatusUpdate:strPost
                              inReplyToStatusID:strID
                                       latitude:nil
                                      longitude:nil
                                        placeID:nil
                             displayCoordinates:nil
                                       trimUser:nil
                                   successBlock:^(NSDictionary *status) {
                                       NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
                                       [dict setObject:strComment forKey:@"Comment"];
                                       NSString *strUserID=[@"" stringByAppendingFormat:@"%ld",(long)self.strLogin];
                                       [dict setValue:strUserID forKey:@"sobuzUserId"];
                                       [dict setObject:@"0" forKey:@"IscomLiked"];
                                       [dict setObject:@"0" forKey:@"IsCommentingLikeSupported"];
                                       [dict setObject:@"" forKey:@"key"];
                                       [dict setObject:@"" forKey:@"LikeLink"];
                                       [dict setObject:@"0" forKey:@"loginOrId"];
                                       [dict setObject:@"" forKey:@"ProfileImage"];
                                       [dict setObject:@"0" forKey:@"secret"];
                                       [dict setObject:@"" forKey:@"SocialIconUrl"];
                                       [dict setObject:@"" forKey:@"Time"];
                                       [dict setObject:[status objectForKey:@"id_str"] forKey:@"commentid"];
                                       [dict setObject:@"" forKey:@"FriendlyDate"];
                                       [dict setObject:@"" forKey:@"id"];
                                       [dict setObject:@"" forKey:@"UserAccountType"];
                                       [dict setObject:feedObj.feed_Title forKey:@"Username"];
                                       commentIndex =btnSelected.tag;
                                       [self performSelector:@selector(twitterReplyLoaddata:) withObject:status afterDelay:2.0];
                                   } errorBlock:^(NSError *error) {
                                       NSLog (@"status is %@",error);
                                       // ...
                                   }];
                     
                 } errorBlock:^(NSError *error)
                 
                 {
                     NSLog (@" Twitter Error :%@",error);
                 }];
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception caught!");
        }
        @finally
        {
            
        }
    }
}
// Twitter Comment Load
-(void)twitterReplyLoaddata:(NSDictionary *)arrayTwitterComment
{
    NSMutableArray *arrAllFeeds=[[NSMutableArray alloc]init];
    arrAllFeeds=[Globals sharedInstance].arrFeeds_TW_Fetching;
    clsFeed *feedObj=(clsFeed *)[arrAllFeeds objectAtIndex:commentIndex] ;
    NSString *strComment =[arrayTwitterComment  objectForKey:@"text"];
    NSString *strUserName = [[arrayTwitterComment objectForKey:@"user"]objectForKey:@"name"];
    NSString *strProfile = [[arrayTwitterComment objectForKey:@"user"]objectForKey:@"profile_image_url"];
    NSString *dateString = [arrayTwitterComment  objectForKey:@"created_at"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *dateFromString = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    dateFromString = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"eee MMM dd, yyyy hh:mm a"];
    NSString *strDate=[dateFormatter stringFromDate:dateFromString];
    
    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc]init];
    [dictTmp setObject:strComment forKey:@"text"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:strUserName forKey:@"name"];
    [dic setObject:strProfile forKey:@"profile_image_url"];
    [dictTmp setObject:dic forKey:@"user"];
    [dictTmp setObject:strDate forKey:@"created_at"];
    
    NSMutableArray *feed_dataComments=[[NSMutableArray alloc]init];
    
    feed_dataComments=[feedObj.feed_dataComments mutableCopy];
    
    if (feed_dataComments.count == 0) {
        feed_dataComments =[[NSMutableArray alloc]initWithCapacity:0];
    }
    [feed_dataComments addObject:dictTmp];
    [[arrAllFeeds objectAtIndex:commentIndex] setFeed_dataComments:feed_dataComments];
    [[arrAllFeeds objectAtIndex:commentIndex] setFeed_CommentCount:feed_dataComments.count];
    feedObj.feed_commentsToDisplay=feedObj.feed_commentsToDisplay+1;
    [[arrAllFeeds objectAtIndex:commentIndex] setFeed_commentsToDisplay:feedObj.feed_commentsToDisplay];

    NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:0 inSection:commentIndex];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
    [self.tblFeed reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - Fetch Twitter Feeds
-(void) FetchTwitterData
{
    NSString *strSecret=self.strSecret;
    NSString *strToken=self.strToken;
    NSString *strLogin=self.strLogin;
    
    //        NSString *strSinceID=[objSocialAccount socialaccount_Since];
    
    NSString *strConsumerkey = CLIENTKEY_TWITTER;
    NSString *strConsumerSecret =SECRETKEY_TWITTER;

    STTwitterAPI *twitterUser = [STTwitterAPI twitterAPIAppOnlyWithConsumerName:@"SoBuz" consumerKey:strConsumerkey consumerSecret:strConsumerSecret];
    [twitterUser verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        [twitterUser getUsersShowForUserID:strLogin orScreenName:nil includeEntities:nil successBlock:^(NSDictionary *user) {
            // getStatusesHomeTimelineWithCount
            NSString *profileImageURLString = [user valueForKey:@"profile_image_url"];
            NSString *userName = [user valueForKey:@"screen_name"];
            
            STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strConsumerkey consumerSecret:strConsumerSecret oauthToken:strToken oauthTokenSecret:strSecret];
            
            [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
   
                [twitter getStatusesHomeTimelineWithCount:@"50" sinceID:nil maxID:nil trimUser:nil excludeReplies:[NSNumber numberWithInt:0] contributorDetails:nil includeEntities:[NSNumber numberWithInt:1] successBlock:^(NSArray *statuses){
                    NSMutableArray *arrTweetMain=[[NSMutableArray alloc]init];
                    
                    for (int j=0; j<statuses.count; j++) {
                        
                        if ([[[statuses objectAtIndex:j ]objectForKey:@"in_reply_to_status_id"] isEqual:[NSNull null]]) {
                            
                            [arrTweetMain  addObject:[statuses objectAtIndex:j]];
                        }
                    }
                    NSMutableArray *arrTweets=[[NSMutableArray alloc]init];
                    for (int j=0; j<arrTweetMain.count; j++) {
                        
                        NSString *strID =[@"" stringByAppendingFormat:@"%@",[[arrTweetMain objectAtIndex:j] objectForKey:@"id"]];
                        
                        NSMutableDictionary *dicTweet=[[NSMutableDictionary alloc]init];
                        
                        NSDictionary *arrTweet_tmp=[arrTweetMain objectAtIndex:j];
                        
                        [dicTweet setObject:arrTweet_tmp forKey:@"tweet"];
                        
                        NSMutableArray *arrTweetReply=[[NSMutableArray alloc]init];
                        
                        for (int k=0; k<statuses.count; k++) {
                            
                            if ([[[statuses objectAtIndex:k ]objectForKey:@"in_reply_to_status_id_str"] isEqual:[NSNull null]]) {
                                
                            }
                            else
                            {
//                                NSString *replyId=[[statuses objectAtIndex:k]objectForKey:@"in_reply_to_status_id_str"] ;
                                if ([[[statuses objectAtIndex:k ]objectForKey:@"in_reply_to_status_id_str"] isEqualToString:strID]) {
                                    
                                    [arrTweetReply addObject:[statuses objectAtIndex:k]];
                                }
                            }
                            
                        }
                        
                        [dicTweet setObject:arrTweetReply forKey:@"comment"];
                        [arrTweets addObject:dicTweet];
                        
                    }
                    
                    for (int j=0; j<[arrTweets count]; j++) {
                        
                        NSString *strId = [[[arrTweets objectAtIndex:j] objectForKey:@"tweet"]objectForKey:@"id"];
                        NSString *strText =[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"]objectForKey:@"text"];
                        NSString *strName =[[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"]objectForKey:@"user"]objectForKey:@"name"];
                        NSString *strPicURL =[[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"]objectForKey:@"user"]objectForKey:@"profile_image_url"];
                        NSString *dateString = [[[arrTweets objectAtIndex:j]objectForKey:@"tweet"]objectForKey:@"created_at"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        NSDate *dateFromString = [[NSDate alloc] init];
                        [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
                        dateFromString = [dateFormatter dateFromString:dateString];
                        [dateFormatter setDateFormat:@"eee MMM dd, yyyy hh:mm a"];
                        NSString *strDate=[dateFormatter stringFromDate:dateFromString];
                        NSString *strPicImageURL =@"";
                        NSString *strOpenUrl =@"";
                        if ( [[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"]objectForKey:@"entities"] objectForKey:@"media"])
                        {
                            NSMutableArray *arrMedia=[[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"]objectForKey:@"entities"] objectForKey:@"media"];
                            if (arrMedia.count >0) {
                                strPicImageURL=  [[arrMedia objectAtIndex:0] objectForKey:@"media_url"];
                            }
                        }
                        
                        NSMutableArray *arrcommentData= [[arrTweets objectAtIndex:j]objectForKey:@"comment"];
                        NSString *screenName=[[[[arrTweets objectAtIndex:j ]objectForKey:@"tweet"]objectForKey:@"user" ]objectForKey:@"screen_name"] ;
                        
                        NSInteger likecount=0;
                        
                        if ([[[arrTweets objectAtIndex:j]objectForKey:@"tweet"] objectForKey:@"favorite_count"])
                        {
                            likecount=[[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"]  objectForKey:@"favorite_count"] integerValue];
                        }
      
                        BOOL isLiked = [[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"] objectForKey:@"favorited"] boolValue];
                        BOOL isTweet =[[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"] objectForKey:@"retweeted"] boolValue];
                        
                        NSString *tweetPostId=[[[arrTweets objectAtIndex:j]objectForKey:@"tweet"]objectForKey:@"id_str"];
                        
                        strOpenUrl=[@"" stringByAppendingFormat:@"https://twitter.com/%@/status/%@",screenName,tweetPostId];
                        
                        clsFeed *objFeed =[[clsFeed  alloc]init];
                        [objFeed setFeed_id:strId];
                        
                        [objFeed setFeed_TweetPostID:tweetPostId];
                        
                        [objFeed setFeed_Type:@"Tw"];
                        [objFeed setFeed_Title:strName];
                        [objFeed setFeed_ImageURL:strPicURL];
                        [objFeed setFeed_DateObject:dateFromString];
                        [objFeed setFeed_Date:strDate];
                        [objFeed setFeed_Description:strText];
                        [objFeed setFeed_PicImageURL:strPicImageURL];
                        [objFeed setFeed_UserPicImageURL:profileImageURLString];
                        [objFeed setFeed_OpenURL:strOpenUrl];
                        [objFeed setFeed_Reply:arrcommentData];
                        [objFeed setFeed_dataComments:arrcommentData];
                        [objFeed setFeed_LikeCount:likecount];
                        [objFeed setFeed_CommentCount:arrcommentData.count];
                        [objFeed setFeed_isTweet:isTweet];
                        if(arrcommentData.count>0)
                        {
                            [objFeed setFeed_commentsToDisplay:3];
                        }
                        
                        [objFeed setFeed_isLike:isLiked];
                        [objFeed setFeed_SecretKey:twitter.oauthAccessTokenSecret];
                        [objFeed setFeed_AccessToken:twitter.oauthAccessToken];
                        [objFeed setFeed_ScreenName:screenName ];
                        [objFeed setFeed_PostOwnerId:userName];
                        [[Globals sharedInstance].arrFeeds_TW_Fetching addObject:objFeed];
                    }
                    [self.tblFeed setDataSource:self];
                    [self.tblFeed setDelegate:self];
                    [self.tblFeed reloadData];
                    [DejalBezelActivityView removeViewAnimated:YES];
                } errorBlock:^(NSError *error) {
                    
                }];
                
                
            } errorBlock:^(NSError *error) {
                //
            }];
            
            
        } errorBlock:^(NSError *error) {
            //
        }];
        
    } errorBlock:^(NSError *error) {
        //
    }];
    
}
- (IBAction)btnPostClick:(id)sender {
    PostViewController *postView = [self.storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
    postView.strLogin = self.strLogin;
    postView.strSecret = self.strSecret;
    postView.strToken = self.strToken;
    [self.navigationController pushViewController:postView animated:YES];
}
@end
