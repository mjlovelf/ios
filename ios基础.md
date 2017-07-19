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
                
8.SDWebImage内部实现过程

                1.入口 setImageWithURL:placeholderImage:options: 
                会先把 placeholderImage 显示，然后 SDWebImageManager 根据 URL 开始处理图片。

               2 .进入 SDWebImageManager-downloadWithURL:delegate:options:
               userInfo:，交给 SDImageCache 从缓存查找图片是否已经下载 queryDiskCacheForKey:delegate:userInfo:.

                3.先从内存图片缓存查找是否有图片，如果内存中已经有图片缓存，
                SDImageCacheDelegate 回调 imageCache:didFindImage:forKey:userInfo: 到 SDWebImageManager。

                4.SDWebImageManagerDelegate 回调 webImageManager:didFinishWithImage: 到 UIImageView+WebCache 等前端展示图片。

                5.如果内存缓存中没有，生成 NSInvocationOperation 添加到队列开始从硬盘查找图片是否已经缓存。

                6.根据 URLKey 在硬盘缓存目录下尝试读取图片文件
                。这一步是在 NSOperation 进行的操作，所以回主线程进行结果回调 notifyDelegate:。

                7.如果上一操作从硬盘读取到了图片，将图片添加到内存缓存中（如果空闲内存过小，会先清空内存缓存）。
                SDImageCacheDelegate 回调 imageCache:didFindImage:forKey:userInfo:。进而回调展示图片。

                8.如果从硬盘缓存目录读取不到图片，说明所有缓存都不存在该图片，需要下载图片，
                回调 imageCache:didNotFindImageForKey:userInfo:。

                9.共享或重新生成一个下载器 SDWebImageDownloader 开始下载图片。

                10.图片下载由 NSURLConnection 来做，实现相关 delegate 来判断图片下载中、下载完成和下载失败。

                connection:didReceiveData: 中利用 ImageIO 做了按图片下载进度加载效果。

                connectionDidFinishLoading: 数据下载完成后交给 SDWebImageDecoder 做图片解码处理。

               11. 图片解码处理在一个 NSOperationQueue 完成，不会拖慢主线程 UI。
                如果有需要对下载的图片进行二次处理，最好也在这里完成，效率会好很多。

                12在主线程 notifyDelegateOnMainThreadWithInfo: 宣告解码完成，
                imageDecoder:didFinishDecodingImage:userInfo: 回调给 SDWebImageDownloader。

                13.imageDownloader:didFinishWithImage: 回调给 SDWebImageManager 告知图片下载完成。

                14.通知所有的 downloadDelegates 下载完成，回调给需要的地方展示图片。

                15.将图片保存到 SDImageCache 中，内存缓存和硬盘缓存同时保存。
                写文件到硬盘也在以单独 NSInvocationOperation 完成，避免拖慢主线程。

                16.SDImageCache 在初始化的时候会注册一些消息通知，
                在内存警告或退到后台的时候清理内存图片缓存，应用结束的时候清理过期图片。

                SDWI 也提供了 UIButton+WebCache 和 MKAnnotationView+WebCache，方便使用。
                SDWebImagePrefetcher 可以预先下载图片，方便后续使用。
                17.从上面流程可以看出，当你调用setImageWithURL:
                方法的时候，他会自动去给你干这么多事，当你需要在某一具体时刻做事情的时候，
                你可以覆盖这些方法。比如在下载某个图片的过程中要响应一个事件，就覆盖这个方法：

                //覆盖方法，指哪打哪，这个方法是下载imagePath2的时候响应
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];

                    [manager downloadImageWithURL:imagePath2 options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                        NSLog(@"显示当前进度");

                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

                        NSLog(@"下载完成");
                    }];
                对于初级来说，用sd_setImageWithURL:的若干个方法就可以实现很好的图片缓存。

