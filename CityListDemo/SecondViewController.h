//
//  SecondViewController.h
//  CityListDemo
//
//  Created by XiaoWarning on 16/1/6.
//  Copyright © 2016年 XiaoWarning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressObject;


typedef NS_ENUM(NSUInteger,AreaType) {
  AreaTypeProvince,
  AreaTypeCity,
};

@protocol AddressDelegate <NSObject>

- (void)getProvince:(AddressObject *)province;
- (void)getCity:(AddressObject *)city;

@end


@interface SecondViewController : UIViewController

@property (nonatomic) AreaType areaType;

- (instancetype)initWithAreaType:(AreaType)type;

@property (nonatomic, assign) id<AddressDelegate>delegate;
@property (nonatomic, strong) AddressObject *provinceObj;
@property (nonatomic, strong) AddressObject *cityObj;


@end
