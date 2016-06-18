//
//  CoreAudioUtil.h
//  Reverb
//
//  Created by wonliao on 13/3/8.
//  Copyright (c) 2013年 wonliao. All rights reserved.//

#include <AudioToolbox/AudioToolbox.h>

#ifndef Reverb_CoreAudioUtil_h
#define Reverb_CoreAudioUtil_h

void GetAUCanonicalDescription(AudioStreamBasicDescription *desc,
                               float samplingRate,
                               UInt32 numOfChannels);

void GetCanonicalDescription(AudioStreamBasicDescription *desc,
                             float samplingRate,
                             UInt32 numOfChannels);

void DumpASBD(AudioStreamBasicDescription *desc);
void DumpASBDofAU(AudioUnit au, int scope, int bus);
#endif
