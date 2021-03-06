//
//  Media.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "Media.h"

@class MediaTableViewCell;

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
            self.downloadState = MediaDownloadStateNeedsImage;
        }
        
        else
        {
            self.downloadState = MediaDownloadStateNonRecoverableError;
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
        
        BOOL userHasLiked = [mediaDictionary[@"user_has_liked"] boolValue];
        
        self.likeState = userHasLiked ? likeStateLiked : likeStateNotLiked;
        
        NSUInteger myInt = [mediaDictionary[@"likes"][@"count"] integerValue];
        self.numberOfLikes = myInt;
    }
    
    
    return self;
}

#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder

{
    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.user forKey:NSStringFromSelector(@selector(user))];
    [aCoder encodeObject:self.mediaURL forKey:NSStringFromSelector(@selector(mediaURL))];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
    [aCoder encodeObject:self.caption forKey:NSStringFromSelector(@selector(caption))];
    [aCoder encodeObject:self.comments forKey:NSStringFromSelector(@selector(comments))];
    [aCoder encodeInteger:self.likeState forKey:NSStringFromSelector(@selector(likeState))];
    [aCoder encodeInteger:self.numberOfLikes forKey:NSStringFromSelector(@selector(numberOfLikes))];
    
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.user = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(user))];
        self.mediaURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(mediaURL))];
        self.image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
        
        if (self.image)
        {
            self.downloadState = MediaDownloadStateHasImage;
        }
        
        else if (self.mediaURL)
        {
            self.downloadState = MediaDownloadStateNeedsImage;
        }
        
        else
        {
            self.downloadState = MediaDownloadStateNonRecoverableError;
        }
        
        self.caption = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(caption))];
        self.comments = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(comments))];
        self.likeState = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(likeState))];
        self.numberOfLikes = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(numberOfLikes))];
    }
    
    return self;
}

- (NSArray *) mediaPropertiesToShare:(Media *)media
{
    
    if (media)
    {
        NSMutableArray *itemsToAdd = [[NSMutableArray alloc] init];
        
        if (media.caption.length > 0)
        {
            [itemsToAdd addObject:media.caption];
        }
        
        if (media.image)
        {
            [itemsToAdd addObject:media.image];
        }
        
        NSArray *mediaPropertiesArray = [NSArray arrayWithArray:itemsToAdd];
        
        return mediaPropertiesArray;

    }
    
    return nil;
    
}
@end
