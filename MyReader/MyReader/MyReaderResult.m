//
//  MyReaderResult.m
//  OfflineReader
//
//  Created by chenjs.us on 12-11-8.
//  Copyright (c) 2012年 HellTom. All rights reserved.
//

#import "MyReaderResult.h"

@implementation MyReaderResult

@synthesize retCode = _retCode;
@synthesize retValue = _retValue;
@synthesize retImage = _retImage;
@synthesize thumbImageData = _thumbImageData;


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:self.retCode forKey:@"RetCode"];
    [coder encodeObject:self.retValue forKey:@"RetValue"];
    [coder encodeObject:self.retImage forKey:@"RetImage"];
    [coder encodeObject:self.thumbImageData forKey:@"ThumbImageData"];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self != nil) {
        self.retCode = [coder decodeIntForKey:@"RetCode"];
        self.retValue = [coder decodeObjectForKey:@"RetValue"];
        self.retImage = [coder decodeObjectForKey:@"RetImage"];
        self.thumbImageData = [coder decodeObjectForKey:@"ThumbImageData"];
	}
	return self;
}

@end
