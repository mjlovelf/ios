Objective-C 的 Runtime 为我们提供了很多运行时状态下跟类与对象相关的函数，比如：

const char *class_getName(Class cls)，获取指定类的类名。
BOOL class_isMetaClass(Class cls)，判断指定类是否是一个元类。
Class class_getSuperclass(Class cls)，获取指定类的父类。
Class class_setSuperclass(Class cls, Class newSuper)，设定指定类的父类。
int class_getVersion(Class cls)，获取指定类的版本信息。
void class_setVersion(Class cls, int version)，设定指定类的版本信息。
size_t class_getInstanceSize(Class cls)，获取实例大小。
Ivar class_getInstanceVariable(Class cls, const char *name)，获取指定名字的实例变量。
Ivar class_getClassVariable(Class cls, const char *name)，获取指定名字的类变量。
Ivar *class_copyIvarList(Class cls, unsigned int *outCount)，获取类的成员变量列表的拷贝。调用后需要自己 free()。
Method class_getInstanceMethod(Class cls, SEL name)，获取指定名字的实例方法。
Method class_getClassMethod(Class cls, SEL name)，获取指定名字的类方法。
IMP class_getMethodImplementation(Class cls, SEL name)，获取指定名字的方法实现。
BOOL class_respondsToSelector(Class cls, SEL sel)，类是否响应指定的方法。
Method *class_copyMethodList(Class cls, unsigned int *outCount)，获取方法列表的拷贝。调用后需要自己 free()。
BOOL class_conformsToProtocol(Class cls, Protocol *protocol)，类是否遵循指定的协议。
Protocol * __unsafe_unretained *class_copyProtocolList(Class cls, unsigned int *outCount)，获取协议列表的拷贝。调用后需要自己 free()。
objc_property_t class_getProperty(Class cls, const char *name)，获取指定名字的属性。
objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)，获取类的属性列表。调用后需要自己 free()。
BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)，为类添加方法。
IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types)，替代类的方法。
BOOL class_addIvar(Class cls, const char *name, size_t size, uint8_t alignment, const char *types)，给指定的类添加成员变量。这个函数只能在 objc_allocateClassPair() 和 objc_registerClassPair() 之间调用，并且不能为一个已经存在的类添加成员变量。
BOOL class_addProtocol(Class cls, Protocol *protocol)，为类添加协议。
BOOL class_addProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount)，为类添加属性。
void class_replaceProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount)，替代类的属性。
id class_createInstance(Class cls, size_t extraBytes)，创建指定类的实例。
id objc_constructInstance(Class cls, void *bytes)，在指定的位置创建类的实例。
void *objc_destructInstance(id obj)，销毁实例。
Class objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes)，创建类和元类。
void objc_registerClassPair(Class cls)，注册类到 Runtime。
void objc_disposeClassPair(Class cls)，销毁类和对应的元类
