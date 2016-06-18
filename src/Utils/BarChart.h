#import <UIKit/UIKit.h>

@interface BarChart : UIView
{
    NSMutableDictionary *values;

    float m_min;
    float m_max;
    float m_width;
    float m_height;
    float m_barWidth;
    float m_barHeight;

    int m_currentTick;

@public
    int m_effectHeight;
}

@property(nonatomic,strong)UIColor *barColor;

-(id)initWithFrame:(CGRect)frame values:(NSMutableDictionary *)aValues;
- (void)update:(NSInteger)currentTime;

@end
