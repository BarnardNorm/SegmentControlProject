//
//  ViewController.m
//  MulticolorSegmentControl
//
//  Created by Norm Barnard on 12/12/15.
//  Copyright © 2015 NormBarnard. All rights reserved.
//

#import "NBMulticolorSegmentControl.h"
#import "RootViewController.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) NBMulticolorSegmentControl *multicolorControl;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = @"The Root View";
    
    NSArray <NBMulticolorSegmentItem *> *items = \
        @[
          [NBMulticolorSegmentItem itemWithTitle:@"Good" selectedColor:[UIColor greenColor]],
          [NBMulticolorSegmentItem itemWithTitle:@"Worn" selectedColor:[UIColor yellowColor]],
          [NBMulticolorSegmentItem itemWithTitle:@"Cracked" selectedColor:[UIColor orangeColor]],
          [NBMulticolorSegmentItem itemWithTitle:@"Replace" selectedColor:[UIColor redColor]]
    ];
    
    NBMulticolorSegmentControl *colorSegmentControl = [[NBMulticolorSegmentControl alloc] initWithSegmentItems:items];
    
    [self.view addSubview:colorSegmentControl];
    self.multicolorControl = colorSegmentControl;
    [self.multicolorControl addTarget:self action:@selector(multiSelectValueChanged:) forControlEvents:UIControlEventValueChanged];

}

- (NSString *)nibName {
    return @"RootView";
}


- (void)viewDidLayoutSubviews {
    self.multicolorControl.frame = CGRectMake(20.0f, CGRectGetHeight(self.view.bounds) - 64.0f, CGRectGetWidth(self.view.bounds) - 40.0f, 32.0f);
}

- (void)multiSelectValueChanged:(NBMulticolorSegmentControl *)segmentControl {
    NSLog(@"selected index %@", @(segmentControl.selectedIndex));
}



@end
