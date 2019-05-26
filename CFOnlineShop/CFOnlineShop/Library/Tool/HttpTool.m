//
//  HttpTool.m
//  网络请求封装
//
//  Created by apple on 15-8-20.
//  Copyright (c) 2015年 jackyu
//

#import "HttpTool.h"
#import "AFNetworking.h"
//#import "NSDictionary+MD5.h"
//#import "StringConvert.h"
#import "AppDelegate.h"

@implementation HttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    static AFHTTPSessionManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 2.发送GET请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
//    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    static AFHTTPSessionManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/plain", @"text/javascript", nil];
        mgr.requestSerializer.timeoutInterval = 10;
    });
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //secret
    NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:params];
    [newdic setValue:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];

    // 2.发送POST请求
    [mgr POST:[NSString stringWithFormat:@"%@/%@", @"", url] parameters:newdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([responseObject[@"result"] isEqualToString:@"0"]) {
                success(responseObject);
            }else {

            }
            
            if ([responseObject[@"errcode"] isEqualToString:@"100024"] || [responseObject[@"errcode"] isEqualToString:@"100025"]) {
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

@end
