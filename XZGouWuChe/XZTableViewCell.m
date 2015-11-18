//
//  XZTableViewCell.m
//  XZGouWuChe
//
//  Created by WZZ on 15/11/18.
//  Copyright © 2015年 晓志. All rights reserved.
//

#import "XZTableViewCell.h"

#define kCellIdentifier @"cell"

@interface XZTableViewCell()

@property(nonatomic,strong) ImageModel *imageModel;

@end

@implementation XZTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    XZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  重写
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView = iconView;
        self.iconView.layer.cornerRadius = 30;
        self.iconView.layer.masksToBounds = YES;
//        self.iconView.image = [UIImage imageNamed:@"test01"];
        iconView.backgroundColor = [UIColor cyanColor];
        self.imageModel.imageView = iconView;
        iconView.userInteractionEnabled = YES;
        // 给imageView添加手势
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewDidClikc:)];
        [iconView addGestureRecognizer:recognizer];
        [self addSubview:iconView];
    }
    return self;
}


/**
 *  自动布局
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.frame = CGRectMake(20, 0, 60, 60);
}

#pragma mark - 
#pragma mark - action
- (void)iconViewDidClikc:(UIGestureRecognizer *)grsture {
    // 把自己传出去告诉用户触发动画
    if ([self.delegate respondsToSelector:@selector(tableViewCell:imageModel:)]) {
        [self.delegate tableViewCell:self imageModel:self.imageModel];
    }
}

#pragma mark - 
#pragma mark - set & get
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    self.imageModel.imageUrl = imageUrl;
    self.iconView.image = [UIImage imageNamed:imageUrl];
}

- (ImageModel *)imageModel {
    if (!_imageModel) {
        _imageModel = [[ImageModel alloc] init];
    }
    return _imageModel;
}

@end
