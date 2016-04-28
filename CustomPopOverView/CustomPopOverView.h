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


#define kTriangleHeight 8.0
#define kTriangleWidth 10.0
#define kPopOverLayerCornerRadius 5.0

@class CustomPopOverView;
@protocol CustomPopOverViewDelegate <NSObject>

@optional
- (void)popOverViewDidShow:(CustomPopOverView *)pView;
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView;

// for normal use
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
- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles;


- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style;

- (void)dismiss;
@end
