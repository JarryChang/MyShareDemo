//
//  COShareView.h
//  MyShareDemo
//
//  Created by chang on 14/11/12.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import "COShareView.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "Notify.h"

@implementation UIButtonCustom
@synthesize index;

@end

@implementation ShareModel
@synthesize nameItem;
@synthesize imageItem;
@synthesize contentItem;

- (id)initWith:(NSString *)_nameItem :(NSString *)_imageItem :(NSString *)_contentItem{
    
    if (self = [super init]) {
        nameItem = [_nameItem copy];
        imageItem = [_imageItem copy];
        contentItem = [_contentItem copy];
    }
    return self;
}

@end

@interface COShareView ()

@property (nonatomic,strong) UIView *shareItemBG;
@property (nonatomic)ShareWay  shareWay;
@property (nonatomic,strong) NSString   *shareContent;      //分享内容  默认所有分享内容都一样
@property (nonatomic,strong) NSArray    *arrayItems;        //所有分享  数组

@end

@implementation COShareView


+(void)showShareViewContent:(NSString*)content{
    COShareView *temp = [[[self class]alloc] initWithContent:content];
    [temp addToRootView];
}

+(void)showShareViewModelItems:(NSMutableArray*)modelItems{
    
    COShareView *temp = [[[self class]alloc] initWithModelItems:modelItems];
    [temp addToRootView];
}

- (id)init{
    
    UIView *rootView = [self rootViewController].view;
    self = [super initWithFrame:rootView.bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    return self;
}

- (id)initWithContent:(NSString*)content{
    
    if ([self init]) {
        self.shareWay = ShareDefaultContentSame;
        self.shareContent = content;
        [self initData];
        [self initView];
    }
    return self;
}
    
- (id)initWithModelItems:(NSMutableArray*)modelItems{
    
    if ([self init]) {
        self.shareWay = ShareCustomContentDiff;
        self.arrayItems = [NSMutableArray arrayWithArray:modelItems];
        
        [self initData];
        [self initView];
    }
    return self;
}

- (void)addToRootView{
    UIView *rootView = [self rootViewController].view;
    [rootView addSubview:self];
}

- (UIViewController*)rootViewController{
    
    return [[UIApplication sharedApplication].delegate window].rootViewController;
}

- (void)initData{
    
    NSString *sinaWeibo     = @"新浪微博";
    NSString *tencentWechat = @"微信";
    NSString *wechatTimeLine = @"微信朋友圈";
    NSString *appleSMS      = @"短信";
    NSString *appleEmail    = @"邮件";
    
    if (self.shareWay==ShareDefaultContentSame) {
        NSMutableArray *arrayData = [NSMutableArray array];
        NSArray *arrayItems      = [NSArray arrayWithObjects:sinaWeibo,tencentWechat,wechatTimeLine,appleSMS,appleEmail,nil];
        NSArray *arrayImageItems = [NSArray arrayWithObjects:@"xinlang72.png",@"weixin72.png",@"wechat_c.png",@"sms72.png",@"mail72.png",nil];
        for (int i=0;i<arrayItems.count;i++) {
            
            NSString *nameItem = [arrayItems objectAtIndex:i];
            NSString *imageItem = [arrayImageItems objectAtIndex:i];
            
            ShareModel *shareModel = [[ShareModel alloc] initWith:nameItem :imageItem :self.shareContent];
            [arrayData addObject:shareModel];
        }
        self.arrayItems = [NSArray arrayWithArray:arrayData];
    }
}

#pragma mark UI绘制
- (void)initView{
    
    if (self.arrayItems==nil||self.arrayItems.count==0) {
        return;
    }
    
    float height = 0;
    NSInteger countRow = 0;
    
    if (self.arrayItems.count%4!=0) {
        countRow = self.arrayItems.count/4+1;
    }
    else{
        countRow = self.arrayItems.count/4;
    }
    
    if (countRow<4) {
        height = 10+18+20+countRow*(60+18+10)+10;
    }
    else{
        height = 10+18+20+3*(60+18+10)+10;
    }
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, height+2)];
    bg.backgroundColor = [UIColor clearColor];
    self.shareItemBG = bg;
    [self addSubview:bg];
    
    UIView *segView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 2)];
    segView.backgroundColor = [UIColor colorWithRed:140.0/255 green:140.0/255 blue:140.0/255 alpha:1];
    [bg addSubview:segView];
    
    UIView *btnBG = [[UIView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, height)];
    btnBG.clipsToBounds = YES;
    btnBG.backgroundColor = [UIColor whiteColor];
    [bg addSubview:btnBG];
    
    NSString *choice = @"请选择分享方式";
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.frame.size.width-20, 20)];
    title.text = choice;
    title.font = [UIFont systemFontOfSize:18.0];
    title.textAlignment = NSTextAlignmentCenter;
    [btnBG addSubview:title];
    
    //button初始化
    int count_x = 0;
    int count_y = 0;
    for (int i=0 ;i<[self.arrayItems count] ;i++) {
        
        ShareModel *shareModel = [self.arrayItems objectAtIndex:i];
        NSString *imagePath = shareModel.imageItem;
        NSString *title = shareModel.nameItem;
        
        UIButtonCustom *button = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(16+(60+16)*count_x, count_y*(60+10+20)+50, 60, 60);
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
        button.index = i;
        [button addTarget:self action:@selector(choiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btnBG addSubview:button];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y+60+2, 60, 18)];
        lable.font = [UIFont systemFontOfSize:12.0];
        lable.text = title;
        lable.textAlignment = NSTextAlignmentCenter;
        [btnBG addSubview:lable];
        
        //换行
        count_x++;
        if ((i+1)%4==0) {
            count_x = 0;
            count_y++;
        }
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         bg.frame = CGRectMake(0, self.frame.size.height-height-2, self.frame.size.width, height+2);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark button 事件
- (void)choiceBtn:(UIButtonCustom*)button{
    
    [self shareEnter:button.index];
}

#pragma mark 分享入口
- (void)shareEnter:(NSInteger)index{
    
    /*
     *  目前只有四种分享方式,新浪微博,微信,短信,邮件
     *  如有以后有更多的分享方式直接在switch 中添加新的分享即可
     *
     */
    
    if (self.arrayItems==nil||self.arrayItems.count==0) {
        return;
    }
    
    NSString *sinaWeibo     = @"新浪微博";
    NSString *tencentWechat = @"微信";
    NSString *wechatTimeLine = @"微信朋友圈";
    NSString *appleSMS      = @"短信";
    NSString *appleEmail    = @"邮件";
    NSString *shareFailed   = @"分享失败";
    
    //注意国际化问题
    ShareModel  *shareModel = [self.arrayItems objectAtIndex:index];
    NSString    *title      = shareModel.nameItem;
    NSString    *content    = shareModel.contentItem;
    
    if ([sinaWeibo isEqual:title]) {
        [self shareSinaWeibo:content];
    }
    else if ([tencentWechat isEqual:title]){
        [self shareTencenttWeixin:content scene:WXSceneSession];
    }
    else if ([wechatTimeLine isEqual:title]) {
        [self shareTencenttWeixin:content scene:WXSceneTimeline];
    }
    else if ([appleSMS isEqual:title]){
        [self shareAppleSMS:content];
    }
    else if ([appleEmail isEqual:title]){
        [self shareAppleMail:content];
    }
    else{
        [Notify showAlertDialog:self messageString:shareFailed];
    }
    
}

#pragma mark 新浪微博分享
- (void)shareSinaWeibo:(NSString*)content{
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        WBMessageObject *message = [[WBMessageObject alloc] init];
        message.text = content;
        WBSendMessageToWeiboRequest *request = [[WBSendMessageToWeiboRequest alloc] init];
        request.message = message;
        [WeiboSDK sendRequest:request];
    } else {
        NSString *unstallSina = @"您还未安装新浪微博";
        [Notify showAlertDialog:self messageString:unstallSina];
    }
    
}

#pragma mark 微信分享
- (void)shareTencenttWeixin:(NSString*)content scene:(int)scene{
    
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = content;
        req.scene = scene;
        [WXApi sendReq:req];
    } else {
        [Notify showAlertDialog:self messageString:@"您还未安装微信客户端！"];
    }
}

#pragma mark 邮件分享
- (void)shareAppleMail:(NSString*)content{
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [self displayMailComposerSheet:content];
        } else {
            [Notify showAlertDialog:self messageString:@"设备不支持邮件功能或者邮件未配置"];
        }
    }
}

- (void)displayMailComposerSheet:(NSString*)content{
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    NSString *bodyMess=content;
    [controller setSubject:@""];
    [controller setMessageBody:bodyMess isHTML:NO];

    UIViewController *rootVC = [self rootViewController];
    [rootVC presentViewController:controller animated:YES completion:nil];
}
#pragma mark 邮件分享回调
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            [Notify showAlertDialog:self messageString:@"用户取消发送"];
            break;
        case MFMailComposeResultSaved:
            [Notify showAlertDialog:self messageString:@"已保存"];
            break;
        case MFMailComposeResultSent:
            [Notify showAlertDialog:self messageString:@"已发送"];
            break;
        case MFMailComposeResultFailed:
            [Notify showAlertDialog:self messageString:@"发送失败"];
            break;
        default:
            break;
    }
    
    UIViewController *rootVC = [self rootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark 短信分享

- (void)shareAppleSMS:(NSString*)content{
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet:content];
        } else {
            [Notify showAlertDialog:self messageString:@"设备不支持短信功能"];
        }
    }
}

- (void)displaySMSComposerSheet:(NSString*)content{
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *smsBody = content;
    picker.body = smsBody;
    
    UIViewController *rootVC = [self rootViewController];
    [rootVC presentViewController:picker animated:YES completion:nil];
}

#pragma mark 短信分享回调
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            [Notify showAlertDialog:self messageString:@"用户取消发送"];
            break;
        case MessageComposeResultSent:
            [Notify showAlertDialog:self messageString:@"已发送"];
            break;
        case MessageComposeResultFailed:
            [Notify showAlertDialog:self messageString:@"发送失败"];
            break;
        default:
            break;
    }
    
    UIViewController *rootVC = [self rootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 点击事件代理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch.view isEqual:self]) {
        [self dismissAnimation];
    }
}

- (void)dismissAnimation {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.shareItemBG.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width,0);
                         self.shareItemBG.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview];
                         }
                     }];
}

@end
