-- 동하
/*
2005년 5월 한 달 동안, 날짜별로 발생하는 매출액과 해당 날짜까지의 누적 매출액을 구하세요.
*/
-- 2005년 데이터가 없어서 2007년 3월로 문제 변경 후 풀이 진행
WITH daily_sales AS(
    SELECT
        DATE(payment_date) AS pay_date,
        SUM(amount) AS daily_revenue
    FROM payment
    WHERE payment_date >= '2007-03-01'
        AND payment_date < '2007-04-01'
    GROUP BY DATE(payment_date)
)
SELECT 
    pay_date,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY pay_date) AS cumulative_revenue
FROM 
    daily_sales
ORDER BY 
    pay_date

/*
 고객별로 첫 번째 대여와 두 번째 대여 사이의  시간 간격(날짜 차이)을 
 구하세요. (모든 고객을 구할 필요 없이, 2번 이상 빌린 고객만 대상)
*/
WITH rental_data AS (
    SELECT 
        customer_id,
        rental_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_seq,
        LEAD(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS next_rental_date
    FROM 
        rental
)
SELECT 
    customer_id,
    rental_date AS first_rental_date,
    next_rental_date AS second_rental_date,
    (next_rental_date - rental_date) AS time_between_rentals
FROM 
    rental_data
WHERE 
    rental_seq = 1 
    AND next_rental_date IS NOT NULL

/*
각 영화 카테고리별로 "전체 재고 수" 대비 "현재 대여 중인 수"의 비율을 
구하세요. 어떤 장르가 가장 활발하게 회전되고 있나요?
*/
WITH inventory_status AS (
    SELECT 
        i.inventory_id,
        i.film_id,
        -- 반납되지 않은 대여기록(rental_id)이 존재하면 1(대여 중), 없으면 0(재고 있음)
        CASE WHEN r.rental_id IS NOT NULL THEN 1 ELSE 0 END AS is_rented
    FROM 
        inventory i
    LEFT JOIN 
        rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
)
SELECT 
    c.name AS category_name,
    COUNT(inv.inventory_id) AS total_inventory,
    SUM(inv.is_rented) AS currently_rented_count,
    -- (대여 중인 수 / 전체 재고 수) * 100을 통해 퍼센트(%) 계산 후 소수점 2자리 반올림
    ROUND(SUM(inv.is_rented) * 100.0 / COUNT(inv.inventory_id), 2) AS rental_ratio_pct
FROM 
    category c
JOIN 
    film_category fc ON c.category_id = fc.category_id
JOIN 
    inventory_status inv ON fc.film_id = inv.film_id
GROUP BY 
    c.name
ORDER BY 
    rental_ratio_pct DESC

-- 민영
/* 
[카테고리별 총 매출]
각 영화는 하나 이상의 카테고리에 속해 있으며, 고객이 영화를 대여하면 결제(payment)가 발생합니다.
대여된 영화가 어떤 카테고리에 속하는지를 기준으로, 카테고리별 총 매출을 구하시오.

결과 컬럼: category_name, total_sales
매출이 높은 순으로 정렬하시오.
*/
SELECT 
    c.name AS category_name,
    SUM(p.amount) AS total_sales
FROM 
    category c
JOIN 
    film_category fc ON c.category_id = fc.category_id
JOIN 
    inventory i ON fc.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    payment p ON r.rental_id = p.rental_id
GROUP BY 
    c.name
ORDER BY 
    total_sales DESC

/*
[고객별 대여 횟수 순위]
고객별로 영화 대여 횟수를 집계하고,
대여 횟수가 많은 순서대로 순위를 매기시오.

결과 컬럼: customer_id, first_name, last_name, rental_count, rental_rank
RANK() 또는 DENSE_RANK()를 사용하시오.
*/
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count,
    RANK() OVER (ORDER BY COUNT(r.rental_id) DESC) AS rental_rank
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY 
    rental_rank

/*
[연체 반납 건수 분석]
각 영화는 대여 가능 기간(rental_duration)이 정해져 있습니다.
실제 대여일(rental_date)과 반납일(return_date)을 비교하여,
대여 가능 기간을 초과하여 반납된 건수를 영화별로 구하시오.

결과 컬럼: title, late_return_count
반납된 데이터만 포함하시오 (return_date IS NOT NULL)
연체 건수가 많은 순으로 정렬하시오.
*/
SELECT 
    f.title,
    COUNT(r.rental_id) AS late_return_count
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.return_date IS NOT NULL
    AND (r.return_date - r.rental_date) > (f.rental_duration * INTERVAL '1 day')
GROUP BY 
    f.title
ORDER BY 
    late_return_count DESC

-- 수현
/*
[배우별 출연 영화 편수와 평균 대여 비용]
배우(actor)와 영화(film)는 film_actor 테이블을 통해 다대다(N:M) 관계로 연결되어 있습니다. 각 배우가 몇 편의 영화에 출연했는지와 해당 영화들의 평균 대여 가격(rental_rate)을 구하시오.

결과 컬럼: first_name, last_name, film_count, avg_rental_rate

정렬: 출연 영화 편수(film_count)가 많은 순으로 정렬하시오.
*/
SELECT
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) film_count,
    ROUND(AVG(f.rental_rate),2) avg_rental_rate
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY first_name, last_name
ORDER BY film_count DESC

/*
[가장 많이 대여된 영화 TOP 10]
재고(inventory) 아이템이 실제로 대여(rental)된 횟수를 집계하여, 어떤 영화가 가장 인기가 많은지 확인하고자 합니다. 영화 제목별로 총 대여 횟수를 구하시오.

결과 컬럼: title, rental_count

정렬: 대여 횟수가 많은 순으로 상위 10개만 출력하시오.
*/
SELECT
    f.title title,
    COUNT(r.rental_id) rental_count
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY title
ORDER BY rental_count DESC
LIMIT 10

/*
[대여 기록이 없는 영화 목록 (재고 효율 분석)]
재고(inventory)에는 등록되어 있지만, 단 한 번도 대여(rental)된 적이 없는 영화를 찾아내어 재고 교체 대상을 선정하고자 합니다.

결과 컬럼: film_title, inventory_id

조건: 대여 기록이 전혀 없는 영화만 출력하시오.
*/
SELECT
    f.title film_title,
    i.inventory_id
FROM film f
JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IS NULL