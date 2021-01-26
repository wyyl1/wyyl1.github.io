## 第 8 章 Collection API 的增强功能
### 8.1 集合工厂
Arrays.asList
- 创建一个固定大小的列表
- 列表的元素可以更新
- 列表的元素不能增加、删除
```java
List<String> friends = Arrays.asList("Raphael", "Olivia");
```
#### 8.1.1 List 工厂
List.of 创建一个列表
- 创建的是一个只读列表
- 可以更新元素
- 不能添加、删除元素
```java
List<String> friends5 = List.of("Raphael", "Olivia", "Thibaut");
```
#### 8.1.2 Set 工厂
Set.of
```java
Set<String> friends = Set.of("Raphael", "Olivia", "Thibaut");
```
#### 8.1.3 Map 工厂
- Map.of
- Map.ofEntries
```java
 private static void creatingMaps() {
    System.out.println("--> Creating a Map with Map.of()");
    Map<String, Integer> ageOfFriends = Map.of("Raphael", 30, "Olivia", 25, "Thibaut", 26);
    System.out.println(ageOfFriends);

    System.out.println("--> Creating a Map with Map.ofEntries()");
    Map<String, Integer> ageOfFriends2 = Map.ofEntries(
        entry("Raphael", 30),
        entry("Olivia", 25),
        entry("Thibaut", 26));
    System.out.println(ageOfFriends2);
  }
```
### 8.2 使用 List 和 Set
因为集合的修改烦琐且容易出错，所以添加了两个方法解决这个问题：
- removeIf
- replaceAll

```java
List<Integer> list = new ArrayList<>();
list.add(1);
list.add(2);
list.add(30);
```
```java
list.removeIf(i -> i > 10);
// [1, 2]
```
```java
list.replaceAll(i -> i > 10 ? i / 10 : i);
// [1, 2, 3]
```
### 8.3 使用 Map
- forEach 遍历 Map
- 排序
    - [Entry.comparingByKey](#Map.Entry.comparingByKey)
    - Entry.comparingByValue
- getOrDefault 方法
    - 解决要查找的键在 Map 中不存在
    - 第一个参数作为键，第二个参数为默认值
- 计算模式
    - [computeIfAbsent](#computeIfAbsent)：给指定的键添加新的值（与原来的值进行合并操作）
    - [computeIfPresent](#computeIfPresent)：如果指定的键在 Map 中存在，使用新值替换旧值；如果不存在，Map 内容无变化
    - [compute](#compute)：添加键值对
        - 键已存在：更新值
        - 键不存在：新增值
    - [remove](#remove)：删除数据
        - remove(Object key, Object value) 可以防止误删数据
- 替换模式（8.3.6）
    - [replaceAll](#replaceAll)：
        - 改变 Map 中所有键的值
        - 不能改变 Map 中键
    - replace(K key, V value)
    - replace(K key, V oldValue, V newValue)
- merge 方法（8.3.7）
    - [处理键冲突时的情况](#merge)
    - [简化代码](#merge-简化代码)

#### Map.Entry.comparingByKey
```java
        Map<String, String> favouriteMovies = Map.ofEntries(
                entry("Raphael", "Star Wars"),
                entry("Cristina", "Matrix"),
                entry("Olivia", "James Bond"));
        favouriteMovies.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .forEachOrdered(System.out::println);
```
#### computeIfAbsent
```java
        Map<String, List<String>> friendsToMovies = new HashMap<>();

        String friend = "小刚";
        friendsToMovies.computeIfAbsent(friend, name -> new ArrayList<>())
                .add("星球大战");
        System.out.println(friendsToMovies);
        // {小刚=[星球大战]}
        friendsToMovies.computeIfAbsent(friend, name -> new ArrayList<>())
                .add("星际争霸");
        System.out.println(friendsToMovies);
        // {小刚=[星球大战, 星际争霸]}
        friendsToMovies.computeIfAbsent(friend, name -> new ArrayList<>())
                .add("星际争霸");
        System.out.println(friendsToMovies);
        // {小刚=[星球大战, 星际争霸, 星际争霸]}
```
#### computeIfPresent
```java
        Map<String, List<String>> gameMap = new HashMap<>();

        String friend = "小刚";
        gameMap.computeIfAbsent(friend, name -> new ArrayList<>())
                .add("星球大战");
        System.out.println(gameMap);
        //{小刚=[星球大战]}
        gameMap.computeIfPresent(friend, (k, v) -> List.of("星际争霸"));
        System.out.println(gameMap);
        // {小刚=[星际争霸]}
        gameMap.computeIfPresent(friend, (k, v) -> List.of("暗黑3", "地球时代"));
        System.out.println(gameMap);
        // {小刚=[暗黑3, 地球时代]}
        gameMap.computeIfPresent("没有这个键", (k, v) -> List.of("消消乐"));
        System.out.println(gameMap);
        // {小刚=[暗黑3, 地球时代]}
```
#### compute
```java
        Map<String, List<String>> gameMap = new HashMap<>();

        String friend = "小刚";
        gameMap.computeIfAbsent(friend, name -> new ArrayList<>())
                .add("星球大战");
        System.out.println(gameMap);
        //{小刚=[星球大战]}
        gameMap.compute(friend, (k, v) -> List.of("星际争霸"));
        System.out.println(gameMap);
        // {小刚=[星际争霸]}
        gameMap.compute(friend, (k, v) -> List.of("暗黑3", "地球时代"));
        System.out.println(gameMap);
        // {小刚=[暗黑3, 地球时代]}
        gameMap.compute("又来一个键", (k, v) -> List.of("红警"));
        System.out.println(gameMap);
        // {小刚=[暗黑3, 地球时代], 又来一个键=[红警]}
```
#### remove
```java
        Map<String, String> gameMap = new HashMap<>();
        gameMap.put("暴雪1", "魔兽争霸");
        gameMap.put("暴雪2", "暗黑3");
        gameMap.put("暴雪3", "守望先锋");

        // 防止误删数据
        gameMap.remove("暴雪1", "疯狂的麦克斯");
        System.out.println(gameMap);
        // {暴雪1=魔兽争霸, 暴雪3=守望先锋, 暴雪2=暗黑3}
        gameMap.remove("暴雪1", "魔兽争霸");
        System.out.println(gameMap);
        // {暴雪3=守望先锋, 暴雪2=暗黑3}
```
#### replaceAll
```java
        Map<String, String> gameMap = new HashMap<>();
        gameMap.put("blizzard1", "starcraft2");
        gameMap.put("blizzard2", "diablo4");
        gameMap.put("blizzard3", "warcraft3");

        gameMap.replaceAll((k, v) -> v.toUpperCase());
        System.out.println(gameMap);
        // {blizzard3=WARCRAFT3, blizzard2=DIABLO4, blizzard1=STARCRAFT2}
        // 不能改变 key 的值
        gameMap.replaceAll((k, v) -> k.toUpperCase());
        System.out.println(gameMap);
        // {blizzard3=BLIZZARD3, blizzard2=BLIZZARD2, blizzard1=BLIZZARD1}
```
#### merge
```java
        Map<String, String> family = Map.ofEntries(
                entry("Teo", "Star Wars"),
                entry("Cristina", "James Bond"));
        Map<String, String> friends = Map.ofEntries(entry("Raphael", "Star Wars"));

        System.out.println("--> Merging the old way, 当键重复时会被覆盖");
        Map<String, String> everyone = new HashMap<>(family);
        everyone.putAll(friends);
        System.out.println(everyone);
        // {Cristina=James Bond, Raphael=Star Wars, Teo=Star Wars}

        Map<String, String> friends2 = Map.ofEntries(
                entry("Raphael", "Star Wars"),
                entry("Cristina", "Matrix"));

        System.out.println("--> Merging maps using merge(), 可以处理键重复时的情况");
        Map<String, String> everyone2 = new HashMap<>(family);
        friends2.forEach((k, v) -> everyone2.merge(k, v, (movie1, movie2) -> movie1 + " & " + movie2));
        System.out.println(everyone2);
        // {Raphael=Star Wars, Cristina=James Bond & Matrix, Teo=Star Wars}
```
#### merge 简化代码
```java
        Map<String, Integer> gameMap = new HashMap<>();
        String gameName = "巫师3";
        Integer count = gameMap.get(gameName);
        if (count == null) {
            gameMap.put(gameName, 1);
        } else {
            gameMap.put(gameName, count + 1);
        }
        System.out.println(gameMap);
        // {巫师3=1}

        // 简化代码
        gameMap.merge(gameName, 1, (k, v) -> v + 1);
        System.out.println(gameMap);
        // {巫师3=2}

        gameMap.merge("英雄无敌", 1, (k, v) -> v + 1);
        System.out.println(gameMap);
        // {英雄无敌=1, 巫师3=2}
```
### 8.4 改进的 ConcurrentHashMap
推荐使用 mappingCount 代替 size 方法