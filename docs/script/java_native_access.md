---
title: JAVA Native Access
since: 202503
---

## Invoke

```
jna.library.path
jna.boot.library.path
jna.platform.library.path

System.out.println("动态库so路径: " + soPath);
System.setProperty("jna.noclasspath", "true");
System.setProperty("jna.nounpack", "true");
System.setProperty("jna.library.path", soPath);
System.setProperty("jna.boot.library.path", soPath);
System.setProperty("jna.platform.library.path", soPath);

...
System.out.println("tmpdir java: " + System.getProperty("java.io.tmpdir"));
System.out.println("tmpdir jna : " + System.getProperty("jna.tmpdir"));
System.out.println("JNA Loaded: " + System.getProperty("jna.loaded"));
```

https://docs.gradle.org/current/userguide/cpp_library_plugin.html
```
gradle init

不支持交叉编译
https://github.com/gradle/gradle-native/issues/989

webx
可以尝试将 cpp-library, java-library 都发布到 maven
```


## Dynamic Library

https://www.baeldung.com/java-jna-dynamic-libraries

https://github.com/ly3too/java-jna-jni

```
cmake_minimum_required(VERSION 3.19)
project(h1)

set(CMAKE_CXX_STANDARD 14)

add_library(h1 SHARED library.cpp library.h)


------------ 构建 ------------
mkdir build && cd build
cmake ..
make
```

header
```
#ifndef H1_LIBRARY_H
#define H1_LIBRARY_H

#ifdef _WIN32
#define JNA_EXPORT __declspec(dllexport)
#else
#define JNA_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif
JNA_EXPORT int add(int a, int b);

#ifdef __cplusplus
}
#endif
#endif //H1_LIBRARY_H

```


```
被 extern "C" 修饰的变量和函数是按照 C 语言方式编译和链接的
__declspec(dllexport)用于Windows中的动态库中，声明导出函数、类、对象等供外面调用，省略给出.def文件。即将函数、类等声明为导出函数，供其它程序调用，作为动态库的对外接口函数、类等。

extern "C"
{
    __declspec(dllexport) int add(int a, int b);
}
```

## Dynamic Library (Rust)

https://gist.github.com/CoolOppo/67b452c125bb0db3212a9fbc44c84245
```
1. 创建lib项目，修改Cargo.toml
[lib]
crate-type = ["cdylib"]

2. 修改lib.rs
#[no_mangle]
pub extern fn add(a:i32, b:i32) -> i32 {
    a + b
}

3.构建
cargo build [--release]
cargo clean
```


## Example

https://www.baeldung.com/java-jna-dynamic-libraries

https://github.com/ly3too/java-jna-jni

https://www.eshayne.com/jnaex/index.html

```
 <dependency>
	<groupId>net.java.dev.jna</groupId>
	<artifactId>jna-platform</artifactId>
	<version>5.8.0</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.junit-pioneer/junit-pioneer -->
<dependency>
    <groupId>org.junit-pioneer</groupId>
    <artifactId>junit-pioneer</artifactId>
    <version>1.4.2</version>
    <scope>test</scope>
</dependency>
```

在接口中定义 methods 和 types，由 jna 创建实例，进行映射
```
-------------- LibC.java --------------
public interface LibC extends Library {
    LibC INSTANCE = (LibC)
            Native.load((Platform.isWindows() ? "msvcrt" : "c"),
                    LibC.class);

    void printf(String format, Object... args);
}

-------------- LibH.java --------------
public interface LibH extends Library {
    LibH INSTANCE = (LibH) Native.load("h1", LibH.class);

    int add(int a, int b);
}
```

测试调用
```
System.setProperty("jna.library.path", "C:\\jna");
System.setProperty("jna.debug_load", "true");
LibH.INSTANCE.add(1, 2)
```

junit测试
```
@SetSystemProperty(key = "jna.debug_load", value = "true")
//@SetSystemProperty(key = "jna.library.path", value = "C:\\jna")
public class AppTest {

    @Test
    @DisplayName("10+20=30")
    public void test() {
        Assertions.assertEquals(30, 10 + 20);
    }

    @Test
    @DisplayName("call cosh(0)=1.0")
    public void testLibC() {
        LibC lib = Native.load(Platform.isWindows() ? "msvcrt" : "c", LibC.class);
        Assertions.assertEquals(1.0, lib.cosh(0));
    }
}
```



### Java native方法

> https://github.com/astonbitecode/j4rs-java-call-rust


-Djna.nosys=true

https://github.com/java-native-access/jna/issues/384



### 加载顺序
```
 System.setProperty("jna.library.path", "C:\\jna");
 System.setProperty("jna.debug_load", "true");
 
 
 --- 首先加载jnidispatch
 com/sun/jna/win32-x86-64/jnidispatch.dll
 
 --- LibH测试：加载h1.dll
 寻找jna.library.path：h1.dll
 寻找system path：h1.dll
 寻找lib- prefix：libh1.dll
 寻找classpath：kbase-lib/target/classes/win32-x86-64/h1.dll
 
 --- LibC测试：加载msvcrt.dll
 寻找jna.library.path
 寻找system path: C:\Windows\System32\msvcrt.dll
```

### 总结

* jni 是 java 和 cpp 混合开发，需要编译，代码复杂
* jna 进行了解耦，代码简单
* jni 比 jna 效率高


JNA-so路径
```
jna.library.path
jna.boot.library.path
jna.platform.library.path
```

GUI框架：javafx

依赖管理工具：gradle

openjdk11 + kotlin + junit5



## Example (Kotlin)

https://www.hicode.club/articles/2020/01/19/1579404425222.html

https://discuss.kotlinlang.org/t/what-is-the-kotlin-equivalent-of-this-jna-code/13697/2

依赖
```
// https://mvnrepository.com/artifact/net.java.dev.jna/jna
implementation("net.java.dev.jna:jna:5.9.0")
// https://mvnrepository.com/artifact/org.junit-pioneer/junit-pioneer
testImplementation("org.junit-pioneer:junit-pioneer:1.4.2")
```

```kotlin
interface LibC : Library {
    fun cosh(value: Double): Double
}

object DyLib {
    val C by lazy {
        Native.load("c", LibC::class.java) as LibC
    }
}

interface LibC: Library {
    companion object {
        val INSTANCE by lazy { Native.load("c", LibC::class.java) }
    }
    // ...
}

// Native.load(if(Platform.isWindows()) "msvcrt" else "c", LibC::class.java) as LibC
```

声明 Struct
```kotlin
@Structure.FieldOrder("field1", "field2", "field3")
class FooType : Structure() {
    @JvmField var field1: Int = 0
    @JvmField var field2: Int = 0
    @JvmField var field3: String = ""
}

@Structure.FieldOrder("field1", "field2", "field3")
data class FooType(
    @JvmField var field1: Int=0,
    @JvmField var field2: Int=0,
    @JvmField var field3: String=""
) : Structure()
```

https://kotlinlang.org/docs/native-c-interop.html



## HFS实例

```
// https://mvnrepository.com/artifact/net.java.dev.jna/jna
implementation("net.java.dev.jna:jna:5.9.0")
// https://mvnrepository.com/artifact/org.junit-pioneer/junit-pioneer
testImplementation("org.junit-pioneer:junit-pioneer:1.4.2")
// https://mvnrepository.com/artifact/org.jetbrains.kotlin/kotlin-reflect
implementation("org.jetbrains.kotlin:kotlin-reflect:1.5.30")
```

结构体
```
class HFS_FILE_INFO: Structure() {
    @JvmField var tsDirName = ByteArray(MAX_FILE_ID)
    @JvmField var tsTableName = ByteArray(MAX_TABLE_LENGTH)
    @JvmField var tsFileName = ByteArray(MAX_FILE_ID)
    @JvmField var tsFileType = ByteArray(MAX_FILE_EXT)
    @JvmField var uiFileSize = 0L
    @JvmField var tsCreateDate = ByteArray(20)
    @JvmField var tsModifyDate = ByteArray(20)
    @JvmField var MD5 = ByteArray(33)
    @JvmField var btFlag = Byte.MAX_VALUE
    @JvmField var bIsDir = Byte.MAX_VALUE
    @JvmField var NodeID = 0
    @JvmField var ulPos = 0L
    @JvmField var ulSize = 0L
    @JvmField var tsVirtualName = ByteArray(MAX_FILE_ID + MAX_FILE_EXT)
    @JvmField var uiFileCount = 0L
    @JvmField var uiDirCount = 0L
    @JvmField var pData = ByteArray(NET_DATA_SIZE_T)

    companion object {
        const val MAX_FILE_PATH = 260
        const val MAX_FILE_ID = 255
        const val MAX_FILE_EXT = 32
        const val MAX_TABLE_LENGTH = 256
        const val NET_DATA_SIZE_T = 8
    }
}

---- 字段顺序1
@FieldOrder(
    "tsDirName", "tsTableName", "tsFileName", "tsFileType",
    "uiFileSize", "tsCreateDate", "tsModifyDate", "MD5",
    "btFlag", "bIsDir", "NodeID", "ulPos", "ulSize",
    "tsVirtualName", "uiFileCount", "uiDirCount", "pData",
)

---- 字段顺序2
override fun getFieldOrder(): MutableList<String> {
	val props = HFS_FILE_INFO::class.declaredMemberProperties.map { it.name }.toSet()
	return HFS_FILE_INFO::class.java.declaredFields.map { it.name }.filter { props.contains(it) }.toMutableList()
}
```

结构体2
```
----struct/Constants.kt
const val MAX_FILE_PATH = 260
const val MAX_FILE_ID = 255
const val MAX_FILE_EXT = 32
const val MAX_TABLE_LENGTH = 256
const val NET_DATA_SIZE_T = 8

----struct/HFS_FILE_INFO.kt
class HFS_FILE_INFO: Structure() {
    @JvmField var tsDirName = ByteArray(MAX_FILE_ID)
    @JvmField var tsTableName = ByteArray(MAX_TABLE_LENGTH)
    @JvmField var tsFileName = ByteArray(MAX_FILE_ID)
    @JvmField var tsFileType = ByteArray(MAX_FILE_EXT)
    @JvmField var uiFileSize = 0L
    @JvmField var tsCreateDate = ByteArray(20)
    @JvmField var tsModifyDate = ByteArray(20)
    @JvmField var MD5 = ByteArray(33)
    @JvmField var btFlag = Byte.MAX_VALUE
    @JvmField var bIsDir = Byte.MAX_VALUE
    @JvmField var NodeID = 0
    @JvmField var ulPos = 0L
    @JvmField var ulSize = 0L
    @JvmField var tsVirtualName = ByteArray(MAX_FILE_ID + MAX_FILE_EXT)
    @JvmField var uiFileCount = 0L
    @JvmField var uiDirCount = 0L
    @JvmField var pData = ByteArray(NET_DATA_SIZE_T)

    override fun getFieldOrder(): MutableList<String> =
        HFS_FILE_INFO::class.java.declaredFields.map { it.name }.toMutableList()
    
}
```

接口
```
interface LibHFS : Library {

    companion object {
        val INSTANCE by lazy {
            Native.load("hfsclient", LibHFS::class.java) as LibHFS
        }
    }

    fun CheckNetWork(ip: String, port: Int = 8810): Boolean

    fun InitApplication(
        ip: String,
        port: Int = 8810,
        appId: Int = 1024,
        appName: String = "HFMS",
        appKey: String = "f4b871d85cd746021b451487849e3cdf"
    ): Boolean

    fun OpenStream(filename: String, mode: String): Pointer

    fun CloseStream(fp: Pointer): Long

    fun ReadStream(fp: Pointer, buf: ByteArray, size: NativeLong): Long

    fun EofStream(fp: Pointer): NativeLong

    fun GetStreamInfo(fp: Pointer, info: HFS_FILE_INFO): Boolean
}
```

测试下载
```
LibHFS.INSTANCE.InitApplication(ip)

val fp = LibHFS.INSTANCE.OpenStream(filename, "rb")
val bos = FileOutputStream("demo.caj").buffered()

val buf = ByteArray(1024 * 8)
while (LibHFS.INSTANCE.EofStream(fp).toInt() != -1) {
	val size = LibHFS.INSTANCE.ReadStream(fp, buf, NativeLong(1024 * 8))
	bos.write(buf, 0, size.toInt())
}

bos.close()
LibHFS.INSTANCE.CloseStream(fp)
```

测试获取文件信息

```
LibHFS.INSTANCE.InitApplication(ip)

val fp = LibHFS.INSTANCE.OpenStream(filename, "rb")
val info = HFS_FILE_INFO()
LibHFS.INSTANCE.GetStreamInfo(fp, info)
println(info)

LibHFS.INSTANCE.CloseStream(fp)
```



ByteArray 转 String 问题

```
ByteArray(32)大小固定，导致这种结果[99, 97, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

直接使用 String(bytes) 结果length=32，结尾有乱码
应该用 String(bytes, 0, bytes.indexOf(0)) 结果length=3

fun ByteArray.trimString() = String(this, 0, this.indexOf(0))
```

