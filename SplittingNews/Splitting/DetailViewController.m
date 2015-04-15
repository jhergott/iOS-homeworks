//
//  DetailViewController.m
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import "DetailViewController.h"
#import "FavoriteArticle.h"
#import <Social/Social.h>

@interface DetailViewController ()

@property NSUserDefaults *defaults;

@property (weak, nonatomic) IBOutlet UIImageView *starImage;

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property UIActivityIndicatorView  *indicator;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)favoriteThisArticle:(id)sender;
- (IBAction)tweetArticle:(id)sender;

@property NSString *tweetTitle;


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the detail view by loading the web view
    if (self.detailItem) {
        NSURL *url = [NSURL URLWithString:[self.detailItem objectForKey:@"link"]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
        
        self.tweetTitle = [self.detailItem objectForKey:@"title"];
        [self setTitle:[self.detailItem objectForKey:@"title"]];
        
        [self.defaults setObject:self.detailItem forKey:@"lastViewed"];
        [self.defaults synchronize];
    }else{
        // Use last view is NSUserDefaults to load the web page
        NSDictionary *link = [self.defaults objectForKey:@"lastViewed"];
        NSURL *url = [NSURL URLWithString:[link objectForKey:@"link"]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
        
        self.tweetTitle = [link objectForKey:@"title"];
        [self setTitle:[link objectForKey:@"title"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.defaults = [NSUserDefaults standardUserDefaults];
    self.webView.delegate = self;
    
    // Hide star.  Only show if the article is a favorite
    [self.starImage setHidden:YES];
    
    // Add indicator to loading view
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = self.view.center;
    [self.loadingView addSubview:self.indicator];
    [self.indicator startAnimating];
    
    // Default titles
    self.tweetTitle = @"This is a great app! (click an article before trying to tweet)";
    [self setTitle:@""];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Favorite Article

- (IBAction)favoriteThisArticle:(id)sender {
    
    NSMutableArray *favoriteLinks = [[NSMutableArray alloc] init];
    
    [self.starImage setHidden:NO];
    
    // Check if a webpage has been loaded
    if(self.detailItem){
        
        // Check if the user already has favorites
        if(![self.defaults arrayForKey:@"favoriteLinks"]){
            
            // No previous favorites in NSUserDefaults
            [favoriteLinks addObject:self.detailItem];
            [self.defaults setValue:favoriteLinks forKey:@"favoriteLinks"];
            [self.defaults synchronize];
            
        }else{
            
            // Does have previous favorites in NSUserDefaults
            NSArray *userFavoriteLinks = [self.defaults arrayForKey:@"favoriteLinks"];
            
            for(id link in userFavoriteLinks){
                [favoriteLinks addObject:link];
            }
            
            [favoriteLinks addObject:self.detailItem];
            [self.defaults setValue:favoriteLinks forKey:@"favoriteLinks"];
            [self.defaults synchronize];
        }
    }
    
    
    // Create an array of Favorite Articles to hold FavoriteArticle NSCoding objects
    NSMutableArray *favArticlesNSCoder = [[NSMutableArray alloc] init];
    
    NSArray *favLinks = [self.defaults arrayForKey:@"favoriteLinks"];
    
    for(id link in favLinks){
        FavoriteArticle *favoriteArticle = [[FavoriteArticle alloc] init];
        favoriteArticle.title = [link objectForKey:@"title"];
        favoriteArticle.contentSnippet = [link objectForKey:@"contentSnippet"];
        favoriteArticle.publishedDate = [link objectForKey:@"publishedDate"];
        favoriteArticle.link = [link objectForKey:@"link"];
        
        [favArticlesNSCoder addObject:favoriteArticle];
    }
    
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask
                                     appropriateForURL:nil
                                                create:YES
                                                 error:&err];
    
    NSData* sessionData = [NSKeyedArchiver archivedDataWithRootObject:favArticlesNSCoder];
    NSURL* file = [docs URLByAppendingPathComponent:@"sessions.plist"];
    [sessionData writeToURL:file atomically:NO];
    NSLog(@"DOCS:%@",file);

    /*
    // Clear user defaults
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    */
}

#pragma mark - Tweet Article

- (IBAction)tweetArticle:(id)sender {
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:self.tweetTitle];
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Prepare segue for popover table view
    if([[segue identifier] isEqualToString:@"popover"]){
        BookmarkViewController *bvc = (BookmarkViewController *)segue.destinationViewController;
        UIPopoverPresentationController *controller = bvc.popoverPresentationController;
        bvc.delegate2 = self;
        controller.delegate = self;

    }
}

#pragma mark - Bookmark Delegate Method

-(void)bookmark:(id)sender sendsURL:(NSURL *)url sendsTitle:(NSString *)title{
    // Load webview with url from favorites
    self.tweetTitle = title;
    [self setTitle:title];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.starImage setHidden:NO];
}

#pragma mark - Web View Delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if(self.loadingView){
        [self.indicator stopAnimating];
        [self.loadingView removeFromSuperview];
    }
}

#pragma mark - iPhone Popover

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}


@end











