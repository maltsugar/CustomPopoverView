//
//  CustomTipView.m
//  CustomPopOverView
//
//  Created by zgy on 2024/9/20.
//  Copyright © 2024 zgy. All rights reserved.
//

#import "CustomTipView.h"
#import "CustomPopOverView.h"


@implementation CustomTipView




+ (void)showTipViewFrom:(UIView *)sender
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    CustomTipView *tipView = [arr lastObject];
    tipView.bounds = CGRectMake(0, 0, 370, 166);
    tipView.layer.cornerRadius = 5;
    tipView.clipsToBounds = YES;
    
    
    CPShowStyle *style = [CPShowStyle new];
    style.triAngelHeight = 10.0;
    style.triAngelWidth = 7.0;
    style.containerCornerRadius = 5.0;
    style.roundMargin = 0;
    style.containerBackgroudColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    CustomPopOverView *view = [CustomPopOverView popOverView];
    view.style = style;
    view.content = tipView;
    
    [view showFrom:sender alignStyle:CPAlignStyleAuto];
}

@end
