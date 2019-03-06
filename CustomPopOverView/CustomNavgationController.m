//
//  CustomNavgationController.m
//  CustomPopOverView
//
//  Created by mac on 2019/3/6.
//  Copyright © 2019 zgy. All rights reserved.
//

#import "CustomNavgationController.h"

@implementation CustomNavgationController


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}



@end
