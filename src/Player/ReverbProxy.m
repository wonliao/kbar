//
//  ReverbProxy.m
//  Reverb
//
//  Created by wonliao on 13/3/8.
//  Copyright (c) 2013年 wonliao. All rights reserved.//

#import "ReverbProxy.h"

@interface ReverbProxy ()
- (Float32)valueForParameter:(int)parameter;
- (void)setValue:(Float32)value forParameter:(int)parameter min:(Float32)min max:(Float32)max;
@end

@implementation ReverbProxy
- (id)init
{
	NSAssert(0, @"Must initialize via initWithReverbUnit: method.");
    return nil;
}

- (id)initWithReverbUnit:(AudioUnit)reverbUnit
{
    self = [super init];
    if (self) {

        reverbUnit_ = reverbUnit;
		dryWetMix_ = self.dryWetMix;
		gain_ = self.gain;
		minDelayTime_ = self.minDelayTime;
		maxDelayTime_ = self.maxDelayTime;
		decayTimeAt0Hz_ = self.decayTimeAt0Hz;
		decayTimeAtNyquist_ = self.decayTimeAtNyquist;
		randomizeReflections_ = self.randomizeReflections;
    }

    return self;
}

- (void)resetParameters
{
	self.dryWetMix = dryWetMix_;
	self.gain = gain_;
	self.minDelayTime = minDelayTime_;
	self.maxDelayTime = maxDelayTime_;
	self.decayTimeAt0Hz = decayTimeAt0Hz_;
	self.decayTimeAtNyquist = decayTimeAtNyquist_;
	self.randomizeReflections = randomizeReflections_;
}

#pragma mark - private methods
- (Float32)valueForParameter:(int)parameter
{
	Float32 value;
	OSStatus rt = AudioUnitGetParameter(reverbUnit_,
										parameter,
										kAudioUnitScope_Global,
										0,
										&value);
	if (rt != noErr) {

		NSLog(@"Error getting parameter(%d)", parameter);
		return MAXFLOAT;
	}

	return value;
}

- (void)setValue:(Float32)value forParameter:(int)parameter min:(Float32)min max:(Float32)max
{
	if (value<min || value>max) {

		NSLog(@"Invalid value(%f)<%f - %f> for parameter(%d). Ignored.",
			  value, min, max, parameter);
		return;
	}

	OSStatus rt = AudioUnitSetParameter(reverbUnit_,
										parameter,
										kAudioUnitScope_Global,
										0,
										value,
										0);
	if (rt != noErr) {

		NSLog(@"Error Setting parameter(%d)", parameter);
	}
}

#pragma mark - Getter/Setter
- (Float32)dryWetMix
{
	Float32 result;
    AudioUnitGetParameter(reverbUnit_,
                          kReverb2Param_DryWetMix,
                          kAudioUnitScope_Global,
                          0,
                          &result);
	return result;
}

- (void)setDryWetMix:(Float32)dryWetMix
{
	// Global, CrossFade, 0->100, 100
	if (dryWetMix<0.0f || dryWetMix>100.0f) {

		return;
	}

    AudioUnitSetParameter(reverbUnit_,
                          kReverb2Param_DryWetMix,
                          kAudioUnitScope_Global,
                          0,
                          dryWetMix,
                          0);
}

#pragma mark -
- (Float32)gain
{
	return [self valueForParameter:kReverb2Param_Gain];
}

- (void)setGain:(Float32)value
{
	// Global, Decibels, -20->20, 0
	[self setValue:value forParameter:kReverb2Param_Gain
			   min:-20.0f max:20.0f];
}

#pragma mark -
- (Float32)minDelayTime
{
	return [self valueForParameter:kReverb2Param_MinDelayTime];
}

- (void)setMinDelayTime:(Float32)value
{
	// Global, Secs, 0.0001->1.0, 0.008	
	[self setValue:value forParameter:kReverb2Param_MinDelayTime
			   min:0.0001f max:1.0f];
}

#pragma mark -
- (Float32)maxDelayTime
{
	return [self valueForParameter:kReverb2Param_MaxDelayTime];
}

- (void)setMaxDelayTime:(Float32)value
{
	// Global, Secs, 0.0001->1.0, 0.050
	[self setValue:value forParameter:kReverb2Param_MaxDelayTime
			   min:0.0001f max:1.0f];
}

#pragma mark -
- (Float32)decayTimeAt0Hz
{
	return [self valueForParameter:kReverb2Param_DecayTimeAt0Hz];
}

- (void)setDecayTimeAt0Hz:(Float32)value
{
	// Global, Secs, 0.001->20.0, 1.0
	[self setValue:value forParameter:kReverb2Param_DecayTimeAt0Hz
			   min:0.001f max:20.0f];
}

#pragma mark -
- (Float32)decayTimeAtNyquist
{
	return [self valueForParameter:kReverb2Param_DecayTimeAtNyquist];
}

- (void)setDecayTimeAtNyquist:(Float32)value
{
	// Global, Secs, 0.001->20.0, 0.5
	[self setValue:value forParameter:kReverb2Param_DecayTimeAtNyquist
			   min:0.001f max:20.0f];
}

#pragma mark -
- (Float32)randomizeReflections
{
	return [self valueForParameter:kReverb2Param_RandomizeReflections];
}

- (void)setRandomizeReflections:(Float32)value
{
	// Global, Integer, 1->1000
	[self setValue:value forParameter:kReverb2Param_RandomizeReflections
			   min:1.0f max:1000.0f];
}
@end
