//
//  WhiteTagLayout.m
//  LiveRecorder
//
//  Created by DoctorGG on 2017/5/3.
//  Copyright © 2017年 NetEase, Inc. All rights reserved.
//

#import "WhiteTagLayout.h"
#import "WhiteTagCell.h"
#import "WhiteTagHeaderView.h"

@interface WhiteTagLayout()

@property (strong, nonatomic) NSMutableArray *itemAttributes;

@end

@implementation WhiteTagLayout

- (instancetype)initWithCollectionViewBounds:(CGRect)rect {
    if (self = [super initWithCollectionViewBounds:rect]) {
        self.itemSize = CGSizeMake(160, 32);
        self.headerReferenceSize = CGSizeMake(rect.size.width, 40);
    }
    
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemAttributes = [NSMutableArray new];
    id<UICollectionViewDelegateFlowLayout> delegate = (id)self.collectionView.delegate;
    
    NSInteger numberOfSection = self.collectionView.numberOfSections;
    for (int section=0; section<numberOfSection; section++)
    {
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
        if (lastIndex < 0)
            continue;
        
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:section]];
        
        UIEdgeInsets sectionInset = self.sectionInset;
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
            sectionInset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        
        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
        frame.origin.x -= sectionInset.left;
        frame.origin.y -= sectionInset.top;
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            frame.size.width += sectionInset.left + sectionInset.right;
            frame.size.height = self.collectionView.frame.size.height;
        }
        else
        {
            frame.size.width = self.collectionView.frame.size.width;
            frame.size.height += sectionInset.top + sectionInset.bottom;
        }
        
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"WhiteSectionBackgroundView" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        attributes.zIndex = -1;
        attributes.frame = frame;
        [self.itemAttributes addObject:attributes];
        [self registerNib:[UINib nibWithNibName:@"WhiteSectionBackgroundView" bundle:[NSBundle mainBundle]] forDecorationViewOfKind:@"WhiteSectionBackgroundView"];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes)
    {
        if (!CGRectIntersectsRect(rect, attribute.frame))
            continue;
        
        [attributes addObject:attribute];
    }
    
    return attributes;
}

@end
