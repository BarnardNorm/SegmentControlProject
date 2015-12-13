//
//  NBMulticolorSegmentControl.m
//  MulticolorSegmentControl
//
//  Created by Norm Barnard on 12/12/15.
//  Copyright © 2015 NormBarnard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NBMulticolorSegmentControl.h"

static void *nbMulticolorSelectKVOContext = &nbMulticolorSelectKVOContext;

@interface NBMulticolorSegmentControl()

@property (strong, nonatomic) NSArray <UILabel *> *segmentLabels;
@property (strong, nonatomic) NSArray <NBMulticolorSegmentItem *> *segmentItems;
@property (assign, nonatomic) NSUInteger highlightedItemIndex;

@end

@implementation NBMulticolorSegmentControl

- (instancetype)initWithSegmentItems:(NSArray <NBMulticolorSegmentItem *> *)segmentItems; {
    self = [super init];
    if (!self) return nil;
    _segmentItems = segmentItems;
    self.opaque = NO;
    NSMutableArray *segmentLabels = [NSMutableArray arrayWithCapacity:segmentItems.count];
    for (NBMulticolorSegmentItem *segmentItem in segmentItems) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = segmentItem.title;
        [segmentLabels addObject:label];
        [self addSubview:label];
    }
    self.segmentLabels = segmentLabels;
    _selectedIndex = NSNotFound;
    _highlightedItemIndex = NSNotFound;
    [self addObserver:self forKeyPath:@"highlightedItemIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nbMulticolorSelectKVOContext];
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"highlightedItemIndex" context:nbMulticolorSelectKVOContext];
}

#pragma mark - public api

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    NSParameterAssert(selectedIndex < self.segmentItems.count);
    self.segmentLabels[selectedIndex].backgroundColor = self.segmentItems[selectedIndex].selectedColor;
}

#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger __block segmentIndex = NSNotFound;
    [self.segmentLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull segmentLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [touch locationInView:segmentLabel];
        *stop = [segmentLabel pointInside:point withEvent:event];
        if (*stop) {
            segmentIndex = idx;
        }
    }];
    if (segmentIndex != self.selectedIndex) {
        self.highlightedItemIndex = segmentIndex;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger __block segmentIndex = NSNotFound;
    [self.segmentLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull segmentLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [touch locationInView:segmentLabel];
        *stop = [segmentLabel pointInside:point withEvent:event];
        if (*stop) {
            segmentIndex = idx;
        }
    }];
    if (segmentIndex != NSNotFound) {
        self.highlightedItemIndex = NSNotFound;
        if (self.selectedIndex != NSNotFound && segmentIndex != self.selectedIndex) {
            self.segmentLabels[self.selectedIndex].backgroundColor = [UIColor clearColor];
        }
        if (self.selectedIndex != segmentIndex) {
            self.selectedIndex = segmentIndex;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.highlightedItemIndex == NSNotFound) return;
    UITouch *touch = [touches anyObject];
    [self.segmentLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull segmentLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [touch locationInView:segmentLabel];
        if ([segmentLabel pointInside:point withEvent:event] && (idx != self.highlightedItemIndex && idx != self.selectedIndex)) {
            self.segmentLabels[self.highlightedItemIndex].backgroundColor = [UIColor clearColor];
            self.highlightedItemIndex = idx;
            *stop = YES;
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context != nbMulticolorSelectKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if ([keyPath isEqualToString:@"highlightedItemIndex"]) {
        NSNumber *prior = change[NSKeyValueChangeOldKey];
        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        if (prior.integerValue != NSNotFound) {
            self.segmentLabels[prior.unsignedIntegerValue].backgroundColor = [UIColor clearColor];
        }
        if (newValue.integerValue != NSNotFound) {
            UIColor *highlightColor = [self.segmentItems[newValue.unsignedIntegerValue].selectedColor colorWithAlphaComponent:0.1f];
            self.segmentLabels[newValue.unsignedIntegerValue].backgroundColor = highlightColor;
        }
    }
}


#pragma mark - subview positioning

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self _adjustLabelPositionsRelativeToRect:newSuperview.bounds];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _adjustLabelPositionsRelativeToRect:self.bounds];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextStrokeRect(ctx, rect);
    CGContextSetLineWidth(ctx, 1.0f);
    [self.segmentLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull segmentLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0 && idx < self.segmentLabels.count) {
            CGContextMoveToPoint(ctx, CGRectGetMinX(segmentLabel.frame), 0.0f);
            CGContextAddLineToPoint(ctx, CGRectGetMinX(segmentLabel.frame), CGRectGetMaxY(segmentLabel.frame));
            CGContextStrokePath(ctx);
        }
    }];
}

- (void)_adjustLabelPositionsRelativeToRect:(CGRect)rect {
    CGFloat segmentWidth = CGRectGetWidth(rect) / self.segmentItems.count;
    CGFloat segmentHeight = CGRectGetHeight(rect);
    CGFloat __block left = 0.0f;
    [self.segmentLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull segmentLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect segmentFrame = CGRectMake(left, 0.0f, segmentWidth, segmentHeight);
        segmentLabel.frame = CGRectInset(segmentFrame, 1, 1);
        left += segmentWidth;
    }];
}


@end
