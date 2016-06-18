//
//  wordpress.m
//  kBar
//
//  Created by wonliao on 13/3/6.
//
//

#import "wordpress.h"
#import "ASIHTTPRequest.h"
#import "FullyLoaded.h"

@implementation wordpress


// 查詢 wordpress 資料
-(NSArray *) queryWordpress:(NSString *) query
{
    NSData *elementsData;
    NSString *urlString = [NSString stringWithFormat:@"http://54.200.150.53/kbar/myapi/%@", query];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString: urlString];
    elementsData = [NSData dataWithContentsOfURL:url];
    NSError *anError = nil;
    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&anError];
    if( [parsedElements count] > 0 ) {

        return parsedElements;
    } else {
        
        NSLog(@"can't connect wordpress");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"連接失敗"
                              message:[NSString stringWithFormat:@"服務器連接失敗，請重試"]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

    return nil;
}

// 異步查詢 wordpress 資料
-(void) queryWordpress:(NSString *) query completion:(void (^)(NSArray *))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"http://54.200.150.53/kbar/myapi/%@", query];
    NSURL *url = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    __block __typeof__(self) blockSelf = self;
	ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    request.defaultResponseEncoding = NSUTF8StringEncoding;
	[request addRequestHeader:@"Content-Type" value:@"text/xml"];

	[request setCompletionBlock:^
     {
         if ([request responseStatusCode] != 200)
         {
             NSDictionary* userInfo = [NSDictionary
                                       dictionaryWithObject:@"Unexpected response from server"
                                       forKey:NSLocalizedDescriptionKey];
             
             NSError* error = [NSError
                               errorWithDomain:NSCocoaErrorDomain
                               code:kCFFTPErrorUnexpectedStatusCode
                               userInfo:userInfo];
             
             [blockSelf handleError:error];
             return;
         }

         NSError *anError = nil;
         NSData *elementsData = [request responseData];
         NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&anError];

         if (completionBlock != nil) completionBlock(parsedElements);
     }];
    
	[request setFailedBlock:^
     {
         [blockSelf handleError:[request error]];
     }];
    
	[request startAsynchronous];

}


- (void)handleError:(NSError*)error
{
	UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"Cannot Connet Server"
                              message:[error localizedDescription]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];

	[alertView show];
}

// 取得指定角色圖片
-(void) getUserImage:(NSString *)uid completion:(void (^)(UIImage *))completionBlock
{
    NSString *fileName = [NSString stringWithFormat:@"FB_%@.jpg", uid];
    NSString *urlString = [NSString stringWithFormat:@"http://54.200.150.53/kbar/wp-content/uploads/photos/%@", fileName];

    NSURL *url = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];

    __block __typeof__(self) blockSelf = self;
	ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    request.defaultResponseEncoding = NSUTF8StringEncoding;
	[request addRequestHeader:@"Content-Type" value:@"text/xml"];
	[request setCompletionBlock:^
     {
         NSString * imageURL = [[request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
         dispatch_async(queue, ^{
             UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
             dispatch_sync(dispatch_get_main_queue(), ^{

                 NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                 NSString *uniquePath=[documentsPath stringByAppendingPathComponent:fileName];
                 [UIImagePNGRepresentation(image)writeToFile:uniquePath atomically:YES];

                 if (completionBlock != nil) completionBlock(image);
             });
         });
     }];

	[request setFailedBlock:^
     {
         [blockSelf handleError:[request error]];
     }];

	[request startAsynchronous];
}

@end
