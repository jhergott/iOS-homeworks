//
//  DrawWinningLine.m
//  Tic-Tac-Snow
//
//  Created by Jake Hergott on 2/4/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import "DrawWinningLine.h"

@implementation DrawWinningLine


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor blackColor] set];
    CGContextRef currentContext =UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext,10.0f);
    CGContextMoveToPoint(currentContext,self.startPoint.x, self.startPoint.y);
    CGContextAddLineToPoint(currentContext,self.endPoint.x, self.endPoint.y);
    CGContextStrokePath(currentContext);
}


@end
