//
//  DBWebViewController.m
//  MissAn
//
//  Created by chengzhang Yan on 17/11/20.
//  Copyright (c) 2017年 doBell. All rights reserved.
//

#import "DBWebViewController.h"
#import <WebKit/WebKit.h>

@interface DBWebViewController ()<UIAlertViewDelegate,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UIProgressView *progressView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIBarButtonItem *rightItem;


@end

@implementation DBWebViewController
#pragma mark LifeCircle

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self cleanCacheAndCookie]; //先清除缓存
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self cleanCacheAndCookie]; //先清除缓存
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupWebView];
    [self setupNavigationItems];
    [self setupProgressView];
    [self loadWebRequestWithUrlString:_URLString];// 获取之后再请求数据
}
#pragma mark SetupUI
- (void)setupWebView
{
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.allowsInlineMediaPlayback = YES; //支持播放视频
    if (@available(iOS 9.0, *)) {
        config.allowsPictureInPictureMediaPlayback = YES;
    }
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kNavigationBarHeight) configuration:config];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES; // 支持滑动返回

    [self.view addSubview:webView];
    self.webView = webView;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil]; // 加载进度的监听
}

- (void)setupNavigationItems
{
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshBtn setImage:IMAGE_NAME(@"icon_refresh") forState:UIControlStateNormal];
    [self.refreshBtn setFrame:CGRectMake(0, 0, 34, 34)];
    self.refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 0);
    [self.refreshBtn addTarget:self action:@selector(refreshWebViewWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    _activityView.color = kGray_five;
    
    self.rightItem = [[UIBarButtonItem alloc]initWithCustomView:_activityView];
    self.navigationItem.rightBarButtonItem = _rightItem;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:IMAGE_NAME(@"nav_back_default") forState:UIControlStateNormal];
    [backButton setImage:IMAGE_NAME(@"nav_back_default") forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, - 20, 0, 0);
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}
- (void)updateNavigationItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:IMAGE_NAME(@"nav_back_default") forState:UIControlStateNormal];
    [backButton setImage:IMAGE_NAME(@"nav_back_default") forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, - 20, 0, 0);
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [closeButton setTitleColor:kGray_five forState:UIControlStateNormal];
    [closeButton sizeToFit];
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(0, - 20, 0, 0);
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];

    self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
}
- (void)setupProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
    progressView.tintColor = [UIColor orangeColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}
#pragma mark Action
// 刷新 webView
- (void)refreshWebViewWithBtn:(UIButton *)sender
{
    [_webView reload];
}
- (void)goBackAction:(UIButton *)sender
{
    //判断是否有上一层H5页面 
    if ([_webView canGoBack]) {
        [_webView goBack];
        [self updateNavigationItem];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)closeAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 清除缓存和cookie
- (void)cleanCacheAndCookie
{
    if (@available(iOS 9.0, *)) // iOS 8.0 的WKWebView没有清除缓存的功能
    {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Done
            debug_NSLog(@"WKWebView清除缓存成功");
        }];
    }
}

- (void)loadWebRequestWithUrlString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",urlString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}

- (void)refreshData
{
    [_webView reload];
}
#pragma mark --- WKWebView--NavigationDelegate
// 开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    self.rightItem = [[UIBarButtonItem alloc]initWithCustomView:_activityView];
    self.navigationItem.rightBarButtonItem = _rightItem;
    [_activityView startAnimating];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

// 页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.title"] completionHandler:^(id _Nullable response, NSError * _Nullable error) {

        if (response) {
            // self.title = webView.title;
            NSString *title = [NSString stringWithFormat:@"%@",response];
            [self setNavigationTitle: title];
        }
    }];
    @try {
        [_activityView stopAnimating];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:_refreshBtn];
        self.navigationItem.rightBarButtonItem = _rightItem;
    }
    @catch (NSException *exception) {

    }
    @finally {

    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [_activityView stopAnimating];
    _rightItem = [[UIBarButtonItem alloc] initWithCustomView:_refreshBtn];
    self.navigationItem.rightBarButtonItem = _rightItem;
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL boolLoad = YES;
    @try
    {
        NSString *urlString = [[[navigationAction request] URL].absoluteString stringByRemovingPercentEncoding];
        NSString *scheme = [[[navigationAction request] URL] scheme];
        // 拨打电话
        if ([scheme isEqualToString:@"tel"])
        {
            NSString *resourceSpecifier = [[[navigationAction request] URL] resourceSpecifier];
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            });
        }
       
        else
        {
            if (navigationAction.targetFrame == nil)
            {
                [_webView loadRequest:navigationAction.request];
            }
        }
    }
    @catch (NSException *exception)
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    @finally
    {
        if (boolLoad)
        {
            decisionHandler(WKNavigationActionPolicyAllow);
        }else{
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    }
    debug_NSLog(@"decidePolicyForNavigationAction   ====    %@", navigationAction);
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    debug_NSLog(@"decidePolicyForNavigationResponse   ====    %@", navigationResponse);
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 权限认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }

}
#pragma mark UIDelegate <主要与JS交互>
// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    if (self.navigationController.visibleViewController == self){
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        completionHandler();
    }
}
// 弹出一个输入框（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    debug_NSLog(@"弹窗输入框");
    debug_NSLog(@"%@",prompt);
    debug_NSLog(@"%@",defaultText);
    debug_NSLog(@"%@",frame);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //这里必须执行不然页面会加载不出来
        completionHandler(@"");
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        debug_NSLog(@"%@",
             [alert.textFields firstObject].text);
        completionHandler([alert.textFields firstObject].text);
    }];
    [alert addAction:a1];
    [alert addAction:a2];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        debug_NSLog(@"%@",textField.text);
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

// 显示一个确认框（JS）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    debug_NSLog(@"弹窗确认框");
    debug_NSLog(@"%@",message);
    debug_NSLog(@"%@",frame);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark KVO
// 进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressView.alpha = 1.0f;
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.progressView.alpha = 0.0f;
                }
               completion:^(BOOL finished) {
                    [self.progressView setProgress:0 animated:NO];
            }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
