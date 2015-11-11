//
//  LGDrawer.m
//  LGDrawer
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGDrawer)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#define kLGDrawerDegreesToRadians(d) ((d) * M_PI / 180)

#import "LGDrawer.h"

@implementation LGDrawer

#pragma mark - Rectangle

+ (UIImage *)drawRectangleWithImageSize:(CGSize)imageSize
                                   size:(CGSize)size
                                 offset:(CGPoint)offset
                                 rotate:(CGFloat)degrees
                         roundedCorners:(UIRectCorner)roundedCorners
                           cornerRadius:(CGFloat)cornerRadius
                        backgroundColor:(UIColor *)backgroundColor
                              fillColor:(UIColor *)fillColor
                            strokeColor:(UIColor *)strokeColor
                        strokeThickness:(CGFloat)strokeThickness
                             strokeDash:(NSArray *)strokeDash
                             strokeType:(LGDrawerStrokeType)strokeType
                            shadowColor:(UIColor *)shadowColor
                           shadowOffset:(CGPoint)shadowOffset
                             shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    BOOL strokeNeeded = (strokeThickness && strokeColor && ![strokeColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (fillNeeded)
    {
        if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

        CGSize radiusSize = CGSizeMake(cornerRadius, cornerRadius);

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:radiusSize];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        [fillColor setFill];
        [path fill];
    }

    // STROKE -----

    if (strokeNeeded)
    {
        if (fillNeeded && shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeZero, 0.f, nil);
        else if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        CGRect rect = CGRectZero;

        if (strokeType == LGDrawerStrokeTypeCenter)
            rect = CGRectMake(imageSize.width/2-size.width/2, imageSize.height/2-size.height/2, size.width, size.height);
        else if (strokeType == LGDrawerStrokeTypeOutside)
            rect = CGRectMake(imageSize.width/2-size.width/2-strokeThickness/2, imageSize.height/2-size.height/2-strokeThickness/2, size.width+strokeThickness, size.height+strokeThickness);
        else if (strokeType == LGDrawerStrokeTypeInside)
            rect = CGRectMake(imageSize.width/2-size.width/2+strokeThickness/2, imageSize.height/2-size.height/2+strokeThickness/2, size.width-strokeThickness, size.height-strokeThickness);

        rect.origin.x += offset.x;
        rect.origin.y += offset.y;

        CGSize radiusSize = CGSizeZero;

        if (strokeType == LGDrawerStrokeTypeCenter)
            radiusSize = CGSizeMake(cornerRadius, cornerRadius);
        else if (strokeType == LGDrawerStrokeTypeOutside)
            radiusSize = CGSizeMake(cornerRadius+strokeThickness/2, cornerRadius+strokeThickness/2);
        else if (strokeType == LGDrawerStrokeTypeInside)
            radiusSize = CGSizeMake(cornerRadius-strokeThickness/2, cornerRadius-strokeThickness/2);

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:radiusSize];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        if (strokeDash.count)
        {
            CGFloat cArray[strokeDash.count];

            for (NSUInteger i=0; i<strokeDash.count; i++)
                cArray[i] = [strokeDash[i] floatValue];

            CGContextSetLineDash(context, 0, cArray, strokeDash.count);
        }

        path.lineWidth = strokeThickness;

        // -----

        [strokeColor setStroke];
        [path stroke];
    }

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Ellipse

+ (UIImage *)drawEllipseWithImageSize:(CGSize)imageSize
                                 size:(CGSize)size
                               offset:(CGPoint)offset
                               rotate:(CGFloat)degrees
                      backgroundColor:(UIColor *)backgroundColor
                            fillColor:(UIColor *)fillColor
                          strokeColor:(UIColor *)strokeColor
                      strokeThickness:(CGFloat)strokeThickness
                           strokeDash:(NSArray *)strokeDash
                           strokeType:(LGDrawerStrokeType)strokeType
                          shadowColor:(UIColor *)shadowColor
                         shadowOffset:(CGPoint)shadowOffset
                           shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    BOOL strokeNeeded = (strokeThickness && strokeColor && ![strokeColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (fillNeeded)
    {
        if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        [fillColor setFill];
        [path fill];
    }

    // STROKE -----

    if (strokeNeeded)
    {
        if (fillNeeded && shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeZero, 0.f, nil);
        else if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        CGRect rect = CGRectZero;

        if (strokeType == LGDrawerStrokeTypeCenter)
            rect = CGRectMake(imageSize.width/2-size.width/2, imageSize.height/2-size.height/2, size.width, size.height);
        else if (strokeType == LGDrawerStrokeTypeOutside)
            rect = CGRectMake(imageSize.width/2-size.width/2-strokeThickness/2, imageSize.height/2-size.height/2-strokeThickness/2, size.width+strokeThickness, size.height+strokeThickness);
        else if (strokeType == LGDrawerStrokeTypeInside)
            rect = CGRectMake(imageSize.width/2-size.width/2+strokeThickness/2, imageSize.height/2-size.height/2+strokeThickness/2, size.width-strokeThickness, size.height-strokeThickness);

        rect.origin.x += offset.x;
        rect.origin.y += offset.y;

        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        if (strokeDash.count)
        {
            CGFloat cArray[strokeDash.count];

            for (NSUInteger i=0; i<strokeDash.count; i++)
                cArray[i] = [strokeDash[i] floatValue];

            CGContextSetLineDash(context, 0, cArray, strokeDash.count);
        }

        path.lineWidth = strokeThickness;

        // -----

        [strokeColor setStroke];
        [path stroke];
    }

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Triangle

/** Stroke type is center */
+ (UIImage *)drawTriangleWithImageSize:(CGSize)imageSize
                                  size:(CGSize)size
                                offset:(CGPoint)offset
                                rotate:(CGFloat)degrees
                          cornerRadius:(CGFloat)cornerRadius
                             direction:(LGDrawerDirection)direction
                       backgroundColor:(UIColor *)backgroundColor
                             fillColor:(UIColor *)fillColor
                           strokeColor:(UIColor *)strokeColor
                       strokeThickness:(CGFloat)strokeThickness
                            strokeDash:(NSArray *)strokeDash
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGPoint)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    BOOL strokeNeeded = (strokeThickness && strokeColor && ![strokeColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // -----

    CGRect rect = CGRectMake(0.f, 0.f, size.width, size.height);

    CGPoint center;

    UIBezierPath *path = [LGDrawer drawTriangleInRect:rect cornerRadius:cornerRadius direction:direction centerPoint:&center];

    // FILL -----

    if (fillNeeded)
    {
        if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        if (degrees)
        {
            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];
        }

        // -----

        CGPoint pathCenter = CGPointMake(path.bounds.size.width/2, path.bounds.size.height/2);
        CGPoint imageCenter = CGPointMake(imageSize.width/2, imageSize.height/2);

        CGFloat xDif = imageCenter.x-pathCenter.x-path.bounds.origin.x+offset.x;
        CGFloat yDif = imageCenter.y-pathCenter.y-path.bounds.origin.y+offset.y;

        CGAffineTransform translate = CGAffineTransformMakeTranslation(xDif, yDif);
        [path applyTransform:translate];

        // -----

        [fillColor setFill];
        [path fill];
    }

    // STROKE -----

    if (strokeNeeded)
    {
        if (fillNeeded && shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeZero, 0.f, nil);
        else if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        if (!fillNeeded)
        {
            if (degrees)
            {
                CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
                [path applyTransform:rotate];
            }

            // -----

            CGPoint pathCenter = CGPointMake(path.bounds.size.width/2, path.bounds.size.height/2);
            CGPoint imageCenter = CGPointMake(imageSize.width/2, imageSize.height/2);

            CGFloat xDif = imageCenter.x-pathCenter.x-path.bounds.origin.x+offset.x;
            CGFloat yDif = imageCenter.y-pathCenter.y-path.bounds.origin.y+offset.y;

            CGAffineTransform translate = CGAffineTransformMakeTranslation(xDif, yDif);
            [path applyTransform:translate];
        }

        // -----

        if (strokeDash.count)
        {
            CGFloat cArray[strokeDash.count];

            for (NSUInteger i=0; i<strokeDash.count; i++)
                cArray[i] = [strokeDash[i] floatValue];

            CGContextSetLineDash(context, 0, cArray, strokeDash.count);
        }

        path.lineWidth = strokeThickness;

        // -----

        [strokeColor setStroke];
        [path stroke];
    }

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIBezierPath *)drawTriangleInRect:(CGRect)rect
                        cornerRadius:(CGFloat)cornerRadius
                           direction:(LGDrawerDirection)direction
                         centerPoint:(CGPoint *)centerPoint
{
    CGPoint topCenter = CGPointZero;
    CGPoint bottomLeft = CGPointZero;
    CGPoint bottomRight = CGPointZero;

    if (direction == LGDrawerDirectionTop)
    {
        topCenter = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y);
        bottomLeft = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    }
    else if (direction == LGDrawerDirectionBottom)
    {
        topCenter = CGPointMake(rect.origin.x, rect.origin.y);
        bottomLeft = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    }
    else if (direction == LGDrawerDirectionRight)
    {
        topCenter = CGPointMake(rect.origin.x, rect.origin.y);
        bottomLeft = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2);
        bottomRight = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
    }
    else if (direction == LGDrawerDirectionLeft)
    {
        topCenter = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
        bottomLeft = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    }
    else if (direction == LGDrawerDirectionTopLeft)
    {
        topCenter = CGPointMake(rect.origin.x, rect.origin.y);
        bottomLeft = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/3);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width/3, rect.origin.y+rect.size.height);
    }
    else if (direction == LGDrawerDirectionTopRight)
    {
        topCenter = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
        bottomLeft = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height/3);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-rect.size.width/3, rect.origin.y+rect.size.height);
    }
    else if (direction == LGDrawerDirectionBottomLeft)
    {
        topCenter = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
        bottomLeft = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height-rect.size.height/3);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width/3, rect.origin.y);
    }
    else if (direction == LGDrawerDirectionBottomRight)
    {
        topCenter = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
        bottomLeft = CGPointMake(rect.origin.x+rect.size.width-rect.size.width/3, rect.origin.y);
        bottomRight = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height-rect.size.height/3);
    }

    *centerPoint = CGPointMake((topCenter.x+bottomLeft.x+bottomRight.x)/3, (topCenter.y+bottomLeft.y+bottomRight.y)/3);

    if (cornerRadius)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, (bottomLeft.x+topCenter.x)/2, (topCenter.y+bottomLeft.y)/2);
        CGPathAddArcToPoint(path, NULL, bottomLeft.x, bottomLeft.y, (bottomLeft.x+bottomRight.x)/2, (bottomLeft.y+bottomRight.y)/2, cornerRadius);
        CGPathAddArcToPoint(path, NULL, bottomRight.x, bottomRight.y, (bottomRight.x+topCenter.x)/2, (bottomRight.y+topCenter.y)/2, cornerRadius);
        CGPathAddArcToPoint(path, NULL, topCenter.x, topCenter.y, (bottomLeft.x+topCenter.x)/2, (topCenter.y+bottomLeft.y)/2, cornerRadius);
        CGPathCloseSubpath(path);

        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:path];
        CGPathRelease(path);

        return bezierPath;
    }
    else
    {
        UIBezierPath *path = [UIBezierPath new];

        [path moveToPoint:topCenter];
        [path addLineToPoint:bottomLeft];
        [path addLineToPoint:bottomRight];

        [path closePath];

        return path;
    }
}

#pragma mark - Shadow

+ (UIImage *)drawShadowWithImageSize:(CGSize)imageSize
                           direction:(LGDrawerDirection)direction
                     backgroundColor:(UIColor *)backgroundColor
                         shadowColor:(UIColor *)shadowColor
                        shadowOffset:(CGPoint)shadowOffset
                          shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // -----

    CGRect rect = CGRectZero;

    if (direction == LGDrawerDirectionTop)
        rect = CGRectMake(-shadowBlur, imageRect.size.height, imageRect.size.width+shadowBlur*2, shadowBlur);
    else if (direction == LGDrawerDirectionBottom)
        rect = CGRectMake(-shadowBlur, -shadowBlur, imageRect.size.width+shadowBlur*2, shadowBlur);
    else if (direction == LGDrawerDirectionLeft)
        rect = CGRectMake(imageRect.size.width, -shadowBlur, shadowBlur, imageRect.size.height+shadowBlur*2);
    else if (direction == LGDrawerDirectionRight)
        rect = CGRectMake(-shadowBlur, -shadowBlur, shadowBlur, imageRect.size.height+shadowBlur*2);
    else if (direction == LGDrawerDirectionTopLeft)
        rect = CGRectMake(imageRect.size.width, imageRect.size.height, shadowBlur, shadowBlur);
    else if (direction == LGDrawerDirectionTopRight)
        rect = CGRectMake(-shadowBlur, imageRect.size.height, shadowBlur, shadowBlur);
    else if (direction == LGDrawerDirectionBottomLeft)
        rect = CGRectMake(imageRect.size.width, -shadowBlur, shadowBlur, shadowBlur);
    else if (direction == LGDrawerDirectionBottomRight)
        rect = CGRectMake(-shadowBlur, -shadowBlur, shadowBlur, shadowBlur);

    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);
    CGContextFillRect(context, rect);

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Plus

+ (UIImage *)drawPlusWithImageSize:(CGSize)imageSize
                              size:(CGSize)size
                            offset:(CGPoint)offset
                            rotate:(CGFloat)degrees
                         thickness:(CGFloat)thickness
                    roundedCorners:(UIRectCorner)roundedCorners
                      cornerRadius:(CGFloat)cornerRadius
                   backgroundColor:(UIColor *)backgroundColor
                         fillColor:(UIColor *)fillColor
                       strokeColor:(UIColor *)strokeColor
                   strokeThickness:(CGFloat)strokeThickness
                        strokeDash:(NSArray *)strokeDash
                        strokeType:(LGDrawerStrokeType)strokeType
                       shadowColor:(UIColor *)shadowColor
                      shadowOffset:(CGPoint)shadowOffset
                        shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    BOOL strokeNeeded = (strokeThickness && strokeColor && ![strokeColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (fillNeeded)
    {
        if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        CGRect rectV = CGRectMake(imageSize.width/2-thickness/2+offset.x, imageSize.height/2-size.height/2+offset.y, thickness, size.height);
        CGRect rectH = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-thickness/2+offset.y, size.width, thickness);

        CGSize radiusSize = CGSizeMake(cornerRadius, cornerRadius);

        UIBezierPath *path = [UIBezierPath new];
        UIBezierPath *roundedRectV = [UIBezierPath bezierPathWithRoundedRect:rectV byRoundingCorners:roundedCorners cornerRadii:radiusSize];
        UIBezierPath *roundedRectH = [UIBezierPath bezierPathWithRoundedRect:rectH byRoundingCorners:roundedCorners cornerRadii:radiusSize];

        CGAffineTransform mirrorOverX = CGAffineTransformMakeScale(-1.0f, 1.0f);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(imageSize.width-shadowOffset.x, 0);
        [roundedRectH applyTransform:mirrorOverX];
        [roundedRectH applyTransform:translate];

        [path appendPath:roundedRectV];
        [path appendPath:roundedRectH];
        [path appendPath:roundedRectV];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        [fillColor setFill];
        [path fill];
    }

    // STROKE -----

    CGRect rectStrokeV = CGRectZero;
    CGRect rectStrokeH = CGRectZero;
    CGSize radiusSizeStroke = CGSizeZero;

    if (strokeNeeded)
    {
        if (fillNeeded && shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeZero, 0.f, nil);
        else if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        CGRect rectV = CGRectZero;
        CGRect rectH = CGRectZero;

        if (strokeType == LGDrawerStrokeTypeCenter)
        {
            rectV = CGRectMake(imageSize.width/2-thickness/2, imageSize.height/2-size.height/2, thickness, size.height);
            rectH = CGRectMake(imageSize.width/2-size.width/2, imageSize.height/2-thickness/2, size.width, thickness);
        }
        else if (strokeType == LGDrawerStrokeTypeOutside)
        {
            rectV = CGRectMake(imageSize.width/2-thickness/2-strokeThickness/2, imageSize.height/2-size.height/2-strokeThickness/2, thickness+strokeThickness, size.height+strokeThickness);
            rectH = CGRectMake(imageSize.width/2-size.width/2-strokeThickness/2, imageSize.height/2-thickness/2-strokeThickness/2, size.width+strokeThickness, thickness+strokeThickness);
        }
        else if (strokeType == LGDrawerStrokeTypeInside)
        {
            rectV = CGRectMake(imageSize.width/2-thickness/2+strokeThickness/2, imageSize.height/2-size.height/2+strokeThickness/2, thickness-strokeThickness, size.height-strokeThickness);
            rectH = CGRectMake(imageSize.width/2-size.width/2+strokeThickness/2, imageSize.height/2-thickness/2+strokeThickness/2, size.width-strokeThickness, thickness-strokeThickness);
        }

        rectV.origin.x += offset.x;
        rectV.origin.y += offset.y;

        rectH.origin.x += offset.x;
        rectH.origin.y += offset.y;

        rectStrokeV = rectV;
        rectStrokeH = rectH;

        CGSize radiusSize = CGSizeZero;

        if (strokeType == LGDrawerStrokeTypeCenter)
            radiusSize = CGSizeMake(cornerRadius, cornerRadius);
        else if (strokeType == LGDrawerStrokeTypeOutside)
            radiusSize = CGSizeMake(cornerRadius+strokeThickness/2, cornerRadius+strokeThickness/2);
        else if (strokeType == LGDrawerStrokeTypeInside)
            radiusSize = CGSizeMake(cornerRadius-strokeThickness/2, cornerRadius-strokeThickness/2);

        radiusSizeStroke = radiusSize;

        UIBezierPath *path = [UIBezierPath new];
        UIBezierPath *roundedRectV = [UIBezierPath bezierPathWithRoundedRect:rectV byRoundingCorners:roundedCorners cornerRadii:radiusSize];
        UIBezierPath *roundedRectH = [UIBezierPath bezierPathWithRoundedRect:rectH byRoundingCorners:roundedCorners cornerRadii:radiusSize];

        CGAffineTransform mirrorOverX = CGAffineTransformMakeScale(-1.0f, 1.0f);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(imageSize.width-shadowOffset.x, 0);
        [roundedRectH applyTransform:mirrorOverX];
        [roundedRectH applyTransform:translate];

        [path appendPath:roundedRectV];
        [path appendPath:roundedRectH];
        [path appendPath:roundedRectV];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        if (strokeDash.count)
        {
            CGFloat cArray[strokeDash.count];

            for (NSUInteger i=0; i<strokeDash.count; i++)
                cArray[i] = [strokeDash[i] floatValue];

            CGContextSetLineDash(context, 0, cArray, strokeDash.count);
        }

        path.lineWidth = strokeThickness;

        // -----

        [strokeColor setStroke];
        [path stroke];
    }

    // -----

    if (fillNeeded && strokeNeeded)
    {
        CGRect rectV = rectStrokeV;
        CGRect rectH = rectStrokeH;

        rectV.origin.x += strokeThickness/2;
        rectV.origin.y += strokeThickness/2;
        rectV.size.width -= strokeThickness;
        rectV.size.height -= strokeThickness;

        rectH.origin.x += strokeThickness/2;
        rectH.origin.y += strokeThickness/2;
        rectH.size.width -= strokeThickness;
        rectH.size.height -= strokeThickness;

        CGSize radiusSize = radiusSizeStroke;

        radiusSize.width -= strokeThickness/2;
        radiusSize.height -= strokeThickness/2;

        UIBezierPath *path = [UIBezierPath new];
        UIBezierPath *roundedRectV = [UIBezierPath bezierPathWithRoundedRect:rectV byRoundingCorners:roundedCorners cornerRadii:radiusSize];
        UIBezierPath *roundedRectH = [UIBezierPath bezierPathWithRoundedRect:rectH byRoundingCorners:roundedCorners cornerRadii:radiusSize];

        CGAffineTransform mirrorOverX = CGAffineTransformMakeScale(-1.0f, 1.0f);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(imageSize.width-shadowOffset.x, 0);
        [roundedRectH applyTransform:mirrorOverX];
        [roundedRectH applyTransform:translate];

        [path appendPath:roundedRectV];
        [path appendPath:roundedRectH];
        [path appendPath:roundedRectV];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        CGContextSetBlendMode(context, kCGBlendModeClear);

        [[UIColor blackColor] setFill];
        [path fill];

        // -----

        CGContextSetBlendMode(context, kCGBlendModeNormal);

        if (backgroundNeeded)
        {
            [backgroundColor setFill];
            [path fill];
        }

        [fillColor setFill];
        [path fill];
    }

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)drawPlusWithImageSize:(CGSize)imageSize
                              size:(CGSize)size
                            offset:(CGPoint)offset
                            rotate:(CGFloat)degrees
                         thickness:(CGFloat)thickness
                   backgroundColor:(UIColor *)backgroundColor
                             color:(UIColor *)color
                              dash:(NSArray *)dash
                       shadowColor:(UIColor *)shadowColor
                      shadowOffset:(CGPoint)shadowOffset
                        shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (shadowNeeded)
        CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

    // -----

    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+rect.size.height/2)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2)];
    [path moveToPoint:CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height)];

    // -----

    if (degrees)
    {
        CGRect originalBounds = path.bounds;

        CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
        [path applyTransform:rotate];

        CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                       -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
        [path applyTransform:translate];
    }

    // -----

    if (dash.count)
    {
        CGFloat cArray[dash.count];

        for (NSUInteger i=0; i<dash.count; i++)
            cArray[i] = [dash[i] floatValue];

        CGContextSetLineDash(context, 0, cArray, dash.count);
    }

    path.lineWidth = thickness;

    // -----

    [color setStroke];
    [path stroke];

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Cross

+ (UIImage *)drawCrossWithImageSize:(CGSize)imageSize
                               size:(CGSize)size
                             offset:(CGPoint)offset
                             rotate:(CGFloat)degrees
                          thickness:(CGFloat)thickness
                     roundedCorners:(UIRectCorner)roundedCorners
                       cornerRadius:(CGFloat)cornerRadius
                    backgroundColor:(UIColor *)backgroundColor
                          fillColor:(UIColor *)fillColor
                        strokeColor:(UIColor *)strokeColor
                    strokeThickness:(CGFloat)strokeThickness
                         strokeDash:(NSArray *)strokeDash
                         strokeType:(LGDrawerStrokeType)strokeType
                        shadowColor:(UIColor *)shadowColor
                       shadowOffset:(CGPoint)shadowOffset
                         shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    BOOL strokeNeeded = (strokeThickness && strokeColor && ![strokeColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    CGFloat rotateDegrees = 45.f;

    if (size.width > size.height)
        rotateDegrees += (45.f-45.f*(size.height/size.width));
    else if (size.height > size.width)
        rotateDegrees -= (45.f-45.f*(size.width/size.height));

    // -----

    if (fillNeeded)
    {
        if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        CGFloat length = sqrt((size.width*size.width)+(size.height*size.height))-thickness;

        CGRect rect = CGRectMake(imageSize.width/2-thickness/2+offset.x, imageSize.height/2-length/2+offset.y, thickness, length);

        CGSize radiusSize = CGSizeMake(cornerRadius, cornerRadius);

        UIBezierPath *path = [UIBezierPath new];
        UIBezierPath *roundedRectV = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:radiusSize];
        UIBezierPath *roundedRectH = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:radiusSize];

        {
            CGRect originalBounds = roundedRectH.bounds;

            CGAffineTransform mirrorOverX = CGAffineTransformMakeScale(-1.0f, 1.0f);
            [roundedRectH applyTransform:mirrorOverX];

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(rotateDegrees));
            [roundedRectH applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(roundedRectH.bounds.origin.x-originalBounds.origin.x)-(roundedRectH.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(roundedRectH.bounds.origin.y-originalBounds.origin.y)-(roundedRectH.bounds.size.height-originalBounds.size.height)*0.5);
            [roundedRectH applyTransform:translate];
        }

        {
            CGRect originalBounds = roundedRectV.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(-rotateDegrees));
            [roundedRectV applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(roundedRectV.bounds.origin.x-originalBounds.origin.x)-(roundedRectV.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(roundedRectV.bounds.origin.y-originalBounds.origin.y)-(roundedRectV.bounds.size.height-originalBounds.size.height)*0.5);
            [roundedRectV applyTransform:translate];
        }

        [path appendPath:roundedRectV];
        [path appendPath:roundedRectH];
        [path appendPath:roundedRectV];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        [fillColor setFill];
        [path fill];
    }

    // STROKE -----

    CGRect rectStroke = CGRectZero;
    CGSize radiusSizeStroke = CGSizeZero;

    if (strokeNeeded)
    {
        if (fillNeeded && shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeZero, 0.f, nil);
        else if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        CGFloat length = sqrt((size.width*size.width)+(size.height*size.height))-thickness;

        CGRect rect = CGRectZero;

        if (strokeType == LGDrawerStrokeTypeCenter)
            rect = CGRectMake(imageSize.width/2-thickness/2, imageSize.height/2-length/2, thickness, length);
        else if (strokeType == LGDrawerStrokeTypeOutside)
            rect = CGRectMake(imageSize.width/2-thickness/2-strokeThickness/2, imageSize.height/2-length/2-strokeThickness/2, thickness+strokeThickness, length+strokeThickness);
        else if (strokeType == LGDrawerStrokeTypeInside)
            rect = CGRectMake(imageSize.width/2-thickness/2+strokeThickness/2, imageSize.height/2-length/2+strokeThickness/2, thickness-strokeThickness, length-strokeThickness);

        rect.origin.x += offset.x;
        rect.origin.y += offset.y;

        rectStroke = rect;

        CGSize radiusSize = CGSizeZero;

        if (strokeType == LGDrawerStrokeTypeCenter)
            radiusSize = CGSizeMake(cornerRadius, cornerRadius);
        else if (strokeType == LGDrawerStrokeTypeOutside)
            radiusSize = CGSizeMake(cornerRadius+strokeThickness/2, cornerRadius+strokeThickness/2);
        else if (strokeType == LGDrawerStrokeTypeInside)
            radiusSize = CGSizeMake(cornerRadius-strokeThickness/2, cornerRadius-strokeThickness/2);

        radiusSizeStroke = radiusSize;

        UIBezierPath *path = [UIBezierPath new];
        UIBezierPath *roundedRectV = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:radiusSize];
        UIBezierPath *roundedRectH = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:radiusSize];

        {
            CGRect originalBounds = roundedRectH.bounds;

            CGAffineTransform mirrorOverX = CGAffineTransformMakeScale(-1.0f, 1.0f);
            [roundedRectH applyTransform:mirrorOverX];

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(rotateDegrees));
            [roundedRectH applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(roundedRectH.bounds.origin.x-originalBounds.origin.x)-(roundedRectH.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(roundedRectH.bounds.origin.y-originalBounds.origin.y)-(roundedRectH.bounds.size.height-originalBounds.size.height)*0.5);
            [roundedRectH applyTransform:translate];
        }

        {
            CGRect originalBounds = roundedRectV.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(-rotateDegrees));
            [roundedRectV applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(roundedRectV.bounds.origin.x-originalBounds.origin.x)-(roundedRectV.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(roundedRectV.bounds.origin.y-originalBounds.origin.y)-(roundedRectV.bounds.size.height-originalBounds.size.height)*0.5);
            [roundedRectV applyTransform:translate];
        }

        [path appendPath:roundedRectV];
        [path appendPath:roundedRectH];
        [path appendPath:roundedRectV];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        if (strokeDash.count)
        {
            CGFloat cArray[strokeDash.count];

            for (NSUInteger i=0; i<strokeDash.count; i++)
                cArray[i] = [strokeDash[i] floatValue];

            CGContextSetLineDash(context, 0, cArray, strokeDash.count);
        }

        path.lineWidth = strokeThickness;

        // -----

        [strokeColor setStroke];
        [path stroke];
    }

    // -----

    if (fillNeeded && strokeNeeded)
    {
        CGRect rect = rectStroke;

        rect.origin.x += strokeThickness/2;
        rect.origin.y += strokeThickness/2;
        rect.size.width -= strokeThickness;
        rect.size.height -= strokeThickness;

        CGSize radiusSize = radiusSizeStroke;

        radiusSize.width -= strokeThickness/2;
        radiusSize.height -= strokeThickness/2;

        UIBezierPath *path = [UIBezierPath new];
        UIBezierPath *roundedRectV = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:radiusSize];
        UIBezierPath *roundedRectH = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:roundedCorners cornerRadii:radiusSize];

        {
            CGRect originalBounds = roundedRectH.bounds;

            CGAffineTransform mirrorOverX = CGAffineTransformMakeScale(-1.0f, 1.0f);
            [roundedRectH applyTransform:mirrorOverX];

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(rotateDegrees));
            [roundedRectH applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(roundedRectH.bounds.origin.x-originalBounds.origin.x)-(roundedRectH.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(roundedRectH.bounds.origin.y-originalBounds.origin.y)-(roundedRectH.bounds.size.height-originalBounds.size.height)*0.5);
            [roundedRectH applyTransform:translate];
        }

        {
            CGRect originalBounds = roundedRectV.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(-rotateDegrees));
            [roundedRectV applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(roundedRectV.bounds.origin.x-originalBounds.origin.x)-(roundedRectV.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(roundedRectV.bounds.origin.y-originalBounds.origin.y)-(roundedRectV.bounds.size.height-originalBounds.size.height)*0.5);
            [roundedRectV applyTransform:translate];
        }

        [path appendPath:roundedRectV];
        [path appendPath:roundedRectH];
        [path appendPath:roundedRectV];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        CGContextSetBlendMode(context, kCGBlendModeClear);

        [[UIColor blackColor] setFill];
        [path fill];

        // -----

        CGContextSetBlendMode(context, kCGBlendModeNormal);

        if (backgroundNeeded)
        {
            [backgroundColor setFill];
            [path fill];
        }

        [fillColor setFill];
        [path fill];
    }

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)drawCrossWithImageSize:(CGSize)imageSize
                               size:(CGSize)size
                             offset:(CGPoint)offset
                             rotate:(CGFloat)degrees
                          thickness:(CGFloat)thickness
                    backgroundColor:(UIColor *)backgroundColor
                              color:(UIColor *)color
                               dash:(NSArray *)dash
                        shadowColor:(UIColor *)shadowColor
                       shadowOffset:(CGPoint)shadowOffset
                         shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (shadowNeeded)
        CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

    // -----

    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(rect.origin.x+thickness/2, rect.origin.y+thickness/2)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-thickness/2)];
    [path moveToPoint:CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+thickness/2)];
    [path addLineToPoint:CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height-thickness/2)];

    // -----

    if (degrees)
    {
        CGRect originalBounds = path.bounds;

        CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
        [path applyTransform:rotate];

        CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                       -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
        [path applyTransform:translate];
    }

    // -----

    if (dash.count)
    {
        CGFloat cArray[dash.count];

        for (NSUInteger i=0; i<dash.count; i++)
            cArray[i] = [dash[i] floatValue];

        CGContextSetLineDash(context, 0, cArray, dash.count);
    }

    path.lineWidth = thickness;

    // -----

    [color setStroke];
    [path stroke];

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Line

+ (UIImage *)drawLineWithImageSize:(CGSize)imageSize
                            length:(CGFloat)length
                            offset:(CGPoint)offset
                            rotate:(CGFloat)degrees
                         thickness:(CGFloat)thickness
                         direction:(LGDrawerLineDirection)direction
                   backgroundColor:(UIColor *)backgroundColor
                             color:(UIColor *)color
                              dash:(NSArray *)dash
                       shadowColor:(UIColor *)shadowColor
                      shadowOffset:(CGPoint)shadowOffset
                        shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (shadowNeeded)
        CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

    // -----

    CGPoint center = CGPointMake(imageSize.width/2+offset.x, imageSize.height/2+offset.y);

    UIBezierPath *path = [UIBezierPath new];

    if (direction == LGDrawerLineDirectionHorizontal)
    {
        [path moveToPoint:CGPointMake(center.x-length/2, center.y)];
        [path addLineToPoint:CGPointMake(center.x+length/2, center.y)];
    }
    else if (direction == LGDrawerLineDirectionVertical)
    {
        [path moveToPoint:CGPointMake(center.x, center.y-length/2)];
        [path addLineToPoint:CGPointMake(center.x, center.y+length/2)];
    }
    else if (direction == LGDrawerLineDirectionDiagonalTopRight)
    {
        CGFloat half = sqrtf(pow(length, 2)/2);

        [path moveToPoint:CGPointMake(center.x+half/2, center.y-half/2)];
        [path addLineToPoint:CGPointMake(center.x-half/2, center.y+half/2)];
    }
    else if (direction == LGDrawerLineDirectionDiagonalTopLeft)
    {
        CGFloat half = sqrtf(pow(length, 2)/2);

        [path moveToPoint:CGPointMake(center.x-half/2, center.y-half/2)];
        [path addLineToPoint:CGPointMake(center.x+half/2, center.y+half/2)];
    }

    // -----

    if (degrees)
    {
        CGRect originalBounds = path.bounds;

        CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
        [path applyTransform:rotate];

        CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                       -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
        [path applyTransform:translate];
    }

    // -----

    if (dash.count)
    {
        CGFloat cArray[dash.count];

        for (NSUInteger i=0; i<dash.count; i++)
            cArray[i] = [dash[i] floatValue];

        CGContextSetLineDash(context, 0, cArray, dash.count);
    }

    path.lineWidth = thickness;

    // -----

    [color setStroke];
    [path stroke];

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Tick

+ (UIImage *)drawTickWithImageSize:(CGSize)imageSize
                              size:(CGSize)size
                            offset:(CGPoint)offset
                            rotate:(CGFloat)degrees
                         thickness:(CGFloat)thickness
                   backgroundColor:(UIColor *)backgroundColor
                             color:(UIColor *)color
                              dash:(NSArray *)dash
                       shadowColor:(UIColor *)shadowColor
                      shadowOffset:(CGPoint)shadowOffset
                        shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (shadowNeeded)
        CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

    // -----

    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

    UIBezierPath *path = [UIBezierPath new];

    [path moveToPoint:CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height*0.6)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width*0.4, rect.origin.y+rect.size.height-thickness/2)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+thickness/2)];

    // -----

    if (degrees)
    {
        CGRect originalBounds = path.bounds;

        CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
        [path applyTransform:rotate];

        CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                       -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
        [path applyTransform:translate];
    }

    // -----

    if (dash.count)
    {
        CGFloat cArray[dash.count];

        for (NSUInteger i=0; i<dash.count; i++)
            cArray[i] = [dash[i] floatValue];

        CGContextSetLineDash(context, 0, cArray, dash.count);
    }

    path.lineWidth = thickness;

    // -----

    [color setStroke];
    [path stroke];

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Arrow

+ (UIImage *)drawArrowWithImageSize:(CGSize)imageSize
                               size:(CGSize)size
                             offset:(CGPoint)offset
                             rotate:(CGFloat)degrees
                          thickness:(CGFloat)thickness
                          direction:(LGDrawerDirection)direction
                    backgroundColor:(UIColor *)backgroundColor
                              color:(UIColor *)color
                               dash:(NSArray *)dash
                        shadowColor:(UIColor *)shadowColor
                       shadowOffset:(CGPoint)shadowOffset
                         shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (shadowNeeded)
        CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

    // -----

    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

    CGPoint topCenter = CGPointZero;
    CGPoint bottomLeft = CGPointZero;
    CGPoint bottomRight = CGPointZero;

    if (direction == LGDrawerDirectionTop)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height-thickness/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-thickness/2);
    }
    else if (direction == LGDrawerDirectionBottom)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height-thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+thickness/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+thickness/2);
    }
    else if (direction == LGDrawerDirectionRight)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height/2);
        bottomLeft  = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+thickness/2);
        bottomRight = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height-thickness/2);
    }
    else if (direction == LGDrawerDirectionLeft)
    {
        topCenter   = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-thickness/2);
    }
    else if (direction == LGDrawerDirectionTopLeft)
    {
        topCenter   = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height/3);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width/3, rect.origin.y+rect.size.height-thickness/2);
    }
    else if (direction == LGDrawerDirectionTopRight)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height/3);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-rect.size.width/3, rect.origin.y+rect.size.height-thickness/2);
    }
    else if (direction == LGDrawerDirectionBottomLeft)
    {
        topCenter   = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height-thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-rect.size.height/3);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width/3, rect.origin.y+thickness/2);
    }
    else if (direction == LGDrawerDirectionBottomRight)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width-rect.size.width/3, rect.origin.y+thickness/2);
        bottomRight = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height-rect.size.height/3);
    }

    UIBezierPath *path = [UIBezierPath new];

    [path moveToPoint:bottomLeft];
    [path addLineToPoint:topCenter];
    [path addLineToPoint:bottomRight];

    // -----

    if (degrees)
    {
        CGRect originalBounds = path.bounds;

        CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
        [path applyTransform:rotate];

        CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                       -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
        [path applyTransform:translate];
    }

    // -----

    if (dash.count)
    {
        CGFloat cArray[dash.count];

        for (NSUInteger i=0; i<dash.count; i++)
            cArray[i] = [dash[i] floatValue];

        CGContextSetLineDash(context, 0, cArray, dash.count);
    }

    path.lineWidth = thickness;

    // -----

    [color setStroke];
    [path stroke];

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)drawArrowTailedWithImageSize:(CGSize)imageSize
                                     size:(CGSize)size
                                   offset:(CGPoint)offset
                                   rotate:(CGFloat)degrees
                                thickness:(CGFloat)thickness
                                direction:(LGDrawerDirection)direction
                          backgroundColor:(UIColor *)backgroundColor
                                    color:(UIColor *)color
                                     dash:(NSArray *)dash
                              shadowColor:(UIColor *)shadowColor
                             shadowOffset:(CGPoint)shadowOffset
                               shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // FILL -----

    if (shadowNeeded)
        CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

    // -----

    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

    CGPoint topCenter = CGPointZero;
    CGPoint bottomLeft = CGPointZero;
    CGPoint bottomRight = CGPointZero;
    CGPoint tail = CGPointZero;

    if (direction == LGDrawerDirectionTop)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height/2);
        tail        = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
    }
    else if (direction == LGDrawerDirectionBottom)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height-thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height/2);
        tail        = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y);
    }
    else if (direction == LGDrawerDirectionRight)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+thickness/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height-thickness/2);
        tail        = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height/2);
    }
    else if (direction == LGDrawerDirectionLeft)
    {
        topCenter   = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height-thickness/2);
        tail        = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2);
    }
    else if (direction == LGDrawerDirectionTopLeft)
    {
        topCenter   = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height-rect.size.height/4);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-rect.size.width/4, rect.origin.y+thickness/2);
        tail        = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-thickness/2);
    }
    else if (direction == LGDrawerDirectionTopRight)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width/4, rect.origin.y+thickness/2);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-rect.size.height/4);
        tail        = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height-thickness/2);
    }
    else if (direction == LGDrawerDirectionBottomLeft)
    {
        topCenter   = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height-thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width-rect.size.width/4, rect.origin.y+rect.size.height-thickness/2);
        bottomRight = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+rect.size.height/4);
        tail        = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+thickness/2);
    }
    else if (direction == LGDrawerDirectionBottomRight)
    {
        topCenter   = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height-thickness/2);
        bottomLeft  = CGPointMake(rect.origin.x+rect.size.width-thickness/2, rect.origin.y+rect.size.height/4);
        bottomRight = CGPointMake(rect.origin.x+rect.size.width/4, rect.origin.y+rect.size.height-thickness/2);
        tail        = CGPointMake(rect.origin.x+thickness/2, rect.origin.y+thickness/2);
    }

    UIBezierPath *path = [UIBezierPath new];

    [path moveToPoint:bottomLeft];
    [path addLineToPoint:topCenter];
    [path addLineToPoint:bottomRight];

    [path moveToPoint:topCenter];
    [path addLineToPoint:tail];

    // -----

    if (degrees)
    {
        CGRect originalBounds = path.bounds;

        CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
        [path applyTransform:rotate];

        CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                       -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
        [path applyTransform:translate];
    }

    // -----

    if (dash.count)
    {
        CGFloat cArray[dash.count];

        for (NSUInteger i=0; i<dash.count; i++)
            cArray[i] = [dash[i] floatValue];

        CGContextSetLineDash(context, 0, cArray, dash.count);
    }

    path.lineWidth = thickness;

    // -----

    [color setStroke];
    [path stroke];

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Heart

/** Stroke type is center */
+ (UIImage *)drawHeartWithImageSize:(CGSize)imageSize
                               size:(CGSize)size
                             offset:(CGPoint)offset
                             rotate:(CGFloat)degrees
                    backgroundColor:(UIColor *)backgroundColor
                          fillColor:(UIColor *)fillColor
                        strokeColor:(UIColor *)strokeColor
                    strokeThickness:(CGFloat)strokeThickness
                         strokeDash:(NSArray *)strokeDash
                        shadowColor:(UIColor *)shadowColor
                       shadowOffset:(CGPoint)shadowOffset
                         shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    BOOL strokeNeeded = (strokeThickness && strokeColor && ![strokeColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // -----

    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

    UIBezierPath *path = [UIBezierPath new];

    [path moveToPoint:CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.width/4)];
    [path addArcWithCenter:CGPointMake(rect.origin.x+rect.size.width/4, rect.origin.y+rect.size.width/4) radius:rect.size.width/4 startAngle:0.f endAngle:kLGDrawerDegreesToRadians(180.f) clockwise:NO];
    [path addCurveToPoint:CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height)
            controlPoint1:CGPointMake(rect.origin.x, rect.origin.y+rect.size.height*0.5)
            controlPoint2:CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height*0.8)];
    [path addCurveToPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.width/4)
            controlPoint1:CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height*0.8)
            controlPoint2:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height*0.5)];
    [path addArcWithCenter:CGPointMake(rect.origin.x+rect.size.width/2+rect.size.width/4, rect.origin.y+rect.size.width/4) radius:rect.size.width/4 startAngle:0.f endAngle:kLGDrawerDegreesToRadians(180.f) clockwise:NO];

    [path closePath];

    // FILL -----

    if (fillNeeded)
    {
        if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        [fillColor setFill];
        [path fill];
    }

    // STROKE -----

    if (strokeNeeded)
    {
        if (fillNeeded && shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeZero, 0.f, nil);
        else if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        if (!fillNeeded)
        {
            if (degrees)
            {
                CGRect originalBounds = path.bounds;

                CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
                [path applyTransform:rotate];

                CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                               -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
                [path applyTransform:translate];
            }
        }

        // -----

        if (strokeDash.count)
        {
            CGFloat cArray[strokeDash.count];

            for (NSUInteger i=0; i<strokeDash.count; i++)
                cArray[i] = [strokeDash[i] floatValue];

            CGContextSetLineDash(context, 0, cArray, strokeDash.count);
        }

        path.lineWidth = strokeThickness;

        // -----

        [strokeColor setStroke];
        [path stroke];
    }

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Star

/** Stroke type is center */
+ (UIImage *)drawStarWithImageSize:(CGSize)imageSize
                              size:(CGSize)size
                            offset:(CGPoint)offset
                            rotate:(CGFloat)degrees
                   backgroundColor:(UIColor *)backgroundColor
                         fillColor:(UIColor *)fillColor
                       strokeColor:(UIColor *)strokeColor
                   strokeThickness:(CGFloat)strokeThickness
                        strokeDash:(NSArray *)strokeDash
                       shadowColor:(UIColor *)shadowColor
                      shadowOffset:(CGPoint)shadowOffset
                        shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    BOOL strokeNeeded = (strokeThickness && strokeColor && ![strokeColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // -----

    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

    UIBezierPath *path = [self drawStarInRect:rect];

    // FILL -----

    if (fillNeeded)
    {
        if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        [fillColor setFill];
        [path fill];
    }

    // STROKE -----

    if (strokeNeeded)
    {
        if (fillNeeded && shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeZero, 0.f, nil);
        else if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        if (!fillNeeded)
        {
            if (degrees)
            {
                CGRect originalBounds = path.bounds;

                CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
                [path applyTransform:rotate];

                CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                               -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
                [path applyTransform:translate];
            }
        }

        // -----

        if (strokeDash.count)
        {
            CGFloat cArray[strokeDash.count];

            for (NSUInteger i=0; i<strokeDash.count; i++)
                cArray[i] = [strokeDash[i] floatValue];

            CGContextSetLineDash(context, 0, cArray, strokeDash.count);
        }

        path.lineWidth = strokeThickness;

        // -----

        [strokeColor setStroke];
        [path stroke];
    }

    if (fillNeeded && strokeNeeded)
    {
        CGRect rect = CGRectMake(imageSize.width/2-size.width/2+strokeThickness+offset.x, imageSize.height/2-size.height/2+strokeThickness+offset.y, size.width-strokeThickness*2, size.height-strokeThickness*2);

        UIBezierPath *path = [self drawStarInRect:rect];

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        CGContextSetBlendMode(context, kCGBlendModeClear);

        [[UIColor blackColor] setFill];
        [path fill];

        // -----

        CGContextSetBlendMode(context, kCGBlendModeNormal);

        if (backgroundNeeded)
        {
            [backgroundColor setFill];
            [path fill];
        }

        [fillColor setFill];
        [path fill];
    }

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIBezierPath *)drawStarInRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath new];

    CGFloat xCenter = rect.origin.x+rect.size.width/2;
    CGFloat yCenter = rect.origin.y+rect.size.height*0.55;

    CGFloat w = rect.size.height;
    CGFloat r = w * 0.52;
    CGFloat flip = -1.0;

    CGFloat theta = kLGDrawerDegreesToRadians(144);

    [path moveToPoint:CGPointMake(xCenter, r*flip+yCenter)];

    CGFloat savedX = xCenter;
    CGFloat savedY = r*flip+yCenter;

    for (NSUInteger k=1; k<=5; k++)
    {
        CGFloat x = r * sin(k * theta);
        CGFloat y = r * cos(k * theta);

        x = x+xCenter;
        y = y*flip+yCenter;

        CGFloat midX = (MAX(x, savedX)-MIN(x, savedX))/2;
        CGFloat midY = (MAX(y, savedY)-MIN(y, savedY))/2;

        CGFloat shift = 2;

        if (k == 1)
            [path addLineToPoint:CGPointMake(MIN(x, savedX)+midX+shift, MIN(y, savedY)+midY-shift)];
        else if (k == 2)
            [path addLineToPoint:CGPointMake(MIN(x, savedX)+midX-shift, MIN(y, savedY)+midY+shift)];
        else if (k == 3)
            [path addLineToPoint:CGPointMake(MIN(x, savedX)+midX,       MIN(y, savedY)+midY-shift)];
        else if (k == 4)
            [path addLineToPoint:CGPointMake(MIN(x, savedX)+midX+shift, MIN(y, savedY)+midY+shift)];
        else if (k == 5)
            [path addLineToPoint:CGPointMake(MIN(x, savedX)+midX-shift, MIN(y, savedY)+midY-shift)];

        [path addLineToPoint:CGPointMake(x, y)];

        savedX = x;
        savedY = y;
    }

    [path closePath];

    return path;
}

#pragma mark - Menu

+ (UIImage *)drawMenuWithImageSize:(CGSize)imageSize
                              size:(CGSize)size
                            offset:(CGPoint)offset
                            rotate:(CGFloat)degrees
                         thickness:(CGFloat)thickness
                            dotted:(BOOL)dotted
                      dotsPosition:(LGDrawerMenuDotsPosition)dotsPosition
                  dotsCornerRadius:(CGFloat)dotsCornerRadius
                 linesCornerRadius:(CGFloat)linesCornerRadius
                   backgroundColor:(UIColor *)backgroundColor
                         fillColor:(UIColor *)fillColor
                       strokeColor:(UIColor *)strokeColor
                   strokeThickness:(CGFloat)strokeThickness
                        strokeDash:(NSArray *)strokeDash
                       shadowColor:(UIColor *)shadowColor
                      shadowOffset:(CGPoint)shadowOffset
                        shadowBlur:(CGFloat)shadowBlur
{
    CGRect imageRect = CGRectMake(0.f, 0.f, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL backgroundNeeded = (backgroundColor && ![backgroundColor isEqual:[UIColor clearColor]]);
    BOOL fillNeeded = (fillColor && ![fillColor isEqual:[UIColor clearColor]]);
    BOOL strokeNeeded = (strokeThickness && strokeColor && ![strokeColor isEqual:[UIColor clearColor]]);
    BOOL shadowNeeded = (shadowColor && ![shadowColor isEqual:[UIColor clearColor]]);

    // BACKGROUND -----

    if (backgroundNeeded)
    {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, imageRect);
    }

    // -----

    CGRect rect = CGRectMake(imageSize.width/2-size.width/2+offset.x, imageSize.height/2-size.height/2+offset.y, size.width, size.height);

    UIBezierPath *path = [UIBezierPath new];

    CGFloat originX = rect.origin.x;
    CGFloat sizeWidth = rect.size.width;

    if (dotted)
    {
        if (dotsPosition == LGDrawerMenuDotsPositionLeft)
            originX = rect.origin.x+thickness*1.5;

        sizeWidth -= thickness*1.5;
    }

    {
        CGRect rect1 = CGRectMake(originX, rect.origin.y, sizeWidth, thickness);
        CGRect rect2 = CGRectMake(originX, rect.origin.y+rect.size.height/2-thickness/2, sizeWidth, thickness);
        CGRect rect3 = CGRectMake(originX, rect.origin.y+rect.size.height-thickness, sizeWidth, thickness);

        UIBezierPath *line1;
        UIBezierPath *line2;
        UIBezierPath *line3;

        if (dotsCornerRadius)
        {
            line1 = [UIBezierPath bezierPathWithRoundedRect:rect1 cornerRadius:linesCornerRadius];
            line2 = [UIBezierPath bezierPathWithRoundedRect:rect2 cornerRadius:linesCornerRadius];
            line3 = [UIBezierPath bezierPathWithRoundedRect:rect3 cornerRadius:linesCornerRadius];
        }
        else
        {
            line1 = [UIBezierPath bezierPathWithRect:rect1];
            line2 = [UIBezierPath bezierPathWithRect:rect2];
            line3 = [UIBezierPath bezierPathWithRect:rect3];
        }

        [path appendPath:line1];
        [path appendPath:line2];
        [path appendPath:line3];
    }

    if (dotted)
    {
        CGRect rect1 = CGRectMake(rect.origin.x, rect.origin.y, thickness, thickness);
        CGRect rect2 = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height/2-thickness/2, thickness, thickness);
        CGRect rect3 = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height-thickness, thickness, thickness);

        if (dotsPosition == LGDrawerMenuDotsPositionRight)
        {
            rect1.origin.x += rect.size.width-thickness;
            rect2.origin.x += rect.size.width-thickness;
            rect3.origin.x += rect.size.width-thickness;
        }

        UIBezierPath *dot1;
        UIBezierPath *dot2;
        UIBezierPath *dot3;

        if (dotsCornerRadius)
        {
            dot1 = [UIBezierPath bezierPathWithRoundedRect:rect1 cornerRadius:dotsCornerRadius];
            dot2 = [UIBezierPath bezierPathWithRoundedRect:rect2 cornerRadius:dotsCornerRadius];
            dot3 = [UIBezierPath bezierPathWithRoundedRect:rect3 cornerRadius:dotsCornerRadius];
        }
        else
        {
            dot1 = [UIBezierPath bezierPathWithRect:rect1];
            dot2 = [UIBezierPath bezierPathWithRect:rect2];
            dot3 = [UIBezierPath bezierPathWithRect:rect3];
        }

        [path appendPath:dot1];
        [path appendPath:dot2];
        [path appendPath:dot3];
    }

    // FILL -----

    if (fillNeeded)
    {
        if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        if (degrees)
        {
            CGRect originalBounds = path.bounds;

            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];

            CGAffineTransform translate = CGAffineTransformMakeTranslation(-(path.bounds.origin.x-originalBounds.origin.x)-(path.bounds.size.width-originalBounds.size.width)*0.5,
                                                                           -(path.bounds.origin.y-originalBounds.origin.y)-(path.bounds.size.height-originalBounds.size.height)*0.5);
            [path applyTransform:translate];
        }

        // -----

        [fillColor setFill];
        [path fill];
    }

    // STROKE -----

    if (strokeNeeded)
    {
        if (fillNeeded && shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeZero, 0.f, nil);
        else if (shadowNeeded)
            CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.x, shadowOffset.y), shadowBlur, shadowColor.CGColor);

        // -----

        if (degrees)
        {
            CGAffineTransform rotate = CGAffineTransformMakeRotation(kLGDrawerDegreesToRadians(degrees));
            [path applyTransform:rotate];
        }

        // -----

        CGPoint pathCenter = CGPointMake(path.bounds.size.width/2, path.bounds.size.height/2);
        CGPoint imageCenter = CGPointMake(imageSize.width/2, imageSize.height/2);

        CGFloat xDif = imageCenter.x-pathCenter.x-path.bounds.origin.x+offset.x;
        CGFloat yDif = imageCenter.y-pathCenter.y-path.bounds.origin.y+offset.y;

        CGAffineTransform translate = CGAffineTransformMakeTranslation(xDif, yDif);
        [path applyTransform:translate];

        // -----

        if (strokeDash.count)
        {
            CGFloat cArray[strokeDash.count];

            for (NSUInteger i=0; i<strokeDash.count; i++)
                cArray[i] = [strokeDash[i] floatValue];

            CGContextSetLineDash(context, 0, cArray, strokeDash.count);
        }

        path.lineWidth = strokeThickness;

        // -----

        [strokeColor setStroke];
        [path stroke];
    }

    // MAKE UIImage -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Images

+ (UIImage *)drawImage:(UIImage *)image2
               onImage:(UIImage *)image1
                 clear:(BOOL)clear
{
    CGSize finishSize = CGSizeMake(MAX(image1.size.width, image2.size.width), MAX(image1.size.height, image2.size.height));

    CGRect rect1 = CGRectMake(finishSize.width/2-image1.size.width/2, finishSize.height/2-image1.size.height/2, image1.size.width, image1.size.height);

    CGRect rect2 = CGRectMake(finishSize.width/2-image2.size.width/2, finishSize.height/2-image2.size.height/2, image2.size.width, image2.size.height);

    // -----

    UIGraphicsBeginImageContextWithOptions(finishSize, NO, 0.f);

    [image1 drawInRect:rect1];

    if (clear)
        [image2 drawInRect:rect2 blendMode:kCGBlendModeXOR alpha:1.f];
    else
        [image2 drawInRect:rect2];

    // -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)drawImageOnImage:(NSArray *)images
{
    CGSize finishSize = CGSizeZero;

    for (UIImage *image in images)
        finishSize = CGSizeMake(MAX(finishSize.width, image.size.width), MAX(finishSize.height, image.size.height));

    UIGraphicsBeginImageContextWithOptions(finishSize, NO, 0.f);

    for (UIImage *image in images)
    {
        CGRect rect = CGRectMake(finishSize.width/2-image.size.width/2, finishSize.height/2-image.size.height/2, image.size.width, image.size.height);

        [image drawInRect:rect];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)drawImagesWithFinishSize:(CGSize)finishSize
                               image1:(UIImage *)image1
                           image1Rect:(CGRect)rect1
                               image2:(UIImage *)image2
                           image2Rect:(CGRect)rect2
                                clear:(BOOL)clear
{
    UIGraphicsBeginImageContextWithOptions(finishSize, NO, 0.f);

    [image1 drawInRect:rect1];

    if (clear)
        [image2 drawInRect:rect2 blendMode:kCGBlendModeXOR alpha:1.f];
    else
        [image2 drawInRect:rect2];

    // -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)drawImagesWithFinishSize:(CGSize)finishSize
                               image1:(UIImage *)image1
                         image1Offset:(CGPoint)offset1
                               image2:(UIImage *)image2
                         image2Offset:(CGPoint)offset2
                                clear:(BOOL)clear
{
    CGRect rect1 = CGRectMake(finishSize.width/2-image1.size.width/2+offset1.x, finishSize.height/2-image1.size.height/2+offset1.y, image1.size.width, image1.size.height);

    CGRect rect2 = CGRectMake(finishSize.width/2-image2.size.width/2+offset2.x, finishSize.height/2-image2.size.height/2+offset2.y, image2.size.width, image2.size.height);

    // -----

    UIGraphicsBeginImageContextWithOptions(finishSize, NO, 0.f);

    [image1 drawInRect:rect1];

    if (clear)
        [image2 drawInRect:rect2 blendMode:kCGBlendModeXOR alpha:1.f];
    else
        [image2 drawInRect:rect2];

    // -----

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}

@end
