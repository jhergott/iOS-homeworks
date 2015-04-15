//
//  ViewController.m
//  Tic-Tac-Snow
//
//  Created by Jake Hergott on 2/4/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import "ViewController.h"
#import "XandO.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DrawWinningLine.h"

@interface ViewController ()

- (IBAction)infoButton:(id)sender;
- (IBAction)removeInfoButton:(id)sender;

- (IBAction)newGame:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *gameOverView;
@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIView *square1;
@property (weak, nonatomic) IBOutlet UIView *square2;
@property (weak, nonatomic) IBOutlet UIView *square3;
@property (weak, nonatomic) IBOutlet UIView *square4;
@property (weak, nonatomic) IBOutlet UIView *square5;
@property (weak, nonatomic) IBOutlet UIView *square6;
@property (weak, nonatomic) IBOutlet UIView *square7;
@property (weak, nonatomic) IBOutlet UIView *square8;
@property (weak, nonatomic) IBOutlet UIView *square9;

@property CGPoint sqr1;
@property CGPoint sqr2;
@property CGPoint sqr3;
@property CGPoint sqr4;
@property CGPoint sqr5;
@property CGPoint sqr6;
@property CGPoint sqr7;
@property CGPoint sqr8;
@property CGPoint sqr9;

@property CGPoint startForLine;
@property CGPoint endForLine;

@property XandO *cubImage;
@property CGPoint cubsStart;

@property XandO *soxImage;
@property CGPoint soxStart;

@property bool isCatsGame;
@property bool isWinner;

@property DrawWinningLine *line;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create an array of the 9 views
    self.squares = @[self.square1,self.square2,self.square3,
                     self.square4,self.square5,self.square6,
                     self.square7,self.square8,self.square9];
    
    
    // Initialize and fill squares values with object values of empty
    self.squaresFilled = [[NSMutableArray alloc] init];
    for(int i = 0; i < 9; i++){
        [self.squaresFilled addObject:@"empty"];
    }


    // Add images to the screen to start the game
    [self addCubsImage];
    [self addSoxImage];
    
    // Set center points for cubs and sox icons
    self.cubsStart = [self.cubImage center];
    self.soxStart = [self.soxImage center];
    
    // Start the game with soxImage inactive
    self.soxImage.userInteractionEnabled = NO;
    self.soxImage.alpha = .5;
    
    // Set infoView off screen
    self.infoView.center = CGPointMake(187.5, -100);
    
    // Set gameOverView off screen
    self.gameOverView.center = CGPointMake(187.5, -100);
    
    // Set cats game bool to false and winner bool to false
    self.isCatsGame = false;
    self.isWinner = false;
    
    // Set all the center points of views to draw line
    self.sqr1 = [self.square1 center];
    self.sqr2 = [self.square2 center];
    self.sqr3 = [self.square3 center];
    self.sqr4 = [self.square4 center];
    self.sqr5 = [self.square5 center];
    self.sqr6 = [self.square6 center];
    self.sqr7 = [self.square7 center];
    self.sqr8 = [self.square8 center];
    self.sqr9 = [self.square9 center];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Drag Piece Logic

- (void)dragPiece:(UIPanGestureRecognizer *)panGestureRecognizer{

    UIView *piece = [panGestureRecognizer view];
    [[piece superview] bringSubviewToFront:piece];
    
    // Play sound if image is picked up
    if ([panGestureRecognizer state] == UIGestureRecognizerStateBegan){
        [self playBlipSound];
    }

    if ([panGestureRecognizer state] == UIGestureRecognizerStateBegan || [panGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x,[piece center].y + translation.y)];
        [panGestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
    
    if([panGestureRecognizer state] == UIGestureRecognizerStateEnded){
        
        bool isEmpty = false;
        
        // Check if there are any empty strings
        for(int i = 0; i < [self.squares count]; i++){
            UIView *squareView = [self.squares objectAtIndex:i];
            NSString *isEmptyString = [self.squaresFilled objectAtIndex:i];
            if(CGRectIntersectsRect(squareView.frame, piece.frame) && [isEmptyString isEqualToString:@"empty"]){
                isEmpty = true;
            }
        }
        
        if(isEmpty){
            for(int i = 0; i < [self.squares count]; i++){
                UIView *squareView2 = [self.squares objectAtIndex:i];
                NSString *isEmptyString2 = [self.squaresFilled objectAtIndex:i];
                if(CGRectIntersectsRect(squareView2.frame, piece.frame) && [isEmptyString2 isEqualToString:@"empty"]){
                    [piece setCenter:[squareView2 center]];
                    
                    if(self.soxImage.userInteractionEnabled){
                        
                        // Set the square equal to sox and make sure it is not enables
                        [self.squaresFilled replaceObjectAtIndex:i withObject:@"Sox"];
                        self.soxImage.userInteractionEnabled = NO;
                        
                        // Add a new sox image after dropping the sox image
                        [self addSoxImage];
                        self.soxImage.userInteractionEnabled = NO;
                        self.soxImage.alpha = .5;
                        
                    }else{
                        
                        // Cubs just went
                        self.soxImage.userInteractionEnabled = YES;
                        self.soxImage.alpha = 1;
                        
                        // Animate symbol by a factor of 2 when it is their turn
                        // Used stackoverflow for help with this
                        [UIView animateWithDuration:0.5 animations:^{
                            self.soxImage.transform = CGAffineTransformMakeScale(2, 2);
                        }
                                         completion:^(BOOL finished){
                                             [UIView animateWithDuration:0.5 animations:^{
                                                 self.soxImage.transform = CGAffineTransformMakeScale(1, 1);
                                             }];
                                         }];
                        
                    }
                    
                    if(self.cubImage.userInteractionEnabled){
                        
                        // Set the square equal to cubs and make sure it is not enables
                        [self.squaresFilled replaceObjectAtIndex:i withObject:@"Cubs"];
                        self.cubImage.userInteractionEnabled = NO;
                        
                        // Add a new cub image after dropping the cub image
                        [self addCubsImage];
                        self.cubImage.userInteractionEnabled = NO;
                        self.cubImage.alpha = .5;
                        
                    }else{
                        
                        // Sox just went
                        self.cubImage.userInteractionEnabled = YES;
                        self.cubImage.alpha = 1;
                        
                        // Animate symbol by a factor of 2 when it is their turn
                        // Used stackoverflow for help with this
                        [UIView animateWithDuration:0.5 animations:^{
                            self.cubImage.transform = CGAffineTransformMakeScale(2, 2);
                        }
                                         completion:^(BOOL finished){
                                             [UIView animateWithDuration:0.5 animations:^{
                                                 self.cubImage.transform = CGAffineTransformMakeScale(1, 1);
                                             }];
                                         }];
                    }
                    
                    [self playChimeSound];
                    
                    // Check the status of the game.  If it's been won or cats game
                    [self checkGameStatus];
                    
                }
            }
        }else{
            if(self.soxImage.userInteractionEnabled){
                //[piece setCenter:self.soxStart];
                [UIView animateWithDuration:1 animations:^{
                    [piece setCenter:self.soxStart];
                }
                                 completion:^(BOOL finished){
                                 }];
                
            }else{
                //[piece setCenter:self.cubsStart];
                [UIView animateWithDuration:1 animations:^{
                    [piece setCenter:self.cubsStart];
                }
                                 completion:^(BOOL finished){
                                 }];
            }
            
            [self playBoingSound];
        }
    }
}

#pragma mark - Check Game Status

- (void)checkGameStatus{
    
    NSString *cell1 = [self.squaresFilled objectAtIndex:0];
    NSString *cell2 = [self.squaresFilled objectAtIndex:1];
    NSString *cell3 = [self.squaresFilled objectAtIndex:2];
    NSString *cell4 = [self.squaresFilled objectAtIndex:3];
    NSString *cell5 = [self.squaresFilled objectAtIndex:4];
    NSString *cell6 = [self.squaresFilled objectAtIndex:5];
    NSString *cell7 = [self.squaresFilled objectAtIndex:6];
    NSString *cell8 = [self.squaresFilled objectAtIndex:7];
    NSString *cell9 = [self.squaresFilled objectAtIndex:8];
    
    //  Check if any one has won
    if([cell1 isEqualToString:cell2] && [cell2 isEqualToString:cell3] && ![cell1 isEqualToString:@"empty"]){
        self.startForLine = self.sqr1;
        self.endForLine = self.sqr3;
        [self drawWinningLine];
        [self gameOver:cell1];
        self.isWinner = true;
    }
    
    if([cell4 isEqualToString:cell5] && [cell5 isEqualToString:cell6] && ![cell4 isEqualToString:@"empty"]){
        self.startForLine = self.sqr4;
        self.endForLine = self.sqr6;
        [self drawWinningLine];
        [self gameOver:cell4];
        self.isWinner = true;
    }
    
    if([cell7 isEqualToString:cell8] && [cell8 isEqualToString:cell9] && ![cell7 isEqualToString:@"empty"]){
        self.startForLine = self.sqr7;
        self.endForLine = self.sqr9;
        [self drawWinningLine];
        [self gameOver:cell7];
        self.isWinner = true;
    }
    
    if([cell1 isEqualToString:cell4] && [cell4 isEqualToString:cell7] && ![cell1 isEqualToString:@"empty"]){
        self.startForLine = self.sqr1;
        self.endForLine = self.sqr7;
        [self drawWinningLine];
        [self gameOver:cell1];
        self.isWinner = true;
    }
    
    if([cell2 isEqualToString:cell5] && [cell5 isEqualToString:cell8] && ![cell2 isEqualToString:@"empty"]){
        self.startForLine = self.sqr2;
        self.endForLine = self.sqr8;
        [self drawWinningLine];
        [self gameOver:cell2];
        self.isWinner = true;
    }
    
    if([cell3 isEqualToString:cell6] && [cell6 isEqualToString:cell9] && ![cell3 isEqualToString:@"empty"]){
        self.startForLine = self.sqr3;
        self.endForLine = self.sqr9;
        [self drawWinningLine];
        [self gameOver:cell3];
        self.isWinner = true;
    }
    
    if([cell1 isEqualToString:cell5] && [cell5 isEqualToString:cell9] && ![cell1 isEqualToString:@"empty"]){
        self.startForLine = self.sqr1;
        self.endForLine = self.sqr9;
        [self drawWinningLine];
        [self gameOver:cell1];
        self.isWinner = true;
    }
    
    if([cell3 isEqualToString:cell5] && [cell5 isEqualToString:cell7] && ![cell3 isEqualToString:@"empty"]){
        self.startForLine = self.sqr3;
        self.endForLine = self.sqr7;
        [self drawWinningLine];
        [self gameOver:cell3];
        self.isWinner = true;
    }
    
    // If no one has won check if it was a cats game
    if(!self.isWinner){
        [self checkCatsGame];
    }
    
}

- (void)checkCatsGame{
    // Keeps count of the number of empty squares
    int emptyCount = 0;
    
    for(NSString *squareState in self.squaresFilled){
        if([squareState isEqualToString:@"empty"]){
            emptyCount++;
        }
    }
    
    // If there are no empty squares and game hasn't already ended then its a draw
    if(emptyCount == 0){
        self.isCatsGame = true;
        [self gameOver:@"It's a draw..."];
    }
}

- (void)gameOver:(NSString *)winner{
    
    [self.view bringSubviewToFront:self.gameOverView];
    
    if(self.isCatsGame){
        [self playBooSound];
        self.gameOverLabel.text = winner;
        self.gameOverView.center = CGPointMake(187.5, 275);
    }else{
        // Not a cats game
        [self playCherringSound];
        self.gameOverLabel.text = [winner stringByAppendingString:@" win!"];
        self.gameOverView.center = CGPointMake(187.5, 275);
    }
    
}

- (void)drawWinningLine{
    self.line = [[DrawWinningLine alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    self.line.startPoint = self.startForLine;
    self.line.endPoint = self.endForLine;
    self.line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.line];
}

- (IBAction)newGame:(id)sender {
    self.gameOverView.center = CGPointMake(187.5, -100);
    NSArray *allSubviews = [self.view subviews];
    
    // Remove all the views that are image views
    for(UIView *subview in allSubviews){
        if([subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[DrawWinningLine class]]){
            [UIView animateWithDuration:2 animations:^{
                subview.center = CGPointMake(600, 700);
            }
                             completion:^(BOOL finished){
                                 [subview removeFromSuperview];
                             }];
        }
    }
    
    /*
    // Remove the line that was drawn
    [UIView animateWithDuration:2 animations:^{
        self.line.center = CGPointMake(600, 700);
    }
                     completion:^(BOOL finished){
                         [self.line removeFromSuperview];
                }];
     */
    
    [self viewDidLoad];
    
}

#pragma mark - Add Images

- (void)addCubsImage{
    
    self.cubImage = [[XandO alloc] initWithFrame:CGRectMake(36, 530, 101, 101)];
    self.cubImage.image = [UIImage imageNamed:@"cubs"];
    [self.view addSubview:self.cubImage];
    [self addGesture:self.cubImage];
}

- (void)addSoxImage{
    
    self.soxImage = [[XandO alloc] initWithFrame:CGRectMake(238, 530, 101, 101)];
    self.soxImage.image = [UIImage imageNamed:@"sox"];
    [self.view addSubview:self.soxImage];
    [self addGesture:self.soxImage];
}

#pragma mark - Gestures

- (void)addGesture:(UIView *)piece{
    
    UIPanGestureRecognizer *dragXO = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPiece:)];
    [dragXO setMaximumNumberOfTouches:2];
    [dragXO setDelegate:self];
    piece.userInteractionEnabled = YES;
    [piece addGestureRecognizer:dragXO];
    
}

- (IBAction)panGesture:(id)sender {
    //NSLog(@"dragging worked");
}

#pragma mark - Sounds

- (void)playBooSound{
    NSString *booPath = [[NSBundle mainBundle] pathForResource:@"boo" ofType:@"wav"];
    NSURL *booURL = [NSURL fileURLWithPath:booPath];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) booURL, &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL,MyAudioServicesSystemSoundCompletionProc, NULL);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playCherringSound{
    NSString *cheeringPath = [[NSBundle mainBundle] pathForResource:@"cheering" ofType:@"wav"];
    NSURL *cheeringURL = [NSURL fileURLWithPath:cheeringPath];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) cheeringURL, &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL,MyAudioServicesSystemSoundCompletionProc, NULL);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playChimeSound{
    NSString *chimePath = [[NSBundle mainBundle] pathForResource:@"chime" ofType:@"wav"];
    NSURL *chimeURL = [NSURL fileURLWithPath:chimePath];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) chimeURL, &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL,MyAudioServicesSystemSoundCompletionProc, NULL);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playBlipSound{
    NSString *blipPath = [[NSBundle mainBundle] pathForResource:@"blip" ofType:@"wav"];
    NSURL *blipURL = [NSURL fileURLWithPath:blipPath];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) blipURL, &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL,MyAudioServicesSystemSoundCompletionProc, NULL);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playBoingSound{
    NSString *boingPath = [[NSBundle mainBundle] pathForResource:@"boing" ofType:@"wav"];
    NSURL *boingURL = [NSURL fileURLWithPath:boingPath];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) boingURL, &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL,MyAudioServicesSystemSoundCompletionProc, NULL);
    AudioServicesPlaySystemSound(soundID);
}

// Callback to handle memory
void MyAudioServicesSystemSoundCompletionProc(SystemSoundID ssID,  void *clientData)
{
    AudioServicesDisposeSystemSoundID(ssID);
}


#pragma mark - Info Button

- (IBAction)infoButton:(id)sender {
    // Animate info page on screen
    [self.view bringSubviewToFront:self.infoView];
    [UIView animateWithDuration:2 animations:^{
        self.infoView.center = CGPointMake(187.5, 300);
    }
                     completion:^(BOOL finished){
                     }];
}

- (IBAction)removeInfoButton:(id)sender {
    // Animate info page off screen and then send it back to its original spot to be spawned again from the top
    [UIView animateWithDuration:2 animations:^{
        self.infoView.center = CGPointMake(187.5, 1000);
    }
                     completion:^(BOOL finished){
                         self.infoView.center = CGPointMake(187.5, -100);
                     }];
}



@end





