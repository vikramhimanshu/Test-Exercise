//
//  NetworkRequest.m
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "NetworkRequest.h"

@interface NetworkRequest ()

@property (retain,nonatomic) NSOperationQueue *networkQueue;

@end

@implementation NetworkRequest

-(void)dealloc {
    [_networkQueue release];
    [super dealloc];
}

+(instancetype)sharedManager
{
    static NetworkRequest *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[NetworkRequest alloc] init];
    });
    return _sharedInstance;
}

- (void)getContentFromURL:(NSURL *)url withSuccessBlock:(GetRequestSuccessBlock)success andFailureBlock:(GetRequestFailureBlock)failure {
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:5.0] autorelease];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    [request setValue:@"ISO-8859-1" forHTTPHeaderField:@"Accept-Charset"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.networkQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (connectionError)
        {
           failure(connectionError);
        }
        else if ([data length])
        {
            NSString *resposeString = [[NSString alloc] initWithBytes:[data bytes]
                                                               length:[data length]
                                                             encoding:NSISOLatin1StringEncoding];
            const char *UTF8CString = [resposeString cStringUsingEncoding:NSUTF8StringEncoding];
            [resposeString release];
            
            NSData *utf8Data = [NSData dataWithBytes:UTF8CString length:strlen(UTF8CString)];
            NSError *jsonError = nil;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:utf8Data
                                                                         options:0
                                                                           error:&jsonError];
               if (jsonResponse) {
                   success(jsonResponse);
               } else {
                   failure(jsonError);
               }
        }
        else
        {
           NSError *unknownError = nil;
           failure(unknownError);
        }
    }];
}

- (void)getImageFromURL:(NSURL *)url
       withSuccessBlock:(GetImageSuccessBlock)success
        andFailureBlock:(GetRequestFailureBlock)failure {
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url
                                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                             timeoutInterval:5.0] autorelease];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.networkQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError)
         {
             failure(connectionError);
         }
         else if ([data length])
         {
             UIImage *image = [UIImage imageWithData:data];
             if (image) {
                 success(image);
             } else {
                 failure(nil);
             }
         }
         else
         {
             NSError *unknownError = nil;
             failure(unknownError);
         }
     }];
}

-(NSOperationQueue *)networkQueue {
    if (_networkQueue == nil) {
        _networkQueue = [[NSOperationQueue alloc] init];
    }
    return _networkQueue;
}

@end
