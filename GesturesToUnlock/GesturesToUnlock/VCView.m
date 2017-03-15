//
//  VCView.m
//  手势解锁
//
//  Created by zhangningning on 16/12/22.
//  Copyright © 2016年 张宁宁. All rights reserved.
//

#import "VCView.h"

@implementation VCView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImage * image = [UIImage imageNamed:@"Home_refresh_bg"];
    [image drawInRect:rect];
}


@end
