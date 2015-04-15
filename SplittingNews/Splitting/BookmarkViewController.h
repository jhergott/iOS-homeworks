//
//  BookmarkViewController.h
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookmarkToWebViewDelegate <NSObject>

- (void)bookmark:(id)sender sendsURL:(NSURL*)url sendsTitle:(NSString*)title;

@end

@interface BookmarkViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) id<BookmarkToWebViewDelegate> delegate2;

@end
