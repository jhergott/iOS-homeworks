//
//  MasterViewController.m
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MasterTableViewCell.h"
#import "SharedNetworking.h"
#import "AppDelegate.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Set up the refresh controls
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventAllEvents];
    self.refreshControl = refresh;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 190;
    
    // Listen for changes to dynamic types to update system fonts
    [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note){
                                                      NSLog(@"content changed");
                                                      [self.tableView reloadData];
                                                  }];
    
    // Listen to changes for nsuserdefaultchanges to reload night mode
    [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note){
                                                      NSLog(@"changed night mode bit");
                                                      [self.tableView reloadData];
                                                  }];

    // Start networkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Call singleton function
    [[SharedNetworking sharedSharedNetworking] getGoogleRSSForURL:@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss"
                                                          success:^(NSDictionary *dictionary, NSError *error){
                                                              
                                                              if(!error){
                                                                  // Initialize dataSource
                                                                  self.dataSource = dictionary[@"responseData"][@"feed"][@"entries"];
                                                                  
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      // Reload data in table view
                                                                      NSLog(@"made it to here..");
                                                                      [self.tableView reloadData];
                                                                      [(AppDelegate*)[[UIApplication sharedApplication] delegate] dataDidLoad];
                                                                  });
                                                              }else{
                                                                  NSLog(@"there was an error...");
                                                              }
                                                              // Stop networkActivityIndicator
                                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                          }
                                                          failure:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                 // Alertview is called in SharedNetworking class
                                                              });
                                                              // Stop networkActivityIndicator
                                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                          }];
     
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Refresh Table

- (void)refreshTable{
    // Start networkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Call singleton function
    [[SharedNetworking sharedSharedNetworking] getGoogleRSSForURL:@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss"
                                                          success:^(NSDictionary *dictionary, NSError *error){
                                                              
                                                              if(!error){
                                                                  // Initialize dataSource
                                                                  self.dataSource = dictionary[@"responseData"][@"feed"][@"entries"];
                                                                  
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      // Reload data in table view
                                                                      [self.tableView reloadData];
                                                                      [(AppDelegate*)[[UIApplication sharedApplication] delegate] dataDidLoad];
                                                                  });
                                                              }else{
                                                                  NSLog(@"there was an error...");
                                                              }
                                                              // Stop networkActivityIndicator
                                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                          }
                                                          failure:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  // Alertview is called in SharedNetworking class
                                                              });
                                                              // Stop networkActivityIndicator
                                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                          }];
    
    // End refreshing if it is refreshing
    if(self.refreshControl.refreshing){
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Prepare for segue to the detail view controller
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *dictionary = [self.dataSource objectAtIndex:indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:dictionary];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterTableViewCell *cell = (MasterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *dictionary = [self.dataSource objectAtIndex:indexPath.row];
    
    UILabel *aTitle = (UILabel*)[cell viewWithTag:101];
    UILabel *aSnippet = (UILabel*)[cell viewWithTag:102];
    UILabel *aDate = (UILabel*)[cell viewWithTag:103];
    
    aTitle.text = [dictionary objectForKey:@"title"];
    aTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    aSnippet.text = [dictionary objectForKey:@"contentSnippet"];
    aSnippet.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    // Parse date published to only return day, month and year
    NSString *publishedDate = [dictionary objectForKey:@"publishedDate"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    NSDate *dateNS = [dateFormatter dateFromString:publishedDate];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterNoStyle];
    aDate.text = [dateFormatter2 stringFromDate:dateNS];
    aDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    // Check if night mode is turned on
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *nightMode = [defaults objectForKey:@"night_reading_preference"];
    if([nightMode  isEqual: @1]){
        NSLog(@"%@",nightMode);
        cell.backgroundColor = [UIColor blackColor];
        cell.articleTitle.textColor = [UIColor whiteColor];
        cell.articleSnippet.textColor = [UIColor whiteColor];
        cell.articleDate.textColor = [UIColor whiteColor];
    }
    
    NSLog(@"relayout cell");
    [cell layoutIfNeeded];
    
    return cell;
}


@end
