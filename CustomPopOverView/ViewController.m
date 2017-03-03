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

- (void)optionClick:(UIButton *)sender
{
    
    NSArray *menus = @[@"清空已完成", @"清空全部"];
    CustomPopOverView *pView = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 100, 44*2) titleMenus:menus config:nil];
    pView.delegate = self;
    pView.containerBackgroudColor = RGBCOLOR(64, 64, 64);
    [pView showFrom:sender alignStyle:CPAlignStyleRight];


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
    view.contentViewController = vc;
    
    [view showFrom:_leftBtn alignStyle:CPAlignStyleLeft];
    
    
}

- (IBAction)testClick:(UIButton *)sender {
    
    _titles = @[@"Menu1", @"Menu2", @"Ah_Menu3"];
    PopOverVieConfiguration *config = [PopOverVieConfiguration new];
    config.triAngelHeight = 5.0;
    config.triAngelWidth = 7.0;
    config.containerViewCornerRadius = 3.0;
    config.roundMargin = 2.0;
    config.defaultRowHeight = 30;
    config.tableBackgroundColor = [UIColor grayColor];
    config.textColor = [UIColor orangeColor];
    
    
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 200, 44*3) titleMenus:_titles config:config];;
    view.containerBackgroudColor = [UIColor blueColor];
    view.delegate = self;
    [view showFrom:sender alignStyle:CPAlignStyleCenter];
}
- (IBAction)testClick2:(UIButton *)sender {
    
    CustomPopOverView *view = [CustomPopOverView popOverView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn.bounds = CGRectMake(0, 0, 60, 40);
    view.content = btn;
    
    [view showFrom:sender alignStyle:CPAlignStyleRight];
}

#pragma mark- CustomPopOverViewDelegate


- (void)popOverViewDidShow:(CustomPopOverView *)pView
{
    NSLog(@"popOverViewDidShow");
}
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView
{
    NSLog(@"popOverViewDidDismiss");
}

- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"index is %d", (int)index] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

@end
