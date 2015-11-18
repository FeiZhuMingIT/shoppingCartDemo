//
//  ViewController.m
//  XZGouWuChe
//
//  Created by WZZ on 15/11/18.
//  Copyright © 2015年 晓志. All rights reserved.
//

// 方案，如果用标记的方法的话，会导致其他的image不能使用
#import "ViewController.h"
#import "XZTableViewCell.h"
#import "ImageModel.h"
#import "XZTabBar.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,XZTableViewCelldelegate>

@property(nonatomic,weak) UITableView *tableView;

/**
 *  保存每一个imageModel
 */
@property(nonatomic,strong) NSArray *dataArr;

/**
 *
 */
@property(nonatomic,strong) UIBezierPath *bezierPath;

// 购物车导航条
@property(nonatomic,weak) XZTabBar *tabBar;

@property(nonatomic,strong) CALayer *layer;


// 当前点击的imageModel
@property(nonatomic,strong) ImageModel *imageModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupTabBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITabView
- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
}



#pragma mark - 设置购物车导航条
- (void)setupTabBar {
    XZTabBar *tabBar = [[XZTabBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 60)];
    tabBar.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
    self.tabBar = tabBar;
    [self.view addSubview:tabBar];
    
    
}


#pragma mark - tableView数据源
/**
 *  返回组数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}
/**
 *  返回对应组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

/**
 *  返回每一行展示的内容(cell)
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 声明一个重用标识
    XZTableViewCell *cell = [XZTableViewCell cellWithTableView:tableView];
    cell.imageUrl = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - cell的代理方法
- (void)tableViewCell:(XZTableViewCell *)cell imageModel:(ImageModel *)imageModel {
    
    // 获得在当前控制器的frame值 第二个参数填写imageFrame
   CGRect imageRect = [imageModel.imageView.superview convertRect:imageModel.imageView.frame toCoordinateSpace:self.view];
    NSLog(@"%@",NSStringFromCGRect(imageRect));
    
    // 得到购物车的终点
    CGRect buyCarFrame = [self.tabBar.buyCar.superview convertRect:self.tabBar.buyCar.frame toCoordinateSpace:self.view];
    
    
    // 设置bezier曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    // 设置起点
    [bezierPath moveToPoint:CGPointMake(imageRect.origin.x + 30, imageRect.origin.y + 30)];
    // 设置终点
    [bezierPath addQuadCurveToPoint:CGPointMake( buyCarFrame.origin.x + 25, buyCarFrame.origin.y + 25) controlPoint:CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, imageRect.origin.y - 80) ];
    
    // 开始动画
    [self startAnimation:imageModel.imageView WithBezierPath:bezierPath];
}

#pragma mark - 添加动画
- (void)startAnimation:(UIImageView *)imageView WithBezierPath:(UIBezierPath *)bezierPath {
    
    
    if (!_layer) {
//        imageView.userInteractionEnabled = NO;
        _layer = [CALayer layer];
        _layer.contents = (__bridge id)imageView.image.CGImage;
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = CGRectMake(0, 0, 50, 50);
        [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
        _layer.masksToBounds = YES;
        _layer.position = CGPointMake(50, 150);
        [self.view.layer addSublayer:_layer];
    } else { // 证明layer存在
        return;
    }
    
    // 获得在当前控制器的frame
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 0.6f;
    groups.removedOnCompletion= NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    
    [_layer addAnimation:groups forKey:@"group"];
}

// 动画结束的时候
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //    [anim def];
    if (anim == [self.layer animationForKey:@"group"]) {
//        self.imageModel.imageView.userInteractionEnabled = YES;
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        [self.tabBar buycarAnimation];
    }
}

#pragma mark - set & get
- (NSArray *)dataArr {
    if (_dataArr == nil) {
        NSMutableArray *mtbArr = [NSMutableArray array];
        // 模拟数据
        for (int index = 0; index < 100; index ++) {
            NSString *imageName = @"test01.jpg";
            [mtbArr addObject:imageName];
        }
        _dataArr = [mtbArr copy];
    }
    return _dataArr;
}

- (UIBezierPath *)bezierPath {
    if (_bezierPath == nil) {
        _bezierPath = [[UIBezierPath alloc] init];
    }
    return _bezierPath;
}


@end
