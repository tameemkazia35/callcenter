USE [CallCenter]
GO
/****** Object:  StoredProcedure [dbo].[usp_branch_insert]    Script Date: 06/18/2016 11:28:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_branch_insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_branch_insert]
GO
/****** Object:  StoredProcedure [dbo].[usp_branch_update]    Script Date: 06/18/2016 11:28:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_branch_update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_branch_update]
GO
/****** Object:  StoredProcedure [dbo].[usp_employee_insert]    Script Date: 06/18/2016 11:28:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_employee_insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_employee_insert]
GO
/****** Object:  StoredProcedure [dbo].[usp_employee_update]    Script Date: 06/18/2016 11:28:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_employee_update]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_employee_update]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserInfoByHomeNo]    Script Date: 06/18/2016 11:28:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUserInfoByHomeNo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetUserInfoByHomeNo]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserInfoByMobile]    Script Date: 06/18/2016 11:28:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUserInfoByMobile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetUserInfoByMobile]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserInfoByOfficeNo]    Script Date: 06/18/2016 11:28:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUserInfoByOfficeNo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetUserInfoByOfficeNo]
GO
/****** Object:  StoredProcedure [dbo].[usp_SaveCustomer]    Script Date: 06/18/2016 11:28:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SaveCustomer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SaveCustomer]
GO
/****** Object:  Table [dbo].[POS_Delivery_CusOrdList]    Script Date: 06/18/2016 11:28:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POS_Delivery_CusOrdList]') AND type in (N'U'))
DROP TABLE [dbo].[POS_Delivery_CusOrdList]
GO
/****** Object:  Table [dbo].[tbl_Branch]    Script Date: 06/18/2016 11:28:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Branch]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_Branch]
GO
/****** Object:  Table [dbo].[tbl_Customers]    Script Date: 06/18/2016 11:28:49 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tbl_Customers_cCreatedOn]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tbl_Customers] DROP CONSTRAINT [DF_tbl_Customers_cCreatedOn]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tbl_Customers_cUpdatedOn]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tbl_Customers] DROP CONSTRAINT [DF_tbl_Customers_cUpdatedOn]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Customers]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_Customers]
GO
/****** Object:  Table [dbo].[tbl_Employee]    Script Date: 06/18/2016 11:28:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Employee]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_Employee]
GO
/****** Object:  Table [dbo].[tbl_Employee]    Script Date: 06/18/2016 11:28:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Employee]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Employee](
	[eID] [int] IDENTITY(1,1) NOT NULL,
	[eEmployeeCode] [nvarchar](50) NULL,
	[ePassword] [nvarchar](50) NULL,
	[eType] [nvarchar](50) NULL,
	[eFullName] [nvarchar](500) NULL,
	[eMobile] [nvarchar](50) NULL,
	[eAddress] [nvarchar](500) NULL,
	[eDOB] [nvarchar](50) NULL,
	[eStatus] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Employee] PRIMARY KEY CLUSTERED 
(
	[eID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tbl_Customers]    Script Date: 06/18/2016 11:28:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Customers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Customers](
	[custID] [int] IDENTITY(1,1) NOT NULL,
	[custBID] [nvarchar](50) NULL,
	[cFirstname] [nvarchar](200) NULL,
	[cFamilyname] [nvarchar](200) NULL,
	[cCompany] [nvarchar](500) NULL,
	[cMobileNo] [nvarchar](50) NULL,
	[cHomeNo] [nvarchar](50) NULL,
	[cOfficeNo] [nvarchar](50) NULL,
	[cCity] [nvarchar](50) NULL,
	[cStreet] [nvarchar](100) NULL,
	[cBuilding] [nvarchar](50) NULL,
	[cFloor] [nvarchar](50) NULL,
	[cZone] [nvarchar](100) NULL,
	[cAppartment] [nvarchar](50) NULL,
	[cNear] [nvarchar](50) NULL,
	[cPAOtherNo] [nvarchar](50) NULL,
	[cPAFax] [nvarchar](50) NULL,
	[cPAEmail] [nvarchar](200) NULL,
	[cPAZipCode] [nvarchar](50) NULL,
	[cSAOtherNo] [nvarchar](50) NULL,
	[cSAFax] [nvarchar](50) NULL,
	[cSAEmail] [nvarchar](200) NULL,
	[cSAZipCode] [nvarchar](50) NULL,
	[cLastSelectedBranch] [int] NULL,
	[cCreatedOn] [datetime] NULL CONSTRAINT [DF_tbl_Customers_cCreatedOn]  DEFAULT (getdate()),
	[cUpdatedOn] [datetime] NULL CONSTRAINT [DF_tbl_Customers_cUpdatedOn]  DEFAULT (getdate()),
	[cBranchId] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Customers] PRIMARY KEY CLUSTERED 
(
	[custID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[tbl_Branch]    Script Date: 06/18/2016 11:28:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Branch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Branch](
	[bID] [int] IDENTITY(1,1) NOT NULL,
	[bCode] [int] NULL,
	[bName] [nvarchar](200) NOT NULL,
	[bAddress] [nvarchar](500) NULL,
	[bIP] [nvarchar](50) NULL,
	[bDBConnectionString] [nvarchar](500) NULL,
	[bOrderingWSurl] [nvarchar](max) NULL,
	[bInvoiceWSurl] [nvarchar](max) NULL,
	[bCreatedOn] [datetime] NULL,
	[bUpdatedOn] [datetime] NULL,
	[bCreatedBy] [nvarchar](50) NULL,
	[bUpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Branch] PRIMARY KEY CLUSTERED 
(
	[bID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[POS_Delivery_CusOrdList]    Script Date: 06/18/2016 11:28:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POS_Delivery_CusOrdList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POS_Delivery_CusOrdList](
	[CusOrdNo] [int] IDENTITY(1,1) NOT NULL,
	[bID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[WorkStationID] [int] NULL,
	[OrderID] [int] NOT NULL,
	[OrderMenuID] [int] NULL,
	[OrderNumber] [int] NULL,
	[CustomerID] [int] NULL,
	[BranchName] [nvarchar](50) NULL,
	[CustomerName] [varchar](150) NULL,
	[phoneno] [nvarchar](50) NULL,
	[amount] [real] NULL,
	[OrdDateTime] [datetime] NULL,
	[OrdAddress] [varchar](250) NULL,
	[DriverId] [int] NULL,
	[DriverName] [varchar](150) NULL,
	[DeliverystatusID] [int] NULL,
	[DeliveryStatus] [varchar](80) NULL,
	[DeliveryTime] [varchar](50) NULL,
	[DespatchTime] [varchar](50) NULL,
	[paidby] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[CusOrdNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_SaveCustomer]    Script Date: 06/18/2016 11:28:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SaveCustomer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_SaveCustomer]
@custID					int=0, 
@custBID				nvarchar(50),
@cFirstname				nvarchar(200), 
@cFamilyname			nvarchar(200), 
@cCompany				nvarchar(500), 
@cMobileNo				nvarchar(50), 
@cHomeNo				nvarchar(50), 
@cOfficeNo				nvarchar(50), 
@cCity					nvarchar(50), 
@cStreet				nvarchar(50), 
@cBuilding				nvarchar(50), 
@cFloor					nvarchar(50), 
@cZone					nvarchar(100), 
@cAppartment			nvarchar(50),  
@cNear					nvarchar(50),  
@cPAOtherNo				nvarchar(50), 
@cPAFax					nvarchar(50), 
@cPAEmail				nvarchar(200), 
@cPAZipCode				nvarchar(50),  
@cSAOtherNo				nvarchar(50),  
@cSAFax					nvarchar(50), 
@cSAEmail				nvarchar(200),  
@cSAZipCode				nvarchar(50), 
@cLastSelectedBranch	int
AS
BEGIN
	DECLARE @isFound INT;
	SET @isFound = (SELECT COUNT(*) FROM tbl_Customers WHERE cMobileNo=@cMobileNo and cBranchId=@cLastSelectedBranch);
	
	IF @isFound = 0 
	BEGIN
		INSERT INTO tbl_Customers(custBID, cFirstname,cFamilyname, cCompany, cMobileNo, cHomeNo, cOfficeNo, cCity, cStreet, cBuilding, cFloor, cZone, cAppartment, cNear, cPAOtherNo, cPAFax, cPAEmail, cPAZipCode, cSAOtherNo, cSAFax, cSAEmail, cSAZipCode, cLastSelectedBranch,cBranchId)
		VALUES(@custBID, @cFirstname, @cFamilyname, @cCompany, @cMobileNo, @cHomeNo, @cOfficeNo, @cCity, @cStreet, @cBuilding, @cFloor, @cZone, @cAppartment, @cNear, @cPAOtherNo, @cPAFax, @cPAEmail, @cPAZipCode, @cSAOtherNo, @cSAFax, @cSAEmail, @cSAZipCode, @cLastSelectedBranch,@cLastSelectedBranch);
	END
	ELSE
	BEGIN
		IF @custID = 0 
		BEGIN
			SET @custID = (SELECT custID FROM tbl_Customers WHERE cMobileNo=@cMobileNo and cBranchId=@cLastSelectedBranch);
		END
	    
		UPDATE tbl_Customers 
		SET
			custBID = @custBID,
			cFirstname=@cFirstname, cFamilyname=@cFamilyname, cCompany=@cCompany, 
			cMobileNo=@cMobileNo, cHomeNo=@cHomeNo, cOfficeNo=@cOfficeNo, cCity=@cCity, 
			cStreet=@cStreet, cBuilding=@cBuilding, cFloor=@cFloor, cZone=@cZone, 
			cAppartment=@cAppartment, cNear=@cNear, cPAOtherNo=@cPAOtherNo, cPAFax=@cPAFax, 
			cPAEmail=@cPAEmail, cPAZipCode=@cPAZipCode, cSAOtherNo=@cSAOtherNo, cSAFax=@cSAFax, 
			cSAEmail=@cSAEmail, cSAZipCode=@cSAZipCode, cLastSelectedBranch=@cLastSelectedBranch, cUpdatedOn = GETDATE()
		WHERE
			custID = @custID and cBranchId=@cLastSelectedBranch;
	END
	
END ' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserInfoByOfficeNo]    Script Date: 06/18/2016 11:28:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUserInfoByOfficeNo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_GetUserInfoByOfficeNo]
@cOfficeNo nvarchar(50),
@BranchName nvarchar(100)
AS
BEGIN
	SELECT 
		*
	FROM
	tbl_Customers
	WHERE
	cOfficeNo = @cOfficeNo and cBranchId=(select bID from tbl_Branch where bName=@BranchName);
END


' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserInfoByMobile]    Script Date: 06/18/2016 11:28:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUserInfoByMobile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_GetUserInfoByMobile]
@cMobileNo nvarchar(50),
@BranchName nvarchar(100)
AS
BEGIN
	SELECT 
		*
	FROM
	tbl_Customers
	WHERE
	cMobileNo = @cMobileNo and cBranchId=(select bID from tbl_Branch where bName=@BranchName);
END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserInfoByHomeNo]    Script Date: 06/18/2016 11:28:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetUserInfoByHomeNo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_GetUserInfoByHomeNo]
@cHomeNo nvarchar(50),
@BranchName nvarchar(100)
AS
BEGIN
	SELECT 
		*
	FROM
	tbl_Customers
	WHERE
	cHomeNo = @cHomeNo and cBranchId=(select bID from tbl_Branch where bName=@BranchName);
END


' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_employee_update]    Script Date: 06/18/2016 11:28:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_employee_update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_employee_update]
@eID	int,
@eEmployeeCode nvarchar(50),
@ePassword nvarchar(50),
@eType nvarchar(50),
@eFullName nvarchar(500),
@eMobile nvarchar(50),
@eAddress nvarchar(500),
@eDOB nvarchar(50)
AS
BEGIN

	UPDATE tbl_Employee
	SET
		eEmployeeCode=@eEmployeeCode,
		ePassword=@ePassword,
		eType=@eType,
		eFullName=@eFullName,
		eMobile=@eMobile,
		eAddress=@eAddress,
		eDOB=@eDOB
	WHERE
		eID = @eID;
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_employee_insert]    Script Date: 06/18/2016 11:28:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_employee_insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[usp_employee_insert]
@eEmployeeCode nvarchar(50),
@ePassword nvarchar(50),
@eType nvarchar(50),
@eFullName nvarchar(500),
@eMobile nvarchar(50),
@eAddress nvarchar(500),
@eDOB nvarchar(50)
AS
BEGIN

	INSERT INTO tbl_Employee(eEmployeeCode,ePassword,eType,eFullName,eMobile,eAddress,eDOB,eStatus) VALUES
	(@eEmployeeCode,@ePassword,@eType,@eFullName,@eMobile,@eAddress,@eDOB,''Active'');
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_branch_update]    Script Date: 06/18/2016 11:28:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_branch_update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_branch_update]
@bID int,
@bCode int,
@bName nvarchar(200),
@bAddress nvarchar(500),
@bIP nvarchar(50),
@bDBConnectionString nvarchar(500),
@bOrderingWSurl nvarchar(MAX),
@bInvoiceWSurl nvarchar(MAX),
@bCreatedBy nvarchar(50)
AS
BEGIN

	UPDATE tbl_Branch
	SET
	bCode=@bCode,
	bName=@bName,
	bAddress=@bAddress,
	bIP=@bIP,
	bDBConnectionString=@bDBConnectionString,
	bOrderingWSurl=@bOrderingWSurl,
	bInvoiceWSurl=@bInvoiceWSurl,
	bUpdatedOn=GETDATE(),
	bUpdatedBy= @bCreatedBy
	WHERE
	bID = @bID;
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_branch_insert]    Script Date: 06/18/2016 11:28:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_branch_insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_branch_insert]
@bCode int,
@bName nvarchar(200),
@bAddress nvarchar(500),
@bIP nvarchar(50),
@bDBConnectionString nvarchar(500),
@bOrderingWSurl nvarchar(MAX),
@bInvoiceWSurl nvarchar(MAX),
@bCreatedBy nvarchar(50)
AS
BEGIN

	INSERT INTO tbl_Branch(bCode,bName,bAddress,bIP,bDBConnectionString,bOrderingWSurl,bInvoiceWSurl,bCreatedOn,bCreatedBy) VALUES
	(@bCode,@bName,@bAddress,@bIP,@bDBConnectionString,@bOrderingWSurl,@bInvoiceWSurl,GETDATE(),@bCreatedBy);
END' 
END
GO
