//
//  Comment.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (instancetype) initWithDictionary:(NSDictionary *)commentDictionary
{
    self = [super init];
    
    if (self)
    {
        self.idNumber = commentDictionary[@"id"];
        self.text = commentDictionary[@"text"];
        self.from = [[User alloc] initWithDictionary:commentDictionary[@"from"]];
    }
    
    return self;
}

@end
