service say {
    function hello (to:String) returns String;

    entity Books as select from db.Books excluding {price};

}

entity db.Books  {
    key id:UUID;
    title: String;
    author: Association to one db.Authors;
    price: Decimal(9,2);
}

entity db.Authors {
    key id: UUID;
    name: String;
}