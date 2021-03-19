# MongoDB 入门

## 安装

- [Install MongoDB Community Edition on macOS](https://docs.mongodb.com/v4.2/tutorial/install-mongodb-on-os-x/)

```cmd
brew services start mongodb-community@4.2
```

```cmd
brew services stop mongodb-community@4.2
```

### 查看状态

```cmd
brew services list
```

或

```cmd
ps aux | grep -v grep | grep mongod
```

### 查看日志

```cmd
/usr/local/var/log/mongodb/mongo.log
```

### Installing the MongoDB Database Tools

```cmd
brew install mongodb-database-tools
```

```cmd
mongotop
```

## [MongoDB CRUD Operations](https://docs.mongodb.com/v4.2/crud/)

### 日常操作

清空 Doc

```mongodb
db.inventory.remove({})
```

#### 返回指定字段 Return the Specified Fields and the _id Field Only

有id

```mongodb
db.inventory.find( { status: "A" }, { item: 1, status: 1 } )
```

```sql
SELECT _id, item, status from inventory WHERE status = "A"
```

没有id

```mongodb
db.inventory.find( { status: "A" }, { item: 1, status: 1, _id: 0 } )
```

```sql
SELECT item, status from inventory WHERE status = "A"
```


## 开发工具

- [NoSQLBooster](https://nosqlbooster.com/)
- [Robo 3T](https://robomongo.org/) 收费
