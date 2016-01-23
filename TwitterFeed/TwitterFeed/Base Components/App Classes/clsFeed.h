//
//  clsFeed.h
//  orBIDme
//
//  Created by Ajeet Singh on 7/28/14.


#import <Foundation/Foundation.h>
@interface clsFeed : NSObject



@property(nonatomic,retain) NSString *feed_sqnid;
@property (nonatomic,retain) NSMutableArray *feed_socialpost;


@property(nonatomic,retain)NSString *feed_id;
@property(nonatomic,retain)NSString *feed_fdid;

@property(nonatomic,retain)NSDate *feed_DateObject;
@property(nonatomic,retain)NSString *feed_Date;
@property(nonatomic,retain)NSString *feed_Type;
@property(nonatomic,assign)NSInteger feed_commentsToDisplay;

@property(nonatomic,retain)NSString *feed_Title_attr;
@property(nonatomic,retain)NSString *feed_Title;

@property(nonatomic,retain)NSString *feed_ImageURL;
@property(nonatomic,retain)NSString *feed_Description_attr;
@property(nonatomic,retain)NSString *feed_Description;

@property(nonatomic,retain)NSDictionary *feed_data;
@property(nonatomic,retain) NSMutableArray *feed_dataComments;


@property(nonatomic,retain)NSString *feed_PicImageURL;

@property(nonatomic,retain)NSString *feed_UserPicImageURL;
@property(nonatomic,retain)NSString *feed_OpenURL;

@property(nonatomic,assign)BOOL feed_isLike;
@property(nonatomic,assign)BOOL feed_isTweet;
@property(nonatomic,assign)NSInteger feed_LikeCount;
@property(nonatomic,assign)NSInteger feed_CommentCount;


@property(nonatomic,retain)NSString *feed_AccessToken;
@property(nonatomic,retain)NSString *feed_UserID;

@property(nonatomic,retain)NSDictionary *feed_UserData;
@property(nonatomic,retain)NSMutableArray *feed_Notes;
@property(nonatomic,retain)NSString *feed_SecretKey;

@property(nonatomic,retain)NSMutableArray *feed_Reply;

@property(nonatomic,retain)NSString *feed_ScreenName;
@property(nonatomic,retain)NSString *feed_TweetPostID;

@property(nonatomic,retain)NSString *feed_GIFImage;
@property(nonatomic,retain)NSString *feed_PostOwnerId;
@property(nonatomic,assign)NSInteger arrIndex;

@property(nonatomic,retain)NSString *feed_reblogKey;

@property(nonatomic,assign)BOOL feed_IsDeletable;


@end
