//
//  MySearchBar.m
//  xiaofeibao
//
//  Created by Xiao_huanG on 15/8/30.
//  Copyright (c) 2015年 Xiao_huanG. All rights reserved.
//

#import "MySearchBar.h"
#import "ColorMacro.h"
#import "FrameMacro.h"

@implementation MySearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSubViews];
    }
    return self;
}

- (void)layoutSubViews {
    
    [super layoutSubviews];
    
    UITextField *searchField;
    for (UIView *subview in self.subviews) {
        for (UIView *view in subview.subviews) {
            
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                searchField = (UITextField *)view;
                searchField.borderStyle = UITextBorderStyleRoundedRect;
                
                UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mirror"]];
                imgView.backgroundColor = [UIColor clearColor];
                imgView.frame = CGRectMake(0, 0, 15, 15);
                
                searchField.layer.cornerRadius = 4;
                searchField.leftViewMode = UITextFieldViewModeAlways;
                searchField.leftView = imgView;
                searchField.textColor = COLOR_VALUE(149, 149, 149, 1);
                //searchField.backgroundColor = COLOR_VALUE(238, 238, 238, 1);
                searchField.backgroundColor = [UIColor whiteColor];
                searchField.textAlignment = NSTextAlignmentLeft;
                break;
            }
            else if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                
                [view removeFromSuperview];
            }
        }
    }
}

@end
