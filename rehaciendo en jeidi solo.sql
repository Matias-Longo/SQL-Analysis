use ejsql;

-- what is the best performing product category in terms of revenue this year !!!
SELECT Product_Category, sum(revenue) AS Revenue_2021 FROM revenue 
WHERE Month_ID IN 
		(SELECT distinct Month_ID FROM calendar WHERE Year_No like 2021)
GROUP BY product_category
ORDER BY Revenue_2021 DESC;


-- what is the product performance vs target for the month !!!
SELECT a.Month_ID, a.Product_Category, round(a.Target) AS Target, b.Revenue,  round(b.Revenue - a.Target) AS "revenue-target", 
CONCAT("% ",ROUND((b.Revenue / a.Target - 1) * 100, 2)) AS Performance  from
	(SELECT Product_Category, Month_ID, SUM(Target) AS Target FROM targets
	GROUP BY Month_ID, Product_Category) a
INNER JOIN
	(SELECT Product_Category, Month_ID, SUM(Revenue) AS Revenue FROM revenue
	GROUP BY Month_ID, Product_Category) b
ON a.Month_ID = b.Month_ID AND a.Product_Category = b.Product_Category
GROUP BY Month_ID, Product_Category
ORDER BY Month_ID DESC;



-- Which account is performing best in terms of revenue ? !!!
SELECT a.Account_No, b.New_Account_Name AS Account_Name,a.Revenue from
	(SELECT Account_No, SUM(revenue) AS Revenue FROM revenue
	GROUP BY Account_No) a
left JOIN
	(SELECT New_account_No, New_account_Name FROM accounts) b
ON a.Account_No = b.New_Account_No
ORDER BY revenue DESC
LIMIT 10

-- Which account is performing best in terms of revenue vs target FY21 ? !!!

SELECT d.Account_No, c.New_Account_Name,RevenueVsTarget from	
	(SELECT a.Account_No,  ROUND((a.Revenue / b.target - 1 ),2) AS RevenueVsTarget from
		(SELECT SUM(revenue) AS Revenue, Account_No FROM revenue
		WHERE Month_ID IN 
			(SELECT distinct Month_ID FROM calendar WHERE Year_No like 2021)
		GROUP BY Account_No) a
	INNER JOIN
	   (SELECT Account_No, sum(Target) AS Target FROM targets
	   WHERE Month_ID IN 
			(SELECT distinct Month_ID FROM calendar WHERE Year_No like 2021)
			GROUP BY Account_No, Month_ID) b
	ON a.Account_No = b.Account_No) d
	INNER JOIN
		(SELECT New_Account_No, New_Account_Name FROM accounts) c
	ON d.Account_No = c.New_Account_No
GROUP BY d.Account_No
ORDER BY RevenueVsTarget DESC
	












