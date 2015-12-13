//
//  NBMulticolorSegmentItem.m
//  MulticolorSegmentControl
//
//  Created by Norm Barnard on 12/12/15.
//  Copyright © 2015 NormBarnard. All rights reserved.
//

#import "NBMulticolorSegmentItem.h"

@interface NBMulticolorSegmentItem()

@property (copy, nonatomic,readwrite) NSString *title;
@property (strong, nonatomic, readwrite) UIColor *selectedColor;

@end

@implementation NBMulticolorSegmentItem


- (instancetype)initWithTitle:(NSString *)title selectedColor:(UIColor *)selectedColor; {
    self = [super init];
    if (!self) return nil;
    _title = title;
    _selectedColor = selectedColor;
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title selectedColor:(UIColor *)selectedColor; {
    return [[NBMulticolorSegmentItem alloc] initWithTitle:title selectedColor:selectedColor];
}

@end
