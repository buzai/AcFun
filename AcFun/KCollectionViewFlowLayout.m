//
//  KCollectionViewFlowLayout.m
//  AcFun
//
//  Created by 陈 on 16/1/29.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "KCollectionViewFlowLayout.h"

@implementation KCollectionViewFlowLayout
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    [super layoutAttributesForElementsInRect:rect];
    
//    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    
    
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let attributes = super.layoutAttributesForElementsInRect(rect)
//        
//        var attributesCopy = [UICollectionViewLayoutAttributes]()
//        
//        for itemAttributes in attributes! {
//            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
//            // manipulate itemAttributesCopy
//            attributesCopy.append(itemAttributesCopy)
//        }
//        return attributesCopy
//    }
    
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];

//    UICollectionViewLayoutAttributes *attributesCopy =[[UICollectionViewLayoutAttributes alloc] init];
    

    
//    NSArray *attributes = [[super layoutAttributesForElementsInRect:rect] copy];
    
//    for (UICollectionViewLayoutAttributes *attr in attributes) {
//        NSLog(@"%@", NSStringFromCGRect([attr frame]));
//    }
    //从第二个循环到最后一个
    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = 10;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    
    
    NSMutableArray * attributesCopy = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *itemAttributes in attributes) {
        UICollectionViewLayoutAttributes * itemAttributesCopy = [itemAttributes copy];
        [attributesCopy addObject:itemAttributesCopy];
    }
    return attributesCopy;
}

@end
