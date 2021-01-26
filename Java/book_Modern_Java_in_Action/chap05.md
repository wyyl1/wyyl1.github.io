# 第 5 章 使用流
## 5.1 筛选
- filter
- distinct：筛选时各异的元素

## 5.2 流的切片
## 5.2.1 使用谓词对流进行切片
Java 9 引入了两个新方法，可以高效地选择流中的元素
- filter的缺点是需要遍历整个流中的数据，这两个方法会在遭遇第一个不符合要求的元素时停止处理
- takeWhile
- dropWhile 

```java
        List<Integer> list = Arrays.asList(12, 2, 9, 3, 3, 5);

        System.out.println(list.stream()
                .takeWhile(i -> i > 2)
                .collect(toList()));
        // [12]

        System.out.println("------------------------------------");
        System.out.println(list.stream()
                .dropWhile(i -> i > 2)
                .collect(toList()));
        // [2, 9, 3, 3, 5]
```

## 5.2.2 截短流
limit(n)
## 5.2.3 跳过元素
skip(n)
- 返回一个扔掉了前n个元素的流
- 如果流中元素不足n个，则返回一个空流
- limit(n) 和 skip(n) 是互补的

## 5.3 映射
- map
- flatMap

## 5.3.1 对流中每一个元素应用函数
map
- 接收一个函数作为参数
- 这个函数会被应用到每个元素上，并将其映射成一个新的元素（创建一个新版本，而不是去"修改"）

找出每道菜的名称有多长

```java
List<Integer> dishNameLengths = menu.stream()
            .map(Dish::getName)
            .map(String::length)
            .collect(toList());
```
## 5.3.2 流的扁平化
flatMap
- 各个数组并不是分别映射成一个流，而是映射成流的内容
- 也就是说：flatMap 方法让你把一个流中的每个值都换成另一个流，然后把所有的流连接起来成为一个流

使用 flatMap 找出单词列表中各不相同的字符

```java
        System.out.println("------------------------------------");
        List<String> words = Arrays.asList("Hello", "World");
        List<String> uniqueCharacters = words.stream()
                .map(word -> word.split(""))
                .flatMap(Arrays::stream)
                .distinct()
                .collect(toList());
        System.out.println(uniqueCharacters);
        // [H, e, l, o, W, r, d]
```

给定两个数字列表，如何返回所有的数对呢？
例如，给定[1,2,3]和[3,4]，应返回 [(1,3), (1,4), (2,3), (2,4), (3,3), (3,4)]
```java
        List<Integer> numbers1 = Arrays.asList(1, 2, 3);
        List<Integer> numbers2 = Arrays.asList(3, 4);
        List<int[]> pairs = numbers1.stream()
                .flatMap(i -> numbers2.stream()
                        .map(j -> new int[]{i, j}))
                .collect(toList());
        pairs.forEach(pair -> {
            System.out.println(Arrays.toString(pair));
        });
```
## 5.4 查找和匹配
看看数据集中的某些元素是否匹配一个给定的属性
- allMatch：是否匹配所有元素
- anyMatch：是否至少匹配一个元素
- noneMatch：和 allMatch 相对，流中没有任何元素匹配
- findFirst：查找第一个元素
- findAny：返回当前流中的任意元素

## 5.5 规约
## 5.5.1 元素求和
reduce
- 接受两个参数
    - 一个初始值
    - 一个 BinaryOperator<T> 来将两个元素结合起来产生一个新值

- 元素求和：
    - int sum = numbers.stream().reduce(0, (a, b) -> a + b);
    - int sum2 = numbers.stream().reduce(0, Integer::sum);
- 最大值：int max = numbers.stream().reduce(0, (a, b) -> Integer.max(a, b));
- 最小值：Optional<Integer> min = numbers.stream().reduce(Integer::min);

规约方法的优势与并行化
- 迭代被内部迭代抽象化，让内部实现得以选择并行执行 reduce 操作

## 5.7.2 数值范围
第一个参数是起始值，第二个参数结束值
- range：不包含结束值
- rangeClosed：包含结束值
```java
    IntStream evenNumbers = IntStream.rangeClosed(1, 100)
        .filter(n -> n % 2 == 0);
    System.out.println(evenNumbers.count());
```
## 5.8 构建流
## 5.8.4 由文件生成流
Files.lines
- 返回一个由指定文件中的各行构成的字符串流
- Stream 接口通过实现 AutoCloseable 接口，自动的安全的关闭流

统计不重复的单词数量

```java
long uniqueWords = Files.lines(Paths.get("data.txt"), Charset.defaultCharset())
        .flatMap(line -> Arrays.stream(line.split(" ")))
        .distinct()
        .count();
```
## 5.8.5 由函数生成流：创建无限流
一般来说，应该使用 limit(n) 来对这种流加以限制
- Stream.iterate：迭代
- Stream.generate：生成

### 迭代
生成一个所有正偶数的流
```java
Stream.iterate(0, n -> n + 2)
        .limit(10)
        .forEach(System.out::println);
```
裴波纳契数列
```java
Stream.iterate(new int[] { 0, 1 }, t -> new int[] { t[1], t[0] + t[1] })
        .limit(10)
        .forEach(t -> System.out.printf("(%d, %d)", t[0], t[1]));
```

Java 9 对 iterate 方法进行了增强，支持谓词操作
从0开始生成一个数字序列，当数字大于100时停止
```java
Stream.iterate(0, n -> n < 100, n -> n +4)
    .forEach(System.out::println);
```
或者使用 takeWhile
```java
Stream.iterate(0, n -> n + 4)
            .takeWhile(n -> n < 100)
            .forEach(System.out::println);
```
### 生成
- 接受一个 Supplier<T> 类型的 Lambda 提供新的值

生成一个随机数流
```java
Stream.generate(Math::random)
        .limit(10)
        .forEach(System.out::println);
```
## 5.10 小结
- 如果明确指定数据源是排序的，使用 takeWhile、dropWhile 方法通常比 filter 高效的多
- filter、map 等操作都是无状态的
- reduce 等操作要存储状态才能计算出一个值
- sorted、distinct 等操作也要存储状态，因为它们需要把流中的所有元素缓存起来才能返回一个新的流
- 流不仅可以从集合创建，也可以从值、数组、文件、iterate、generate 等特定方法创建