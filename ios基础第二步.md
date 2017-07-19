
1、64位操作系统，64位编译器 sizeof(int) sizeof(char)  sizeof(int *) sizeof(char *) 分别是多少

        int 和 char类型的变量所占内存和操作系统位数无关，所以sizeOf(int) = 4,sizeOf(char) = 1,
        int *和char*表示两个变量的指针，sizeOf(指针)就是一个指针的长度，
        一般来讲指针的长度和cpu的寻址位数有关，一般CPU的寻址位数等于操作系统位数，
        所以64位，没个字节8位，所以就是8个字节，所以sizeOf(指针) ＝ 8.


2、64位操作系统，一个结构 struct aStruct{int a; char b; int c; char d}; 
此时 sizeof(struct aStruct) 是多少？ 
如果是 struct aStruct{int a; char b; char d; int c}；
此时 sizeof(struct aStruct) 是多少？为啥？

      首先，不管多少位的操作系统，一个int变量永远只占4个字节，一个char变量永远只占1个字节
      第一个：4+4+4+4 = 16
      第二个：4+4+4 ＝ 12
