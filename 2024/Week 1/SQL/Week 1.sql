-- Creating the table
create table Output_Table as (
	select left("Flight Details", 10) as "Date",
	substring("Flight Details" from 13 for 5) as "Flight Number",
	split_part(substring("Flight Details" from 20), '-', 1) as "From",
	split_part(split_part("Flight Details", '//', 3), '-', 2) as "To",
	split_part("Flight Details", '//', 4) as "Class",
	split_part("Flight Details", '//', 5) as "Price",
	"Flow Card?", "Bags Checked", "Meal Type"
from "Week 1 Input"
);

-- Casting Date column to date datatype
Alter table output_table
alter column "Date" type date
using "Date"::date;

-- Casting Price column to numeric datatype
Alter table output_table
alter column "Price" type numeric
using "Price"::numeric;

-- Casting Flow Card? column to text datatype
alter table output_table
alter column "Flow Card?" type text
using "Flow Card?"::text;

-- Updating values in Flow Card? column
update output_table
set "Flow Card?" = case when "Flow Card?" = '1' then 'Yes'
when "Flow Card?" = '0' then 'No'
end;

-- Creating Flow Card holders table
create table "Flow Card holders" as (
select * from output_table
where "Flow Card?"='Yes'
);

-- Creating Non-Flow Card holders table
create table "Non-Flow Card holders" as (
select * from output_table
where "Flow Card?"='No'
);
