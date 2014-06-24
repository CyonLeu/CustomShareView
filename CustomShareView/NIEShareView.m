//
//  NIEShareView.m
//  CustomShareView
//
//  Created by Liuyong on 14-6-24.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "NIEShareView.h"

#import "NIEShareItemCell.h"

#define kMAX_CONTENT_HEIGHT 360
#define kEdgeMarginSpace 10
#define kMinimumInteritemSpacing 5
#define kUIViewAnimationTimeInterval 0.5

@interface NIEShareView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *cancelSeparatorView;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemImages;
@property (nonatomic) NSInteger itemCount;


@end

@implementation NIEShareView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0f];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackgroundView:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        _itemTitles = [NSArray array];
        _itemImages = [NSArray array];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        [_contentView addSubview:_titleLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        _lineView.backgroundColor = [UIColor blackColor];
        
        [_contentView addSubview:_lineView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kShareItemWidth, kShareItemHeight);
        layout.minimumLineSpacing = kMinimumInteritemSpacing;
        layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[NIEShareItemCell class] forCellWithReuseIdentifier:@"NIEShareItemCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.clipsToBounds = YES;
        
        [_contentView addSubview:_collectionView];
        
        
        //取消按钮与视图之间的分割线
        _cancelSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
        _cancelSeparatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45f];
        [self.contentView addSubview:_cancelSeparatorView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.clipsToBounds = YES;
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取    消" forState:UIControlStateNormal];
        
        [_cancelButton addTarget:self
                          action:@selector(onCancelButton:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_cancelButton];
        
        [self addSubview:_contentView];
    }
    return self;
}


- (id)initWithTitle:(NSString *)title
         itemTitles:(NSArray *)itemTitles
             images:(NSArray *)images
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        NSInteger count = MIN(itemTitles.count, images.count);
        _titleLabel.text = title;
        _itemTitles = [itemTitles subarrayWithRange:NSMakeRange(0, count)];
        _itemImages = [images subarrayWithRange:NSMakeRange(0, count)];
        _itemCount = 8;
        
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



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.contentView.frame = (CGRect){CGPointMake(0, self.bounds.size.height - self.contentView.bounds.size.height), self.contentView.bounds.size};
    [self.contentView layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = (CGRect){CGPointMake(0, 0), CGSizeMake(self.contentView.bounds.size.width, 40)};
    self.lineView.frame = CGRectMake(kEdgeMarginSpace * 2, self.titleLabel.frame.size.height, self.contentView.bounds.size.width - kEdgeMarginSpace, 0.5);
    [self layoutCollectionView];
    self.collectionView.frame = (CGRect){CGPointMake(kEdgeMarginSpace, self.titleLabel.frame.size.height + self.lineView.frame.size.height+ kEdgeMarginSpace/2), self.collectionView.bounds.size};
    
    self.cancelSeparatorView.frame = CGRectMake(0, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + kEdgeMarginSpace, self.contentView.bounds.size.width, 2);
    
    self.cancelButton.frame = CGRectMake(self.contentView.bounds.size.width*0.05, self.titleLabel.bounds.size.height + self.collectionView.bounds.size.height + kEdgeMarginSpace *2, self.bounds.size.width*0.9, 44);
    
    self.contentView.bounds = (CGRect){CGPointZero, CGSizeMake(self.contentView.bounds.size.width, self.titleLabel.bounds.size.height + self.collectionView.bounds.size.height + self.cancelButton.bounds.size.height + kEdgeMarginSpace * 2)};
    self.contentView.frame = (CGRect){CGPointMake(0, self.bounds.size.height - self.contentView.bounds.size.height), self.contentView.bounds.size};
}

- (void)layoutCollectionView
{
    NSInteger rowCount = ((self.itemCount - 1) / 4) + 1;
    CGSize size = CGSizeMake(self.contentView.bounds.size.width - kEdgeMarginSpace * 2, rowCount * kShareItemHeight + kMinimumInteritemSpacing * (rowCount - 1));
    
    if (size.height > kMAX_CONTENT_HEIGHT) {
        self.collectionView.bounds = (CGRect){CGPointZero, CGSizeMake(self.contentView.bounds.size.width - kEdgeMarginSpace * 2, kMAX_CONTENT_HEIGHT)};
    }else{
        self.collectionView.bounds = (CGRect){CGPointZero, size};
    }
}

#pragma  mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NIEShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NIEShareItemCell" forIndexPath:indexPath];
//    cell.iconImageView.image = self.itemImages[indexPath.row];
//    cell.titleLabel.text = self.itemTitles[indexPath.row];
    cell.iconImageView.image = self.itemImages[1];
    cell.titleLabel.text = self.itemTitles[1];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma  mark - UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath: %d", indexPath.row);
    [self dismissShareView];
}


- (void)showInview:(UIView *)parentView
{
    if (![self superview]) {
        
        if (parentView){
            [parentView addSubview:self];
        }
        else{
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window addSubview:self];
        }
        
    }

    self.frame = (CGRect){CGPointMake(0, 0), self.superview.bounds.size};
    CGRect contentFrame = self.contentView.frame;
    self.contentView.frame = (CGRect){CGPointMake(0, contentFrame.origin.y + contentFrame.size.height), contentFrame.size};
    [UIView animateWithDuration:kUIViewAnimationTimeInterval animations:^{
        self.contentView.frame = contentFrame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    } completion:^(BOOL finished) {
    }];
}

#pragma  mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, touchPoint)) {
        return NO;
    }
    
    return YES;
}

#pragma mark - HandleEvent

- (void)onCancelButton:(id)sender
{
    [self dismissShareView];
}

- (void)onTapBackgroundView:(UITapGestureRecognizer *)tapGesture
{
    [self dismissShareView];
}

- (void)dismissShareView
{
    CGRect contentFrame = self.contentView.frame;
    contentFrame = (CGRect){CGPointMake(0, contentFrame.origin.y + contentFrame.size.height), contentFrame.size};
    [UIView animateWithDuration:kUIViewAnimationTimeInterval animations:^{
        self.contentView.frame = contentFrame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
