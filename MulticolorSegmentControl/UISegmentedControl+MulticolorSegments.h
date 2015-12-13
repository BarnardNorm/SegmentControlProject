//
//  UISegmentedControl+MulticolorSegments.h
//  MulticolorSegmentControl
//
//  Created by Norm Barnard on 12/12/15.
//  Copyright © 2015 NormBarnard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (MulticolorSegments)

- (void)nb_configureSegmentsWithSelectedColors:(NSArray <UIColor *> *)selectedColors unselectedColor:(UIColor *)unselectedColor;

@end
