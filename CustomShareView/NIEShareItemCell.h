//
//  NIEShareItemCell.h
//  CustomShareView
//
//  Created by Liuyong on 14-6-24.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kShareItemWidth 70
#define kShareItemHeight 70
#define kShareItemIconHeight 50

@interface NIEShareItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end
