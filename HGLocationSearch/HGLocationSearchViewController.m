//
//  HGLocationSearchViewController.m
//  LocationSearch
//
//  Created by 汤海波 on 7/30/15.
//  Copyright (c) 2015 FanAppz. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HGLocationSearchViewController.h"
#import "HGLocationSearchViewModel.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 *  动态位置cell。包含地方名字和地址信息。
 */
@interface HGLocationCell(){
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UILabel *_addressLabel;
}

@end

@implementation HGLocationCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // icon
        _iconView = [[UIImageView alloc] init];
        _iconView.tintColor = [UIColor blackColor];
        _iconView.image = [UIImage imageNamed:@"HGLocationSearch.bundle/LegacyPinDown3Sat"];
        [self.contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_iconView.superview.mas_centerY);
            make.leading.equalTo(_iconView.superview.mas_leading).with.offset(15);
        }];
        // title
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.superview.mas_top).with.offset(8);
            make.leading.equalTo(_titleLabel.superview.mas_leading).with.offset(45);
            make.trailing.equalTo(_titleLabel.superview.mas_trailing).with.offset(-8);
        }];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_addressLabel.superview.mas_bottom).with.offset(-4);
            make.leading.equalTo(_addressLabel.superview.mas_leading).with.offset(45);
            make.trailing.equalTo(_addressLabel.superview.mas_trailing).with.offset(-8);
        }];
    }
    return self;
}

- (void)updateCellWithTitle:(NSString *)title address:(NSString *)address {
    _titleLabel.text = title;
    _addressLabel.text = address;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 *  静态Cell。
 *  输入位置的Cell，当前位置Cell
 */
@interface HGLocationStaticCell() {
    UIImageView *_iconView;
    UILabel *_titleLabel;
}

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation HGLocationStaticCell : UITableViewCell
#pragma mark - 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
        // icon
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_iconView.superview.mas_centerY);
            make.leading.equalTo(_iconView.superview.mas_leading).with.offset(15);
        }];
        // title
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.superview.mas_centerY);
            make.leading.equalTo(_titleLabel.superview.mas_leading).with.offset(45);
        }];
        
        self.indicator = [[UIActivityIndicatorView alloc] init];
        self.indicator.hidesWhenStopped = YES;
        [self.contentView addSubview:self.indicator];
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.mas_centerY);
            make.leading.equalTo(_titleLabel.mas_trailing).with.offset(8);
        }];
    }
    return self;
}

#pragma mark - Public
- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

#pragma mark - Getter/Setter
- (void)setType:(HGLocationStaticCellType)type {
    _type = type;
    if (_type == HGLocationStaticCellTypeCurrent) {
        _iconView.image = [[UIImage imageNamed:@"HGLocationSearch.bundle/TrackingLocation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _iconView.tintColor = [UIColor blackColor];
        _titleLabel.text = @"Current";
    }else {
        _iconView.image = [[UIImage imageNamed:@"HGLocationSearch.bundle/LegacyPinDown3Sat"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _iconView.tintColor = [UIColor grayColor];
        _titleLabel.text = nil;
    }
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface HGLocationSearchViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,
UISearchBarDelegate>{
    UISearchBar *_searchBar;
}

@property (strong, nonatomic) HGLocationSearchViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HGLocationSearchViewController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Location";
    
    // add search bar
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"Enter Location";
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.leading.equalTo(_searchBar.superview.mas_leading).with.offset(0);
        make.trailing.equalTo(_searchBar.superview.mas_trailing).with.offset(0);
    }];
   
    // add table view
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom);
        make.leading.equalTo(_tableView.superview.mas_leading);
        make.trailing.equalTo(_tableView.superview.mas_trailing);
        make.bottom.equalTo(_tableView.superview.mas_bottom);
    }];
    
    // register cell
    [_tableView registerClass:[HGLocationStaticCell class] forCellReuseIdentifier:@"HGLocationStaticCell"];
    [_tableView registerClass:[HGLocationCell class] forCellReuseIdentifier:@"HGLocationCell"];
    
    // reactive
    @weakify(self);
    [self.viewModel.dataChangeSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    // navigatin item
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(onClickedCancelItem)];
    self.navigationItem.rightBarButtonItem = item;
    
    //监听数据
    [RACObserve(self.viewModel, reversing) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - Action
- (void)onClickedCancelItem {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Delegate
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.viewModel.searchText = searchText;
    [self.viewModel searchFromServer];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.viewModel searchFromServer];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel sectionCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.viewModel rowCountInSection:0] == 2 && indexPath.row == 0) {
            HGLocationStaticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HGLocationStaticCell"];
            cell.type = HGLocationStaticCellTypeUserInput;
            [cell setTitle:self.viewModel.searchText];
            return cell;
        }else {
            HGLocationStaticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HGLocationStaticCell"];
            cell.type = HGLocationStaticCellTypeCurrent;
            if (self.viewModel.reversing) {
                [cell.indicator startAnimating];
            }else {
                [cell.indicator stopAnimating];
            }
            return cell;
        }
    }else {
        HGLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HGLocationCell"];
        MKMapItem *item = self.viewModel.searchResults[indexPath.row];
        NSString *title = nil;
        NSString *address = nil;
        NSArray *strs = [self.viewModel stringsForItem:item];
        if ([strs.firstObject isKindOfClass:[NSString class]]) {
            title = strs.firstObject;
        }
        if ([strs.lastObject isKindOfClass:[NSString class]]) {
            address = strs.lastObject;
        }
            
        [cell updateCellWithTitle:title address:address];
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel rowCountInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Locations";
    }else {
        return nil;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.delegate respondsToSelector:@selector(locationSearchViewControllerDidSelect:name:address:)]) {
        return;
    }
    
    NSArray *nameAndAddress = nil;
    NSString *name = nil;
    NSString *address = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && [self.viewModel rowCountInSection:0]==2) {
            nameAndAddress = @[self.viewModel.searchText, [NSNull null]];
        }else {
            // 正在解析地址，当前位置不可用
            if (self.viewModel.reversing) {
                return;
            }
            
            if (self.viewModel.currentName) {
                name = self.viewModel.currentName;
            }
            if (self.viewModel.currentAddress ) {
                address = self.viewModel.currentAddress;
            }
        }
    }else {
        nameAndAddress = [self.viewModel stringsForItem:self.viewModel.searchResults[indexPath.row]];
    }
    
    if ([nameAndAddress.firstObject isKindOfClass:[NSString class]]) {
        name = nameAndAddress.firstObject;
    }
    if ([nameAndAddress.lastObject isKindOfClass:[NSString class]]) {
        address = nameAndAddress.lastObject;
    }
    [self.delegate locationSearchViewControllerDidSelect:self name:name address:address];
}

#pragma mark - Getter/Setter
- (HGLocationSearchViewModel *)viewModel {
    if (nil == _viewModel) {
        _viewModel = [HGLocationSearchViewModel new];
    }
    return _viewModel;
}

@end
