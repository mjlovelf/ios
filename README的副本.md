一.代理通知区别：
        NotificationCenter 
         通知中心：“一对多”，在APP中，很多控制器都需要知道一个事件，应该用通知 

        delegate 代理委托
          1，“一对一”，对同一个协议，一个对象只能设置一个代理delegate，所以单例对象就不能用代理；
          2，代理更注重过程信息的传输：比如发起一个网络请求，可能想要知道此时请求是否已经开始、是否收到了数据、数据是否已经接受完成、数据接收失败
        
        block(闭包)
        block和delegate一样，一般都是“一对一”之间通信交互，相比代理block有以下特点
           1：写法更简练，不需要写protocol、函数等等
           2，block注重结果的传输：比如对于一个事件，只想知道成功或者失败，并不需要知道进行了多少或者额外的一些信息
           3，block需要注意防止循环引用

代理实现发送通知：
-(void)didclickButton{
    //1、执行必选代理回调
    if([self.delegate respondsToSelector:@selector(getCarModel:)]){
        [self.delegate getCarModel:self];
    }
    //2、执行可选代理回调
    if([self.delegate respondsToSelector:@selector(getCarOtherModel:)]){
        [self.delegate getCarOtherModel:self];
    }
}

代理中使用weak，strong，assign
对于weak:指明该对象并不负责保持delegate这个对象，delegate这个对象的销毁由外部控制。

对于strong：该对象强引用delegate，外界不能销毁delegate对象，会导致循环引用(Retain Cycles)

对于assign：也有weak的功效。但是网上有assign是指针赋值，不对引用计数操作，使用之后如果没有置为nil，可能就会产生野指针；而weak一旦不进行使用后，永远不会使用了，就不会产生野指针


关联属性可以使用kvo。关联属性其实就相当于分类增加一个属性那么如果是

要子视图超出父试图部分上面的控件可以响应事件，我们只需要重写上述方法就ok了：

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    
    return view;
}
