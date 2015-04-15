//
//  FavoriteArticle.m
//  Splitting
//
//  Created by Jake Hergott on 2/18/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import "FavoriteArticle.h"

@implementation FavoriteArticle

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.contentSnippet forKey:@"contentSnippet"];
    [aCoder encodeObject:self.publishedDate forKey:@"publishedDate"];
    [aCoder encodeObject:self.link forKey:@"link"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.contentSnippet = [aDecoder decodeObjectForKey:@"contentSnippet"];
    self.publishedDate = [aDecoder decodeObjectForKey:@"publishedDate"];
    self.link = [aDecoder decodeObjectForKey:@"link"];
    return self;
    
}

@end
