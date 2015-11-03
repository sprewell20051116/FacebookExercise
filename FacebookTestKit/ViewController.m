//
//  ViewController.m
//  FacebookTestKit
//
//  Created by GIGIGUN on 2015/10/26.
//  Copyright © 2015年 GIGIGUN. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ListTableViewController.h"
@interface ViewController () <FBSDKGraphRequestConnectionDelegate> {
    NSDictionary *_RequestResult;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.readPermissions =@[@"public_profile",
                                      @"email",
                                      @"user_friends"];
    // Do any additional setup after loading the view, typically from a nib.
//    if ([FBSDKAccessToken currentAccessToken]) {
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 NSLog(@"fetched user:%@", result);
//             }
//         }];
//    }

    if ([FBSDKAccessToken currentAccessToken]) {
        
        FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                        initWithGraphPath:@"me" parameters:nil];
        
        FBSDKGraphRequest *requestLikes = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"me/likes" parameters:nil];

        FBSDKGraphRequest *requestPost = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"me/posts" parameters:nil];
        
        FBSDKGraphRequest *requestPages = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"/351786334846150" parameters:@{@"fields" : @"likes,about,posts"}]; //appCoda
        
        FBSDKGraphRequest *requestPages_Church = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"/152088544855478" parameters:@{ @"fields": @"name,description,likes,public_transit,phone,location",}]; //Church
        
        
        FBSDKGraphRequest *requestPages_Comment = [[FBSDKGraphRequest alloc]
                                                  initWithGraphPath:@"/152088544855478_894090300655295" parameters:@{ @"fields": @"full_picture,message,likes"}]; //Comment request
        
        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
        [connection addRequest:requestMe
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process me information
                 //NSLog(@"fetched user:%@", result);
             }];
        [connection addRequest:requestLikes
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
//                 NSLog(@"fetched likes:%@", result);
//                 _RequestResult = result;
             }];
        
        [connection addRequest:requestPost
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
//                 NSLog(@"fetched posts:%@", result);
             }];
        
        [connection addRequest:requestPages
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
//                 NSLog(@"fetched pages:%@", result);
//                 _RequestResult = result;
             }];
        
        [connection addRequest:requestPages_Church
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
//                  NSLog(@"fetched pages:%@", result);
//                  _RequestResult = result;
             }];
        
        [connection addRequest:requestPages_Comment
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
                 NSLog(@"fetched pages:%@", result);
                 _RequestResult = result;
             }];
        
        connection.delegate = self;
        [connection start];
    }
    else {
        NSLog(@"no permission");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ListTableViewController *DestViewController = [segue destinationViewController];
    DestViewController.result = _RequestResult;
}


@end
