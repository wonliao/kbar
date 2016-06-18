//
//  ReverbProxy.h
//  Reverb
//
//  Created by wonliao on 13/3/8.
//  Copyright (c) 2013年 wonliao. All rights reserved.//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ReverbProxy : NSObject
{
    AudioUnit reverbUnit_;

	Float32 dryWetMix_;
	Float32 gain_;
	Float32 minDelayTime_;
	Float32 maxDelayTime_;
	Float32 decayTimeAt0Hz_;
	Float32 decayTimeAtNyquist_;
	Float32 randomizeReflections_;
}

@property (atomic)Float32 dryWetMix;
@property (atomic)Float32 gain;
@property (atomic)Float32 minDelayTime;
@property (atomic)Float32 maxDelayTime;
@property (atomic)Float32 decayTimeAt0Hz;
@property (atomic)Float32 decayTimeAtNyquist;
@property (atomic)Float32 randomizeReflections;

- (id)initWithReverbUnit:(AudioUnit)reverbUnit;

- (void)resetParameters;
@end
