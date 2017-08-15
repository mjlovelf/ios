//
//  AnimationPageRelatedController.m
//  DesignDemo
//
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "AnimationPageRelatedController.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "ZXLuminanceSource.h"
#import "ZXCGImageLuminanceSource.h"
#import "ZXBinaryBitmap.h"
#import "ZXHybridBinarizer.h"
#import "ZXDecodeHints.h"
#import "ZXMultiFormatReader.h"
#import "ZXResult.h"

static  NSString * kBbeginAnimationID = @"beginAnimationID";

@interface AnimationPageRelatedController ()
@property (weak, nonatomic) IBOutlet UIView *viewAnimation;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AnimationPageRelatedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [Utils setNavBarBgUI:self.navigationController.navigationBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)AnimationButtonClick:(id)sender {

    //[self  AnimationWithUIView];
    NSString *data = @"http://www.jianshu.com/users/b8b48d8bdb6b/latest_articles";
    if (data == 0)
        return;
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:data
                                  format:kBarcodeFormatQRCode
                                   width:self.imageView.frame.size.width
                                  height:self.imageView.frame.size.width error:nil];
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        _imageView.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        _imageView.image = nil;
    }
    CGImageRef imageToDecode;  // Given a CGImage in which we are looking for barcodes

    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage: _imageView.image.CGImage];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];

    NSError *error = nil;

    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];

    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *kresult = [reader decode:bitmap
                                 hints:hints
                                 error:&error];
    if (kresult) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = kresult.text;

        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = kresult.barcodeFormat;
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
    }
}

/**
 + (void)setAnimationDidStopSelector:(nullable SEL)selector;                  // default = NULL. -animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
 + (void)setAnimationDuration:(NSTimeInterval)duration;              // default = 0.2
 + (void)setAnimationDelay:(NSTimeInterval)delay;                    // default = 0.0
 + (void)setAnimationStartDate:(NSDate *)startDate;                  // default = now ([NSDate date])
 + (void)setAnimationCurve:(UIViewAnimationCurve)curve;              // default = UIViewAnimationCurveEaseInOut
 + (void)setAnimationRepeatCount:(float)repeatCount;                 // default = 0.0.  May be fractional
 + (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses;    // default = NO. used if repeat count is non-zero
 + (void)setAnimationBeginsFromCurrentState:(BOOL)fromCurrentState;  // default = NO. If YES, the current view position is always used for new animations -- allowing animations to "pile up" on each other. Otherwise, the last end state is used for the animation (the default).

 + (void)setAnimationTransition:(UIViewAnimationTransition)transition forView:(UIView *)view cache:(BOOL)cache;  // current limitation - only one per begin/commit block

 + (void)setAnimationsEnabled:(BOOL)enabled;                         // ignore any attribute changes while set.
 */
- (void)AnimationWithUIView{
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/4);
    _viewAnimation.transform = transform;
    [UIView beginAnimations:kBbeginAnimationID context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(startViewAnimation)];
    [UIView setAnimationDidStopSelector:@selector(stopViewAnimation)];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelay:0];
    [UIView setAnimationStartDate:[NSDate date]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_viewAnimation cache:YES];
    //  [UIView setAnimationRepeatAutoreverses:YES];//如果设置为YES,代表动画每次重复执行的效果会跟上一次相反
    //    [UIView commitAnimations];
}

- (void)startViewAnimation{

    NSLog(@"Animation start");

}

- (void)stopViewAnimation{

    NSLog(@"Animation stop");
}
@end
