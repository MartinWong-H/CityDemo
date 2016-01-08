//
//  ColorMacro.h
//  xiaofeibao_buyer
//
//  Created by Jin on 15/11/16.
//  Copyright © 2015年 Jin. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

#define COLOR_VALUE(r,g,b,a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
//#define ColorHexValue(value) [UIColor colorWithRed:((float)((r & 0xFF0000) >> 16)) / 255.0 green:((float)((r & 0xFF00) >> 8)) / 255.0 blue:((float)(r & 0xFF)) / 255.0 alpha:a]


#define BACKGROUND_COLOR      [UIColor colorWithRedFloat:245 greenFloat:245 blueFloat:245]
#define MAIN_THEME_COLOR      [UIColor colorWithRedFloat:255 greenFloat:89 blueFloat:24]
#define FONT_SELECTED_COLOR   [UIColor colorWithRedFloat:255 greenFloat:89 blueFloat:24]
#define FONT_NORMAL_COLOR     [UIColor colorWithRedFloat:128 greenFloat:128 blueFloat:128]
#define RGB_188_COLOR         [UIColor colorWithRedFloat:188 greenFloat:188 blueFloat:188]

#endif /* ColorMacro_h */
