//
//  CustomPopOverView.m
//  CustomPopOverView
//
//  Created by zgy on 16/4/28.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "CustomPopOverView.h"


// 屏的size(宽、高)
#define kCPScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)


static BOOL __enableDebugLog = NO;

@implementation CPShowStyle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _triAngelHeight = 8.0;
        _triAngelWidth = 10.0;
        _roundMargin = 10.0;
        _showSpace = 5.f;
        _containerBorderWidth = 0.5f;
        _containerBorderColor = [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1];
        _shadowColor = [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1];
        _containerBackgroudColor = [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1];
        _containerCornerRadius = 5.0;
        _shouldDismissOnTouchOutside = YES;
        _isNeedAnimate = YES;
        _animationDuration = 0.2;
        
        // 普通用法
        _defaultRowHeight = 44.f;
        _tableBackgroundColor = [UIColor whiteColor];
        _separatorColor = [UIColor blackColor];
        _separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _textColor = [UIColor blackColor];
        _font = [UIFont systemFontOfSize:14.0];

    }
    return self;
}

- (void)dealloc
{
    if (__enableDebugLog) {
        NSLog(@"%s", __func__);
    }
}

@end


@interface CPAnimatorDelegate : NSObject <CAAnimationDelegate>

@property (nonatomic,   weak) CustomPopOverView *popView;

@end



typedef NS_ENUM(NSUInteger, FinalPosition) {
    FinalPositionDown,
    FinalPositionUp
};

// custom containerView

@interface PopOverContainerView : UIView

@property (nonatomic, strong) CAShapeLayer *popLayer;
@property (nonatomic, assign) CGFloat  apexOftriangelX; // 小三角顶部X值
@property (nonatomic, strong) CPShowStyle *style;
@property (nonatomic, assign) FinalPosition finalPosition; // 最终计算后的位置

@end

@implementation PopOverContainerView

- (instancetype)initWithStyle:(CPShowStyle *)style
{
    self = [super init];
    if (self) {
        // monitor frame property
        [self addObserver:self forKeyPath:@"frame" options:0 context:NULL];
        _style = style;
    }
    return self;
}

- (CAShapeLayer *)popLayer
{
    if (nil == _popLayer) {
        _popLayer = [[CAShapeLayer alloc]init];
        [self.layer addSublayer:_popLayer];
    }
    
    return _popLayer;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = CGRectNull;
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
            [self setLayerFrame:newFrame];
            
        }
    }
}




- (void)setLayerFrame:(CGRect)frame
{
    float apexOfTriangelX;
    if (_apexOftriangelX == 0) {
        apexOfTriangelX = frame.size.width - 60;
    }else
    {
        apexOfTriangelX = _apexOftriangelX;
    }
    
    
    CGFloat borderRadius = _style.containerCornerRadius;
    
    // triangel must between left corner and right corner
    if (apexOfTriangelX > frame.size.width - borderRadius) {
        apexOfTriangelX = frame.size.width - borderRadius - 0.5 * _style.triAngelWidth;
    }else if (apexOfTriangelX < borderRadius) {
        apexOfTriangelX = borderRadius + 0.5 * _style.triAngelWidth;
    }
    
    
    
    CGPoint point0 = CGPointMake(apexOfTriangelX, 0);
    CGPoint point1 = CGPointMake(apexOfTriangelX - 0.5 * _style.triAngelWidth, _style.triAngelHeight);
    CGPoint point2 = CGPointMake(borderRadius, _style.triAngelHeight);
    CGPoint point2_center = CGPointMake(borderRadius, _style.triAngelHeight + borderRadius);
    
    CGPoint point3 = CGPointMake(0, frame.size.height - _style.containerCornerRadius);
    CGPoint point3_center = CGPointMake(borderRadius, frame.size.height - borderRadius);
    
    CGPoint point4 = CGPointMake(frame.size.width - borderRadius, frame.size.height);
    CGPoint point4_center = CGPointMake(frame.size.width - borderRadius, frame.size.height - borderRadius);
    
    CGPoint point5 = CGPointMake(frame.size.width, _style.triAngelHeight + borderRadius);
    CGPoint point5_center = CGPointMake(frame.size.width - borderRadius, _style.triAngelHeight + borderRadius);
    
    CGPoint point6 = CGPointMake(apexOfTriangelX + 0.5 * _style.triAngelWidth, _style.triAngelHeight);
    
    
    if (_finalPosition == FinalPositionUp) {
        CGFloat maxY = CGRectGetHeight(frame);
        
        point0 = CGPointMake(apexOfTriangelX, maxY);
        point1 = CGPointMake(apexOfTriangelX - 0.5 * _style.triAngelWidth, maxY - _style.triAngelHeight);
        
        point2 = CGPointMake(borderRadius, maxY - _style.triAngelHeight);
        point2_center = CGPointMake(borderRadius, maxY - (_style.triAngelHeight + borderRadius));
        
        point3 = CGPointMake(0, maxY - (frame.size.height - borderRadius));
        point3_center = CGPointMake(borderRadius, maxY - (frame.size.height - borderRadius));
        
        point4 = CGPointMake(frame.size.width - borderRadius, maxY - frame.size.height);
        point4_center = CGPointMake(frame.size.width - borderRadius, maxY - (frame.size.height - borderRadius));
        
        point5 = CGPointMake(frame.size.width, maxY - (_style.triAngelHeight + borderRadius));
        point5_center = CGPointMake(frame.size.width - borderRadius, maxY - (_style.triAngelHeight + borderRadius));
        
        point6 = CGPointMake(apexOfTriangelX + 0.5 * _style.triAngelWidth, maxY - _style.triAngelHeight);
    }
    
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:point0];
    [path addLineToPoint:point1];
    
    [path addLineToPoint:point2];
    if (_finalPosition == FinalPositionDown) {
        [path addArcWithCenter:point2_center radius:borderRadius startAngle:3*M_PI_2 endAngle:M_PI clockwise:NO];
    }else
    {
        [path addArcWithCenter:point2_center radius:borderRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    }
    
    [path addLineToPoint:point3];
    if (_finalPosition == FinalPositionDown) {
        [path addArcWithCenter:point3_center radius:borderRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    }else
    {
        [path addArcWithCenter:point3_center radius:borderRadius startAngle:M_PI endAngle:3*M_PI_2 clockwise:YES];
    }
    

    
    [path addLineToPoint:point4];
    if (_finalPosition == FinalPositionDown) {
        [path addArcWithCenter:point4_center radius:borderRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    }else
    {
        [path addArcWithCenter:point4_center radius:borderRadius startAngle:3*M_PI_2 endAngle:0 clockwise:YES];
    }


    [path addLineToPoint:point5];
    if (_finalPosition == FinalPositionDown) {
        [path addArcWithCenter:point5_center radius:borderRadius startAngle:0 endAngle:3*M_PI_2 clockwise:NO];
    }else
    {
        [path addArcWithCenter:point5_center radius:borderRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    }
    

    [path addLineToPoint:point6];
    [path closePath];
    
    
    
    
    self.popLayer.path = path.CGPath;
    self.popLayer.fillColor = _style.containerBackgroudColor ? _style.containerBackgroudColor.CGColor : [UIColor orangeColor].CGColor;
    
    
    CGFloat lineWidth = _style.containerBorderWidth;
    
    if (lineWidth > 0.4) {
        self.popLayer.lineWidth = lineWidth;
        self.popLayer.strokeColor = _style.containerBorderColor.CGColor;
    }else
    {
        self.popLayer.borderWidth = 0;
    }
    
    if (_style.shadowColor) {
        self.popLayer.shadowPath = path.CGPath;
        self.popLayer.shadowOffset = CGSizeMake(0, 3);
        self.popLayer.shadowOpacity = 0.75;
        self.popLayer.shadowColor = _style.shadowColor.CGColor;
    }
    
}

- (void)setApexOftriangelX:(CGFloat)apexOftriangelX
{
    _apexOftriangelX = apexOftriangelX;
    [self setLayerFrame:self.frame];
    
}

//- (void)didMoveToSuperview
//{
//    [super didMoveToSuperview];
//    
//    
//    
//}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
    if (__enableDebugLog) {
        NSLog(@"%s", __func__);
    }
}




@end


                /*==================================IMPLEMENTATION=================================================*/

@interface CustomPopOverView () <UITableViewDelegate, UITableViewDataSource>
{
    CGRect _contentOrignFrame;
}
@property (nonatomic, strong) PopOverContainerView *containerView; // black backgroud container
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *titleMenus;
@property (nonatomic, strong) NSArray *titleInfoes;

@property (nonatomic, assign) CPAlignStyle alignStyle;
@property (nonatomic, assign) CPContentPosition contentPosition;
@property (nonatomic,   weak) UIView *showFrom;


@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) CPAnimatorDelegate *animatorDelegate;

@end


static NSString* _dimissAnimationKey = @"_dimissAnimation";

@implementation CustomPopOverView

+ (instancetype)popOverView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
    return self;
}

- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles style:(CPShowStyle *)style
{
    self = [super initWithFrame:bounds];
    if (self) {
        _style = style;
        self.titleMenus = titles;
        
        self.table.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.table.delegate = self;
        self.table.dataSource = self;
        _table.scrollEnabled = NO;
        [self setContent:self.table];
        
        
        if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
            //让线头不留白
            [_table setSeparatorInset:UIEdgeInsetsZero];
            
        }
        if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [_table setLayoutMargins:UIEdgeInsetsZero];
            
        }
    }
    return self;
}

- (instancetype)initWithBounds:(CGRect)bounds titleInfo:(NSArray <NSDictionary<NSString *,NSString *> *>*)infoes style:(CPShowStyle *)style
{
    self = [super initWithFrame:bounds];
    if (self) {
        _style = style;
        self.titleInfoes = infoes;
        
        self.table.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.table.delegate = self;
        self.table.dataSource = self;
        
        [self setContent:self.table];
        
        _table.scrollEnabled = NO;
        if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
            //让线头不留白
            [_table setSeparatorInset:UIEdgeInsetsZero];
            
        }
        if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [_table setLayoutMargins:UIEdgeInsetsZero];
            
        }
    }
    return self;
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    CGRect contentFrame = content.frame;
    
    contentFrame.origin.x = self.style.roundMargin;
    contentFrame.origin.y = self.style.triAngelHeight + self.style.roundMargin;
    content.frame = contentFrame;
    
    
    _contentOrignFrame = contentFrame;
    
    CGRect  temp = self.containerView.frame;
    temp.size.width = CGRectGetMaxX(contentFrame) + self.style.roundMargin; // left and right space
    temp.size.height = CGRectGetMaxY(contentFrame) + self.style.roundMargin;
    
    self.containerView.frame = temp;
    
    [self.containerView addSubview:content];
    
    if (_table) {
        [_table addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    }
    

}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    [self setContent:_contentViewController.view];
    
}

- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style
{
    [self showFrom:from alignStyle:style relativePosition:CPContentPositionAutomaticDownFirst];
}

- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style relativePosition:(CPContentPosition)position
{
    _contentPosition = position;
    self.showFrom = from;
    _alignStyle = style;
    
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    [self updateSubViewFrames];
    
    if ([self.delegate respondsToSelector:@selector(popOverViewDidShow:)]) {
        [self.delegate popOverViewDidShow:self];
    }
    
    if (self.style.isNeedAnimate) {
        // animations support
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.1;
        scaleAnimation.toValue = @1.0;
        scaleAnimation.duration = _style.animationDuration;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @0.0;
        alphaAnimation.toValue = @1.0;
        alphaAnimation.duration = _style.animationDuration;
        alphaAnimation.removedOnCompletion = NO;
        alphaAnimation.fillMode = kCAFillModeForwards;
        
        CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
        group.animations = @[scaleAnimation, alphaAnimation];
        group.timingFunction = [CAMediaTimingFunction functionWithName:@"easeIn"];
        
        [self.containerView.layer addAnimation:group forKey:@"containerAnimate0"];
        
        
        self.alpha = 0;
        [UIView animateWithDuration:_style.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 1;
        } completion:nil];
    }
    
    
}




- (void)dismiss
{
    if (self.style.isNeedAnimate) {
        // animations support

        if (_isAnimating) {
            [self resetAnimationStatus];
            return;
        }
        
        
        _isAnimating = YES;
        [self resetAnimationStatus];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.0;
        scaleAnimation.toValue = @0.85;
        scaleAnimation.duration = _style.animationDuration;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1.0;
        alphaAnimation.toValue = @0.0;
        alphaAnimation.duration = _style.animationDuration;
        alphaAnimation.removedOnCompletion = NO;
        alphaAnimation.fillMode = kCAFillModeForwards;
        
        
        CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
        group.animations = @[scaleAnimation, alphaAnimation];
        group.delegate = self.animatorDelegate;
        group.removedOnCompletion = NO;
        group.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
        
        [self.containerView.layer addAnimation:group forKey:_dimissAnimationKey];
        
        [UIView animateWithDuration:_style.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.1;
        } completion:nil];
        
    }else
    {
        [self removeFromSuperview];
    }
    
    
    
    
    if ([self.delegate respondsToSelector:@selector(popOverViewDidDismiss:)]) {
        [self.delegate popOverViewDidDismiss:self];
    }
}

- (void)resetAnimationStatus
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isAnimating = NO;
    });
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGRect rect = [self.containerView convertRect:self.containerView.bounds toView:self];
    if (!CGRectContainsPoint(rect, [tch locationInView:self])) {
        if (self.style.shouldDismissOnTouchOutside) {
            [self dismiss];
        }
    }
}

- (void)updateSubViewFrames
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.frame = window.bounds;
    
    // 默认向下计算
    self.containerView.finalPosition = FinalPositionDown;
    
    if (!_showFrom) {
        
        self.containerView.center = self.center;
        return;
    }
    
    CGRect newFrame = [_showFrom convertRect:_showFrom.bounds toView:window];

    CGRect containerViewFrame = self.containerView.frame;
    
    UIEdgeInsets safeInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        if (window.safeAreaInsets.bottom > 0) {
            // 刘海屏使用对应的safeInsets
            safeInsets = window.safeAreaInsets;
        }
    }
    
    
    
    CGRect contentFrame = _contentOrignFrame;
    
    switch (_contentPosition) {
        case CPContentPositionAlwaysDown:
        {
            self.containerView.finalPosition = FinalPositionDown;
            containerViewFrame.origin.y =  CGRectGetMaxY(newFrame) + self.style.showSpace;
        }
            break;
        case CPContentPositionAlwaysUp:
        {
            self.containerView.finalPosition = FinalPositionUp;
            containerViewFrame.origin.y = CGRectGetMinY(newFrame) - self.style.showSpace - containerViewFrame.size.height;
        
            contentFrame.origin.y = self.style.roundMargin;
        }
            break;
            
            case CPContentPositionAutomaticUpFirst:
        {
            containerViewFrame.origin.y = CGRectGetMinY(newFrame) - self.style.showSpace - containerViewFrame.size.height;
            self.containerView.finalPosition = FinalPositionUp;
            contentFrame.origin.y = self.style.roundMargin;
            
            if (CGRectGetMinY(containerViewFrame) < safeInsets.top) {
                // 超出屏幕， 向下
                self.containerView.finalPosition = FinalPositionDown;
                containerViewFrame.origin.y = CGRectGetMaxY(newFrame) + self.style.showSpace;
                contentFrame.origin.y = self.style.triAngelHeight + self.style.roundMargin;
            }
        }
            break;
            
        default:
        {
            containerViewFrame.origin.y =  CGRectGetMaxY(newFrame) + self.style.showSpace;
            self.containerView.finalPosition = FinalPositionDown;
            
            
            CGFloat totalHeight = kCPScreenSize.height;
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            if (!(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)) {
                totalHeight = kCPScreenSize.width;
            }
            
            if (CGRectGetMaxY(containerViewFrame) > (totalHeight - safeInsets.bottom)) {
                // 超出屏幕， 向上
                self.containerView.finalPosition = FinalPositionUp;
                containerViewFrame.origin.y = CGRectGetMinY(newFrame) - self.style.showSpace - containerViewFrame.size.height;
                contentFrame.origin.y = self.style.roundMargin;
            }
        }
            break;
    }
    
    self.content.frame = contentFrame;
    self.containerView.frame = containerViewFrame;
    
    
    switch (_alignStyle) {
        case CPAlignStyleCenter:
        {
            CGPoint center = self.containerView.center;
            center.x = CGRectGetMidX(newFrame);
            self.containerView.center = center;
            
            self.containerView.apexOftriangelX = CGRectGetWidth(self.containerView.frame)/2;
        }
            break;
        case CPAlignStyleLeft:
        {
            CGRect frame = self.containerView.frame;
            frame.origin.x = CGRectGetMinX(newFrame);
            self.containerView.frame = frame;
            
            self.containerView.apexOftriangelX = CGRectGetWidth(_showFrom.frame)/2;
        }
            
            break;
        case CPAlignStyleRight:
        {
            CGRect frame = self.containerView.frame;
            frame.origin.x = CGRectGetMinX(newFrame) - (fabs(frame.size.width - newFrame.size.width));
            self.containerView.frame = frame;
            
            self.containerView.apexOftriangelX = CGRectGetWidth(self.containerView.frame) - CGRectGetWidth(_showFrom.frame)/2;
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateSubViewFrames];
}


#pragma mark- KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentSize"]) {
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            CGSize contentSize = [[object valueForKeyPath:keyPath] CGSizeValue];
            if (contentSize.height > _contentOrignFrame.size.height+1) {
                _table.scrollEnabled = YES;
            }else
            {
                _table.scrollEnabled = NO;
            }
            
        }
    }
}


#pragma mark- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleMenus.count?:self.titleInfoes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GYPopOverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSString *text;
    NSString *icon;
    if (self.titleMenus.count) {
        text = self.titleMenus[indexPath.row];
    }
    
    if (self.titleInfoes.count) {
        NSDictionary *dic = self.titleInfoes[indexPath.row];
        text = dic[@"name"];
        icon = dic[@"icon"];
    }
    
    cell.textLabel.text = text;
    cell.textLabel.textColor = self.style.textColor;
    cell.textLabel.font = self.style.font;
    cell.textLabel.textAlignment = self.style.textAlignment;
    if (icon.length) {
        cell.imageView.image = [UIImage imageNamed:icon];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(popOverView:didClickMenuIndex:)]) {
        [self.delegate popOverView:self didClickMenuIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


#pragma mark- lazy
- (PopOverContainerView *)containerView
{
    if (nil == _containerView) {
        _containerView = [[PopOverContainerView alloc]initWithStyle:self.style];
        [self addSubview:_containerView];
    }
    
    return _containerView;
}

- (UITableView *)table
{
    if (nil == _table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        //        _table.backgroundView = nil;
        _table.backgroundColor = self.style.tableBackgroundColor;
        _table.separatorColor = self.style.separatorColor;
        _table.rowHeight = self.style.defaultRowHeight?:44.f;
        _table.separatorStyle = self.style.separatorStyle;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}
- (CPShowStyle *)style
{
    if (nil == _style) {
        _style = [CPShowStyle new];
    }
    return _style;
}

- (CPAnimatorDelegate *)animatorDelegate
{
    if (nil == _animatorDelegate) {
        _animatorDelegate = [[CPAnimatorDelegate alloc]init];
        _animatorDelegate.popView = self;
    }
    return _animatorDelegate;
}


#pragma mark- 
- (void)dealloc
{
    [_table removeObserver:self forKeyPath:@"contentSize"];
    if (__enableDebugLog) {
        NSLog(@"%s", __func__);
    }
}

@end






#pragma mark- CPAnimatorDelegate Implementations
@implementation CPAnimatorDelegate

// CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 动画完成
    if (flag) {
        if (self.popView) {
            CAAnimation *dissmissAnimation = [self.popView.containerView.layer animationForKey:_dimissAnimationKey];
            if (dissmissAnimation == anim) {
                [self.popView setValue:@(NO) forKeyPath:@"isAnimating"];
                [self.popView removeFromSuperview];
            }
        }
        
    }
}

- (void)dealloc
{
    if (__enableDebugLog) {
        NSLog(@"%s", __func__);
    }
}

@end
