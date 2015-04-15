//
//  SharedNetworking.m
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import "SharedNetworking.h"

@implementation SharedNetworking

#pragma mark - Initialization

+ (id)sharedSharedNetworking
{
    static dispatch_once_t pred;
    static SharedNetworking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if ( self = [super init] ) {
        
    }
    return self;
}

#pragma - Requests

- (void)getGoogleRSSForURL:(NSString*)url
                 success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion
{
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     
                                     
                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                     if (httpResp.statusCode == 200) {
                                         NSError *jsonError;
                                         
                                         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

                                         successCompletion(dictionary,nil);
                                     } else {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (failureCompletion) failureCompletion();
                                             
                                             // If there is no network connection use a UIAlertView to notify the user
                                             UIAlertView *errorAlert =[[UIAlertView alloc ] initWithTitle:@"Network"
                                                                                                  message:@"There is no network connection available"
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:@"Ok"
                                                                                        otherButtonTitles: nil];
                                             [errorAlert show];
                                             
                                         });
                                     }
                                 }] resume];
}

@end
