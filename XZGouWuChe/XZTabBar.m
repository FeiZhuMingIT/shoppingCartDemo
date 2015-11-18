//
//  XZTabBar.m
//  XZGouWuChe
//
//  Created by WZZ on 15/11/18.
//  Copyright © 2015年 晓志. All rights reserved.
//

#import "XZTabBar.h"
@interface XZTabBar()

// 数量label
@property(nonatomic,weak) UILabel *buyNumberLabel;

@end

@implementation XZTabBar

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubView];
    }
    return self;
}


- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

// 设立
- (void)setupSubView {
    
    UIImageView *buyCar = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 10, 60, 60)];
    buyCar.image = [UIImage imageNamed:@"TabCartSelected"];
    self.buyCar = buyCar;
    [self addSubview:buyCar];
    
    // 30 + 30 = 60 - 10 - 50
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 43, 15, 20, 20)];
    label.layer.cornerRadius = 10;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor redColor];
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 1.0f;
    label.text = @"0";
    label.textAlignment = NSTextAlignmentCenter;
    self.buyNumberLabel = label;
    label.hidden = YES;
    [self addSubview:label];
}

- (void)buycarAnimation {
    
    NSInteger buyCount = [self.buyNumberLabel.text integerValue];
    buyCount ++ ;
    if (buyCount > 0 ) {
        self.buyNumberLabel.hidden = NO;
    } else {
        self.buyNumberLabel.hidden = YES;
    }
    CATransition *animation = [CATransition animation];
    animation.duration = 0.25f;
    [self.buyNumberLabel.layer addAnimation:animation forKey:nil];
    self.buyNumberLabel.text = [NSString stringWithFormat:@"%ld",buyCount];
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-8];
    shakeAnimation.toValue = [NSNumber numberWithFloat:8];
    // 什么意思？没效果啊
    shakeAnimation.autoreverses = YES;
    [self.buyCar.layer addAnimation:shakeAnimation forKey:nil];
}

@end
