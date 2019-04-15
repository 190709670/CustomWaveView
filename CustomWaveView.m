//
//  CustomWaveView.m
//  HAAA
//
//  Created by apple on 2019/4/4.
//  Copyright © 2019 MeiKangHui. All rights reserved.
//

#import "CustomWaveView.h"
@interface CustomWaveView()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *waveArray;
@property (nonatomic, assign) NSInteger offset;
@end
@implementation CustomWaveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    [super layoutSubviews];
}
- (void)addWaveWithSpeed:(CGFloat)speed waveColor:(UIColor *)waveColor waveHeightArray:(NSArray *)waveHeightArray waveWidthArray:(NSArray *)waveWidthArray bottomHeight:(NSInteger)bottomHeight{
    CAShapeLayer *waveLayer = [CAShapeLayer layer];
    [self.layer addSublayer:waveLayer];
    [self.waveArray addObject:@{
                                @"wave":waveLayer,
                                @"speed":[NSNumber numberWithFloat:speed],
                                @"waveColor":waveColor,
                                @"waveHeightArray":waveHeightArray,
                                @"waveWidthArray":waveWidthArray,
                                @"bottomHeight":[NSNumber numberWithInteger:bottomHeight]
                                }];
    [self wave];
}

- (void)wave{
    self.offset ++;
    for (NSDictionary *waveDic in self.waveArray) {
        CAShapeLayer *waveLayer = waveDic[@"wave"];
        CGFloat speed = [waveDic[@"speed"] floatValue];// @"speed":[NSNumber numberWithFloat:speed],
        UIColor *waveColor = waveDic[@"waveColor"]; //;@"waveColor":waveColor,
        NSArray *waveHeightArray = waveDic[@"waveHeightArray"] ;// @"waveHeight":[NSNumber numberWithFloat:waveHeight],
        NSArray *waveWidthArray = waveDic[@"waveWidthArray"]; //@"waveCurve":[NSNumber numberWithFloat:waveCure],
        NSInteger bottomHeight = [waveDic[@"bottomHeight"] integerValue];
        
        NSInteger waveOffset = self.offset * speed;
        //创建浪的路径
        CGMutablePathRef wavePath = CGPathCreateMutable();
        //创建一个点
        CGPathMoveToPoint(wavePath, NULL, 0, self.frame.size.height - bottomHeight); //已低谷为起点
        
        //存放计算的每一个浪的宽度
        //计算全部浪组合的一个周期
        NSInteger cycleWidth = 0.0;
//        NSMutableArray *waveWidthArray = [NSMutableArray array];
        for (NSInteger i = 0; i < waveWidthArray.count; i++) {
            NSInteger waveWidth = [waveWidthArray[i] integerValue];
//            [waveWidthArray addObject:[NSNumber numberWithFloat:waveWidth]];
            cycleWidth = waveWidth + cycleWidth;
        }
        //存放当前x为第几个周期
        NSInteger cycleNumber = 0;
        //            //主要f算法 y = Asin（ωx+φ）
        for (int x = 0; x < self.frame.size.width; x++) {
            cycleNumber = (x + waveOffset)/ cycleWidth;
            CGFloat offset_x = x + waveOffset - cycleNumber*cycleWidth; //每个周期内x的位置
            CGFloat y = 0.0; //浪高
            //遍历浪周期z数组，查找x所在浪周期，高度
            NSInteger waveWidth = 0;
            NSInteger waveHeight = 0;
            for (NSInteger i = 0; i < waveWidthArray.count ; i ++){
                NSInteger temWidth = waveWidth;
                waveWidth  += [waveWidthArray[i] integerValue];//每个浪宽度
                if (fabs(offset_x) < waveWidth) {
                   waveHeight = [waveHeightArray[i] integerValue];
                    //[[waveWidthArray[i] integerValue]
                    NSInteger waveWidthAAA = [waveWidthArray[i] integerValue];
                    y = waveHeight * sinf((fabs(offset_x) - temWidth) * (360.0/waveWidthAAA)  * M_PI/180 + M_PI_2);
                    break;
                }
            }
            CGPathAddLineToPoint(wavePath, NULL, x,y + self.frame.size.height - bottomHeight -waveHeight);
        }
        
        //调整填充路径
        CGPathAddLineToPoint(wavePath, NULL, self.frame.size.width, self.frame.size.height);
        CGPathAddLineToPoint(wavePath, NULL, 0, self.frame.size.height);
        //结束路径
        CGPathCloseSubpath(wavePath);
        //用路径创建浪
        waveLayer.path = wavePath;
        waveLayer.fillColor = waveColor.CGColor;
        
        CGPathRelease(wavePath);
    }
}
- (void)startWaveAnimation{
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)stopWaveAnimation{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

-(NSMutableArray *)waveArray{
    if (_waveArray == nil) {
        _waveArray = [[NSMutableArray alloc] init];
    }
    return _waveArray;
} 
-(CADisplayLink *)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(wave)];
    }
    return _displayLink;
}

@end
