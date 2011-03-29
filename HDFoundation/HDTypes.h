//
//  HDTypes.h
//  HDLibraries
//
//  Created by David Hart on 2/16/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


typedef struct
{
	NSUInteger x;
	NSUInteger y;
} HDPoint;

typedef struct
{
	NSUInteger width;
	NSUInteger height;
} HDSize;


#pragma mark - HDPoint

static inline HDPoint HDPointMake(NSUInteger x, NSUInteger y)
{
	return (HDPoint){x, y};
}

static inline BOOL HDPointEquals(HDPoint first, HDPoint second)
{
	return (first.x == second.x) && (first.y == second.y);
}

static inline HDPoint HDPointMultiply(HDPoint point, NSUInteger factor)
{
	return HDPointMake(point.x * factor, point.y * factor);
}

static inline NSUInteger HDPointDistance(HDPoint first, HDPoint second)
{
	NSInteger a = first.x - second.x;
	NSInteger b = first.y - second.y;
	return (NSUInteger)sqrt(a*a + b*b);
}

static inline NSString*	NSStringFromHDPoint(HDPoint point)
{
	return [NSString stringWithFormat:@"(%i, %i)", point.x, point.y];
}

static inline CGPoint CGPointFromHDPoint(HDPoint point)
{
	return CGPointMake(point.x, point.y);
}

#pragma mark - HDSize

static inline HDSize HDSizeMake(NSUInteger width, NSUInteger height)
{
	return (HDSize){ width, height };
}

static inline BOOL HDSizeEquals(HDSize first, HDSize second)
{
	return (first.width == second.width) && (first.height == second.height);
}

static inline HDSize HDSizeMultiply(HDSize size, NSUInteger factor)
{
	return HDSizeMake(size.width * factor, size.height * factor);
}

static inline NSUInteger HDSizeArea(HDSize size)
{
	return size.width * size.height;
}

static inline BOOL HDSizeContainsHDPoint(HDSize size, HDPoint point)
{
	return (point.x < size.width) && (point.y < size.height);
}

static inline NSString* NSStringFromHDSize(HDSize size)
{
	return [NSString stringWithFormat:@"(%i, %i)", size.width, size.height];
}

static inline CGSize CGSizeFromHDSize(HDSize size)
{
	return CGSizeMake(size.width, size.height);
}