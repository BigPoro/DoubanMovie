//
//  LHTabBarControllerConfig.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHTabBarControllerConfig.h"
#import "LHNavigationController.h"
#import "LHMineViewController.h"
#import "LHMainSearchViewController.h"
#import "LHInTheatersViewControlloer.h"
#import "LHReaderViewController.h"
#import "LHMusicViewController.h"
static CGFloat const kTabBarControllerHeight = 40.f;
static NSInteger const kSelectedCoverIndex = 2;

@interface LHTabBarControllerConfig()<CYLTabBarControllerDelegate,UITabBarControllerDelegate>

@property (nonatomic, weak) UIButton *selectedCover;


@end

@implementation LHTabBarControllerConfig
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self mainTabBarController];
    return self;
}
#pragma mark UI
- (CYLTabBarController *)mainTabBarController
{
    if (!_mainTabBarController) {
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;
        UIOffset titlePositionAdjustment = UIOffsetZero;
        _mainTabBarController = [CYLTabBarController tabBarControllerWithViewControllers:[self arrayViewControllerItem] tabBarItemsAttributes:[self arrayAttributesItem] imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment];
        _mainTabBarController.delegate = self;
        [self customizeTabBarAppearance:_mainTabBarController];
    }
    return _mainTabBarController;
}
- (void)setupSelectedCoverBtn
{
    kWeakSelf;
    [_mainTabBarController setViewDidLayoutSubViewsBlock:^(CYLTabBarController *tabBarController) {
        if ([self cyl_tabBarController].selectedIndex != 0) {
            return;
        }
        static dispatch_once_t onceToken;
        UITabBar *tabBar =  tabBarController.tabBar;
        for (UIControl *control in tabBar.subviews) {
            if ([control cyl_isTabButton]) {
                dispatch_once(&onceToken, ^{
                    NSUInteger delaySeconds = 0.2;
                    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
                    dispatch_after(when, dispatch_get_main_queue(), ^{
                        [weakSelf setSelectedCoverShow:YES];
                    });
                });
            }
        }
    }];

}
- (void)setSelectedCoverShow:(BOOL)show {
    if (_selectedCover.superview && show) {
        [self addOnceScaleAnimationOnView:_selectedCover];
        return;
    }
    UIControl *selectedTabButton = [[self cyl_tabBarController].viewControllers[kSelectedCoverIndex].tabBarItem cyl_tabButton];
    if (show && !_selectedCover.superview) {
        UIButton *selectedCover = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"douban_reader_logo"];
        [selectedCover setImage:image forState:UIControlStateNormal];
        selectedCover.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        if (selectedTabButton) {
            selectedCover.center = CGPointMake(selectedTabButton.cyl_tabImageView.center.x, selectedTabButton.center.y);
            [self addOnceScaleAnimationOnView:selectedCover];
            [selectedTabButton addSubview:(_selectedCover = selectedCover)];
            [selectedTabButton bringSubviewToFront:_selectedCover];
        }
    } else if (_selectedCover.superview){
        [_selectedCover removeFromSuperview];
        _selectedCover = nil;
    }
    if (selectedTabButton) {
        selectedTabButton.cyl_tabLabel.hidden = (show);
        selectedTabButton.cyl_tabImageView.hidden = (show);
    }
}
//缩放动画
- (void)addOnceScaleAnimationOnView:(UIView *)animationView {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@0.5, @1.0];
    animation.duration = 0.1;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}
- (NSArray *)arrayViewControllerItem
{
    LHNavigationController *firstNavigationController = [[LHNavigationController alloc]
                                                    initWithRootViewController:[[LHInTheatersViewControlloer alloc] init]];
    LHNavigationController *secondNavigationController = [[LHNavigationController alloc]
                                                          initWithRootViewController:[[LHMainSearchViewController alloc] init]];
    
    LHNavigationController *thirdNavigationController = [[LHNavigationController alloc]
                                                          initWithRootViewController:[[LHReaderViewController alloc] init]];
    
    LHNavigationController *fourthNavigationController = [[LHNavigationController alloc]
                                                         initWithRootViewController:[[LHMusicViewController alloc] init]];
    
    LHNavigationController *fifthNavigationController = [[LHNavigationController alloc]
                                                         initWithRootViewController:[[LHMineViewController alloc] init]];
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 fourthNavigationController,
                                 fifthNavigationController
                                 ];
    return viewControllers;
}

- (NSArray *)arrayAttributesItem
{
    /* NSString and UIImage are supported*/
    
    NSDictionary *firstItemsAttributes =@{CYLTabBarItemTitle : @"热映",
                                             CYLTabBarItemImage : @"ic_tab_hot_gray_27x27_",
                                             CYLTabBarItemSelectedImage : @"ic_tab_hot_black_27x27_",};
    
    NSDictionary *secondItemsAttributes = @{CYLTabBarItemTitle : @"找片",
                                              CYLTabBarItemImage : @"ic_tab_discover_gray_27x27_",
                                              CYLTabBarItemSelectedImage : @"ic_tab_discover_black_27x27_",};
   
    NSDictionary *thirdItemsAttributes = @{CYLTabBarItemTitle : @"读书",
                                           CYLTabBarItemImage : @"douban_reader",
                                           CYLTabBarItemSelectedImage : @"douban_reader_seleted",};
    
    NSDictionary *fourthItemsAttributes = @{CYLTabBarItemTitle : @"音乐",
                                           CYLTabBarItemImage : @"douban_fm",
                                           CYLTabBarItemSelectedImage : @"douban_fm_seleceted",};
    
   
    
    NSDictionary *fifthItemsAttributes = @{CYLTabBarItemTitle : @"我的",
                                           CYLTabBarItemImage : @"ic_tab_profile_gray_27x27_",
                                           CYLTabBarItemSelectedImage : @"ic_tab_profile_black_27x27_",};
    NSArray *tabBarItemsAttributes = @[firstItemsAttributes,
                                       secondItemsAttributes,
                                       thirdItemsAttributes,
                                       fourthItemsAttributes,
                                       fifthItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController
{
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // TabBarItem选中后的背景颜色
    [self customizeTabBarSelectionIndicatorImage];
    

    // 需要支持横竖屏
    [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    // 设置背景图片
    UITabBar *tabBarAppearance = [UITabBar appearance];
    
    [UITabBar appearance].translucent = NO;
    UIImage *tabBarBackgroundImage = [[self class] imageWithColor:kWhite_one size:CGSizeMake(kScreenW, kTabBarControllerHeight)];
    UIImage *scanedTabBarBackgroundImage = [[self class] scaleImage:tabBarBackgroundImage];
    [tabBarAppearance setBackgroundImage:scanedTabBarBackgroundImage];
    
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

// 横屏支持
- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate
{
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            debug_NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            debug_NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}
- (void)customizeTabBarSelectionIndicatorImage
{
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    CGFloat tabBarHeight = kTabBarControllerHeight;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor whiteColor]
                             size:selectionIndicatorImageSize]];
}
#pragma mark Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control
{
    UIView *animationView;
    
    if ([control cyl_isTabButton]) {
        // 更改红标状态
        if ([[self cyl_tabBarController].selectedViewController cyl_isShowTabBadgePoint]) {
            [[self cyl_tabBarController].selectedViewController cyl_removeTabBadgePoint];
        } else {
            [[self cyl_tabBarController].selectedViewController cyl_showTabBadgePoint];
        }
        animationView = [control cyl_tabImageView];
    }
    
    UIButton *button = CYLExternPlusButton;
    BOOL isPlusButton = [control cyl_isPlusButton];
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if (isPlusButton) {
        animationView = button.imageView;
    }
    
    if ([self cyl_tabBarController].selectedIndex == 0) {
        [self addScaleAnimationOnView:animationView repeatCount:1];
    } else {
        [self addRotateAnimationOnView:animationView];
    }
    
    //添加仿淘宝tabbar，第四个tab选中后有图标覆盖
    if ([control cyl_isTabButton]|| [control cyl_isPlusButton]) {
        BOOL shouldSelectedCoverShow = ([self cyl_tabBarController].selectedIndex == kSelectedCoverIndex);
        [self setSelectedCoverShow:shouldSelectedCoverShow];
    }
    
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount
{
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

// 旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView
{
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

#pragma make Tools
+ (UIImage *)scaleImage:(UIImage *)image
{
    CGFloat halfWidth = image.size.width/2;
    CGFloat halfHeight = image.size.height/2;
    UIImage *secondStrechImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth) resizingMode:UIImageResizingModeStretch];
    return secondStrechImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
