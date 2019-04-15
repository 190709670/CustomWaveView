//
//  CustomWaveView.h
//  HAAA
//
//  Created by apple on 2019/4/4.
//  Copyright © 2019 MeiKangHui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomWaveView : UIView

/**
  添加一条波纹

 @param speed 速度
 @param waveColor 浪的颜色
 @param waveHeightArray 浪高
 @param waveWidthArray 浪的周期
 @param bottomHeight 距离底部距离
 */
- (void)addWaveWithSpeed:(CGFloat)speed waveColor:(UIColor *)waveColor waveHeightArray:(NSArray *)waveHeightArray waveWidthArray:(NSArray *)waveWidthArray bottomHeight:(NSInteger)bottomHeight;
- (void)startWaveAnimation;
- (void)stopWaveAnimation;
@end

NS_ASSUME_NONNULL_END
