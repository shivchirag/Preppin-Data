
create table "Week 4 Output" as
--concatenating the datasets with new col Flow Card
with cte1 as
(
	select *, 'Yes' AS "Flow Card?"
	from "Flow Card"
	union all
	select *, 'No' AS "Flow Card?"
	from "Non Flow Card"
	union all
	select *, 'No' AS "Flow Card?"
	from "Non Flow Card 2"
),
--aggregating the customer ID col
cte2 as 
(
	select "Flow Card?", "Class", "Seat", "Row", count("CustomerID") as "No of Bookings"
	from cte1
	group by "Flow Card?", "Class", "Seat", "Row"
),
--joining the seat plan
cte3 as
(
    select st."Class", st."Seat", st."Row", ct."No of Bookings"
    from cte2 as ct
    right join "Seat Plan" as st
    on ct."Class" = st."Class"
    and ct."Seat" = st."Seat"
    and ct."Row" = st."Row"
)
--final output
select "Class", "Seat", "Row"
from cte3
where "No of Bookings" is null;










