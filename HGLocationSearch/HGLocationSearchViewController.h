//
//  HGLocationSearchViewController.h
//  LocationSearch
//
//  Created by 汤海波 on 7/30/15.
//  Copyright (c) 2015 FanAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 *  动态位置cell。包含地方名字和地址信息。
 */
@interface HGLocationCell : UITableViewCell

- (void)updateCellWithTitle:(NSString *)title address:(NSString *)address;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
typedef enum : NSUInteger {
    HGLocationStaticCellTypeCurrent,
    HGLocationStaticCellTypeUserInput,
} HGLocationStaticCellType;

/**
 *  静态Cell。
 *  输入位置的Cell，当前位置Cell
 */
@interface HGLocationStaticCell : UITableViewCell

@property (assign, nonatomic) HGLocationStaticCellType type;

- (void)setTitle:(NSString *)title;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol HGLocationSearchViewControllerDelegate <NSObject>
@optional
- (void)locationSearchViewControllerDidSelect:(id)sender name:(NSString *)name address:(NSString *)address;

@end
@interface HGLocationSearchViewController : UIViewController

@property (weak, nonatomic) id<HGLocationSearchViewControllerDelegate> delegate;

@end