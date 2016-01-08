//
//  ViewController.m
//  CityListDemo
//
//  Created by XiaoWarning on 16/1/5.
//  Copyright © 2016年 XiaoWarning. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "PinYin4Objc.h"
#import "PinyinHelper.h"
#import "ChineseInclude.h"
#import "SecondViewController.h"
#import "ColorMacro.h"
#import "FrameMacro.h"
#import "AddressObject.h"
#import "Masonry.h"

@interface ViewController ()<AddressDelegate>

@property (nonatomic,strong) AddressObject *province;

@property (nonatomic,strong) AddressObject *city;

@property (nonatomic,strong) UILabel *label;

@property (nonatomic,strong) UIButton *button_1;

@property (nonatomic,strong) UIButton *button_2;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutViews];
  
  NSArray *array = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"Province2"];
  if (array.count == 0) {
    [self getTheCityData];
  }
}

- (void)layoutViews {
  WS(ws);
  
  [self.view addSubview:self.label];
  [self.view addSubview:self.button_1];
  [self.view addSubview:self.button_2];
  
  [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(ws.view);
    make.top.mas_equalTo(ws.view).mas_offset(@(130));
    make.width.mas_equalTo(@(SCREEN_WIDTH));
    make.height.mas_equalTo(@(44));
  }];
  
  [self.button_1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ws.label).mas_offset(@(30));
    make.top.mas_equalTo(ws.label.mas_bottom).mas_offset(@(VIEW_HEIGHT(60)));
    make.size.mas_equalTo(CGSizeMake(100, 60));
  }];
  
  self.button_2.enabled = NO;
  [self.button_2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(ws.label).mas_offset(@(-30));
    make.top.mas_equalTo(ws.button_1);
    make.size.mas_equalTo(CGSizeMake(100, 60));
  }];
}

- (void)getTheCityData {
  
  NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"db"];
  FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
  NSMutableArray *addArray = [[NSMutableArray alloc] init];
  NSMutableArray *addArray1 = [[NSMutableArray alloc] init];
  
  if ([database open]) {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM area WHERE levelNum = 1"];
    FMResultSet *set = [database executeQuery:sql];
    
    while ([set next]) {
      
      AddressObject *aObj = [[AddressObject alloc] init];
      aObj.addressName = [set stringForColumn:@"areaname"];
      aObj.addressID = [set stringForColumn:@"id"];
      aObj.levelNum = [set stringForColumn:@"levelNum"];
      
      NSString *ms = [NSString stringWithFormat:@"%@",aObj.addressName];
      HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
      [outputFormat setToneType:ToneTypeWithoutTone];
      [outputFormat setVCharType:VCharTypeWithV];
      [outputFormat setCaseType:CaseTypeLowercase];
      NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:ms withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
      
      aObj.letter = outputPinyin;
      [addArray addObject:aObj];
    }
    
    [set close];
    [database close];
  }
  
//  NSMutableArray *temp = [[NSMutableArray alloc] init];
//  for (MySelectCity *city in arrays) {
//    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:city];
//    [temp addObject:archiver];
//  }
//  [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"Province"];
//  [[NSUserDefaults standardUserDefaults] synchronize];
  
  NSMutableArray *temp2 = [[NSMutableArray alloc] init];
  for (AddressObject *obj in addArray) {
    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [temp2 addObject:archiver];
  }
  [[NSUserDefaults standardUserDefaults] setObject:temp2 forKey:@"Province2"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  
  
  if ([database open]) {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM area WHERE levelNum = 2"];
    
    FMResultSet *set = [database executeQuery:sql];
    
    while ([set next]) {
      
      AddressObject *addressObj = [[AddressObject alloc] init];
      addressObj.addressName = [set stringForColumn:@"areaname"];
      addressObj.addressID = [set stringForColumn:@"id"];
      addressObj.levelNum = [set stringForColumn:@"levelNum"];
      
//      MySelectCity *cityObj = [[MySelectCity alloc] init];
//      cityObj.cityName = [set stringForColumn:@"areaname"];
//      cityObj.cityID = [set stringForColumn:@"id"];
      
      NSString *ms = [NSString stringWithFormat:@"%@",addressObj.addressName];
      HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
      [outputFormat setToneType:ToneTypeWithoutTone];
      [outputFormat setVCharType:VCharTypeWithV];
      [outputFormat setCaseType:CaseTypeLowercase];
      NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:ms withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
      addressObj.letter = outputPinyin;
      [addArray1 addObject:addressObj];
    }
    [set close];
    [database close];
  }
  
//  NSMutableArray *temp1 = [[NSMutableArray alloc] init];
//  for (MySelectCity *city in array1) {
//    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:city];
//    [temp1 addObject:archiver];
//  }
//  [[NSUserDefaults standardUserDefaults] setObject:temp1 forKey:@"City"];
//  [[NSUserDefaults standardUserDefaults] synchronize];
  
  NSMutableArray *temp3 = [[NSMutableArray alloc] init];
  for (AddressObject *obj in addArray1) {
    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [temp3 addObject:archiver];
  }
  [[NSUserDefaults standardUserDefaults] setObject:temp3 forKey:@"City1"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
//  NSMutableArray *array1 = [[NSMutableArray alloc] init];
//  NSMutableArray *temp1 = [[NSMutableArray alloc] init];
//  temp1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
//  for (NSData *data in temp1) {
//    MySelectCity *city = (MySelectCity *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
//    [array1 addObject:city];
//    NSLog(@"%@",city.letter);
//  }
//  NSLog(@"222 %lu",(unsigned long)array1.count);

}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)clickToProvince {
  
  SecondViewController *second = [[SecondViewController alloc] initWithAreaType:AreaTypeProvince];
  second.delegate = self;
  [self.navigationController pushViewController:second
                                       animated:YES];
}

- (void)clickToCityList {
  
  SecondViewController *second = [[SecondViewController alloc] initWithAreaType:AreaTypeCity];
  second.delegate = self;
  [self.navigationController pushViewController:second
                                       animated:YES];
}

- (void)getProvince:(AddressObject *)province {
  
  self.province = province;
  self.label.text = [NSString stringWithFormat:@"%@",self.province.addressName];
  
  self.button_2.enabled = YES;
  NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"db"];
  FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
  NSMutableArray *addArray = [[NSMutableArray alloc] init];
  
  if ([database open]) {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM area WHERE levelNum = 2 AND parentid = %d",[self.province.addressID intValue]/10000 *10000];
    FMResultSet *set = [database executeQuery:sql];
    
    while ([set next]) {
      
      AddressObject *aObj = [[AddressObject alloc] init];
      aObj.addressName = [set stringForColumn:@"areaname"];
      aObj.addressID = [set stringForColumn:@"id"];
      aObj.levelNum = [set stringForColumn:@"levelNum"];
      
      NSString *ms = [NSString stringWithFormat:@"%@",aObj.addressName];
      HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
      [outputFormat setToneType:ToneTypeWithoutTone];
      [outputFormat setVCharType:VCharTypeWithV];
      [outputFormat setCaseType:CaseTypeLowercase];
      NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:ms withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
      
      aObj.letter = outputPinyin;
      [addArray addObject:aObj];
      
      NSLog(@"%@",aObj.addressName);
    }
    
    [set close];
    [database close];
  }
  
  NSMutableArray *temp3 = [[NSMutableArray alloc] init];
  for (AddressObject *obj in addArray) {
    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [temp3 addObject:archiver];
  }
  [[NSUserDefaults standardUserDefaults] setObject:temp3 forKey:@"City1"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
}
- (void)getCity:(AddressObject *)city {
  
  self.city = city;
  self.label.text = [NSString stringWithFormat:@"%@-%@",self.province.addressName,self.city.addressName];
}

#pragma mark - Accessor
- (UIButton *)button_1 {
  
  if (!_button_1) {
    _button_1 = [[UIButton alloc] init];
    _button_1.backgroundColor = COLOR_VALUE(51, 51, 51, 1);
    [_button_1 setTitle:@"选择省份" forState:UIControlStateNormal];
    [_button_1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_button_1 addTarget:self action:@selector(clickToProvince) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _button_1;
}

- (UIButton *)button_2 {
  
  if (!_button_2) {
    _button_2 = [[UIButton alloc] init];
    _button_2.backgroundColor = COLOR_VALUE(51, 51, 51, 1);
    [_button_2 setTitle:@"选择城市" forState:UIControlStateNormal];
    [_button_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button_2 addTarget:self action:@selector(clickToCityList) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _button_2;
}

- (UILabel *)label {
  
  if (!_label) {
    
    _label = [[UILabel alloc] init];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = COLOR_VALUE(80, 120, 201, 1);
    _label.font = [UIFont systemFontOfSize:18];
  }
  
  return _label;
}

@end
