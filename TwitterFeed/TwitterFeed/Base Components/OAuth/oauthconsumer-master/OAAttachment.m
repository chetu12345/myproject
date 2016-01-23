//
//  OAAttachment.h
//  Zeus
//
//  Created by orBIDme on on 2/3/11.
//  
//

#import "OAAttachment.h"

@implementation OAAttachment

@synthesize name, fileName, contentType, data;

- (id)initWithName:(NSString *)aName filename:(NSString *)aFilename contentType:(NSString *)aContentType data:(NSData *)aData{
	if((self = [super init])){
		self.name = aName;
		self.fileName = aFilename;
		self.contentType = aContentType;
		self.data = aData;
	}
	return self;
}

- (void)dealloc{
	[name release];
	[fileName release];
	[contentType release];
	[data release];
	[super dealloc];
}

@end