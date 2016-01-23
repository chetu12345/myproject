//
//  clsFeed.m
//  orBIDme
//
//  Created by Ajeet Singh on 7/28/14.
//  Copyright (c) 2014 ___Dmitry Ovechkin___. All rights reserved.
//

#import "clsFeed.h"

//#import "NSData.h"

@implementation clsFeed


@synthesize feed_sqnid;
@synthesize feed_socialpost;


@synthesize feed_id;
@synthesize feed_fdid;
@synthesize feed_DateObject;
@synthesize feed_Date;
@synthesize feed_Type;
@synthesize feed_Title_attr;
@synthesize feed_Title;

@synthesize feed_ImageURL;
@synthesize feed_Description_attr;
@synthesize feed_Description;

@synthesize feed_data;
@synthesize feed_dataComments;

@synthesize feed_PicImageURL;


@synthesize feed_UserPicImageURL;
@synthesize feed_OpenURL;

@synthesize feed_isLike;
@synthesize feed_LikeCount;
@synthesize feed_CommentCount;
@synthesize feed_commentsToDisplay;

@synthesize feed_AccessToken;
@synthesize feed_SecretKey;

@synthesize feed_UserID;
@synthesize feed_UserData;
@synthesize feed_Notes;
@synthesize feed_isTweet;

@synthesize feed_ScreenName;
@synthesize feed_Reply;

@synthesize feed_TweetPostID;
@synthesize feed_GIFImage;
@synthesize feed_PostOwnerId;

@synthesize arrIndex;
@synthesize feed_reblogKey;

@synthesize feed_IsDeletable;


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        @try {
            feed_sqnid= [decoder decodeObjectForKey:@"feed_sqnid"];
//            if(feed_socialpost== nil)
//            {
//                
//            }
//            else
//            {
//                feed_socialpost = [decoder decodeObjectForKey:@"feed_socialpost"];
//            }
//            
            
            feed_socialpost = [decoder decodeObjectForKey:@"feed_socialpost"];
            
            feed_id  = [decoder decodeObjectForKey:@"feed_id"];
            feed_fdid = [decoder decodeObjectForKey:@"feed_fdid"];
            
            feed_DateObject  = [decoder decodeObjectForKey:@"feed_DateObject"];
            feed_Date  = [decoder decodeObjectForKey:@"feed_Date"];
            feed_Type = [decoder decodeObjectForKey:@"feed_Type"];
            feed_Title_attr = [decoder decodeObjectForKey:@"feed_Title_attr"];
            feed_Title= [decoder decodeObjectForKey:@"feed_Title"];
            feed_ImageURL= [decoder decodeObjectForKey:@"feed_ImageURL"];
            feed_Description_attr= [decoder decodeObjectForKey:@"feed_Description_attr"];
            feed_Description = [decoder decodeObjectForKey:@"feed_Description"];
            feed_data= [decoder decodeObjectForKey:@"feed_data"];
            feed_dataComments= [decoder decodeObjectForKey:@"feed_dataComments"];
            feed_PicImageURL= [decoder decodeObjectForKey:@"feed_PicImageURL"];
            
            feed_UserPicImageURL = [decoder decodeObjectForKey:@"feed_UserPicImageURL"];
            feed_OpenURL= [decoder decodeObjectForKey:@"feed_OpenURL"];
            feed_isLike = [decoder decodeBoolForKey:@"feed_isLike"];
            feed_LikeCount = [decoder decodeIntegerForKey:@"feed_LikeCount"];
            feed_CommentCount = [decoder decodeIntegerForKey:@"feed_CommentCount"];
            feed_commentsToDisplay = [decoder decodeIntegerForKey:@"feed_commentsToDisplay"];
            feed_AccessToken= [decoder decodeObjectForKey:@"feed_AccessToken"];
            feed_SecretKey = [decoder decodeObjectForKey:@"feed_SecretKey"];
            feed_UserID= [decoder decodeObjectForKey:@"feed_UserID"];
            feed_PostOwnerId= [decoder decodeObjectForKey:@"feed_PostOwnerId"];
            
            
            if(feed_UserData== nil)
            {
                
            }
            else
            {
                feed_UserData= [decoder decodeObjectForKey:@"feed_UserData"];
            }
            
            
            feed_Notes= [decoder decodeObjectForKey:@"feed_Notes"];
            feed_isTweet = [decoder decodeBoolForKey:@"feed_isTweet"];
            feed_ScreenName= [decoder decodeObjectForKey:@"feed_ScreenName"];
            feed_Reply= [decoder decodeObjectForKey:@"feed_Reply"];
            feed_TweetPostID= [decoder decodeObjectForKey:@"feed_TweetPostID"];
            feed_GIFImage= [decoder decodeObjectForKey:@"feed_GIFImage"];
            
            
            
            feed_reblogKey= [decoder decodeObjectForKey:@"feed_reblogKey"];
            
            feed_IsDeletable=[decoder decodeBoolForKey:@"feed_IsDeletable"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    @try {
        [encoder      encodeObject:feed_sqnid  forKey:@"feed_sqnid"];
        
        if(feed_socialpost== nil)
        {
            
        }
        else
        {
            [encoder      encodeObject:feed_socialpost  forKey:@"feed_socialpost"];
        }
        
        
        
        [encoder      encodeObject:feed_id  forKey:@"feed_id"];
        [encoder      encodeObject:feed_fdid forKey:@"feed_fdid"];
        
        [encoder      encodeObject:feed_DateObject  forKey:@"feed_DateObject"];
        [encoder      encodeObject:feed_Date  forKey:@"feed_Date"];
        [encoder     encodeObject:feed_Type   forKey:@"feed_Type"];
        [encoder       encodeObject:feed_Title_attr forKey:@"feed_Title_attr"];
        [encoder        encodeObject:feed_Title forKey:@"feed_Title"];
        [encoder      encodeObject:feed_ImageURL  forKey:@"feed_ImageURL"];
        [encoder      encodeObject: feed_Description_attr forKey:@"feed_Description_attr"];
        [encoder      encodeObject:feed_Description  forKey:@"feed_Description"];
        [encoder      encodeObject:feed_data  forKey:@"feed_data"];
        [encoder      encodeObject:feed_dataComments  forKey:@"feed_dataComments"];
        [encoder      encodeObject:feed_PicImageURL  forKey:@"feed_PicImageURL"];
        [encoder     encodeObject:feed_UserPicImageURL   forKey:@"feed_UserPicImageURL"];
        [encoder    encodeObject:feed_OpenURL    forKey:@"feed_OpenURL"];
        [encoder      encodeBool:feed_isLike  forKey:@"feed_isLike"];
        [encoder      encodeInteger:feed_LikeCount  forKey:@"feed_LikeCount"];
        [encoder      encodeInteger:feed_CommentCount  forKey:@"feed_CommentCount"];
        [encoder      encodeInteger:feed_commentsToDisplay  forKey:@"feed_commentsToDisplay"];
        [encoder      encodeObject:feed_AccessToken  forKey:@"feed_AccessToken"];
        [encoder      encodeObject:feed_SecretKey  forKey:@"feed_SecretKey"];
        [encoder      encodeObject:feed_UserID  forKey:@"feed_UserID"];
        [encoder      encodeObject:feed_PostOwnerId  forKey:@"feed_PostOwnerId"];
        
        if(feed_UserData== nil)
        {
            
        }
        else
        {
            [encoder      encodeObject:feed_UserData  forKey:@"feed_UserData"];
        }
        
        
        [encoder      encodeObject:feed_Notes  forKey:@"feed_Notes"];
        [encoder       encodeBool:feed_isTweet forKey:@"feed_isTweet"];
        [encoder     encodeObject: feed_ScreenName  forKey:@"feed_ScreenName"];
        [encoder     encodeObject: feed_Reply  forKey:@"feed_Reply"];
        [encoder       encodeObject: feed_TweetPostID forKey:@"feed_TweetPostID"];
        
        [encoder       encodeObject:feed_GIFImage forKey:@"feed_GIFImage"];
        
        
        [encoder       encodeObject:feed_reblogKey forKey:@"feed_reblogKey"];
        
        [encoder      encodeBool:feed_IsDeletable  forKey:@"feed_IsDeletable"];
        

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
}



@end
