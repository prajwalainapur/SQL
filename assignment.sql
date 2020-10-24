use stockAnalysis;

-- Result: 1
-- --Creating tables 
create table bajaj1
(
modDate Datetime,
closePrice float,
DMA20 float,
DMA50 float
);

create table eicher1
(
modDate Datetime,
closePrice float,
DMA20 float,
DMA50 float
);

create table tvs1
(
modDate Datetime,
closePrice float,
DMA20 float,
DMA50 float
);

create table hero1
(
modDate Datetime,
closePrice float,
DMA20 float,
DMA50 float
);

create table tcs1
(
modDate Datetime,
closePrice float,
DMA20 float,
DMA50 float
);

create table infosys1
(
modDate Datetime,
closePrice float,
DMA20 float,
DMA50 float
);

-- --Modifying datetime and inserting the same into each of the previously created tables
insert into bajaj1
select str_to_date(Date, "%d-%M-%Y") as modDate, `Close Price` as closePrice,
avg(`Close Price`) over (order by date rows between 19 preceding and current row) as DMA20,
avg(`Close Price`) over (order by date rows between 49 preceding and current row) as DMA50
from bajajTmp;

insert into eicher1
select str_to_date(Date, "%d-%M-%Y") as modDate, `Close Price` as closePrice,
avg(`Close Price`) over (order by date rows between 19 preceding and current row) as DMA20,
avg(`Close Price`) over (order by date rows between 49 preceding and current row) as DMA50
from eicherTmp;

insert into hero1
select str_to_date(Date, "%d-%M-%Y") as modDate, `Close Price` as closePrice,
avg(`Close Price`) over (order by date rows between 19 preceding and current row) as DMA20,
avg(`Close Price`) over (order by date rows between 49 preceding and current row) as DMA50
from heroTmp;

insert into infosys1
select str_to_date(Date, "%d-%M-%Y") as modDate, `Close Price` as closePrice,
avg(`Close Price`) over (order by date rows between 19 preceding and current row) as DMA20,
avg(`Close Price`) over (order by date rows between 49 preceding and current row) as DMA50
from infosysTmp;

insert into tvs1
select str_to_date(Date, "%d-%M-%Y") as modDate, `Close Price` as closePrice,
avg(`Close Price`) over (order by date rows between 19 preceding and current row) as DMA20,
avg(`Close Price`) over (order by date rows between 49 preceding and current row) as DMA50
from tvsTmp;

insert into tcs1
select str_to_date(Date, "%d-%M-%Y") as modDate, `Close Price` as closePrice,
avg(`Close Price`) over (order by date rows between 19 preceding and current row) as DMA20,
avg(`Close Price`) over (order by date rows between 49 preceding and current row) as DMA50
from tcsTmp;

-- -- Removing the temproary tables which here imported manually from csv files
drop table bajajTmp;
drop table heroTmp;
drop table infosysTmp;
drop table eicherTmp;
drop table tcsTmp;
drop table tvsTmp;

-- Result: 2
-- --Creating the master table
create table masterTable
(
Date Date,
Bajaj float,
Hero float,
TVS float,
Eicher float,
TCS float,
Infosys float
);

-- --Inserting the values from other tables into the master table
insert into masterTable
select h.modDate as Date, h.closePrice as Hero, b.closePrice as Bajaj, 
t.closePrice as TVS, e.closePrice as Eicher, c.closePrice as TCS, i.closePrice as Infosys
from hero1 h
inner join bajaj1 b on h.modDate = b.modDate
inner join tvs1 t on b.modDate = t.modDate
inner join eicher1 e on t.modDate = e.modDate
inner join infosys1 i on i.modDate = e.modDate
inner join tcs1 c on c.modDate = i.modDate
order by b.modDate;

-- Result: 3
-- -- Creating tables for the trading signals
create table bajaj2
(
`Date` Datetime,
closePrice float,
`Signal` char
);

create table eicher2
(
Date Datetime,
closePrice float,
`Signal` char
);

create table tvs2
(
Date Datetime,
closePrice float,
`Signal` char
);

create table hero2
(
Date Datetime,
closePrice float,
`Signal` char
);

create table infosys2
(
Date Datetime,
closePrice float,
`Signal` char
);

create table TCS2
(
Date Datetime,
closePrice float,
`Signal` char
);

-- -- Calculating the trading signals i.e. Buy or sell and inserting them into the newly created tables
insert into bajaj2
select Date as Date, closePrice as closePrice, (
case 
	when DMA20 > DMA50 then 'Sell'
    when DMA20 < DMA50 then 'Buy'
    else 'Hold'
end) as `Signal`
from bajaj1;

insert into hero2
select Date as Date, closePrice as closePrice, (
case 
	when DMA20 > DMA50 then 'Sell'
    when DMA20 < DMA50 then 'Buy'
    else 'Hold'
end) as `Signal`
from hero1;

insert into tvs2
select Date as Date, closePrice as closePrice, (
case 
	when DMA20 > DMA50 then 'Sell'
    when DMA20 < DMA50 then 'Buy'
    else 'Hold'
end) as `Signal`
from tvs1;

insert into eicher2
select Date as Date, closePrice as closePrice, (
case 
	when DMA20 > DMA50 then 'Sell'
    when DMA20 < DMA50 then 'Buy'
    else 'Hold'
end) as `Signal`
from eicher1;

insert into TCS2
select Date as Date, closePrice as closePrice, (
case 
	when DMA20 > DMA50 then 'Sell'
    when DMA20 < DMA50 then 'Buy'
    else 'Hold'
end) as `Signal`
from tcs1;

insert into infosys2
select Date as Date, closePrice as closePrice, (
case 
	when DMA20 > DMA50 then 'Sell'
    when DMA20 < DMA50 then 'Buy'
    else 'Hold'
end) as `Signal`
from infosys1;


-- Result: 4
-- -- User defined function to get the trading signal for bajaj stock
DELIMITER $$
create procedure TradingBajaj
  (in n date)
begin
  select Signals
  from bajaj2
  where 
    Date = n;
end $$
DELIMITER ;
