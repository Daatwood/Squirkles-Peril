
#import "ResourceManager.h"
#import "Common.h"
#import "SynthesizeSingleton.h"
#import "Texture2D.h"
#import "Image.h"

@implementation ResourceManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ResourceManager);

- (void)dealloc 
{
    
    // Release the cachedTextures dictionary.
	[_cachedTextures release];
	[_textureMap release];
	[_imageResource release];
	[super dealloc];
}


- (id)init 
{
	NSLog(@"Resource Manager Initializing...");
	// Initialize a dictionary with an initial size to allocate some memory, but it will 
    // increase in size as necessary as it is mutable.
	_cachedTextures = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	_textureMap = [[NSDictionary dictionaryWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"TextureAtlasMonkey00.plist" ]]retain];
	_imageResource = [[NSDictionary dictionaryWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"ImageResource.plist" ]]retain];
	return self;
}

- (Texture2D*)getTextureWithName:(NSString*)aTextureName 
{
    
    // Try to get a texture from cachedTextures with the supplied key.
    Texture2D *_cachedTexture;
    
    // If we can find a texture with the supplied key then return it.
    if((_cachedTexture = [_cachedTextures objectForKey:aTextureName]))
	{
        if(DEBUG) NSLog(@"INFO - Resource Manager: A cached texture was found with the key '%@'.", aTextureName);
        return _cachedTexture;
    }
    
    // As no texture was found we create a new one, cache it and return it.
    if(DEBUG) NSLog(@"INFO - Resource Manager: A texture with the key '%@' could not be found so creating it.", aTextureName);
    _cachedTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:aTextureName] filter:GL_NEAREST];
    [_cachedTextures setObject:_cachedTexture forKey:aTextureName];
    
    // Return the texture which is autoreleased as the caller is responsible for it
    return [_cachedTexture autorelease];
}

- (BOOL)releaseTextureWithName:(NSString*)aTextureName {

    // Try to get a texture from cachedTextures with the supplied key.
    Texture2D *cachedTexture = [_cachedTextures objectForKey:aTextureName];

    // If a texture was found we can remove it from the cachedTextures and return YES.
    if(cachedTexture) {
        if(DEBUG) NSLog(@"INFO - Resource Manager: A cached texture with the key '%@' was released.", aTextureName);
        [_cachedTextures removeObjectForKey:aTextureName];
        return YES;
    }
    
    // No texture was found with the supplied key so log that and return NO;
    if(DEBUG) NSLog(@"INFO - Resource Manager: A texture with the key '%@' could not be found to release.", aTextureName);
    return NO;
}

- (void)releaseAllTextures {
    if(DEBUG) NSLog(@"INFO - Resource Manager: Releasing all cached textures.");
    [_cachedTextures removeAllObjects];
}

- (Image*)getImageWithImageKey:(NSString*)anImageKey andTextureAtlas:(NSString*)aTextureAtlas andOffset:(int)off
{
	NSString *asImageKey = [[NSString stringWithFormat:@"%@.png",anImageKey]retain];
	
	// Returns a subimage of the image
	if(![_textureMap objectForKey:asImageKey])
	{
		NSLog(@"Image not found: %@", asImageKey);
		return nil;
	}
	
	if([[[_textureMap objectForKey:asImageKey] objectForKey:@"rotated"] boolValue])
	{
		NSLog(@"Image rotation is not supported.");
		return nil;
	}
	
	CGRect imgArea = CGRectFromString([[_textureMap objectForKey:asImageKey] objectForKey:@"frame"]);
	
	//CGRectMake([[[_textureMap objectForKey:anImageKey] objectForKey:@"x"] intValue],
	//							[[[_textureMap objectForKey:anImageKey] objectForKey:@"y"] intValue],
	//							[[[_textureMap objectForKey:anImageKey] objectForKey:@"width"] intValue],
	//							[[[_textureMap objectForKey:anImageKey] objectForKey:@"height"] intValue]);
	
	CGPoint pos;
	int total = (int)([[[_imageResource objectForKey:anImageKey] objectForKey:@"position"] count] - 1);
	if(total < off)
		pos = CGPointFromString([[[_imageResource objectForKey:anImageKey] objectForKey:@"position"] objectAtIndex:total]);
	else
		pos = CGPointFromString([[[_imageResource objectForKey:anImageKey] objectForKey:@"position"] objectAtIndex:off]);
	
	Image *texture = [[Image alloc] initWithImageNamed:aTextureAtlas];
	return [[texture getSubImageAtPoint:CGPointMake(imgArea.origin.x, imgArea.origin.y) 
						  subImageWidth:imgArea.size.width
						 subImageHeight:imgArea.size.height
								  scale:[texture scale]
							   rotation:[[[_textureMap objectForKey:asImageKey] objectForKey:@"rotation"] floatValue]
							   position:pos]
										retain];
	[texture release];
	[anImageKey release];
}


@end
