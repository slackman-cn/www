读取文件

```java
Path path = Paths.get("new.txt");
byte[] bytes = Files.readAllBytes(path);
int size = bytes.length; // ls -l

try(InputStream inputStream = Files.newInputStream(path)) {
    ...
}
```

## JDK

```java
MessageDigest md5 = MessageDigest.getInstance("MD5");
byte[] ret = md5.digest(bytes);

StringBuilder checksum = new StringBuilder();
for (byte b : ret) {
    checksum.append(String.format("%02x",b));
}
assertEquals(CHK_MD5, checksum.toString());
// codec
String checksum = Hex.encodeHexString(ret);
```

## 3rd

```java
// apache codec
String sign = DigestUtils.md5Hex(bytes);

// spring-core
String sign = org.springframework.util.DigestUtils.md5DigestAsHex(bytes);
```


大文件分片计算
https://stackoverflow.com/questions/9321912/very-slow-to-generate-md5-for-large-file-using-java

文件流
https://gitee.com/sxl_db/OnJava8/blob/master/docs/book/Appendix-New-IO.md
