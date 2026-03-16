-- 국가별 총 매출을 구하는 SQL을 짜줘.
-- country, city, address, customer, payment 테이블을 조인해야 해.
SELECT 
    c.country,
    SUM(p.amount) AS total_sales
FROM 
    country c
JOIN 
    city ci ON c.country_id = ci.country_id
JOIN
    address a ON ci.city_id = a.city_id
JOIN
    customer cu ON a.address_id = cu.address_id
JOIN
    payment p ON cu.customer_id = p.customer_id
GROUP BY
    c.country   
ORDER BY
    total_sales DESC;



