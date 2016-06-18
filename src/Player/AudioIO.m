//
//  AudioIO.m
//  Reverb
//
//  Created by wonliao on 13/3/8.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//

#import "AudioIO.h"
#include "CoreAudioUtil.h"

@interface AudioIO ()
- (BOOL)setupAudioSession;
@end

@implementation AudioIO
@synthesize samplingRate=samplingRate_;
@synthesize reverbProxy=reverbProxy_;

- (id)initWithSamplingRate:(Float64)sampleRate
{
    self = [super init];
    if (self) {

        self.samplingRate = sampleRate;
        [self setupAudioSession];
    }

    return self;
}

- (void)open
{
    OSStatus ret = noErr;

    NewAUGraph(&graph_);
    AUGraphOpen(graph_);

    AudioComponentDescription cd;

	//---------------------------------
	// Audio Unit Graph Node
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType = kAudioUnitSubType_RemoteIO;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;

    AUNode  remoteIONode;
    AUGraphAddNode(graph_, &cd, &remoteIONode);
    AUGraphNodeInfo(graph_, remoteIONode, NULL, &remoteIOUnit_);

    // Converter Unit
    cd.componentType = kAudioUnitType_FormatConverter;
    cd.componentSubType = kAudioUnitSubType_AUConverter;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;

    // AUConverter
    AUNode converterNode;
    AUGraphAddNode(graph_, &cd, &converterNode);
    AUGraphNodeInfo(graph_, converterNode, NULL, &converterUnit_);

    // Reverb2
    cd.componentType = kAudioUnitType_Effect;
    cd.componentSubType = kAudioUnitSubType_Reverb2;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;

    AUNode  reverbNode;
    AUGraphAddNode(graph_, &cd, &reverbNode);
    AUGraphNodeInfo(graph_, reverbNode, NULL, &reverbUnit_);

    // MultiChannel Mixer
    cd.componentType = kAudioUnitType_Mixer;
    cd.componentSubType = kAudioUnitSubType_MultiChannelMixer;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;

    //調整reverb 參數
    AudioUnitSetParameter(reverbUnit_, kAudioUnitScope_Global, 0, kReverb2Param_DryWetMix, 30.0, 0);
    AudioUnitSetParameter(reverbUnit_, kReverb2Param_Gain, kAudioUnitScope_Global, 0, 2, 0);
    AudioUnitSetParameter(reverbUnit_, kReverb2Param_MinDelayTime, kAudioUnitScope_Global, 0, 0.008, 0);
    AudioUnitSetParameter(reverbUnit_, kReverb2Param_MaxDelayTime, kAudioUnitScope_Global, 0, 0.05, 0);
    AudioUnitSetParameter(reverbUnit_, kReverb2Param_RandomizeReflections, kAudioUnitScope_Global, 0, 1000, 0);
    AudioUnitSetParameter(reverbUnit_, kReverb2Param_DecayTimeAt0Hz, kAudioUnitScope_Global, 0, 1.5, 0);
    AudioUnitSetParameter(reverbUnit_, kReverb2Param_DecayTimeAtNyquist, kAudioUnitScope_Global, 0, 10, 0);

    // MultiChannel Mixer
    AUNode  multiChannelMixerNode;
    AUGraphAddNode(graph_, &cd, &multiChannelMixerNode);
    AUGraphNodeInfo(graph_, multiChannelMixerNode, NULL, &multiChannelMixerUnit_);
    {
        UInt32 value;
        UInt32 size = sizeof(value);
        ret = AudioUnitGetProperty(multiChannelMixerUnit_,
                                   kAudioUnitProperty_ElementCount,
                                   kAudioUnitScope_Input, 0,
                                   &value, &size);
        NSLog(@"kAudioUnitProperty_ElementCount returns %lu (ret:%lu)", value, ret);
    }

    const UInt32 enableAudioInput = 1; 
    AudioUnitSetProperty(remoteIOUnit_,
                               kAudioOutputUnitProperty_EnableIO,
                               kAudioUnitScope_Input,  
                               1, 
                               &enableAudioInput,
                               sizeof(enableAudioInput));

    AudioStreamBasicDescription reverb_desc = {0};
    UInt32 size = sizeof(reverb_desc);
    AudioUnitGetProperty(reverbUnit_,
                               kAudioUnitProperty_StreamFormat,
                               kAudioUnitScope_Input, 0,
                               &reverb_desc, &size);
    //NSCAssert (ret==noErr, @"Error: %d'", (int)ret);

	AudioUnitSetProperty(converterUnit_,
                               kAudioUnitProperty_StreamFormat,
                               kAudioUnitScope_Output, 0,
                               &reverb_desc, size);
    //NSCAssert (ret==noErr, @"Error: %d'", (int)ret);

    AUGraphConnectNodeInput(graph_,
                                  remoteIONode, 1,
                                  converterNode, 0);
    //NSCAssert (ret==noErr, @"Error: %d'", (int)ret);

    AUGraphConnectNodeInput(graph_,
                                  converterNode, 0,
                                  reverbNode, 0);
    //NSCAssert (ret==noErr, @"Error: %d'", (int)ret);

    AUGraphConnectNodeInput(graph_,
                                  reverbNode, 0,
                                  multiChannelMixerNode, 0);
    //NSCAssert (ret==noErr, @"Error: %d'", (int)ret);

    AUGraphConnectNodeInput(graph_,
                                  multiChannelMixerNode, 0,
                                  remoteIONode, 0);
    //NSCAssert (ret==noErr, @"Error: %d'", (int)ret);

	reverbProxy_ = [[ReverbProxy alloc] initWithReverbUnit:reverbUnit_];
    CAShow(graph_);

    AUGraphInitialize(graph_);
    //NSCAssert (ret==noErr, @"Error: %d'", (int)ret);
}

- (void)start
{
    if (graph_) {

        Boolean isRunning = false;
        OSStatus ret = AUGraphIsRunning(graph_, &isRunning);
        if (ret == noErr && !isRunning) {

            AUGraphStart(graph_);
        }
    }
}

- (void)stop
{
    if (graph_) {

        Boolean isRunning = false;
        OSStatus ret = AUGraphIsRunning(graph_, &isRunning);
        if (ret == noErr && isRunning) {

            AUGraphStop(graph_);
        }
    }
}

- (void)clear
{
    if (graph_) {

        Boolean isRunning = false;
        OSStatus ret = AUGraphIsRunning(graph_, &isRunning);
        if (ret == noErr && isRunning) {

            AUGraphClearConnections(graph_);
        }
    }
}

- (BOOL)setupAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    UInt32 doSetProperty = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);

    [session setPreferredHardwareSampleRate:self.samplingRate error:nil];
    self.samplingRate = [session currentHardwareSampleRate];

    [session setActive:YES error:nil];

    return YES;
}

- (BOOL)isHeadsetPluggedIn
{
    UInt32 routeSize = sizeof (CFStringRef);
    //CFStringRef route;
    NSString *route;
    OSStatus error = AudioSessionGetProperty (kAudioSessionProperty_AudioRoute,
                                              &routeSize,
                                              &route);
    
    /* Known values of route:
     * "Headset"
     * "Headphone"
     * "Speaker"
     * "SpeakerAndMicrophone"
     * "HeadphonesAndMicrophone"
     * "HeadsetInOut"
     * "ReceiverAndMicrophone"
     * "Lineout"
     */
    
    if (!error && (route != NULL)) {
        
        NSString* routeStr = (NSString*)route;
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Head"];
        
        if (headphoneRange.location != NSNotFound) return YES;
        
    }
    
    return NO;
}

- (void)setReverbArea:(int)areaType
{
    switch (areaType) {
        case 0:
            m_dryWetMixValue = 0.0f;
            break;
        case 1:
            m_dryWetMixValue = 30.0f;
            break;
        case 2:
            m_dryWetMixValue = 50.0f;
            break;
        case 3:
            m_dryWetMixValue = 70.0f;
            break;
        default:
            break;
    }
    
    AudioUnitSetParameter(reverbUnit_, kAudioUnitScope_Global, 0, kReverb2Param_DryWetMix, m_dryWetMixValue, 0);
}
@end
