#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ImgPool.h"



@protocol HFImageEditorFrame
@required
@property(nonatomic,assign) CGRect cropRect;
@end

@class ASIFormDataRequest;
@class  HFImageEditorViewController;

typedef void(^HFImageEditorDoneCallback)(UIImage *image, BOOL canceled);

@interface HFImageEditorViewController : UIViewController<UIGestureRecognizerDelegate, MBProgressHUDDelegate> {

    ASIFormDataRequest *request;

    // 合成時間吧
    MBProgressHUD *HUD;
}

@property(nonatomic,copy) HFImageEditorDoneCallback doneCallback;
@property(nonatomic,copy) NSString *fbUID;
@property(nonatomic,copy) UIImage *sourceImage;
@property(nonatomic,copy) UIImage *previewImage;
@property(nonatomic,assign) CGSize cropSize;
@property(nonatomic,assign) CGFloat outputWidth;
@property(nonatomic,assign) CGFloat minimumScale;
@property(nonatomic,assign) CGFloat maximumScale;

@property(nonatomic,assign) BOOL panEnabled;
@property(nonatomic,assign) BOOL rotateEnabled;
@property(nonatomic,assign) BOOL scaleEnabled;
@property(nonatomic,assign) BOOL tapToResetEnabled;

@property(nonatomic,readonly) CGRect cropBoundsInSourceImage;

@property (retain, nonatomic) ASIFormDataRequest *request;
@property (strong, nonatomic) MBProgressHUD *HUD;

- (void)reset:(BOOL)animated;

@end


