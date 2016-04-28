//
//  ViewController.m
//  CustomPopOverView
//
//  Created by zgy on 16/4/28.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "ViewController.h"
#import "CustomPopOverView.h"

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
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [rightBtn addTarget:self action:@selector(handleRightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    _rightBtn = rightBtn;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [leftBtn addTarget:self action:@selector(handleLeftClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    _leftBtn = leftBtn;
    
}

- (void)handleRightClick {
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
    
    [view showFrom:_rightBtn alignStyle:CPAlignStyleRight];


}

- (void)handleLeftClick {
    CustomPopOverView *view = [CustomPopOverView popOverView];
    view.content = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    view.containerBackgroudColor = [UIColor blueColor];
    [view showFrom:_leftBtn alignStyle:CPAlignStyleLeft];
    
    
}

- (IBAction)testClick:(UIButton *)sender {
    
    _titles = @[@"Menu1", @"Menu2", @"Ah_Menu3"];
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 200, 44*3) titleMenus:_titles];;
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
    NSLog(@"select menu title is: %@", _titles[index]);
}

@end
