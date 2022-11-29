/*Creating database*/
Create Database oyo;
/*using oyo database*/
Use Oyo;
/*creating a table for booking details*/
Create table oyo_hotels(
booking_id integer not null,
customer_id bigint,
status text,
check_in date,
check_out date,
no_of_rooms integer,
hotel_id integer,
amount float,
discount float,
date_of_booking date
);
select * from oyo_hotels;
/*dataset is directly imoported using cmd*/
/*No. of hotels in the dataset*/
Select count(distinct(hotel_id)) from city_hotels;
/*No. of cities in the dataset*/
Select count(distinct(City)) from city_hotels;
/*No. of hotels by city*/
Select count(Hotel_id), City from city_hotels 
group by City;
/*New column 'Price' is added*/
Alter table oyo_hotels add column price float;
update oyo_hotels set price= amount + discount;
Select o.Status, count(o.hotel_id), Sum(price) as revenue, c.city from oyo_hotels o join city_hotels c on o.hotel_id=c.hotel_id
group by city,status ;
/*new column no_of nights is created*/
alter table oyo_hotels add column no_of_nights int;
update oyo_hotels set no_of_nights = datediff(check_out, check_in); 
/*new column 'Rate' is created*/
Alter table oyo_hotels add column Rate float;
update oyo_hotels set Rate = round(if(no_of_rooms=1, (Price/no_of_nights), (Price/no_of_nights)/no_of_rooms),2);
/*average rate by city*/
Select round(avg(rate),2) as avg_rate_by_city, city from oyo_hotels o, city_hotels c where o.hotel_id=c.hotel_id
group by city order by 1 desc; 
/*cancellation rate*/
Create view Cancellation_Rate as
Select City, Count(status) as cancellation_rate from city_hotels c, oyo_hotels o
where o.hotel_id=c.hotel_id and status = "Cancelled"
group by city order by 2 desc;
/*Booking rate by city for jan, feb and march*/
Create view Booking_Rate as
Select count(booking_id), city, month(date_of_booking) from oyo_hotels o, city_hotels c 
where month(date_of_booking) between 1 and 3 and o.hotel_id= c.hotel_id 
group by city,3 order by 1 desc;
/*How many days prior the bookings were made*/
Select Count(*), day(datediff(check_in, date_of_booking)) as datediff from oyo_hotels group by 2 order by 2;
/*Gross Revenue by city*/
Create View Gross_Revenue as
Select sum(amount) as gross_revenue, city from oyo_hotels o, city_hotels c where o.hotel_id=c.hotel_id 
group by city order by 1 desc;
/*Net revenue*/
Create View Net_Revenue as
Select sum(amount) as net_revenue, city from oyo_hotels o, city_hotels c 
where o.hotel_id=c.hotel_id and (status = 'No Show' or status ='Stayed')
group by city order by 1 desc;
/*Average discount offered*/
Create View Avg_Discount as
Select avg(discount)/avg(amount), city from oyo_hotels o, city_hotels c 
where o.hotel_id=c.hotel_id and month(date_of_booking) between 1 and 3 
group by 2 order by 1 desc;