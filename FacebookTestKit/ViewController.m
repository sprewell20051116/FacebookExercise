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
@interface ViewController () <FBSDKGraphRequestConnectionDelegate>
@property (strong, nonatomic) NSMutableArray *DisplayData;

@end

#define FBID_TEST_1 @"/447459395280612" // 基隆中山長老教會
#define FBID_TEST_2 @"/425790100787215" // 台灣基督長老教會
#define FBID_TEST_3 @"/152088544855478" // 埔墘教會

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _DisplayData = [NSMutableArray new];
    
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
        
//        FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
//                                        initWithGraphPath:@"me" parameters:nil];
//        
//        FBSDKGraphRequest *requestLikes = [[FBSDKGraphRequest alloc]
//                                           initWithGraphPath:@"me/likes" parameters:nil];
//
//        FBSDKGraphRequest *requestPost = [[FBSDKGraphRequest alloc]
//                                           initWithGraphPath:@"me/posts" parameters:nil];
//        
//        FBSDKGraphRequest *requestPages = [[FBSDKGraphRequest alloc]
//                                           initWithGraphPath:@"/351786334846150" parameters:@{@"fields" : @"likes,about,posts"}]; //appCoda
//        
//        FBSDKGraphRequest *requestPages_Church = [[FBSDKGraphRequest alloc]
//                                           initWithGraphPath:@"/152088544855478" parameters:@{ @"fields": @"name,description,likes,public_transit,phone,location",}]; //Church
//        
//        
//        FBSDKGraphRequest *requestPages_Comment = [[FBSDKGraphRequest alloc]
//                                                  initWithGraphPath:@"/152088544855478_894090300655295" parameters:@{ @"fields": @"full_picture,message,likes"}]; //Comment request
//        
//        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
//        [connection addRequest:requestMe
//             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                 //TODO: process me information
//                 //NSLog(@"fetched user:%@", result);
//             }];
//        [connection addRequest:requestLikes
//             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                 //TODO: process like information
////                 NSLog(@"fetched likes:%@", result);
////                 _RequestResult = result;
//             }];
//        
//        [connection addRequest:requestPost
//             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                 //TODO: process like information
////                 NSLog(@"fetched posts:%@", result);
//             }];
//        
//        [connection addRequest:requestPages
//             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                 //TODO: process like information
////                 NSLog(@"fetched pages:%@", result);
////                 _RequestResult = result;
//             }];
//        
//        [connection addRequest:requestPages_Church
//             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                 //TODO: process like information
////                  NSLog(@"fetched pages:%@", result);
////                  _RequestResult = result;
//             }];
//
        
        FBSDKGraphRequest *requestPages_1 = [[FBSDKGraphRequest alloc]
                                                  initWithGraphPath:FBID_TEST_2
                                                   parameters:@{ @"fields": @"posts.since(2015-08-01){full_picture,message,created_time},name",}]; //Comment request
        
        FBSDKGraphRequest *requestPages_2 = [[FBSDKGraphRequest alloc]
                                             initWithGraphPath:FBID_TEST_3
                                             parameters:@{ @"fields": @"posts.since(2015-09-01){full_picture,message,created_time},name",}]; //Comment request

        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];

        [connection addRequest:requestPages_1
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
                 //NSLog(@"Req 1 %@", result);
                 //_RequestResult = result;
                 [self MergePostsForDisplayWithConnectionResult:result];
             }];

        [connection addRequest:requestPages_2
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //TODO: process like information
                 //NSLog(@"Req 2 %@", result);
                 //_RequestResult = result;
                 [self MergePostsForDisplayWithConnectionResult:result];
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
    DestViewController.result = _DisplayData;
}

- (void) MergePostsForDisplayWithConnectionResult : (id) PostData
{
//    NSLog(@"id = %@", [PostData objectForKey:@"id"]);
//    NSLog(@"name = %@", [PostData objectForKey:@"name"]);
//    NSLog(@"Data = %@", [[PostData objectForKey:@"posts"] objectForKey:@"data"]);
    
    NSString *PageID = [PostData objectForKey:@"id"];
    NSString *PageName = [PostData objectForKey:@"name"];
    NSArray *PostsArray = [[PostData objectForKey:@"posts"] objectForKey:@"data"];
    
    
    for (NSDictionary *PostData in PostsArray) {
        NSMutableDictionary *PostDic = [[NSMutableDictionary alloc] initWithDictionary:PostData];
        [PostDic setObject:PageID forKey:@"page_id"];
        [PostDic setObject:PageName forKey:@"page_name"];
        [_DisplayData addObject:PostDic];
    }
    
    
    
//    
    NSLog(@"_DisplayData = %@", _DisplayData);
//    
//    NSSortDescriptor *SortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"created_time" ascending:NO];
//    NSArray *TestArray = [_DisplayData sortedArrayUsingDescriptors:[NSArray arrayWithObject:SortDescriptor]];
//    NSLog(@"!!!!!!!!!!!!!!!!!!");
//    NSLog(@"_DisplayData = %@", TestArray);

}

@end
