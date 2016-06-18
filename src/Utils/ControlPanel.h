//
//  ControlPanel.h
//  mySingPage
//
//  Created by vincent on 13/1/22.
//  Copyright (c) 2013年 vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>


@interface ControlPanel : UIView{
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    
    UIColor *_color;
    
    CGGradientRef _gradient;
    
    UIButton *button2;
    
    //AVAudioPlayer *m_pLongMusicPlayer;
}

@property (nonatomic, assign) UIImage *icon;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *detail;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) UIButton *button2;

- (id)initWithWidth:(CGFloat)width;
- (id)initWithTitle:(NSString *)title detail:(NSString *)detail icon:(UIImage *)icon;
- (UIColor *)lightenColor:(UIColor *)oldColor value:(float)value;

- (IBAction)forwardButtonTapped:(id)sender;
- (IBAction)playButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;
- (IBAction)backwardButtonTapped:(id)sender;

@end
