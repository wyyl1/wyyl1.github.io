# 第 16 章 CompletableFuture：组合式异步编程

## 16.1 Future 接口

- 一大优点：比底层的 Thread 更好用

### 16.1.1 Future 接口的局限性

当长时间计算任务完成时，将该计算的结果通知到另一个长时间运行的计算任务，这两个计算任务都完成后，将计算的结果与另一个查询操作结果合并。

### 16.1.2 使用 CompletableFuture 构建异步应用

## 16.2 实现异步 API

### 16.2.1 将同步方法转换为异步方法

### 16.2.2 错误处理

工厂方法 CompletableFuture.supplyAsync

## 16.3 让你的代码免受阻塞之苦

### 16.3.2 使用 CompletableFuture 发起异步请求

代码清单 16-11 

```java
public List<String> findPrices(String product) {
    List<CompletableFuture<String>> priceFutures =
            shops.stream()
                    // 使用 CompletableFuture 以异步方式及时每种商品的价格
            .map(shop -> CompletableFuture.supplyAsync(
                    () -> shop.getName() + " price is" + shop.getPrice(product)
            ))
            .collect(Collectors.toList());
    return priceFutures.stream()
            // 等待所有异步操作结束
            .map(CompletableFuture::join)
            .collect(Collectors.toList());
}
```

 使用两个不同的 Stream 流水线，而不是在同一个处理流的流水线上一个接一个地放置两个 map 操作，是因为：

 - 在单一流水线中处理流，发向不同商家的请求只能以同步、顺序执行
 - 因此，每个创建 CompletableFuture 对象只能在前一个操作结束之后执行查询指定商家的动作，通知 join 方法返回计算结果
 - 图 16-2 解释了这些重要的细节

![avatar](image/16-2.png)

### 16.3.3 寻找更好的方案

CompletableFuture 相对于并行流的优势

 - 允许对执行器（Executor）进行配置，尤其是线程池的大小

### 16.3.4 使用定制的执行器

#### 调整线程池的大小，《Java 并发编程实战》中的公式

线程数 = Cpu 核心数 * 期望的 CPU 利用率（0和1之间） * （1 + 等待时间/计算时间）

- CPU 核心数可以通过 Runtime.getRuntime.availableProcessors() 得到
- 避免过载，最好设置线程数上限

#### 并行几乎最有效的策略

100 个店铺测试
- 16-11 代码耗时：15209 msecs
- 下面代码耗时：1181 msecs

核心代码

```java
private final Executor executor =
        Executors.newFixedThreadPool(Math.min(shops.size(), 100), r -> {
            Thread t = new Thread(r);
            t.setDaemon(true);
            return t;
        });

CompletableFuture.supplyAsync(() -> shop.getName() + " price is" + shop.getPrice(product), executor)
```

完整代码

```java
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

/**
 * Java 最强并行
 * @author aoe
 * @date 2021/2/20
 */
public class BestParallel {

    private final List<Shop> shops = getShops(100);

    private final Executor executor =
            Executors.newFixedThreadPool(Math.min(shops.size(), 100), r -> {
                Thread t = new Thread(r);
                t.setDaemon(true);
                return t;
            });

    public static void main(String[] args) {
        BestParallel test = new BestParallel();

        long start = System.nanoTime();
        test.findPrices("car");
        long duration = (System.nanoTime() - start) / 1_000_000;
        System.out.println("普通版 done in " + duration + " msecs");
        // 15115

        start = System.nanoTime();
        test.findPricesBest("car");
        duration = (System.nanoTime() - start) / 1_000_000;
        System.out.println("最强版 done in " + duration + " msecs");
        // 1020
    }

    public List<String> findPrices(String product) {
        List<CompletableFuture<String>> priceFutures =
                shops.stream()
                        // 使用 CompletableFuture 以异步方式及时每种商品的价格
                        .map(shop -> CompletableFuture.supplyAsync(() -> shop.getName() + " price is" + shop.getPrice(product))
                        )
                        .collect(Collectors.toList());
        return priceFutures.stream()
                // 等待所有异步操作结束
                .map(CompletableFuture::join)
                .collect(Collectors.toList());
    }

    public List<String> findPricesBest(String product) {
        List<CompletableFuture<String>> priceFutures =
                shops.stream()
                        // 使用 CompletableFuture 以异步方式及时每种商品的价格
                        .map(shop -> CompletableFuture.supplyAsync(() -> shop.getName() + " price is" + shop.getPrice(product), executor)
                        )
                        .collect(Collectors.toList());
        return priceFutures.stream()
                // 等待所有异步操作结束
                .map(CompletableFuture::join)
                .collect(Collectors.toList());
    }

    private List<Shop> getShops(int count) {
        List<Shop> list = new ArrayList<>(count);
        for (int i = 0; i < count; i++) {
            list.add(new Shop("Shop" + i));
        }
        return list;
    }
}

class Shop {

    private final String name;
    private final Random random;

    public Shop(String name) {
        this.name = name;
        random = new Random(name.charAt(0) * name.charAt(1) * name.charAt(2));
    }

    public String getPrice(String product) {
        double price = calculatePrice(product);
        Discount.Code code = Discount.Code.values()[random.nextInt(Discount.Code.values().length)];
        return name + ":" + price + ":" + code;
    }

    public double calculatePrice(String product) {
        Util.delay();
        return Util.format(random.nextDouble() * product.charAt(0) + product.charAt(1));
    }

    public String getName() {
        return name;
    }

}

class Discount {

    public enum Code {
        NONE(0), SILVER(5), GOLD(10), PLATINUM(15), DIAMOND(20);

        private final int percentage;

        Code(int percentage) {
            this.percentage = percentage;
        }
    }

    public static String applyDiscount(Quote quote) {
        return quote.getShopName() + " price is " + Discount.apply(quote.getPrice(), quote.getDiscountCode());
    }

    private static double apply(double price, Code code) {
        Util.delay();
        return Util.format(price * (100 - code.percentage) / 100);
    }
}

class Util {

    private static final Random RANDOM = new Random(0);
    private static final DecimalFormat formatter = new DecimalFormat("#.##", new DecimalFormatSymbols(Locale.US));

    public static void delay() {
        int delay = 1000;
        //int delay = 500 + RANDOM.nextInt(2000);
        try {
            Thread.sleep(delay);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    public static double format(double number) {
        synchronized (formatter) {
            return new Double(formatter.format(number));
        }
    }

    public static <T> CompletableFuture<List<T>> sequence(List<CompletableFuture<T>> futures) {
/*
    CompletableFuture<Void> allDoneFuture =
        CompletableFuture.allOf(futures.toArray(new CompletableFuture[futures.size()]));
    return allDoneFuture.thenApply(v ->
        futures.stream()
            .map(future -> future.join())
            .collect(Collectors.<T>toList())
    );
*/
        return CompletableFuture.supplyAsync(() -> futures.stream()
                .map(future -> future.join())
                .collect(Collectors.<T>toList()));
    }

}

class Quote {

    private final String shopName;
    private final double price;
    private final Discount.Code discountCode;

    public Quote(String shopName, double price, Discount.Code discountCode) {
        this.shopName = shopName;
        this.price = price;
        this.discountCode = discountCode;
    }

    public static Quote parse(String s) {
        String[] split = s.split(":");
        String shopName = split[0];
        double price = Double.parseDouble(split[1]);
        Discount.Code discountCode = Discount.Code.valueOf(split[2]);
        return new Quote(shopName, price, discountCode);
    }

    public String getShopName() {
        return shopName;
    }

    public double getPrice() {
        return price;
    }

    public Discount.Code getDiscountCode() {
        return discountCode;
    }

}
```

#### 并行：使用流还是 CompletableFuture ？

- 流
  - 计算密集型
  - 没有 I/O
  - 因为实现简单，同时效率也可能是最高的
- CompletableFuture
  - 涉及等待 I/O 操作（包括网络连接）
  - 灵活性好（可以根据实际情况设置线程数）
  - 不使用并行流的原因之一：处理流的流水线中如果发生 I/O 等待，流的延迟特性会让我们很难判断到底什么时候触发了等待

## 16.4 对多个异步任务进行流水线操作

### 16.4.1 实现折扣服务

### 16.4.2 使用 Discount 服务
### 16.4.3 构造同步和异步操作

很强大，没看懂

### 16.4.4 将两个 CompletableFuture 对象整合起来，无论他们是否存在依赖

炫酷

### 16.4.5 对 Future 和 CompletableFuture 的回顾

### 16.4.6 高效地使用超时机制

## 16.5 响应 CompletableFuture 的 completion 事件

### 16.5.1 对最佳价格查询器应用的优化

### 16.5.2 付诸实战