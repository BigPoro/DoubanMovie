//
//  UITableViewCell+Highlighted.m
//  FlyServiceRepair
//
//  Created by iDog on 2018/8/1.
//  Copyright © 2018年 ifeixiu.FlyService. All rights reserved.
//

#import "UITableViewCell+selected.h"

@implementation UITableViewCell (Highlighted)

- (void)db_setHighlighted:(BOOL)highlighted
{
    UIColor *originColor = self.backgroundColor;
    if (highlighted) {
        self.backgroundColor = kGray_two;
        [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundColor = originColor;
        } completion:nil];
    } else {
        self.backgroundColor = originColor;
    }
}

@end
