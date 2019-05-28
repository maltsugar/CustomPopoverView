//
//  ViewController.m
//  CustomPopOverView
//
//  Created by zgy on 16/4/28.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "ViewController.h"
#import "CustomPopOverView.h"


#define RGBCOLOR(r,g,b)		[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]


#define kGYCancelSameActionInTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
    shouldPrevent = NO; \
}); \

@interface ViewController () <CustomPopOverViewDelegate>
{
    UIButton *_rightBtn;
    
    UIButton *_leftBtn;
    
    NSArray *_titles;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [rightBtn addTarget:self action:@selector(handleRightClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    _rightBtn = rightBtn;
    
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x222222); // 背景色
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // items字体色
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    NSFontAttributeName: [UIFont systemFontOfSize:18.0f]
                                                                    };

    
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [leftBtn addTarget:self action:@selector(handleLeftClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    _leftBtn = leftBtn;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame= CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame= CGRectMake(0, 0, 40, 40);
    [btn1 setImage:[UIImage imageNamed:@"ger_add"] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -5;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spacer, btn_right, btn_right1, nil];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


- (void)optionClick:(UIButton *)sender
{
    
    NSArray *menus = @[@"清空已完成", @"清空全部"];
    CPShowStyle *style = [CPShowStyle new];
    style.roundMargin = 5;
    style.triAngelHeight = 0.0;
    style.triAngelWidth = 0.0;
    style.containerCornerRadius = 5.0;
    style.roundMargin = 10.0;
    style.showSpace = 5.f;
    style.containerBackgroudColor = RGBCOLOR(64, 64, 64);
    style.containerBorderColor = UIColor.orangeColor;
    style.containerBorderWidth = 2;
    
    
    CustomPopOverView *pView = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 300) titleMenus:menus style:style];
    pView.delegate = self;
    [pView showFrom:nil alignStyle:CPAlignStyleRight];

}

- (void)handleLeftClick {
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
    vc.view.frame = CGRectMake(0, 0, 200, 200);
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 100)];
    lab.center = vc.view.center;
    lab.text = @"I'm viewController's view";
    lab.numberOfLines = 0;
    [vc.view addSubview:lab];
    
    
    CustomPopOverView *view = [CustomPopOverView popOverView];
    view.style.containerBorderWidth = 0.5;
    view.style.containerBorderColor = UIColor.lightGrayColor;
//    view.style.isNeedAnimate = NO;
    
    view.contentViewController = vc;
    
    [view showFrom:_leftBtn alignStyle:CPAlignStyleLeft relativePosition:CPContentPositionAutomaticUpFirst];
    
}

- (IBAction)testClick:(UIButton *)sender {
    
    kGYCancelSameActionInTime(1);

    _titles = @[@"Menu1", @"Menu2", @"Ah_Menu3"];
    CPShowStyle *style = [CPShowStyle new];
    style.triAngelHeight = 6.0;
    style.triAngelWidth = 10.0;
    style.containerCornerRadius = 15.0;
    style.roundMargin = 10.0;
    style.defaultRowHeight = 30;
    style.showSpace = 5;
    style.tableBackgroundColor = [UIColor grayColor];
    style.textColor = [UIColor orangeColor];
    style.textAlignment = NSTextAlignmentLeft;
    style.containerBackgroudColor = [UIColor blueColor];
    
    NSArray *arr = @[
                     @{@"name": @"羽毛球", @"icon": @"icon_badminton"},
                     @{@"name": @"篮球", @"icon": @"icon_basketball"},
                     @{@"name": @"足球", @"icon": @"icon_football"},
                     @{@"name": @"更多", @"icon": @"icon_more"}
                     ];
    
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 200, 30*4) titleInfo:arr style:style];
    view.delegate = self;
    [view showFrom:sender alignStyle:CPAlignStyleCenter];
    
    
    
}
- (IBAction)testClick2:(UIButton *)sender {
    
    CustomPopOverView *view = [CustomPopOverView popOverView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn.bounds = CGRectMake(0, 0, 160, 40);
    
    view.style.containerBorderColor = UIColor.purpleColor;
    
    view.content = btn;
//    view.backgroundColor = UIColor.orangeColor;
    [view showFrom:sender alignStyle:CPAlignStyleRight relativePosition:CPContentPositionAlwaysUp];
}

- (IBAction)testClick3:(UIButton *)sender {
    
    CPShowStyle *style = [CPShowStyle new];
    style.triAngelHeight = 10.0;
    style.triAngelWidth = 7.0;
    style.containerCornerRadius = 5.0;
    style.roundMargin = 5.0;
    style.defaultRowHeight = 30;
    style.showSpace = 2;
    style.tableBackgroundColor = [UIColor grayColor];
    style.textColor = [UIColor orangeColor];
    style.textAlignment = NSTextAlignmentLeft;
    style.containerBackgroudColor = [UIColor greenColor];
    style.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *arr = @[
                     @{@"name": @"羽毛球", @"icon": @"icon_badminton"},
                     @{@"name": @"篮球", @"icon": @"icon_basketball"},
                     @{@"name": @"足球", @"icon": @"icon_football"},
                     @{@"name": @"更多", @"icon": @"icon_more"}
                     ];
    
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 130, 30*4) titleInfo:arr style:style];
    
    view.delegate = self;
    [view showFrom:sender alignStyle:CPAlignStyleRight];
    
    
}


- (IBAction)handleTest4:(UIButton *)sender
{
    CPShowStyle *style = [CPShowStyle new];
    style.triAngelHeight = 10.0;
    style.triAngelWidth = 7.0;
    style.containerCornerRadius = 5.0;
    style.roundMargin = 5.0;
    style.defaultRowHeight = 30;
    style.showSpace = 2;
    style.tableBackgroundColor = [UIColor grayColor];
    style.textColor = [UIColor orangeColor];
    style.textAlignment = NSTextAlignmentLeft;
    style.containerBackgroudColor = [UIColor purpleColor];
    
    NSArray *arr = @[
                     @{@"name": @"羽毛球", @"icon": @"icon_badminton"},
                     @{@"name": @"篮球", @"icon": @"icon_basketball"},
                     @{@"name": @"足球", @"icon": @"icon_football"},
                     @{@"name": @"更多", @"icon": @"icon_more"}
                     ];
    
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 130, 30*4) titleInfo:arr style:style];
    
    view.delegate = self;
    [view showFrom:sender alignStyle:CPAlignStyleRight relativePosition:CPContentPositionAutomaticUpFirst];
}





#pragma mark- CustomPopOverViewDelegate


//- (void)popOverViewDidShow:(CustomPopOverView *)pView
//{
//    NSLog(@"popOverViewDidShow");
//}
//- (void)popOverViewDidDismiss:(CustomPopOverView *)pView
//{
//    NSLog(@"popOverViewDidDismiss");
//}

- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"index is %d", (int)index] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

@end
