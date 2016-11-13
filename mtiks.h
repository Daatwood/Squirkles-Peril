//
//  mtiks.h
//
//  Created by Muthu Arumugam on 1/14/10.
//  Copyright 2010 mtiks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mtiks : NSObject {
	@private
	NSString *_sessionUUID;        // Unique identifier for this session.
	NSString *_iTunesURL;
	NSString *_appKey;
}

+ (mtiks *)sharedSession;
- (NSString *)getVersion;

// Basic start & stop of tracking
- (void)start:(NSString *)strAppKey;
- (void)stop;

// Event & Attributes
- (void)postEvent:(NSString *)eventName;
- (void)postEvent:(NSString *)eventName withAttributes:(NSDictionary *)attribs;

@end
