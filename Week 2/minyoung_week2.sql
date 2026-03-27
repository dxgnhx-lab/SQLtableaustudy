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

-- 동하
/*
2007년 2월 한 달 동안, 날짜별로 발생하는 매출액과 
해당 날짜까지의 누적 매출액을 구하세요.
*/
select
	sales_date,
	daily_sales,
	sum(daily_sales) over (order by sales_date) as cumulative_sales
from (
	select
		date(payment_date) as sales_date,
		sum(amount) as daily_sales
	from payment
	where payment_date >= '2007-02-01'
		and payment_date < '2007-03-01'
	group by date(payment_date)
)
order by sales_date;

/*
고객별로 첫 번째 대여와 두 번째 대여 사이의 시간 간격(날짜 차이)을 
구하세요. (모든 고객을 구할 필요 없이, 2번 이상 빌린 고객만 대상)
*/
with ranked_rentals as (
	select
		customer_id,
		rental_date,
		row_number() over (
			partition by customer_id
			order by rental_date
		) as rn
	from rental
),
first_second as (
	select
		customer_id,
		max(case when rn = 1 then rental_date end) as first_rental_date,
		max(case when rn = 2 then rental_date end) as second_rental_date
	from ranked_rentals
	where rn <= 2
	group by customer_id
)
select
	customer_id,
	first_rental_date,
	second_rental_date,
	second_rental_date::date - first_rental_date::date as days_between
from first_second 
where second_rental_date is not null
order by customer_id;

/*
각 영화 카테고리별로 "전체 재고 수" 대비 "현재 대여 중인 수"의 비율을 
구하세요. 어떤 장르가 가장 활발하게 회전되고 있나요?
*/
with active_inventory as (
	select distinct inventory_id
	from rental
	where return_date is null
)
select
	c.name as category_name,
	count(i.inventory_id) as total_inventory_count,
	count(ai.inventory_id) as currently_rented_count,
	round (
		count(ai.inventory_id)::numeric / count(i.inventory_id),
		4
	) as rented_ratio
from category c
join film_category fc
	on c.category_id = fc.category_id
join inventory i
	on fc.film_id = i.film_id
left join active_inventory ai
	on i.inventory_id = ai.inventory_id
group by c.category_id, c.name
order by rented_ratio desc, currently_rented_count desc;

-- 수현
/*
[배우별 출연 영화 편수와 평균 대여 비용]
배우(actor)와 영화(film)는 film_actor 테이블을 통해 다대다(N:M) 관계로 연결되어 있습니다. 각 배우가 몇 편의 영화에 출연했는지와 해당 영화들의 평균 대여 가격(rental_rate)을 구하시오.

결과 컬럼: first_name, last_name, film_count, avg_rental_rate

정렬: 출연 영화 편수(film_count)가 많은 순으로 정렬하시오.
*/
select
	a.first_name,
	a.last_name,
	count(f.film_id) as film_count,
	round(avg(f.rental_rate), 2) as avg_rental_rate
from actor a
join film_actor fa
	on a.actor_id = fa.actor_id
join film f
	on fa.film_id = f.film_id
group by a.actor_id, a.first_name, a.last_name
order by film_count desc, a.last_name, a.first_name;

/*
[가장 많이 대여된 영화 TOP 10]
재고(inventory) 아이템이 실제로 대여(rental)된 횟수를 집계하여, 어떤 영화가 가장 인기가 많은지 확인하고자 합니다. 영화 제목별로 총 대여 횟수를 구하시오.

결과 컬럼: title, rental_count

정렬: 대여 횟수가 많은 순으로 상위 10개만 출력하시오.
*/
select
	f.title,
	count(r.rental_id) as rental_count
from film f
join inventory i
	on f.film_id = i.film_id
join rental r
	on i.inventory_id = r.inventory_id
group by f.film_id, f.title
order by rental_count desc, f.title
limit 10;

/*
[대여 기록이 없는 영화 목록 (재고 효율 분석)]
재고(inventory)에는 등록되어 있지만, 단 한 번도 대여(rental)된 적이 없는 영화를 찾아내어 재고 교체 대상을 선정하고자 합니다. (Outer Join 활용 권장)

결과 컬럼: film_title, inventory_id

조건: 대여 기록이 전혀 없는 영화만 출력하시오.
*/
select
	f.title as film_title,
	i.inventory_id
from inventory i
join film f
	on i.film_id = f.film_id
left join rental r
	on i.inventory_id = r.inventory_id
where r.rental_id is null
order by f.title, i.inventory_id;