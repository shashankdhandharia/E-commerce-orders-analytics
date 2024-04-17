-- Creating table orders in SQL server database

CREATE TABLE orders
(
    order_id int primary key,
    order_date	datetime,
    ship_mode VARCHAR(20),
    segment	VARCHAR(20),
    country	VARCHAR(20),
    city	VARCHAR(20),
    state	VARCHAR(20),
    postal_code	INT,
    region	VARCHAR(20),
    category	VARCHAR(20),
    sub_category	VARCHAR(20),
    product_id	VARCHAR(20),
    quantity	INT,
    discount	decimal(7,2),
	sale_price decimal(7,2),
	profit decimal(7,2)
);






--Top 10 highest revene generating products

select top 10 product_id,sum(sale_price) as sm
from orders 
group by product_id
order by sm desc










--Top 5 highest selling product in each region

with t1 as(
select region,product_id,sum(sale_price) as sm from orders
group by region,product_id
--order by region,sm desc
)
,t2 as(
select *,row_number() over(partition by region order by sm desc) as rn
from t1
)
select region,product_id from t2
where rn<=5









-- Month over month growth comparison for 2022 and 2023 sales


with t1 as(
select datepart(year,order_date) as yr,datepart(month,order_date) as mon,
sum(case when datepart(year,order_date)='2022' then sale_price else null end) as 'sales22',
sum(case when datepart(year,order_date)='2023' then sale_price else null end) as 'sales23'
from orders
group by datepart(year,order_date) ,datepart(month,order_date) 
--order by datepart(year,order_date) ,datepart(month,order_date)
)

select top 12
case when x.mon='1' then 'Jan'
when x.mon='2' then 'Feb'
when x.mon='3' then 'Mar'
when x.mon='4' then 'Apr'
when x.mon='5' then 'May'
when x.mon='6' then 'Jun'
when x.mon='7' then 'Jul'
when x.mon='8' then 'Aug'
when x.mon='9' then 'Sep'
when x.mon='10' then 'Oct'
when x.mon='11' then 'Nov'
when x.mon='12' then 'Dec'
end as Month,
x.sales22 as '2022',
y.sales23 as '2023'
from t1 x join t1 y on x.mon=y.mon and x.yr<>y.yr
order by x.yr,x.mon








--For each category which month had highest sales


with t1 as (
select category,datepart(month,order_date) as dt_mon,datepart(year,order_date) as dt_yr,sum(sale_price) as sm
from orders
group by category,datepart(month,order_date),datepart(year,order_date)
--order by category,datepart(month,order_date),datepart(year,order_date)
),
t2 as(
select *,row_number() over(partition by category order by sm desc) as rn
from t1
)
--select * from t2
select category,
case when dt_mon='1' and dt_yr='2022' then 'Jan 2022'
when dt_mon='2' and dt_yr='2022' then 'Feb 2022'
when dt_mon='3' and dt_yr='2022' then 'Mar 2022'
when dt_mon='4' and dt_yr='2022' then 'Apr 2022'
when dt_mon='5' and dt_yr='2022' then 'May 2022'
when dt_mon='6' and dt_yr='2022' then 'Jun 2022'
when dt_mon='7' and dt_yr='2022' then 'Jul 2022'
when dt_mon='8' and dt_yr='2022' then 'Aug 2022'
when dt_mon='9' and dt_yr='2022' then 'Sep 2022'
when dt_mon='10' and dt_yr='2022' then 'Oct 2022'
when dt_mon='11' and dt_yr='2022' then 'Nov 2022'
when dt_mon='12' and dt_yr='2022' then 'Dec 2022'
when dt_mon='1' and dt_yr='2023' then 'Jan 2023'
when dt_mon='2' and dt_yr='2023' then 'Feb 2023'
when dt_mon='3' and dt_yr='2023' then 'Mar 2023'
when dt_mon='4' and dt_yr='2023' then 'Apr 2023'
when dt_mon='5' and dt_yr='2023' then 'May 2023'
when dt_mon='6' and dt_yr='2023' then 'Jun 2023'
when dt_mon='7' and dt_yr='2023' then 'Jul 2023'
when dt_mon='8' and dt_yr='2023' then 'Aug 2023'
when dt_mon='9' and dt_yr='2023' then 'Sep 2023'
when dt_mon='10' and dt_yr='2023' then 'Oct 2023'
when dt_mon='11' and dt_yr='2023' then 'Nov 2023'
when dt_mon='12' and dt_yr='2023' then 'Dec 2023'
end as 'month',sm as sale_price
from t2
where rn=1







--Sub category having highest growth of profit in 2023 compared to 2022


with t1 as(
select sub_category,format(order_date,'yyyy') as dt,sum(profit) as sm
from orders
group by sub_category,format(order_date,'yyyy')
--order by 1,2,3
)

select top 1 sub_category,max(sm)-min(sm) as profit
from t1
group by sub_category
order by profit desc