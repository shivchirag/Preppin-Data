--Creating a new table
create table temp_table as
select *
from "Flow Card holders"
union
select *
from "Non-Flow Card holders";

--Creating the output table
create table "Week 2 Output" as
with cte as 
(	
	--Creating Quarter field
	select "Flight Number", "From", "To", "Class", "Price", 
	"Flow Card?", "Bags Checked", "Meal Type", 
	ceil(extract(month from "Date")/3) as "Quarter"
	from temp_table
),
cte1 as 
(
	--Creating Aggregated Fields
	select "Quarter", "Flow Card?", "Class",
	percentile_cont(0.5) within group (order by "Price") as "Median Price",
	min("Price") as "Min Price", max("Price") as "Max Price"
	from cte
	group by 1,2,3
),
cte2 as 
(
	--Pivoting for median fields
	select "Flow Card?", "Quarter",
	sum(case when "Class" = 'Business Class' then "Median Price" else 0 end) as "Business Class",
	sum(case when "Class" = 'Economy' then "Median Price" else 0 end) as "Economy",
	sum(case when "Class" = 'First Class' then "Median Price" else 0 end) as "First Class",
	sum(case when "Class" = 'Premium Economy' then "Median Price" else 0 end) as "Premium Economy"
	from cte1
	group by 1,2
),
cte3 as 
(
	--Pivoting for min fields
	select "Flow Card?", "Quarter",
	sum(case when "Class" = 'Business Class' then "Min Price" else 0 end) as "Business Class",
	sum(case when "Class" = 'Economy' then "Min Price" else 0 end) as "Economy",
	sum(case when "Class" = 'First Class' then "Min Price" else 0 end) as "First Class",
	sum(case when "Class" = 'Premium Economy' then "Min Price" else 0 end) as "Premium Economy"
	from cte1
	group by 1,2
),
cte4 as 
(
	--Pivoting for max fields
	select "Flow Card?", "Quarter",
	sum(case when "Class" = 'Business Class' then "Max Price" else 0 end) as "Business Class",
	sum(case when "Class" = 'Economy' then "Max Price" else 0 end) as "Economy",
	sum(case when "Class" = 'First Class' then "Max Price" else 0 end) as "First Class",
	sum(case when "Class" = 'Premium Economy' then "Max Price" else 0 end) as "Premium Economy"
	from cte1
	group by 1,2
)

select *
from cte2
union
select *
from cte3
union
select *
from cte4;

--Renaming the fields
alter table "Week 2 Output"
rename column "Business Class" to Premium;
alter table "Week 2 Output"
rename column "Economy" to First;
alter table "Week 2 Output"
rename column "First Class" to Economy;
alter table "Week 2 Output"
rename column "Premium Economy" to Business;