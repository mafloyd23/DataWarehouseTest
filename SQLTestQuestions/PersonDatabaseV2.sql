USE [master]
GO
/****** Object:  Database [PersonDatabase]    Script Date: 11/12/2018 2:54:14 PM ******/
CREATE DATABASE [PersonDatabase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PersonDatabase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.KGB\MSSQL\DATA\PersonDatabase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PersonDatabase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.KGB\MSSQL\DATA\PersonDatabase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [PersonDatabase] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PersonDatabase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PersonDatabase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PersonDatabase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PersonDatabase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PersonDatabase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PersonDatabase] SET ARITHABORT OFF 
GO
ALTER DATABASE [PersonDatabase] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [PersonDatabase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PersonDatabase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PersonDatabase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PersonDatabase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PersonDatabase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PersonDatabase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PersonDatabase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PersonDatabase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PersonDatabase] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PersonDatabase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PersonDatabase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PersonDatabase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PersonDatabase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PersonDatabase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PersonDatabase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PersonDatabase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PersonDatabase] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PersonDatabase] SET  MULTI_USER 
GO
ALTER DATABASE [PersonDatabase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PersonDatabase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PersonDatabase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PersonDatabase] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PersonDatabase] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PersonDatabase] SET QUERY_STORE = OFF
GO
USE [PersonDatabase]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [PersonDatabase]
GO
/****** Object:  Table [dbo].[Contracts]    Script Date: 11/12/2018 2:54:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contracts](
	[ContractID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[ContractStartDate] [datetime] NOT NULL,
	[ContractEndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Contracts] PRIMARY KEY CLUSTERED 
(
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dates]    Script Date: 11/12/2018 2:54:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dates](
	[DateValue] [datetime] NOT NULL,
	[DateDayofMonth] [int] NULL,
	[DateDayofYear] [int] NULL,
	[DateQuarter] [int] NULL,
	[DateWeekdayName] [varchar](20) NULL,
	[DateMonthName] [varchar](20) NULL,
	[DateYearMonth] [char](6) NULL,
 CONSTRAINT [PK_Dates] PRIMARY KEY CLUSTERED 
(
	[DateValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 11/12/2018 2:54:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[PersonName] [varchar](255) NULL,
	[Sex] [varchar](1) NULL,
	[DateofBirth] [datetime] NULL,
	[Address] [varchar](255) NULL,
	[IsActive] [int] NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
 CONSTRAINT [Person_PK] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Risk]    Script Date: 11/12/2018 2:54:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Risk](
	[RiskID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[AttributedPayer] [varchar](255) NULL,
	[RiskScore] [decimal](10, 6) NULL,
	[RiskLevel] [varchar](10) NULL,
	[RiskDateTime] [datetime] NULL,
 CONSTRAINT [PK_Risk] PRIMARY KEY CLUSTERED 
(
	[RiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Contracts_1]    Script Date: 11/12/2018 2:54:15 PM ******/
CREATE NONCLUSTERED INDEX [IX_Contracts_1] ON [dbo].[Contracts]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX1]    Script Date: 11/12/2018 2:54:15 PM ******/
CREATE NONCLUSTERED INDEX [IX1] ON [dbo].[Person]
(
	[DateofBirth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX1]    Script Date: 11/12/2018 2:54:15 PM ******/
CREATE NONCLUSTERED INDEX [IX1] ON [dbo].[Risk]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Person] ADD  CONSTRAINT [IsActiveDefault]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Contracts]  WITH CHECK ADD  CONSTRAINT [FK_Contracts_Dates] FOREIGN KEY([ContractStartDate])
REFERENCES [dbo].[Dates] ([DateValue])
GO
ALTER TABLE [dbo].[Contracts] CHECK CONSTRAINT [FK_Contracts_Dates]
GO
ALTER TABLE [dbo].[Contracts]  WITH CHECK ADD  CONSTRAINT [FK_Contracts_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Contracts] CHECK CONSTRAINT [FK_Contracts_Person]
GO
ALTER TABLE [dbo].[Risk]  WITH CHECK ADD  CONSTRAINT [FK_Risk_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Risk] CHECK CONSTRAINT [FK_Risk_Person]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [sex_constraint] CHECK  (([Sex]='F' OR [Sex]='M'))
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [sex_constraint]
GO
/****** Object:  StoredProcedure [dbo].[person_match]    Script Date: 11/12/2018 2:54:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[person_match] 
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
USE [master]
GO
ALTER DATABASE [PersonDatabase] SET  READ_WRITE 
GO
