//
//  AppDelegate.m
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@property UIView *splashScreen;
@property UISplitViewController *splitViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.splitViewController.delegate = self;
    
    [self setPreferenceDefaults];
    
    // Customize navigation bar
    [[UINavigationBar appearance] setBackgroundColor:[UIColor blueColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor purpleColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Arial Rounded MT Bold" size:16.0f]
                                                            }];
    
    // Customize tool bars
    [[UIToolbar appearance] setTintColor:[UIColor orangeColor]];
    [[UIToolbar appearance] setBackgroundColor:[UIColor blackColor]];
    
    // Show splash screen
    self.splashScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.splitViewController.view.frame.size.width, self.splitViewController.view.frame.size.height)];
    self.splashScreen.backgroundColor = [UIColor purpleColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.splitViewController.view.center.y, self.splitViewController.view.frame.size.width, 21)];
    label.text = @"This is my splash screen...";
    label.textColor = [UIColor whiteColor];
    [self.splashScreen addSubview:label];
    [self.splitViewController.view addSubview:self.splashScreen];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Set Preference Defaults

- (void)setPreferenceDefaults{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"night_reading_preference"]){
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSDate date]
                                                                forKey:@"Initial Run"];
        [defaults registerDefaults:appDefaults];
        NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults]
                                      dictionaryRepresentation]);
    }else{
        NSLog(@"not set...");
    }
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

// Hide splash screen once the data is loaded
-(void)dataDidLoad{
    if(self.splashScreen != nil){
        NSLog(@"splash screen is gone");
        [UIView animateWithDuration:2 animations:^{
            self.splashScreen.alpha = 0;
        } completion:^(BOOL finished) {
            // remove splash screen
            [self.splashScreen removeFromSuperview];
            
            // Show master view controller if it is an ipad. Otherwise shows automatically
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                NSLog(@"using ipad");
                self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
            }
            
        }];
        
    }
}

@end
