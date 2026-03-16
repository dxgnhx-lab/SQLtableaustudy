/*국가별 총 매출을 구하시오.
각 고객은 특정 주소에 연결되어 있으며, 해당 주소는 도시와 국가 정보를 포함하고 있습니다. 
\또한 고객이 영화를 대여하면 결제(payment)가 발생합니다. 고객의 거주 국가 정보를 기준으로, 
각 국가에서 발생한 전체 결제 금액의 합계를 계산하여 국가별 총 매출을 구하시오.*/
select
    co.country as country_name,
    sum(p.amount) as total_sales
from payment p
join customer cu on p.customer_id = cu.customer_id
join address a on cu.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
group by co.country
order by total_sales desc;

/*
도시별 고객 수를 구하시오.
각 고객은 하나의 주소를 가지고 있으며, 주소는 특정 도시(city)에 속해 있습니다. 
고객이 거주하는 도시를 기준으로 고객 수를 집계하여, 각 도시별로 몇 명의 고객이 등록되어 있는지 계산하시오.
*/
select
    ci.city as city_name,
    count(cu.customer_id) as customer_cnt
from customer cu
join address a on cu.address_id = a.address_id
join city ci on a.city_id = ci.city_id
group by ci.city
order by customer_cnt desc, city_name asc;

/*
카테고리별 영화 수를 구하시오.
각 영화는 하나 이상의 카테고리에 속할 수 있으며, 영화와 카테고리 간의 관계는 별도의 연결 테이블을 통해 관리됩니다. 
영화가 속한 카테고리를 기준으로 카테고리별 영화 수를 집계하여, 각 카테고리에 몇 편의 영화가 존재하는지 계산하시오.
*/
select
    c.name as category_name,
    count(fc.film_id) as film_cnt
from category c
join film_category fc on c.category_id = fc.category_id
group by c.category_id
order by film_cnt desc;

/*
월별 매출을 구하시오.
고객이 영화를 대여하면 결제(payment)가 발생하며, 각 결제에는 결제 날짜(payment_date)가 기록되어 있습니다. 
결제가 발생한 날짜를 기준으로 연도와 월 단위로 데이터를 그룹화하여, 각 월별 총 결제 금액을 계산하시오.
*/
select
date_trunc('month', payment_date) as month,
sum(amount)
from payment
group by date_trunc('month', payment_date);

/*
배우별 출연 영화 수를 구하시오.
배우와 영화는 다대다 관계로 연결되어 있으며, 이를 위해 별도의 연결 테이블이 사용됩니다. 
각 배우가 출연한 영화의 수를 집계하여, 배우별로 몇 편의 영화에 출연했는지 계산하시오.
*/
select
    a.first_name,
    a.last_name,
    count(fa.film_id)
from film_actor fa
join actor a on fa.actor_id = a.actor_id
group by a.first_name, a.last_name
order by count(fa.film_id) desc;