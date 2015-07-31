//
//  HGLocationSearchViewModel.h
//  LocationSearch
//
//  Created by 汤海波 on 7/31/15.
//  Copyright (c) 2015 FanAppz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface HGLocationSearchViewModel : NSObject

@property (strong, nonatomic) NSString *searchText;
// current
@property (strong, nonatomic) id currentLocation;
@property (strong, nonatomic) NSString *currentAddress;
@property (strong, nonatomic) NSArray *searchResults;

// table data
- (NSInteger)sectionCount;
- (NSInteger)rowCountInSection:(NSInteger)section;
- (NSArray *)stringsForItem:(MKMapItem *)item;
- (NSArray *)stringsForCurrentLocation;

// signal
@property (strong, nonatomic) RACSignal *dataChangeSignal;

- (void)searchFromServer;

@end
