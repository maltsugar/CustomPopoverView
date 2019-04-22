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



typedef NS_ENUM(NSUInteger, CPContentPosition) {
    CPContentPositionAlwaysDown,                // 总是在控件下面
    CPContentPositionAlwaysUp,                  // 总是在控件上面
    CPContentPositionAutomaticDownFirst,        // 自动根据屏幕调整， 优先向下（缺省）
    CPContentPositionAutomaticUpFirst,          // 自动根据屏幕调整， 优先向上
};

@class CustomPopOverView;
@protocol CustomPopOverViewDelegate <NSObject>

@optional
- (void)popOverViewDidShow:(CustomPopOverView *)pView;
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView;

// for normal use
// 普通用法（点击菜单）的回调
- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index;


@end



// 样式类
@interface CPShowStyle : NSObject

@property (nonatomic, assign) CGFloat showSpace; // 视图出现时与目标view的间隙
@property (nonatomic, assign) CGFloat triAngelHeight; // 小三角的高度
@property (nonatomic, assign) CGFloat triAngelWidth; // 小三角的宽度


@property (nonatomic, assign) CGFloat roundMargin; // 调整弹出视图背景四周的空隙
@property (nonatomic, strong) UIColor *shadowColor; // 阴影颜色 默认#666666
@property (nonatomic, strong) UIColor *containerBackgroudColor; // 弹出视图背景色 默认#eeeeee
@property (nonatomic, assign) CGFloat containerCornerRadius; // 弹出视图背景的圆角半径
@property (nonatomic, assign) CGFloat containerBorderWidth; // 边框宽度默认0.5( 必须 >= 0.5)
@property (nonatomic, strong) UIColor *containerBorderColor; // 边框颜色 默认#666666



@property (nonatomic, assign) BOOL shouldDismissOnTouchOutside; // 点击空白区域是否消失（默认YES）
@property (nonatomic, assign) BOOL isNeedAnimate; // 开始和消失动画(默认YES)
@property (nonatomic, assign) CGFloat animationDuration; // 0.2s

// 普通用法配置
@property (nonatomic, assign) CGFloat defaultRowHeight; // row高度
@property (nonatomic, strong) UIColor *tableBackgroundColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;


@end



@interface CustomPopOverView : UIView

// 首先设置显示样式
@property (nonatomic, strong) CPShowStyle *style;

@property (nonatomic,   weak) id<CustomPopOverViewDelegate> delegate;

// you can set custom view or custom viewController
// 设置内容之前，先设置 "样式参数"
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentViewController;


+ (instancetype)popOverView;

// for normal use, you can set titles, it will show as a tableview
// 简单使用的话，直接传一组菜单，会以tableview的形式展示，可以自己修改tableview属性
- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles style:(CPShowStyle *)style;


// infoes 里是字典@{@"name": @"foo", @"icon": @"bar"}
- (instancetype)initWithBounds:(CGRect)bounds titleInfo:(NSArray <NSDictionary<NSString *,NSString *> *>*)infoes style:(CPShowStyle *)style;





/**
 展示弹出视图

 @param from 呼出控件，nil则表示在屏幕中心
 @param style 对齐方式， 内容相对呼出控件位置自动控制
 */
- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style;


/**
 展示弹出视图

 @param from 呼出控件，nil则表示在屏幕中心
 @param style 对齐方式
 @param position 内容相对于呼出控件位置（必须有呼出控件，否则就是屏幕中心，自定义alertView是这种模式）
 */
- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style relativePosition:(CPContentPosition)position;


- (void)dismiss;
@end
