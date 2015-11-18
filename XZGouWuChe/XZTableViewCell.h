//
//  XZTableViewCell.h
//  XZGouWuChe
//
//  Created by WZZ on 15/11/18.
//  Copyright © 2015年 晓志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"
@class XZTableViewCell;
@protocol XZTableViewCelldelegate <NSObject>

- (void)tableViewCell:(XZTableViewCell *)cell imageModel:(ImageModel *)imageModel;

@end

@interface XZTableViewCell : UITableViewCell
/**
 *  图像
 */
@property(nonatomic,weak) UIImageView *iconView;

/**
 *  图片地址
 */
@property(nonatomic,copy) NSString *imageUrl;

@property(nonatomic,weak) id<XZTableViewCelldelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


//

@end
