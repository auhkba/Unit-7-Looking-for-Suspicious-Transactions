
CREATE TABLE "card_holder" (
    "id" INT   NOT NULL,
    "name" VARCHAR(255)   NOT NULL,
    CONSTRAINT "pk_card_holder" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "credit_card" (
    "card" VARCHAR(20)   NOT NULL,
    "cardholder_id" INT   NOT NULL,
    CONSTRAINT "pk_credit_card" PRIMARY KEY (
        "card"
     )
);

CREATE TABLE "merchant" (
    "id" INT   NOT NULL,
    "name" VARCHAR(255)   NOT NULL,
    "id_merchant_category" INT   NOT NULL,
    CONSTRAINT "pk_merchant" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "merchant_category" (
    "id" INT   NOT NULL,
    "name" VARCHAR(255)   NOT NULL,
    CONSTRAINT "pk_merchant_category" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "transation" (
    "id" INT   NOT NULL,
    "date" TIMESTAMP   NOT NULL,
    "amount" numeric(7,2)   NOT NULL,
    "card" VARCHAR(20)   NOT NULL,
    "id_merchant" INT   NOT NULL,
    CONSTRAINT "pk_transation" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "credit_card" ADD CONSTRAINT "fk_credit_card_cardholder_id" FOREIGN KEY("cardholder_id")
REFERENCES "card_holder" ("id");

ALTER TABLE "merchant" ADD CONSTRAINT "fk_merchant_id_merchant_category" FOREIGN KEY("id_merchant_category")
REFERENCES "merchant_category" ("id");

ALTER TABLE "transation" ADD CONSTRAINT "fk_transation_card" FOREIGN KEY("card")
REFERENCES "credit_card" ("card");

ALTER TABLE "transation" ADD CONSTRAINT "fk_transation_id_merchant" FOREIGN KEY("id_merchant")
REFERENCES "merchant" ("id");




create view small_transation AS
select cardholder_id, count(amount) as no_small_tr
from transation AS a
left join credit_card AS b 
    on (a.card = b. card)
    where amount < 2
group by cardholder_id
order by no_small_tr desc;

create view morning_transation AS
select id_merchant, count(id) as morning_trx, round(avg(amount),2) as avg_trx, max(amount) as max_trx, min(amount) as min_trx
from transation
where CAST(date as TIME) >= '07:00:00'
AND CAST(date as TIME) <= '09:00:00'
group by id_merchant
order by morning_trx desc;

select CAST(date as DATE),amount,card,id_merchant 
from transation
where card in
    (
    select card
    from credit_card
    where cardholder_id = 2
    );

select CAST(date as DATE),amount,card,id_merchant
from transation
where card in
    (
    select card
    from credit_card
    where cardholder_id = 18
    );

select CAST(date as DATE),amount,card,id_merchant, c.name
from transation a
left join merchant b on (a.id_merchant = b.id)
left join merchant_category c on (b.id_merchant_category = c.id)
where card in
    (
    select card
    from credit_card
    where cardholder_id = 25
        AND CAST(date as DATE) >= '2018-01-01'
        AND CAST(date as DATE) <= '2018-06-30'    
    );

select * from card_holder;
select * from transation;
select * from credit_card;
select * from merchant;
select * from merchant_category;


