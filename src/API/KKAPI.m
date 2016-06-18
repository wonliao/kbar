//
//  KBarAPI.m
//
// add by wonliao
//

#import "KKAPI.h"
#import "StringUtils.h"

static NSString* sid;

@implementation KKAPI

+ (void)updateSID:(NSString *)theSid {
    sid = theSid;
}

+ (NSString *)getSID {
    return [StringUtils urlEncode:sid];
}

- (void)addGetParameter:(NSString *)key value:(NSString *)value {
    if (getParameters == nil) {
        getParameters = [NSMutableString stringWithFormat:@"?%@=%@", key, value];
    } else {
        [getParameters appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
}

- (void)addPostParameter:(NSString *)key value:(NSString *)value {
    if (postParameters == nil) {
        postParameters = [[NSMutableData alloc] init];
        [postParameters appendData:[[NSString stringWithFormat:@"%@=%@", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [postParameters appendData:[[NSString stringWithFormat:@"&%@=%@", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void)connect:(NSString*)urlString {
    NSMutableURLRequest *urlRequest;
    if (getParameters != nil) {
        NSLog(@"%@%@%@", SERVER_ADDRESS, urlString, getParameters);
        urlRequest= [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, urlString, getParameters]]];
    } else {
        NSLog(@"%@%@", SERVER_ADDRESS, urlString);
        urlRequest= [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, urlString]]];
    }
    if (postParameters != nil) {
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:postParameters];
    }
	[NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_errorCallback) {
        _errorCallback(apiError);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	receivedData = [[NSMutableData alloc] init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self parse:receivedData] < 0) {
        if (_errorCallback) {
            _errorCallback(apiError);
        }
    } else if (_succeededCallback) {
        _succeededCallback();
    }
}

- (int)parse:(NSData *)data {
    NSError *error;
    jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%@", [[NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding]);
    int status = [[jsonData objectForKey:@"status"] intValue];
    if (status < 0) {
        NSString* errorMessage = [jsonData objectForKey:@"error_message"];
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:errorMessage forKey:NSLocalizedDescriptionKey];
        apiError = [NSError errorWithDomain:@"com.kkbox.kbar.api" code:status userInfo:errorDetail];
    }
    return status;
}

@end
