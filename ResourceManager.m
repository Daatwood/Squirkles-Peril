
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
	[super dealloc];
}


- (id)init 
{
	NSLog(@"Resource Manager Initializing...");
	// Initialize a dictionary with an initial size to allocate some memory, but it will 
    // increase in size as necessary as it is mutable.
	_cachedTextures = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
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
    _cachedTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:aTextureName] filter:GL_LINEAR];
    [_cachedTextures setObject:_cachedTexture forKey:aTextureName];
    
    // Return the texture which is autoreleased as the caller is responsible for it
    return [_cachedTexture autorelease];
}

- (BOOL)releaseTextureWithName:(NSString*)aTextureName 
{

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

- (Image*)getImageWithImageNamed:(NSString*)anImage withinAtlasNamed:(NSString*)anAtlas
{
    //NSLog(@"Image: %@, Atlas: %@", anImage, anAtlas);
    
	// Load the TextureAtlas Plist
	NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",anAtlas ]];
	NSDictionary* atlasDictionary = [[NSDictionary dictionaryWithContentsOfFile: path]retain];
	
	// Generate correct Image Name 
	NSString *formattedImageName = [[NSString stringWithFormat:@"%@.png",anImage]retain];
	
	// Make sure the image exsits;
	if(![atlasDictionary objectForKey:formattedImageName])
	{
		NSLog(@"Resource Manager: Image not found: %@ in atlas path: %@!", formattedImageName, path);
		//NSLog(@"Dictionary: %@", [atlasDictionary description]);
		[path release];
		[atlasDictionary release];
		[formattedImageName release];
		return nil;
	}
	
	CGRect imageArea = CGRectMake([[[atlasDictionary objectForKey:formattedImageName] objectForKey:@"x"] intValue],
								[[[atlasDictionary objectForKey:formattedImageName] objectForKey:@"y"] intValue],
								[[[atlasDictionary objectForKey:formattedImageName] objectForKey:@"width"] intValue],
								[[[atlasDictionary objectForKey:formattedImageName] objectForKey:@"height"] intValue]);
	
	Image *texture = [[Image alloc] initWithImageNamed:anAtlas];
    
    [texture setIsColored:[[[atlasDictionary objectForKey:formattedImageName] objectForKey:@"colored"] boolValue]];
    
	return [[texture getSubImageAtPoint:imageArea.origin
						  subImageWidth:imageArea.size.width
						 subImageHeight:imageArea.size.height
								  scale:[texture scale]
							   rotation:0
							   position:
             CGPointMake([[[atlasDictionary objectForKey:formattedImageName] objectForKey:@"offsetX"] intValue], 
                         [[[atlasDictionary objectForKey:formattedImageName] objectForKey:@"offsetY"] intValue])]
										retain];
	[atlasDictionary release];
	[formattedImageName release];
	[texture release];
}


@end
