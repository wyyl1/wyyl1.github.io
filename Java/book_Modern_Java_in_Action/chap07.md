# 第 7 章 并行数据处理与性能
## 7.1 并行流
**并行流**就是把内容拆分成多个数据块，用不同线程分别处理每个数据块的流
## 7.1.1 将顺序流转换为并行流
对顺序流调用 parallel 方法
```java
  public static long parallelSum(long n) {
    return Stream.iterate(1L, i -> i + 1).limit(n).parallel().reduce(Long::sum).get();
  }
```
配置并行流使用的线程池
- 并行流内部使用了默认的 ForkJoinPool
- 默认线程数量就是处理器数量
- 这个值由 Runtime.getRuntime().availableProcessors() 得到的
- 可以通过系统属性 System.setProperty("java.util.concurrent.ForkJoinPool.common.parallelism", "12");
    - Java 11 这个方法已经失效
    - 没有充足的理由，强烈建议不要修改
## 7.1.2 测量流性能
JMH （Java 微基准套件 Java microbenchmark harness）

Stream.iterate 本质上是顺序的，使用它的并行流，性能提升不明显
```java
  public long sequentialSum() {
    return Stream.iterate(1L, i -> i + 1).limit(N).reduce(0L, Long::sum);
  }
```
选择适当的数据结构往往比并行化算法更重要
```java
  public long parallelRangedSum() {
    return LongStream.rangeClosed(1, N).parallel().reduce(0L, Long::sum);
  }
```
并行化的代价
- 并行化过程本身需要对流做递归划分，把每个子流的规约操作分配到不同的线程，然后把这些操作的结果合并成一个值
- 在多核之间移动数据的代价
    - 要保证：在核中并行执行工作的时间 > 在核之间传输数据的时长
## 7.1.3 正确使用并行流
- 产生错误的首要原因：使用的算法改变了某些共享状态
    - 要避免共享可变状态，确保并行 Stream 得到正确的结果
## 7.1.4 高效使用并行流
- 通过测量，判断是否得到性能提升
- 留意装箱，原始类型流：IntStream、LongStream、DoubleStream
- 有些操作本身在并行流上的性能就比顺序流差
    - limit、findFirst 等医疗元素顺序的操作
    - findAny 不需要按顺序操作，性能优于 findFirst
    - 调用 unordered 方法把有序流变成无序流
- 考虑流的操作流水线的总计算成本
- 对于较小的数据量，选择并行几乎是一个糟糕的决定
- 要考虑流背后的数据结构是否易于分解
    - ArrayList 的拆分效率比 LinkedList 高的多，因为前者不用遍历就可以平均拆分，后者则必须遍历
    - 用 range 工厂方法创建的原始类型流也可以快速分解
- 流自身的特点以及流水线中的中间操作修改流的方式，都可能会改变分解过程的性能
- 还要考虑终端操作中合并步骤的代价的大小
## 7.2 分支/合并框架
- 以递归方式将可以并行的任务拆分成更小的任务
- 然后将美国子任务的结果合并起来生成整体结果
- 它是 ExecutorService 接口的一个实现，把子任务分配给线程池（ForkJoinPool）中的工作线程
## 7.2.1 使用 RecursiveTask
## 7.2.2 使用分支/合并框架的最佳做法
- 对一个任务调用 join 方法会阻塞调用方，直到该任务返回结果
    - 有必要在两个子任务的计算都开始之后再调用
    - 否则，你的代码会比原始的顺序算法更慢且更复杂，因为每个子任务都必须等待另一个子任务完成后才能启动
- 不应该在 RecursiveTask 内部使用 ForkJoinPool 的 invoke 方法
- 对子任务调用 fork 方法可以把它排进 ForkJoinPool
    - 同时对左右两边的子任务调用它似乎很自然，但这样的效率比直接对期中一个调用 compute 低
    - 这样做可以为期中一个子任务重用同一线程，从而避免在线程池中多分配一个任务造成的开销
- Debug 时会很郁闷
- 和并行流一样，不一定比顺序执行速度快
    - 一个惯用的方法：把输入/输出放在一个子任务，计算放在另一个，这样计算就可以和输入/输出同时进行
## 7.2.3 工作窃取
由于每个任务花费的时间不同（比如磁盘、网络访问慢），导致有的线程很闲、有的很忙，为了平衡工作量，有了工作窃取算法
- 首先，将任务差不多平均分配到 ForkJoinPool 中的所有线程上
- 其次，每个线程都将分配到的任务保存在一个双端队列中
    - 每完成一个任务，就从队列头取出下一个任务执行
- 当任自己的务队列为空时，其他线程还很忙
    - 随机选择一个其他线程
    - 从队列尾部"偷走"一个任务执行
- 划分成许多小任务而不是少数几个大任务，有助于更好的在工作线程之间平衡负载
## 7.3 Spliterator
- Java 8 中的一个新接口
- 可分迭代器（splitable iterator）
- 和 Iterator 一样，用于遍历数据源中的元素，但它是为了并行执行而设计
## 7.3.1 拆分过程
## 7.3.2 实现你自己的 Spliterator 😅太高级了，看书吧