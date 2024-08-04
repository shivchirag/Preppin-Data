create table "Week 3 Output" as
--making union of flow card and non flow card holders 
with cte as (
	select *
	from "Flow Card Holders"
	union all
	select * 
	from "Non Flow Card Holders"
),

--renaming the classes
cte1 as (
	select "Date", "Price", 
	(case when "Class"='Economy' then 'First' 
		 when "Class"='First Class' then 'Economy'
		 when "Class"='Business Class' then 'Premium'
		 when "Class"='Premium Economy' then 'Business' end) as "Class"
	from cte
),

--abbreviating the classes
cte2 as (
	select "Date", "Price", 
	(case when "Class"='Economy' then 'E' 
		 when "Class"='First' then 'FC'
		 when "Class"='Business' then 'BC'
		 when "Class"='Premium' then 'PE' end) as "Class"
	from cte1
),

--retreiving month from date
cte3 as (
	select extract(month from "Date") as "Month",
	"Price", "Class"
	from cte2
),

--aggregating price over month and class
cte4 as (
	select "Month", "Class", sum("Price") as "Price"
	from cte3
	group by 1,2
),

--joining quarter file based on month
cte5 as (
	select c."Month", c."Class", c."Price", 
	(case when c."Month"<=3 then q1."Target"
		when c."Month"<=6 then q2."Target"
		when c."Month"<=9 then q3."Target"
		when c."Month"<=12 then q4."Target" end) as "Target"
	from cte4 c
	left join "Quarter 1" q1
	on c."Class"=q1."Class"
	and c."Month"=q1."Month"
	left join "Quarter 2" q2
	on c."Class"=q2."Class"
	and c."Month"=q2."Month"
	left join "Quarter 3" q3
	on c."Class"=q3."Class"
	and c."Month"=q3."Month"
	left join "Quarter 4" q4
	on c."Class"=q4."Class"
	and c."Month"=q4."Month"
),

--calculating the difference to target col
cte6 as (
	select "Price"-"Target" as "Difference To Target",
	"Month", "Price", "Class", "Target"
	from cte5
)

select * 
from cte6;