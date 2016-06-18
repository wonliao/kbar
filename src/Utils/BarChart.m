#import "BarChart.h"

@implementation BarChart

-(id)initWithFrame:(CGRect)frame values:(NSMutableDictionary *)aValues;
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        values = aValues;
        m_height   = self.frame.size.height;
        m_width    = self.frame.size.width;
        m_barWidth = m_width / 200;
        m_barHeight = 10;
        m_min = 0;
        m_max = 97;
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.barColor setFill];
    [self.barColor setStroke];

    CGRect bar = CGRectMake(50, // 偏移 50 px
                            m_height - m_max,
                            3,
                            m_max);
    [self.barColor setFill];
    UIRectFill(bar);

    for(int i=0; i<200; i++) {

        // 50 / 320 = xxx / 200
        // xxx = 31
        NSString *key = [NSString stringWithFormat:@"%d", m_currentTick + (i-31)*10];
        float value =  [[values valueForKey:key] floatValue];
        if( value > 0 ) {

            float barHeight = ((value-m_min)/(m_max-m_min))*(m_height-20)+20;
            
            CGRect bar = CGRectMake(m_barWidth * i,
                                    m_height - barHeight,
                                    m_barWidth,
                                    10);

            if( i<33 ) {

                [[UIColor colorWithRed:116.0/255.0
                                 green:152.0/255.0
                                  blue:71.0/255.0
                                 alpha:1] setFill];
            } else {

                [self.barColor setFill];
            }
            
            UIRectFill(bar);

            // for 特效跟拍
            if( i == 50 ) {

                m_effectHeight = m_height - barHeight;
            }
        }
    }
}

- (void)update:(NSInteger)currentTime
{
    //m_currentTick = currentTime;
    int a = round( currentTime / 10 );
    m_currentTick = a * 10;

    [self setNeedsDisplay];
}

@end
