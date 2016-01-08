//
//  SecondViewController.m
//  CityListDemo
//
//  Created by XiaoWarning on 16/1/6.
//  Copyright © 2016年 XiaoWarning. All rights reserved.
//

#import "SecondViewController.h"
#import "AIMTableViewIndexBar.h"
#import "FMDB.h"
#import "Masonry.h"
#import "PinYin4Objc.h"
#import "PinyinHelper.h"
#import "ChineseInclude.h"
#import "ColorMacro.h"
#import "FrameMacro.h"
#import "AddressObject.h"
#import "MySearchBar.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,AIMTableViewIndexBarDelegate,UISearchBarDelegate,UISearchDisplayDelegate> {
  
  AIMTableViewIndexBar *_indexBar;                                         //右侧搜索栏
  UISearchDisplayController *_searchDisplayController;                    //显示搜索结果VC
}

@property (nonatomic,strong) UITableView *tableView;

/**
 * 城市首字母
 */
@property (nonatomic,strong) NSMutableArray *firstLetter;

/**
 *  分类数组
 */
@property (nonatomic,strong) NSMutableArray *citys;

/**
 *  全部城市对象
 */
@property (nonatomic,strong) NSMutableArray *allCitys;

/**
 *  全部数据
 */
@property (nonatomic,strong) NSArray *allArrays;

@property (nonatomic,strong) MySearchBar *searchBar;

/**
 *  当前城市
 */
@property (nonatomic,strong) UILabel *currentCityLabel;

@property (nonatomic,strong) NSMutableArray *searchResult;

@end

@implementation SecondViewController
- (instancetype)initWithAreaType:(AreaType)type {
  
  self = [super init];
  if (self) {
    
    self.areaType = type;
  }
  
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
//  [self layoutViews];
  
  self.view.backgroundColor = COLOR_VALUE(188, 188, 188, 1);
  [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  self.navigationController.tabBarController.tabBar.hidden = YES;
  self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  
  [_indexBar animateLayerAtIndex:0];
}

- (void)viewWillDisappear:(BOOL)animated {
  
  [super viewWillDisappear:animated];
  self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)loadData {
  
  if (_areaType == AreaTypeProvince) {
    
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    NSMutableArray *temp1 = [[NSMutableArray alloc] init];
    [self.allCitys removeAllObjects];
    temp1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"Province2"];
    for (NSData *data in temp1) {
      AddressObject *city = (AddressObject *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
      [array1 addObject:city];
      [self.allCitys addObject:city];
    }
    
    if (self.allCitys != 0) {
      [self classifyCity];
    }
  }
  else if (_areaType == AreaTypeCity) {
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"City1"];
    [self.allCitys removeAllObjects];
    for (NSData *data in temp) {
      AddressObject *city = (AddressObject *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
      [self.allCitys addObject:city];
    }
    
    if (self.allCitys.count != 0) {
      [self classifyCity];
    }
  }
  
}

/**
 *  分类
 */
- (void)classifyCity {
  
  NSArray *newArray = [[NSArray alloc] init];
  // 所有城市列表排序
  newArray = [self.allCitys sortedArrayUsingFunction:nickeNameSort context:NULL];
  
  //self.citys = [NSMutableArray array];
  
  BOOL checkValueAtIndex = NO; // 检查的flag
  NSMutableArray *tempArrForGrouping = nil;
  for (int i = 0; i < newArray.count; i++) {
    
    AddressObject *chineseString = (AddressObject *)[newArray objectAtIndex:i];
    NSMutableString *strChar = [NSMutableString stringWithString:chineseString.letter];
    // 取首字母
    NSString *sr = [strChar substringToIndex:1];
    // 检查数组内是否有该字母，没有则创建
    if (![self.firstLetter containsObject:[sr uppercaseString]]) {
      // 不存在则添加
      [self.firstLetter addObject:[sr uppercaseString]];
      tempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
      checkValueAtIndex = NO;
    }
    
    // 有数据则添加
    if ([self.firstLetter containsObject:[sr uppercaseString]]) {
      [tempArrForGrouping addObject:[newArray objectAtIndex:i]];
      if (checkValueAtIndex == NO) {
        [self.citys addObject:tempArrForGrouping];
        checkValueAtIndex = YES;
      }
    }
  }
  
  _allArrays = [NSArray arrayWithObjects:self.firstLetter, self.citys, self.allCitys, nil];
  [self layoutViews];
}

/**
 *  根据拼音进行排序
 */
NSInteger nickeNameSort (id user1, id user2, void *context) {
//  MySelectCity *c1, *c2;
//  
//  c1 = (MySelectCity *)user1;
//  c2 = (MySelectCity *)user2;
  AddressObject *c1, *c2;
  
  c1 = (AddressObject *)user1;
  c2 = (AddressObject *)user2;
  
  return [c1.letter localizedCompare:c2.letter];
}

- (void)layoutViews {
  WS(ws);
  
  
  _searchBar = [MySearchBar new];
  _searchBar.placeholder = @"输入城市名或拼音";
  _searchBar.delegate = self;
  _searchBar.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_searchBar];
  [_searchBar  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(ws.view).mas_offset(65);
    make.left.mas_equalTo(ws.view);
    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
  }];
  
  _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
  //_searchDisplayController.active = NO;
  _searchDisplayController.searchResultsDataSource = self;
  _searchDisplayController.searchResultsDelegate = self;
  
  UILabel *currentLabel = [UILabel new];
  currentLabel.backgroundColor = [UIColor clearColor];
  currentLabel.textColor = COLOR_VALUE(255, 60, 0, 1);
  currentLabel.text = @"当前：";
  currentLabel.textAlignment = NSTextAlignmentRight;
  currentLabel.font = [UIFont systemFontOfSize:16];
  [self.view addSubview:currentLabel];
  [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.searchBar.mas_bottom).mas_offset(1);
    make.left.mas_equalTo(ws.view);
    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH /2, 32));
  }];
  
  _currentCityLabel = [UILabel new];
  _currentCityLabel.backgroundColor = [UIColor clearColor];
  _currentCityLabel.textColor = COLOR_VALUE(255, 60, 0, 1);
  _currentCityLabel.textAlignment = NSTextAlignmentLeft;
  _currentCityLabel.font = [UIFont systemFontOfSize:18];
  [self.view addSubview:self.currentCityLabel];
  [self.currentCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.searchBar.mas_bottom).mas_offset(1);
    make.left.mas_equalTo(currentLabel.mas_right);
    make.right.mas_equalTo(ws.view);
    make.height.mas_equalTo(@32);
  }];
  
  _tableView = [UITableView new];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(ws.currentCityLabel).mas_offset(@(VIEW_HEIGHT(120)));
    make.left.bottom.and.right.mas_equalTo(ws.view);
  }];
  
  _indexBar = [AIMTableViewIndexBar new];
  _indexBar.letters = self.firstLetter;
  _indexBar.backgroundColor = COLOR_VALUE(238, 238, 238, 1);
  _indexBar.delegate = self;
  [self.view addSubview:_indexBar];
  [_indexBar mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.tableView).mas_offset(30);
    make.right.mas_equalTo(self.tableView).mas_offset(-1);
    make.width.mas_equalTo(@22);
    make.bottom.mas_equalTo(ws.tableView);
  }];
}

- (void)viewDidLayoutSubviews {
  
  if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
  }
  
  if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
  }
  
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
  
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == _searchDisplayController.searchResultsTableView) {
    return 1;
  }
  
  return self.firstLetter.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (tableView == _searchDisplayController.searchResultsTableView) {
    return self.searchResult.count;
  }
  return [(NSArray *)[self.citys objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  if (tableView == _searchDisplayController.searchResultsTableView) {
    return 0.0;
  }
  return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  if (tableView == _searchDisplayController.searchResultsTableView) {
    return nil;
  }
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 30.0f)];
  headerView.backgroundColor = COLOR_VALUE(250, 250, 250, 1);
  
  UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0, SCREEN_WIDTH - 10.0f, 30)];
  sectionLabel.textColor = COLOR_VALUE(154, 150, 150, 1);
  NSString *text = [self.firstLetter objectAtIndex:section];
  
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 29.0, SCREEN_WIDTH, 1.0)];
  lineView.backgroundColor = COLOR_VALUE(225, 225, 225, 1);
  [headerView addSubview:lineView];
  sectionLabel.text = text;
  [headerView addSubview:sectionLabel];
  
  return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"city ID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = COLOR_VALUE(250, 250, 250, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setTextColor:[UIColor blackColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
  }
  if (tableView == _searchDisplayController.searchResultsTableView) {
//    MySelectCity *city = (MySelectCity *)[self.searchResult objectAtIndex:indexPath.row];
//    cell.textLabel.text = city.cityName;
    
    AddressObject *obj = (AddressObject *)[self.searchResult objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.addressName;
  }
  else {
    
    AddressObject *obj = (AddressObject *)[[self.citys objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.addressName;
    
//    MySelectCity *city = (MySelectCity *)[[self.citys objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//    cell.textLabel.text = city.cityName;
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (self.areaType == AreaTypeProvince) {
    AddressObject *addressObj;
    addressObj = [[self.citys objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSLog(@"测试 %@",addressObj.addressName);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getProvince:)]) {
      [self.delegate getProvince:addressObj];
      [self.navigationController popViewControllerAnimated:YES];
    }
  }
  else {
    
    AddressObject *aObj;
    aObj = [[self.citys objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCity:)]) {
      [self.delegate getCity:aObj];
      [self.navigationController popViewControllerAnimated:YES];
    }
  }
}

#pragma mark AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index {
  
  if (self.tableView.numberOfSections > index && index > -1) {
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
  
}

#pragma UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
  _searchResult = [[NSMutableArray alloc] init];
  
  if (self.searchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
    for (int i=0; i < self.allCitys.count; i++) {
      AddressObject *obj = (AddressObject *)[self.allCitys objectAtIndex:i];
      //MySelectCity *aCity = (MySelectCity *)[self.allCitys objectAtIndex:i];
      HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
      [outputFormat setToneType:ToneTypeWithoutTone];
      [outputFormat setVCharType:VCharTypeWithV];
      [outputFormat setCaseType:CaseTypeLowercase];
      if ([ChineseInclude isIncludeChineseInString:obj.addressName]) {
        // 文字转拼音
        NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:obj.addressName withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        NSRange titleResult=[outputPinyin rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
        if (titleResult.length>0) {
          [self.searchResult addObject:obj];
        }
      }
      else {
        NSRange titleResult=[obj.addressName rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
        if (titleResult.length>0) {
          [self.searchResult addObject:obj.addressName];
        }
      }
    }
  } else if (self.searchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
    for (AddressObject *aCity in self.allCitys) {
      NSRange titleResult=[aCity.addressName rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
      if (titleResult.length>0) {
        [self.searchResult addObject:aCity];
      }
    }
  }
}

#pragma mark - Accessor
- (NSMutableArray *)firstLetter {
  
  if (!_firstLetter) {
    _firstLetter = [[NSMutableArray alloc] init];
  }
  return _firstLetter;
}

- (NSMutableArray *)citys {
  
  if (!_citys) {
    _citys = [[NSMutableArray alloc]init];
  }
  return _citys;
}

- (NSMutableArray *)allCitys {
  
  if (!_allCitys) {
    _allCitys = [[NSMutableArray alloc] init];
    
  }
  return _allCitys;
}

- (NSArray *)allArrays {
  
  if (!_allArrays) {
    
    _allArrays = [[NSArray alloc] init];
  }
  return _allArrays;
}

- (NSMutableArray *)searchResult {
  
  if (!_searchResult) {
    _searchResult = [[NSMutableArray alloc] init];
  }
  return _searchResult;
}

@end
