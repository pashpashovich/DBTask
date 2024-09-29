-- Task 1

select model ->>'ru' as model, fare_conditions, count (seat_no) as number_of_seats
from seats
    inner join aircrafts_data using (aircraft_code)
group by model, aircraft_code, fare_conditions


-- Task 2

select model ->>'ru' as model, count(seat_no) as number_of_seats
from seats
    inner join aircrafts_data using (aircraft_code)
group by model, fare_conditions
order by number_of_seats desc limit(3)


-- Task 3

select flight_id, flight_no, extract(epoch from (actual_departure - scheduled_departure)) / 3600 as delay_hours
from flights
where actual_departure is not null
  and extract(epoch from (actual_departure - scheduled_departure)) / 3600 > 2


-- Task 4

select ticket_no, passenger_name, contact_data, book_date, fare_conditions
from tickets
         inner join bookings using (book_ref)
         inner join ticket_flights using (ticket_no)
where (fare_conditions like 'Business')
order by book_date desc limit(10)


-- Task 5

select *
from flights
where flight_id not in
      (select distinct flight_id
       from ticket_flights
       where fare_conditions like 'Business')


-- Task 6

select distinct airport_name, city
from flights
         inner join airports on (departure_airport = airport_code)
where (actual_departure is not null
    and actual_departure > scheduled_departure)


-- Task 7

select airport_name, count(flight_id) as flight_count
from flights
         inner join airports on (departure_airport = airport_code)
group by airport_name
order by flight_count desc


-- Task 8

select flight_id, flight_no, scheduled_arrival, actual_arrival
from flights
where actual_arrival is not null
  and actual_arrival!=scheduled_arrival


-- Task 9

select aircraft_code, model ->>'ru' as model, seat_no, fare_conditions
from aircrafts_data
    inner join seats using (aircraft_code)
where (fare_conditions not like 'Economy'
  and model->>'ru' like 'Аэробус A321-200')
order by seat_no;


-- Task 10

select airport_code, airport_name ->>'ru' as airport_name, city->>'ru' as city
from airports_data
where city in
    (
    select city
    from airports_data
    group by city
    having count (city)
    >1
    )

-- Task 11

select passenger_name, sum(total_amount) as total_sum
from tickets
         inner join bookings using (book_ref)
group by passenger_name
having sum(total_amount) > (select avg(total_amount) as average_amount
                            from bookings)


-- Task 12

select flight_id,
       flight_no,
       scheduled_departure,
       a1.airport_name as departure_airport,
       a2.airport_name as arrival_airport
from flights
         inner join airports a1 on departure_airport = a1.airport_code
         inner join airports a2 on arrival_airport = a2.airport_code
where a1.city like 'Екатеринбург'
  and a2.city like 'Москва'
  and (status like 'On Time'
    or status like 'Delayed')
order by scheduled_departure limit(1)


-- Task 13

(
    select 'Самый дешевый' as name, ticket_no, amount
    from ticket_flights
    order by amount
    limit 1
)

union all

(
select 'Самый дорогой'  as name, ticket_no, amount
from ticket_flights
order by amount desc
    limit 1
    );


-- Task 14

create table customers
(
    id         serial primary key,
    first_name varchar(50)         not null,
    last_name  varchar(50)         not null,
    email      varchar(100) unique not null,
    phone      varchar(15) unique  not null,
    constraint proper_email check (email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
) , constraint check_phone_format check (phone ~* '^\+?[0-9]{10,15}$') );


-- Task 15

create table orders
(
    id          serial primary key,
    customer_id int not null,
    quantity    int check (quantity > 0),
    constraint fk_customer foreign key (customer_id)
        references customers (id)
        on delete cascade
)


-- Task 16

    insert into customers (first_name, last_name, email, phone) values
('Иван', 'Иванов', 'ivan.ivanov@gmail.com', '+375293586269'),
('Мария', 'Петрова', 'maria.petrovna@mail.ru', '+375293686269'),
('Алексей', 'Сидоров', 'alexey.sidorov@example.com', '+375293786269'),
('Ольга', 'Кузнецова', 'olga.kuznetsova@example.com', '+375293886269'),
('Дмитрий', 'Николаев', 'dmitry.nikolaev@example.com', '+375293986269');


insert into orders (customer_id, quantity)
values (1, 2),
       (2, 5),
       (1, 1),
       (3, 3),
       (4, 4);


-- Task 17

drop table if exists orders;
drop table if exists customers;