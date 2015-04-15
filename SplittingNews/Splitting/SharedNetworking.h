//
//  SharedNetworking.h
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedNetworking : NSObject

+ (id)sharedSharedNetworking;

- (void)getGoogleRSSForURL:(NSString*)url
                 success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion;

@end
