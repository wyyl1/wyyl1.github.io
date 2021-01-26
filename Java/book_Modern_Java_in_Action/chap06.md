# 第 6 章 用流收集数据
## 6.1 收集器简介
## 6.1.1 收集器用作高级规约
优秀的函数式 API 设计优点
- 更易复合
- 更易重用
## 6.1.2 预定义收集器
Collectors 类提供的工厂方法创建的收集器，主要提供三大功能：
- 将流元素规约和汇总为一个值
- 元素分组
- 元素分区
## 6.2.1 查找流中的最大值和最小值
- Collectors.maxBy
- Collectors.minBy
## 6.2.2 汇总
- Collectors.summingInt：求和
- Collectors.averagingInt：计算平均数
```java
int total = menu.stream().collect(summingInt(Dish::getCalories));
```
## 6.2.3 链接字符串
joining()
```java
menu.stream().map(Dish::getName).collect(joining());
// porkbeefchickenfrench friesriceseason fruitpizzaprawnssalmon

menu.stream().map(Dish::getName).collect(joining(", "));
// porkbeefchickenfrench, friesriceseason, fruitpizzaprawnssalmon
```
## 6.2.4 广义的规约汇总
Collectors.reducing 工厂方法是所有这些特殊情况的一般化
计算菜单总热量
```java
  private static int calculateTotalCalories() {
    return menu.stream().collect(reducing(0, Dish::getCalories, (Integer i, Integer j) -> i + j));
  }
```
它需要三个参数：
- 第一个是规约操作的起始值，也是流中没有元素时的返回值
- 第二个是一个函数
- 第三个是一个 BinaryOperator，将两个项目累积成一个同类型的值

### 收集与规约
- reduce：
    - 把两个值结合起来生成一个新值，它是一个不可变的规约
- collect：
    - 设计是要改变容器，从而累积要输出的结果
    - 适合并行操作
## 6.3 分组
按类别分组
```java
  private static Map<Dish.Type, List<Dish>> groupDishesByType() {
    return menu.stream().collect(groupingBy(Dish::getType));
  }
  // {OTHER=[french fries, rice, season fruit, pizza], MEAT=[pork, beef, chicken], FISH=[prawns, salmon]}
```
自定义分组规则
```java
  private static Map<CaloricLevel, List<Dish>> groupDishesByCaloricLevel() {
    return menu.stream().collect(
        groupingBy(dish -> {
          if (dish.getCalories() <= 400) {
            return CaloricLevel.DIET;
          }
          else if (dish.getCalories() <= 700) {
            return CaloricLevel.NORMAL;
          }
          else {
            return CaloricLevel.FAT;
          }
        })
    );
  }
```
## 6.3.1 操作分组的元素
groupingBy + filtering 操作有点复杂，需要时查阅原文
- 使用 filter，会少一个分类 FISH
- 使用 groupingBy + filtering，FISH 分类会被保存，即使是空数据

modernjavainaction.chap06.Grouping.java
```java
  private static Map<Dish.Type, List<Dish>> groupCaloricDishesByType() {
//    return menu.stream()
//            .filter(dish -> dish.getCalories() > 500)
//            .collect(groupingBy(Dish::getType));
      // {OTHER=[french fries, pizza], MEAT=[pork, beef]}
    return menu.stream().collect(
        groupingBy(Dish::getType,
            filtering(dish -> dish.getCalories() > 500, toList())));
    // {OTHER=[french fries, pizza], MEAT=[pork, beef], FISH=[]}
  }
```
## 6.3.2 多级分组
groupingBy 嵌套 groupingBy
```java
  private static Map<Dish.Type, Map<CaloricLevel, List<Dish>>> groupDishedByTypeAndCaloricLevel() {
    return menu.stream().collect(
        groupingBy(Dish::getType,
            groupingBy((Dish dish) -> {
              if (dish.getCalories() <= 400) {
                return CaloricLevel.DIET;
              }
              else if (dish.getCalories() <= 700) {
                return CaloricLevel.NORMAL;
              }
              else {
                return CaloricLevel.FAT;
              }
            })
        )
    );
  }
```

## 6.3.3 按子组收集数据
传递给第一个 gropingBy 的第二个收集器可以是任何类型

统计每个类型的数量
```java
  private static Map<Dish.Type, Long> countDishesInGroups() {
    return menu.stream().collect(groupingBy(Dish::getType, counting()));
  }
  // {OTHER=4, MEAT=3, FISH=2}
```
Collectors.collectingAndThen 😅详情见原文
## 6.4 分区
分区是分组的特殊情况，Collectors.partitioningBy
- 分区函数返回一个布尔值

按荤素分
```java
  private static Map<Boolean, List<Dish>> partitionByVegeterian() {
    return menu.stream().collect(partitioningBy(Dish::isVegetarian));
  }
  // {false=[pork, beef, chicken, prawns, salmon], true=[french fries, rice, season fruit, pizza]}
```
## 6.4.1 分区的优势
- 保留了分区函数返回 true 或 false 的两套流元素列表

按荤素、食材类型分类
```java
  private static Map<Boolean, Map<Dish.Type, List<Dish>>> vegetarianDishesByType() {
    return menu.stream().collect(partitioningBy(Dish::isVegetarian, groupingBy(Dish::getType)));
  }
  // {false={MEAT=[pork, beef, chicken], FISH=[prawns, salmon]}, true={OTHER=[french fries, rice, season fruit, pizza]}}
```

查找荤素中热量最高的食物
```java
  private static Object mostCaloricPartitionedByVegetarian() {
    return menu.stream().collect(
        partitioningBy(Dish::isVegetarian,
            collectingAndThen(
                maxBy(comparingInt(Dish::getCalories)),
                Optional::get)));
  }
  // {false=pork, true=pizza}
```
## 6.5 收集器接口
```java
public interface Collector<T, A, R> {
    Supplier<A> supplier();
    BiConsumer<A, T> accumulator();
    BinaryOperator<A> combiner();
    Function<A, R> finisher();
    Set<Characteristics> characteristics();
}
```
- T：流中要收集的项目的泛型
- A：累加器的类型，累加器是在收集过程中用于累积部分结果的对象
- R：收集操作得到的对象（通常但并不一定是集合）的类型

## 6.5.1 理解 Collector 接口声明的方法 😅详见原文
- 前四个方法都返回一个会被 collect 方法调用的函数
- 第五个方法 characteristics 则提供了一系列特征，也就是一个提示列表，告诉 collect 方法在执行归约操作的时候可以应用哪些优化（比如并行化）

### 01 建立新的结果容器： supplier 方法
### 02 将元素添加到结果容器： accumulator 方法
### 05 characteristics 方法
- UNORDERED：归约结果不受流中项目的遍历和累积顺序的影响
- CONCURRENT：
    - accumulator 函数可以从多个线程同时调用，且该收集器可以并行归约流
    - 如果收集器没有标为 UNORDERED，那它仅在用于无序数据源时才可以并行归约
- IDENTITY_FINISH：
    - 表明完成器方法返回的函数是一个恒等函数，可以跳过
    - 这种情况下，累加器对象将会直接用作归约过程的最终结果
    - 这也意味着，将累加器 A 不加检查地转换为结果 R 是安全的   
## 6.6 开发你自己的收集器以获得更好的性能 😅太高级了，看书吧