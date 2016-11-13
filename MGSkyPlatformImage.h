//
//  MGSkyPlatformImage.h
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/26/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Texture2D.h"
#import "ResourceManager.h"
#import "Director.h"

@interface MGSkyPlatformImage : NSObject 
{
	// Color of the Platform
	Color4f colorBase;
	
	// Shape Type
	uint platformShape;
	
	// The total life of the platform, initial 3.
	// Each life loss is a loss of end platforms.
	// 0 life the shape is no longer rendered
	int platformLife;
	
	// Center position of the platform.
	CGPoint positionCenter;
	
	// Base Texture
	Texture2D *texture;
	
	// The vertices of each shape within the platform.
	CGPoint *vertices;
}

- (id) initWithShapeType:(int)shape atCenterPosition:(CGPoint)position withBaseColor:(Color4f)color;

- (void)renderToVerticesAtPoint:(CGPoint)aPoint;

- (void)render;

- (void)renderAtPoint:(CGPoint)aPoint;

@end
