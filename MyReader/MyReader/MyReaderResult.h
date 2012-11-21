//
//  MyReaderResult.h
//  OfflineReader
//
//  Created by chenjs.us on 12-11-8.
//  Copyright (c) 2012年 HellTom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyReaderResult : NSObject <NSCoding>

@property (nonatomic, assign) int retCode;
@property (nonatomic, strong) NSString *retValue;
@property (nonatomic, strong) UIImage *retImage;
@property (nonatomic, strong) NSData *thumbImageData;

@end
