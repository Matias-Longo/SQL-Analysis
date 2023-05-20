-- create database ejsql;
use ejsql;

select * from revenue;
select * from calendar;

-- Revenue FY21
select sum(Revenue) as Total_Revenue_FY21 from revenue where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21');

-- Revenue FY21 per month
select Month_ID, sum(Revenue) as Total_Revenue_FY21 from revenue where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21') group by Month_ID;

 -- Revenue FY20 all months
select Month_ID, sum(Revenue) as Total_Revenue_FY20 from revenue where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY20') group by Month_ID;

-- Revenue FY20 same months FY21 per months
select Month_ID , sum(Revenue) as Total_Revenue_FY20 from revenue where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21') group by Month_ID;

-- Revenue FY20 same months FY21
select sum(Revenue) as Total_Revenue_FY20same_monthsFY21 from revenue where
Month_id in (select distinct Month_ID -12 from revenue where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21'));

-- YOY diff
select a.Total_Revenue_FY21, b.Total_Revenue_FY20same_monthsFY21, a.Total_Revenue_FY21 - b.Total_Revenue_FY20same_monthsFY21 as FY21vsFY20, a.Total_Revenue_FY21 / b.Total_Revenue_FY20same_monthsFY21 - 1 AS PercentageDiff
FROM
-- Revenue FY21
(
select sum(Revenue) as Total_Revenue_FY21 from revenue 
where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21')
) a,
-- Revenue FY20 same months FY21
(
select sum(Revenue) as Total_Revenue_FY20same_monthsFY21 from revenue where
Month_id in (select distinct Month_ID -12 from revenue where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21'))
) b
;

-- REVENUE PERFORMANCE per month !!!
select a.Total_Revenue_FY21, b.Total_Revenue_FY20, a.Total_Revenue_FY21 - b.Total_Revenue_FY20 as FY21vsFY20, a.Total_Revenue_FY21 / b.Total_Revenue_FY20 - 1 as percentaje_diff from
-- Revenue FY21 per month
(
select Month_ID, sum(Revenue) as Total_Revenue_FY21 from revenue where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21') group by Month_ID
) a ,

-- Revenue FY20 same months FY21 per month
(
select Month_id, sum(Revenue) as Total_Revenue_FY20 from revenue where
Month_id in (select distinct Month_ID -12 from revenue where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21')) group by Month_ID
) b
;


-- MOM performance !!!
select a.Total_revenue_this_month, b.Total_revenue_last_month, a.Total_revenue_this_month - b.Total_revenue_last_month as Diff, a.Total_revenue_this_month / b.Total_revenue_last_month as Percentaje_Diff from

-- Revenue this month
(
select Month_ID , sum(Revenue) as Total_revenue_this_month from revenue 
where Month_ID in (select max(Month_ID) from revenue)
) a ,

-- Revenue last month
(
select Month_ID , sum(Revenue) as Total_revenue_last_month from revenue 
where Month_ID in (select max(Month_ID) - 1 from revenue)
) b
;

-- What is the total revenue vs the target performance for the year per month !!!
select a.Month_ID, c.Month_Name , a.Total_Revenue_FY21, b.Target_Revenue_FY21, a.Total_Revenue_FY21 - b.Target_Revenue_FY21 as Diff,  a.Total_Revenue_FY21 / b.Target_Revenue_FY21 - 1 as PercentajeDiff from

-- Revenue FY21
(
select Month_ID, sum(Revenue) as Total_Revenue_FY21 from revenue 
where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21') group by Month_ID
) a
left join
-- Target revenue FY21
(
select Month_ID, sum(Target) as Target_Revenue_FY21 from targets 
where Month_id in (select distinct Month_ID from calendar where FiscalYear = 'FY21') group by Month_ID
) b 
on a.Month_ID = b.Month_ID

left join

(select distinct Month_ID, Month_Name from calendar) c 
on a.Month_ID = c.Month_ID

