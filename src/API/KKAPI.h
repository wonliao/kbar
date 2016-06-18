//
//  KBarAPI.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

#define SERVER_ADDRESS ((NSString *) @"http://192.168.6.18:7878/")

@class KKAPI;

@interface KKAPI : NSObject {
    NSMutableData*      receivedData;
    NSDictionary*       jsonData;
    NSError*            apiError;
    NSMutableString*    getParameters;
    NSMutableData*      postParameters;
}

@property (copy) void (^succeededCallback)(void);
@property (copy) void (^errorCallback)(NSError * error);

+ (void)updateSID:(NSString *)theSid;
+ (NSString *)getSID;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (int)parse:(NSData *)data;

- (void)addGetParameter:(NSString *)key value:(NSString *)value;
- (void)addPostParameter:(NSString *)key value:(NSString *)value;
- (void)connect:(NSString*)urlString;
@end

