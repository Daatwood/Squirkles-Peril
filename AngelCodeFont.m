

#import "AngelCodeFont.h"

@interface AngelCodeFont (Private)
- (void)parseFont:(NSString*)controlFile;
- (void)parseCharacterDefinition:(NSString*)line charDef:(CharDef*)CharDef;
- (void)parseKerningCapacity:(NSString*)line;
- (void)parseKerningEntry:(NSString*)line;
- (int)kerningAmountForFirst:(unichar)first second:(unichar)second;
- (void)initVertexArrays:(int)totalQuads;
@end

@implementation AngelCodeFont

@synthesize scale;
@synthesize image;
@synthesize useKerning;
@synthesize rotation;
@synthesize maxLength;
@synthesize leftAlignment;

- (id)initWithFontImageNamed:(NSString*)fontImage controlFile:(NSString*)controlFile scale:(float)fontScale filter:(GLenum)filter {
	self = [self init];
	if (self != nil) {
		
		// Reference the font image which has been supplied and which contains the character bitmaps
		image = [[Image alloc] initWithImageNamed:fontImage scale:fontScale filter:filter];
		// Set the scale to be used for the font
		scale = fontScale;
		maxLength = 300;
		// Set the kerningDictionary to nil.  This will be used when processing any kerning info
		KerningDictionary = nil;
		
		leftAlignment = TRUE;
		
		// Default for kerning is off
		useKerning = NO;
        
        // Set up the colourFilter
        colourFilter.red = 1.0f;
        colourFilter.green = 1.0f;
        colourFilter.blue = 1.0f;
        colourFilter.alpha = 1.0f;
		
		// Parse the control file and populate charsArray which the character definitions
		[self parseFont:controlFile];

		// Now we have passed the font control file we know how many characters we have so we can set
		// up the vertext arrays
		[self initVertexArrays:kMaxCharsInMessage];
	}
	return self;
}


- (void)parseFont:(NSString*)controlFile {

	// Read the contents of the file into a string
	NSString *contents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:controlFile ofType:@"fnt"] encoding:NSUTF8StringEncoding error:nil];

	// Move all lines in the string, which are denoted by \n, into an array
	NSArray *lines = [[NSArray alloc] initWithArray:[contents componentsSeparatedByString:@"\n"]];

	// Create an enumerator which we can use to move through the lines read from the control file
	NSEnumerator *nse = [lines objectEnumerator];

	// Create a holder for each line we are going to work with
	NSString *line;
	
	// A holder for the number of characters read in from the font file
	int numberOfFontChars = 0;
	
	// Loop through all the lines in the lines array processing each one
	while(line = [nse nextObject]) {
		// Check to see if the start of the line is something we are interested in
		if([line hasPrefix:@"chars c"]) {
			// Ignore this line
		} else if([line hasPrefix:@"char"]) {
			// Parse the current line and create a new CharDef
			CharDef *characterDefinition = [[CharDef alloc] initCharDefWithFontImage:image scale:scale];
			[self parseCharacterDefinition:line charDef:characterDefinition];

			// Add the CharDef returned to the charArray
			charsArray[[characterDefinition charID]] = characterDefinition;
			
			// Increment the total number of characters
			numberOfFontChars++;
		} else if([line hasPrefix:@"kernings count"]) {
			[self parseKerningCapacity:line];
		} else if([line hasPrefix:@"kerning first"]) {
			if(useKerning)
				[self parseKerningEntry:line];
		}
	}
	// Finished with lines so release it
	[lines release];
}


- (void)initVertexArrays:(int)totalQuads {
	
	// Init the texture, vertices and indices arrays ready for taking data.  The size we allocate
	// to these arrays is based on the number of characters (quads) read from the font control file
	texCoords = calloc( totalQuads, sizeof( Quad2f ) );
	vertices = calloc( totalQuads, sizeof( Quad2f ) );
	indices = calloc( totalQuads * 6, sizeof( GLushort ) );
	
	for( NSUInteger i=0;i<totalQuads;i++) {
		indices[i*6+0] = i*4+0;
		indices[i*6+1] = i*4+1;
		indices[i*6+2] = i*4+2;
		indices[i*6+5] = i*4+1;
		indices[i*6+4] = i*4+2;
		indices[i*6+3] = i*4+3;			
	}	
}


// Added 07/05/09
- (void)parseKerningCapacity:(NSString*)line {
	// Break the values for this line up using =
	NSArray *values = [line componentsSeparatedByString:@"="];
	NSEnumerator *nse = [values objectEnumerator];
	NSString *propertyValue;
	
	// We need to move past the first entry in the array before we start assigning values
	[nse nextObject];
	
	// Get the kerning count
	propertyValue = [nse nextObject];
	int capacity = [propertyValue intValue];
	if(capacity!=-1)
		KerningDictionary = [[NSMutableDictionary dictionaryWithCapacity:[propertyValue intValue]] retain];
}


// Added 07/05/09
- (void)parseKerningEntry:(NSString*)line {
	NSArray *values = [line componentsSeparatedByString:@"="];
	NSEnumerator *nse = [values objectEnumerator];
	NSString *propertyValue;
	
	// Move past the first entry before we start assinging values
	[nse nextObject];
	
	// First
	propertyValue = [nse nextObject];
	int first = [propertyValue intValue];
	
	// Second
	propertyValue = [nse nextObject];
	int second = [propertyValue intValue];
	
	// Amount
	propertyValue = [nse nextObject];
	int amount = [propertyValue intValue];
	
	NSString *key = [NSString stringWithFormat:@"%d,%d", first, second];
	NSNumber *value = [NSNumber numberWithInt:amount];
	
	[KerningDictionary setObject:value forKey:key];
}


// Added 07/05/09
- (int)kerningAmountForFirst:(unichar)first second:(unichar)second {
	int ret = 0;
	NSString *key = [NSString stringWithFormat:@"%d,%d", first, second];
	NSNumber *value = [KerningDictionary objectForKey:key];
	if(value)
		ret = [value intValue];
	
	return ret;
}


- (void)parseCharacterDefinition:(NSString*)line charDef:(CharDef*)characterDefinition {

	// Break the values for this line up using =
	NSArray *values = [line componentsSeparatedByString:@"="];
	
	// Get the enumerator for the array of components which has been created
	NSEnumerator *nse = [values objectEnumerator];
	
	// We are going to place each value we read from the line into this string
	NSString *propertyValue;
	
	// We need to move past the first entry in the array before we start assigning values
	[nse nextObject];
	
	// Character ID
	propertyValue = [nse nextObject];
	[characterDefinition setCharID:[propertyValue intValue]];
	// Character x
	propertyValue = [nse nextObject];
	[characterDefinition setX:[propertyValue intValue]];
	// Character y
	propertyValue = [nse nextObject];
	[characterDefinition setY:[propertyValue intValue]];
	// Character width
	propertyValue = [nse nextObject];
	[characterDefinition setWidth:[propertyValue intValue]];
	// Character height
	propertyValue = [nse nextObject];
	[characterDefinition setHeight:[propertyValue intValue]];
	// Character xoffset
	propertyValue = [nse nextObject];
	[characterDefinition setXOffset:[propertyValue intValue]];
	// Character yoffset
	propertyValue = [nse nextObject];
	[characterDefinition setYOffset:[propertyValue intValue]];
	// Character xadvance
	propertyValue = [nse nextObject];
	[characterDefinition setXAdvance:[propertyValue intValue] * .85];
}

// Changed 07/05/09 to add kerning
- (void)drawStringAt:(CGPoint)point text:(NSString*)text 
{
	
	// TODO: Add error if string is too long using NSASSERT
	//NSAssert(1>0, @"WARNING: Text to be rendered is too long");
	
	CGPoint originPoint = point;
	
	// Reset the number of quads which are going to be drawn
	int currentQuad = 0;
	
	glPushMatrix();
	
	if(rotation > 0)
	{
		glTranslatef(point.x, point.y, 0);
		glRotatef(-rotation, 0.0f, 0.0f, 1.0f);
		glTranslatef(-point.x, -point.y, 0);
	}
	
	// Enable those states necessary to draw with textures and allow blending
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);

	// Setup how the text is to be blended
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	// Bind to the texture which was generated for the spritesheet image used for this font.  We only
	// need to bind once before the drawing as all characters are on the same texture.
	if([[image texture] name] != [[Director sharedDirector] currentlyBoundTexture]) {
		[[Director sharedDirector] setCurrentlyBoundTexture:[[image texture] name]];
		glBindTexture(GL_TEXTURE_2D, [[image texture] name]);
	}	
	
	// Set up the previous character and kerning amount vars
	unichar previousChar = -1;
	int kerningAmount = 0;
	
	
	if(!leftAlignment)
		point.x -= [self getWidthForString:text];
	
	// Loop through all the characters in the text
	for(int i=0; i<[text length]; i++) 
	{
		
		// Grab the unicode value of the current character
		unichar charID = [text characterAtIndex:i];
		
		if(charID != '\n')
		{
			// Look up the kerning information for the previous char and this current char
			kerningAmount = [self kerningAmountForFirst:previousChar second:charID];
		
			// Move x based on the kerning info
			point.x += kerningAmount * scale;
		
			// Only render the current character if it is going to be visible otherwise move the variables such as currentQuad and point.x
			// as normal but don't render the character which should save some cycles
			if(point.x > 0 - ([charsArray[charID] width] * scale) || point.x < [[UIScreen mainScreen] bounds].size.width || point.y > 0 - ([charsArray[charID] height] * scale) || point.y < [[UIScreen mainScreen] bounds].size.height) 
			{
	
				// Using the current x and y, calculate the correct position of the character using the x and y offsets for each character.
				// This will cause the characters to all sit on the line correctly with tails below the line etc.
				CGPoint newPoint = CGPointMake(point.x, 
										   point.y - ([charsArray[charID] yOffset] + [charsArray[charID] height]) * [charsArray[charID] scale]);
	
				// Create a point into the bitmap font spritesheet using the coords read from the control file for this character
				CGPoint pointOffset = CGPointMake([charsArray[charID] x], [charsArray[charID] y]);
			
				// Calculate the texture coordinates and quad vertices for the current character
				[[charsArray[charID] image] calculateTexCoordsAtOffset:pointOffset subImageWidth:[charsArray[charID] width] subImageHeight:[charsArray[charID] height]];
				[[charsArray[charID] image] calculateVerticesAtPoint:newPoint subImageWidth:[charsArray[charID] width] subImageHeight:[charsArray[charID] height] centerOfImage:NO];
			
				// Place the calculated texture coordinates and quad vertices into the arrays we will use when drawing our string
				texCoords[currentQuad] = *[[charsArray[charID] image] textureCoordinates];
				vertices[currentQuad] = *[[charsArray[charID] image] vertices];
			
				// Increment the Quad count
				currentQuad++;
			}
		
			point.x += [charsArray[charID] xAdvance] * scale;
		}
		
		// Add the following: If the X position of the character to be displayed exceeds the width of the frame (rectangle)
		// in which the text is justified or a return character line is detected, we modify the X and Y position
		// of the next character to display to be displayed at the beginning of the next line.
		if (charID == '\n') 
		{
			point.x = originPoint.x;
			point.y = point.y - [self getHeightForString:@"X"];
		}
		else if (maxLength != 0 && point.x >= maxLength && charID == ' ') 
		{
			point.x = originPoint.x;
			point.y = point.y - [self getHeightForString:@"X"];
		}
		// Store the character just processed as the previous char for looking up any kerning info
		previousChar = charID;
	}
	
	// Now that we have calculated all the quads and textures for the string we are drawing we can draw them all
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glColor4f(colourFilter.red, colourFilter.green, colourFilter.blue, colourFilter.alpha * [[Director sharedDirector] globalAlpha]);
	glDrawElements(GL_TRIANGLES, currentQuad*6, GL_UNSIGNED_SHORT, indices);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
	glPopMatrix();
}
/*
- (void)renderStringAt:(CGPoint)aPoint widthMargin:(CGFloat)aWidthMargin textHeight:(int)aTextHeight text:(NSString*)aText 
{
    
	// Grab the scale that we will be using
	float xScale = image.scale.x;
	float yScale = image.scale.y;
	int nextLineOffset = 0;
	int startXPointPosition = aPoint.x;
	
	// Loop through all the characters in the text to be rendered
	for(int i=0; i<[aText length]; i++) {
		
		// Grab the character value of the current character.  We take off 32 as the first
		// 32 characters of the fonts are not used
		unichar charID = [aText characterAtIndex:i] - 32;
		
		// Using the current x and y, calculate the correct position of the character using the x and y offsets for each character.
		// This will cause the characters to all sit on the line correctly with tails below the line.  The commonHeight which has
		// been taken from the fonts control file is used within the calculation.
		int y = aPoint.y + nextLineOffset + (lineHeight * yScale) - (charsArray[charID].height + charsArray[charID].yOffset) * yScale;
		int x = aPoint.x + charsArray[charID].xOffset;
		
		CGPoint renderPoint = CGPointMake(x, y);
		
		// Set the color of this character based on the fontColor
		charsArray[charID].image.color = fontColor;
		
		// Render the current character at the renderPoint
		[charsArray[charID].image renderAtPoint:renderPoint];
		
		// Move x based on the amount to advance for the current char
		aPoint.x += charsArray[charID].xAdvance * xScale;
		
		// Add the following: If the X position of the character to be displayed exceeds the width of the frame (rectangle)
		// in which the text is justified or a return character line is detected, we modify the X and Y position
		// of the next character to display to be displayed at the beginning of the next line.
		if (aPoint.x - startXPointPosition > aWidthMargin || (unichar)(charID + 32) == '\n') {
			aPoint.x = startXPointPosition;
			nextLineOffset -= aTextHeight;
		}
	}
}
*/

- (int)getWidthForString:(NSString*)string {
	// Set up stringWidth
	int stringWidth = 0;
	
	// Loop through the characters in the text and sum the xAdvance for each one
	// xAdvance holds how far to move long X for each character so that the correct
	// space is left after each character
	for(int index=0; index<[string length]; index++) 
	{
		unichar charID = [string characterAtIndex:index];

		// Add the xAdvance value of the current character to stringWidth scaling as necessary
		stringWidth += [charsArray[charID] xAdvance] * scale;
	}	
	
	if(stringWidth > maxLength)
		stringWidth = maxLength;
	
	// Return the total width calculated
	return stringWidth;
}


- (int)getHeightForString:(NSString*)string 
{
	// Set up stringHeight	
	int stringHeight = 0;

	// Loop through the characters in the text and sum the height.  The sum will take into
	// account the offset of the character as some characters sit below the line etc
	for(int i=0; i<[string length]; i++) {
		unichar charID = [string characterAtIndex:i];
		
		// Don't bother checking if the character is a space as they have no height
		if(charID == ' ')
			continue;
		
		// Check to see if the height of the current character is greater than the current max height
		// If so then replace the current stringHeight with the height of the current character
		stringHeight = MAX(([charsArray[charID] height] * scale) + ([charsArray[charID] yOffset] * scale), stringHeight);
	}	
	// Return the total height calculated
	return stringHeight;	
}


- (void)setColourFilterRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
	// Set the colour filter of the spritesheet image used for this font
	colourFilter.red = red;
    colourFilter.green = green;
    colourFilter.blue = blue;
    colourFilter.alpha = alpha;
}


- (void)setScale:(float)newScale {
	scale = newScale;
	[image setScale:newScale];
}


- (void)dealloc {
	free(texCoords);
	free(vertices);
	free(indices);
	
	// Free the objects which are being held within the charsArray
	for(int i=0; i < kMaxCharsInFont; i++) {
		[charsArray[i] release];
	}
	
	[KerningDictionary release];
	[image release];
	[super dealloc];
}

@end
