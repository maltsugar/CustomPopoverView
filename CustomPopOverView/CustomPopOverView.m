//
//  CustomPopOverView.m
//  CustomPopOverView
//
//  Created by zgy on 16/4/28.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "CustomPopOverView.h"


@implementation PopOverVieConfiguration
- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldDismissOnTouchOutside = YES;
        _isNeedAnimate = YES;
    }
    return self;
}

@end


// custom containerView

@interface PopOverContainerView : UIView

@property (nonatomic, strong) CAShapeLayer *popLayer;
@property (nonatomic, assign) CGFloat  apexOftriangelX;
@property (nonatomic, strong) UIColor *layerColor;
@property (nonatomic, strong) PopOverVieConfiguration *config;
@end

@implementation PopOverContainerView

- (instancetype)initWithConfig:(PopOverVieConfiguration *)config
{
    self = [super init];
    if (self) {
        // monitor frame property
        [self addObserver:self forKeyPath:@"frame" options:0 context:NULL];
        _config = config;
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
    if (apexOfTriangelX > frame.size.width - _config.containerViewCornerRadius) {
        apexOfTriangelX = frame.size.width - _config.containerViewCornerRadius - 0.5 * _config.triAngelWidth;
    }else if (apexOfTriangelX < _config.containerViewCornerRadius) {
        apexOfTriangelX = _config.containerViewCornerRadius + 0.5 * _config.triAngelWidth;
    }
    
    
    CGPoint point0 = CGPointMake(apexOfTriangelX, 0);
    CGPoint point1 = CGPointMake(apexOfTriangelX - 0.5 * _config.triAngelWidth, _config.triAngelHeight);
    CGPoint point2 = CGPointMake(_config.containerViewCornerRadius, _config.triAngelHeight);
    CGPoint point2_center = CGPointMake(_config.containerViewCornerRadius, _config.triAngelHeight + _config.containerViewCornerRadius);
    
    CGPoint point3 = CGPointMake(0, frame.size.height - _config.containerViewCornerRadius);
    CGPoint point3_center = CGPointMake(_config.containerViewCornerRadius, frame.size.height - _config.containerViewCornerRadius);
    
    CGPoint point4 = CGPointMake(frame.size.width - _config.containerViewCornerRadius, frame.size.height);
    CGPoint point4_center = CGPointMake(frame.size.width - _config.containerViewCornerRadius, frame.size.height - _config.containerViewCornerRadius);
    
    CGPoint point5 = CGPointMake(frame.size.width, _config.triAngelHeight + _config.containerViewCornerRadius);
    CGPoint point5_center = CGPointMake(frame.size.width - _config.containerViewCornerRadius, _config.triAngelHeight + _config.containerViewCornerRadius);
    
    CGPoint point6 = CGPointMake(apexOfTriangelX + 0.5 * _config.triAngelWidth, _config.triAngelHeight);
    
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point0];
    [path addLineToPoint:point1];
    [path addLineToPoint:point2];
    [path addArcWithCenter:point2_center radius:_config.containerViewCornerRadius startAngle:3*M_PI_2 endAngle:M_PI clockwise:NO];
    
    [path addLineToPoint:point3];
    [path addArcWithCenter:point3_center radius:_config.containerViewCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    
    [path addLineToPoint:point4];
    [path addArcWithCenter:point4_center radius:_config.containerViewCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    
    [path addLineToPoint:point5];
    [path addArcWithCenter:point5_center radius:_config.containerViewCornerRadius startAngle:0 endAngle:3*M_PI_2 clockwise:NO];
    
    [path addLineToPoint:point6];
    [path closePath];
    
    
    
    self.popLayer.path = path.CGPath;
    self.popLayer.fillColor = _layerColor? _layerColor.CGColor : [UIColor orangeColor].CGColor;
    
    
    
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
}




@end


                /*==================================IMPLEMENTATION=================================================*/





@interface CustomPopOverView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PopOverContainerView *containerView; // black backgroud container
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *titleMenus;
@property (nonatomic, strong) NSArray *titleInfoes;

@property (nonatomic, assign) CPAlignStyle alignStyle;
@property (nonatomic,   weak) UIView *showFrom;

@end


@implementation CustomPopOverView

+ (instancetype)popOverView
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefaultConfig];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cpScreenOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultConfig];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cpScreenOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles config:(PopOverVieConfiguration *)config
{
    self = [super initWithFrame:bounds];
    if (self) {
        if (!config) {
            [self initDefaultConfig];
        }else
        {
            _config = config;
        }
        
        self.titleMenus = titles;
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cpScreenOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithBounds:(CGRect)bounds titleInfo:(NSArray <NSDictionary<NSString *,NSString *> *>*)infoes config:(PopOverVieConfiguration *)config
{
    self = [super initWithFrame:bounds];
    if (self) {
        if (!config) {
            [self initDefaultConfig];
        }else
        {
            _config = config;
        }
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cpScreenOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)initDefaultConfig
{
    _config = [PopOverVieConfiguration new];
    _config.triAngelHeight = 8.0;
    _config.triAngelWidth = 10.0;
    _config.containerViewCornerRadius = 5.0;
    _config.roundMargin = 10.0;
    _config.showSpace = 5.f;
    
    // 普通用法
    _config.defaultRowHeight = 44.f;
    _config.tableBackgroundColor = [UIColor whiteColor];
    _config.separatorColor = [UIColor blackColor];
    _config.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _config.textColor = [UIColor blackColor];
    _config.font = [UIFont systemFontOfSize:14.0];
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    CGRect contentFrame = content.frame;
    
    contentFrame.origin.x = _config.roundMargin;
    contentFrame.origin.y = _config.triAngelHeight + _config.roundMargin;
    content.frame = contentFrame;
    
    
    CGRect  temp = self.containerView.frame;
    temp.size.width = CGRectGetMaxX(contentFrame) + _config.roundMargin; // left and right space
    temp.size.height = CGRectGetMaxY(contentFrame) + _config.roundMargin;
    
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
    _showFrom = from;
    _alignStyle = style;
    
    // 此方法找到的window会在模态弹出时不准确
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    [self updateSubViewFrames];
    
    if ([self.delegate respondsToSelector:@selector(popOverViewDidShow:)]) {
        [self.delegate popOverViewDidShow:self];
    }
    
    if (_config.isNeedAnimate) {
        // animations support
        self.containerView.transform = CGAffineTransformMakeScale(1.1,1.1);
        self.containerView.alpha = 0;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.containerView.transform = CGAffineTransformMakeScale(1.0,1.0);
        self.containerView.alpha = 1;
        [UIView commitAnimations];
    }
    
    
}



- (void)dismiss
{
    if (_config.isNeedAnimate) {
        // animations support
        [UIView animateWithDuration:0.2 animations:^{
            self.containerView.transform = CGAffineTransformMakeScale(0.9,0.9);
            self.containerView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else
    {
        [self removeFromSuperview];
    }
    
    
    
    
    if ([self.delegate respondsToSelector:@selector(popOverViewDidDismiss:)]) {
        [self.delegate popOverViewDidDismiss:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.config.shouldDismissOnTouchOutside) {
        [self dismiss];
    }
}

- (void)updateSubViewFrames
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.frame = window.bounds;
    
    if (!_showFrom) {
        
        self.containerView.center = self.center;
        return;
    }
    
    CGRect newFrame = [_showFrom convertRect:_showFrom.bounds toView:window];
    
    
    // change containerView position
    CGRect containerViewFrame = self.containerView.frame;
    containerViewFrame.origin.y =  CGRectGetMaxY(newFrame) + _config.showSpace;
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

#pragma mark- Notis

- (void)cpScreenOrientationChange
{
    [self updateSubViewFrames];
}

#pragma mark- lazy
- (PopOverContainerView *)containerView
{
    if (nil == _containerView) {
        _containerView = [[PopOverContainerView alloc]initWithConfig:_config];
        [self addSubview:_containerView];
    }
    
    return _containerView;
}

- (UITableView *)table
{
    if (nil == _table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        //        _table.backgroundView = nil;
        _table.backgroundColor = _config.tableBackgroundColor;
        _table.separatorColor = _config.separatorColor;
        _table.rowHeight = _config.defaultRowHeight?:44.f;
        _table.separatorStyle = _config.separatorStyle?:UITableViewCellSeparatorStyleSingleLine;
        _table.tableFooterView = [UIView new];
    }
    return _table;
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
    cell.textLabel.textColor = _config.textColor;
    cell.textLabel.font = _config.font;
    cell.textLabel.textAlignment = _config.textAlignment;
    cell.imageView.image = [UIImage imageNamed:icon];
    
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

#pragma mark- 
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NSLog(@"%s", __func__);
}

@end


