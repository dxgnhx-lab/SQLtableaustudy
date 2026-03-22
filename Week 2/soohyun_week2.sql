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