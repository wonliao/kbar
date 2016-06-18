//  MDCParallaxView.m
//
//  Copyright (c) 2012 modocache
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "MDCParallaxView.h"


static CGFloat const kMDCParallaxViewDefaultHeight = 150.0f;


@interface MDCParallaxView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *midgroundView;
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIScrollView *foregroundScrollView;
@property (nonatomic, strong) UIScrollView *midgroundScrollView;
- (void)updateBackgroundFrame;
- (void)updateForegroundFrame;
//- (void)updateMidegroundFrame;
- (void)updateContentOffset;
@end


@implementation MDCParallaxView


#pragma mark - Object Lifecycle

- (id)initWithBackgroundView:(UIView *)backgroundView midgroundView:(UIView *)midgroundView
              foregroundView:(UIView *)foregroundView {
    self = [super init];
    if (self) {
        _backgroundHeight = kMDCParallaxViewDefaultHeight;
        _backgroundView = backgroundView;
        _midgroundView = midgroundView;
        _foregroundView = foregroundView;
        
        _backgroundScrollView = [UIScrollView new];
        _backgroundScrollView.backgroundColor = [UIColor clearColor];
        _backgroundScrollView.showsHorizontalScrollIndicator = NO;
        _backgroundScrollView.showsVerticalScrollIndicator = NO;
        [_backgroundScrollView addSubview:_backgroundView];
        [self addSubview:_backgroundScrollView];
        /*
        _midgroundScrollView = [UIScrollView new];
        _midgroundScrollView.backgroundColor = [UIColor clearColor];
        _midgroundScrollView.showsHorizontalScrollIndicator = NO;
        _midgroundScrollView.showsVerticalScrollIndicator = NO;
        [_midgroundScrollView addSubview:_midgroundView];
        [self addSubview:_midgroundScrollView];
         */

        _foregroundScrollView = [UIScrollView new];
        _foregroundScrollView.backgroundColor = [UIColor clearColor];
        _foregroundView.frame = CGRectMake(0.0f,
                                               50.0f,
                                               _foregroundView.frame.size.width,
                                               _foregroundView.frame.size.height);
        _foregroundScrollView.delegate = self;
        [_foregroundScrollView addSubview:_foregroundView];
        [_foregroundScrollView addSubview:_midgroundView];
        [self addSubview:_foregroundScrollView];
        /*
        _midgroundScrollView = [UIScrollView new];
        _midgroundScrollView.backgroundColor = [UIColor clearColor];
        //_midgroundScrollView.showsHorizontalScrollIndicator = NO;
        //_midgroundScrollView.showsVerticalScrollIndicator = NO;
        _midgroundScrollView.delegate = self;
        [_midgroundScrollView addSubview:_midgroundView];
        [self addSubview:_midgroundScrollView];
         */

        
    }
    return self;
}
- (void)setforegroundView:(UIView *)foregroundView{
    [_foregroundView removeFromSuperview ];
    _foregroundView = foregroundView;
    [_foregroundScrollView addSubview:_foregroundView];
    [_foregroundScrollView addSubview:_midgroundView];
    [self updateForegroundFrame];
}

#pragma mark - UIView Overrides

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateBackgroundFrame];
    [self updateMidgroundFrame];
    [self updateForegroundFrame];
    [self updateContentOffset];
    //NSLog(@"setFrame");
}

- (void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask {
    [super setAutoresizingMask:autoresizingMask];
    self.backgroundView.autoresizingMask = autoresizingMask;
    self.backgroundScrollView.autoresizingMask = autoresizingMask;
    self.midgroundView.autoresizingMask = autoresizingMask;
    //self.midgroundScrollView.autoresizingMask = autoresizingMask;
    self.foregroundView.autoresizingMask = autoresizingMask;
    self.foregroundScrollView.autoresizingMask = autoresizingMask;
}


#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateContentOffset];
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewDidZoom:scrollView];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        return [self.scrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        [self.scrollViewDelegate scrollViewWillEndDragging:scrollView
                                              withVelocity:velocity
                                       targetContentOffset:targetContentOffset];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:_cmd]) {
        return [self.scrollViewDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}


#pragma mark - Public Interface

- (UIScrollView *)scrollView {
    return self.foregroundScrollView;
}

- (void)setBackgroundHeight:(CGFloat)backgroundHeight {
    _backgroundHeight = backgroundHeight;
    [self updateBackgroundFrame];
    [self updateMidgroundFrame];
    [self updateForegroundFrame];
    [self updateContentOffset];
    //NSLog(@"setBackgroundHeight");
}


#pragma mark - Internal Methods

- (void)updateBackgroundFrame {
    
    self.backgroundScrollView.frame = CGRectMake(0.0f,
                                                 0.0f,
                                                 self.frame.size.width,
                                                 self.frame.size.height);
    self.backgroundScrollView.contentSize = CGSizeMake(self.frame.size.width,
                                                       self.frame.size.height);
    self.backgroundScrollView.contentOffset	= CGPointZero;

    self.backgroundView.frame =
        CGRectMake(0.0f,
                   0.0f,
                   self.frame.size.width,
                   self.backgroundView.frame.size.height);
    
    //NSLog(@"updateBackgroundFrame");
}
- (void)updateMidgroundFrame {
    //self.midgroundScrollView.frame = CGRectMake(0.0f,
     //                                            0.0f,
      //                                           self.frame.size.width,
      //                                           self.frame.size.height);
    //self.midgroundScrollView.contentSize = CGSizeMake(self.frame.size.width,
    //                                                   self.frame.size.height);
    //self.midgroundScrollView.contentOffset	= CGPointZero;
    
    self.midgroundView.frame =
    CGRectMake(0.0f,
               self.backgroundHeight,
               self.frame.size.width,
               self.midgroundView.frame.size.height);
    //[self bringSubviewToFront:_midgroundView];
    NSLog(@"updateMidgroundFrame");

}

- (void)updateForegroundFrame {
    self.foregroundView.frame = CGRectMake(0.0f,
                                           self.backgroundHeight+50,
                                           self.foregroundView.frame.size.width,
                                           self.foregroundView.frame.size.height);

    self.foregroundScrollView.frame = self.bounds;
    self.foregroundScrollView.contentSize =
        CGSizeMake(self.foregroundView.frame.size.width,
                   self.foregroundView.frame.size.height + self.backgroundHeight );
    //NSLog(@"updateForegroundFrame");
}

- (void)updateContentOffset {
    //前景的位移
    CGFloat offsetY   = self.foregroundScrollView.contentOffset.y;

    //NSLog(@"offsetY=%f",offsetY);
    //NSLog(@"threshold=%f",offsetY);

        self.backgroundScrollView.contentOffset = CGPointMake(0.0f, offsetY);
    if (offsetY > 290) {
        //self.midgroundScrollView.contentOffset = CGPointMake(0.0f, offsetY);
        _midgroundView.frame = CGRectMake(0.0f,
                                          offsetY,
                                          _midgroundView.frame.size.width,
                                          _midgroundView.frame.size.height);
    }

    

            

    //NSLog(@"updateContentOffset");
 
}

@end
