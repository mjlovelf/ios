//
//  MyScollview.m
//  DesignDemo
//
//  Created by mjbest on 2017/8/3.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "MyScollview.h"

@implementation MyScollview

//描述了有多大范围的内容需要使用scrollView的窗口来显示，其默认值为CGSizeZero，也就是一个宽和高都是0的范围
//contentSize



//contentOffset: 描述了内容视图相对于scrollView窗口的位置(当然是向上向左的偏移量咯)。默认值是CGPointZero，也就是(0,0)。当视图被拖动时，系统会不断修改该值。也可以通过setContentOffset:animated:方法让图片到达某个指定的位置。

//scrollRectToVisible:animated:与setContentOffset:animated:类似，只不过是将scrollView坐标系内的一块指定区域移到scrollView的窗口中，如果这部分已经存在于窗口中，则什么也不做。

//contentInset: 表示scrollView的内边距，也就是内容视图边缘和scrollView的边缘的留空距离，默认值是UIEdgeInsetsZero，也就是没间距。这个属性用的不多，通常在需要刷新内容时才用得到。

//bounces：描述的当scrollview的显示超过内容区域的边缘以及返回时，是否有弹性，默认值为YES。值为YES的时候，意味着到达contentSize所描绘的的边界的时候，拖动会产生弹性。值为No的时候，拖动到达边界时，会立即停止。所以，如果在上面的例子当中，将bounces设置为NO时，窗口中是不会显示contentSize范围外的内容的。

//alwaysBounceHorizontal：默认值为NO，如果该值设为YES，并且bounces也设置为YES，那么，即使设置的contentSize比scrollView的size小，那么也是可以拖动的。

//alwaysBounceVertical：默认值为NO，如果该值设为YES，并且bounces也设置为YES，那么，即使设置的contentSize比scrollView的size小，那么也是可以拖动的。

//indicatorStyle: 状态条的风格，默认值为UIScrollViewIndicatorStyleDefault。除此之外，还有UIScrollViewIndicatorStyleBlack, UIScrollViewIndicatorStyleWhite两种其他风格。可以用来和环境配色。
//showsHorizontalScrollIndicator : 当处于跟踪状态(tracking)时是否显示水平状态条，默认值为YES。下一节说明什么是跟踪状态。
//showsVerticalScrollIndicator : 当处于跟踪状态(tracking)时是否显示垂直状态条，默认值为YES。
//scrollIndicatorInsets : 状态条和scrollView边距的距离（暂时还没想明白为什么要有这个）。
//flashScrollIndicators: 短暂的显示一下状态条，当你将scrollView调整到最上面时，需要调用一下该方法。
@end
