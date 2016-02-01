//
//  WCCheckbox.m
//  WCCheckbox
//
//  Created by wesley_chen on 15/1/1.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "WCCheckbox.h"

#define DEBUG_UI 1

#define kBorder 5
#define kSpacing 5

@interface WCCheckbox ()

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImage *checkedImage;
@property (nonatomic, strong) UIImage *uncheckedImage;
@property (nonatomic, strong) UIImage *checkedDisabledImage;
@property (nonatomic, strong) UIImage *uncheckedDisabledImage;

@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) CGFloat border;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGSize textSize;

@end

@implementation WCCheckbox

@synthesize selected = _selected;
@synthesize enabled = _enabled;

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame checkedImageName:nil uncheckedImageName:nil];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame checkedImageName:(NSString *)checkedImageName uncheckedImageName:(NSString *)uncheckedImageName {
    self = [super initWithFrame:frame];
    if (self) {
        _originFrame = frame;
        [self setCheckedImageName:checkedImageName];
        [self setUncheckedImageName:uncheckedImageName];
        [self prepareForInit];
    }
    return self;
}

- (void)setTarget:(id)sender selector:(SEL)action {
    _target = sender;
    _selector = action;
}

#pragma mark -
- (void)prepareForInit {
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    _textLabel.backgroundColor = [UIColor clearColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _border = kBorder;
    _spacing = kSpacing;
    _autoWidth = YES;
    _textColor = [UIColor blackColor];
    _textDisabledColor = [UIColor lightGrayColor];
    _lineBreakMode = NSLineBreakByWordWrapping;
    _enabled = YES;
#if DEBUG_UI
    self.backgroundColor = [UIColor greenColor];
    _textLabel.backgroundColor = [UIColor redColor];
    _imageView.backgroundColor = [UIColor yellowColor];
#endif
    [self addSubview:_textLabel];
    [self addSubview:_imageView];
    
    [self addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
#if DEBUG_UI
    NSLog(@"layoutsubviews");
#endif
    
    UIImage *image = nil;
    if (!_enabled) {
        image = _selected ? _checkedDisabledImage : _uncheckedDisabledImage;
        if (image) {
            _imageView.image = image;
        }
        else {
            _imageView.alpha = 0.2f;
        }
        _textLabel.textColor = _textDisabledColor;
    }
    else {
        image = _selected ? _checkedImage : _uncheckedImage;
        _imageView.image = image;
        _textLabel.textColor = _textColor;
    }
    
    if (_autoWidth) {
        CGSize textSize;
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
            textSize = [_textLabel.text sizeWithAttributes:@{ NSFontAttributeName : _textLabel.font }];
        }
        else {
            textSize = [_textLabel.text sizeWithFont:_textLabel.font];
        }
        
        CGSize checkboxSize = CGSizeMake(2 * _border + image.size.width + _spacing + textSize.width, (image.size.height > textSize.height ? image.size.height : textSize.height) + 2 * _border);
        
        self.frame = CGRectMake(_originFrame.origin.x, _originFrame.origin.y, checkboxSize.width, checkboxSize.height);
        _imageView.frame = CGRectMake(_border, (self.bounds.size.height - image.size.height) / 2, image.size.width, image.size.height);
        _textLabel.frame = CGRectMake(_border + image.size.width + _spacing, (CGRectGetHeight(self.bounds) - textSize.height) / 2.0, textSize.width, textSize.height);
    }
    else {
        CGFloat expectedWidth = _originFrame.size.width - 2 * _border - image.size.width - _spacing;
        
        CGSize textSize;
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = _lineBreakMode;
            
			textSize = [_textLabel.text boundingRectWithSize:CGSizeMake(expectedWidth, CGFLOAT_MAX)
			                                         options:NSStringDrawingUsesLineFragmentOrigin
			                                      attributes:@{ NSFontAttributeName : _textLabel.font,
			                                                    NSParagraphStyleAttributeName : paragraphStyle, }
			                                         context:nil].size;
        }
        else {
            textSize = [_textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(expectedWidth, CGFLOAT_MAX) lineBreakMode:_lineBreakMode];
        }
        
        CGSize checkboxSize = CGSizeMake(2 * _border + image.size.width + _spacing + textSize.width, (image.size.height > textSize.height ? image.size.height : textSize.height) + 2 * _border);
        self.frame = CGRectMake(_originFrame.origin.x, _originFrame.origin.y, checkboxSize.width, checkboxSize.height);
        
        NSInteger numberOfLines = textSize.height / _textLabel.font.pointSize;
        CGFloat lineHeight = textSize.height / numberOfLines;
        CGFloat offset = lineHeight > image.size.height ? ((lineHeight - image.size.height) / 2.0) : 0;
        
#if DEBUG_UI
        NSLog(@"numberOfLines: %ld", (long)numberOfLines);
        NSLog(@"offset: %f", offset);
#endif
        _imageView.frame = CGRectMake(_border, _border + offset, image.size.width, image.size.height);
        _textLabel.frame = CGRectMake(_border + image.size.width + _spacing, (CGRectGetHeight(self.bounds) - textSize.height) / 2.0, textSize.width, textSize.height);
    }
}

- (void)checkboxClicked:(id)sender {
    // Ask delegate should toggle checkbox
    if (_delegate && [_delegate respondsToSelector:@selector(checkboxShouldClicked:)]) {
        if ([_delegate checkboxShouldClicked:self] == NO) {
            return;
        }
    }
    _selected = !_selected;
    _imageView.image = _selected ? _checkedImage : _uncheckedImage;
    
    if (_target != nil && _selector != nil) {
        // Same as [_target performSelector:_selector] but no warning
        ((void (*)(id, SEL, id))[_target methodForSelector:_selector])(_target, _selector, self);
    }
    else {
        NSString *message = nil;
        message = _target == nil ? @"target is nil" : ((_selector == nil) ? @"selector is nil" : @"shoud never show");
        NSLog(@"Warning: %@", message);
    }
}

#pragma mark - Setters and Getters
- (void)setTitle:(NSString *)title {
    _textLabel.text = title;
}

- (void)setFont:(UIFont *)font {
    _textLabel.font = font;
}

- (void)setMultipleLines:(BOOL)multipleLines {
    _multipleLines = multipleLines;
    _autoWidth = NO;
    _textLabel.numberOfLines = 0;
}

- (void)setCheckedImageName:(NSString *)checkedImageName {
    if (![checkedImageName isEqualToString:_checkedImageName]) {
        _checkedImageName = checkedImageName;
        _checkedImage = [UIImage imageNamed:checkedImageName];
    }
}

- (void)setUncheckedImageName:(NSString *)uncheckedImageName {
    if (![uncheckedImageName isEqualToString:_uncheckedImageName]) {
        _uncheckedImageName = uncheckedImageName;
        _uncheckedImage = [UIImage imageNamed:uncheckedImageName];
    }
}

- (void)setCheckedDisabledImageName:(NSString *)checkedDisabledImageName {
    if (![checkedDisabledImageName isEqualToString:_checkedDisabledImageName]) {
        _checkedDisabledImageName = checkedDisabledImageName;
        _checkedDisabledImage = [UIImage imageNamed:checkedDisabledImageName];
    }
}

- (void)setUncheckedDisabledImageName:(NSString *)uncheckedDisabledImageName {
    if (![uncheckedDisabledImageName isEqualToString:_uncheckedDisabledImageName]) {
        _uncheckedDisabledImageName = uncheckedDisabledImageName;
        _uncheckedDisabledImage = [UIImage imageNamed:uncheckedDisabledImageName];
    }
}

- (void)setChecked:(BOOL)checked {
    _selected = checked;
    [self setNeedsLayout];
}

- (BOOL)isChecked {
    return _selected;
}

@end
