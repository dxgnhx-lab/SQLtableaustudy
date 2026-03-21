-- 민영
/* 
[카테고리별 총 매출]
각 영화는 하나 이상의 카테고리에 속해 있으며, 고객이 영화를 대여하면 결제(payment)가 발생합니다.
대여된 영화가 어떤 카테고리에 속하는지를 기준으로, 카테고리별 총 매출을 구하시오.

결과 컬럼: category_name, total_sales
매출이 높은 순으로 정렬하시오.
*/
select
    c.name as category_name,
    sum(p.amount) as total_sales
from payment p
join rental r
    on p.rental_id = r.rental_id
join inventory i
    on r.inventory_id = i.inventory_id
join film f
    on i.film_id = f.film_id
join film_category fc
    on f.film_id = fc.film_id
join category c
    on fc.category_id = c.category_id
group by c.name
order by total_sales desc;

/*
[고객별 대여 횟수 순위]
고객별로 영화 대여 횟수를 집계하고,
대여 횟수가 많은 순서대로 순위를 매기시오.

결과 컬럼: customer_id, first_name, last_name, rental_count, rental_rank
RANK() 또는 DENSE_RANK()를 사용하시오.
*/
select
    c.customer_id,
    c.first_name,
    c.last_name,
    count(r.rental_id) as rental_count,
    rank() over (order by count(r.rental_id) desc) as rental_rank
from customer c
join rental r
    on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by rental_rank;

/*
[연체 반납 건수 분석]
각 영화는 대여 가능 기간(rental_duration)이 정해져 있습니다.
실제 대여일(rental_date)과 반납일(return_date)을 비교하여,
대여 가능 기간을 초과하여 반납된 건수를 영화별로 구하시오.

결과 컬럼: title, late_return_count
반납된 데이터만 포함하시오 (return_date IS NOT NULL)
연체 건수가 많은 순으로 정렬하시오.
*/
select
    f.title,
    count(*) as late_return_count
from rental r
join inventory i
    on r.inventory_id = i.inventory_id
join film f
    on i.film_id = f.film_id
where r.return_date is not null
  and (r.return_date::date - r.rental_date::date) > f.rental_duration
group by f.title
order by late_return_count desc;