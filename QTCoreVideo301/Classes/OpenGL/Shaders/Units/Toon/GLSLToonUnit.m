//---------------------------------------------------------------------------
//
//	File: GLSLToonUnit.m
//
//  Abstract: Utility toolkit for GLSL toon shader
// 			 
//  Disclaimer: IMPORTANT:  This Apple software is supplied to you by
//  Inc. ("Apple") in consideration of your agreement to the following terms, 
//  and your use, installation, modification or redistribution of this Apple 
//  software constitutes acceptance of these terms.  If you do not agree with 
//  these terms, please do not use, install, modify or redistribute this 
//  Apple software.
//  
//  In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Apple grants you a personal, non-exclusive
//  license, under Apple's copyrights in this original Apple software (the
//  "Apple Software"), to use, reproduce, modify and redistribute the Apple
//  Software, with or without modifications, in source and/or binary forms;
//  provided that if you redistribute the Apple Software in its entirety and
//  without modifications, you must retain this notice and the following
//  text and disclaimers in all such redistributions of the Apple Software. 
//  Neither the name, trademarks, service marks or logos of Apple Inc. may 
//  be used to endorse or promote products derived from the Apple Software 
//  without specific prior written permission from Apple.  Except as 
//  expressly stated in this notice, no other rights or licenses, express
//  or implied, are granted by Apple herein, including but not limited to
//  any patent rights that may be infringed by your derivative works or by
//  other works in which the Apple Software may be incorporated.
//  
//  The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
//  MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
//  THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
//  OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//  
//  IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
//  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
//  MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
//  AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
//  STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
// 
//  Copyright (c) 2004-2007 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//------------------------------------------------------------------------

#import "GLSLUnitDictConsts.h"
#import "GLSLToonUnit.h"

//------------------------------------------------------------------------

//------------------------------------------------------------------------

static const GLfloat kAlphaMax  = 10.0f;
static const GLfloat kOffsetMax = 10.0f;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

@implementation GLSLToonUnit

//------------------------------------------------------------------------

#pragma mark -- initializer --

//------------------------------------------------------------------------

- (id) initShaderWithSize:(const NSSize *)theSize
{
	NSNumber     *uniformSamplerId   = [NSNumber numberWithInt:0];
	NSDictionary *uniformSamplerDict = [NSDictionary dictionaryWithObject:uniformSamplerId forKey:@"tex"];

	self = [super initWithShadersInAppBundleAndSamplers:@"toon" size:theSize samplers:uniformSamplerDict];
	
	if ( self )
	{
		uniformLoc[0] = [self uniformLocation:@"style"];
		uniformLoc[1] = [self uniformLocation:@"alpha"];
		uniformLoc[2] = [self uniformLocation:@"offset"];
	} // if

	return  self;
} // initShaderWithSize

//------------------------------------------------------------------------

#pragma mark -- Deallocating Resources --

//------------------------------------------------------------------------

- (void) dealloc
{
	//Dealloc the superclass
	
	[super dealloc];
} // dealloc

//------------------------------------------------------------------------

#pragma mark -- Utilities --

//---------------------------------------------------------------------------

- (void) executeWithFloatsAndBoolUniforms:(CVOpenGLTextureRef)theVideoFrame
									flag:(const BOOL)theFlag
									value:(const GLfloat *)theUniformValue
{
	GLfloat uniformValue[2];
	
	uniformValue[0] = kAlphaMax  * theUniformValue[0];
	uniformValue[1] = kOffsetMax * theUniformValue[1];
	
	NSDictionary *uniformStyleDict  = [self getDictUniformIntScalar:uniformLoc[0]   value:theFlag];
	NSDictionary *uniformAlphaDict  = [self getDictUniformFloatScalar:uniformLoc[1] value:uniformValue[0]];
	NSDictionary *uniformOffsetDict = [self getDictUniformFloatScalar:uniformLoc[2] value:uniformValue[1]];

	NSArray *uniforms = [NSArray arrayWithObjects:uniformStyleDict,uniformAlphaDict,uniformOffsetDict,nil];
	
	[uniformStyleDict  release];
	[uniformAlphaDict  release];
	[uniformOffsetDict release];
	
	[self executeWithCVTextureAndUniforms:theVideoFrame uniforms:uniforms];
} // executeWithFloatsAndBoolUniforms

//------------------------------------------------------------------------

@end

//------------------------------------------------------------------------

//------------------------------------------------------------------------

