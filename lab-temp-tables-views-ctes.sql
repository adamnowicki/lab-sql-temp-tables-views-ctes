-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

create view customer_summary as
select c.customer_id, c.first_name, c.last_name, email,count(r.rental_id) as rental_count
from customer as c
left join rental as r
on r.customer_id = c.customer_id
group by customer_id;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
-- create temporary table customer_summar_total_paid as 

select cs.customer_id, cs.first_name, cs.last_name, cs.email, cs.rental_count, sum(amount) as total_paid
from payment as p
left join customer_summary as cs
on cs.customer_id = p.customer_id
group by customer_id;

drop table table_total_paid;

-- create temporary table table_total_paid as
select customer_id, sum(amount) as total_paid
from payment 
group by customer_id;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.


with abc as (select * from customer_summary as cs
inner join table_total_paid)


-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

with abc as (select customer_id, first_name, last_name, email, rental_count, total_paid 
from customer_summary as cs
inner join table_total_paid
using (customer_id))
select first_name, last_name, email, rental_count, total_paid, round(((total_paid)/(rental_count)),2) as average_payment_per_rental
from abc
;



