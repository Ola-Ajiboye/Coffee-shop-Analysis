select * from coffee_sales

-- TOTALS SALES FOR EACH RESPECTIVE MONTHLY
select 
Concat(Round(sum(transaction_qty * unit_price)/100, 0),'k') 
as Total_sales
from coffee_sales
where 
Month(transaction_date) = 6 --June

-- MONTH ON MONTH INCREASE 0R DECREASE
--selected month (CM) = 6 June
-- previous month (PM) = 5 May
Select 
Month(transaction_date) as Month,
Concat(Round(sum(transaction_qty* unit_price),2),'k') as Total_month,
(sum(transaction_qty* unit_price) - lag(sum(transaction_qty* unit_price),1) -- difference
Over(order by month(transaction_date))) / lag(sum(transaction_qty* unit_price),1)
Over(order by month(transaction_date)) * 100 as MoM_Percentage
From coffee_sales
Where month(transaction_date) in (5,6) -- May and June
Group by month(transaction_date)
Order by month(transaction_date)

--TOTAL ORDER FOR EACH RESPECTIVE MONTH
Select count(transaction_id) Total_Order
From coffee_sales
where Month(transaction_date) = 6 -- June

-- MONTH ON MONTH INCREASE 0R DECREASE
--selected month (CM) = 6 June
-- previous month (PM) = 5 May
Select
Month(transaction_date) As Month,
Count(transaction_id) As Total_order,
(cast(count(transaction_id) as decimal(10,2)) - Lag(count(transaction_id), 1)
over(order by Month(transaction_date))) / Lag(count(transaction_id), 1)
over(order by Month(transaction_date)) *100 as MoM_percentage
From coffee_sales
where Month(transaction_date) in (5,6)
Group by Month(transaction_date)
Order by Month(transaction_date)

--TOTAL QUALITY SOLD FOR EACH RESPECTIVE MONTH
Select 
sum(transaction_qty) as Total_qty_sold
from coffee_sales
where month(transaction_date) = 6

-- MONTH ON MONTH INCREASE 0R DECREASE
--selected month (CM) = 6 June
-- previous month (PM) = 5 May
Select
Month(transaction_date) as month,
sum(transaction_qty) as Total_sold,
(cast(sum(transaction_qty) as decimal (10,2)) - Lag(sum(transaction_qty), 1)
over(order by month(transaction_date)))/ lag(sum(transaction_qty),1)
over(order by month(transaction_date)) *100 as mom_percentage
from coffee_sales
where 
month(transaction_date) in (5,6)
group by 
month(transaction_date)
order by 
month(transaction_date)

--CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS
select 
concat(Round(Sum(transaction_qty * unit_price)/1000,1),'K') as Total_Sales,
concat(Round(Count(transaction_id)/1000,1), 'K') as Total_Order,
concat(Round(Sum(transaction_qty)/ 1000,1),'K') as Total_Qty_Sold
From coffee_sales
Where
transaction_date = '2023-05-18'

-- SALES ANALYSIS BY WEEKENDS AND WEEKDAYS
-- Sun = 1
-- Mon = 2....
-- Sat = 7

select
	case when datepart(dw,transaction_date) in (1,7) then 'weekends'
	else 'weekdays'
	end as weeks,
	concat(round(Sum(transaction_qty * unit_price)/100,2),'K') as Total_sales
	from coffee_sales
	where Month(transaction_date) = 5
	group by 
		case when datepart(dw,transaction_date) in (1,7) then 'weekends'
	else 'weekdays'
	end

--SALES ANALYSIS BY STORE LOCATION
select
Store_location,
concat(round(Sum(transaction_qty*unit_price)/1000,2),'K') as Total_sales
from coffee_sales
where month(transaction_date) = 6
group by Store_location
order by Store_location

--DAILY SALES ANALYSIS WITH AVAERAGE 
select
	concat(round(Avg(total_sales)/1000,1),'K') as Average_sales
	from (
	select
	sum(transaction_qty * unit_price) as total_sales
	from coffee_sales
	where month(transaction_date) = 6
	group by transaction_date
	) as iner

	--DAILY

	select 
		day(transaction_date) as Day_of_Month,
		concat(round(sum(transaction_qty * unit_price)/1000,1),'K') as Total_sales
		from coffee_sales
		where month(transaction_date) = 6
		group by day(transaction_date)
		order by day(transaction_date)

--WITH AVERAGE
	select
		Day_of_Month,
			case 
			when total_sales > Avg_sales then 'Above average'
			when total_sales < Avg_sales then 'Below average'
			else 'average'
			end as sales_status,
			Total_sales
	from(
		select 
		day(transaction_date) as Day_of_Month,
		sum(transaction_qty * unit_price) as total_sales,
		avg(sum(transaction_qty * unit_price)) over () as Avg_sales
		from coffee_sales
		where month(transaction_date) = 5
		group by day(transaction_date)
		) as sales
		order by Day_of_Month
		


-- SALES ANALYSIS PRODUCT CATEGORY
select
	product_category,
	concat(round(sum(transaction_qty * unit_price)/1000,2),'K') as Total_Sales
	from coffee_sales
	where month(transaction_date) = 6
	group by product_category 
	order by Total_Sales desc

-- TOP 10 PRODUCT BY SALES
select top 10
	product_type,
	concat(round(Sum(transaction_qty*unit_price)/1000,2),'K') as Total_sales
	from coffee_sales
	where month(transaction_date) = 6
	group by product_type
	order by Total_sales desc

	-- SALES ANALYSIS DAYS AND HOURS
	--DAYS
	select
		datepart(dw, transaction_date) as Day,
		sum(transaction_qty * unit_price) as Total_sales,
		count(transaction_id) as total_orders,
		sum(transaction_qty) as Total_qty_sold
		from coffee_sales
		where month(transaction_date) = 5
		group by datepart(dw, transaction_date)
		order by datepart(dw, transaction_date)

	--HOURS
		select
		datepart(hour, transaction_time) as Hour,
		sum(transaction_qty * unit_price) as Total_sales,
		count(transaction_id) as total_orders,
		sum(transaction_qty) as Total_qty_sold
		from coffee_sales
		where month(transaction_date) = 5 
		and datepart(dw,transaction_date) = 2
		group by datepart(hour, transaction_time)
		order by datepart(hour, transaction_time)

