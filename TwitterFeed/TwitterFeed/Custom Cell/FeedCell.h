//
//  FeedCell.h
//  orBIDme
//
//  Created by orBIDme on 6/10/14.


#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,retain)NSIndexPath *selectedIndexPath;
@property(strong, nonatomic) IBOutlet UIImageView *imgType;
@property(strong, nonatomic) IBOutlet UIImageView *imgThumbnail;
@property(strong, nonatomic) IBOutlet UILabel *lblTitle;
@property(strong, nonatomic) IBOutlet UILabel *lblDate;
//@property(strong, nonatomic) IBOutlet UILabel *lblDescription;
@property(strong, nonatomic) IBOutlet UITextView *lblDescription;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cellIndicator;

@property(nonatomic,retain)IBOutlet UIImageView *imgComment;

@property(nonatomic,retain)IBOutlet UIImageView *imgFeedPic;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadMoreIndicate;

@property(strong, nonatomic) IBOutlet UILabel *lblLikeCount;
@property(strong, nonatomic) IBOutlet UILabel *lblCommentsCount;
@property (weak, nonatomic) IBOutlet UIView *viewInnerCmtView;


@property (strong, nonatomic) IBOutlet UIView *viewBottom;

@property(strong, nonatomic) IBOutlet UIView *viewComments;

@property (weak, nonatomic) IBOutlet UIButton *btnLoadMoreComment;

@property (weak, nonatomic) IBOutlet UIButton *btnPost;

@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnLike_icon;

@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnComment_icon;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnShare_icon;
@property (weak, nonatomic) IBOutlet UIButton *btnSave_icon;


@property(strong, nonatomic) IBOutlet UIView *viewWriteComment;


@property (weak, nonatomic) IBOutlet UITextField *txtComment;


@property (strong, nonatomic) IBOutlet UIImageView *imgprogress;

@property (weak, nonatomic) IBOutlet UIWebView *webviewImage;
@property (weak, nonatomic) IBOutlet UIButton *btnEmoji;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

@property (weak, nonatomic) IBOutlet UIButton *btnAttachment;
@property (weak, nonatomic) IBOutlet UIButton *btnMemeGenration;
@property (weak, nonatomic) IBOutlet UITextField *txtEmoji;

@property (strong, nonatomic) IBOutlet UIImageView *imgCountSeperatorLine;


@property (strong, nonatomic) IBOutlet UIButton *btnDeleteFeed;
@property (strong, nonatomic) IBOutlet UIButton *btnHideFeed;


@property (strong, nonatomic) IBOutlet UIButton *btnSobuz;


@property (strong, nonatomic) IBOutlet UIButton *btnFeedSelection;



@property (strong, nonatomic) IBOutlet UIView *viewButtons;






@end
