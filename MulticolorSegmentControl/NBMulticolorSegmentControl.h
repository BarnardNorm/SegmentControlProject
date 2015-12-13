//
//  NBMulticolorSegmentControl.h
//  MulticolorSegmentControl
//
//  Created by Norm Barnard on 12/12/15.
//  Copyright © 2015 NormBarnard. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NBMulticolorSegmentItem.h"

@interface NBMulticolorSegmentControl : UIControl

@property (assign, nonatomic) NSUInteger selectedIndex;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *foregroundColor;

- (instancetype)initWithSegmentItems:(NSArray <NBMulticolorSegmentItem *> *)segmentItems;

@end
