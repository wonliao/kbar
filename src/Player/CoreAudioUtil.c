//
//  CoreAudioUtil.c
//
//  Created by wonliao on 13/3/8.
//  Copyright (c) 2013年 wonliao. All rights reserved.//

#include <stdio.h>
#include "CoreAudioUtil.h"

typedef struct {
    const char *name;
    int value;
} FormatIDList;
static FormatIDList formatIDList[] = {
    {"kAudioFormatLinearPCM"            , kAudioFormatLinearPCM},
    {"kAudioFormatAC3"                  , kAudioFormatAC3},
    {"kAudioFormat60958AC3"             , kAudioFormat60958AC3},
    {"kAudioFormatAppleIMA4"            , kAudioFormatAppleIMA4},
    {"kAudioFormatMPEG4AAC"             , kAudioFormatMPEG4AAC},
    {"kAudioFormatMPEG4CELP"            , kAudioFormatMPEG4CELP},
    {"kAudioFormatMPEG4HVXC"            , kAudioFormatMPEG4HVXC},
    {"kAudioFormatMPEG4TwinVQ"          , kAudioFormatMPEG4TwinVQ},
    {"kAudioFormatMACE3"                , kAudioFormatMACE3},
    {"kAudioFormatMACE6"                , kAudioFormatMACE6},
    {"kAudioFormatULaw"                 , kAudioFormatULaw},
    {"kAudioFormatALaw"                 , kAudioFormatALaw},
    {"kAudioFormatQDesign"              , kAudioFormatQDesign},
    {"kAudioFormatQDesign2"             , kAudioFormatQDesign2},
    {"kAudioFormatQUALCOMM"             , kAudioFormatQUALCOMM},
    {"kAudioFormatMPEGLayer1"           , kAudioFormatMPEGLayer1},
    {"kAudioFormatMPEGLayer2"           , kAudioFormatMPEGLayer2},
    {"kAudioFormatMPEGLayer3"           , kAudioFormatMPEGLayer3},
    {"kAudioFormatTimeCode"             , kAudioFormatTimeCode},
    {"kAudioFormatMIDIStream"           , kAudioFormatMIDIStream},
    {"kAudioFormatParameterValueStream" , kAudioFormatParameterValueStream},
    {"kAudioFormatAppleLossless"        , kAudioFormatAppleLossless},
    {"kAudioFormatMPEG4AAC_HE"          , kAudioFormatMPEG4AAC_HE},
    {"kAudioFormatMPEG4AAC_LD"          , kAudioFormatMPEG4AAC_LD},
    {"kAudioFormatMPEG4AAC_ELD"         , kAudioFormatMPEG4AAC_ELD},
    {"kAudioFormatMPEG4AAC_ELD_SBR"     , kAudioFormatMPEG4AAC_ELD_SBR},
    {"kAudioFormatMPEG4AAC_HE_V2"       , kAudioFormatMPEG4AAC_HE_V2},
    {"kAudioFormatMPEG4AAC_Spatial"     , kAudioFormatMPEG4AAC_Spatial},
    {"kAudioFormatAMR"                  , kAudioFormatAMR},
    {"kAudioFormatAudible"              , kAudioFormatAudible},
    {"kAudioFormatiLBC"                 , kAudioFormatiLBC},
    {"kAudioFormatDVIIntelIMA"          , kAudioFormatDVIIntelIMA},
    {"kAudioFormatMicrosoftGSM"         , kAudioFormatMicrosoftGSM},
    {"kAudioFormatAES3"                 , kAudioFormatAES3},
};

typedef struct {
    const char *name;
    int value;
} FormatFlagsList;
static FormatFlagsList flagsList[] = {
    {"Float", kAudioFormatFlagIsFloat},
    {"BigEndian", kAudioFormatFlagIsBigEndian},
    {"SignedInteger", kAudioFormatFlagIsSignedInteger},
    {"Packed", kAudioFormatFlagIsPacked},
    {"AlignedHigh", kAudioFormatFlagIsAlignedHigh},
    {"NonInterleaved", kAudioFormatFlagIsNonInterleaved},
    {"NonMixable", kAudioFormatFlagIsNonMixable},
};

void GetAUCanonicalDescription(AudioStreamBasicDescription *desc,
                               float samplingRate,
                               UInt32 numOfChannels)
{
    desc->mSampleRate = samplingRate;
    desc->mFormatID = kAudioFormatLinearPCM;
    desc->mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
    desc->mBytesPerPacket = sizeof(AudioUnitSampleType);
    desc->mFramesPerPacket = 1;
    desc->mBytesPerFrame = sizeof(AudioUnitSampleType);
    desc->mChannelsPerFrame = numOfChannels;
    desc->mBitsPerChannel = sizeof(AudioSampleType) * 8;
    desc->mReserved = 0;
}

void GetCanonicalDescription(AudioStreamBasicDescription *desc,
                             float samplingRate,
                             UInt32 numOfChannels)
{
    desc->mSampleRate = samplingRate;
    desc->mFormatID = kAudioFormatLinearPCM;
    desc->mFormatFlags = kAudioFormatFlagsCanonical;
    desc->mBytesPerPacket = sizeof(AudioSampleType) * numOfChannels;
    desc->mFramesPerPacket = 1;
    desc->mBytesPerFrame = sizeof(AudioSampleType) * numOfChannels;
    desc->mChannelsPerFrame = numOfChannels;
    desc->mBitsPerChannel = sizeof(AudioSampleType) * 8;
    desc->mReserved = 0;
}

void DumpASBD(AudioStreamBasicDescription *desc)
{
    if (!desc) {

        fprintf(stderr, "+-------- ASBD:%p --------\n", desc);
        return;
    }

    fprintf(stderr, "+-------- ASBD:%p --------\n", desc);
    fprintf(stderr, "| mSampleRate       = %lf\n", desc->mSampleRate);
    fprintf(stderr, "| mFormatID         = ");

    for (int i=0; i<sizeof(formatIDList)/sizeof(FormatIDList); ++i) {

        if (desc->mFormatID == formatIDList[i].value) {

            fprintf(stderr, "%s", formatIDList[i].name);
            break;
        }
    }

    fprintf(stderr, "\n");
    fprintf(stderr, "| mFormatFlags      = ");
    for (int i=0; i<sizeof(flagsList)/sizeof(FormatFlagsList); ++i) {

        if (desc->mFormatFlags & flagsList[i].value) {

            fprintf(stderr, "%s, ", flagsList[i].name);
        }
    }

    fprintf(stderr, "\n");
    fprintf(stderr, "| mBytesPerPacket   = %lu\n", desc->mBytesPerPacket);
    fprintf(stderr, "| mFramesPerPacket  = %lu\n", desc->mFramesPerPacket);
    fprintf(stderr, "| mBytesPerFrame    = %lu\n", desc->mBytesPerFrame);
    fprintf(stderr, "| mChannelsPerFrame = %lu\n", desc->mChannelsPerFrame);
    fprintf(stderr, "| mBitsPerChannel   = %lu\n", desc->mBitsPerChannel);
    fprintf(stderr, "| mReserved         = %lu\n", desc->mReserved);
    fprintf(stderr, "+---------------------------------\n");
}

void DumpASBDofAU(AudioUnit au, int scope, int bus)
{
    AudioStreamBasicDescription debug_desc = {0};
    UInt32 size = sizeof(debug_desc);
    AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat, scope, bus, &debug_desc, &size);
    DumpASBD(&debug_desc);
}
