//
//  FrameMacro.h
//  xiaofeibao_buyer
//
//  Created by Jin on 15/11/16.
//  Copyright © 2015年 Jin. All rights reserved.
//

#ifndef FrameMacro_h
#define FrameMacro_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static CGFloat kLeftPadding = 8.0;

#define VIEW_WIDTH(w)   w * SCREEN_WIDTH / 640.0
#define VIEW_HEIGHT(h)  h * SCREEN_HEIGHT / 1136.0

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#endif /* FrameMacro_h */
