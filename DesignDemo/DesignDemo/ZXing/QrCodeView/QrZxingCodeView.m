//
//  QrZxingCodeView.h
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "QrZxingCodeView.h"
#import "UIDevice+MJAuthorizationStatus.h"

static const float kNavHeight=44.0;
static const float kStatusHeight=20.0;

@interface QrZxingCodeView()

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (assign, nonatomic) AVCaptureTorchMode torchMode;

@property (nonatomic, assign) CGRect cropRect; // 提示框
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIButton* torchButton;
@property (nonatomic, strong) UIView *topBack;
@property (nonatomic, strong) UIView *leftBack;
@property (nonatomic, strong) UIView *rightBack;
@property (nonatomic, strong) UIView *bottomBack;
@property (nonatomic, strong) UIButton *lightButton;

@end

@implementation QrZxingCodeView
@synthesize scanCodeSucess;
@synthesize scanCodeFailure;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)rect view:(UIView *)view
{
    self = [super init];

    if (self) {

        self.view = view;
        [self initZbarCodeView];

        //进入后台扫描动画会被系统stop，所以进入前台的时候重新开始扫描动画
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startScanLine)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];

    }

    return self;
}

- (void)initZbarCodeView
{
    if (!self.contentView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;

        self.cropRect = CGRectMake(screenSize.width*0.15,
                                   screenSize.height/2.0 - kStatusHeight - kNavHeight - screenSize.width*0.35 - 50,
                                   screenSize.width*0.7,
                                   screenSize.width*0.7);
        [self initContentView];
        [self initTopBack];
        [self initLeftBack];
        [self initRightBack];
        [self initBottomBack];
        [self initTips];
        [self initLight];
        self.torchButton = _lightButton;
        [self initFourCorners];
        [self initBarCodeScanLine];
    }
}

- (void)initContentView
{
    WEAK_SELF_OBJ(self);

    // contentView
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

- (void)initReaderView
{
    [self.contentView.layer insertSublayer:self.preview atIndex:0];
    [self configureDevice:self.input.device];
}

- (void)initTopBack
{
    WEAK_SELF_OBJ(self);
    // topback
    self.topBack = [[UIView alloc] init];
    self.topBack.backgroundColor = [UIColor blackColor];
    self.topBack.alpha = 0.5;
    [self.contentView addSubview:self.topBack];

    [self.topBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@(weakSelf.cropRect.origin.y));
    }];
}

- (void)initLeftBack
{
    WEAK_SELF_OBJ(self);
    // leftback
    self.leftBack = [[UIView alloc] init];
    self.leftBack.backgroundColor = [UIColor blackColor];
    self.leftBack.alpha = 0.5;
    [self.contentView addSubview:self.leftBack];

    [self.leftBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.topBack.mas_bottom);
        make.width.mas_equalTo(@(weakSelf.cropRect.origin.x));
    }];
}

- (void)initRightBack
{
    WEAK_SELF_OBJ(self);
    // rightback
    self.rightBack = [[UIView alloc] init];
    self.rightBack.backgroundColor = [UIColor blackColor];
    self.rightBack.alpha = 0.5;
    [self.contentView addSubview:self.rightBack];

    [self.rightBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.topBack.mas_bottom);
        make.left.equalTo(weakSelf.contentView).with.offset(weakSelf.cropRect.origin.x + weakSelf.cropRect.size.width);
    }];
}

- (void)initBottomBack
{
    WEAK_SELF_OBJ(self);
    // bottomback
    self.bottomBack = [[UIView alloc] init];
    self.bottomBack.backgroundColor = [UIColor blackColor];
    self.bottomBack.alpha = 0.5;
    [self.contentView addSubview:self.bottomBack];

    [self.bottomBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).with.offset(weakSelf.cropRect.origin.y + weakSelf.cropRect.size.height);
        make.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.leftBack.mas_right);
        make.right.equalTo(weakSelf.rightBack.mas_left);
    }];
}

- (void)initTips
{
    WEAK_SELF_OBJ(self);
    // tips label
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsLabel.text = @"将二维码/条码放入框内，即可自动扫描";
    [self.contentView addSubview:tipsLabel];

    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomBack).with.offset(10);
        make.centerX.equalTo(weakSelf.contentView);
    }];
}

- (void)initLight
{
    WEAK_SELF_OBJ(self);
    // light
    self.lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lightButton setImage:[UIImage imageNamed:@"icon_light_off"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.lightButton];

    [self.lightButton addTarget:self action:@selector(changeTorchStatus:) forControlEvents:UIControlEventTouchUpInside];

    [self.lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.bottomBack);
    }];
}

- (void)initFourCorners
{
    WEAK_SELF_OBJ(self);
    // edge
    UIImage *tmpImage = [UIImage imageNamed:@"fourCorners"];
    tmpImage = [tmpImage resizableImageWithCapInsets:UIEdgeInsetsMake(tmpImage.size.height*0.5,
                                                                      tmpImage.size.width*0.5,
                                                                      tmpImage.size.height*0.5,
                                                                      tmpImage.size.width*0.5)
                                        resizingMode:UIImageResizingModeStretch];

    UIImageView *edgeImageView = [[UIImageView alloc] initWithImage:tmpImage];
    [self.contentView addSubview:edgeImageView];

    [edgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topBack.mas_bottom).with.offset(-4);
        make.left.equalTo(weakSelf.leftBack.mas_right).with.offset(-4);
        make.right.equalTo(weakSelf.rightBack.mas_left).with.offset(4);
        make.bottom.equalTo(weakSelf.bottomBack.mas_top).with.offset(4);
    }];
}

- (void)initBarCodeScanLine
{
    // line
    self.line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCodeScanLine"]];
    self.line.frame = CGRectMake(self.cropRect.origin.x,
                                 self.cropRect.origin.y + 10,
                                 self.cropRect.size.width,
                                 2);
    [self.contentView addSubview:self.line];
}

- (void)startScanLine
{
    // start animation
    [self.line.layer removeAnimationForKey:@"translateAnimation"];
    self.line.layer.anchorPoint = CGPointMake(0.5, 0.5);

    CABasicAnimation* translateAnimation;
    translateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translateAnimation.fromValue = @(0);
    translateAnimation.toValue = @(self.cropRect.size.height - 20);
    translateAnimation.duration = 2.0;
    translateAnimation.repeatCount = INFINITY;
    [self.line.layer addAnimation:translateAnimation forKey:@"translateAnimation"];

    // set torch
    [self changeTorchMode:self.torchMode];
}

- (UIView *)getBarCodeView
{
    return nil;
}

- (void)startScan
{
    [self initZbarCodeView];

    // start animation
    [self startScanLine];

    if ([self requestAccessForCamera])
    {
#if TARGET_OS_SIMULATOR
#else
        [self initReaderView];
        // start scan
        [self.session startRunning];
#endif
    }else{
        [self showCameraAlert];
        [self scanFailedAndNotPopViewController];
    }

}
- (void)stopScan
{
    if ([self requestAccessForCamera]) {
#if TARGET_OS_SIMULATOR
#else
        [self.session stopRunning];
        self.torchMode = AVCaptureTorchModeOff;
        [self changeTorchMode:self.torchMode];
        [self changeTorchButtonImage];
#endif
    }
}

- (void)changeTorchStatus:(id)sender
{
    self.torchMode = self.torchMode == AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    [self changeTorchMode:self.torchMode];
    [self changeTorchButtonImage];
}

//改变手电筒按钮的状态
- (void)changeTorchButtonImage
{
    UIImage *image = [UIImage imageNamed:self.torchMode == AVCaptureTorchModeOn ? @"icon_light_on" : @"icon_light_off"];
    [self.torchButton setImage:image forState:UIControlStateNormal];
}

- (BOOL)requestAccessForCamera
{
    if (![[UIDevice currentDevice] isCameraAuthorization]) {

        return NO;
    };

    return YES;
}

- (void)showCameraAlert
{
    //直接跳转

    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }

}
- (void) scanFailedAndNotPopViewController{

    if (self.scanCodeFailure)
    {
        self.scanCodeFailure(nil,ScanBarCodeStatus_Failure,NO);
    }
}

#pragma mark - setup capture
- (void)configureDevice:(AVCaptureDevice *)device {
    if ([device lockForConfiguration:nil] == YES ) {
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [device setFocusPointOfInterest:CGPointMake(0.5, 0.5)];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }

        if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [device setExposurePointOfInterest:CGPointMake(0.5f, 0.5f)];
            [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }

        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        [device unlockForConfiguration];
    }
}

- (AVCaptureDevice *)device {
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input {
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device
                                                       error:nil];
    }
    return _input;
}

- (AVCaptureMetadataOutput *)output {
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        _output.rectOfInterest = CGRectMake(self.cropRect.origin.y/screenHeight,
                                            self.cropRect.origin.x/screenWidth,
                                            self.cropRect.size.height/screenHeight,
                                            self.cropRect.size.width/screenWidth);
    }
    return _output;
}

- (AVCaptureSession *)session {
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];

        if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            _session.sessionPreset = AVCaptureSessionPresetHigh;
        }

        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }

        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }

        self.output.metadataObjectTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code,
                                            AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode,
                                            AVMetadataObjectTypeAztecCode];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)preview {
    if (_preview == nil) {
        _preview =[ AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill ;
        _preview.frame = self.view.layer.bounds ;
    }
    return _preview;
}

- (void)changeTorchMode:(AVCaptureTorchMode)mode {
    if ([self.device lockForConfiguration:nil]) {
        if([self.device isTorchModeSupported:mode]) {
            self.device.torchMode = mode;
        }
        [self.device unlockForConfiguration];
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *metadata in metadataObjects) {
        NSString *code = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
        if (code.length != 0) {
            if (self.scanCodeSucess)
            {
                self.scanCodeSucess(code,ScanBarCodeStatus_Sucess);
            }
            
            break;
        }
    }
}


@end
