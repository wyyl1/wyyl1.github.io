# 第 3 章 Lambda 表达式

## 方法引用 ::

- 创建方法引用（File::isHidden）
```java
File[] hiddenFiles = new File(".").listFiles(File::isHidden);
```

## Predicate
- 谓词：在数学上常常用来代表类似于函数的东西，它接受一个参数值，并返回 **true** 或 **false**
- 优点：代码更干净、更清晰
- 复杂的条件可以使用策略模式
- 更好的实现 DRY(Don't Repeat Yourself)

## 行为参数化
- 通俗解释：让方法接受多种行为（策略）作为参数，并在内部使用，来完成不同的行为
- 优点：让代码更能适应需求的变化

## Lambda
- 可以理解为一种简洁的可传递匿名函数
    - 没有名称
    - 有参数列表、函数主体、返回类型
    - 允许有一个可以抛出的异常列表
    - Lambda 表达式可以作为参数传递给方法或存储在变量中
    - Lambda 没有 return 语句，因为已经隐含了 return
    - 可以返回 void ``` () -> {} ```
    - 起源于学术界开发出的一套用来描述计算的λ演算法
              
### 表 3-1 Lambda 示例

| 使用案例 | Lambda 示例 |
| --- | --- |
| 布尔表达式 | (List<String> list) -> list.isEmpty()|
| 创建对象 | () -> new Apple(10) |
| 消费一个对象 | (Apple a) -> { System.out.println(a.getWeight()); } |
| 从一个对象中选择/抽取 | (String s) -> s.length() |
| 组合两个值 | (int a, int b) -> a * b |
| 比较两个对象 | (Apple a1, Apple a2) -> a1.getWeight().compareTo(a2.getWeight()) |
| 返回 String 作为表达式 | () -> "Hi" |
| 返回 String（利用显示返回语句） | () -> {return "Hi";} |

## 函数式接口
- 只定义一个抽象方法的接口
                         
### @FunctionalInterface

### 3.4.1 Predicate
- java.util.function.Predicate
- boolean test(T t);
    - t : the function argument
    - r : the function result

### 3.4.2 Consumer
- 消费者
- void accept(T t);

### 3.4.3 Function
- R apply(T t);
- 接受泛型 T 的参数，返回泛型 R 的对象

### 基本类型函数接口
- 装箱后的值本质上就是把基本类型包裹起来，并保存在堆里
- 因此，装箱后的值需要更多的内存
- 并且需要额外的内存搜索来获取被包裹的基本值

使用类似下列函数式接口可以避免自动装箱操作

- IntPredicate
- LongConsumer
- DoubleFunction

更多接口详见：表 3-2 Java 8 中的常用函数式接口
表 3-3 Lambda 及函数式接口的例子

| 使用案例 | Lambda 的例子 | 对应的函数式接口 |
| --- | --- | --- |
| 布尔表达式 | (List<String> list) -> list.isEmpty() | Predicate<List<String>> |
| 创建对象 | () -> new Apple(10) | Supplier<Apple> |
| 消费一个对象 | (Apple a) -> System.out.println(a.getWeight) | Consumer<Apple> |
| 从一个对象中提取 | (String s) -> s.length() | Function<String, Integer> <br> ToIntFunction<String> |
| 合并两个值 | (int a, int b) -> a * b | IntBinaryOperator |
| 比较两个对象 | (Apple a1, Apple a2) -> a1.getWeight().compareTo(a2.getWeight()) | Comparator<Apple> <br> BiFunction<Apple, Apple, Integer> <br> ToIntBiFunction<Apple, Apple, Apple> |

### 3.6 方法引用

- 方法引用主要有三类
    - 指向静态方法的方法引用
    - 指向任意类型示例方法的方法引用
    - 指向现存对象或表达式实例方法的方法引用

图 3-5 改编

| Lambda | 方法引用 | 备注 |
| --- | --- | --- |
| (args) -> ClassName.staticMethod(args) | ClassName::staticMethod |  |
| (arg0, rest) -> arg0.instanceMethod(rest) | ClassName::instanceMethod | arg0 是 ClassName 类型的 |
| (args) -> expr.instanceMethod(args) | expr::instanceMethod |  |

测验3.6：方法引用

| Lambda | 方法引用 |
| --- | --- |
| ToIntFunction<String> stringToInt = (String s) -> Integer.parseInt(s); | ToIntFunction<String> stringToInt = Integer:parseInt; |
| BiPredicate<List<String>, String> contains = (list, element) -> list.contains(element); | BiPredicate<List<String>, String> contains = List::contains; |
| Predicate<String> startsWithNumber = (String string) -> this.startWithNumber(string); | Predicate<String> startsWithNumber = this::startsWithNumber |

#### 3.6.2 构造函数引用

### 3.8 复合 Lambda 表达式的有用方法
#### 3.8.2 谓词复合

谓词接口包括三个方法

- negate
    - 返回 Predicate 的非，例如苹果不是红的 Predicate<Apple> notRedApple = redApple.negate();
- and
- or

#### 3.8.3 函数复合
##### andThen 方法会返回一个函数
- 先对输入，执行一个给定函数
- 在对输出，执行另一个函数

```java
        Function<Integer, Integer> f = x -> x + 1;
        Function<Integer, Integer> g = x -> x * 2;
        // 数学上写作：g(f(x))
        Function<Integer, Integer> h = f.andThen(g);
        // 结果是 4
        int result = h.apply(1);
```

##### compose 方法
- 先对输入执行 compose 后的函数
- 再将之前的结果作为输入，执行 compose 前的函数

```java
        Function<Integer, Integer> f = x -> x + 1;
        Function<Integer, Integer> g = x -> x * 2;
        // 数学上写作：f(g(x))
        Function<Integer, Integer> h = f.compose(g);
        // 结果是 3
        int result = h.apply(1);
```
图3-6说明了andThen和compose之间的区别

##### 作用：可以组成强大的流水线（对新手来说并不友好，因为无法推测出正确的结果）

```java
    public static String addHeader(String text) {
        return "Header: " + text;
    }

    public static String addFooter(String text) {
        return " Footer " + text;
    }

    public static String checkSpelling(String text) {
        return text.replaceAll("labda", "lambda");
    }

    public static void assemblyLine1(){
        String text = "流水线1";
        Function<String, String> addHeader = Chap03Letter::addHeader;
        Function<String, String> transformationPipeline = addHeader
                .andThen(Chap03Letter::checkSpelling)
                .andThen(Chap03Letter::addFooter);
        System.out.println(transformationPipeline.apply(text));
        // 输出：Footer Header: 流水线1
    }

    public static void assemblyLine2(){
        String text = "流水线2";
        Function<String, String> addHeader = Chap03Letter::addHeader;
        Function<String, String> transformationPipeline = addHeader
                .compose(Chap03Letter::checkSpelling)
                .compose(Chap03Letter::addFooter);
        System.out.println(transformationPipeline.apply(text));
        // 输出：Header:  Footer 流水线2
    }
```

### 3.9 数学中的类似思想

f(x) = x + 10

### 3.10 小结
- Lambda 表达式可以理解为一种匿名函数
    - 没有名称
    - 有参数列表、函数主体、返回类型
    - 可能还有一个可以抛出的异常列表
- Lambda 表达式让你可以简洁地传递代码
- **函数式接口**就是仅仅声明了一个抽象方法的接口
- 只有在接受函数式接口的地方才可以使用 Lambda 表达式