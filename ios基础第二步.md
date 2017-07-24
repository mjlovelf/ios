
1、64位操作系统，64位编译器 sizeof(int) sizeof(char)  sizeof(int *) sizeof(char *) 分别是多少

        int 和 char类型的变量所占内存和操作系统位数无关，所以sizeOf(int) = 4,sizeOf(char) = 1,
        int *和char*表示两个变量的指针，sizeOf(指针)就是一个指针的长度，
        一般来讲指针的长度和cpu的寻址位数有关，一般CPU的寻址位数等于操作系统位数，
        所以64位，没个字节8位，所以就是8个字节，所以sizeOf(指针) ＝ 8.


2、64位操作系统，一个结构 struct aStruct{int a; char b; int c; char d}; 
此时 sizeof(struct aStruct) 是多少？ 
如果是 struct aStruct{int a; char b; char d; int c}；
此时 sizeof(struct aStruct) 是多少？为啥？

              首先，不管多少位的操作系统，一个int变量永远只占4个字节，一个char变量永远只占1个字节,而
              结构体几部分会对齐。所以都变成4，这就会导致浪费，所以最好同类型用结构体
              第一个：4+4+4+4 = 16
              第二个：4+4+4+4 ＝ 16
      
3、全局并发队列和自定义并发队列的区别，如果现在有两种任务需要并发处理，其中一种是
：任务单位小，数量多 另一种是：任务单位大，数量少 分别应该使用哪种队列处理？为什么？
        
        全局并发队列是由系统创建和管理的，并且存在线程池，暂时不用的队列会丢进线程池中，一旦有需要就可以直接拿来用，
        省去了创建线程带来的资源开销，因此数量多的任务是用全局并发队列从性能方面来讲有一定的优势。
        这并不是说任务单位大，数量少的任务就不能使用全局并发队列，只能说这种情况下，
        自建队列会让自己清楚什么任务跑在哪个线程上，方便自己管理。
        
        
          同步和异步代表会不会开辟新的线程。串行和并发代表任务执行的方式。

        同步串行和同步并发，任务执行的方式是一样的。没有区别，因为没有开辟新的线程，所有的任务都是在一条线程里面执行。

        异步串行和异步并发，任务执行的方式是有区别的，异步串行会开辟一条新的线程，
        队列中所有任务按照添加的顺序一个一个执行，异步并发会开辟多条线程，至于具体开辟多少条线程
        ，是由系统决定的，但是所有的任务好像就是同时执行的一样。
        
        开辟队列的方法：

        dispatch_queue_t myQueue = dispatch_queue_create("MyQueue", NULL);

                /**

                    参数1：标签，用于区分队列

                    参数2：队列的类型，表示这个队列是串行队列还是并发队列NUll表示串行队列，

                DISPATCH_QUEUE_CONCURRENT表示并发队列

                    */

        执行队列的方法

               异步执行

        dispatch_async(<#dispatch_queue_t queue#>, <#^(void)block#>)

               同步执行

               dispatch_sync(<#dispatch_queue_t queue#>, <#^(void)block#>)

4.为了防止循环引用，我们都知道使用weak(self); 但是程序中偶尔会见到strong(self); 这种用法，请问：strong(self)的应用场景是什么？
        
                weakself是弱化的self，防止self被强引用。同理strong self就是强化的self，防止self被释放
                eg:block回调中如果有self中方法，则需要使用weak，否则循环了，而为了保证block中代码执行完成，比如异步耗时动作
                加上strong（可以理解为局部变量强引用所以不会有循环问题）则能保证代码的执行。比如dbmanager中performBlockAndWait也需要用到weak
                
 5.类方法和对象方法的区别何在？类方法的生存周期？ 相对与对象方法，哪类处理适合使用类方法？

         类方法和对象方法的区别：首先，他俩长得不一样，＋号和－号,对像方法存在于栈中，只能由对象来调用
         ，依赖于对像存在，类方法只能由类调用，属于存在于堆区的静态方法，不依赖于对像而存在。
         
        类方法的生存周期：类方法的生存周期？应该是程序跑起来了，类的+load方法被调用后，类方法开始存在了
        ，等程序挂了不再运行了，类不存在了，类方法也就不存在了
        
        适合使用类方法：无需访问类属性的方法适合使用类方法，还有就是用于初始化的类方法

6.kvo监听是否一定是在主线程完成的？如果不是，请举例说明

        KVO 行为是同步的，并且发生与所观察的值发生变化的同样的线程上。没有队列或者 Run-loop 的处理。
        手动或者自动调用 -didChange... 会触发 KVO 通知。
       
7、如何创建一个常驻线程？ 

        runloop
        
8.我们知道，多线程读写，只要有1个写，就有可能出现并发问题，解决方案可以用锁，
但我们又知道锁的效率不高，并且破坏程序结构，加锁的代码通常并不易理清逻辑，
那么，还有什么样的手段能实现这个目的？（考虑队列） 如何实现？

        dispatch_async并发读   － 读可以并发
        dispatch_barrier写   － 写只能串行

9.dispatch_group函数族的应用场景是什么？
假如现在让你使用信号量（dispatch_semaphore）来模拟类似的功能，如何实现？

        第一个问号：可以并行的操作，需要这些全部操作完成之后再进行其他操作，
        比如我进入一个页面，必须拿到两个接口的数据（并发）之后才能刷UI
        
             dispatch_queue_t dispatchQueue = dispatch_queue_create("com.mj.test", DISPATCH_QUEUE_CONCURRENT);
            dispatch_group_t dispatchGroup = dispatch_group_create();

            dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
                NSLog(@"第一个线程执行内容");
            });
            dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
                NSLog(@"第二个线程执行内容");
            });
            dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
                NSLog(@"这里执行页面跳转");
            });
