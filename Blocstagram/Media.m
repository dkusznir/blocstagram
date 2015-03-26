//
//  Media.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "Media.h"

@implementation Media

- (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary
{
    self = [super init];
    
    if (self)
    {
        self.idNumber = mediaDictionary[@"id"];
        self.user = [[User alloc] initWithDictionary:mediaDictionary[@"user"]];
        NSString *standardResolutionImageURLString = mediaDictionary[@"images"][@"standard_resolution"][@"url"];
        NSURL *standardResolutionImageURL = [NSURL URLWithString:standardResolutionImageURLString];
        
        if (standardResolutionImageURL)
        {
            self.mediaURL = standardResolutionImageURL;
        }
        
        NSObject *captionObject = mediaDictionary[@"caption"];
        
        if ([captionObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *captionDictionary = (NSDictionary *)captionObject;
            self.caption = captionDictionary[@"text"];
        }
        
        else
        {
            self.caption = @"";
        }
        
        NSMutableArray *commentsArray = [NSMutableArray array];
        
        for (NSDictionary *commentDictionary in mediaDictionary[@"comments"][@"data"])
        {
            Comment *comment = [[Comment alloc] initWithDictionary:commentDictionary];
            [commentsArray addObject:comment];
        }
        
        self.comments = commentsArray;
    }
    
    
    return self;
}

@end
