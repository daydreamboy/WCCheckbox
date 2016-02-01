//
//  WCViewController.m
//  WCCheckbox
//
//  Created by wesley_chen on 01/28/2016.
//  Copyright (c) 2016 wesley_chen. All rights reserved.
//

#import "ViewController.h"
#import <WCCheckbox/WCCheckbox.h>

@interface ViewController ()
@property (nonatomic, strong) WCCheckbox *checkbox1;
@property (nonatomic, strong) WCCheckbox *checkbox2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat spacingV = 30;

    self.view.backgroundColor = [UIColor whiteColor];

    WCCheckbox *checkbox = nil;

    // Example 1
    _checkbox1 = [[WCCheckbox alloc] initWithFrame:CGRectMake(20, 30, 120, 60)];
    _checkbox1.checkedImageName = @"checked";
    _checkbox1.uncheckedImageName = @"unchecked";
    [self.view addSubview:_checkbox1];

    // Example 2
    checkbox = [[WCCheckbox alloc] initWithFrame:CGRectMake(20, 30 + spacingV, 100, 60) checkedImageName:@"checked" uncheckedImageName:@"unchecked"];
    [checkbox setTarget:self selector:@selector(checkboxClicked:)];

    // optionals
    checkbox.uncheckedDisabledImageName = @"unchecked_disabled";
    checkbox.checkedDisabledImageName = @"checked_disabled";
    checkbox.checked = YES;
    checkbox.enabled = NO;
    checkbox.textColor = [UIColor blueColor];
    checkbox.textDisabledColor = [UIColor darkGrayColor];
    checkbox.title = @"This is a long long long text";
    checkbox.font = [UIFont systemFontOfSize:17];
    //    checkbox.multipleLines = YES;

    [self.view addSubview:checkbox];
}

- (void)checkboxClicked:(id)sender {
    //NSLog(@"%@, %@", self, NSStringFromSelector(_cmd));
    WCCheckbox *checkbox = sender;

    if (checkbox.isChecked) {
        NSLog(@"checked");
    }
    else {
        NSLog(@"unchecked");
    }
}

@end
