# Домашнее задание к занятию «Индексы» - Калиничева Оксана

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

### Решение 1

```
SELECT 
    ROUND(SUM(INDEX_LENGTH) / SUM(DATA_LENGTH) * 100, 2) AS "Процентное отношение размера индексов к размеру таблиц"
FROM 
    information_schema.TABLES
WHERE 
    TABLE_SCHEMA = 'sakila';
```
---

### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

### Решение 2

Узкие места и оптимизация:
1. Seq Scan on payment p и Filter: (date(payment_date) = '2005-07-30'::date): Необходимо добавить индекс на payment_date, чтобы ускорить поиск по дате.

2. Hash Join (cost=1.05..52.21 rows=10 width=16): Используется хеш-соединение, что может быть неэффективно при больших объемах данных. Необходимо добавить индексы на соединяемые столбцы payment.payment_date, rental.rental_date, rental.customer_id, и inventory.inventory_id.

Оптимизированный запрос:

```
EXPLAIN ANALYZE
SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS "Customer Name",
    SUM(p.amount) OVER (PARTITION BY c.customer_id, f.title) AS "Total Amount"
FROM 
    payment p
JOIN 
    rental r ON p.payment_date = r.rental_date
JOIN 
    customer c ON r.customer_id = c.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    p.payment_date = '2005-07-30';

CREATE INDEX payment_date_idx ON payment (payment_date);
CREATE INDEX rental_date_idx ON rental (rental_date);
CREATE INDEX rental_customer_id_idx ON rental (customer_id);
CREATE INDEX inventory_inventory_id_idx ON inventory (inventory_id);
```
---

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

*Приведите ответ в свободной форме.*