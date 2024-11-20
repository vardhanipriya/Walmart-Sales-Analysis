create database walmart_sales;
use walmart_sales;
select * from walmart_sales_t;

## Generic Question
## How many unique cities does the data have?

select distinct City from walmart_sales_t;

## In which city is each branch?
select City,
max(Branch)
from walmart_sales_t
group by 1;

## Product

## How many unique product lines does the data have?

select count(distinct Productline) from walmart_sales_t;

## What is the most common payment method?

select Payment,
count(Payment)
from walmart_sales_t
group by 1
order by 2 desc
limit 1;

## What is the most selling product line?

select Productline,
count(Productline)
from walmart_sales_t
group by 1
order by 2 desc
limit 1;

## What is the total revenue by month?

select monthname(Date),
round(sum(Unitprice*Quantity),2)
from walmart_sales_t
group by 1;

## What month had the largest COGS?

select monthname(Date),
round(sum(Unitprice*Quantity),2)
from walmart_sales_t
group by 1
order by 2 desc
limit 1;

## What product line had the largest revenue?

select Productline,
round(sum(Unitprice*Quantity),2)
from walmart_sales_t
group by 1
order by 2 desc
limit 1;

## What is the city with the largest revenue?

select City,
round(sum(Unitprice*Quantity),2)
from walmart_sales_t
group by 1
order by 2 desc
limit 1;

## What product line had the largest VAT?

select Productline,
round(sum(Unitprice*Quantity),2) * 0.05 as VAT
from walmart_sales_t
group by 1
order by 2 desc
limit 1;

## Fetch each product line and add a column to those product line 
## showing "Good", "Bad". Good if its greater than average sales

select
Productline,
case when avg(Quantity) > (select avg(Quantity) from walmart_sales_t)
 then 'Good' else 'Bad' end as remark
 from walmart_sales_t
 group by 1;

##  Which branch sold more products than average product sold?

select Branch,
avg(Quantity)
from walmart_sales_t
group by 1
having avg(Quantity) > (select avg (Quantity) from walmart_sales_t);

## What is the most common product line by gender?



(select Gender,
Productline,
count(Productline)
from walmart_sales_t
where Gender = 'Male'
group by 1,2
order by 3 desc
limit 1)
union all
(select Gender,
Productline,
count(Productline)
from walmart_sales_t
where Gender = 'Female'
group by 1,2
order by 3 desc
limit 1);


## What is the average rating of each product line?

select Productline,
round(avg(Rating),2)
from walmart_sales_t
group by 1
order by 2;

## Sales

## Number of sales made in each time of the day per weekday


with time_of_day_t
as
(
select 
time,
InvoiceID,
case 
when Time between '10:00:00' and '12:00:00' then 'Morning' 
when Time between '12:01:00' and '17:00:00' then 'Afternoon'
when Time between '17:00:00' and '23:00:00' then 'Night'
else null end as time_of_the_day
from walmart_sales_t
)
select dayname(s.Date),
tm.time_of_the_day,
count(s.InvoiceID) as num_of_sales
from walmart_sales_t as s
join time_of_day_t as tm
on tm.InvoiceID = s.InvoiceID
group by 1,2
order by 3 desc;

## Which of the customer types brings the most revenue?

select 
Customertype,
round(sum(Unitprice*Quantity),2) as revenue
from walmart_sales_t
group by 1
order by 2 desc;

## Which city has the largest tax percent/ VAT (Value Added Tax)?

select
City,
round(sum(Unitprice*Quantity),2) * 0.05 as VAT
from walmart_sales_t
group by 1
order by 2 desc;

## Which customer type pays the most in VAT?

select
Customertype,
round(sum(Unitprice*Quantity),2) * 0.05 as VAT
from walmart_sales_t
group by 1
order by 2 desc;

## Customer

## How many unique customer types does the data have?

select distinct Customertype from walmart_sales_t;

## How many unique payment methods does the data have?

select distinct Payment from walmart_sales_t;

## What is the most common customer type?

select
Customertype,
count(Customertype)
from walmart_sales_t
group by 1
order by 2 desc;

## Which customer type buys the most?

select
Customertype,
round(sum(Quantity*Unitprice),2) as cogs,
count(*)
from walmart_sales_t
group by 1
order by 2 desc;

## What is the gender of most of the customers?

select
Gender,
count(Gender)
from walmart_sales_t
group by 1
order by 2 desc;

## What is the gender distribution per branch?

select 
Branch,
Gender,
count(Gender)
from walmart_sales_t
group by 1,2
order by 1,2 ;

## Which time of the day do customers give most ratings?

with time_of_day_t
as
(
select 
time,
InvoiceID,
case 
when Time between '10:00:00' and '12:00:00' then 'Morning' 
when Time between '12:01:00' and '17:00:00' then 'Afternoon'
when Time between '17:00:00' and '23:00:00' then 'Night'
else null end as time_of_the_day
from walmart_sales_t
)
select 
tm.time_of_the_day,
round(avg(s.Rating),2) as avg_ratings
from walmart_sales_t as s
join time_of_day_t as tm
on tm.InvoiceID = s.InvoiceID
group by 1
order by 2 desc;

## Which time of the day do customers give most ratings per branch?

with time_of_day_t
as
(
select 
time,
InvoiceID,
case 
when Time between '10:00:00' and '12:00:00' then 'Morning' 
when Time between '12:01:00' and '17:00:00' then 'Afternoon'
when Time between '17:00:00' and '23:00:00' then 'Night'
else null end as time_of_the_day
from walmart_sales_t
)
select s.Branch,
tm.time_of_the_day,
round(avg(s.Rating),2) as avg_of_ratings
from walmart_sales_t as s
join time_of_day_t as tm
on tm.InvoiceID = s.InvoiceID
group by 1,2
order by 3 desc;

## Which day of the week has the best avg ratings?

select
dayname(Date),
round(avg(Rating),2)
from walmart_sales_t
group by 1
order by 2 desc;

## Which day of the week has the best average ratings per branch?

select Branch,
dayname(Date),
round(avg(Rating),2)
from walmart_sales_t
group by 1,2
order by 3 desc;
