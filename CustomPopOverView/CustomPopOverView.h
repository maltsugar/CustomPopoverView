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

@class CustomPopOverView;
@protocol CustomPopOverViewDelegate <NSObject>

@optional
- (void)popOverViewDidShow:(CustomPopOverView *)pView;
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView;

// for normal use
// 普通用法（点击菜单）的回调
- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index;


@end



// 配置类
@interface PopOverVieConfiguration : NSObject

@property (nonatomic, assign) float triAngelHeight; // 小三角的高度
@property (nonatomic, assign) float triAngelWidth; // 小三角的宽度
@property (nonatomic, assign) float containerViewCornerRadius; // 弹出视图背景的圆角半径
@property (nonatomic, assign) float roundMargin; // 调整弹出视图背景四周的空隙


// 普通用法配置
@property (nonatomic, assign) float defaultRowHeight; // row高度
@property (nonatomic, strong) UIColor *tableBackgroundColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;


@end



@interface CustomPopOverView : UIView


@property (nonatomic, strong) PopOverVieConfiguration *config;

@property (nonatomic,   weak) id<CustomPopOverViewDelegate> delegate;

// you can set custom view or custom viewController
// 设置内容之前，先配置参数
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentViewController;


@property (nonatomic, strong) UIColor *containerBackgroudColor;

+ (instancetype)popOverView;

// for normal use, you can set titles, it will show as a tableview
// 简单使用的话，直接传一组菜单，会以tableview的形式展示，可以自己修改tableview属性
- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles config:(PopOverVieConfiguration *)config;


// infoes 里是字典@{@"name": @"foo", @"icon": @"bar"}
- (instancetype)initWithBounds:(CGRect)bounds titleInfo:(NSArray <NSDictionary<NSString *,NSString *> *>*)infoes config:(PopOverVieConfiguration *)config;




- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style;

- (void)dismiss;
@end
