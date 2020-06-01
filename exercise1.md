# Exercise Day 2

1.  下面哪个是用来描述entity中元素的格式？

    A. Aspects

    B. Entities

    C. Associations

    D. Types

2. 下面哪两段代码符合命名规范？

```bash
entity books {
   key ID : UUID;
   title : String;
   genre : Genre;
   author : Association to Authors;
}
```

```bash
entity Books {
   key ID : UUID;
   title : String;
   genre : Genre;
   author : Association to Authors;
}
```

```bash
type genre: String enum {
  Mystery; Fiction; Drama;
}
```

```bash
type Genre: String enum {
  Mystery; Fiction; Drama;
}
```

```
entity Book {
   key ID : UUID;
   title : String;
   genre : Genre;
   author : Association to Authors;
}
```