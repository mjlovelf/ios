/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <AudioToolbox/AudioToolbox.h>
#import <ZXingObjC/ZXingObjC.h>
#import "ZXingQRController.h"

@interface ZXingQRController ()<ZXCaptureDelegate>


@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong)  UIView *scanRectView;
@property (nonatomic, strong)  UILabel *decodedLabel;

@end

@implementation ZXingQRController {
    CGAffineTransform _captureSizeTransform;
}

#pragma mark - View Controller Methods
- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    [self.capture.layer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.autoresizingMask = 0xFF;

    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;

    [self.view.layer addSublayer:self.capture.layer];

    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
}

- (UIView *)scanRectView{
    if (_scanRectView == nil) {
        _scanRectView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    }
    return _scanRectView;
}

- (UILabel *)decodedLabel{
    if (_decodedLabel == nil) {
        _decodedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    }
    return _decodedLabel;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.capture.delegate = self;

    [self applyOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self applyOrientation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self applyOrientation];
     }];
}

#pragma mark - Private
- (void)applyOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;

    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    [self applyRectOfInterest:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    [self.capture setTransform:transform];
    [self.capture setRotation:scanRectRotation];

    //    self.capture.layer.frame = CGRectMake(0, 0, 1000, 1000);
    self.capture.layer.frame = self.view.frame;

    [self.capture start];

}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = self.scanRectView.frame;
    //    if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
    //        videoSizeX = 1080;
    //        videoSizeY = 1920;
    //    } else {
    //        videoSizeX = 720;
    //        videoSizeY = 1280;
    //    }
    videoSizeY = CGRectGetHeight(self.view.frame);
    videoSizeX = CGRectGetWidth(self.view.frame);


    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
        }
    } else {
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
        }
    }
    _captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";

        case kBarcodeFormatCodabar:
            return @"CODABAR";

        case kBarcodeFormatCode39:
            return @"Code 39";

        case kBarcodeFormatCode93:
            return @"Code 93";

        case kBarcodeFormatCode128:
            return @"Code 128";

        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";

        case kBarcodeFormatEan8:
            return @"EAN-8";

        case kBarcodeFormatEan13:
            return @"EAN-13";

        case kBarcodeFormatITF:
            return @"ITF";

        case kBarcodeFormatPDF417:
            return @"PDF417";

        case kBarcodeFormatQRCode:
            return @"QR Code";

        case kBarcodeFormatRSS14:
            return @"RSS 14";

        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";

        case kBarcodeFormatUPCA:
            return @"UPCA";

        case kBarcodeFormatUPCE:
            return @"UPCE";

        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";

        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;

    CGAffineTransform inverse = CGAffineTransformInvert(_captureSizeTransform);
    NSMutableArray *points = [[NSMutableArray alloc] init];
    NSString *location = @"";
    for (ZXResultPoint *resultPoint in result.resultPoints) {
        CGPoint cgPoint = CGPointMake(resultPoint.x, resultPoint.y);
        CGPoint transformedPoint = CGPointApplyAffineTransform(cgPoint, inverse);
        transformedPoint = [self.scanRectView convertPoint:transformedPoint toView:self.scanRectView.window];
        NSValue* windowPointValue = [NSValue valueWithCGPoint:transformedPoint];
        location = [NSString stringWithFormat:@"%@ (%f, %f)", location, transformedPoint.x, transformedPoint.y];
        [points addObject:windowPointValue];
    }


    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@\nLocation: %@", formatString, result.text, location];
    [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];

    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    [self.capture stop];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.capture start];
    });
}

@end
