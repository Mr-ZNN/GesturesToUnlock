//
//  LockView.m
//  手势解锁
//
//  Created by zhangningning on 16/12/21.
//  Copyright © 2016年 张宁宁. All rights reserved.
//

#import "LockView.h"

@interface LockView ()
@property (strong,nonatomic) NSMutableArray * selectBtnArr;
@property (assign,nonatomic) CGPoint currentPoint;
@end
@implementation LockView

-(NSMutableArray*)selectBtnArr{
    if (_selectBtnArr == nil) {
        _selectBtnArr = [NSMutableArray array];
    }
    return _selectBtnArr;
}
-(IBAction)pan:(UIPanGestureRecognizer*)pan{
    NSLog(@"我的哥啊");
    //获取触摸点
    _currentPoint = [pan locationInView:self];
    
    //判断触摸点在不在按钮上
    for (UIButton * btn in self.subviews) {
        //判断点在不在按钮范围内，并且按钮有没有被选中
        if (CGRectContainsPoint(btn.frame, _currentPoint) && btn.selected == NO) {
            //当前点在按钮上
            btn.selected = YES;
            //把按钮保存到数组
            [self.selectBtnArr addObject:btn];
        }
    }
    
    //重绘
    [self setNeedsDisplay];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        //创建可变数组
        NSMutableString * strM = [NSMutableString string];
        //保存输入密码
        for (UIButton * btn in self.selectBtnArr) {
            [strM appendFormat:@"%ld",btn.tag];
        }
        NSLog(@"%@",strM);
        
        //还原界面
        //取消所有按钮的选中
        [self.selectBtnArr makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
        //清除画线，把选中按钮清空
        [self.selectBtnArr removeAllObjects];
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    for (int i =0; i < 9; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.tag = i;
        [self addSubview:btn];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    int cols = 3;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 74;
    CGFloat h = 74;
    CGFloat margin = (self.bounds.size.width - cols * w)/(cols+1);
    NSInteger count = self.subviews.count;
    
    int col = 0;
    int row = 0;
    for (int i = 0; i < count; i++) {
        UIButton * btn = self.subviews[i];
        
        col = i % cols;
        row = i / cols;
        x = margin + col * (margin + w);
        y = row * (margin + w);
        
        btn.frame = CGRectMake(x, y, w, h);
    }
}

//只要调用这个方法，就会把之前绘制的东西全部清除，重新绘制
- (void)drawRect:(CGRect)rect {
    // 没有选中的按钮，不需要连线
    if (self.selectBtnArr.count == 0) {
        return;
    }else{
       //有选中按钮
        //把所有选中按钮中心点连线
        UIBezierPath * path = [UIBezierPath bezierPath];
        NSInteger count = self.selectBtnArr.count;
        //把所有选中按钮之间都连好线
        for (int i = 0; i < count; i++) {
            UIButton * btn = self.selectBtnArr[i];
            if (i == 0) {
                //设置为起点
                [path moveToPoint:btn.center];
            }else{
               //连接
                [path addLineToPoint:btn.center];
                
            }
        }
        // 连线到手指的触摸点
        [path addLineToPoint:_currentPoint];
        
        [[UIColor greenColor] set];
        path.lineWidth = 10;
        path.lineJoinStyle = kCGLineJoinRound;
        [path stroke];
    }
    
}


@end
