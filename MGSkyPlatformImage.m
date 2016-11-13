//
//  MGSkyPlatformImage.m
//  Squirkle's Peril
//
//  Created by Dustin Atwood on 2/26/11.
//  Copyright 2011 Litlapps. All rights reserved.
//

#import "MGSkyPlatformImage.h"

static const CGPoint verticesBase[] = 
{
	{ 0, 18.5 },
	{ 16, 37 },
	{ 29, 18.5 },
	{ 58, 37 },
	{ 87, 18.5 },
	{ 96, 37 },
	{ 116, 18.5 }
};

static const GLfloat textureCoordinates[] = 
{
	0.0, 0.35,
	0.35, 0.0,
	0.0, 0.0,
	0.0, 0.35,
	0.35, 0.0,
	0.0, 0.0,
	0.35, 0.35,
};

@implementation MGSkyPlatformImage

- (id) initWithShapeType:(int)shape atCenterPosition:(CGPoint)position withBaseColor:(Color4f)color
{
	self = [super init];
	if (self != nil) 
	{
		platformShape = shape;
		platformLife = 3;
		colorBase = color;
		positionCenter = position;
		texture = [[[ResourceManager sharedResourceManager] getTextureWithName:@"TextureBase"] retain];
		
		vertices = calloc( 7, sizeof( CGPoint ) );
	}
	return self;
}

- (void)renderToVerticesAtPoint:(CGPoint)aPoint
{	
	for(int i = 0; i < 7; i++)
	{
		vertices[i] = CGPointAdd(verticesBase[i], aPoint);
	}
}

- (void)render
{
	[self renderAtPoint:positionCenter];
}

- (void)renderAtPoint:(CGPoint)aPoint
{
	CGPoint verticesOutline[] = 
	{ // -186
		{ 54, 305 },
		{ 29, 305 },
		{ 31, 301 },
		{ 16, 301 },
		{ 18, 296 },
		{ 0, 296 },
		{ 14, 268 },
		{ 23, 286 },
		{ 35, 263 },
		{ 42, 278 },
		{ 54, 255 },
		{ 35, 278 },
		{ 72, 263 },
		{ 84, 286 },
		{ 93, 268 },
		{ 107, 296 },
		{ 89, 296 },
		{ 91, 301 },
		{ 77, 301 },
		{ 79, 305 }
    };
	
	static const int shadOff = 3;
	
	CGPoint verticesShadowLine[] = 
	{
		{ 240-shadOff, 305-shadOff },
		{ 215-shadOff, 305-shadOff },
		{ 217-shadOff, 301-shadOff },
		{ 202-shadOff, 301-shadOff },
		{ 204-shadOff, 296-shadOff },
		{ 186-shadOff, 296-shadOff },
		{ 200-shadOff, 268-shadOff },
		{ 209-shadOff, 286-shadOff },
		{ 221-shadOff, 263-shadOff },
		{ 228-shadOff, 278-shadOff },
		{ 240-shadOff, 255-shadOff },
		{ 251-shadOff, 278-shadOff },
		{ 258-shadOff, 263-shadOff },
		{ 270-shadOff, 286-shadOff },
		{ 279-shadOff, 268-shadOff },
		{ 293-shadOff, 296-shadOff },
		{ 275-shadOff, 296-shadOff },
		{ 277-shadOff, 301-shadOff },
		{ 263-shadOff, 301-shadOff },
		{ 265-shadOff, 305-shadOff }
    };
	
    CGPoint vertices1[] = 
	{
		// 186, 255
		{ 54+aPoint.x, 0+aPoint.y },
		{ 79+aPoint.x, 50+aPoint.y },
		{ 29+aPoint.x, 50+aPoint.y }
    };
	
	CGPoint vertices2[] = 
	{
		{ 72+aPoint.x, 8+aPoint.y },
		{ 91+aPoint.x, 46+aPoint.y },
		{ 54+aPoint.x, 46+aPoint.y }
    };
	
	CGPoint vertices3[] = 
	{
		{ 35+aPoint.x, 8+aPoint.y },
		{ 54+aPoint.x, 46+aPoint.y },
		{ 16+aPoint.x, 46+aPoint.y }
    };
	
	 CGPoint vertices4[] = 
	{
		{ 14+aPoint.x, 13+aPoint.y },
		{ 29+aPoint.x, 41+aPoint.y },
		{ 0+aPoint.x, 41+aPoint.y }
    };
	
	CGPoint vertices5[] = 
	{
		{ 93+aPoint.x, 13+aPoint.y },
		{ 107+aPoint.x, 41+aPoint.y },
		{ 79+aPoint.x, 41+aPoint.y }
    };
	
    static const GLfloat texCoords[] = 
	{
        0.25, 0.35,
        0.35, 0.25,
        0.25, 0.25,
    };
	glPushMatrix();
	glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
	//glEnableClientState(GL_COLOR_ARRAY);
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	
	glColor4f(colorBase.red, colorBase.green, colorBase.blue, colorBase.alpha);
	
	if([texture name] != [[Director sharedDirector] currentlyBoundTexture]) 
	{
		[[Director sharedDirector] setCurrentlyBoundTexture:[texture name]];
		glBindTexture(GL_TEXTURE_2D, [texture name]);
	}
    
	
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	//glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
	
	// Draw the Black Shadow Outline
	////glVertexPointer(2, GL_FLOAT, 0, verticesShadowLine);
	//glColor4f(0.2, 0.2, 0.2, 0.5);
	//glLineWidth(6.0f);
	//glDrawArrays(GL_LINE_LOOP, 0, 20);
	
	
	//glColor4f(1.0, 0.52, 1.0, 0.5);
	
	//glVertexPointer(2, GL_FLOAT, 0, vertices4);
	//glDrawArrays(GL_TRIANGLES, 0, 15);
	
	/*
	// 5nd
	glVertexPointer(2, GL_FLOAT, 0, vertices5);
	glDrawArrays(GL_TRIANGLES, 0, 3);
	
	// 4rd
	glVertexPointer(2, GL_FLOAT, 0, vertices4);
	glDrawArrays(GL_TRIANGLES, 0, 3);
	*/
	// 2nd
	glVertexPointer(2, GL_FLOAT, 0, vertices2);
	glDrawArrays(GL_TRIANGLES, 0, 3);
	
	// 3rd
	glVertexPointer(2, GL_FLOAT, 0, vertices3);
	glDrawArrays(GL_TRIANGLES, 0, 3);
	
	// 1st
	glVertexPointer(2, GL_FLOAT, 0, vertices1);
	glDrawArrays(GL_TRIANGLES, 0, 3);
	
	// Draw the White Outline
	//glVertexPointer(2, GL_FLOAT, 0, verticesOutline);
	//glColor4f(1.0, 1.0, 1.0, 1.0);
	//glLineWidth(2.0f);
	//glDrawArrays(GL_LINE_LOOP, 0, 20);
	glDisable(GL_BLEND);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_VERTEX_ARRAY);
	 glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glPopMatrix();
	
	/*
	
	[self renderToVerticesAtPoint:aPoint];
	
	glPushMatrix();
	glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	glColor4f(colorBase.red, colorBase.green, colorBase.blue, colorBase.alpha);
	
	if([texture name] != [[Director sharedDirector] currentlyBoundTexture]) 
	{
		[[Director sharedDirector] setCurrentlyBoundTexture:[texture name]];
		glBindTexture(GL_TEXTURE_2D, [texture name]);
	}
    
    glTexCoordPointer(2, GL_FLOAT, 0, textureCoordinates);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 7);
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glPopMatrix();
	 */
}

@end
