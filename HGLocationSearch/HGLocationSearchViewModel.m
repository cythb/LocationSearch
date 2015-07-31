//
//  HGLocationSearchViewModel.m
//  LocationSearch
//
//  Created by 汤海波 on 7/31/15.
//  Copyright (c) 2015 FanAppz. All rights reserved.
//

#import "HGLocationSearchViewModel.h"
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface HGLocationSearchViewModel() {
    MKLocalSearch *_search;
}

@end
@implementation HGLocationSearchViewModel

#pragma mark - 
- (instancetype)init {
    self = [super init];
    if (self) {
        id searchTextSignal = RACObserve(self, searchText);
        id currentAddressSignal = RACObserve(self, currentAddress);
        id searchReusltsChangedSignal = RACObserve(self, searchResults);
        
        self.dataChangeSignal = [RACSignal merge:@[searchTextSignal, currentAddressSignal, searchReusltsChangedSignal]];
    }
    return self;
}

#pragma mark - Private
- (NSString *)addressForItem:(MKMapItem *)item {
    NSString *address = ABCreateStringWithAddressDictionary(item.placemark.addressDictionary, NO);
    //    return [address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return [[address componentsSeparatedByString:@"\n"] lastObject];
}

- (NSString *)titleForItem:(MKMapItem *)item {
    return item.name;
}

#pragma mark - Public
- (void)searchFromServer {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchText;
    [_search cancel];
    _search = [[MKLocalSearch alloc] initWithRequest:request];
    [_search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.searchResults = response.mapItems;
    }];
}

- (NSArray *)stringsForCurrentLocation {
    MKMapItem *item = [MKMapItem mapItemForCurrentLocation];
    id name = [self titleForItem:item];
    id address = [self addressForItem:item];
    if (name == nil) {
        name = [NSNull null];
    }
    if (address == nil) {
        address = [NSNull null];
    }
    return @[name, address ];
}

- (NSArray *)stringsForItem:(MKMapItem *)item {
    id name = [self titleForItem:item];
    id address = [self addressForItem:item];
    if (name == nil) {
        name = [NSNull null];
    }
    if (address == nil) {
        address = [NSNull null];
    }
    return @[name, address ];
    
}

#pragma mark TableCount
- (NSInteger)sectionCount {
    if (self.searchResults.count > 0) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)rowCountInSection:(NSInteger)section {
    if (section == 0) {
        if (self.searchText.length > 0) {
            return 2;
        }else {
            return 1;
        }
    }else {
        return self.searchResults.count;
    }
}

@end
