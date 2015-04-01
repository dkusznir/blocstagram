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

#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    if (self)
    {
        [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
        [aCoder encodeObject:self.from forKey:NSStringFromSelector(@selector(from))];
        [aCoder encodeObject:self.text forKey:NSStringFromSelector(@selector(text))];
    }
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.from = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(from))];
        self.text = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(text))];
    }
    
    return self;
}

@end
