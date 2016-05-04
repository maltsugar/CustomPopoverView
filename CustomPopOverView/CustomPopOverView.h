//
//  CustomPopOverView.h
//  CustomPopOverView
//
//  Created by zgy on 16/4/28.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CPAlignStyle) {
    CPAlignStyleCenter,
    CPAlignStyleLeft,
    CPAlignStyleRight,
};


// 小三角的高度
#define kTriangleHeight 8.0

// 小三角的宽度
#define kTriangleWidth 10.0

// 弹出视图背景的圆角半径
#define kPopOverLayerCornerRadius 5.0

// 调整弹出视图背景四周的空隙
#define kRoundMargin 10.0

@class CustomPopOverView;
@protocol CustomPopOverViewDelegate <NSObject>

@optional
- (void)popOverViewDidShow:(CustomPopOverView *)pView;
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView;

// for normal use
// 普通用法（点击菜单）的回调
- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index;


@end


@interface CustomPopOverView : UIView


@property (nonatomic,   weak) id<CustomPopOverViewDelegate> delegate;

// you can set custom view or custom viewController
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentViewController;


@property (nonatomic, strong) UIColor *containerBackgroudColor;

+ (instancetype)popOverView;

// for normal use, you can set titles, it will show as a tableview
// 简单使用的话，直接传一组菜单，会以tableview的形式展示，可以自己修改tableview属性
- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles;


- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style;

- (void)dismiss;
@end
