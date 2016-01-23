//
//  OAProblem.h
//  OAuthConsumer
//
//  Created by orBIDme on 03/09/08.

#import <Foundation/Foundation.h>

enum {
	kOAProblemSignatureMethodRejected = 0,
	kOAProblemParameterAbsent,
	kOAProblemVersionRejected,
	kOAProblemConsumerKeyUnknown,
	kOAProblemTokenRejected,
	kOAProblemSignatureInvalid,
	kOAProblemNonceUsed,
	kOAProblemTimestampRefused,
	kOAProblemTokenExpired,
	kOAProblemTokenNotRenewable
};

@interface OAProblem : NSObject {
	NSString *problem;
}

@property (readonly) NSString *problem;

- (id)initWithProblem:(NSString *)aProblem;
- (id)initWithResponseBody:(NSString *)response;

- (BOOL)isEqualToProblem:(OAProblem *)aProblem;
- (BOOL)isEqualToString:(NSString *)aProblem;
- (BOOL)isEqualTo:(id)aProblem;
- (int)code;

+ (OAProblem *)problemWithResponseBody:(NSString *)response;

+ (NSArray *)validProblems;

+ (OAProblem *)SignatureMethodRejected;
+ (OAProblem *)ParameterAbsent;
+ (OAProblem *)VersionRejected;
+ (OAProblem *)ConsumerKeyUnknown;
+ (OAProblem *)TokenRejected;
+ (OAProblem *)SignatureInvalid;
+ (OAProblem *)NonceUsed;
+ (OAProblem *)TimestampRefused;
+ (OAProblem *)TokenExpired;
+ (OAProblem *)TokenNotRenewable;

@end
