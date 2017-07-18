1.代理通知区别：
        NotificationCenter 通知中心：“一对多”，在APP中，很多控制器都需要知道一个事件，应该用通知 
        
      delegate 代理委托
          1，“一对一”，对同一个协议，一个对象只能设置一个代理delegate，所以单例对象就不能用代理；
          2，代理更注重过程信息的传输：比如发起一个网络请求，可能想要知道此时请求是否
          已经开始、是否收到了数据、数据是否已经接受完成、数据接收失败
          
      block(闭包)
         block和delegate一样，一般都是“一对一”之间通信交互，相比代理block有以下特点
         1：写法更简练，不需要写protocol、函数等等
         2，block注重结果的传输：比如对于一个事件，只想知道成功或者失败，并不需
            要知道进行了多少或者额外的一些信息
         3，block需要注意防止循环引用
         
2.代理实现发送通知：

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

3.代理中使用weak，strong，assign

        对于weak:指明该对象并不负责保持delegate这个对象，delegate这个对象的销毁由外部控制。

        对于strong：该对象强引用delegate，外界不能销毁delegate对象，会导致循环引用(Retain Cycles)

        对于assign：也有weak的功效。但是网上有assign是指针赋值，
        不对引用计数操作，使用之后如果没有置为nil，可能就会产生野指针；而weak一旦不进行使用后
        ，永远不会使用了，就不会产生野指针

4.关联属性可以使用kvo。关联属性其实就相当于分类增加一个属性那么如果是

5.要子视图超出父试图部分上面的控件可以响应事件，我们只需要重写上述方法就ok了：

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
6.书写个dispatch_once:对于某个任务执行一次，且只执行一次。
     dispatch_once函数有两个参数，第一个参数predicate用来保证执行一次，
     第二个参数是要执行一次的任务block
     dispatch_once被广泛使用在单例、缓存等代码中，用以保证在初始化时执行一次某任务。
     dispatch_once在单线程程序中毫无意义，但在多线程程序中，其低负载、高可依赖性
     、接口简单等特性，赢得了广大消费者的一致五星好评。

        + (instancetype)defaultInstance {
            static AFImageDownloader *sharedInstance = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sharedInstance = [[self alloc] init];
            });
            return sharedInstance;
        }
        
 7.Objective C类方法load和initialize的区别
 
            这两个方法是在程序运行一开始就被调用的方法，我们可以利用他们在类被使用前，做一些预处理工作
            load是只要类所在文件被引用就会被调用，而initialize是在类或者其子类的第一个方法被调用前调用。
            所以如果类没有被引用进项目，就不会有load调用；
            但即使类文件被引用进来，但是没有使用，那么initialize也不会被调用。
            
            相同点在于：方法只会被调用一次。
            
        //只要程序启动就会将所有类的代码加载到内存中, 放到代码区(无论该类有没有被使用到都会被调用)  、
        // load方法会在当前类被加载到内存的时候调用, 有且仅会调用一次 
        // 如果存在继承关系, 会先调用父类的load方法, 再调用子类的load方法  
        + (void)load  
        {  
            NSLog(@"类被加载到内存了");  
        }  

        // 当当前类第一次被使用的时候就会调用(创建类对象的时候)  
        // initialize方法在整个程序的运行过程中只会被调用一次, 无论你使用多少次这个类都只会调用一次  
        // initialize用于对某一个类进行一次性的初始化  
        // initialize和load一样, 如果存在继承关系, 会先调用父类的initialize再调用子类的initialize  
        + (void)initialize  
        {  
            NSLog(@" initialize");  
        }  
