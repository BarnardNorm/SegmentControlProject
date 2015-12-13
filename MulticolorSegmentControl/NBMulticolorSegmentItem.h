//
//  NBMulticolorSegmentItem.h
//  MulticolorSegmentControl
//
//  Created by Norm Barnard on 12/12/15.
//  Copyright © 2015 NormBarnard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBMulticolorSegmentItem : NSObject

@property (copy, nonatomic,readonly) NSString *title;
@property (strong, nonatomic, readonly) UIColor *selectedColor;

- (instancetype)initWithTitle:(NSString *)title selectedColor:(UIColor *)selectedColor;

+ (instancetype)itemWithTitle:(NSString *)title selectedColor:(UIColor *)selectedColor;

@end