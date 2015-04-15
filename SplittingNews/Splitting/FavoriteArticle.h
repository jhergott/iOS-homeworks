//
//  FavoriteArticle.h
//  Splitting
//
//  Created by Jake Hergott on 2/18/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteArticle : NSObject <NSCoding>

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *contentSnippet;
@property (strong,nonatomic) NSString *publishedDate;
@property (strong,nonatomic) NSString *link;

@end
