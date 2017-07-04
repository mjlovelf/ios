//
//  ObserverViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/7/4.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "ObserverViewController.h"

static void *ObservationContext = &ObservationContext;


@interface ObserverViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstLineTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondLineTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdLineTextField;
@property (weak, nonatomic) IBOutlet UITextField *forthLineTextField;
@property (weak, nonatomic) IBOutlet UITextField *fiveLineTextField;

@end

@implementation ObserverViewController
- (void)dealloc{
    @try {
        [_secondLineTextField removeObserver:self forKeyPath:@"text" context:ObservationContext];
    } @catch (NSException *exception) {

    } @finally {
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.title = @"Observer使用";
    [self addObserverToTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addObserverToTextField{
//通过在object中添加对应textfield，实现只对其进行监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverMessageWithObserver:) name:UITextFieldTextDidChangeNotification object:_firstLineTextField];
    //通过keypath方式实现监听
    [_secondLineTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:ObservationContext];
}
- (void)receiverMessageWithObserver:(NSNotification *) notification{

    NSLog(@"god is good man=%@",[notification.object text]);
    _secondLineTextField.text = [notification.object text];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == ObservationContext) {
        _thirdLineTextField.text = [object text];
    }
}

/*
 #pragma mark - Navigationffddd

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - textfield delegate

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField{


}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField{

}

// if implemented, called in place of textFieldDidEndEditing:
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){


}
// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return YES;
}

// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField{

    return YES;
}
// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
    
}

@end
