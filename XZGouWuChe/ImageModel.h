//
//  ImageModel.h
//  XZGouWuChe
//
//  Created by WZZ on 15/11/18.
//  Copyright © 2015年 晓志. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageModel : NSObject

/**
 *  保存一个imageView
 */
@property(nonatomic,strong) UIImageView *imageView;

/**
 *  图片的地址
 */
@property(nonatomic,copy) NSString *imageUrl;

@end
