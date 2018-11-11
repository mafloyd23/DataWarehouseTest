USE PERSONDATABASE

alter table dbo.Person alter column PersonID int NOT NULL;
alter table dbo.Person add constraint Person_PK PRIMARY KEY (PersonID);
alter table dbo.Risk alter column PersonID int not null;
alter table dbo.Risk add CONSTRAINT FK_Risk_Person FOREIGN KEY (PersonID) REFERENCES Person (PersonID);
create index IX1 on dbo.Risk(PersonID);
create index IX1 on dbo.Person(DATEOFBIRTH);
update Person
set sex = case sex 
    when 'Female' then 'F'
    when 'Male' then 'M'
    else sex
end;

ALTER TABLE Person ADD CONSTRAINT sex_constraint CHECK (Sex = 'F' OR Sex = 'M');

alter table dbo.Person alter column sex varchar(1);
alter table dbo.Person add FirstName varchar(50);
alter table dbo.Person add LastName varchar(50);
alter table dbo.Person alter column IsActive int;
alter table dbo.Person add constraint IsActiveDefault default 0 for IsActive;

/*********************
Hello! 

Please use the test data provided in the file 'PersonDatabase' to answer the following
questions. Please also import the dbo.Contacts flat file to a table for use. 

All answers should be written in SQL. 

***********************



QUESTION 1

The table dbo.Risk contains calculated risk scores for the population in dbo.Person. Write a 
query or group of queries that return the patient name, and their most recent risk level(s). 
Any patients that dont have a risk level should also be included in the results. 

**********************/
--Option 1
select a.PersonName,
    (
        select top 1 RiskLevel
        from Risk
        where PersonID = a.PersonID
        order by RiskDateTime desc
    ) as RiskLevel
from Person a
order by PersonName;

--Option 2
select a.PersonName, b.RiskLevel
from Person a
    left join 
    (
        select PersonID,
            RiskLevel,
            row_number() over (partition by PersonID order by RiskDateTime desc) as rank
        from Risk
    ) b
    on a.PersonID = b.PersonID
where isnull(b.rank, 1) = 1
order by a.PersonName;

/**********************

QUESTION 2


The table dbo.Person contains basic demographic information. The source system users 
input nicknames as strings inside parenthesis. Write a query or group of queries to 
return the full name and nickname of each person. The nickname should contain only letters 
or be blank if no nickname exists.

**********************/

select a.PersonName,
    case when b.nickname is not null then replace(replace(a.PersonName, b.nickname, ''), ')', '') 
        else a.PersonName 
    end as FullName,
    case when b.nickname is not null then replace(replace(b.nickname, '(', ''), ')', '')
        else '' 
    end as nickname
from Person a
    left join 
        (
            select PersonID,
                substring(PersonName, charindex('(', PersonName), charindex(')', PersonName, -1) - charindex('(', PersonName) +1) as NickName
            from Person
        ) b
        on a.PersonID = b.PersonID;

update dbo.Person
set FirstName = substring(ltrim(rtrim(names.FullName)), 1, charindex(' ', ltrim(rtrim(names.FullName)))),
	LastName = substring(ltrim(rtrim(names.FullName)), charindex(' ', ltrim(rtrim(names.FullName)))+ 1, len(FullName))
from dbo.Person P
	 inner join 
	 	(
			select a.PersonID,
				case when b.nickname is not null then replace(replace(a.PersonName, b.nickname, ''), ')', '') 
					else a.PersonName 
				end as FullName,
				case when b.nickname is not null then replace(replace(b.nickname, '(', ''), ')', '')
					else '' 
				end as nickname
			from Person a
				left join 
					(
						select PersonID,
							substring(PersonName, charindex('(', PersonName), charindex(')', PersonName, -1) - charindex('(', PersonName) +1) as NickName
						from Person
					) b
					on a.PersonID = b.PersonID
		) names
			on P.PersonID = names.PersonID;

/**********************

QUESTION 3

Building on the query in question 1, write a query that returns only one row per 
patient for the most recent levels. Return a level for a patient so that for patients with 
multiple levels Gold > Silver > Bronze


**********************/

 select a.PersonName, 
    case min(b.rank)
        when 1 then 'Gold'
        when 2 then 'Silver'
        when 3 then 'Bronze'
    end as RiskLevel
from Person a
    left join 
    (
        select PersonID,
            RiskLevel,
            case RiskLevel
                when 'Gold' then 1
                when 'Silver' then 2
                when 'Bronze' then 3
                else 0
            end as rank
        from Risk
    ) b
    on a.PersonID = b.PersonID
group by a.PersonName
order by a.PersonName;

-- I understand there is hardcoding present.  This seems reasonable for an extremely limited set of choices
-- such as Gold, Silver, Bronze.  Obviously, this value could be in a column somewhere so it could be dynamic

/**********************

QUESTION 4

The following query returns patients older than 55 and their assigned risk level history. 

A. What changes could be made to this query to improve optimization? Rewrite the query with  
any improvements in the Answer A section below.

B. What changes would we need to make to run this query at any time to return patients over 55?
Rewrite the query with any required changes in Answer B section below. 

**********************/

--------Answer A--------------------

SELECT P.PersonID, P.PersonName, R.*
FROM DBO.Person P
INNER JOIN DBO.Risk R
    ON R.PersonID = P.PersonID
WHERE DATEDIFF(dd, P.DATEOFBIRTH, getdate()) / 365.25 > 55
    and P.ISACTIVE = 1
order by P.PersonName, R.RiskLevel;

/* I know there are much more precise ways to get to the age */

---------Answer B--------------------
/* Unless I am missing the obvious, which I might very well be, I submit A *
/* for both A and B */

/**********************

QUESTION 5

Create a patient matching stored procedure that accepts (first name, last name, dob and sex) as parameters and 
and calculates a match score from the Person table based on the parameters given. If the parameters do not match the existing 
data exactly, create a partial match check using the weights below to assign partial credit for each. Return PatientIDs and the
 calculated match score. Feel free to modify or create any objects necessary in PersonDatabase.  

FirstName 
	Full Credit = 1
	Partial Credit = .5

LastName 
	Full Credit = .8
	Partial Credit = .4

Dob 
	Full Credit = .75
	Partial Credit = .3

Sex 
	Full Credit = .6
	Partial Credit = .25


**********************/
create procedure person_match 
(
	@firstName varchar(50), 
	@lastName varchar(50),
	@dateOfBirth datetime,
	@sex varchar(1)
)
as
BEGIN  
    set nocount on;

	declare @scores table
	(
		PersonID int,
		FirstName varchar(50),
		LastName varchar(50),
		DateOfBirth datetime,
		Sex varchar(1),
		score numeric(3, 2)
	);

	insert into @scores (PersonID, FirstName, LastName, DateOfBirth, Sex)
	select PersonID, FirstName, LastName, DateOfBirth, Sex
	from Person
	where (FirstName = @firstName or soundex(FirstName) = soundex(@firstName));

	insert into @scores (PersonID, FirstName, LastName, DateOfBirth, Sex)
	select p1.PersonID, p1.FirstName, p1.LastName, p1.DateOfBirth, p1.Sex
	from Person p1
		left join @scores p2
			on p1.PersonID = p2.PersonID
	where (p1.LastName = @lastName or soundex(p1.LastName) = soundex(@lastName))
		and p2.PersonID is null;

	insert into @scores (PersonID, FirstName, LastName, DateOfBirth, Sex)
	select p1.PersonID, p1.FirstName, p1.LastName, p1.DateOfBirth, p1.Sex
	from Person p1
		left join @scores p2
			on p1.PersonID = p2.PersonID
	where p1.DateOfBirth = @dateOfBirth
		and p2.PersonID is null;

	update @scores
	set score = case when FirstName = @firstName then 1 else .5 end;

	update @scores
	set score = score + case when Lastname = @lastName then .8 else .4 end;

	update @scores
	set score = score + case when DateOfBirth = @dateOfBirth then .75 else .3 end;

	update @scores
	set score = score + case when Sex = @sex then .6 else .25 end;

	select PersonID, score
	from @scores;
END;
GO

/**********************

QUESTION 6

A. Looking at the script 'PersonDatabase', what change(s) to the tables could be made to improve the database structure?  
I added what I thought were relevant options at the very top of the script


B. What method(s) could we use to standardize the data allowed in dbo.Person (Sex) to only allow 'Male' or 'Female'?
I added a check constraint at the top of the script

C. Assuming these tables will grow very large, what other database tools/objects could we use to ensure they remain
efficient when queried?
Full text index catalogs


**********************/

/**********************

QUESTION 7

Write a query to return risk data for all patients, all contracts 
and a moving average of risk for that patient and contract in dbo.Risk. 

**********************/

select a.PersonID, a.AttributedPayer, AverageRisk
FROM   
    (
        select PersonID, 
            AttributedPayer, 
            AVG(RiskScore) OVER (PARTITION BY PersonID, AttributedPayer ORDER BY PersonID, AttributedPayer) as AverageRisk
        from Risk
    ) a
group by a.PersonID, a.AttributedPayer, a.AverageRisk;

/**********************

QUESTION 8

Write script to load the dbo.Dates table with all applicable data elements for dates 
between 1/1/2010 and 50 days past the current date.


**********************/
set nocount on;

truncate table Dates;

declare @beginDate datetime
declare @endDate datetime

select @beginDate = '2010-01-01';
select @endDate = dateadd(dd, 50, getdate());

while @beginDate <= @endDate
BEGIN
    insert into Dates 
        (
            DateValue, 
            DateDayOfMonth, 
            DateDayOfYear, 
            DateQuarter, 
            DateWeekdayName, 
            DateMonthName, 
            DateYearMonth)
    values 
        (
            @beginDate,
            datepart(dd, @beginDate),
            datepart(dy, @beginDate),
            datepart(qq, @beginDate),
            datename(dw, @beginDate),
            datename(m, @beginDate),
            cast(datepart(year, @beginDate) as varchar(4)) +
                case 
                    when datepart(m, @beginDate) < 10 then '0' + cast(datepart(m, @beginDate) as varchar(1)) 
                    else cast(datepart(month, @beginDate) as varchar(2)) 
                end
        );

    select @beginDate = dateadd(dd, 1, @beginDate)
end;

/**********************

QUESTION 9

Please import the data from the flat file dbo.Contracts.txt to a table to complete this question. 

Using the data in dbo.Contracts, create a query that returns 

(PersonID, AttributionStartDate, AttributionEndDate) 

merging contiguous date ranges into one row and returning a new row when a break in time exists. 
The date at the beginning of the rage can be the first day of that month, the day of the end of the range can
be the last day of that month. Use the dbo.Dates table if helpful.

**********************/






