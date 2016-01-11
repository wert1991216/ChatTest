//
//  UIImage+CL.m
//  AppTest
//
//  Created by clark on 16/1/2.
//  Copyright © 2016年 ccpp. All rights reserved.
//

#import "UIImage+CL.h"

@implementation UIImage (CL)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    int tempWidth = image.size.width;
    int tempHeight = image.size.height;
    
    UIImage *resultImg=nil;
    
    if(tempWidth <= newSize.width && tempHeight <= newSize.height)
        resultImg=image;
    else
    {
        float tempRate = (float)newSize.width/tempWidth < (float)newSize.height/tempHeight ? (float)newSize.width/tempWidth : (float)newSize.height/tempHeight;
        CGSize itemSize = CGSizeMake(tempRate*tempWidth, tempRate*tempHeight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0,itemSize.width,itemSize.height);
        [image drawInRect:imageRect];
        resultImg= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return resultImg;
}

@end
