---
title: "更多笔记"
date: 2022-11-22T00:00:01+08:20
draft: true
tags: ["更多笔记"]
categories: ["代码精进之路 从码农到工匠"]
---

[《代码精进之路 从码农到工匠》学习笔记目录](../dir)

> 原书：《代码精进之路 从码农到工匠》 | 作者：张建飞

## 3.7 精简辅助代码

Java 中使用 Optional 优化判空，但 **Optional 自身为 null 时也会报 NullPointerException**

被嫌弃的代码

```java
if(user !=null){
    Address address = user.getAddress();
    if(address != null){
        PhoneNumber phoneNumber = address.getPhoneNumber();
        if(phoneNumber != null){
            log.info("用户的电话号码={}", phoneNumber.getNumber());
        }
    }
}
```

消除 if 语句的代码：用户电话号码提取器

```java
import java.util.Optional;

public class PhoneNumberExtractor {

    public final static Integer extract(User user) {
        return Optional.ofNullable(user)
                // address 为 null 时，可以返回默认值 0
                .map(User::getAddress).orElse(Optional.empty())
                // phoneNumber 为 null 时，抛出空指针异常
                .flatMap(Address::getPhoneNumber)
                .map(PhoneNumber::getNumber)
                .orElse(0);
    }
}
```

```java
import java.util.Optional;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

class PhoneNumberExtractorTest {

    @Test
    void return_0_when_user_is_null() {
        Integer phoneNumber = PhoneNumberExtractor.extract(null);

        assertThat(phoneNumber).isEqualTo(0);
    }

    @Test
    void return_0_when_address_is_null() {
        Integer phoneNumber = PhoneNumberExtractor.extract(User.builder().address(null).build());

        assertThat(phoneNumber).isEqualTo(0);
    }

    @Test
    void throws_NullPointerException_when_phone_number_is_null() {
        Optional<Address> address = Optional.of(Address.builder().phoneNumber(null).build());
        User user = User.builder().address(address).build();

        Assertions.assertThrows(NullPointerException.class, () -> PhoneNumberExtractor.extract(user));
    }
}
```

```java
import lombok.Builder;
import lombok.Getter;

import java.util.Optional;

@Builder
@Getter
public class User {
    private Optional<Address> address;
}

@Builder
@Getter
public class Address {
    private Optional<PhoneNumber> phoneNumber;
}

@Builder
@Getter
public class PhoneNumber {
    private Integer number;
}
```

## 4.1 SOLID 设计原则

> SOLID 是 5 个设计原则开头字母的缩写，本身就有“稳定的”意思，寓意是 “尊从 SOLID 原则可以建立**稳定、灵活、健壮**的系统”

- Single Responsibility Principle (SRP): 单一职责原则
- Open Close Principle (OCP): 开闭原则
- Liskov Substiution Principle (LSP): 里氏替换原则
- Interface Segregation Principle (ISP): 接口隔离原则
- Dependency Inversion Principle (DIP): 依赖倒置原则

> **开闭原则、里氏替换原则是设计目标，其他 3 个是设计方法**

## 待学习

- 3.7.2 优化缓存判断
- 3.7.3 优雅降级
- 3.8 组合函数模式(组合函数模式出自 Kent Beck 的《Smalltalk Best Practice Patterns》)
- 3.10 函数编程
  - 减少冗余代码，让代码更简洁、可读性更好
  - “无副作用”，都是线程安全的不可变对象