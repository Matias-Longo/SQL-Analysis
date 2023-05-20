use ejsql;

-- what is the best performing product category in terms of revenue this year !!!
select * from calendar;
SELECT distinct Product_Category, sum(revenue) from revenue 
where Month_ID in (select distinct Month_ID from calendar where FiscalYear = 'FY21')
group by Product_category ;


-- what is the product performance vs target for the month !!!
select a.Target, b.Revenue, a.Product_Category, b.Revenue - a.Target, b.Revenue / a.Target - 1 from

(
select Month_ID, sum(Target) as Target, Product_Category from targets
where Month_ID in (select Max(Month_ID) from revenue)
group by Product_category
) a 

right join

(
-- select Max(Month_ID) as Month_ID, sum(Revenue) as Revenue, Product_Category from revenue group by Product_Category, Month_ID
select Month_ID, sum(Revenue) as Revenue, Product_Category from revenue 
where Month_ID in (select max(Month_ID) from revenue)
group by Product_Category
) b

on a.Product_Category = b.Product_Category;

-- Which account is performing best in terms of revenue ? !!!
Select a.Account_No, b.New_account_Name, a.Revenue from
(
select Account_No, sum(Revenue) as Revenue from revenue group by Account_No
) a
left join
(
select AccountNo, New_Account_Name from accounts
) b

on a.Account_No = b.AccountNo
order by a.Revenue desc;


-- Which account is performing best in terms of revenue vs target FY21 ? !!!

Select a.Account_No, b.New_account_Name, a.Revenue, c.Target, a.Revenue - c.Target, ISNULL(a.Revenue,0) / nullif(c.Target,0) - 1 as Rev_VS_Tgt from
		(
		select Account_No, sum(Revenue) as Revenue from revenue 
		where Month_ID in (select Month_ID from calendar where FiscalYear = 'FY21')
		group by Account_No
		) a

		left join

		(
		select AccountNo, New_Account_Name from accounts
		) b
		on a.Account_No = b.AccountNo

		left join

		(
		select Account_No, sum(Target) as target from targets
		where Month_ID in (select Month_ID from calendar where FiscalYear = 'FY21')
		group by Account_No
		) c
		on a.Account_No = c.Account_No

	union

	Select a.Account_No, b.New_account_Name, a.Revenue, c.Target, a.Revenue - c.Target, a.Revenue / c.Target - 1  from
		(
		select Account_No, sum(Revenue) as Revenue from revenue 
		where Month_ID in (select Month_ID from calendar where FiscalYear = 'FY21')
		group by Account_No
		) a

	left join

		(
		select AccountNo, New_Account_Name from accounts
		) b
		on a.Account_No = b.AccountNo

	right join

		(
		select Account_No, sum(Target) as target from targets
		where Month_ID in (select Month_ID from calendar where FiscalYear = 'FY21')
		group by Account_No
		) c
on a.Account_No = c.Account_No           

order by Rev_VS_Tgt desc















