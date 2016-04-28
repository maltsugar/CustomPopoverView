//
//  CustomPopOverView.m
//  CustomPopOverView
//
//  Created by zgy on 16/4/28.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "CustomPopOverView.h"


// custom containerView

@interface PopOverContainerView : UIView

@property (nonatomic, strong) CAShapeLayer *popLayer;
@property (nonatomic, assign) CGFloat  apexOftriangelX;
@property (nonatomic, strong) UIColor *layerColor;


@end

@implementation PopOverContainerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // monitor frame property
        [self addObserver:self forKeyPath:@"frame" options:0 context:NULL];
        
        
        
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
    
    
    // triangel must between left corner and right corner
    if (apexOfTriangelX > frame.size.width - kPopOverLayerCornerRadius) {
        apexOfTriangelX = frame.size.width - kPopOverLayerCornerRadius - 0.5 * kTriangleWidth;
    }else if (apexOfTriangelX < kPopOverLayerCornerRadius) {
        apexOfTriangelX = kPopOverLayerCornerRadius + 0.5 * kTriangleWidth;
    }
    
    
    CGPoint point0 = CGPointMake(apexOfTriangelX, 0);
    CGPoint point1 = CGPointMake(apexOfTriangelX - 0.5 * kTriangleWidth, kTriangleHeight);
    CGPoint point2 = CGPointMake(kPopOverLayerCornerRadius, kTriangleHeight);
    CGPoint point2_center = CGPointMake(kPopOverLayerCornerRadius, kTriangleHeight + kPopOverLayerCornerRadius);
    
    CGPoint point3 = CGPointMake(0, frame.size.height - kPopOverLayerCornerRadius);
    CGPoint point3_center = CGPointMake(kPopOverLayerCornerRadius, frame.size.height - kPopOverLayerCornerRadius);
    
    CGPoint point4 = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, frame.size.height);
    CGPoint point4_center = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, frame.size.height - kPopOverLayerCornerRadius);
    
    CGPoint point5 = CGPointMake(frame.size.width, kTriangleHeight + kPopOverLayerCornerRadius);
    CGPoint point5_center = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, kTriangleHeight + kPopOverLayerCornerRadius);
    
    CGPoint point6 = CGPointMake(apexOfTriangelX + 0.5 * kTriangleWidth, kTriangleHeight);
    
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point0];
    [path addLineToPoint:point1];
    [path addLineToPoint:point2];
    [path addArcWithCenter:point2_center radius:kPopOverLayerCornerRadius startAngle:3*M_PI_2 endAngle:M_PI clockwise:NO];
    
    [path addLineToPoint:point3];
    [path addArcWithCenter:point3_center radius:kPopOverLayerCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    
    [path addLineToPoint:point4];
    [path addArcWithCenter:point4_center radius:kPopOverLayerCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    
    [path addLineToPoint:point5];
    [path addArcWithCenter:point5_center radius:kPopOverLayerCornerRadius startAngle:0 endAngle:3*M_PI_2 clockwise:NO];
    
    [path addLineToPoint:point6];
    [path closePath];
    
    
    
    self.popLayer.path = path.CGPath;
    self.popLayer.fillColor = _layerColor? _layerColor.CGColor : [UIColor greenColor].CGColor;
    
    
    
}

- (void)setApexOftriangelX:(CGFloat)apexOftriangelX
{
    _apexOftriangelX = apexOftriangelX;
    [self setLayerFrame:self.frame];
    
}

- (void)setLayerColor:(UIColor *)layerColor
{
    _layerColor = layerColor;
    [self setLayerFrame:self.frame];
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}




@end


                /*==================================IMPLEMENTATION=================================================*/





@interface CustomPopOverView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PopOverContainerView *containerView; // black backgroud container
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *titleMenus;


@end


@implementation CustomPopOverView

- (PopOverContainerView *)containerView
{
    if (nil == _containerView) {
        _containerView = [[PopOverContainerView alloc]init];
        [self addSubview:_containerView];
    }
    
    return _containerView;
}

- (UITableView *)table
{
    if (nil == _table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.tableFooterView = [UIView new];
    }
    return _table;
}


- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles
{
    self = [super initWithFrame:bounds];
    if (self) {
        self.titleMenus = titles;
        
        self.table.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.table.delegate = self;
        self.table.dataSource = self;
        
        [self setContent:self.table];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return self;
}

+ (instancetype)popOverView
{
    return [[self alloc]init];
}


- (void)setContent:(UIView *)content
{
    _content = content;
    
    CGRect contentFrame = content.frame;
    
    contentFrame.origin.x = 5;
    contentFrame.origin.y = kTriangleHeight + 5;
    content.frame = contentFrame;
    
    
    CGRect  temp = self.containerView.frame;
    temp.size.width = CGRectGetMaxX(contentFrame) + 5; // left and right space are 2.0
    temp.size.height = CGRectGetMaxY(contentFrame) + 5;
    
    self.containerView.frame = temp;
    
    [self.containerView addSubview:content];
    
    
    
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    [self setContent:_contentViewController.view];
    
}

- (void)setContainerBackgroudColor:(UIColor *)containerBackgroudColor
{
    _containerBackgroudColor = containerBackgroudColor;
    self.containerView.layerColor = _containerBackgroudColor;
}




- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:self];
    
    self.frame = window.bounds;
    
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    
    
    // change containerView position
    CGRect containerViewFrame = self.containerView.frame;
    containerViewFrame.origin.y =  CGRectGetMaxY(newFrame) + 5;
    self.containerView.frame = containerViewFrame;
    
    
    switch (style) {
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
            
            self.containerView.apexOftriangelX = CGRectGetWidth(from.frame)/2;
        }
            
            break;
        case CPAlignStyleRight:
        {
            CGRect frame = self.containerView.frame;
            frame.origin.x = CGRectGetMinX(newFrame) - (fabs(frame.size.width - newFrame.size.width));
            self.containerView.frame = frame;
            
            self.containerView.apexOftriangelX = CGRectGetWidth(self.containerView.frame) - CGRectGetWidth(from.frame)/2;
        }
            
            break;
            
        default:
            break;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(popOverViewDidShow:)]) {
        [self.delegate popOverViewDidShow:self];
    }
}

- (void)dismiss
{
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(popOverViewDidDismiss:)]) {
        [self.delegate popOverViewDidDismiss:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

#pragma mark- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleMenus.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GYPopOverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.titleMenus[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(popOverView:didClickMenuIndex:)]) {
        [self.delegate popOverView:self didClickMenuIndex:indexPath.row];
    }
}
@end


