//
//  AudioIO.h
//  Reverb
//
//  Created by wonliao on 13/3/8.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "ReverbProxy.h"

@interface AudioIO : NSObject
{
    AUGraph graph_;
    Float64 samplingRate_;

    AudioUnit remoteIOUnit_;
    AudioUnit reverbUnit_;
    AudioUnit converterUnit_;
    AudioUnit multiChannelMixerUnit_;

	ReverbProxy *reverbProxy_;
    
    float m_dryWetMixValue;
}
@property (nonatomic)Float64 samplingRate;
@property (nonatomic,readonly)ReverbProxy *reverbProxy;

- (id)initWithSamplingRate:(Float64)sampleRate;
- (void)open;
- (void)start;
- (void)stop;
- (void)clear;
- (BOOL)isHeadsetPluggedIn;
- (void)setReverbArea:(int)areaType;

@end
