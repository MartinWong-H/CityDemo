//
//  AddressObject.h
//  CityListDemo
//
//  Created by XiaoWarning on 16/1/6.
//  Copyright © 2016年 XiaoWarning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressObject : NSObject

/**
 *  位置名称
 */
@property (nonatomic,strong) NSString *addressName;
/**
 *  拼音
 */
@property (nonatomic,strong) NSString *letter;

@property (nonatomic,strong) NSString *levelNum;
/**
 *  国标ID
 */
@property (nonatomic,strong) NSString *addressID;

@property (nonatomic,strong) NSString *parentID;

- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

- (instancetype)initWithAddressDic:(NSDictionary *)dic;

@end
