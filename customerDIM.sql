CREATE TABLE CustomersDim(
	[CustomerID] [varchar](50) NOT NULL primary key,
	[Gender] [varchar](10) NULL,
	[Age] [tinyint] NULL,
	[Under30] [varchar](5) NULL,
	[Senior_Citizen] [varchar](5) NULL,
	[Married] [varchar](5) NULL,
	[Dependents] [varchar](5) NULL,
	[Number_of_Dependents] [tinyint] NULL,
	[CLTV] [int] NULL,
	[Zip_Code] [int] NULL,
	[Payment_Method] [varchar](50) NULL,
	[Contract_type] [varchar](50) NULL,
	[Paperless_Billing] [varchar](5) NULL,
	[Referred_a_Friend] [varchar](5) NULL,
	[Number_of_Referrals] [tinyint] NULL,
	[Offer] [varchar](50) NULL,
	[AvgMonthlyGBDownload] [tinyint] NULL,
	[Internet_type] [varchar](50) NULL,
	[Charges_ID] [int] NULL,
	[Service_No] [tinyint] NULL,
	Phone_Service varchar(5),
Multiple_Lines varchar(5),
Internet_Service varchar(5),
Online_Security varchar(5),
Online_Backup varchar(5),
Device_Protection_Plan varchar(5),
Premium_Tech_Support varchar(5),
Streaming_TV varchar(5),
Streaming_Movies varchar(5),
Streaming_Music varchar(5),
Unlimited_Data varchar(5),
[Satisfaction_Score] [tinyint] NULL,
	[Churn_Value] [tinyint] NULL,
	[Churn_Score] [int] NULL,
	[Churn_Category] [varchar](50) NULL,
	[Churn_Reasons] [varchar](100) NULL
)