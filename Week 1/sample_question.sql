/*
문제 1
film 테이블에서 교체 비용(replacement_cost)이 20달러 이상이고 25달러 이하인 영화의 제목(title)과 교체 비용을 나열하세요.
*/
-- TODO: 문제 1 SQL 작성
select title, replacement_cost from film
where replacement_cost between 20 and 25;

/*
문제 2
customer 테이블에서 매장 ID(store_id)가 2번인 고객 중 비활성화된(active = 0) 고객의 이메일(email) 목록을 조회하세요.
*/
-- TODO: 문제 2 SQL 작성
select email from customer
where store_id = 2 and active  =0;


/*
문제 3
address 테이블에서 구역(district)이 'California'이거나 'Texas'인 지역의 상세 주소(address)와 전화번호(phone)를 찾아보세요.
*/
-- TODO: 문제 3 SQL 작성
select address, phone, district from address
where district = 'California' or district = 'Texas';

/*
문제 4
actor 테이블에서 성(last_name)에 'LI'가 포함되면서, 이름(first_name)은 'C'로 시작하는 배우를 찾고, 결과를 성(last_name) 알파벳 오름차순으로 정렬하세요.
*/
-- TODO: 문제 4 SQL 작성
select first_name, last_name from actor
where last_name ilike '%LI%' and first_name ilike 'C%'
order by last_name asc;

/*
문제 5
rental 테이블에서 반납일(return_date)이 아직 비어있는(즉, 아직 반납되지 않고 대여 중인) 대여 기록의 대여 ID(rental_id)와 대여일(rental_date)을 최근 대여일 순으로 딱 15개만 뽑아보세요.
*/
-- TODO: 문제 5 SQL 작성
select rental_id, rental_date from rental
where return_date is null
order by rental_date desc
limit 15;

/*
문제 6
film 테이블에서 영화 설명(description)에 'Documentary'라는 단어가 포함된 영화들의 제목(title)과 대여 기간(rental_duration)을 대여 기간이 짧은 순으로 조회하세요.
*/
-- TODO: 문제 6 SQL 작성
select title, rental_duration from film
where description ilike '%Documentary%'
order by rental_duration asc;

/*
문제 7
payment 테이블에서 직원 ID(staff_id)가 1번인 직원이 처리한 결제 중, 결제 금액(amount)이 0.99 달러이거나 1.99 달러인 내역을 찾아 최신 결제일(payment_date) 기준으로 정렬해 보세요.
*/
-- TODO: 문제 7 SQL 작성
select amount, payment_date from payment
where staff_id = 1 and amount in (0.99, 1.99)
order by payment_date desc;

/*
문제 8
customer 테이블에서 이름(first_name)의 글자 수가 딱 4글자인 고객의 이름과 성(last_name)을 추출하세요. (힌트: LIKE에 언더바(_)를 활용하거나 길이 함수를 찾아보세요.)
*/
-- TODO: 문제 8 SQL 작성
select first_name, last_name from customer
where first_name ilike '____';

/*
문제 9
payment 테이블에서 2007년 2월 15일 이후에 결제된 내역 중, 결제 금액(amount)이 5달러를 초과하는 결제 건의 고객 ID(customer_id)와 결제일(payment_date)을 조회하세요.
*/
-- TODO: 문제 9 SQL 작성
select customer_id, payment_date from payment
where payment_date > '2007-02-15' and amount > 5;

/*
문제 10
film 테이블에서 영화 등급(rating)이 'R'이면서 렌탈 비용(rental_rate)이 2.99달러 이하이고 상영 시간(length)이 90분 미만인 '짧고 저렴한 R등급 영화' 제목들을 모두 찾아보세요.
*/
-- TODO: 문제 10 SQL 작성
select title from film
where rating = 'R' and rental_rate <= 2.99 and length < 90
order by title asc;