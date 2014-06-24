//
//  NIEShareItemCell.m
//  CustomShareView
//
//  Created by Liuyong on 14-6-24.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "NIEShareItemCell.h"

@implementation NIEShareItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setupShareItemView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setupShareItemView
{
    CGRect imageRect = CGRectMake((self.bounds.size.width - kShareItemIconHeight)/2.0, 0, kShareItemIconHeight, kShareItemIconHeight);
    self.iconImageView = [[UIImageView alloc] initWithFrame:imageRect];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageRect.size.height, self.bounds.size.width, self.bounds.size.height - imageRect.size.height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    self.iconImageView.backgroundColor = [UIColor clearColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
}

//- (void)setupShareItemData
//{
//    
//}




@end
