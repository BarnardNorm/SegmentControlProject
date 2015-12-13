//
//  UISegmentedControl+MulticolorSegments.m
//  MulticolorSegmentControl
//
//  Created by Norm Barnard on 12/12/15.
//  Copyright © 2015 NormBarnard. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "UISegmentedControl+MulticolorSegments.h"

@implementation UISegmentedControl (MulticolorSegments)


- (void)nb_configureSegmentsWithSelectedColors:(NSArray <UIColor *> *)selectedColors unselectedColor:(UIColor *)unselectedColor; {

    if (CGRectGetHeight(self.bounds) <= 0.0f) {
        NSLog(@"Height is Zero!");
        return;
    }
    
    CGSize segmentSize = CGSizeMake(100.0f, CGRectGetHeight(self.bounds));
    
    for (NSInteger segIndex = 0; segIndex < self.numberOfSegments; segIndex++) {
        UIGraphicsBeginImageContext(segmentSize);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIColor *selectedColor = selectedColors[segIndex];
        CGContextSetFillColorWithColor(ctx, selectedColor.CGColor);
        CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, segmentSize.width, segmentSize.height));
        CGContextSaveGState(ctx);
        UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
}


@end
