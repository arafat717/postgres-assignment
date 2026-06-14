https://lucid.app/lucidchart/6d5de222-9407-450c-8407-88bca1f64b3e/edit?viewport_loc=-1211%2C34%2C1479%2C823%2C0_0&invitationId=inv_c8c7f367-9ad9-4edb-8fc9-49b34d7aca82


-- users table start
CREATE TABLE Users (
    user_id int primary key,
    full_name varchar(50) not null,
    email varchar(100) unique not null,
    role varchar(50) check(role in('Ticket Manager', 'Football Fan')),
    phone_number varchar(20)
);

INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);
--  users table end




-- match table start
CREATE TABLE Matches (
    match_id int primary key,
    fixture varchar(150) not null,
    tournament_category varchar(200) not null,
    base_ticket_price decimal(10,2) check(base_ticket_price >= 0),
    match_status varchar(50) check(match_status in('Available', 'Selling Fast', 'Sold Out','Postponed'))
);

INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');
-- match table end





-- booking table start
CREATE TABLE Bookings (
    booking_id int primary key,
    user_id int references users(user_id),
    match_id int references matches(match_id),
    seat_number varchar(10),
    payment_status varchar(100) check (payment_status in ('Pending', 'Confirmed', 'Cancelled', 'Refunded')),
    total_cost decimal(10,2) check (total_cost >= 0)
);

INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);
--  booking table end


-- select * from bookings;




-- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.

select match_id, fixture, base_ticket_price from matches where tournament_category = 'Champions League' and match_status = 'Available';


-- Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).
select
  user_id,
  full_name,
  email
from
  users
where
  full_name ilike 'Tanvir%'
  or full_name ilike '%Haque%';


  -- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.
select
  booking_id,
  user_id,
  match_id,
  coalesce(payment_status, 'Action Required') as systematic_status
from
  bookings
where
  payment_status is null;


-- Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.
select
  b.booking_id ,u.full_name , m.fixture , b.total_cost
from
  bookings as b
  inner join users as u on b.user_id = u.user_id
  inner join matches as m on m.match_id = b.match_id;



  -- Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.
select
  u.user_id,
  u.full_name,
  b.booking_id
from
  users as u
  left join bookings as b on u.user_id = b.user_id;






-- Query 6: Find all ticket bookings where the total cost is strictly higher than the average cost of all ticket bookings.

select booking_id,	match_id,	total_cost from bookings
  where total_cost > (select avg(total_cost) from bookings);