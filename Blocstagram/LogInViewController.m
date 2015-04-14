//
//  LogInViewController.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/25/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "LogInViewController.h"
#import "DataSource.h"

@interface LogInViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@end

@implementation LogInViewController

NSString *const LogInViewControllerDidGetAccessTokenNotification = @"LogInViewControllerDidGetAccessTokenNotification";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&scope=likes+comments+relationships&redirect_uri=%@&response_type=token", [DataSource instagramClientID], [self redirectURI]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (url)
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
    if (self)
    {
        self.title = NSLocalizedString(@"Login", @"login");
    }
    
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStyleDone target:self.webView action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = self.backButton;

}

- (void) goBack
{
    self.backButton.enabled = [self.webView canGoBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)redirectURI
{
    return @"http://bloc.io/";
}

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    
    self.webView = webView;
    self.view = webView;
    
}

- (void)dealloc
{
    [self clearInstagramCookies];
    
    self.webView.delegate = nil;
}

- (void)clearInstagramCookies
{
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        NSRange domainRange = [cookie.domain rangeOfString:@"instagram.com"];
        if (domainRange.location != NSNotFound)
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString hasPrefix:[self redirectURI]])
    {
        NSRange rangeOfAccessTokenParameter = [urlString rangeOfString:@"access_token="];
        NSUInteger indexOfTokenStarting = rangeOfAccessTokenParameter.location + rangeOfAccessTokenParameter.length;
        NSString *accessToken = [urlString substringFromIndex:indexOfTokenStarting];
        [[NSNotificationCenter defaultCenter] postNotificationName:LogInViewControllerDidGetAccessTokenNotification object:accessToken];
        return NO;
    }
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
