//
//  DataSource.h
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;

@interface DataSource : NSObject

@property (nonatomic, strong, readonly) NSArray *mediaItems;

+ (instancetype) sharedInstance;
- (void) deleteMediaItem:(Media *)item;
- (NSUInteger)countOfMediaItems;

@end
