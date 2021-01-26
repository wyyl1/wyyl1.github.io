# 第 9 章 重构、测试和调试
## 9.1 为改善可读性和灵活性重构代码
## 9.1.1 改善代码的可读性
三种简单的重构：
- 用 Lambda 表达式取代匿名类；
    - 匿名类的类型是在初始化时确定的
    - Lambda 的类型取决于它的上下文
- 用方法引用重构 Lambda 表达式；
    - 更清晰地表达问题陈述是什么
- 用 Stream API 重构命令式的数据处理
    - 更清晰地表达数据处理管道的意图

## 9.2 使用 Lambda 重构面向对象的设计模式
- 策略模式（9.2.1）
- 模板方法（9.2.2）
- 观察者模式（9.2.3）
    - 适合逻辑简单的情况下使用 Lambda 表达式
- 责任链模式（9.2.4）
- 工厂模式
    - 使用 Supplier 包装产品
```java
  final static private Map<String, Supplier<Product>> map = new HashMap<>();
  static {
    map.put("loan", Loan::new);
    map.put("stock", Stock::new);
    map.put("bond", Bond::new);
  }

  public static Product createProductLambda(String name) {
      Supplier<Product> p = map.get(name);
      if (p != null) {
        return p.get();
      }
      throw new RuntimeException("No such product " + name);
    }
```
多个参数时就没那么好看了
```java
interface TriFunction<T, U, V, R>{
  R apply(T t, U u, V v);
}

Map<String, TriFunction<Integer, Integer, String, Product>> map = new HashMap<>();
```
## 9.4.2 使用日志调试
- peek
```java
    List<Integer> result = Stream.of(2, 3, 4, 5)
        .peek(x -> System.out.println("taking from stream: " + x))
        .map(x -> x + 17)
        .peek(x -> System.out.println("after map: " + x))
        .filter(x -> x % 2 == 0)
        .peek(x -> System.out.println("after filter: " + x))
        .limit(3)
        .peek(x -> System.out.println("after limit: " + x))
        .collect(toList());
```