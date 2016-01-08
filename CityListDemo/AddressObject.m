//
//  AddressObject.m
//  CityListDemo
//
//  Created by XiaoWarning on 16/1/6.
//  Copyright © 2016年 XiaoWarning. All rights reserved.
//

#import "AddressObject.h"

@implementation AddressObject
- (instancetype)initWithAddressDic:(NSDictionary *)dic {
  
  self = [super init];
  if (self) {
    self.addressName = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"areaname"]];
    self.addressID = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.letter = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"Letter"]];
    self.levelNum = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"levelNum"]];
    self.parentID = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"parentid"]];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  
  self = [super init];
  if (self) {
    
    _addressName = [coder decodeObjectForKey:@"areaname"];
    _addressID = [coder decodeObjectForKey:@"id"];
    _letter = [coder decodeObjectForKey:@"Letter"];
    _levelNum = [coder decodeObjectForKey:@"levelNum"];
    _parentID = [coder decodeObjectForKey:@"parentid"];
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  
  [coder encodeObject:self.addressName forKey:@"areaname"];
  [coder encodeObject:self.addressID forKey:@"id"];
  [coder encodeObject:self.letter forKey:@"Letter"];
  [coder encodeObject:self.levelNum forKey:@"levelNum"];
  [coder encodeObject:self.parentID forKey:@"parentid"];
}

#pragma mark - Accessor
- (NSString *)addressName {
  
  if (!_addressName) {
    _addressName = [[NSString alloc] init];
  }
  
  return _addressName;
}

- (NSString *)addressID {
  
  if (!_addressID) {
    _addressID = [[NSString alloc] init];
  }
  
  return _addressID;
}

- (NSString *)letter {
  
  if (!_letter) {
    _letter = [[NSString alloc] init];
  }
  
  return _letter;
}

- (NSString *)levelNum {
  
  if (!_levelNum) {
    _levelNum = [[NSString alloc] init];
  }
  
  return _levelNum;
}

- (NSString *)parentID {
  
  if (!_parentID) {
    _parentID = [[NSString alloc] init];
  }
  
  return _parentID;
}

@end
