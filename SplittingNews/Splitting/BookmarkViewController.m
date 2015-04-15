//
//  BookmarkViewController.m
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import "BookmarkViewController.h"

@interface BookmarkViewController ()

@property NSUserDefaults *defaults;
@property NSArray *userFavoriteLinks;
@property NSMutableArray *mutableFavoriteLinks;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)toggleEditMode:(id)sender;

@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.editButton setTitle:@"Edit"];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.userFavoriteLinks = [self.defaults arrayForKey:@"favoriteLinks"];
    self.mutableFavoriteLinks = [[NSMutableArray alloc] initWithArray:self.userFavoriteLinks];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mutableFavoriteLinks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoriteCell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = [self.mutableFavoriteLinks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dictionary objectForKey:@"title"];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Remove favorite article from user defaults
        [self.mutableFavoriteLinks removeObjectAtIndex:indexPath.row];
        [self.defaults setValue:self.mutableFavoriteLinks forKey:@"favoriteLinks"];
        [self.defaults synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Send the selected row's link to the web view and dismiss the pop up view controller
    NSDictionary *link = [self.mutableFavoriteLinks objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[link objectForKey:@"link"]];
    NSString *title = [link objectForKey:@"title"];
    [self.delegate2 bookmark:self sendsURL:url sendsTitle:title];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Edit Button

// Toggle the state of the table view and edit button
- (IBAction)toggleEditMode:(id)sender {
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit"];
    }else {
        [self.tableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done"];
    }
}


@end
