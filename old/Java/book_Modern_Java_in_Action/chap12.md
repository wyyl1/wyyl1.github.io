# 第12章 新的日期和时间 API
- Joda-Time 第三方日期和时间库

## 12.1 LocalDate、LocalTime、LocalDateTime、Instant、Duration 以及 Period

## 12.1.1 使用 LocalDate 和 LocalTime

### LocalDate
  
  - 是一个不可变对象
  - 只提供了简单的日期
  - 不含当天的时间信息
  - 也不附带任何与时区相关的信息
  
可以通过静态工厂方法 of 创建一个 LocalDate 实例

```java
    LocalDate date = LocalDate.of(2014, 3, 18);
    int year = date.getYear(); // 2014
    Month month = date.getMonth(); // MARCH
    int day = date.getDayOfMonth(); // 18
    DayOfWeek dow = date.getDayOfWeek(); // TUESDAY
    int len = date.lengthOfMonth(); // 31 (days in March)
    boolean leap = date.isLeapYear(); // false (not a leap year)
    System.out.println(date);
```

还可以使用工厂方法 now 从系统时钟获取当前的日期

```java
LocalDate today = LocalDate.now();
```

### LocalTime

- 可以表示一天中的时间，比如 13:45:20

```java
    LocalTime time = LocalTime.of(13, 45, 20); // 13:45:20
    int hour = time.getHour(); // 13
    int minute = time.getMinute(); // 45
    int second = time.getSecond(); // 20
    System.out.println(time);
```

使用静态方法 parse 也可以创建

```java
LocalDate date = LocalDate.parse("2017-09-21");
LocalTime time = LocalTime.parse("13:45:20");
```

## 12.1.2 合并日期和时间

- LocalDateTime：LocalDate 和 LocalTime 的合体
- 同时表示日期和时间
- 但不带有时区信息

```java
    // 2014-03-18T13:45
    LocalDateTime dt1 = LocalDateTime.of(2014, Month.MARCH, 18, 13, 45, 20);
    LocalDateTime dt2 = LocalDateTime.of(date, time);
    LocalDateTime dt3 = date.atTime(13, 45, 20);
    LocalDateTime dt4 = date.atTime(time);
    LocalDateTime dt5 = time.atDate(date);
    System.out.println(dt1);

    LocalDate date1 = dt1.toLocalDate();
    System.out.println(date1);
    LocalTime time1 = dt1.toLocalTime();
    System.out.println(time1);
```

## 12.1.3 机器的日期和时间格式

### java.time.Instant

- 建模方式：表示一个持续时间段上某个点的单一大整型数
- 以 Unix 元年时间（传统的设定为 UTC 时区 1970 年 1 月 1 日午夜时分）开始所经历的秒数进行计算
- 可以通过向静态工厂方法 ofEpochSecond 传递代表秒数的值创建一个该类的实例
- ofEpochSecond 增强的重载版本，它接受第二个以纳秒为单位的参数值，对传入作为秒数的参数进行调整
  - 确保保存的纳秒分片在 0  到 999 999 999 之间

```java
    Instant instant = Instant.ofEpochSecond(44 * 365 * 86400);
    Instant now = Instant.now();
    // 2 秒之后再加上 10 亿纳秒（1 秒）
    Instant instant = Instant.ofEpochSecond(2, 1_000_000_000);
    // 4 秒之前的 10 亿纳秒（1 秒）
    Instant instant = Instant.ofEpochSecond(4, -1_000_000_000);
```

- **Instant 的设计初衷是为了便于机器使用**
  - 它包含的是由秒及纳秒所构成的数字
  - 它无法处理那些非常容易理解的时间单位（例如，获得今天是这个月的第几天）
    - 可以通过 Duration 或 Period 类使用 Instant

## 12.1.4 定义 Duration 或 Period

### Duration 类主要用于以秒和纳秒衡量时间

- 不能仅向 between 方法传递一个 LocalDate 对象做参数

```java
        LocalTime time = LocalTime.of(13, 45, 20); // 13:45:20
        Instant instant = Instant.ofEpochSecond(44 * 365 * 86400);
        Instant now = Instant.now();

        Duration d1 = Duration.between(LocalTime.of(13, 45, 10), time);
        Duration d2 = Duration.between(instant, now);
        System.out.println(d1.getSeconds());
        System.out.println(d2.getSeconds());
```

### Period 以年、月、日的方式对多个时间单位建模

工厂方法 between 可以得到两个 LocalDate 之间的时长

```java
        Period tenDays = Period.between(LocalDate.of(2017, 9, 11),
                                        LocalDate.of(2017, 9, 21));
        System.out.println(tenDays.getDays());
```

### Duration 和 Period 便利的创建工厂

```java
        Duration threeMinutes = Duration.ofMinutes(3);
        Duration threeDays = Duration.of(3, ChronoUnit.DAYS);
        Period tenDays = Period.ofDays(10);
        Period threeWeeks = Period.ofWeeks(3);
        Period towYearsSixMonthsOneDay = Period.of(2, 6, 1);
```

表 12-1 Duration 和 Period 中表示时间间隔的通用方法

|方法名 | 是否静态方法 | 方法描述 |
| - | - | - |
| between | 是 | 创建两个时间点之间的间隔 |
| from | 是 | 由一个临时时间点创建时间间隔 |
| of | 是 | 由它的组成部分创建时间间隔的实例 |
| parse | 是 | 由字符串创建时间间隔的实例 |
| addTo | 否 | 创建该时间间隔的副本，并将其**叠加**到某个指定的 temporal 对象 |
| get | 否 | 读取该时间间隔的状态 |
| isNegative | 否 | 检查该时间间隔是否为负值，不包括零 |
| isZero | 否 | 检查该时间间隔的时长是否为零 |
| minus | 否 | 通过**减去**一定的时间创建该间隔时间的副本 |
| multipliedBy | 否 | 将时间间隔的值**乘以**某个标量创建该时间间隔的副本 |
| negated | 否 | 以**忽略**某个时长的方式创建该时间间隔的副本 |
| plus | 否 | 以**增加**某个指定时长的方式创建该时间间隔的副本 |
| subtractFrom | 否 | 从指定的 temporal 对象中**减去**该时间间隔 |


### 截止目前，Duration 和 Period 对象都是不可修改的

- 更好的支持函数式编程
- 线程安全

## 12.2 操纵、解析和格式化日期

以下代码中所有的方法都返回一个修改了属性的对象，**不会修改原来的对象**

```java
        LocalDate date1 = LocalDate.of(2017, 9, 21); // 2017-09-21
        LocalDate date2 = date1.withYear(2011); // 2011-09-21
        LocalDate date3 = date2.withDayOfMonth(25); // 2011-09-25
        LocalDate date4 = date3.with(ChronoField.MONTH_OF_YEAR, 2); // 2011-02-25
```

- 使用 get 和 with 方法，可以将 Temporal 对象值的读取和修改区分开
  - with 方法并不会直接修改现有的 Temporal 对象
  - 它会创建现有对象的副本并更新对应的字段
  - 这一过程也被称作**函数式更新**

以相对方式修改 LocalDate 对象的属性

```java
        LocalDate date1 = LocalDate.of(2017, 9, 21); // 2017-09-21
        LocalDate date2 = date1.plusWeeks(1); // 2017-09-28
        LocalDate date3 = date2.minusYears(6); // 2011-09-28
        LocalDate date4 = date3.plus(6, ChronoUnit.MONTHS); // 2012-03-28
```

## 12.2.1 使用 TemporalAdjuster

- 将日期调整到下个周日、下个工作日
- 本月的最后一天

```java
        import static java.time.temporal.TemporalAdjusters.*;

        LocalDate date1 = LocalDate.of(2014, 3, 18); // 2014-03-18
        LocalDate date2 = date1.with(nextOrSame(DayOfWeek.SUNDAY)); // 2014-03-23
        LocalDate date3 = date2.with(lastDayOfMonth()); // 2014-03-31
```

表 12-3 TemporalAdjusters 类中的工厂方法

|方法名 | 描述 |
| - | - |
| dayOfWeekInMonth | 创建一个新的日期，它的值为同一个月中每一周的第几天（负数表示从月末往月初计数） |
| firstDayOfMonth | 创建一个新的日期，它的值为当月的第一天 |
| firstDayOfNextMonth | 创建一个新的日期，它的值为下月的第一天 |
| firstDayOfNextYear | 创建一个新的日期，它的值为明年的第一天 |
| firstDayOfYear | 创建一个新的日期，它的值为当年的第一天 |
| firstInMonth | 创建一个新的日期，它的值为同一个月中，第一个符合星期几要求的值 |
| lastDayOfMonth | 创建一个新的日期，它的值为当月的最后一天 |
| lastDayOfNextMonth | 创建一个新的日期，它的值为下月的最后一天 |
| lastDayOfNextYear | 创建一个新的日期，它的值为明年的最后一天 |
| lastDayOfYear | 创建一个新的日期，它的值为当年的最后一天 |
| lastInMonth | 创建一个新的日期，它的值为同一个月中，最后一个符合星期几要求的值 |
| next / previous | 创建一个新的日期，并将其值设定为日期调整后或者调整前，第一个符合指定星期几要求的日期 |
| nextOrSame / previousOrSame | 创建一个新的日期，并将其值设定为日期调整后或者调整前，第一个符合指定星期几要求的日期，如果该日期已经符合要求，则直接返回该对象 |

### 实现自己的时间调节器

- 使用 Lambda 表达式定义 TemporalAdjuster 对象，推荐使用静态工厂方法 TemporalAdjusters.ofDateAdjuster

下一个工作日

```java
        TemporalAdjuster nextWorkingDay = TemporalAdjusters.ofDateAdjuster(temporal -> {
            DayOfWeek dow = DayOfWeek.of(temporal.get(ChronoField.DAY_OF_WEEK)); // 读取当前日期
            int dayToAdd = 1; // 正常情况：增加一天
            if (dow == DayOfWeek.FRIDAY) {
                dayToAdd = 3; // 如果当天是周五，增加三天
            }
            if (dow == DayOfWeek.SATURDAY) {
                dayToAdd = 2; // 如果当天是周六，增加两天
            }
            return temporal.plus(dayToAdd, ChronoUnit.DAYS); // 增加恰当的天数后，返回修改的日期
        });

        LocalDate date1 = LocalDate.of(2021, 1, 22); // 2021-01-22
        LocalDate date2 = date1.with(nextWorkingDay); // 2021-01-25
```

## 12.2.2 打印输出及解析日期 - 时间对象

### 包 java.time.format

- 格式化、解析日期
- 最重要的类 **DateTimeFormatter**

格式化日期

```java
LocalDate date = LocalDate.of(2014, 3, 18);
String s1 = date.format(DateTimeFormatter.BASIC_ISO_DATE); // 20140318
String s2 = date.format(DateTimeFormatter.ISO_LOCAL_DATE); // 2014-03-18
```

字符串转时间类型

```java
LocalDate date1 = LocalDate.parse("20140318", DateTimeFormatter.BASIC_ISO_DATE);
LocalDate date2 = LocalDate.parse("2014-03-18", DateTimeFormatter.ISO_LOCAL_DATE);
```

和老的 java.util.DateFormat 相比较， 所有的 **DateTimeFormatter 实例都是线程安全的**

按照自己喜欢的格式创建 DateTimeFormatter

```java
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
LocalDate dateILike = LocalDate.of(2021, 1, 27);
String formattedDate = dateILike.format(formatter); // 2021/01/27
LocalDate dateULike = LocalDate.parse(formattedDate, formatter);
```

创建一个本地化的 DateTimeFormatter

```java
LocalDate date = LocalDate.of(2021, 1, 27);
DateTimeFormatter chinaFormatter = DateTimeFormatter.ofPattern("yyyy MMMM d", Locale.CHINA);
String formattedDate = date.format(chinaFormatter);
System.out.println(formattedDate);
// 2021 一月 27
```

DateTimeFormatterBuilder **自定义时间格式**

```java
LocalDate date = LocalDate.of(2021, 1, 27);
DateTimeFormatter complexFormatter = new DateTimeFormatterBuilder()
        .appendText(ChronoField.YEAR)
        .appendLiteral(" 年 ")
        .appendText(ChronoField.MONTH_OF_YEAR)
        .appendLiteral(" ")
        .appendText(ChronoField.DAY_OF_MONTH)
        .appendLiteral(" 日 ")
        .parseCaseInsensitive()
        .toFormatter(Locale.CHINA);
// 2021 年 一月 27 日        
```

## 12.3 处理不同的时区和历法

新版 java.time.ZoneId 类

- 是老版 java.util.TimeZone 类的代替品
- 设计目标是让你无需为处理时区操碎了心
- ZoneId 类是不可变的

### 12.3.1 使用时区

```java
// ZoneId.of("区域/城市")
ZoneId shanghaiZone = ZoneId.of("Asia/Shanghai");
```

- 时区数据由 IANA 的时区数据库提供

将老的 TimeZone 转为 ZoneId

```java
ZoneId zoneId = TimeZone.getDefault().toZoneId();
```

ZoneId 对象可以整合下列对象构造 ZonedDateTime 实例

- LocalDate
- LocalDateTime
- Instant

```java
ZoneId shanghaiZone = ZoneId.of("Asia/Shanghai");

LocalDate date = LocalDate.of(2021, 1, 27);
ZonedDateTime zdt1 = date.atStartOfDay(shanghaiZone);
// 2021-01-27T00:00+08:00[Asia/Shanghai]
System.out.println(zdt1);

LocalDateTime dateTime = LocalDateTime.of(2021, 1, 27, 18, 13, 45);
ZonedDateTime zdt2 = dateTime.atZone(shanghaiZone);
// 2021-01-27T18:13:45+08:00[Asia/Shanghai]
System.out.println(zdt2);

Instant instant = Instant.now();
ZonedDateTime zdt3 = instant.atZone(shanghaiZone);
// 2021-01-27T23:47:02.923793+08:00[Asia/Shanghai]
System.out.println(zdt3);
```

图 12-1 理解 ZonedDateTime 可以很好的帮助理解它们的关系（详见书中插图）

- LocalDate : 年 月 日
- LocalTime : 时 分 秒
- ZoneId : 时区
- LocalDateTime : LocalDate + LocalTime = 年 月 日 时 分 秒
- ZonedDateTime : LocalDateTime + ZoneId = 年 月 日 时 分 秒 时区
