![Demo Image](http://7xihd8.com1.z0.glb.clouddn.com/location_search.gif)

# LocationSearch
项目中需要用到一个位置搜索的功能。没有找到开源的项目就自己写了一个。
模仿iOS自带日历程序中位置搜索界面和功能。可以很方便的集成。轻松得到用户搜索的位置信息。

# 安装
1. 将HGLocationSearch文件夹添加到你的项目中。
2. 添加相关类库
  1. MapKit.framework

# 用法
```objc
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
```

# TODO
1. 最近搜索的纪录

#License
MIT
