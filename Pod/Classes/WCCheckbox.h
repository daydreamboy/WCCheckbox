//
//  WCCheckbox.h
//  WCCheckbox
//
//  Created by wesley_chen on 15/1/1.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCCheckboxDelegate;

/*!
 *  用例
 *  @code
 checkbox = [[WCCheckbox alloc] initWithFrame:CGRectMake(20, 30, 100, 60) checkedImageName:@"checked" uncheckedImageName:@"unchecked"];
 [checkbox setTarget:self selector:@selector(checkBoxClicked:)];
 
 // optionals
 checkbox.uncheckedDisabledImageName = @"unchecked_disabled";
 checkbox.checkedDisabledImageName = @"checked_disabled";
 checkbox.checked = YES;
 checkbox.enabled = YES;
 checkbox.textColor = [UIColor blueColor];
 checkbox.textDisabledColor = [UIColor darkGrayColor];
 checkbox.title = @"This is a long long long text";
 checkbox.font = [UIFont systemFontOfSize:17];
 checkbox.multipleLines = YES;
 */
@interface WCCheckbox : UIControl

// * Required properties *
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter=isChecked) BOOL checked;
@property (nonatomic, copy) NSString *checkedImageName;
@property (nonatomic, copy) NSString *uncheckedImageName;

// * Optional properties *
@property (nonatomic, weak) id<WCCheckboxDelegate> delegate;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textDisabledColor;
@property (nonatomic, assign, getter=isMultipleLines) BOOL multipleLines;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, copy) NSString *checkedDisabledImageName;
@property (nonatomic, copy) NSString *uncheckedDisabledImageName;
/*!
 *  Should adjust width according to text length. When multipleLines is YES, it's NO
 *
 *  Default is YES
 */
@property (nonatomic, assign, getter=isAutoWidth) BOOL autoWidth;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame checkedImageName:(NSString *)checkedImageName uncheckedImageName:(NSString *)uncheckedImageName;
- (void)setTarget:(id)sender selector:(SEL)action;

@end

@protocol WCCheckboxDelegate <NSObject>
@optional
- (BOOL)checkboxShouldClicked:(WCCheckbox *)checkbox;
@end




