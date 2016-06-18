//
//  AsyncImageView.m
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "FullyLoaded.h"

@interface AsyncImageView ()
- (void) downloadImage:(NSString*)imageURL withCount:(int)counter;
@end

@implementation AsyncImageView
@synthesize request = _request;

- (void) dealloc {
	self.request.delegate = nil;
    [self cancelDownload];
    [super dealloc];
}

- (void) loadImage:(NSString*)imageURL withCount:(int)counter
{
    [self loadImage:imageURL withPlaceholdImage:nil withCount:counter];
}

- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage withCount:(int)counter
{
    self.image = placeholdImage;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{

        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (image) {

                self.image = image;

                [self fixWidthAndHeight:counter width:image.size.width height:image.size.height];
            } else {

                [self downloadImage:imageURL withCount:counter];
            }
        });
    });
}

- (void) cancelDownload
{
    [self.request cancel];
    self.request = nil;
}

#pragma mark - 
#pragma mark private downloads

- (void) downloadImage:(NSString *)imageURL withCount:(int)counter
{
    [self cancelDownload];
	NSString * newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:newImageURL]];
    [self.request setDownloadDestinationPath:[[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL]];
    [self.request setDelegate:self];
    [self.request setCompletionBlock:^(void){

         self.request.delegate = nil;
         NSLog(@"async image download done");

         NSString * imageURL = [[self.request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        self.request = nil;

         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
         dispatch_async(queue, ^{
            UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
            dispatch_sync(dispatch_get_main_queue(), ^{

                self.image = image;

                [self fixWidthAndHeight:counter width:image.size.width height:image.size.height];
            });
         });
    }];

    [self.request setFailedBlock:^(void){

        [self.request cancel];
        self.request.delegate = nil;
        self.request = nil;

        NSLog(@"async image download failed");
     }];

    [self.request startAsynchronous];
}

- (void) fixWidthAndHeight:(int) counter width:(float)imgWidth height:(float)imgHeight
{
    float width = 0.0;
    float height = 0.0;
    switch (counter) {
        case 1: width = 320.0;    height = 240.0;   break;
        case 2:
        case 3: width = 160.0;    height = 120.0;   break;
        default:width = 80.0;     height = 80.0;    break;
    }

    CGSize imgFinalSize = CGSizeZero;
    if (imgWidth < imgHeight){

        imgFinalSize.width = width;
        imgFinalSize.height = width * imgHeight / imgWidth;
        if (imgFinalSize.height < height){

            imgFinalSize.width = height * width / imgFinalSize.height;
            imgFinalSize.height = height;
        }
    }else{

        imgFinalSize.height = height;
        imgFinalSize.width = height * imgWidth / imgHeight;
        if (imgFinalSize.width < width){

            imgFinalSize.height = height * width / imgFinalSize.height;
            imgFinalSize.width = width;
        }
    }

    self.frame = CGRectMake(0, 0, imgFinalSize.width, imgFinalSize.height);
    self.bounds = CGRectMake(0, 0, width, height);
    self.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}
@end
