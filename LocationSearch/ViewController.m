//
//  ViewController.m
//  LocationSearch
//
//  Created by 汤海波 on 7/31/15.
//  Copyright (c) 2015 FanAppz. All rights reserved.
//

#import "ViewController.h"
#import "HGLocationSearchViewController.h"

@interface ViewController ()<HGLocationSearchViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HGLocationSearchViewController *vc = [(id)[segue.destinationViewController viewControllers] firstObject];
    vc.delegate = self;
}

#pragma mark - Delegate
#pragma mark HGLocationSearchViewControllerDelegate
- (void)locationSearchViewControllerDidSelect:(id)sender name:(NSString *)name address:(NSString *)address {
    self.nameLabel.text = name;
    self.addressLabel.text = address;
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
