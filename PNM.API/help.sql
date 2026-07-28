USE [DB_PNM_2026]
GO
/****** Object:  StoredProcedure [dbo].[SP_PNM_2026]    Script Date: 28-07-2026 21:57:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Event:GetUserByGuid~!Guid:c39a1963-f8da-4898-a4dd-2c46f5b8ffe7~!format:compactjson

---select top 200 * from dbo.tbl_Log order by 1 desc
--- exec [dbo].[SP_PNM_2026] 'Event:GetUserByGuid~!Guid:c39a1963-f8da-4898-a4dd-2c46f5b8ffe7~!Empguid:c39a1963-f8da-4898-a4dd-2c46f5b8ffe7~!format:compactjson'

ALTER PROC [dbo].[SP_PNM_2026](@ParameterString NVARCHAR(MAX)='')
AS
BEGIN
SET NOCOUNT ON;
DECLARE @LastId NVARCHAR(50);
INSERT INTO dbo.tbl_Log(LogText,Status,Reasons) VALUES(@ParameterString,'Success','');
SET @LastId=CAST(SCOPE_IDENTITY() AS NVARCHAR(50));
BEGIN TRY

DECLARE
@Event VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Event'),
@Guid VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Guid'),
@AssetID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetID') AS INT),
@LogID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LogID') AS INT),
@OperatorID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OperatorID') AS INT),
@LogDate DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LogDate') AS DATE),
@StartHMR DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'StartHMR') AS DECIMAL(18,2)),
@EndHMR DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EndHMR') AS DECIMAL(18,2)),
@MachineStatus VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MachineStatus'),
@Remarks NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Remarks'),
@Today DATE=CAST(GETDATE() AS DATE),
@AllocationID INT,@SelectedOperatorID INT,
@ProjectID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ProjectID') AS INT),
@LastEndHMR DECIMAL(18,2),@StartHMR_End DECIMAL(18,2),
@TypeName VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TypeName'),
@CreatedBy INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@NewAssetTypeID INT,@NewCategoryCode VARCHAR(50),@NewCategoryID INT,
@AssetTypeID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetTypeID') AS INT),
@CreatedByCategory INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@CategoryName VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CategoryName'),
@CategoryCode VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CategoryCode'),
@ParentCategoryID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ParentCategoryID') AS INT),
@TrackOutput BIT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TrackOutput') AS BIT),
@OutputName VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OutputName'),
@CategoryID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CategoryID') AS INT),
@RecordingUnit VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'RecordingUnit'),
@OutputUnit VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OutputUnit'),
@OutputRequired BIT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OutputRequired') AS BIT),
@FuelType VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FuelType'),
@FuelUnit VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FuelUnit'),
@MandatoryCertificates NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MandatoryCertificates'),
@AssetCode VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetCode'),
@AssetName VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetName'),
@OwnershipType VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OwnershipType'),
@AssetTypeID_Add INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetTypeID') AS INT),
@CategoryID_Add INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CategoryID') AS INT),
@Make VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Make'),
@ModelName VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModelName'),
@YearOfManufacture INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'YearOfManufacture') AS INT),
@RegistrationNo VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'RegistrationNo'),
@EngineNo VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EngineNo'),
@ChassisNo VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ChassisNo'),
@FuelType_Add VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FuelType'),
@Capacity VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Capacity'),
@RecordingUnit_Add VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'RecordingUnit'),
@PurchasePrice DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PurchasePrice') AS DECIMAL(18,2)),
@PurchaseDate DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PurchaseDate') AS DATE),
@PurchaseFrom VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PurchaseFrom'),
@PurchaseInvoiceNo VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PurchaseInvoiceNo'),
@DepreciationPct DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DepreciationPct') AS DECIMAL(18,2)),
@OutputRate DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OutputRate') AS DECIMAL(18,2)),
@OutputUnit_Add VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OutputUnit'),
@VendorID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'VendorID') AS INT),
@Status_Add VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Status'),
@PhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoPath'),
@CreatedBy_Add INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@NewAssetCode VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'NewAssetCode'),
@ShiftID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ShiftID') AS INT),
@ShiftName VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ShiftName'),
@StartTime TIME=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'StartTime') AS TIME),
@EndTime TIME=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EndTime') AS TIME),
@CreatedBy_Shift INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@ShiftCode VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ShiftCode'),
@OperatorCode VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OperatorCode'),
@FullName VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FullName'),
@DateOfBirth DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DateOfBirth') AS DATE),
@Gender VARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Gender'),
@Mobile VARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Mobile'),
@EmergencyContact VARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EmergencyContact'),
@BloodGroup VARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'BloodGroup'),
@AadhaarNo VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AadhaarNo'),
@PANNo VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PANNo'),
@LicenseNo_Operator VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LicenseNo'),
@LicenseType VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LicenseType'),
@LicenseExpiry DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LicenseExpiry') AS DATE),
@Address NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Address'),
@DateOfJoining DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DateOfJoining') AS DATE),
@Status_Operator VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Status'),
@PhotoPath_Operator VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoPath'),
@CreatedBy_Operator INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@EndedBy_Alloc INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT),
@ProjectID_Alloc INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ProjectID') AS INT),
@OperatorID_Alloc INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OperatorID') AS INT),
@StartDate_Alloc DATETIME = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'StartDate') AS DATETIME),
@EndDate_Alloc DATETIME = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EndDate') AS DATETIME),
@Remarks_Alloc NVARCHAR(MAX) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Remarks'),
@CreatedBy_Alloc INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@StartDateTime DATETIME=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'StartDateTime') AS DATETIME),
@EndDateTime DATETIME=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EndDateTime') AS DATETIME),
@OutputQty DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OutputQty') AS DECIMAL(18,2)),
@WorkingRemarks NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'WorkingRemarks'),
@SubmittedBy INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'SubmittedBy') AS INT),
@ProductionQty DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ProductionQty') AS DECIMAL(18,2)),
@ProductionUnit VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ProductionUnit'),
@IdleHours DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IdleHours') AS DECIMAL(18,2)),
@BreakdownHours DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'BreakdownHours') AS DECIMAL(18,2)),
@BreakdownReason NVARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'BreakdownReason'),
@FuelDateTime DATETIME=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FuelDateTime') AS DATETIME),
@FuelQty DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FuelQty') AS DECIMAL(18,2)),
@ReadingAtFueling DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ReadingAtFueling') AS DECIMAL(18,2)),
@PhotoPath_Fuel VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoPath'),
@CreatedBy_Fuel INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@ProjectCode VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ProjectCode'),
@ProjectName VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ProjectName'),
@Location VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Location'),
@ClientName VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ClientName'),
@Status_Project VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Status'),
@StartDate_Project DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'StartDate') AS DATE),
@EndDate_Project DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EndDate') AS DATE),
@CreatedBy_Project INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@ExpenseDateTime DATETIME=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ExpenseDateTime') AS DATETIME),
@ExpenseType VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ExpenseType'),
@ExpenseAssetID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetID') AS INT),
@ExpenseAmount DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Amount') AS DECIMAL(18,2)),
@ExpenseRemarks NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Remarks'),
@ExpensePhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoPath'),
@CreatedBy_Expense INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@ExpenseID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ExpenseID') AS INT),
@CertificateID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CertificateID') AS INT),
@CertificateCode VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CertificateCode'),
@CertificateName VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CertificateName'),
@ValidityType VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ValidityType'),
@DefaultValidityDays INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DefaultValidityDays') AS INT),
@Mandatory BIT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Mandatory') AS BIT),
@CertificateDescription NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Description'),
@CreatedBy_Certificate INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@ApplicabilityID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ApplicabilityID') AS INT),
@ApplicabilityAssetTypeID TINYINT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetTypeID') AS TINYINT),
@ApplicabilityCategoryID SMALLINT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CategoryID') AS SMALLINT),
@CreatedBy_Applicability INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@MaintenanceAssetID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetID') AS INT),
@NewCertificateCode VARCHAR(50),
@MaintenanceID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MaintenanceID') AS INT),
@MaintenanceDateTime DATETIME=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MaintenanceDateTime') AS DATETIME),
@MaintenanceType VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MaintenanceType'),
@MaintenanceVendor VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'VendorName'),
@MaintenanceCost DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Cost') AS DECIMAL(18,2)),
@MaintenanceNextDueDate DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'NextDueDate') AS DATE),
@MaintenancePhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoPath'),
@MaintenanceRemarks NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Remarks'),
@CreatedBy_Maintenance INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@Latitude DECIMAL(10,7)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Latitude') AS DECIMAL(10,7)),
@Longitude DECIMAL(10,7)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Longitude') AS DECIMAL(10,7)),
@LocationTime DATETIME=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LocationTime') AS DATETIME),
@TrackingSpeed DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Speed') AS DECIMAL(18,2)),
@TrackingAddress NVARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Address'),
@CreatedBy_Tracking INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@AssetCertificateID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetCertificateID') AS INT),
@CertificateNo VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CertificateNo'),
@IssueDate DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IssueDate') AS DATE),
@ExpiryDate DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ExpiryDate') AS DATE),
@CertificateRemarks NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Remarks'),
@CertificatePhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoPath'),
@CreatedBy_AssetCertificate INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CreatedBy') AS INT),
@NewProjectCode VARCHAR(50),
@Status NVARCHAR(20),
@LicenseNo NVARCHAR(30),
@ModifiedBy INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT),
@BankName NVARCHAR(150)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'BankName'),
@AccountNo NVARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AccountNo'),
@IFSC NVARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IFSC'),
@PFNo NVARCHAR(30)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PFNo'),
@ESINo NVARCHAR(30)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ESINo'),
@OperatorType NVARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OperatorType'),
@FullName_OpPrefix VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_name'),
@DateOfBirth_OpPrefix DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_dob') AS DATE),
@Gender_OpPrefix VARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_gender'),
@Mobile_OpPrefix VARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_mobile'),
@EmergencyContact_OpPrefix VARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_emergency'),
@BloodGroup_OpPrefix VARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_ddl_blood'),
@AadhaarNo_OpPrefix VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_aadhaar'),
@PANNo_OpPrefix VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_pan'),
@LicenseNo_OpPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_license'),
@LicenseType_OpPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_license_type'),
@LicenseExpiry_OpPrefix DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_license_expiry') AS DATE),
@Address_OpPrefix NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_address'),
@DateOfJoining_OpPrefix DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_doj') AS DATE),
@Status_OpPrefix VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_ddl_status'),
@PhotoPath_OpPrefix VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_hdn_photo_path'),
@CreatedBy_OpPrefix INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_CreatedBy') AS INT),
@BankName_OpPrefix NVARCHAR(150)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_bank'),
@AccountNo_OpPrefix NVARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_account'),
@IFSC_OpPrefix NVARCHAR(20)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_ifsc'),
@PFNo_OpPrefix NVARCHAR(30)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_pf'),
@ESINo_OpPrefix NVARCHAR(30)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_esi'),
@OperatorType_OpPrefix NVARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_text_type'),
@Template36PhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_file_profile_Template36'),
@FrontPhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FrontPhotoPath'),
@BackPhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'BackPhotoPath'),
@LeftPhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LeftPhotoPath'),
@RightPhotoPath VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'RightPhotoPath'),
@AssetPhotoID INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetPhotoID') AS INT),
@PhotoType VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoType'),
@DisplayOrder INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DisplayOrder') AS INT),
@AssetID_AssetPrefix INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_AssetID') AS INT),
@AssetCode_AssetPrefix VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_AssetCode'),
@AssetName_AssetPrefix VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_AssetName'),
@OwnershipType_AssetPrefix VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_OwnershipType'),
@AssetTypeID_AssetPrefix INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_AssetTypeID') AS INT),
@CategoryID_AssetPrefix INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_CategoryID') AS INT),
@Make_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_Make'),
@ModelName_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_ModelName'),
@YearOfManufacture_AssetPrefix INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_YearOfManufacture') AS INT),
@RegistrationNo_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_RegistrationNo'),
@EngineNo_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_EngineNo'),
@ChassisNo_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_ChassisNo'),
@FuelType_AssetPrefix VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_FuelType'),
@Capacity_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_Capacity'),
@RecordingUnit_AssetPrefix VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_RecordingUnit'),
@PurchasePrice_AssetPrefix DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_PurchasePrice') AS DECIMAL(18,2)),
@PurchaseDate_AssetPrefix DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_PurchaseDate') AS DATE),
@PurchaseFrom_AssetPrefix VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_PurchaseFrom'),
@PurchaseInvoiceNo_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_PurchaseInvoiceNo'),
@DepreciationPct_AssetPrefix DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_DepreciationPct') AS DECIMAL(18,2)),
@OutputRate_AssetPrefix DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_OutputRate') AS DECIMAL(18,2)),
@OutputUnit_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_OutputUnit'),
@Status_AssetPrefix VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_Status'),
@PhotoPath_AssetPrefix VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_PhotoPath'),
@CreatedBy_AssetPrefix INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_CreatedBy') AS INT),
@ModifiedBy_AssetPrefix INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_ModifiedBy') AS INT),
@FrontPhotoPath_AssetPrefix VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_file_front_Template36'),
@BackPhotoPath_AssetPrefix VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_file_back_Template36'),
@LeftPhotoPath_AssetPrefix VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_file_left_Template36'),
@RightPhotoPath_AssetPrefix VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_file_right_Template36'),
@EmployeeID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EmployeeID') AS INT),
@RoleID     INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'RoleID') AS INT),
@Username   NVARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Username'),
@EMPGuidId VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Empguid'),
@EndReadingPhoto VARCHAR(500)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EndReadingPhoto'),
@RemarkPhoto VARCHAR(500)=ISNULL(NULLIF(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'RemarkPhoto'),''),DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Remark Photo')),
@NewOperatorCode VARCHAR(50),
@Client VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Client'),
@Division VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Division'),
@SerialNo VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'SerialNo'),
@Client_AssetPrefix VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_Client'),
@Division_AssetPrefix VARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_Division'),
@SerialNo_AssetPrefix VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'asset_SerialNo'),
@LogVerificationStatus BIT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LogVerificationStatus') AS BIT),
@LogVerificationDate DATETIME2(0) = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LogVerificationDate') AS DATETIME2(0)),
@DivisionID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DivisionID') AS INT),
@DivisionName NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DivisionName'),
@IsActive BIT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IsActive') AS BIT),
@MakeID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MakeID') AS INT),
@MakeName NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MakeName'),
@AssetCatName NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetCatName'),
@SubTypeName NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'SubTypeName'),
@ModelID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModelID') AS INT),
@ServiceTypeID NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ServiceTypeID'),
@ModelNo NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModelNo'),
@StartKMR DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'StartKMR') AS DECIMAL(18,2)),
@EndKMR DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EndKMR') AS DECIMAL(18,2)),
@ExistingStartHMR DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ExistingStartHMR') AS DECIMAL(18,2)),
@ExistingEndHMR DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ExistingEndHMR') AS DECIMAL(18,2)),
@ExistingStartKMR DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ExistingStartKMR') AS DECIMAL(18,2)),
@ExistingEndKMR  DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ExistingEndKMR') AS DECIMAL(18,2)),
@AssetRecordingUnit VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetRecordingUnit'),
@UsesHMR BIT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'UsesHMR') AS BIT),
@UsesKMR BIT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'UsesKMR') AS BIT),
@UsesHMR_End BIT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'UsesHMR_End') AS BIT),
@UsesKMR_End BIT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'UsesKMR_End') AS BIT),
@LunchDinnerHours DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'LunchDinnerHours') AS DECIMAL(18,2)),
@form1_ddl_info_provider VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_info_provider'),
@form1_ddl_customer VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_customer'),
@form1_ddl_site VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_site'),
@form1_ddl_plant VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_plant'), 
@form1_text_start_date DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_start_date') AS DATE),
@form1_ddl_start_hour INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_start_hour') AS INT),
@form1_ddl_start_minute INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_start_minute') AS INT),
@form1_text_stop_date DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_stop_date') AS DATE),
@form1_ddl_stop_hour INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_stop_hour') AS INT),
@form1_ddl_stop_minute INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_stop_minute') AS INT),
@form1_ddl_breakdown_hour INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_breakdown_hour') AS INT),
@form1_ddl_breakdown_minute INT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_breakdown_minute') AS INT),
@form1_text_volume DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_volume') AS DECIMAL(18,2)),
@form1_text_diesel_received DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_diesel_received') AS DECIMAL(18,2)),
@form1_text_diesel_rate DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_diesel_rate')AS DECIMAL(18,2)),
@form1_text_cement_received DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_cement_received') AS DECIMAL(18,2)),
@form1_text_hmr DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_hmr') AS DECIMAL(18,2)),@form1_text_mixer_hmr DECIMAL(18,2)=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_mixer_hmr') AS DECIMAL(18,2)),
@form1_ddl_concrete_type VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_concrete_type'),
@form1_ddl_pour_location VARCHAR(100)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_pour_location'),
@form1_text_incharge_customer NVARCHAR(150)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_incharge_customer'),
@form1_text_incharge_rohan NVARCHAR(150)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_incharge_rohan'),
@form1_text_note NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_note'),
@form1_text_fr_date DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_fr_date') AS DATE),
@form1_CreatedBy VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_CreatedBy'),
@form1_mis_session_userid VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_mis_session_userid'),
@mis_session_userid VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'mis_session_userid'),
@form1_ddl_recent_entry VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_ddl_recent_entry'),
@PermissionID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PermissionID') AS INT),
@PermissionKey VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PermissionKey'),
@MenuName NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MenuName'),
@MenuType NVARCHAR(40) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MenuType'),
@ParentPermissionKey NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ParentPermissionKey'),
@SortOrder_Menu INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'SortOrder') AS INT),
@IsVisible BIT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IsVisible') AS BIT),
@ViewName NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ViewName'),
@IconClass NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IconClass'),
@SiteID         NVARCHAR(50)  = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'SiteID'),
@MachineID      NVARCHAR(50)  = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'MachineID'),
@AttachFor      NVARCHAR(10)  = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'AttachFor'),
@Month          NVARCHAR(2)   = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'Month'),
@Year           NVARCHAR(4)   = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'Year'),
@AttachmentDate DATE          = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'AttachmentDate') AS DATE),
@FilePath       NVARCHAR(500) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'FilePath'),
@FileName       NVARCHAR(300) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'FileName'),
@TemplateID     NVARCHAR(20)  = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'TemplateID'),
@DocumentTypeID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DocumentTypeID') AS INT),
@DocumentType VARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DocumentType'),
@Category VARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Category'),
@Authority VARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Authority'),
@Notes_Document VARCHAR(500) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Notes'),
@FieldsJson NVARCHAR(MAX) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FieldsJson'),
@FileExtension VARCHAR(20) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FileExtension'),
@FileSizeKB DECIMAL(18,2) = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FileSizeKB') AS DECIMAL(18,2)),
@AttachmentID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AttachmentID') AS INT),
@DocumentFieldID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DocumentFieldID') AS INT),
@FieldName VARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FieldName'),
@FieldLabel VARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FieldLabel'),
@FieldDataType VARCHAR(30) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FieldDataType'),
@FieldOptions NVARCHAR(MAX) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'FieldOptions'),
@IsMandatory BIT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IsMandatory') AS BIT),
@SortOrder INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'SortOrder') AS INT),
@IsActive_Field BIT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IsActive') AS BIT),
@ProposedEndDate_Alloc DATETIME = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EndDate') AS DATETIME),
@AuthEmployeeID INT=NULL,
@AuthRoleID INT=NULL,
@AuthRoleName VARCHAR(100)=NULL,
@ScopeDivisionID TINYINT=NULL,
@ScopeDivisionName VARCHAR(200)=NULL,
@MountCode VARCHAR(100) = LTRIM(RTRIM(ISNULL(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'MountCode'),''))),
@AssetIDs VARCHAR(MAX) = LTRIM(RTRIM(ISNULL(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetID'),''))),
@TMChassisAssetID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisAssetID') AS INT),
@TMChassisAssetCode VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisAssetCode'),
@TMChassisMake VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisMake'),
@TMChassisModel VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisModel'),
@TMChassisYearOfManufacture INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisYearOfManufacture') AS INT),
@TMChassisRegistrationNo VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisRegistrationNo'),
@TMChassisSerialNo VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisSerialNo'),
@TMChassisEngineNo VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisEngineNo'),
@TMChassisNo VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisNo'),
@TMChassisCapacity VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMChassisCapacity'),
@TMUpperAssetID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMUpperAssetID') AS INT),
@TMUpperAssetCode VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMUpperAssetCode'),
@TMUpperMake VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMUpperMake'),
@TMUpperModel VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMUpperModel'),
@TMUpperSerialNo VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMUpperSerialNo'),
@TMUpperEngineNo VARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'TMUpperEngineNo'),
@CustomerID VARCHAR(50)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'CustomerID'),
@SitesJson NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'SitesJson'),
@EmployeesJson NVARCHAR(MAX)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EmployeesJson'),
@DateFrom DATE = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'datefrom') AS DATE),
@DateTo DATE = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'dateto') AS DATE),
@ddl_month VARCHAR(10)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_month'),
@text_year VARCHAR(10)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'text_year'),
@ddl_division NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_division'),
@ddl_customer NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_customer'),
@ddl_site NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_site'),
@ddl_workarea NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_workarea'),
@ddl_machine NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_machine'),
@ddl_shift NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_shift'),
@ddl_drive NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_drive'),
@ddl_helper NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_helper'),
@chk_breakdownonly BIT=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'chk_breakdownonly') AS BIT),
@ddl_machinetype NVARCHAR(200)=DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ddl_machinetype'),
@form1_text_to_date DATE=TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'form1_text_to_date') AS DATE);



declare @empid varchar(50),@UserNamecss nvarchar(200)

if(isnull(@EMPGuidId,'')<>'')
	begin

select @empid=isnull(cast(employee_id as nvarchar(max)),''),@UserNamecss=employee_name from Rohanreporting..employee_master where Pguids=@EMPGuidId


if exists(select 1 from [dbo].[mst_UserRole] where Guid=@EMPGuidId)
	begin
		update [dbo].[mst_UserRole] set Username=@UserNamecss where Guid=@EMPGuidId
	end 
else 
	begin
		--insert into [dbo].[mst_UserRole](EmployeeID,Username,Guid) values(cast(isnull(@empid,'0') as int),@UserNamecss,@EMPGuidId)
		insert into [dbo].[mst_UserRole](EmployeeID, Username, Guid, RoleID)
                        values(cast(isnull(@empid,'0') as int), @UserNamecss, @EMPGuidId, 8)
	end

	select u.UserRoleID, u.EmployeeID, u.Username,
        u.RoleID, u.IsActive, u.Guid, u.OperatorID,
        r.RoleName
	 from [dbo].[mst_UserRole] u
	 left join [dbo].[mst_Role] r on r.RoleID = u.RoleID
	 where u.Guid = @EMPGuidId
end

--select @empid,@UserNamecss,@EMPGuidId

IF ISNULL(@Guid,'') <> ''
BEGIN
    SELECT TOP 1
        @AuthEmployeeID = ur.EmployeeID,
        @AuthRoleID = ur.RoleID,
        @AuthRoleName = ISNULL(r.RoleName,''),
        @ScopeDivisionID = ur.DivisionID,
        @ScopeDivisionName = ISNULL(d.DivisionName,'')
    FROM dbo.mst_UserRole ur
    LEFT JOIN dbo.mst_Role r
        ON r.RoleID = ur.RoleID
    LEFT JOIN dbo.mst_Division d
        ON d.DivisionID = ur.DivisionID
    WHERE ur.Guid = @Guid
      AND ISNULL(ur.IsActive,1) = 1
    ORDER BY ur.UserRoleID DESC;
END

IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Admin'
BEGIN
    SET @ScopeDivisionID = 0;
END
-- Asset Master Event start here
IF(@Event='GetAssetTypeList')
BEGIN 
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
    SELECT
        t.AssetTypeID, t.TypeName,
        t.IsActive,
        t.CreatedBy,
        t.CreatedOn,
        COUNT(CASE WHEN ISNULL(c.IsActive,1)=1 THEN 1 END) AS CategoryCount
    FROM dbo.mst_AssetType t
    LEFT JOIN dbo.mst_AssetCategory c
        ON c.AssetTypeID = t.AssetTypeID
       AND ISNULL(c.IsActive,1)=1
    WHERE ISNULL(t.IsActive,1)=1
    GROUP BY
        t.AssetTypeID,
        t.TypeName,
        t.IsActive,
        t.CreatedBy,
        t.CreatedOn
    ORDER BY t.TypeName;
END

ELSE IF(@Event='GetDashboardData')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF OBJECT_ID('tempdb..#ScopedAssets') IS NOT NULL DROP TABLE #ScopedAssets;
    IF OBJECT_ID('tempdb..#LatestLog') IS NOT NULL DROP TABLE #LatestLog;
    IF OBJECT_ID('tempdb..#Cards') IS NOT NULL DROP TABLE #Cards;
    IF OBJECT_ID('tempdb..#Utilization') IS NOT NULL DROP TABLE #Utilization;
    IF OBJECT_ID('tempdb..#Alerts') IS NOT NULL DROP TABLE #Alerts;
    IF OBJECT_ID('tempdb..#Production') IS NOT NULL DROP TABLE #Production;
    IF OBJECT_ID('tempdb..#WorkingMachines') IS NOT NULL DROP TABLE #WorkingMachines;
    IF OBJECT_ID('tempdb..#StatusCounts') IS NOT NULL DROP TABLE #StatusCounts;
    IF OBJECT_ID('tempdb..#Fuel') IS NOT NULL DROP TABLE #Fuel;

    SELECT
        a.AssetID,
        a.AssetCode,
        a.AssetName,
        a.DivisionID
    INTO #ScopedAssets
    FROM dbo.mst_Asset a
    WHERE ISNULL(a.IsActive,1)=1
      AND (
            ISNULL(@ScopeDivisionID,0)=0
            OR a.DivisionID = @ScopeDivisionID
          );

    SELECT
        dl.LogID,
        dl.LogDate,
        dl.AssetID,
        dl.OperatorID,
        dl.ProjectID,
        dl.MachineStatus,
        dl.SubmissionStatus,
        dl.TotalHours,
        dl.IdleHours,
        dl.BreakdownHours,
        dl.ProductionQty,
        dl.ProductionUnit,
        dl.StartDateTime,
        ROW_NUMBER() OVER
        (
            PARTITION BY dl.AssetID
            ORDER BY
                CASE WHEN ISNULL(dl.SubmissionStatus,'')='Draft' THEN 0 ELSE 1 END,
                ISNULL(dl.StartDateTime, dl.CreatedOn) DESC,
                dl.LogID DESC
        ) AS rn
    INTO #LatestLog
    FROM dbo.trn_DailyLog dl
    INNER JOIN #ScopedAssets sa
        ON sa.AssetID = dl.AssetID
    WHERE ISNULL(dl.AssetID,0) > 0;

	   SELECT
		COUNT(DISTINCT sa.AssetID) AS TotalMachines,
		COUNT(DISTINCT CASE
			WHEN ll.MachineStatus = 'Working'
			THEN ll.AssetID
		END) AS ActiveMachines,
		COUNT(DISTINCT CASE
			WHEN ll.MachineStatus = 'Breakdown'
			THEN ll.AssetID
		END) AS BreakdownMachines,
		COUNT(DISTINCT CASE
			WHEN ll.MachineStatus IN ('Under Maintenance','UnderMaintenance','Maintenance')
			THEN ll.AssetID
		END) AS MaintenanceMachines
	INTO #Cards
	FROM #ScopedAssets sa
	LEFT JOIN #LatestLog ll
		ON ll.AssetID = sa.AssetID
	   AND ll.rn = 1;

    SELECT
        CAST(dl.LogDate AS date) AS LogDate,
        SUM(CASE WHEN dl.MachineStatus = 'Working' THEN ISNULL(dl.TotalHours,0) ELSE 0 END) AS WorkingHours,
        SUM(CASE WHEN dl.MachineStatus = 'Idle' THEN ISNULL(dl.IdleHours,0) ELSE 0 END) AS IdleHours,
        SUM(CASE WHEN dl.MachineStatus = 'Breakdown' THEN ISNULL(dl.BreakdownHours, ISNULL(dl.TotalHours,0)) ELSE 0 END) AS BreakdownHours,
        SUM(CASE WHEN dl.MachineStatus IN ('Under Maintenance','UnderMaintenance','Maintenance') THEN ISNULL(dl.TotalHours,0) ELSE 0 END) AS MaintenanceHours
    INTO #Utilization
    FROM dbo.trn_DailyLog dl
    INNER JOIN #ScopedAssets sa
        ON sa.AssetID = dl.AssetID
    WHERE CAST(dl.LogDate AS date) >= DATEADD(DAY,-6,CAST(GETDATE() AS date))
    GROUP BY CAST(dl.LogDate AS date);

    SELECT TOP 10
        sa.AssetID,
        sa.AssetCode,
        sa.AssetName,
        ll.ProjectID,
        p.ProjectName,
        ll.OperatorID,
        o.FullName AS OperatorName,
        CASE
            WHEN ll.MachineStatus IN ('Under Maintenance','UnderMaintenance','Maintenance') THEN 'Under Maintenance'
            ELSE ll.MachineStatus
        END AS CurrentStatus,
        CASE
            WHEN ll.MachineStatus = 'Breakdown' THEN 'Breakdown'
            WHEN ll.MachineStatus IN ('Under Maintenance','UnderMaintenance','Maintenance') THEN 'Maintenance'
            WHEN ll.MachineStatus = 'Idle' THEN 'Idle'
            WHEN ll.MachineStatus = 'Working' THEN 'Working'
            ELSE 'Unknown'
        END AS AlertType,
        CASE
            WHEN ll.MachineStatus = 'Breakdown' THEN 'Machine is in breakdown'
            WHEN ll.MachineStatus IN ('Under Maintenance','UnderMaintenance','Maintenance') THEN 'Machine is under maintenance'
            WHEN ll.MachineStatus = 'Idle' THEN 'Machine is idle'
            WHEN ll.MachineStatus = 'Working' AND ll.SubmissionStatus = 'Draft' THEN 'Machine is currently working on site'
            ELSE 'Current machine status available'
        END AS AlertMessage,
        CASE
            WHEN ll.MachineStatus = 'Breakdown' THEN 1
            WHEN ll.MachineStatus IN ('Under Maintenance','UnderMaintenance','Maintenance') THEN 2
            WHEN ll.MachineStatus = 'Idle' THEN 3
            WHEN ll.MachineStatus = 'Working' THEN 4
            ELSE 5
        END AS SortOrder
    INTO #Alerts
    FROM #LatestLog ll
    INNER JOIN #ScopedAssets sa
        ON sa.AssetID = ll.AssetID
    LEFT JOIN dbo.mst_Project p
        ON p.ProjectID = ll.ProjectID
    LEFT JOIN dbo.mst_Operator o
        ON o.OperatorID = ll.OperatorID
    WHERE ll.rn = 1
    ORDER BY
        CASE
            WHEN ll.MachineStatus = 'Breakdown' THEN 1
            WHEN ll.MachineStatus IN ('Under Maintenance','UnderMaintenance','Maintenance') THEN 2
            WHEN ll.MachineStatus = 'Idle' THEN 3
            WHEN ll.MachineStatus = 'Working' THEN 4
            ELSE 5
        END,
        sa.AssetName;

    SELECT
        ISNULL(NULLIF(LTRIM(RTRIM(dl.ProductionUnit)),''),'Units') AS OutputUnit,
        SUM(ISNULL(dl.ProductionQty,0)) AS TotalQty
    INTO #Production
    FROM dbo.trn_DailyLog dl
    INNER JOIN #ScopedAssets sa
        ON sa.AssetID = dl.AssetID
    WHERE CAST(dl.LogDate AS date) >= DATEADD(DAY,-30,CAST(GETDATE() AS date))
      AND ISNULL(dl.ProductionQty,0) > 0
    GROUP BY ISNULL(NULLIF(LTRIM(RTRIM(dl.ProductionUnit)),''),'Units');

    SELECT
        dl.AssetID,
        sa.AssetCode,
        sa.AssetName,
        MAX(dl.LogDate) AS LogDate,
        MAX(dl.StartDateTime) AS StartDateTime,
        MAX(dl.OperatorID) AS OperatorID,
        MAX(o.FullName) AS OperatorName,
        MAX(dl.ProjectID) AS ProjectID,
        MAX(p.ProjectName) AS ProjectName
    INTO #WorkingMachines
    FROM dbo.trn_DailyLog dl
    INNER JOIN #ScopedAssets sa
        ON sa.AssetID = dl.AssetID
    LEFT JOIN dbo.mst_Operator o
        ON o.OperatorID = dl.OperatorID
    LEFT JOIN dbo.mst_Project p
        ON p.ProjectID = dl.ProjectID
    WHERE dl.MachineStatus = 'Working'
      AND dl.SubmissionStatus = 'Draft'
    GROUP BY
        dl.AssetID,
        sa.AssetCode,
        sa.AssetName;

    SELECT
        CASE
            WHEN ISNULL(ll.MachineStatus,'Unknown') IN ('Under Maintenance','UnderMaintenance','Maintenance') THEN 'Under Maintenance'
            ELSE ISNULL(ll.MachineStatus,'Unknown')
        END AS MachineStatus,
        COUNT(DISTINCT ll.AssetID) AS MachineCount
    INTO #StatusCounts
    FROM #LatestLog ll
    WHERE ll.rn = 1
    GROUP BY
        CASE
            WHEN ISNULL(ll.MachineStatus,'Unknown') IN ('Under Maintenance','UnderMaintenance','Maintenance') THEN 'Under Maintenance'
            ELSE ISNULL(ll.MachineStatus,'Unknown')
        END;

    SELECT
        ISNULL(NULLIF(LTRIM(RTRIM(fl.FuelType)),''),'Fuel') AS FuelType,
        'L' AS Unit,
        SUM(ISNULL(fl.FuelQty,0)) AS TotalQty
    INTO #Fuel
    FROM dbo.trn_FuelLog fl
    INNER JOIN #ScopedAssets sa
        ON sa.AssetID = fl.AssetID
    WHERE ISNULL(fl.IsActive,1)=1
      AND CAST(fl.FuelDateTime AS date) >= DATEADD(DAY,-30,CAST(GETDATE() AS date))
    GROUP BY ISNULL(NULLIF(LTRIM(RTRIM(fl.FuelType)),''),'Fuel');

    SELECT
        (SELECT TOP 1
            TotalMachines,
            ActiveMachines,
            BreakdownMachines,
            MaintenanceMachines
         FROM #Cards
         FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS cards,

        (SELECT
            LogDate,
            WorkingHours,
            IdleHours,
            BreakdownHours,
            MaintenanceHours
         FROM #Utilization
         ORDER BY LogDate
         FOR JSON PATH) AS utilization,

        (SELECT
            AssetID,
            AssetCode,
            AssetName,
            ProjectID,
            ProjectName,
            OperatorID,
            OperatorName,
            CurrentStatus,
            AlertType,
            AlertMessage
         FROM #Alerts
         ORDER BY SortOrder, AssetName
         FOR JSON PATH) AS alerts,

        (SELECT
            OutputUnit,
            TotalQty
         FROM #Production
         ORDER BY OutputUnit
         FOR JSON PATH) AS production,

        (SELECT
            AssetID,
            AssetCode,
            AssetName,
            LogDate,
            StartDateTime,
            OperatorID,
            OperatorName,
            ProjectID,
            ProjectName
         FROM #WorkingMachines
         ORDER BY AssetName
         FOR JSON PATH) AS workingMachines,

        (SELECT
            MachineStatus,
            MachineCount
         FROM #StatusCounts
         ORDER BY MachineStatus
         FOR JSON PATH) AS statusCounts,

        (SELECT
            FuelType,
            Unit,
            TotalQty
         FROM #Fuel
         ORDER BY FuelType
         FOR JSON PATH) AS fuel;

    DROP TABLE #ScopedAssets;
    DROP TABLE #LatestLog;
    DROP TABLE #Cards;
    DROP TABLE #Utilization;
    DROP TABLE #Alerts;
    DROP TABLE #Production;
    DROP TABLE #WorkingMachines;
    DROP TABLE #StatusCounts;
    DROP TABLE #Fuel;
END


ELSE IF(@Event='AddAssetType')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Add Asset Type.',16,1);
		RETURN;
	END
    IF ISNULL(LTRIM(RTRIM(@TypeName)), '') = ''
        RAISERROR('TypeName is required.',16,1);

    IF ISNULL(@CreatedBy,0) = 0
        RAISERROR('CreatedBy is required.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_AssetType
        WHERE LTRIM(RTRIM(TypeName)) = LTRIM(RTRIM(@TypeName))
          AND ISNULL(IsActive,1) = 1
    )
        RAISERROR('Asset Type already exists.',16,1);

    INSERT INTO dbo.mst_AssetType
    (
        TypeName,IsActive,CreatedBy, CreatedOn,ModifiedBy,ModifiedOn
    )
    VALUES
    (
        @TypeName,1,@CreatedBy,GETDATE(),NULL,NULL
    );

    SET @NewAssetTypeID = SCOPE_IDENTITY();

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Asset Type added successfully.' AS Msg,
        @NewAssetTypeID AS AssetTypeID;
END

ELSE IF(@Event='DeleteAssetType')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Asset Type.',16,1);
		RETURN;
	END
    IF ISNULL(@AssetTypeID,0) = 0
        RAISERROR('AssetTypeID is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_AssetType
        WHERE AssetTypeID = @AssetTypeID
          AND ISNULL(IsActive,1) = 1
    )
        RAISERROR('Asset Type not found.',16,1);

    UPDATE dbo.mst_AssetType
    SET IsActive = 0,
        ModifiedBy = @ModifiedBy,
        ModifiedOn = GETDATE()
    WHERE AssetTypeID = @AssetTypeID;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Asset Type deleted successfully.' AS Msg,
        @AssetTypeID AS AssetTypeID;
END



ELSE IF(@Event='GetAssetCategoryByType')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF ISNULL(@AssetTypeID,0)=0
        RAISERROR('AssetTypeID is required.',16,1);

    DECLARE @SelectedAssetTypeName VARCHAR(200);

    SELECT TOP 1
        @SelectedAssetTypeName = LTRIM(RTRIM(TypeName))
    FROM dbo.mst_AssetType
    WHERE AssetTypeID = @AssetTypeID
      AND ISNULL(IsActive,1)=1;

    SELECT
        c.CategoryID,
        c.CategoryName,
        c.AssetTypeID,
        c.IsActive,
        c.CreatedBy,
        c.CreatedOn,
        COUNT(CASE WHEN ISNULL(a.IsActive,1)=1 THEN 1 END) AS AssetCount
    FROM dbo.mst_AssetCategory c
    LEFT JOIN dbo.mst_Asset a
        ON a.CategoryID = c.CategoryID
       AND ISNULL(a.IsActive,1)=1
    WHERE c.AssetTypeID = @AssetTypeID
      AND ISNULL(c.IsActive,1)=1
      AND (
            ISNULL(@SelectedAssetTypeName,'') <> 'Transit Mixer'
            OR c.CategoryName NOT IN ('TRANSIT MIXER - UPPER','TRANSIT MIXER - CHASSIS')
          )
    GROUP BY
        c.CategoryID,
        c.CategoryName,
        c.AssetTypeID,
        c.IsActive,
        c.CreatedBy,
        c.CreatedOn
    ORDER BY c.CategoryName;
END

ELSE IF(@Event='GetAssetByCategory')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    IF ISNULL(@CategoryID,0)=0
        RAISERROR('CategoryID is required.',16,1);

    SELECT
        a.AssetID,a.AssetCode, a.AssetName,a.OwnershipType,a.AssetTypeID,at.TypeName AS AssetTypeName,a.CategoryID, c.CategoryName, a.Make,a.ModelName,a.YearOfManufacture,a.RegistrationNo,a.EngineNo,
        a.ChassisNo, a.FuelType, a.Capacity, a.RecordingUnit,a.PurchasePrice,a.PurchaseDate,a.PurchaseFrom,a.PurchaseInvoiceNo, a.DepreciationPct,a.OutputRate,a.OutputUnit,a.VendorID, a.Status,a.PhotoPath,
		a.IsActive,a.CreatedBy,a.CreatedOn, a.ModifiedBy,a.ModifiedOn
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetType at
        ON at.AssetTypeID = a.AssetTypeID
    LEFT JOIN dbo.mst_AssetCategory c
        ON c.CategoryID = a.CategoryID
    WHERE a.CategoryID = @CategoryID
      AND ISNULL(a.IsActive,1)=1
    ORDER BY a.AssetName;
END


ELSE IF(@Event='AddAssetCategory')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Add Asset Category.',16,1);
		RETURN;
	END
   

    INSERT INTO dbo.mst_AssetCategory
	(
	 CategoryName,AssetTypeID,IsActive,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn
	)
	VALUES
	(
		@CategoryName,@AssetTypeID,1,@CreatedByCategory,GETDATE(),NULL,NULL
	);


    SET @NewCategoryID = SCOPE_IDENTITY();

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Asset Category added successfully.' AS Msg,
        @NewCategoryID AS CategoryID,
        @NewCategoryCode AS CategoryCode;
END

ELSE IF (@Event = 'GetAssetCategoryDefaults')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    -- @CategoryID INT

		SELECT TOP 1
		cd.DefaultID,
		cd.CategoryID,
		cd.RecordingUnit,
		cd.OutputName,
		cd.OutputUnit,
		cd.OutputRequired,
		cd.FuelType,
		cd.FuelUnit,
		cd.MandatoryCertificates
	FROM dbo.mst_AssetCategoryDefaults cd
	WHERE cd.CategoryID = @CategoryID
	AND ISNULL(cd.IsActive,1)=1
END

ELSE IF (@Event = 'SaveAssetCategoryDefaults')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Save Asset Category Defaults.',16,1);
		RETURN;
	END
    IF EXISTS (
        SELECT 1 FROM dbo.mst_AssetCategoryDefaults
        WHERE CategoryID = @CategoryID AND ISNULL(IsActive, 1) = 1
    )
    BEGIN
        UPDATE dbo.mst_AssetCategoryDefaults SET
            RecordingUnit         = @RecordingUnit,
            OutputName            = @OutputName,
            OutputUnit            = @OutputUnit,
            OutputRequired        = CAST(@OutputRequired AS BIT),  -- 1 = show, 0 = hide
            FuelType              = @FuelType,
            FuelUnit              = @FuelUnit,
            MandatoryCertificates = @MandatoryCertificates,
            ModifiedBy            = @CreatedBy
            --ModifiedDate          = GETDATE()
        WHERE CategoryID = @CategoryID AND ISNULL(IsActive, 1) = 1;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.mst_AssetCategoryDefaults
            (CategoryID, RecordingUnit, OutputName, OutputUnit, OutputRequired,
             FuelType, FuelUnit, MandatoryCertificates, CreatedBy)
        VALUES
            (@CategoryID, @RecordingUnit, @OutputName, @OutputUnit,
             CAST(@OutputRequired AS BIT),
             @FuelType, @FuelUnit, @MandatoryCertificates, @CreatedBy);
    END

    SELECT 'Success' AS Status, 'Defaults saved successfully.' AS Msg;
END

ELSE IF(@Event='AddAsset')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Add Asset.',16,1);
		RETURN;
	END
DECLARE @NewAssetID INT,
            @NextNo INT;
    SET @AssetID = CASE WHEN ISNULL(@AssetID,0)=0 THEN @AssetID_AssetPrefix ELSE @AssetID END;
	SET @AssetCode = ISNULL(NULLIF(@AssetCode,''), @AssetCode_AssetPrefix);
	SET @AssetName = ISNULL(NULLIF(@AssetName,''), @AssetName_AssetPrefix);
	SET @OwnershipType = ISNULL(NULLIF(@OwnershipType,''), @OwnershipType_AssetPrefix);
	SET @AssetTypeID_Add = CASE WHEN ISNULL(@AssetTypeID_Add,0)=0 THEN @AssetTypeID_AssetPrefix ELSE @AssetTypeID_Add END;
	SET @CategoryID_Add = CASE WHEN ISNULL(@CategoryID_Add,0)=0 THEN @CategoryID_AssetPrefix ELSE @CategoryID_Add END;
	SET @Make = ISNULL(NULLIF(@Make,''), @Make_AssetPrefix);
	SET @ModelName = ISNULL(NULLIF(@ModelName,''), @ModelName_AssetPrefix);
	SET @YearOfManufacture = ISNULL(@YearOfManufacture, @YearOfManufacture_AssetPrefix);
	SET @RegistrationNo = ISNULL(NULLIF(@RegistrationNo,''), @RegistrationNo_AssetPrefix);
	SET @EngineNo = ISNULL(NULLIF(@EngineNo,''), @EngineNo_AssetPrefix);
	SET @ChassisNo = ISNULL(NULLIF(@ChassisNo,''), @ChassisNo_AssetPrefix);
	SET @FuelType_Add = ISNULL(NULLIF(@FuelType_Add,''), @FuelType_AssetPrefix);
	SET @Capacity = ISNULL(NULLIF(@Capacity,''), @Capacity_AssetPrefix);
	SET @RecordingUnit_Add = ISNULL(NULLIF(@RecordingUnit_Add,''), @RecordingUnit_AssetPrefix);
	SET @PurchasePrice = ISNULL(@PurchasePrice, @PurchasePrice_AssetPrefix);
	SET @PurchaseDate = ISNULL(@PurchaseDate, @PurchaseDate_AssetPrefix);
	SET @PurchaseFrom = ISNULL(NULLIF(@PurchaseFrom,''), @PurchaseFrom_AssetPrefix);
	SET @PurchaseInvoiceNo = ISNULL(NULLIF(@PurchaseInvoiceNo,''), @PurchaseInvoiceNo_AssetPrefix);
	SET @DepreciationPct = ISNULL(@DepreciationPct, @DepreciationPct_AssetPrefix);
	SET @OutputRate = ISNULL(@OutputRate, @OutputRate_AssetPrefix);
	SET @OutputUnit_Add = ISNULL(NULLIF(@OutputUnit_Add,''), @OutputUnit_AssetPrefix);
	SET @Status_Add = ISNULL(NULLIF(@Status_Add,''), @Status_AssetPrefix);
	SET @PhotoPath = ISNULL(NULLIF(@PhotoPath,''), @PhotoPath_AssetPrefix);
	SET @FrontPhotoPath = ISNULL(NULLIF(@FrontPhotoPath,''), @FrontPhotoPath_AssetPrefix);
	SET @BackPhotoPath = ISNULL(NULLIF(@BackPhotoPath,''), @BackPhotoPath_AssetPrefix);
	SET @LeftPhotoPath = ISNULL(NULLIF(@LeftPhotoPath,''), @LeftPhotoPath_AssetPrefix);
	SET @RightPhotoPath = ISNULL(NULLIF(@RightPhotoPath,''), @RightPhotoPath_AssetPrefix);
	SET @CreatedBy_Add = CASE WHEN ISNULL(@CreatedBy_Add,0)=0 THEN @CreatedBy_AssetPrefix ELSE @CreatedBy_Add END;
	SET @ModifiedBy = CASE WHEN ISNULL(@ModifiedBy,0)=0 THEN @ModifiedBy_AssetPrefix ELSE @ModifiedBy END;
	SET @FrontPhotoPath = ISNULL(NULLIF(@FrontPhotoPath,''), @FrontPhotoPath_AssetPrefix);
	SET @BackPhotoPath = ISNULL(NULLIF(@BackPhotoPath,''), @BackPhotoPath_AssetPrefix);
	SET @LeftPhotoPath = ISNULL(NULLIF(@LeftPhotoPath,''), @LeftPhotoPath_AssetPrefix);
	SET @RightPhotoPath = ISNULL(NULLIF(@RightPhotoPath,''), @RightPhotoPath_AssetPrefix);
	SET @Client = ISNULL(NULLIF(@Client,''), @Client_AssetPrefix);
	SET @Division = ISNULL(NULLIF(@Division,''), @Division_AssetPrefix);
	SET @DivisionID = ISNULL(NULLIF(@DivisionID,''), @Division_AssetPrefix);
	SET @SerialNo = ISNULL(NULLIF(@SerialNo,''), @SerialNo_AssetPrefix);
	SET @RecordingUnit = LTRIM(RTRIM(ISNULL(@RecordingUnit,'')));

	IF UPPER(@RecordingUnit) IN ('BOTH', 'KMR/HMR', 'HMR/KMR', 'KMR / HMR')
		SET @RecordingUnit = 'KMR/HMR';
	ELSE IF UPPER(@RecordingUnit) IN ('KILOMETERS', 'KILOMETER', 'KM', 'KMR')
		SET @RecordingUnit = 'Kilometers';
	ELSE IF UPPER(@RecordingUnit) IN ('HOURS', 'HOUR', 'HRS', 'HR', 'HMR')
		SET @RecordingUnit = 'Hours';
	ELSE IF UPPER(@RecordingUnit) IN ('DAYS', 'DAY')
		SET @RecordingUnit = 'Days';



    IF ISNULL(LTRIM(RTRIM(@PhotoPath)),'')<>'' 
    BEGIN
        SET @PhotoPath = REPLACE(@PhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @PhotoPath = REPLACE(@PhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @PhotoPath = REPLACE(@PhotoPath,'\','/');
        IF LEFT(@PhotoPath,1)='/' SET @PhotoPath = STUFF(@PhotoPath,1,1,'');
        IF @PhotoPath LIKE 'C:%' SET @PhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@FrontPhotoPath)),'')<>'' 
    BEGIN
        SET @FrontPhotoPath = REPLACE(@FrontPhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @FrontPhotoPath = REPLACE(@FrontPhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @FrontPhotoPath = REPLACE(@FrontPhotoPath,'\','/');
        IF LEFT(@FrontPhotoPath,1)='/' SET @FrontPhotoPath = STUFF(@FrontPhotoPath,1,1,'');
        IF @FrontPhotoPath LIKE 'C:%' SET @FrontPhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@BackPhotoPath)),'')<>'' 
    BEGIN
        SET @BackPhotoPath = REPLACE(@BackPhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @BackPhotoPath = REPLACE(@BackPhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @BackPhotoPath = REPLACE(@BackPhotoPath,'\','/');
        IF LEFT(@BackPhotoPath,1)='/' SET @BackPhotoPath = STUFF(@BackPhotoPath,1,1,'');
        IF @BackPhotoPath LIKE 'C:%' SET @BackPhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@LeftPhotoPath)),'')<>'' 
    BEGIN
        SET @LeftPhotoPath = REPLACE(@LeftPhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @LeftPhotoPath = REPLACE(@LeftPhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @LeftPhotoPath = REPLACE(@LeftPhotoPath,'\','/');
        IF LEFT(@LeftPhotoPath,1)='/' SET @LeftPhotoPath = STUFF(@LeftPhotoPath,1,1,'');
        IF @LeftPhotoPath LIKE 'C:%' SET @LeftPhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@RightPhotoPath)),'')<>'' 
    BEGIN
        SET @RightPhotoPath = REPLACE(@RightPhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @RightPhotoPath = REPLACE(@RightPhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @RightPhotoPath = REPLACE(@RightPhotoPath,'\','/');
        IF LEFT(@RightPhotoPath,1)='/' SET @RightPhotoPath = STUFF(@RightPhotoPath,1,1,'');
        IF @RightPhotoPath LIKE 'C:%' SET @RightPhotoPath = '';
    END

	IF ISNULL(LTRIM(RTRIM(@PhotoPath)),'')=''
    SET @PhotoPath = @FrontPhotoPath;


    IF ISNULL(LTRIM(RTRIM(@AssetName)),'')=''
        RAISERROR('AssetName is required.',16,1);

    IF ISNULL(@AssetTypeID_Add,0)=0
        RAISERROR('AssetTypeID is required.',16,1);

    IF ISNULL(@CategoryID_Add,0)=0
        RAISERROR('CategoryID is required.',16,1);

    IF ISNULL(@CreatedBy_Add,0)=0
        RAISERROR('CreatedBy is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@AssetCode)),'')=''
    BEGIN
        SELECT @NextNo = ISNULL(MAX(AssetID),0) + 1
        FROM dbo.mst_Asset;

        SET @NewAssetCode = 'A' + RIGHT('000' + CAST(@NextNo AS VARCHAR(10)), 3);
    END
    ELSE
    BEGIN
        SET @NewAssetCode = @AssetCode;
    END

    IF ISNULL(LTRIM(RTRIM(@NewAssetCode)),'')=''
        RAISERROR('AssetCode could not be generated.',16,1);

	IF ISNULL(@AssetID, 0) > 0 AND EXISTS (SELECT 1 FROM dbo.mst_Asset WHERE AssetID = @AssetID AND ISNULL(IsActive,1)=1)
    BEGIN
        DECLARE @ModifiedBy_Add_Fallback INT;
        SET @ModifiedBy_Add_Fallback = ISNULL(ISNULL(@ModifiedBy, @ModifiedBy_AssetPrefix), @CreatedBy_Add);

        UPDATE dbo.mst_Asset
        SET
            AssetCode         = @NewAssetCode,
            AssetName         = @AssetName,
            OwnershipType     = ISNULL(NULLIF(@OwnershipType,''),'Owned'),
            AssetTypeID       = @AssetTypeID_Add,
            CategoryID        = @CategoryID_Add,
            Make              = @Make,
            ModelName         = @ModelName,
            YearOfManufacture = @YearOfManufacture,
            RegistrationNo    = @RegistrationNo,
            EngineNo          = @EngineNo,
            ChassisNo         = @ChassisNo,
            FuelType          = @FuelType_Add,
            Capacity          = @Capacity,
            RecordingUnit     = @RecordingUnit_Add,
            PurchasePrice     = @PurchasePrice,
            PurchaseDate      = @PurchaseDate,
            PurchaseFrom      = @PurchaseFrom,
            PurchaseInvoiceNo = @PurchaseInvoiceNo,
            DepreciationPct   = @DepreciationPct,
            OutputRate        = @OutputRate,
            OutputUnit        = @OutputUnit_Add,
            VendorID          = @VendorID,
            Status            = ISNULL(NULLIF(@Status_Add,''),'Active'),
            PhotoPath         = ISNULL(NULLIF(@PhotoPath,''), PhotoPath),
            ModifiedBy        = @ModifiedBy_Add_Fallback,
            ModifiedOn        = GETDATE(),
			Client = @Client,
			Division = @Division,
			DivisionID = @DivisionID,
			SerialNo = @SerialNo
        WHERE AssetID = @AssetID;

        IF ISNULL(LTRIM(RTRIM(@FrontPhotoPath)),'')<>''
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@AssetID AND PhotoType='Front' AND ISNULL(IsActive,1)=1)
                UPDATE dbo.trn_AssetPhoto SET PhotoPath=@FrontPhotoPath, DisplayOrder=1, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
                WHERE AssetID=@AssetID AND PhotoType='Front' AND ISNULL(IsActive,1)=1;
            ELSE
                INSERT INTO dbo.trn_AssetPhoto (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
                VALUES (@AssetID, 'Front', @FrontPhotoPath, 1, 1, @ModifiedBy_Add_Fallback, GETDATE(), NULL, NULL);
        END

        IF ISNULL(LTRIM(RTRIM(@BackPhotoPath)),'')<>''
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@AssetID AND PhotoType='Back' AND ISNULL(IsActive,1)=1)
                UPDATE dbo.trn_AssetPhoto SET PhotoPath=@BackPhotoPath, DisplayOrder=2, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
                WHERE AssetID=@AssetID AND PhotoType='Back' AND ISNULL(IsActive,1)=1;
            ELSE
                INSERT INTO dbo.trn_AssetPhoto (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
                VALUES (@AssetID, 'Back', @BackPhotoPath, 2, 1, @ModifiedBy_Add_Fallback, GETDATE(), NULL, NULL);
        END

        IF ISNULL(LTRIM(RTRIM(@LeftPhotoPath)),'')<>''
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@AssetID AND PhotoType='Left' AND ISNULL(IsActive,1)=1)
                UPDATE dbo.trn_AssetPhoto SET PhotoPath=@LeftPhotoPath, DisplayOrder=3, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
                WHERE AssetID=@AssetID AND PhotoType='Left' AND ISNULL(IsActive,1)=1;
            ELSE
                INSERT INTO dbo.trn_AssetPhoto (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
                VALUES (@AssetID, 'Left', @LeftPhotoPath, 3, 1, @ModifiedBy_Add_Fallback, GETDATE(), NULL, NULL);
        END

        IF ISNULL(LTRIM(RTRIM(@RightPhotoPath)),'')<>''
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@AssetID AND PhotoType='Right' AND ISNULL(IsActive,1)=1)
                UPDATE dbo.trn_AssetPhoto SET PhotoPath=@RightPhotoPath, DisplayOrder=4, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
                WHERE AssetID=@AssetID AND PhotoType='Right' AND ISNULL(IsActive,1)=1;
            ELSE
                INSERT INTO dbo.trn_AssetPhoto (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
                VALUES (@AssetID, 'Right', @RightPhotoPath, 4, 1, @ModifiedBy_Add_Fallback, GETDATE(), NULL, NULL);
        END

        UPDATE dbo.tbl_Log SET Status='Success' WHERE Id=@LastId;
        SELECT 'Success' Status, 'Asset updated successfully.' Msg, @AssetID AssetID, @NewAssetCode AssetCode;
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM dbo.mst_Asset WHERE AssetCode = @NewAssetCode AND ISNULL(IsActive,1)=1)
    BEGIN
        -- Resolve the real AssetID from the existing record (asset_AssetID may be empty from JS)
        DECLARE @ExistingAssetID INT;
        SELECT @ExistingAssetID = AssetID FROM dbo.mst_Asset WHERE AssetCode = @NewAssetCode AND ISNULL(IsActive,1)=1;
        SET @AssetID = ISNULL(NULLIF(@AssetID, 0), @ExistingAssetID);

        --DECLARE @ModifiedBy_Add_Fallback INT;
        SET @ModifiedBy_Add_Fallback = ISNULL(ISNULL(@ModifiedBy, @ModifiedBy_AssetPrefix), @CreatedBy_Add);

        UPDATE dbo.mst_Asset
        SET
            AssetCode         = @NewAssetCode,
            AssetName         = @AssetName,
            OwnershipType     = ISNULL(NULLIF(@OwnershipType,''),'Owned'),
            AssetTypeID       = @AssetTypeID_Add,
            CategoryID        = @CategoryID_Add,
            Make              = @Make,
            ModelName         = @ModelName,
            YearOfManufacture = @YearOfManufacture,
            RegistrationNo    = @RegistrationNo,
            EngineNo          = @EngineNo,
            ChassisNo         = @ChassisNo,
            FuelType          = @FuelType_Add,
            Capacity          = @Capacity,
            RecordingUnit     = @RecordingUnit_Add,
            PurchasePrice     = @PurchasePrice,
            PurchaseDate      = @PurchaseDate,
            PurchaseFrom      = @PurchaseFrom,
            PurchaseInvoiceNo = @PurchaseInvoiceNo,
            DepreciationPct   = @DepreciationPct,
            OutputRate        = @OutputRate,
            OutputUnit        = @OutputUnit_Add,
            VendorID          = @VendorID,
            Status            = ISNULL(NULLIF(@Status_Add,''),'Active'),
            PhotoPath         = ISNULL(NULLIF(@PhotoPath,''), PhotoPath),
            ModifiedBy        = @ModifiedBy_Add_Fallback,
            ModifiedOn        = GETDATE(),
			Client = @Client,
			Division = @Division,
			DivisionID = @DivisionID,
			SerialNo = @SerialNo
        WHERE AssetID = @AssetID;

        IF ISNULL(LTRIM(RTRIM(@FrontPhotoPath)),'')<>''
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@AssetID AND PhotoType='Front' AND ISNULL(IsActive,1)=1)
                UPDATE dbo.trn_AssetPhoto SET PhotoPath=@FrontPhotoPath, DisplayOrder=1, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
                WHERE AssetID=@AssetID AND PhotoType='Front' AND ISNULL(IsActive,1)=1;
            ELSE
                INSERT INTO dbo.trn_AssetPhoto (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
                VALUES (@AssetID, 'Front', @FrontPhotoPath, 1, 1, @ModifiedBy_Add_Fallback, GETDATE(), NULL, NULL);
        END

        IF ISNULL(LTRIM(RTRIM(@BackPhotoPath)),'')<>''
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@AssetID AND PhotoType='Back' AND ISNULL(IsActive,1)=1)
                UPDATE dbo.trn_AssetPhoto SET PhotoPath=@BackPhotoPath, DisplayOrder=2, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
                WHERE AssetID=@AssetID AND PhotoType='Back' AND ISNULL(IsActive,1)=1;
            ELSE
                INSERT INTO dbo.trn_AssetPhoto (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
                VALUES (@AssetID, 'Back', @BackPhotoPath, 2, 1, @ModifiedBy_Add_Fallback, GETDATE(), NULL, NULL);
        END

        IF ISNULL(LTRIM(RTRIM(@LeftPhotoPath)),'')<>''
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@AssetID AND PhotoType='Left' AND ISNULL(IsActive,1)=1)
                UPDATE dbo.trn_AssetPhoto SET PhotoPath=@LeftPhotoPath, DisplayOrder=3, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
                WHERE AssetID=@AssetID AND PhotoType='Left' AND ISNULL(IsActive,1)=1;
            ELSE
                INSERT INTO dbo.trn_AssetPhoto (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
                VALUES (@AssetID, 'Left', @LeftPhotoPath, 3, 1, @ModifiedBy_Add_Fallback, GETDATE(), NULL, NULL);
        END

        IF ISNULL(LTRIM(RTRIM(@RightPhotoPath)),'')<>''
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@AssetID AND PhotoType='Right' AND ISNULL(IsActive,1)=1)
                UPDATE dbo.trn_AssetPhoto SET PhotoPath=@RightPhotoPath, DisplayOrder=4, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
                WHERE AssetID=@AssetID AND PhotoType='Right' AND ISNULL(IsActive,1)=1;
            ELSE
                INSERT INTO dbo.trn_AssetPhoto (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
                VALUES (@AssetID, 'Right', @RightPhotoPath, 4, 1, @ModifiedBy_Add_Fallback, GETDATE(), NULL, NULL);
        END

        UPDATE dbo.tbl_Log SET Status='Success' WHERE Id=@LastId;
        SELECT 'Success' Status, 'Asset updated successfully.' Msg, @AssetID AssetID, @NewAssetCode AssetCode;
        RETURN;
    END

    INSERT INTO dbo.mst_Asset
    (
        AssetCode, AssetName, OwnershipType, AssetTypeID, CategoryID, Make, ModelName, YearOfManufacture,
        RegistrationNo, EngineNo, ChassisNo, FuelType, Capacity, RecordingUnit, PurchasePrice, PurchaseDate,
        PurchaseFrom, PurchaseInvoiceNo, DepreciationPct, OutputRate, OutputUnit, VendorID, Status, PhotoPath,
        IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,Client, Division,DivisionID, SerialNo,MountCode,
        IsVirtualAsset

    )
    VALUES
    (
        @NewAssetCode, @AssetName, ISNULL(NULLIF(@OwnershipType,''),'Owned'), @AssetTypeID_Add, @CategoryID_Add,
        @Make, @ModelName, @YearOfManufacture, @RegistrationNo, @EngineNo, @ChassisNo, @FuelType_Add, @Capacity,
        @RecordingUnit_Add, @PurchasePrice, @PurchaseDate, @PurchaseFrom, @PurchaseInvoiceNo, @DepreciationPct,
        @OutputRate, @OutputUnit_Add, @VendorID, ISNULL(NULLIF(@Status_Add,''),'Active'),
        ISNULL(@PhotoPath,''), 1, @CreatedBy_Add, GETDATE(), NULL, NULL,@Client, @Division,@DivisionID, @SerialNo,NULLIF(@MountCode,''),0

    );

    SET @NewAssetID = SCOPE_IDENTITY();

    IF ISNULL(LTRIM(RTRIM(@FrontPhotoPath)),'')<>'' 
    BEGIN
        INSERT INTO dbo.trn_AssetPhoto
        (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
        VALUES
        (@NewAssetID, 'Front', @FrontPhotoPath, 1, 1, @CreatedBy_Add, GETDATE(), NULL, NULL);
    END

    IF ISNULL(LTRIM(RTRIM(@BackPhotoPath)),'')<>'' 
    BEGIN
        INSERT INTO dbo.trn_AssetPhoto
        (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
        VALUES
        (@NewAssetID, 'Back', @BackPhotoPath, 2, 1, @CreatedBy_Add, GETDATE(), NULL, NULL);
    END

    IF ISNULL(LTRIM(RTRIM(@LeftPhotoPath)),'')<>'' 
    BEGIN
        INSERT INTO dbo.trn_AssetPhoto
        (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
        VALUES
        (@NewAssetID, 'Left', @LeftPhotoPath, 3, 1, @CreatedBy_Add, GETDATE(), NULL, NULL);
    END

    IF ISNULL(LTRIM(RTRIM(@RightPhotoPath)),'')<>'' 
    BEGIN
        INSERT INTO dbo.trn_AssetPhoto
        (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
        VALUES
        (@NewAssetID, 'Right', @RightPhotoPath, 4, 1, @CreatedBy_Add, GETDATE(), NULL, NULL);
    END

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT 'Success' Status, 'Asset added successfully.' Msg, @NewAssetID AssetID, @NewAssetCode AssetCode;
END


ELSE IF(@Event='GetAssetByID')
BEGIN
	IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Asset
        WHERE AssetID=@AssetID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset not found.',16,1);

    SELECT
        a.AssetID,a.AssetCode,a.AssetName, a.OwnershipType,a.AssetTypeID, at.TypeName AS AssetTypeName,a.CategoryID,ac.CategoryName, a.Make, a.ModelName,a.YearOfManufacture,a.RegistrationNo,
        a.EngineNo,a.ChassisNo,a.FuelType,a.Capacity,a.RecordingUnit,a.PurchasePrice,a.PurchaseDate, a.PurchaseFrom, a.PurchaseInvoiceNo,a.DepreciationPct,a.OutputRate,a.OutputUnit,a.VendorID,
        a.Status,a.PhotoPath, a.IsActive,a.CreatedBy, a.CreatedOn, a.ModifiedBy,a.ModifiedOn
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetType at ON at.AssetTypeID = a.AssetTypeID
    LEFT JOIN dbo.mst_AssetCategory ac ON ac.CategoryID = a.CategoryID
    WHERE a.AssetID=@AssetID
      AND ISNULL(a.IsActive,1)=1;
END

ELSE IF(@Event='AddAsset')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
    BEGIN
        RAISERROR('Only Admin can Add Asset.',16,1);
        RETURN;
    END

    DECLARE 
            @SavedAssetID INT,
            @SavedAssetCode VARCHAR(100),
            @OperationMsg VARCHAR(100)
    SET @AssetID = CASE WHEN ISNULL(@AssetID,0)=0 THEN @AssetID_AssetPrefix ELSE @AssetID END;
    SET @AssetCode = ISNULL(NULLIF(@AssetCode,''), @AssetCode_AssetPrefix);
    SET @AssetName = ISNULL(NULLIF(@AssetName,''), @AssetName_AssetPrefix);
    SET @OwnershipType = ISNULL(NULLIF(@OwnershipType,''), @OwnershipType_AssetPrefix);
    SET @AssetTypeID_Add = CASE WHEN ISNULL(@AssetTypeID_Add,0)=0 THEN @AssetTypeID_AssetPrefix ELSE @AssetTypeID_Add END;
    SET @CategoryID_Add = CASE WHEN ISNULL(@CategoryID_Add,0)=0 THEN @CategoryID_AssetPrefix ELSE @CategoryID_Add END;
    SET @Make = ISNULL(NULLIF(@Make,''), @Make_AssetPrefix);
    SET @ModelName = ISNULL(NULLIF(@ModelName,''), @ModelName_AssetPrefix);
    SET @YearOfManufacture = ISNULL(@YearOfManufacture, @YearOfManufacture_AssetPrefix);
    SET @RegistrationNo = ISNULL(NULLIF(@RegistrationNo,''), @RegistrationNo_AssetPrefix);
    SET @EngineNo = ISNULL(NULLIF(@EngineNo,''), @EngineNo_AssetPrefix);
    SET @ChassisNo = ISNULL(NULLIF(@ChassisNo,''), @ChassisNo_AssetPrefix);
    SET @FuelType_Add = ISNULL(NULLIF(@FuelType_Add,''), @FuelType_AssetPrefix);
    SET @Capacity = ISNULL(NULLIF(@Capacity,''), @Capacity_AssetPrefix);
    SET @RecordingUnit_Add = ISNULL(NULLIF(@RecordingUnit_Add,''), @RecordingUnit_AssetPrefix);
    SET @PurchasePrice = ISNULL(@PurchasePrice, @PurchasePrice_AssetPrefix);
    SET @PurchaseDate = ISNULL(@PurchaseDate, @PurchaseDate_AssetPrefix);
    SET @PurchaseFrom = ISNULL(NULLIF(@PurchaseFrom,''), @PurchaseFrom_AssetPrefix);
    SET @PurchaseInvoiceNo = ISNULL(NULLIF(@PurchaseInvoiceNo,''), @PurchaseInvoiceNo_AssetPrefix);
    SET @DepreciationPct = ISNULL(@DepreciationPct, @DepreciationPct_AssetPrefix);
    SET @OutputRate = ISNULL(@OutputRate, @OutputRate_AssetPrefix);
    SET @OutputUnit_Add = ISNULL(NULLIF(@OutputUnit_Add,''), @OutputUnit_AssetPrefix);
    SET @Status_Add = ISNULL(NULLIF(@Status_Add,''), @Status_AssetPrefix);
    SET @PhotoPath = ISNULL(NULLIF(@PhotoPath,''), @PhotoPath_AssetPrefix);
    SET @FrontPhotoPath = ISNULL(NULLIF(@FrontPhotoPath,''), @FrontPhotoPath_AssetPrefix);
    SET @BackPhotoPath = ISNULL(NULLIF(@BackPhotoPath,''), @BackPhotoPath_AssetPrefix);
    SET @LeftPhotoPath = ISNULL(NULLIF(@LeftPhotoPath,''), @LeftPhotoPath_AssetPrefix);
    SET @RightPhotoPath = ISNULL(NULLIF(@RightPhotoPath,''), @RightPhotoPath_AssetPrefix);
    SET @CreatedBy_Add = CASE WHEN ISNULL(@CreatedBy_Add,0)=0 THEN @AuthEmployeeID ELSE @CreatedBy_Add END;
    SET @ModifiedBy = CASE WHEN ISNULL(@ModifiedBy,0)=0 THEN @AuthEmployeeID ELSE @ModifiedBy END;
    SET @Client = ISNULL(NULLIF(@Client,''), @Client_AssetPrefix);
    SET @Division = ISNULL(NULLIF(@Division,''), @Division_AssetPrefix);
    SET @DivisionID = ISNULL(@DivisionID, TRY_CAST(@Division_AssetPrefix AS INT));
    SET @SerialNo = ISNULL(NULLIF(@SerialNo,''), @SerialNo_AssetPrefix);
    SET @MountCode = LTRIM(RTRIM(ISNULL(@MountCode,'')));

    SET @RecordingUnit_Add = LTRIM(RTRIM(ISNULL(@RecordingUnit_Add,'')));

    IF UPPER(@RecordingUnit_Add) IN ('BOTH', 'KMR/HMR', 'HMR/KMR', 'KMR / HMR')
        SET @RecordingUnit_Add = 'KMR/HMR';
    ELSE IF UPPER(@RecordingUnit_Add) IN ('KILOMETERS', 'KILOMETER', 'KM', 'KMR')
        SET @RecordingUnit_Add = 'Kilometers';
    ELSE IF UPPER(@RecordingUnit_Add) IN ('HOURS', 'HOUR', 'HRS', 'HR', 'HMR')
        SET @RecordingUnit_Add = 'Hours';
    ELSE IF UPPER(@RecordingUnit_Add) IN ('DAYS', 'DAY')
        SET @RecordingUnit_Add = 'Days';

    IF ISNULL(LTRIM(RTRIM(@PhotoPath)),'')<>'' 
    BEGIN
        SET @PhotoPath = REPLACE(@PhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @PhotoPath = REPLACE(@PhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @PhotoPath = REPLACE(@PhotoPath,'\','/');
        IF LEFT(@PhotoPath,1)='/' SET @PhotoPath = STUFF(@PhotoPath,1,1,'');
        IF @PhotoPath LIKE 'C:%' SET @PhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@FrontPhotoPath)),'')<>'' 
    BEGIN
        SET @FrontPhotoPath = REPLACE(@FrontPhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @FrontPhotoPath = REPLACE(@FrontPhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @FrontPhotoPath = REPLACE(@FrontPhotoPath,'\','/');
        IF LEFT(@FrontPhotoPath,1)='/' SET @FrontPhotoPath = STUFF(@FrontPhotoPath,1,1,'');
        IF @FrontPhotoPath LIKE 'C:%' SET @FrontPhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@BackPhotoPath)),'')<>'' 
    BEGIN
        SET @BackPhotoPath = REPLACE(@BackPhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @BackPhotoPath = REPLACE(@BackPhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @BackPhotoPath = REPLACE(@BackPhotoPath,'\','/');
        IF LEFT(@BackPhotoPath,1)='/' SET @BackPhotoPath = STUFF(@BackPhotoPath,1,1,'');
        IF @BackPhotoPath LIKE 'C:%' SET @BackPhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@LeftPhotoPath)),'')<>'' 
    BEGIN
        SET @LeftPhotoPath = REPLACE(@LeftPhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @LeftPhotoPath = REPLACE(@LeftPhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @LeftPhotoPath = REPLACE(@LeftPhotoPath,'\','/');
        IF LEFT(@LeftPhotoPath,1)='/' SET @LeftPhotoPath = STUFF(@LeftPhotoPath,1,1,'');
        IF @LeftPhotoPath LIKE 'C:%' SET @LeftPhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@RightPhotoPath)),'')<>'' 
    BEGIN
        SET @RightPhotoPath = REPLACE(@RightPhotoPath,'{{baseurl}}/I_Drive/Documents\','');
        SET @RightPhotoPath = REPLACE(@RightPhotoPath,'{{baseurl}}/I_Drive/Documents/','');
        SET @RightPhotoPath = REPLACE(@RightPhotoPath,'\','/');
        IF LEFT(@RightPhotoPath,1)='/' SET @RightPhotoPath = STUFF(@RightPhotoPath,1,1,'');
        IF @RightPhotoPath LIKE 'C:%' SET @RightPhotoPath = '';
    END

    IF ISNULL(LTRIM(RTRIM(@PhotoPath)),'')=''
        SET @PhotoPath = @FrontPhotoPath;

    IF ISNULL(LTRIM(RTRIM(@AssetName)),'')=''
        RAISERROR('AssetName is required.',16,1);

    IF ISNULL(@AssetTypeID_Add,0)=0
        RAISERROR('AssetTypeID is required.',16,1);

    IF ISNULL(@CategoryID_Add,0)=0
        RAISERROR('CategoryID is required.',16,1);

    IF ISNULL(@CreatedBy_Add,0)=0
        RAISERROR('CreatedBy is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_AssetType
        WHERE AssetTypeID=@AssetTypeID_Add
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset Type not found.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_AssetCategory
        WHERE CategoryID=@CategoryID_Add
          AND AssetTypeID=@AssetTypeID_Add
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset Category not found.',16,1);

    IF ISNULL(LTRIM(RTRIM(@AssetCode)),'')=''
    BEGIN
        SELECT @NextNo = ISNULL(MAX(AssetID),0) + 1
        FROM dbo.mst_Asset;

        SET @NewAssetCode = 'A' + RIGHT('000' + CAST(@NextNo AS VARCHAR(10)), 3);
    END
    ELSE
    BEGIN
        SET @NewAssetCode = @AssetCode;
    END

    IF ISNULL(LTRIM(RTRIM(@NewAssetCode)),'')=''
        RAISERROR('AssetCode could not be generated.',16,1);

    SET @ModifiedBy_Add_Fallback = ISNULL(@ModifiedBy, @AuthEmployeeID);

    IF ISNULL(@AssetID,0) > 0
       AND EXISTS (
            SELECT 1
            FROM dbo.mst_Asset
            WHERE AssetID = @AssetID
              AND ISNULL(IsActive,1)=1
       )
    BEGIN
        UPDATE dbo.mst_Asset
        SET
            AssetCode         = @NewAssetCode,
            AssetName         = @AssetName,
            OwnershipType     = ISNULL(NULLIF(@OwnershipType,''),'Owned'),
            AssetTypeID       = @AssetTypeID_Add,
            CategoryID        = @CategoryID_Add,
            Make              = @Make,
            ModelName         = @ModelName,
            YearOfManufacture = @YearOfManufacture,
            RegistrationNo    = @RegistrationNo,
            EngineNo          = @EngineNo,
            ChassisNo         = @ChassisNo,
            FuelType          = @FuelType_Add,
            Capacity          = @Capacity,
            RecordingUnit     = @RecordingUnit_Add,
            PurchasePrice     = @PurchasePrice,
            PurchaseDate      = @PurchaseDate,
            PurchaseFrom      = @PurchaseFrom,
            PurchaseInvoiceNo = @PurchaseInvoiceNo,
            DepreciationPct   = @DepreciationPct,
            OutputRate        = @OutputRate,
            OutputUnit        = @OutputUnit_Add,
            VendorID          = @VendorID,
            Status            = ISNULL(NULLIF(@Status_Add,''),'Active'),
            PhotoPath         = ISNULL(NULLIF(@PhotoPath,''), PhotoPath),
            Client            = @Client,
            Division          = @Division,
            DivisionID        = @DivisionID,
            SerialNo          = @SerialNo,
            MountCode         = NULLIF(@MountCode,''),
            IsVirtualAsset    = ISNULL(IsVirtualAsset,0),
            ModifiedBy        = @ModifiedBy_Add_Fallback,
            ModifiedOn        = GETDATE()
        WHERE AssetID = @AssetID;

        SET @SavedAssetID = @AssetID;
        SET @SavedAssetCode = @NewAssetCode;
        SET @OperationMsg = 'Asset updated successfully.';
    END
    ELSE IF EXISTS (
        SELECT 1
        FROM dbo.mst_Asset
        WHERE AssetCode = @NewAssetCode
          AND ISNULL(IsActive,1)=1
    )
    BEGIN
        SELECT TOP 1
            @AssetID = AssetID
        FROM dbo.mst_Asset
        WHERE AssetCode = @NewAssetCode
          AND ISNULL(IsActive,1)=1;

        UPDATE dbo.mst_Asset
        SET
            AssetCode         = @NewAssetCode,
            AssetName         = @AssetName,
            OwnershipType     = ISNULL(NULLIF(@OwnershipType,''),'Owned'),
            AssetTypeID       = @AssetTypeID_Add,
            CategoryID        = @CategoryID_Add,
            Make              = @Make,
            ModelName         = @ModelName,
            YearOfManufacture = @YearOfManufacture,
            RegistrationNo    = @RegistrationNo,
            EngineNo          = @EngineNo,
            ChassisNo         = @ChassisNo,
            FuelType          = @FuelType_Add,
            Capacity          = @Capacity,
            RecordingUnit     = @RecordingUnit_Add,
            PurchasePrice     = @PurchasePrice,
            PurchaseDate      = @PurchaseDate,
            PurchaseFrom      = @PurchaseFrom,
            PurchaseInvoiceNo = @PurchaseInvoiceNo,
            DepreciationPct   = @DepreciationPct,
            OutputRate        = @OutputRate,
            OutputUnit        = @OutputUnit_Add,
            VendorID          = @VendorID,
            Status            = ISNULL(NULLIF(@Status_Add,''),'Active'),
            PhotoPath         = ISNULL(NULLIF(@PhotoPath,''), PhotoPath),
            Client            = @Client,
            Division          = @Division,
            DivisionID        = @DivisionID,
            SerialNo          = @SerialNo,
            MountCode         = NULLIF(@MountCode,''),
            IsVirtualAsset    = ISNULL(IsVirtualAsset,0),
            ModifiedBy        = @ModifiedBy_Add_Fallback,
            ModifiedOn        = GETDATE()
        WHERE AssetID = @AssetID;

        SET @SavedAssetID = @AssetID;
        SET @SavedAssetCode = @NewAssetCode;
        SET @OperationMsg = 'Asset updated successfully.';
    END
    ELSE
    BEGIN
        INSERT INTO dbo.mst_Asset
        (
            AssetCode, AssetName, OwnershipType, AssetTypeID, CategoryID, Make, ModelName, YearOfManufacture,
            RegistrationNo, EngineNo, ChassisNo, FuelType, Capacity, RecordingUnit, PurchasePrice, PurchaseDate,
            PurchaseFrom, PurchaseInvoiceNo, DepreciationPct, OutputRate, OutputUnit, VendorID, Status, PhotoPath,
            IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, Client, Division, DivisionID, SerialNo,
            MountCode, IsVirtualAsset
        )
        VALUES
        (
            @NewAssetCode, @AssetName, ISNULL(NULLIF(@OwnershipType,''),'Owned'), @AssetTypeID_Add, @CategoryID_Add,
            @Make, @ModelName, @YearOfManufacture, @RegistrationNo, @EngineNo, @ChassisNo, @FuelType_Add, @Capacity,
            @RecordingUnit_Add, @PurchasePrice, @PurchaseDate, @PurchaseFrom, @PurchaseInvoiceNo, @DepreciationPct,
            @OutputRate, @OutputUnit_Add, @VendorID, ISNULL(NULLIF(@Status_Add,''),'Active'),
            ISNULL(@PhotoPath,''), 1, @CreatedBy_Add, GETDATE(), NULL, NULL, @Client, @Division, @DivisionID, @SerialNo,
            NULLIF(@MountCode,''), 0
        );

        SET @SavedAssetID = SCOPE_IDENTITY();
        SET @SavedAssetCode = @NewAssetCode;
        SET @OperationMsg = 'Asset added successfully.';
    END

    IF ISNULL(LTRIM(RTRIM(@FrontPhotoPath)),'')<>'' 
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@SavedAssetID AND PhotoType='Front' AND ISNULL(IsActive,1)=1)
            UPDATE dbo.trn_AssetPhoto
            SET PhotoPath=@FrontPhotoPath, DisplayOrder=1, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
            WHERE AssetID=@SavedAssetID AND PhotoType='Front' AND ISNULL(IsActive,1)=1;
        ELSE
            INSERT INTO dbo.trn_AssetPhoto
            (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
            VALUES
            (@SavedAssetID, 'Front', @FrontPhotoPath, 1, 1, @CreatedBy_Add, GETDATE(), NULL, NULL);
    END

    IF ISNULL(LTRIM(RTRIM(@BackPhotoPath)),'')<>'' 
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@SavedAssetID AND PhotoType='Back' AND ISNULL(IsActive,1)=1)
            UPDATE dbo.trn_AssetPhoto
            SET PhotoPath=@BackPhotoPath, DisplayOrder=2, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
            WHERE AssetID=@SavedAssetID AND PhotoType='Back' AND ISNULL(IsActive,1)=1;
        ELSE
            INSERT INTO dbo.trn_AssetPhoto
            (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
            VALUES
            (@SavedAssetID, 'Back', @BackPhotoPath, 2, 1, @CreatedBy_Add, GETDATE(), NULL, NULL);
    END

    IF ISNULL(LTRIM(RTRIM(@LeftPhotoPath)),'')<>'' 
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@SavedAssetID AND PhotoType='Left' AND ISNULL(IsActive,1)=1)
            UPDATE dbo.trn_AssetPhoto
            SET PhotoPath=@LeftPhotoPath, DisplayOrder=3, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
            WHERE AssetID=@SavedAssetID AND PhotoType='Left' AND ISNULL(IsActive,1)=1;
        ELSE
            INSERT INTO dbo.trn_AssetPhoto
            (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
            VALUES
            (@SavedAssetID, 'Left', @LeftPhotoPath, 3, 1, @CreatedBy_Add, GETDATE(), NULL, NULL);
    END

    IF ISNULL(LTRIM(RTRIM(@RightPhotoPath)),'')<>'' 
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.trn_AssetPhoto WHERE AssetID=@SavedAssetID AND PhotoType='Right' AND ISNULL(IsActive,1)=1)
            UPDATE dbo.trn_AssetPhoto
            SET PhotoPath=@RightPhotoPath, DisplayOrder=4, ModifiedBy=@ModifiedBy_Add_Fallback, ModifiedOn=GETDATE()
            WHERE AssetID=@SavedAssetID AND PhotoType='Right' AND ISNULL(IsActive,1)=1;
        ELSE
            INSERT INTO dbo.trn_AssetPhoto
            (AssetID, PhotoType, PhotoPath, DisplayOrder, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
            VALUES
            (@SavedAssetID, 'Right', @RightPhotoPath, 4, 1, @CreatedBy_Add, GETDATE(), NULL, NULL);
    END

    IF ISNULL(@CategoryID_Add,0) IN (42,43)
       AND ISNULL(@MountCode,'') <> ''
    BEGIN
        DECLARE @CombinedCategoryID_TM INT;
        DECLARE @UpperAssetID_TM INT;
        DECLARE @ChassisAssetID_TM INT;
        DECLARE @UpperSerialNo_TM VARCHAR(200);
        DECLARE @ChassisRegNo_TM VARCHAR(200);
        DECLARE @ChassisMake_TM VARCHAR(200);
        DECLARE @ChassisModel_TM VARCHAR(200);
        DECLARE @VirtualFuelType_TM VARCHAR(100);
        DECLARE @VirtualDivision_TM VARCHAR(100);
        DECLARE @VirtualDivisionID_TM INT;
        DECLARE @VirtualClient_TM VARCHAR(100);
        DECLARE @VirtualAssetID_TM INT;
        DECLARE @VirtualAssetName_TM VARCHAR(300);
        DECLARE @VirtualAssetCode_TM VARCHAR(100);

        SELECT TOP 1
            @CombinedCategoryID_TM = c.CategoryID
        FROM dbo.mst_AssetCategory c
        INNER JOIN dbo.mst_AssetType t
            ON t.AssetTypeID = c.AssetTypeID
        WHERE LTRIM(RTRIM(t.TypeName)) = 'Transit Mixer'
          AND LTRIM(RTRIM(c.CategoryName)) = 'TRANSIT MIXER - COMBINED'
          AND ISNULL(c.IsActive,1)=1;

        SELECT TOP 1
            @UpperAssetID_TM = a.AssetID,
            @UpperSerialNo_TM = ISNULL(NULLIF(a.SerialNo,''), a.EngineNo)
        FROM dbo.mst_Asset a
        WHERE a.MountCode = @MountCode
          AND a.CategoryID = 42
          AND ISNULL(a.IsActive,1)=1
          AND ISNULL(a.IsVirtualAsset,0)=0
        ORDER BY a.AssetID DESC;

        SELECT TOP 1
            @ChassisAssetID_TM = a.AssetID,
            @ChassisRegNo_TM = a.RegistrationNo,
            @ChassisMake_TM = a.Make,
            @ChassisModel_TM = a.ModelName,
            @VirtualFuelType_TM = a.FuelType,
            @VirtualDivision_TM = a.Division,
            @VirtualDivisionID_TM = a.DivisionID,
            @VirtualClient_TM = a.Client
        FROM dbo.mst_Asset a
        WHERE a.MountCode = @MountCode
          AND a.CategoryID = 43
          AND ISNULL(a.IsActive,1)=1
          AND ISNULL(a.IsVirtualAsset,0)=0
        ORDER BY a.AssetID DESC;

        IF ISNULL(@CombinedCategoryID_TM,0) > 0
           AND ISNULL(@UpperAssetID_TM,0) > 0
           AND ISNULL(@ChassisAssetID_TM,0) > 0
        BEGIN
            SET @VirtualAssetCode_TM = @MountCode;
            SET @VirtualAssetName_TM =
                @MountCode + '(Transit Mixer)'
                + CASE WHEN ISNULL(@ChassisRegNo_TM,'') <> '' THEN '(' + @ChassisRegNo_TM + ')' ELSE '' END
                + CASE WHEN ISNULL(@UpperSerialNo_TM,'') <> '' THEN ' (' + @UpperSerialNo_TM + ')' ELSE '' END;

            SELECT TOP 1
                @VirtualAssetID_TM = a.AssetID
            FROM dbo.mst_Asset a
            WHERE a.MountCode = @MountCode
              AND a.CategoryID = @CombinedCategoryID_TM
              AND ISNULL(a.IsVirtualAsset,0)=1
              AND ISNULL(a.IsActive,1)=1
            ORDER BY a.AssetID DESC;

            IF ISNULL(@VirtualAssetID_TM,0)=0
            BEGIN
                INSERT INTO dbo.mst_Asset
                (
                    AssetCode, AssetName, OwnershipType, AssetTypeID, CategoryID, Make, ModelName, YearOfManufacture,
                    RegistrationNo, EngineNo, ChassisNo, FuelType, Capacity, RecordingUnit, PurchasePrice, PurchaseDate,
                    PurchaseFrom, PurchaseInvoiceNo, DepreciationPct, OutputRate, OutputUnit, VendorID, Status, PhotoPath,
                    IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, Client, Division, DivisionID, SerialNo,
                    MountCode, IsVirtualAsset
                )
                SELECT
                    @VirtualAssetCode_TM,
                    @VirtualAssetName_TM,
                    ISNULL(NULLIF(ca.OwnershipType,''),'Owned'),
                    ca.AssetTypeID,
                    @CombinedCategoryID_TM,
                    @ChassisMake_TM,
                    @ChassisModel_TM,
                    ca.YearOfManufacture,
                    @ChassisRegNo_TM,
                    ca.EngineNo,
                    ca.ChassisNo,
                    ISNULL(NULLIF(@VirtualFuelType_TM,''),'Diesel'),
                    ca.Capacity,
                    'KMR/HMR',
                    0,
                    NULL,
                    '',
                    '',
                    0,
                    0,
                    '',
                    ca.VendorID,
                    'Active',
                    ca.PhotoPath,
                    1,
                    @AuthEmployeeID,
                    GETDATE(),
                    NULL,
                    NULL,
                    @VirtualClient_TM,
                    @VirtualDivision_TM,
                    @VirtualDivisionID_TM,
                    @UpperSerialNo_TM,
                    @MountCode,
                    1
                FROM dbo.mst_Asset ca
                WHERE ca.AssetID = @ChassisAssetID_TM;

                SET @VirtualAssetID_TM = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                UPDATE dbo.mst_Asset
                SET
                    AssetCode      = @VirtualAssetCode_TM,
                    AssetName      = @VirtualAssetName_TM,
                    Make           = @ChassisMake_TM,
                    ModelName      = @ChassisModel_TM,
                    RegistrationNo = @ChassisRegNo_TM,
                    FuelType       = ISNULL(NULLIF(@VirtualFuelType_TM,''),'Diesel'),
                    RecordingUnit  = 'KMR/HMR',
                    Client         = @VirtualClient_TM,
                    Division       = @VirtualDivision_TM,
                    DivisionID     = @VirtualDivisionID_TM,
                    SerialNo       = @UpperSerialNo_TM,
                    MountCode      = @MountCode,
                    IsVirtualAsset = 1,
                    ModifiedBy     = @AuthEmployeeID,
                    ModifiedOn     = GETDATE()
                WHERE AssetID = @VirtualAssetID_TM;
            END

            IF EXISTS (
                SELECT 1
                FROM dbo.trn_AssetMounting
                WHERE MountCode = @MountCode
                  AND ISNULL(IsActive,1)=1
            )
            BEGIN
                UPDATE dbo.trn_AssetMounting
                SET
                    VirtualAssetID = @VirtualAssetID_TM,
                    ChassisAssetID = @ChassisAssetID_TM,
                    UpperAssetID   = @UpperAssetID_TM,
                    ModifiedBy     = @AuthEmployeeID,
                    ModifiedOn     = GETDATE()
                WHERE MountCode = @MountCode
                  AND ISNULL(IsActive,1)=1;
            END
            ELSE
            BEGIN
                INSERT INTO dbo.trn_AssetMounting
                (
                    MountCode,
                    VirtualAssetID,
                    ChassisAssetID,
                    UpperAssetID,
                    MountedOn,
                    IsActive,
                    CreatedBy,
                    CreatedOn
                )
                VALUES
                (
                    @MountCode,
                    @VirtualAssetID_TM,
                    @ChassisAssetID_TM,
                    @UpperAssetID_TM,
                    GETDATE(),
                    1,
                    @AuthEmployeeID,
                    GETDATE()
                );
            END
        END
    END

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        @OperationMsg AS Msg,
        @SavedAssetID AS AssetID,
        @SavedAssetCode AS AssetCode;
END

ELSE IF(@Event='GetAssetByID')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Asset
        WHERE AssetID=@AssetID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset not found.',16,1);

    SELECT
        a.AssetID,
        a.AssetCode,
        a.AssetName,
        a.OwnershipType,
        a.AssetTypeID,
        at2.TypeName AS AssetTypeName,
        a.CategoryID,
        ac.CategoryName,
        a.Make,
        a.ModelName,
        a.YearOfManufacture,
        a.RegistrationNo,
        a.SerialNo,
        a.EngineNo,
        a.ChassisNo,
        a.FuelType,
        a.Capacity,
        a.RecordingUnit,
        a.PurchasePrice,
        a.PurchaseDate,
        a.PurchaseFrom,
        a.PurchaseInvoiceNo,
        a.DepreciationPct,
        a.OutputRate,
        a.OutputUnit,
        a.VendorID,
        a.Status,
        a.PhotoPath,
        a.Client,
        a.Division,
        a.DivisionID,
        a.MountCode,
        a.IsVirtualAsset,
        a.IsActive,
        a.CreatedBy,
        a.CreatedOn,
        a.ModifiedBy,
        a.ModifiedOn
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetType at2
        ON at2.AssetTypeID = a.AssetTypeID
    LEFT JOIN dbo.mst_AssetCategory ac
        ON ac.CategoryID = a.CategoryID
    WHERE a.AssetID=@AssetID
      AND ISNULL(a.IsActive,1)=1;
END


ELSE IF(@Event='GetAssetPhotos')
BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END
	IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    SELECT
        AssetPhotoID,
        AssetID,
        PhotoType,
        PhotoPath,
        DisplayOrder,
        IsActive,
        CreatedBy,
        CreatedOn,
        ModifiedBy,
        ModifiedOn
    FROM dbo.trn_AssetPhoto
    WHERE AssetID=@AssetID
      AND ISNULL(IsActive,1)=1
    ORDER BY DisplayOrder, AssetPhotoID;
END

ELSE IF(@Event='DeleteAsset')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Asset.',16,1);
		RETURN;
	END
    DECLARE @ModifiedBy_Delete INT;
    SET @ModifiedBy_Delete = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT);

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF ISNULL(@ModifiedBy_Delete,0)=0
        RAISERROR('ModifiedBy is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Asset
        WHERE AssetID=@AssetID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset not found.',16,1);

    UPDATE dbo.mst_Asset
    SET
        IsActive = 0,
        ModifiedBy = @ModifiedBy_Delete,
        ModifiedOn = GETDATE()
    WHERE AssetID = @AssetID;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Asset deleted successfully.' AS Msg,
        @AssetID AS AssetID;
END

ELSE IF(@Event='EditAssetCategory')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Edit Asset Category.',16,1);
		RETURN;
	END
    DECLARE @ModifiedBy_Category INT;
    SET @ModifiedBy_Category = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT);
    SET @ParentCategoryID = NULLIF(@ParentCategoryID,0);

    IF ISNULL(@CategoryID,0)=0
        RAISERROR('CategoryID is required.',16,1);

    IF ISNULL(@AssetTypeID,0)=0
        RAISERROR('AssetTypeID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@CategoryName)),'')=''
        RAISERROR('CategoryName is required.',16,1);

    IF ISNULL(@ModifiedBy_Category,0)=0
        RAISERROR('ModifiedBy is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_AssetCategory
        WHERE CategoryID=@CategoryID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Category not found.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_AssetType
        WHERE AssetTypeID=@AssetTypeID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset Type not found.',16,1);

    IF @ParentCategoryID = @CategoryID
        RAISERROR('ParentCategoryID cannot be same as CategoryID.',16,1);

    IF @ParentCategoryID IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM dbo.mst_AssetCategory
        WHERE CategoryID=@ParentCategoryID
          AND AssetTypeID=@AssetTypeID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Parent category not found.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_AssetCategory
        WHERE AssetTypeID=@AssetTypeID
          AND LTRIM(RTRIM(CategoryName)) = LTRIM(RTRIM(@CategoryName))
          AND CategoryID<>@CategoryID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Category name already exists.',16,1);

    UPDATE dbo.mst_AssetCategory
    SET
        CategoryName = @CategoryName, AssetTypeID = @AssetTypeID ,
        ModifiedBy = @ModifiedBy_Category, ModifiedOn = GETDATE()
    WHERE CategoryID = @CategoryID;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Asset Category updated successfully.' AS Msg,
        @CategoryID AS CategoryID;
END

ELSE IF(@Event='DeleteAssetCategory')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Asset Category.',16,1);
		RETURN;
	END
    DECLARE @ModifiedBy_CategoryDelete INT;
    SET @ModifiedBy_CategoryDelete = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT);

    IF ISNULL(@CategoryID,0)=0
        RAISERROR('CategoryID is required.',16,1);

    IF ISNULL(@ModifiedBy_CategoryDelete,0)=0
        RAISERROR('ModifiedBy is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_AssetCategory
        WHERE CategoryID=@CategoryID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Category not found.',16,1);


    IF EXISTS (
        SELECT 1
        FROM dbo.mst_Asset
        WHERE CategoryID=@CategoryID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Cannot delete category because assets exist under it.',16,1);

    UPDATE dbo.mst_AssetCategory
    SET
        IsActive = 0,
        ModifiedBy = @ModifiedBy_CategoryDelete,
        ModifiedOn = GETDATE()
    WHERE CategoryID = @CategoryID;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Asset Category deleted successfully.' AS Msg,
        @CategoryID AS CategoryID;
END

ELSE IF(@Event='GetShiftList')
BEGIN
    SELECT
        ShiftID,
        ShiftName,
        StartTime,
        EndTime,
        IsActive,
        CreatedBy,
        CreatedOn
    FROM dbo.mst_Shift
    WHERE ISNULL(IsActive,1)=1
    ORDER BY ShiftID;
END

ELSE IF(@Event='AddShift')
BEGIN
    DECLARE @NewShiftCode VARCHAR(50),
            @NextShiftNo INT;

    IF ISNULL(LTRIM(RTRIM(@ShiftName)),'')=''
        RAISERROR('ShiftName is required.',16,1);

    IF @StartTime IS NULL
        RAISERROR('StartTime is required.',16,1);

    IF @EndTime IS NULL
        RAISERROR('EndTime is required.',16,1);

    IF ISNULL(@CreatedBy_Shift,0)=0
        RAISERROR('CreatedBy is required.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_Shift
        WHERE LTRIM(RTRIM(ShiftName)) = LTRIM(RTRIM(@ShiftName))
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Shift already exists.',16,1);

    IF ISNULL(LTRIM(RTRIM(@ShiftCode)),'')=''
    BEGIN
        SELECT @NextShiftNo = ISNULL(MAX(ShiftID),0) + 1
        FROM dbo.mst_Shift;

        SET @NewShiftCode = 'S' + CAST(@NextShiftNo AS VARCHAR(10));
    END
    ELSE
    BEGIN
        SET @NewShiftCode = @ShiftCode;
    END

    INSERT INTO dbo.mst_Shift
    (
        ShiftCode,ShiftName, StartTime,EndTime, IsActive,CreatedBy, CreatedOn
    )
    VALUES
    (
        @NewShiftCode, @ShiftName,@StartTime,@EndTime, 1,@CreatedBy_Shift,GETDATE()
    );

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Shift added successfully.' AS Msg,
        SCOPE_IDENTITY() AS ShiftID,
        @NewShiftCode AS ShiftCode;
END

ELSE IF(@Event='UpdateShift')
BEGIN
    DECLARE @ModifiedBy_Shift INT;
    SET @ModifiedBy_Shift = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT);

    IF ISNULL(@ShiftID,0)=0
        RAISERROR('ShiftID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@ShiftName)),'')=''
        RAISERROR('ShiftName is required.',16,1);

    IF @StartTime IS NULL
        RAISERROR('StartTime is required.',16,1);

    IF @EndTime IS NULL
        RAISERROR('EndTime is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Shift
        WHERE ShiftID=@ShiftID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Shift not found.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_Shift
        WHERE LTRIM(RTRIM(ShiftName)) = LTRIM(RTRIM(@ShiftName))
          AND ShiftID<>@ShiftID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Shift name already exists.',16,1);

    UPDATE dbo.mst_Shift
    SET
        ShiftName = @ShiftName,
        StartTime = @StartTime,
        EndTime = @EndTime
        --ModifiedBy = @ModifiedBy_Shift,
        --ModifiedOn = GETDATE()
    WHERE ShiftID = @ShiftID;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Shift updated successfully.' AS Msg,
        @ShiftID AS ShiftID;
END

ELSE IF(@Event='DeleteShift')
BEGIN
    DECLARE @ModifiedBy_ShiftDelete INT;
    SET @ModifiedBy_ShiftDelete = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT);

    IF ISNULL(@ShiftID,0)=0
        RAISERROR('ShiftID is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Shift
        WHERE ShiftID=@ShiftID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Shift not found.',16,1);

    UPDATE dbo.mst_Shift
    SET
        IsActive = 0
    WHERE ShiftID = @ShiftID;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Shift deleted successfully.' AS Msg,
        @ShiftID AS ShiftID;
END

ELSE IF(@Event='SaveAssetPhoto')
BEGIN
	IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END
		IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
		BEGIN
			RAISERROR('Only Admin can Delete Asset Category.',16,1);
			RETURN;
		END
    DECLARE @AssetPhotoID_Save INT;
    DECLARE @AssetID_Save INT;
    DECLARE @PhotoType_Save VARCHAR(20);
    DECLARE @PhotoPath_Save NVARCHAR(500);
    DECLARE @DisplayOrder_Save INT;
    DECLARE @ModifiedBy_Save INT;

    SET @AssetPhotoID_Save = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetPhotoID') AS INT);
    SET @AssetID_Save      = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetID') AS INT);
    SET @PhotoType_Save    = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoType');
    SET @PhotoPath_Save    = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PhotoPath');
    SET @DisplayOrder_Save = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'DisplayOrder') AS INT);
    SET @ModifiedBy_Save   = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT);

    IF ISNULL(@AssetID_Save,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF ISNULL(@PhotoType_Save,'')=''
        RAISERROR('PhotoType is required.',16,1);

    IF ISNULL(@PhotoPath_Save,'')=''
        RAISERROR('PhotoPath is required.',16,1);

    IF ISNULL(@ModifiedBy_Save,0)=0
        RAISERROR('ModifiedBy is required.',16,1);

    IF @PhotoType_Save NOT IN ('Front','Back','Left','Right','Other')
        RAISERROR('Invalid PhotoType.',16,1);

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.mst_Asset
        WHERE AssetID = @AssetID_Save
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset record not found.',16,1);

    IF ISNULL(@DisplayOrder_Save,0)=0
        SET @DisplayOrder_Save = 1;

    IF ISNULL(@AssetPhotoID_Save,0)=0
    BEGIN
        IF @PhotoType_Save IN ('Front','Back','Left','Right')
        BEGIN
            UPDATE dbo.trn_AssetPhoto
            SET
                IsActive = 0,
                ModifiedBy = @ModifiedBy_Save,
                ModifiedOn = GETDATE()
            WHERE AssetID = @AssetID_Save
              AND PhotoType = @PhotoType_Save
              AND ISNULL(IsActive,1)=1;
        END

        INSERT INTO dbo.trn_AssetPhoto
        (
            AssetID,
            PhotoType,
            PhotoPath,
            DisplayOrder,
            IsActive,
            CreatedBy,
            CreatedOn,
            ModifiedBy,
            ModifiedOn
        )
        VALUES
        (
            @AssetID_Save,
            @PhotoType_Save,
            @PhotoPath_Save,
            @DisplayOrder_Save,
            1,
            @ModifiedBy_Save,
            GETDATE(),
            @ModifiedBy_Save,
            GETDATE()
        );

        SET @AssetPhotoID_Save = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.trn_AssetPhoto
            WHERE AssetPhotoID=@AssetPhotoID_Save
              AND ISNULL(IsActive,1)=1
        )
            RAISERROR('Asset photo record not found.',16,1);

        UPDATE dbo.trn_AssetPhoto
        SET
            PhotoType = @PhotoType_Save,
            PhotoPath = @PhotoPath_Save,
            DisplayOrder = @DisplayOrder_Save,
            ModifiedBy = @ModifiedBy_Save,
            ModifiedOn = GETDATE()
        WHERE AssetPhotoID = @AssetPhotoID_Save;
    END

    IF @PhotoType_Save = 'Front'
    BEGIN
        UPDATE dbo.mst_Asset
        SET
            PhotoPath = @PhotoPath_Save,
            ModifiedBy = @ModifiedBy_Save,
            ModifiedOn = GETDATE()
        WHERE AssetID = @AssetID_Save;
    END

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Asset photo saved successfully.' AS Msg,
        @AssetPhotoID_Save AS AssetPhotoID,
        @AssetID_Save AS AssetID,
        @PhotoType_Save AS PhotoType,
        @PhotoPath_Save AS PhotoPath;
END

ELSE IF(@Event='GetAssetList')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        a.AssetID,
        a.AssetCode,
        a.AssetName,
        a.OwnershipType,
        a.AssetTypeID,
        at.TypeName AS AssetTypeName,
        a.CategoryID,
        ac.CategoryName,
        a.Make,
        a.ModelName,
        a.YearOfManufacture,
        a.RegistrationNo,
        a.SerialNo,
        a.EngineNo,
        a.ChassisNo,
        a.FuelType,
        a.Capacity,
        a.RecordingUnit,
        a.PurchasePrice,
        a.PurchaseDate,
        a.PurchaseFrom,
        a.PurchaseInvoiceNo,
        a.DepreciationPct,
        a.OutputRate,
        a.OutputUnit,
        a.VendorID,
        a.Status,
        a.PhotoPath,
        a.IsActive,
        a.CreatedBy,
        a.CreatedOn,
        a.ModifiedBy,
        a.ModifiedOn,
        a.Guid,
        a.ProjectID,
        a.Client,
        a.Division,
        a.DivisionID,
        a.MountCode,
        a.IsVirtualAsset
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetType at
        ON at.AssetTypeID = a.AssetTypeID
    LEFT JOIN dbo.mst_AssetCategory ac
        ON ac.CategoryID = a.CategoryID
    WHERE ISNULL(a.IsActive,1)=1
      AND (
            ISNULL(@ScopeDivisionID,0)=0
            OR a.DivisionID = @ScopeDivisionID
          )
    ORDER BY a.AssetName;
END


-- Asset master Event End 

-- Operater Master Event start

ELSE IF(@Event='GetOperatorList')
BEGIN

    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    ;WITH ActiveAllocation AS
    (
        SELECT
            al.OperatorID,
            al.ProjectID
            
        FROM dbo.trn_ProjectUserAllocation al
        WHERE ISNULL(al.IsActive,1)=1
    )

    SELECT
        o.OperatorID,
        o.OperatorCode,
        o.EmployeeID,
        o.FullName,
        o.DateOfBirth,
        o.Gender,
        o.Mobile,
        o.EmergencyContact,
        o.BloodGroup,
        o.AadhaarNo,
        o.PANNo,
        o.LicenseNo,
        o.LicenseType,
        o.LicenseExpiry,
        o.BankName,
        o.AccountNo,
        o.IFSC,
        o.PFNo,
        o.ESINo,
        o.Address,
        o.DateOfJoining,
        o.OperatorType,
        o.PhotoPath,
        o.Status,
        aa.ProjectID,
        p.ProjectName AS CurrentProject,
        o.IsActive,
        o.CreatedBy,
        o.CreatedOn,
        o.ModifiedBy,
        o.ModifiedOn
    FROM dbo.mst_Operator o

    LEFT JOIN ActiveAllocation aa
        ON aa.OperatorID = o.OperatorID


    LEFT JOIN dbo.mst_Project p
        ON p.ProjectID = aa.ProjectID

    WHERE ISNULL(o.IsActive,1)=1
      AND (
            ISNULL(@ScopeDivisionID,0)=0
            OR p.DivisionID = @ScopeDivisionID
          )
    ORDER BY o.OperatorID DESC;

END



ELSE IF(@Event='AddOperator')
 BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Add Operator.',16,1);
		RETURN;
	END
     DECLARE @EmployeeID_Operator INT;

     SET @EmployeeID_Operator = COALESCE(
         TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EmployeeID') AS INT),
         TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_EmployeeID') AS INT),
         TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_employee_id') AS INT)
     );

     SET @FullName = ISNULL(NULLIF(@FullName,''), @FullName_OpPrefix);
     SET @DateOfBirth = ISNULL(@DateOfBirth, @DateOfBirth_OpPrefix);
     SET @Gender = ISNULL(NULLIF(@Gender,''), @Gender_OpPrefix);
     SET @Mobile = ISNULL(NULLIF(@Mobile,''), @Mobile_OpPrefix);
     SET @EmergencyContact = ISNULL(NULLIF(@EmergencyContact,''), @EmergencyContact_OpPrefix);
     SET @BloodGroup = ISNULL(NULLIF(@BloodGroup,''), @BloodGroup_OpPrefix);
     SET @AadhaarNo = ISNULL(NULLIF(@AadhaarNo,''), @AadhaarNo_OpPrefix);
     SET @PANNo = ISNULL(NULLIF(@PANNo,''), @PANNo_OpPrefix);
     SET @LicenseNo_Operator = ISNULL(NULLIF(@LicenseNo_Operator,''), @LicenseNo_OpPrefix);
     SET @LicenseType = ISNULL(NULLIF(@LicenseType,''), @LicenseType_OpPrefix);
     SET @LicenseExpiry = ISNULL(@LicenseExpiry, @LicenseExpiry_OpPrefix);
     SET @Address = ISNULL(NULLIF(@Address,''), @Address_OpPrefix);
     SET @DateOfJoining = ISNULL(@DateOfJoining, @DateOfJoining_OpPrefix);
     SET @Status_Operator = ISNULL(NULLIF(@Status_Operator,''), @Status_OpPrefix);
     SET @PhotoPath_Operator = ISNULL(NULLIF(@PhotoPath_Operator,''), NULLIF(@PhotoPath_OpPrefix,''));
     SET @CreatedBy_Operator = CASE
         WHEN ISNULL(@CreatedBy_Operator,0)=0 THEN @CreatedBy_OpPrefix
         ELSE @CreatedBy_Operator
     END;

     SET @BankName = ISNULL(NULLIF(@BankName,''), @BankName_OpPrefix);
     SET @AccountNo = ISNULL(NULLIF(@AccountNo,''), @AccountNo_OpPrefix);
     SET @IFSC = ISNULL(NULLIF(@IFSC,''), @IFSC_OpPrefix);
     SET @PFNo = ISNULL(NULLIF(@PFNo,''), @PFNo_OpPrefix);
     SET @ESINo = ISNULL(NULLIF(@ESINo,''), @ESINo_OpPrefix);
     SET @OperatorType = ISNULL(NULLIF(@OperatorType,''), @OperatorType_OpPrefix);
     SET @Gender = COALESCE(
         NULLIF(@Gender,''),
         NULLIF(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_gender'),''),
         NULLIF(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_Gender'),'')
     );

     IF ISNULL(LTRIM(RTRIM(@PhotoPath_Operator)),'')=''
         SET @PhotoPath_Operator = @Template36PhotoPath;

     IF ISNULL(LTRIM(RTRIM(@PhotoPath_Operator)),'')<>''
     BEGIN
         SET @PhotoPath_Operator = REPLACE(@PhotoPath_Operator,'{{baseurl}}/I_Drive/Documents\','');
         SET @PhotoPath_Operator = REPLACE(@PhotoPath_Operator,'{{baseurl}}/I_Drive/Documents/','');
         SET @PhotoPath_Operator = REPLACE(@PhotoPath_Operator,'\','/');
         IF LEFT(@PhotoPath_Operator,1)='/' SET @PhotoPath_Operator = STUFF(@PhotoPath_Operator,1,1,'');
         IF @PhotoPath_Operator LIKE 'C:%' SET @PhotoPath_Operator = '';
     END

     IF ISNULL(@EmployeeID_Operator,0)=0
         RAISERROR('EmployeeID is required.',16,1);

     IF ISNULL(LTRIM(RTRIM(@FullName)),'')=''
         RAISERROR('FullName is required Error from sp.',16,1);

     --IF @DateOfBirth IS NULL
     --    RAISERROR('DateOfBirth is required.',16,1);

     IF ISNULL(LTRIM(RTRIM(@Gender)),'')=''
         RAISERROR('Gender is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@Mobile)),'')=''
     --    RAISERROR('Mobile is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@EmergencyContact)),'')=''
     --    RAISERROR('EmergencyContact is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@BloodGroup)),'')=''
     --    RAISERROR('BloodGroup is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@AadhaarNo)),'')=''
     --    RAISERROR('AadhaarNo is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@PANNo)),'')=''
     --    RAISERROR('PANNo is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@LicenseNo_Operator)),'')=''
     --    RAISERROR('LicenseNo is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@LicenseType)),'')=''
     --    RAISERROR('LicenseType is required.',16,1);

     --IF @LicenseExpiry IS NULL
     --    RAISERROR('LicenseExpiry is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@Address)),'')=''
     --    RAISERROR('Address is required.',16,1);

     IF @DateOfJoining IS NULL
         RAISERROR('DateOfJoining is required.',16,1);

     IF ISNULL(LTRIM(RTRIM(@Status_Operator)),'')=''
         RAISERROR('Status is required.',16,1);

     IF ISNULL(@CreatedBy_Operator,0)=0
         RAISERROR('CreatedBy is required.',16,1);

     IF EXISTS (
         SELECT 1
         FROM dbo.mst_Operator
         WHERE EmployeeID=@EmployeeID_Operator
           AND ISNULL(IsActive,1)=1
     )
         RAISERROR('EmployeeID already exists.',16,1);

     --IF EXISTS (
     --    SELECT 1
     --    FROM dbo.mst_Operator
     --    WHERE Mobile=@Mobile
     --      AND ISNULL(IsActive,1)=1
     --)
     --    RAISERROR('Mobile already exists.',16,1);

     --IF EXISTS (
     --    SELECT 1
     --    FROM dbo.mst_Operator
     --    WHERE AadhaarNo=@AadhaarNo
     --      AND ISNULL(IsActive,1)=1
     --)
     --    RAISERROR('AadhaarNo already exists.',16,1);

     --IF EXISTS (
     --    SELECT 1
     --    FROM dbo.mst_Operator
     --    WHERE PANNo=@PANNo
     --      AND ISNULL(IsActive,1)=1
     --)
     --    RAISERROR('PANNo already exists.',16,1);

     --IF EXISTS (
     --    SELECT 1
     --    FROM dbo.mst_Operator
     --    WHERE LicenseNo=@LicenseNo_Operator
     --      AND ISNULL(IsActive,1)=1
     --)
     --    RAISERROR('LicenseNo already exists.',16,1);

     SELECT @OperatorCode = 'OP' + RIGHT('000' + CAST(ISNULL(MAX(OperatorID),0) + 1 AS VARCHAR(10)),3)
     FROM dbo.mst_Operator;

     INSERT INTO dbo.mst_Operator
     (
         OperatorCode,
         EmployeeID,
         FullName,
         DateOfBirth,
         Gender,
         Mobile,
         EmergencyContact,
         BloodGroup,
         AadhaarNo,
         PANNo,
         LicenseNo,
         LicenseType,
         LicenseExpiry,
         Address,
         DateOfJoining,
         Status,
         PhotoPath,
         IsActive,
         CreatedBy,
         CreatedOn,
         ModifiedBy,
         ModifiedOn,
         BankName,
         AccountNo,
         IFSC,
         PFNo,
         ESINo,
         OperatorType
     )
     VALUES
     (
         @OperatorCode,
         @EmployeeID_Operator,
         @FullName,
         @DateOfBirth,
         @Gender,
         @Mobile,
         @EmergencyContact,
         @BloodGroup,
         @AadhaarNo,
         @PANNo,
         @LicenseNo_Operator,
         @LicenseType,
         @LicenseExpiry,
         @Address,
         @DateOfJoining,
         @Status_Operator,
         ISNULL(@PhotoPath_Operator,''),
         1,
         @CreatedBy_Operator,
         GETDATE(),
         NULL,
         NULL,
         @BankName,
         @AccountNo,
         @IFSC,
         @PFNo,
         @ESINo,
         @OperatorType
     );

     UPDATE dbo.tbl_Log
     SET Status='Success'
     WHERE Id=@LastId;

     SELECT
         'Success' AS Status,
         'Operator added successfully.' AS Msg,
         SCOPE_IDENTITY() AS OperatorID,
         @OperatorCode AS OperatorCode,
         @EmployeeID_Operator AS EmployeeID;
 END


ELSE IF(@Event='EditOperator')
 BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Edit Operator.',16,1);
		RETURN;
	END
     DECLARE @EmployeeID_OperatorEdit INT;

     SET @EmployeeID_OperatorEdit = COALESCE(
         TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EmployeeID') AS INT),
         TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_EmployeeID') AS INT),
         TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_employee_id') AS INT)
     );

     SET @FullName = ISNULL(NULLIF(@FullName,''), @FullName_OpPrefix);
     SET @DateOfBirth = ISNULL(@DateOfBirth, @DateOfBirth_OpPrefix);
     SET @Gender = ISNULL(NULLIF(@Gender,''), @Gender_OpPrefix);
     SET @Mobile = ISNULL(NULLIF(@Mobile,''), @Mobile_OpPrefix);
     SET @EmergencyContact = ISNULL(NULLIF(@EmergencyContact,''), @EmergencyContact_OpPrefix);
     SET @BloodGroup = ISNULL(NULLIF(@BloodGroup,''), @BloodGroup_OpPrefix);
     SET @AadhaarNo = ISNULL(NULLIF(@AadhaarNo,''), @AadhaarNo_OpPrefix);
     SET @PANNo = ISNULL(NULLIF(@PANNo,''), @PANNo_OpPrefix);
     SET @LicenseNo_Operator = ISNULL(NULLIF(@LicenseNo_Operator,''), @LicenseNo_OpPrefix);
     SET @LicenseType = ISNULL(NULLIF(@LicenseType,''), @LicenseType_OpPrefix);
     SET @LicenseExpiry = ISNULL(@LicenseExpiry, @LicenseExpiry_OpPrefix);
     SET @Address = ISNULL(NULLIF(@Address,''), @Address_OpPrefix);
     SET @DateOfJoining = ISNULL(@DateOfJoining, @DateOfJoining_OpPrefix);
     SET @Status_Operator = ISNULL(NULLIF(@Status_Operator,''), @Status_OpPrefix);
     SET @PhotoPath_Operator = ISNULL(NULLIF(@PhotoPath_Operator,''), NULLIF(@PhotoPath_OpPrefix,''));
     SET @BankName = ISNULL(NULLIF(@BankName,''), @BankName_OpPrefix);
     SET @AccountNo = ISNULL(NULLIF(@AccountNo,''), @AccountNo_OpPrefix);
     SET @IFSC = ISNULL(NULLIF(@IFSC,''), @IFSC_OpPrefix);
     SET @PFNo = ISNULL(NULLIF(@PFNo,''), @PFNo_OpPrefix);
     SET @ESINo = ISNULL(NULLIF(@ESINo,''), @ESINo_OpPrefix);
     SET @OperatorType = ISNULL(NULLIF(@OperatorType,''), @OperatorType_OpPrefix);
     SET @Gender = COALESCE(
         NULLIF(@Gender,''),
         NULLIF(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_gender'),''),
         NULLIF(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'op_Gender'),'')
     );

     IF ISNULL(LTRIM(RTRIM(@PhotoPath_Operator)),'')=''
         SET @PhotoPath_Operator = @Template36PhotoPath;

     IF ISNULL(LTRIM(RTRIM(@PhotoPath_Operator)),'')<>''
     BEGIN
         SET @PhotoPath_Operator = REPLACE(@PhotoPath_Operator,'{{baseurl}}/I_Drive/Documents\','');
         SET @PhotoPath_Operator = REPLACE(@PhotoPath_Operator,'{{baseurl}}/I_Drive/Documents/','');
         SET @PhotoPath_Operator = REPLACE(@PhotoPath_Operator,'\','/');
         IF LEFT(@PhotoPath_Operator,1)='/' SET @PhotoPath_Operator = STUFF(@PhotoPath_Operator,1,1,'');
         IF @PhotoPath_Operator LIKE 'C:%' SET @PhotoPath_Operator = NULL;
     END

     IF ISNULL(@OperatorID,0)=0
         RAISERROR('OperatorID is required.',16,1);

     IF ISNULL(LTRIM(RTRIM(@OperatorCode)),'')=''
         RAISERROR('OperatorCode is required.',16,1);

     IF ISNULL(@EmployeeID_OperatorEdit,0)=0
         RAISERROR('EmployeeID is required.',16,1);

     IF ISNULL(LTRIM(RTRIM(@FullName)),'')=''
         RAISERROR('FullName is required.',16,1);

     IF @DateOfBirth IS NULL
         RAISERROR('DateOfBirth is required.',16,1);

     IF ISNULL(LTRIM(RTRIM(@Gender)),'')=''
         RAISERROR('Gender is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@Mobile)),'')=''
     --    RAISERROR('Mobile is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@EmergencyContact)),'')=''
     --    RAISERROR('EmergencyContact is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@BloodGroup)),'')=''
     --    RAISERROR('BloodGroup is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@AadhaarNo)),'')=''
     --    RAISERROR('AadhaarNo is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@PANNo)),'')=''
     --    RAISERROR('PANNo is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@LicenseNo_Operator)),'')=''
     --    RAISERROR('LicenseNo is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@LicenseType)),'')=''
     --    RAISERROR('LicenseType is required.',16,1);

     --IF @LicenseExpiry IS NULL
     --    RAISERROR('LicenseExpiry is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@Address)),'')=''
     --    RAISERROR('Address is required.',16,1);

     --IF @DateOfJoining IS NULL
     --    RAISERROR('DateOfJoining is required.',16,1);

     --IF ISNULL(LTRIM(RTRIM(@Status_Operator)),'')=''
     --    RAISERROR('Status is required.',16,1);

     --IF ISNULL(@ModifiedBy,0)=0
     --    RAISERROR('ModifiedBy is required.',16,1);

     IF NOT EXISTS (
         SELECT 1
         FROM dbo.mst_Operator
         WHERE OperatorID=@OperatorID
           AND ISNULL(IsActive,1)=1
     )
         RAISERROR('Operator not found.',16,1);

     IF EXISTS (
         SELECT 1
         FROM dbo.mst_Operator
         WHERE EmployeeID=@EmployeeID_OperatorEdit
           AND OperatorID<>@OperatorID
           AND ISNULL(IsActive,1)=1
     )
         RAISERROR('EmployeeID already exists.',16,1);

     --IF EXISTS (
     --    SELECT 1
     --    FROM dbo.mst_Operator
     --    WHERE Mobile=@Mobile
     --      AND OperatorID<>@OperatorID
     --      AND ISNULL(IsActive,1)=1
     --)
     --    RAISERROR('Mobile already exists.',16,1);

     --IF EXISTS (
     --    SELECT 1
     --    FROM dbo.mst_Operator
     --    WHERE AadhaarNo=@AadhaarNo
     --      AND OperatorID<>@OperatorID
     --      AND ISNULL(IsActive,1)=1
     --)
     --    RAISERROR('AadhaarNo already exists.',16,1);

     --IF EXISTS (
     --    SELECT 1
     --    FROM dbo.mst_Operator
     --    WHERE PANNo=@PANNo
     --      AND OperatorID<>@OperatorID
     --      AND ISNULL(IsActive,1)=1
     --)
     --    RAISERROR('PANNo already exists.',16,1);

     --IF EXISTS (
     --    SELECT 1
     --    FROM dbo.mst_Operator
     --    WHERE LicenseNo=@LicenseNo_Operator
     --      AND OperatorID<>@OperatorID
     --      AND ISNULL(IsActive,1)=1
     --)
     --    RAISERROR('LicenseNo already exists.',16,1);

     UPDATE dbo.mst_Operator
     SET
         OperatorCode = @OperatorCode,
         EmployeeID = @EmployeeID_OperatorEdit,
         FullName = @FullName,
         DateOfBirth = @DateOfBirth,
         Gender = @Gender,
         Mobile = @Mobile,
         EmergencyContact = @EmergencyContact,
         BloodGroup = @BloodGroup,
         AadhaarNo = @AadhaarNo,
         PANNo = @PANNo,
         LicenseNo = @LicenseNo_Operator,
         LicenseType = @LicenseType,
         LicenseExpiry = @LicenseExpiry,
         Address = @Address,
         DateOfJoining = @DateOfJoining,
         Status = @Status_Operator,
         PhotoPath = ISNULL(@PhotoPath_Operator, PhotoPath),
         BankName = @BankName,
         AccountNo = @AccountNo,
         IFSC = @IFSC,
         PFNo = @PFNo,
         ESINo = @ESINo,
         OperatorType = @OperatorType,
         ModifiedBy = @ModifiedBy,
         ModifiedOn = GETDATE()
     WHERE OperatorID=@OperatorID;

     UPDATE dbo.tbl_Log
     SET Status='Success'
     WHERE Id=@LastId;

     SELECT
         'Success' AS Status,
         'Operator updated successfully.' AS Msg,
         @OperatorID AS OperatorID,
         @OperatorCode AS OperatorCode,
         @EmployeeID_OperatorEdit AS EmployeeID;
 END

 ELSE IF(@Event='DeleteOperator')
 BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Operator.',16,1);
		RETURN;
	END
     DECLARE @ModifiedBy_OperatorDelete INT;
     SET @ModifiedBy_OperatorDelete = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS
INT);

     IF ISNULL(@OperatorID,0)=0
         RAISERROR('OperatorID is required.',16,1);

     IF ISNULL(@ModifiedBy_OperatorDelete,0)=0
         RAISERROR('ModifiedBy is required.',16,1);

     IF NOT EXISTS (
         SELECT 1
         FROM dbo.mst_Operator
         WHERE OperatorID=@OperatorID
           AND ISNULL(IsActive,1)=1
     )
         RAISERROR('Operator not found.',16,1);

     IF EXISTS (
			SELECT 1
			FROM dbo.trn_ProjectUserAllocation
			WHERE OperatorID = 72
			  AND EndDate IS NULL
		)
		BEGIN
			RAISERROR('Cannot delete operator because active allocation exists.',16,1);
		END
      
     UPDATE dbo.mst_Operator
     SET
         IsActive = 0,
         ModifiedBy = @ModifiedBy_OperatorDelete,
         ModifiedOn = GETDATE()
     WHERE OperatorID = @OperatorID;

     UPDATE dbo.tbl_Log
     SET Status='Success'
     WHERE Id=@LastId;

     SELECT
         'Success' AS Status,
         'Operator deleted successfully.' AS Msg,
         @OperatorID AS OperatorID;
 END

ELSE IF(@Event='UpdateLog')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @ProductionUnit_Update VARCHAR(100),
            @ExistingStatus VARCHAR(50),
            @ExistingSubmittedBy INT,
            @ExistingSubmissionStatus VARCHAR(50),
            @FinalRecordingUnit VARCHAR(50),
            @FinalFuelType VARCHAR(100);

    IF ISNULL(@LogID,0)=0
        RAISERROR('LogID is required.',16,1);

    IF @StartDateTime IS NULL
        RAISERROR('StartDateTime is required.',16,1);

    SELECT
        @AssetID = dl.AssetID,
        @ProjectID = dl.ProjectID,
        @AllocationID = dl.AllocationID,
        @ExistingStatus = dl.MachineStatus,
        @ExistingSubmittedBy = dl.SubmittedBy,
        @ExistingSubmissionStatus = dl.SubmissionStatus,
        @ExistingStartHMR = dl.StartHMR,
        @ExistingEndHMR = dl.EndHMR,
        @ExistingStartKMR = dl.StartKMR,
        @ExistingEndKMR = dl.EndKMR,
        @OperatorID = ISNULL(@OperatorID, dl.OperatorID)
    FROM dbo.trn_DailyLog dl
    WHERE dl.LogID = @LogID;

    IF ISNULL(@AssetID,0)=0
        RAISERROR('Log not found.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can update only your assigned division logs.',16,1);
            RETURN;
        END
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Operator'
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Operator o
            WHERE o.OperatorID = @OperatorID
              AND o.EmployeeID = @AuthEmployeeID
              AND ISNULL(o.IsActive,1)=1
        )
        BEGIN
            RAISERROR('Operator can update only their own logs.',16,1);
            RETURN;
        END
    END

    SELECT
        @ProductionUnit_Update = ISNULL(NULLIF(ma.OutputUnit,''),''),
        @FinalFuelType = ISNULL(NULLIF(ma.FuelType,''),''),
        @FinalRecordingUnit =
        CASE
            WHEN ISNULL(NULLIF(ma.RecordingUnit,''),'') IN ('KMR/HMR','Both')
              OR ISNULL(NULLIF(cd.RecordingUnit,''),'') IN ('KMR/HMR','Both')
            THEN 'KMR/HMR'
            WHEN ISNULL(NULLIF(ma.RecordingUnit,''),'') <> ''
            THEN ma.RecordingUnit
            WHEN ISNULL(NULLIF(cd.RecordingUnit,''),'') <> ''
            THEN cd.RecordingUnit
            ELSE 'Hours'
        END
    FROM dbo.mst_Asset ma
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = ma.CategoryID
    WHERE ma.AssetID = @AssetID;

    SET @UsesHMR =
        CASE
            WHEN @FinalRecordingUnit IN ('Hours','Hour','HMR','Both','KMR/HMR')
            THEN 1 ELSE 0
        END;

    SET @UsesKMR =
        CASE
            WHEN @FinalRecordingUnit IN ('Kilometer','Kilometers','KM','KMR','Both','KMR/HMR')
            THEN 1 ELSE 0
        END;

    IF ISNULL(@OperatorID,0)=0
        RAISERROR('OperatorID is required.',16,1);

    IF ISNULL(@MachineStatus,'')=''
        RAISERROR('MachineStatus is required.',16,1);

    IF @EndDateTime IS NOT NULL
       AND @EndDateTime < @StartDateTime
        RAISERROR('EndDateTime cannot be less than StartDateTime.',16,1);

    IF @UsesHMR = 1 AND @StartHMR IS NULL
        SET @StartHMR = @ExistingStartHMR;

    IF @UsesKMR = 1 AND @StartKMR IS NULL
        SET @StartKMR = @ExistingStartKMR;

    IF @UsesHMR = 1 AND @StartHMR IS NULL
        RAISERROR('StartHMR is required.',16,1);

    IF @UsesKMR = 1 AND @StartKMR IS NULL
        RAISERROR('StartKMR is required.',16,1);

    IF @EndDateTime IS NOT NULL
    BEGIN
        IF @UsesHMR = 1 AND @EndHMR IS NULL
            SET @EndHMR = @ExistingEndHMR;

        IF @UsesKMR = 1 AND @EndKMR IS NULL
            SET @EndKMR = @ExistingEndKMR;
    END
    ELSE
    BEGIN
        IF @UsesHMR = 1 AND @EndHMR IS NULL
            SET @EndHMR = @StartHMR;

        IF @UsesKMR = 1 AND @EndKMR IS NULL
            SET @EndKMR = @StartKMR;
    END

    IF @UsesHMR = 1 AND @EndHMR < @StartHMR
        RAISERROR('EndHMR cannot be less than StartHMR.',16,1);

    IF @UsesKMR = 1 AND @EndKMR < @StartKMR
        RAISERROR('EndKMR cannot be less than StartKMR.',16,1);

    UPDATE dbo.trn_DailyLog
    SET
        LogDate = CAST(@StartDateTime AS DATE),
        ProjectID = @ProjectID,
        OperatorID = @OperatorID,
        StartDateTime = @StartDateTime,
        EndDateTime = @EndDateTime,
        StartHMR = CASE WHEN @UsesHMR = 1 THEN @StartHMR ELSE 0 END,
        EndHMR   = CASE WHEN @UsesHMR = 1 THEN @EndHMR ELSE 0 END,
        StartKMR = CASE WHEN @UsesKMR = 1 THEN @StartKMR ELSE 0 END,
        EndKMR   = CASE WHEN @UsesKMR = 1 THEN @EndKMR ELSE 0 END,
        MachineStatus = @MachineStatus,
        ProductionQty = ISNULL(@OutputQty,0),
        ProductionUnit = ISNULL(NULLIF(@ProductionUnit,''),@ProductionUnit_Update),
        IdleHours = ISNULL(@IdleHours,0),
        LunchDinnerHours = ISNULL(@LunchDinnerHours,0),
        BreakdownHours = ISNULL(@BreakdownHours,0),
        BreakdownReason = ISNULL(@BreakdownReason,''),
        Remarks = ISNULL(@WorkingRemarks,''),
        EndReadingPhoto = ISNULL(NULLIF(@EndReadingPhoto,''), EndReadingPhoto),
        RemarkPhoto = ISNULL(NULLIF(@RemarkPhoto,''), RemarkPhoto),
        IsPhotoUploaded =
            CASE
                WHEN NULLIF(@EndReadingPhoto,'') IS NOT NULL
                  OR NULLIF(@RemarkPhoto,'') IS NOT NULL
                  OR ISNULL(IsPhotoUploaded,0)=1
                THEN 1 ELSE 0
            END,
        SubmittedBy = @ExistingSubmittedBy,
        SubmissionStatus = @ExistingSubmissionStatus,
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE(),
        LogVerificationStatus = ISNULL(@LogVerificationStatus,0),
        LogVerificationDate =
            CASE
                WHEN ISNULL(@LogVerificationStatus,0)=1
                THEN @LogVerificationDate
                ELSE NULL
            END
    WHERE LogID = @LogID;

    IF @@ROWCOUNT = 0
        RAISERROR('UpdateLog failed.',16,1);

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Log updated successfully.' AS Msg,
        @LogID AS LogID;
END


-- operatoer master Event End

-- Allocation Asset and Project Start

ELSE IF(@Event='GetAllocationAssets')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    ;WITH ActiveMount AS
    (
        SELECT
            am.MountCode,
            am.VirtualAssetID,
            am.ChassisAssetID,
            am.UpperAssetID
        FROM dbo.trn_AssetMounting am
        WHERE ISNULL(am.IsActive,1)=1
          AND am.UnmountedOn IS NULL
    ),
    AssetOperationalMap AS
    (
        SELECT
            a.AssetID AS BaseAssetID,
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN am.VirtualAssetID IS NOT NULL AND a.CategoryID IN (42,43) THEN am.VirtualAssetID
                ELSE a.AssetID
            END AS EffectiveAssetID
        FROM dbo.mst_Asset a
        LEFT JOIN ActiveMount am
            ON am.ChassisAssetID = a.AssetID
            OR am.UpperAssetID = a.AssetID
        WHERE ISNULL(a.IsActive,1)=1
    ),
    EffectiveAssets AS
    (
        SELECT
            ea.AssetID,
            ea.AssetCode,
            ea.AssetName,
            ea.AssetTypeID,
            ea.CategoryID,
            ea.RegistrationNo,
            ea.Status,
            ea.DivisionID,
            ea.IsVirtualAsset
        FROM dbo.mst_Asset ea
        WHERE ISNULL(ea.IsActive,1)=1
          AND (
                ISNULL(@ScopeDivisionID,0)=0
                OR ea.DivisionID = @ScopeDivisionID
              )
          AND (
                ISNULL(ea.IsVirtualAsset,0)=1
                OR NOT EXISTS
                (
                    SELECT 1
                    FROM ActiveMount amx
                    WHERE amx.ChassisAssetID = ea.AssetID
                       OR amx.UpperAssetID = ea.AssetID
                )
              )
    ),
    CurrentProjectAllocation AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            pma.ProjectID,
            pma.ID AS AllocationID,
            ROW_NUMBER() OVER
            (
                PARTITION BY map.EffectiveAssetID
                ORDER BY pma.ID DESC
            ) AS rn
        FROM dbo.trn_ProjectMachineAllocation pma
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = pma.AssetID
        INNER JOIN dbo.mst_Project mp
            ON mp.ProjectID = pma.ProjectID
           AND ISNULL(mp.IsActive,1)=1
        WHERE ISNULL(pma.IsActive,1)=1
          AND pma.EndDate IS NULL
          AND (
                ISNULL(@ScopeDivisionID,0)=0
                OR mp.DivisionID = @ScopeDivisionID
              )
    ),
    ActiveMachineOperators AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            moa.ProjectID,
            STRING_AGG(CAST(moa.OperatorID AS VARCHAR(20)), ',') AS OperatorID,
            STRING_AGG(o.FullName, ', ') AS CurrentOperator
        FROM dbo.trn_MachineOperatorAllocation moa
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = moa.AssetID
        LEFT JOIN dbo.mst_Operator o
            ON o.OperatorID = moa.OperatorID
        WHERE moa.EndDate IS NULL
          AND ISNULL(moa.IsActive,1)=1
        GROUP BY map.EffectiveAssetID, moa.ProjectID
    ),
    LatestLog AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            dl.LogID,
            dl.MachineStatus,
            dl.SubmissionStatus,
            dl.LogDate,
            dl.StartDateTime,
            dl.EndDateTime,
            ROW_NUMBER() OVER
            (
                PARTITION BY map.EffectiveAssetID
                ORDER BY dl.LogDate DESC, dl.LogID DESC
            ) AS rn
        FROM dbo.trn_DailyLog dl
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = dl.AssetID
    )
    SELECT
        a.AssetID,
        a.AssetCode,
        a.AssetName,
        a.AssetTypeID,
        at.TypeName AS AssetTypeName,
        a.CategoryID,
        ac.CategoryName,
        a.RegistrationNo,
        a.Status AS AssetMasterStatus,
        cur.ProjectID,
        p.ProjectName AS CurrentProject,
        amo.OperatorID,
        amo.CurrentOperator,
        CASE
            WHEN ll.MachineStatus IS NOT NULL THEN ll.MachineStatus
            WHEN cur.ProjectID IS NOT NULL THEN 'Idle'
            ELSE 'Idle'
        END AS CurrentStatus
    FROM EffectiveAssets a
    LEFT JOIN dbo.mst_AssetType at
        ON at.AssetTypeID = a.AssetTypeID
    LEFT JOIN dbo.mst_AssetCategory ac
        ON ac.CategoryID = a.CategoryID
    LEFT JOIN CurrentProjectAllocation cur
        ON cur.AssetID = a.AssetID
       AND cur.rn = 1
    LEFT JOIN ActiveMachineOperators amo
        ON amo.AssetID = a.AssetID
       AND ISNULL(amo.ProjectID,0) = ISNULL(cur.ProjectID,0)
    LEFT JOIN dbo.mst_Project p
        ON p.ProjectID = cur.ProjectID
    LEFT JOIN LatestLog ll
        ON ll.AssetID = a.AssetID
       AND ll.rn = 1
    ORDER BY a.AssetName;
END

ELSE IF(@Event='GetAllocationProjects')
BEGIN
	IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
	END
    SELECT
        p.ProjectID,
        p.ProjectCode,
        p.ProjectName,
        p.Location,
        p.ClientName,
        p.Status,
        p.IsActive,
        p.DivisionID,
        d.DivisionName
    FROM dbo.mst_Project p
    LEFT JOIN dbo.mst_Division d
        ON d.DivisionID = p.DivisionID
    WHERE ISNULL(p.IsActive,1) = 1
	 AND (
            ISNULL(@ScopeDivisionID,0)=0
            OR p.DivisionID = @ScopeDivisionID
          )
    ORDER BY p.ProjectName;
END


ELSE IF(@Event='GetAllocationOperators')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT DISTINCT
        o.OperatorID,
        o.OperatorCode,
        o.FullName,
        o.Mobile,
        o.LicenseNo,
        o.LicenseExpiry,
        o.Status,
        o.PhotoPath,
        o.IsActive
    FROM dbo.mst_Operator o
    LEFT JOIN dbo.trn_ProjectUserAllocation a
        ON a.OperatorID = o.OperatorID
       AND ISNULL(a.IsActive,1)=1
       AND a.EndDate IS NULL
    LEFT JOIN dbo.mst_Project p
        ON p.ProjectID = a.ProjectID
    WHERE ISNULL(o.IsActive,1)=1
      AND (
            ISNULL(@ScopeDivisionID,0)=0
            OR p.DivisionID = @ScopeDivisionID
          )
    ORDER BY o.FullName;
END

ELSE IF(@Event='GetCurrentAllocations')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    ;WITH ActiveMount AS
    (
        SELECT
            am.MountCode,
            am.VirtualAssetID,
            am.ChassisAssetID,
            am.UpperAssetID
        FROM dbo.trn_AssetMounting am
        WHERE ISNULL(am.IsActive,1)=1
          AND am.UnmountedOn IS NULL
    ),
    AssetOperationalMap AS
    (
        SELECT
            a.AssetID AS BaseAssetID,
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN am.VirtualAssetID IS NOT NULL AND a.CategoryID IN (42,43) THEN am.VirtualAssetID
                ELSE a.AssetID
            END AS EffectiveAssetID
        FROM dbo.mst_Asset a
        LEFT JOIN ActiveMount am
            ON am.ChassisAssetID = a.AssetID
            OR am.UpperAssetID = a.AssetID
        WHERE ISNULL(a.IsActive,1)=1
    ),
    EffectiveAssets AS
    (
        SELECT
            ea.AssetID,
            ea.AssetCode,
            ea.AssetName,
            ea.DivisionID
        FROM dbo.mst_Asset ea
        WHERE ISNULL(ea.IsActive,1)=1
          AND (
                ISNULL(@ScopeDivisionID,0)=0
                OR ea.DivisionID = @ScopeDivisionID
              )
          AND (
                ISNULL(ea.IsVirtualAsset,0)=1
                OR NOT EXISTS
                (
                    SELECT 1
                    FROM ActiveMount amx
                    WHERE amx.ChassisAssetID = ea.AssetID
                       OR amx.UpperAssetID = ea.AssetID
                )
              )
    ),
    AllocationBase AS
    (
        SELECT
            pm.ID AS AllocationID,
            map.EffectiveAssetID AS AssetID,
            pm.ProjectID,
            pm.StartDate,
            pm.EndDate,
            pm.ProposedEndDate,
            pm.Remarks,
            ISNULL(pm.IsActive,1) AS IsActive,
            pm.CreatedAt AS CreatedOn,
            pm.ModifiedBy,
            COALESCE(pm.ModifiedOn, pm.UpdatedAt) AS ModifiedOn,
            ROW_NUMBER() OVER
            (
                PARTITION BY map.EffectiveAssetID, pm.ProjectID
                ORDER BY pm.ID DESC
            ) AS rn
        FROM dbo.trn_ProjectMachineAllocation pm
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = pm.AssetID
        WHERE ISNULL(pm.IsActive,1)=1
          AND pm.EndDate IS NULL
    ),
    CurrentAlloc AS
    (
        SELECT *
        FROM AllocationBase
        WHERE rn = 1
    ),
    OperatorAgg AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            moa.ProjectID,
            STRING_AGG(CAST(moa.OperatorID AS VARCHAR(20)), ',') AS OperatorID,
            STRING_AGG(o.FullName, ', ') AS OperatorName
        FROM dbo.trn_MachineOperatorAllocation moa
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = moa.AssetID
        LEFT JOIN dbo.mst_Operator o
            ON o.OperatorID = moa.OperatorID
        WHERE moa.EndDate IS NULL
          AND ISNULL(moa.IsActive,1)=1
        GROUP BY
            map.EffectiveAssetID,
            moa.ProjectID
    )
    SELECT
        ca.AllocationID,
        ea.AssetID,
        ea.AssetCode,
        ea.AssetName,
        ca.ProjectID,
        p.ProjectName,
        ops.OperatorID,
        NULL AS OperatorCode,
        ops.OperatorName,
        ca.StartDate,
        ca.EndDate,
        ca.ProposedEndDate,
        ca.Remarks,
        ca.IsActive,
        NULL AS CreatedBy,
        ca.CreatedOn,
        ca.ModifiedBy,
        ca.ModifiedOn
    FROM CurrentAlloc ca
	INNER JOIN EffectiveAssets ea
		ON ea.AssetID = ca.AssetID
	LEFT JOIN dbo.mst_Project p
		ON p.ProjectID = ca.ProjectID
	LEFT JOIN OperatorAgg ops
		ON ops.AssetID = ca.AssetID
	   AND ISNULL(ops.ProjectID,0) = ISNULL(ca.ProjectID,0)
	ORDER BY ea.AssetName, ca.AllocationID DESC;
END



ELSE IF(@Event='EndAllocation')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can End Allocation.',16,1);
		RETURN;
	END
    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF ISNULL(@EndedBy_Alloc,0)=0
        RAISERROR('ModifiedBy is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.trn_ProjectMachineAllocation
        WHERE AssetID=@AssetID
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
    )
        RAISERROR('No active allocation found for this asset.',16,1);

    UPDATE dbo.trn_ProjectMachineAllocation
    SET
        EndDate = GETDATE(),
        IsActive = 0,
        ModifiedBy = @EndedBy_Alloc,
        ModifiedOn = GETDATE(),
        UpdatedAt = GETDATE()
    WHERE AssetID = @AssetID
      AND ISNULL(IsActive,1)=1
      AND EndDate IS NULL;

    UPDATE dbo.trn_MachineOperatorAllocation
    SET
        EndDate = GETDATE(),
        ModifiedBy = @EndedBy_Alloc,
        UpdatedAt = GETDATE()
    WHERE AssetID = @AssetID
      AND EndDate IS NULL;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Allocation ended successfully.' AS Msg,
        @AssetID AS AssetID;
END

ELSE IF(@Event='UpdateAllocation')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
    BEGIN
        RAISERROR('Only Admin can Update Allocation.',16,1);
        RETURN;
    END

    DECLARE @NewProjectMachineAllocationID INT;
    DECLARE @EffectiveAssetID INT;

    SELECT
        @EffectiveAssetID =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID, @AssetID);

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF ISNULL(@ProjectID_Alloc,0)=0
        RAISERROR('ProjectID is required.',16,1);

    IF @StartDate_Alloc IS NULL
        RAISERROR('StartDate is required.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset
            WHERE AssetID = @AssetID
              AND DivisionID = @ScopeDivisionID
              AND ISNULL(IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can update allocation only for your assigned division assets.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project
            WHERE ProjectID = @ProjectID_Alloc
              AND DivisionID = @ScopeDivisionID
              AND ISNULL(IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can allocate assets only to your assigned division projects.',16,1);
            RETURN;
        END
    END

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Asset
        WHERE AssetID=@AssetID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset not found.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Project
        WHERE ProjectID=@ProjectID_Alloc
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Project not found.',16,1);

    IF ISNULL(@OperatorID_Alloc,0)<>0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Operator
            WHERE OperatorID=@OperatorID_Alloc
              AND ISNULL(IsActive,1)=1
        )
            RAISERROR('Operator not found.',16,1);
    END

    UPDATE dbo.trn_ProjectMachineAllocation
    SET
        EndDate = GETDATE(),
        IsActive = 0,
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE(),
        UpdatedAt = GETDATE()
    WHERE AssetID = @AssetID
      AND ISNULL(IsActive,1)=1
      AND EndDate IS NULL;

    INSERT INTO dbo.trn_ProjectMachineAllocation
    (
        AssetID,
        ProjectID,
        StartDate,
        EndDate,
        ProposedEndDate,
        Remarks,
        ModifiedBy,
        CreatedAt,
        UpdatedAt,
        IsActive,
        ModifiedOn
    )
    VALUES
    (
        @AssetID,
        @ProjectID_Alloc,
        @StartDate_Alloc,
        NULL,
        @ProposedEndDate_Alloc,
        @Remarks_Alloc,
        @AuthEmployeeID,
        GETDATE(),
        NULL,
        1,
        NULL
    );

    SET @NewProjectMachineAllocationID = SCOPE_IDENTITY();

    UPDATE dbo.mst_Asset
    SET ProjectID = @ProjectID_Alloc
    WHERE AssetID = @AssetID;

    UPDATE dbo.trn_MachineOperatorAllocation
    SET
        EndDate = GETDATE(),
        ModifiedBy = @AuthEmployeeID,
        UpdatedAt = GETDATE(),
        IsActive = 0
    WHERE AssetID = @AssetID
      AND EndDate IS NULL
      AND ISNULL(IsActive,1)=1;

    IF ISNULL(@OperatorID_Alloc, 0) <> 0
    BEGIN
        UPDATE dbo.trn_ProjectUserAllocation
        SET
            EndDate = GETDATE(),
            IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE(),
            UpdatedAt = GETDATE()
        WHERE OperatorID = @OperatorID_Alloc
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
          AND ISNULL(ProjectID,0) <> ISNULL(@ProjectID_Alloc,0);

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.trn_ProjectUserAllocation
            WHERE OperatorID = @OperatorID_Alloc
              AND ProjectID = @ProjectID_Alloc
              AND ISNULL(IsActive,1)=1
              AND EndDate IS NULL
        )
        BEGIN
            INSERT INTO dbo.trn_ProjectUserAllocation
            (
                OperatorID,
                ProjectID,
                StartDate,
                EndDate,
                ProposedEndDate,
                Remarks,
                ModifiedBy,
                CreatedAt,
                UpdatedAt,
                IsActive,
                ModifiedOn
            )
            VALUES
            (
                @OperatorID_Alloc,
                @ProjectID_Alloc,
                @StartDate_Alloc,
                NULL,
                @ProposedEndDate_Alloc,
                'User Allocation',
                @AuthEmployeeID,
                GETDATE(),
                NULL,
                1,
                NULL
            );
        END

        INSERT INTO dbo.trn_MachineOperatorAllocation
        (
            AssetID,
            OperatorID,
            ProjectID,
            StartDate,
            EndDate,
            ProposedEndDate,
            Remarks,
            ModifiedBy,
            CreatedAt,
            UpdatedAt,
            IsActive
        )
        VALUES
        (
            @AssetID,
            @OperatorID_Alloc,
            @ProjectID_Alloc,
            @StartDate_Alloc,
            NULL,
            @ProposedEndDate_Alloc,
            @Remarks_Alloc,
            @AuthEmployeeID,
            GETDATE(),
            NULL,
            1
        );
    END

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Allocation updated successfully.' AS Msg,
        @NewProjectMachineAllocationID AS AllocationID;
END


ELSE IF(@Event='ReleaseSelectedAssets')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
    BEGIN
        RAISERROR('Only Admin can Release Selected Assets.',16,1);
        RETURN;
    END

    --IF ISNULL(@ProjectID_Alloc,0)=0
    --    RAISERROR('ProjectID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(ISNULL(@AssetIDs,''))),'') = ''
        RAISERROR('AssetIDs are required.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID_Alloc
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can release allocations only from your assigned division projects.',16,1);
            RETURN;
        END
    END

    DECLARE @RequestedAssets TABLE
    (
        AssetID INT
    );

    INSERT INTO @RequestedAssets(AssetID)
    SELECT DISTINCT TRY_CAST(value AS INT)
    FROM STRING_SPLIT(@AssetIDs, ',')
    WHERE TRY_CAST(value AS INT) IS NOT NULL;

    IF NOT EXISTS (SELECT 1 FROM @RequestedAssets)
        RAISERROR('No valid AssetIDs were provided.',16,1);

    ;WITH ActiveMount AS
    (
        SELECT
            am.VirtualAssetID,
            am.ChassisAssetID,
            am.UpperAssetID
        FROM dbo.trn_AssetMounting am
        WHERE ISNULL(am.IsActive,1)=1
          AND am.UnmountedOn IS NULL
    ),
    EffectiveReleaseAssets AS
    (
        SELECT DISTINCT
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM ActiveMount am
                    WHERE am.ChassisAssetID = a.AssetID
                       OR am.UpperAssetID = a.AssetID
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM ActiveMount am
                    WHERE am.ChassisAssetID = a.AssetID
                       OR am.UpperAssetID = a.AssetID
                )
                ELSE a.AssetID
            END AS EffectiveAssetID
        FROM @RequestedAssets ra
        INNER JOIN dbo.mst_Asset a
            ON a.AssetID = ra.AssetID
        WHERE ISNULL(a.IsActive,1)=1
    )
    UPDATE pma
    SET
        EndDate = GETDATE(),
        IsActive = 0,
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE(),
        UpdatedAt = GETDATE()
    FROM dbo.trn_ProjectMachineAllocation pma
    INNER JOIN EffectiveReleaseAssets era
        ON era.EffectiveAssetID = pma.AssetID
    WHERE pma.ProjectID = @ProjectID_Alloc
      AND ISNULL(pma.IsActive,1)=1
      AND pma.EndDate IS NULL;

    UPDATE moa
    SET
        EndDate = GETDATE(),
        IsActive = 0,
        ModifiedBy = @AuthEmployeeID,
        UpdatedAt = GETDATE()
    FROM dbo.trn_MachineOperatorAllocation moa
    INNER JOIN EffectiveReleaseAssets era
        ON era.EffectiveAssetID = moa.AssetID
    WHERE moa.ProjectID = @ProjectID_Alloc
      AND ISNULL(moa.IsActive,1)=1
      AND moa.EndDate IS NULL;

    UPDATE a
    SET ProjectID = NULL
    FROM dbo.mst_Asset a
    INNER JOIN EffectiveReleaseAssets era
        ON era.EffectiveAssetID = a.AssetID
    WHERE ISNULL(a.IsActive,1)=1;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Selected assets released successfully.' AS Msg;
END



-- Allocation Asset and Project End

-- Daily Log Start

ELSE IF(@Event='GetOperatorsDropdown')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT DISTINCT
        op.OperatorID,
        op.FullName
    FROM dbo.mst_Operator op
    LEFT JOIN dbo.trn_ProjectUserAllocation a
        ON a.OperatorID = op.OperatorID
       AND ISNULL(a.IsActive,1)=1
       AND a.EndDate IS NULL
    LEFT JOIN dbo.mst_Project p
        ON p.ProjectID = a.ProjectID
    WHERE op.IsActive = 1
      AND (
            ISNULL(@ScopeDivisionID,0)=0
            OR p.DivisionID = @ScopeDivisionID
          )
    ORDER BY op.FullName;
END


ELSE IF(@Event='GetData')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    ;WITH ActiveMount AS
    (
        SELECT
            am.MountCode,
            am.VirtualAssetID,
            am.ChassisAssetID,
            am.UpperAssetID
        FROM dbo.trn_AssetMounting am
        WHERE ISNULL(am.IsActive,1)=1
          AND am.UnmountedOn IS NULL
    ),
    AssetOperationalMap AS
    (
        SELECT
            a.AssetID AS BaseAssetID,
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN am.VirtualAssetID IS NOT NULL AND a.CategoryID IN (42,43) THEN am.VirtualAssetID
                ELSE a.AssetID
            END AS EffectiveAssetID
        FROM dbo.mst_Asset a
        LEFT JOIN ActiveMount am
            ON am.ChassisAssetID = a.AssetID
            OR am.UpperAssetID = a.AssetID
        WHERE ISNULL(a.IsActive,1)=1
    ),
    EffectiveAssets AS
    (
        SELECT
            ea.AssetID,
            ea.AssetCode,
            ea.AssetName,
            ea.RegistrationNo,
            ea.OwnershipType,
            ea.PhotoPath,
            ea.AssetTypeID,
            ea.CategoryID,
            ea.RecordingUnit,
            ea.DivisionID,
            ea.IsVirtualAsset
        FROM dbo.mst_Asset ea
        WHERE ISNULL(ea.IsActive,1)=1
          AND (
                ISNULL(@ScopeDivisionID,0)=0
                OR ea.DivisionID = @ScopeDivisionID
              )
          AND (
                ISNULL(ea.IsVirtualAsset,0)=1
                OR NOT EXISTS
                (
                    SELECT 1
                    FROM ActiveMount amx
                    WHERE amx.ChassisAssetID = ea.AssetID
                       OR amx.UpperAssetID = ea.AssetID
                )
              )
    ),
    LatestSubmitted AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            dl.LogID,
            dl.LogDate,
            dl.EndHMR,
            dl.EndKMR,
            dl.SubmittedOn,
            ROW_NUMBER() OVER
            (
                PARTITION BY map.EffectiveAssetID
                ORDER BY dl.LogDate DESC, dl.LogID DESC
            ) AS rn
        FROM dbo.trn_DailyLog dl
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = dl.AssetID
        WHERE dl.SubmissionStatus IN ('Submitted','Locked')
    ),
    OpenWorking AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            dl.LogID,
            dl.EndHMR,
            dl.EndKMR,
            dl.StartDateTime
        FROM dbo.trn_DailyLog dl
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = dl.AssetID
        WHERE dl.LogType='Working'
          AND dl.SubmissionStatus='Draft'
    ),
    OpenInterrupt AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            dl.LogID,
            dl.LogType,
            dl.EndHMR,
            dl.EndKMR,
            dl.StartDateTime
        FROM dbo.trn_DailyLog dl
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = dl.AssetID
        WHERE dl.LogType IN ('Breakdown','UnderMaintenance')
          AND dl.SubmissionStatus='Draft'
    ),
    ActiveProjectMachine AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            pma.ProjectID,
            ROW_NUMBER() OVER
            (
                PARTITION BY map.EffectiveAssetID
                ORDER BY pma.ID DESC
            ) AS rn
        FROM dbo.trn_ProjectMachineAllocation pma
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = pma.AssetID
        INNER JOIN dbo.mst_Project mp
            ON mp.ProjectID = pma.ProjectID
           AND ISNULL(mp.IsActive,1)=1
        WHERE ISNULL(pma.IsActive,1)=1
          AND pma.EndDate IS NULL
          AND (
                ISNULL(@ScopeDivisionID,0)=0
                OR mp.DivisionID = @ScopeDivisionID
              )
    ),
    ActiveMachineOperators AS
    (
        SELECT
            map.EffectiveAssetID AS AssetID,
            moa.ProjectID,
            MIN(moa.OperatorID) AS OperatorID,
            STRING_AGG(o.FullName, ', ') AS OperatorName
        FROM dbo.trn_MachineOperatorAllocation moa
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = moa.AssetID
        LEFT JOIN dbo.mst_Operator o
            ON o.OperatorID = moa.OperatorID
        WHERE ISNULL(moa.IsActive,1)=1
          AND moa.EndDate IS NULL
          AND (@OperatorID = 0 OR moa.OperatorID = @OperatorID)
        GROUP BY
            map.EffectiveAssetID,
            moa.ProjectID
    ),
    AssetAlloc AS
    (
        SELECT
            pm.AssetID,
            pm.ProjectID,
            amo.OperatorID,
            amo.OperatorName
        FROM ActiveProjectMachine pm
        LEFT JOIN ActiveMachineOperators amo
            ON amo.AssetID = pm.AssetID
           AND ISNULL(amo.ProjectID,0) = ISNULL(pm.ProjectID,0)
        WHERE pm.rn = 1
          AND (
                @OperatorID = 0
                OR amo.OperatorID = @OperatorID
              )
    )
    SELECT
        a.AssetID,
        a.AssetName,
        a.RegistrationNo,
        a.OwnershipType,
        a.PhotoPath,
        at.TypeName AS AssetType,
        ac.CategoryName AS AssetCategory,
        p.ProjectName,
        p.Location,
        ISNULL(p.ProjectName,'') + CASE WHEN ISNULL(p.Location,'')='' THEN '' ELSE ' (' + p.Location + ')' END AS SiteLabel,
        ISNULL(al.OperatorName,'') AS OperatorName,

        ow.LogID AS WorkingLogID,
        oi.LogID AS InterruptionLogID,
        ISNULL(oi.LogID, ow.LogID) AS OpenLogID,

        ISNULL(COALESCE(oi.EndHMR, ow.EndHMR, ls.EndHMR),0) AS ReadingHMR,
        ISNULL(COALESCE(oi.EndKMR, ow.EndKMR, ls.EndKMR),0) AS ReadingKMR,

        ISNULL(
            COALESCE(
                oi.EndHMR, ow.EndHMR, ls.EndHMR,
                oi.EndKMR, ow.EndKMR, ls.EndKMR
            ),0
        ) AS Reading,

        a.RecordingUnit AS RecordingUnit,

        CAST(
            ISNULL(
                COALESCE(
                    oi.EndHMR, ow.EndHMR, ls.EndHMR,
                    oi.EndKMR, ow.EndKMR, ls.EndKMR
                ),0
            ) AS VARCHAR(50)
        ) + ' ' + ISNULL(a.RecordingUnit,'') AS ReadingLabel,

        CASE
            WHEN oi.StartDateTime IS NOT NULL THEN FORMAT(oi.StartDateTime,'dd-MMM h:mm tt')
            WHEN ow.StartDateTime IS NOT NULL THEN FORMAT(ow.StartDateTime,'dd-MMM h:mm tt')
            WHEN ls.LogDate IS NULL THEN 'No Log'
            WHEN ls.LogDate=@Today THEN 'Today ' + FORMAT(ls.SubmittedOn,'hh:mm tt')
            WHEN ls.LogDate=DATEADD(DAY,-1,@Today) THEN 'Yesterday ' + FORMAT(ls.SubmittedOn,'hh:mm tt')
            ELSE FORMAT(ls.LogDate,'dd-MMM')
        END AS ReadingSince,

        CASE
            WHEN oi.LogType='Breakdown' THEN 'Breakdown'
            WHEN oi.LogType='UnderMaintenance' THEN 'Under Maintenance'
            WHEN ow.LogID IS NOT NULL THEN 'Working'
            ELSE 'Idle'
        END AS CurrentStatus,

        CASE WHEN ow.LogID IS NULL AND oi.LogID IS NULL THEN 1 ELSE 0 END AS ShowAddLogBtn,
        CASE WHEN ow.LogID IS NOT NULL OR oi.LogID IS NOT NULL THEN 1 ELSE 0 END AS ShowEndLogBtn

    FROM EffectiveAssets a
    JOIN dbo.mst_AssetType at
        ON at.AssetTypeID = a.AssetTypeID
    JOIN dbo.mst_AssetCategory ac
        ON ac.CategoryID = a.CategoryID
    INNER JOIN AssetAlloc al
        ON al.AssetID = a.AssetID
    LEFT JOIN dbo.mst_Project p
        ON p.ProjectID = al.ProjectID
    LEFT JOIN LatestSubmitted ls
        ON ls.AssetID = a.AssetID
       AND ls.rn = 1
    LEFT JOIN OpenWorking ow
        ON ow.AssetID = a.AssetID
    LEFT JOIN OpenInterrupt oi
        ON oi.AssetID = a.AssetID
    ORDER BY a.AssetName;
END



ELSE IF(@Event='GetAddLogAssetDetails')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF ISNULL(@ScopeDivisionID,0) <> 0
	BEGIN
		IF NOT EXISTS (
			SELECT 1
			FROM dbo.mst_Asset a
			WHERE a.AssetID = @AssetID
			  AND a.DivisionID = @ScopeDivisionID
			  AND ISNULL(a.IsActive,1)=1
		)
		BEGIN
			RAISERROR('You can view only your assigned division asset details.',16,1);
			RETURN;
		END
	END
    DECLARE @AssetRecordingUnit_Details VARCHAR(50);
    DECLARE @UsesHMR_Details BIT = 0;
    DECLARE @UsesKMR_Details BIT = 0;

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    SELECT TOP 1
        @ProjectID = ProjectID,
        @AllocationID = ID
    FROM dbo.trn_ProjectMachineAllocation
    WHERE AssetID=@AssetID
      AND ISNULL(IsActive,1)=1
      AND EndDate IS NULL
    ORDER BY ID DESC;

    SELECT TOP 1
        @OperatorID = OperatorID
    FROM dbo.trn_MachineOperatorAllocation
    WHERE AssetID=@AssetID
      AND ISNULL(ProjectID,0)=ISNULL(@ProjectID,0)
      AND EndDate IS NULL
    ORDER BY ID DESC;

    SELECT TOP 1
        @AssetRecordingUnit_Details = LTRIM(RTRIM(ISNULL(NULLIF(a.RecordingUnit,''), ISNULL(NULLIF(cd.RecordingUnit,''), 'Hours'))))
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = a.CategoryID
       AND ISNULL(cd.IsActive, 1) = 1
    WHERE a.AssetID = @AssetID;

    SET @AssetRecordingUnit_Details = LTRIM(RTRIM(ISNULL(@AssetRecordingUnit_Details,'Hours')));

    SET @UsesHMR_Details = CASE
        WHEN @AssetRecordingUnit_Details IN ('Hours','Hour','HMR','Both','KMR/HMR') THEN 1
        ELSE 0
    END;

    SET @UsesKMR_Details = CASE
        WHEN @AssetRecordingUnit_Details IN ('Kilometer','Kilometers','KM','KMR','Both','KMR/HMR') THEN 1
        ELSE 0
    END;

    SELECT TOP 1
        a.AssetID,
        a.AssetName,
        ISNULL(cd.RecordingUnit, a.RecordingUnit) AS RecordingUnit,
        ISNULL(cd.OutputName, '') AS OutputName,
        ISNULL(cd.OutputUnit, a.OutputUnit) AS OutputUnit,
        ISNULL(cd.OutputRequired, 0) AS OutputRequired,
        ISNULL(@ProjectID,0) AS ProjectID,
        ISNULL(@AllocationID,0) AS AllocationID,
        ISNULL(@OperatorID,0) AS DefaultOperatorID,
        CASE
            WHEN @UsesKMR_Details = 1 AND @UsesHMR_Details = 0
                THEN COALESCE(kmr.LastReading, 0)
            WHEN @UsesHMR_Details = 1 AND @UsesKMR_Details = 0
                THEN COALESCE(hmr.LastReading, 0)
            WHEN @UsesHMR_Details = 1 AND @UsesKMR_Details = 1
                THEN COALESCE(hmr.LastReading, kmr.LastReading, 0)
            ELSE
                COALESCE(hmr.LastReading, kmr.LastReading, 0)
        END AS StartReading,
        GETDATE() AS StartDateTime,
        NULL AS EndDateTime,
        NULL AS EndReading,
        NULL AS OutputQty,
        '' AS WorkingRemarks,
        COALESCE(hmr.StartHMR, 0) AS StartHMR,
        COALESCE(hmr.EndHMR, 0) AS EndHMR,
        COALESCE(kmr.StartKMR, 0) AS StartKMR,
        COALESCE(kmr.EndKMR, 0) AS EndKMR
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = a.CategoryID
       AND ISNULL(cd.IsActive, 1) = 1
    OUTER APPLY
    (
        SELECT TOP 1
            StartHMR,
            EndHMR,
            COALESCE(NULLIF(EndHMR,0), NULLIF(StartHMR,0)) AS LastReading
        FROM dbo.trn_DailyLog
        WHERE AssetID = a.AssetID
          AND (ISNULL(StartHMR,0) > 0 OR ISNULL(EndHMR,0) > 0)
        ORDER BY LogDate DESC, LogID DESC
    ) hmr
    OUTER APPLY
    (
        SELECT TOP 1
            StartKMR,
            EndKMR,
            COALESCE(NULLIF(EndKMR,0), NULLIF(StartKMR,0)) AS LastReading
        FROM dbo.trn_DailyLog
        WHERE AssetID = a.AssetID
          AND (ISNULL(StartKMR,0) > 0 OR ISNULL(EndKMR,0) > 0)
        ORDER BY LogDate DESC, LogID DESC
    ) kmr
    WHERE a.AssetID = @AssetID;
END


ELSE IF(@Event='GetProjectList')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END
	
    SELECT
        p.ProjectID,
        p.ProjectCode,
        p.ProjectName,
        p.Location,
        p.ClientName,
        p.DivisionID,
        d.DivisionName,
        p.Status,
        p.StartDate,
        p.EndDate,
        p.CreatedBy,
        p.CreatedOn,
        p.ModifiedBy,
        p.ModifiedOn
    FROM dbo.mst_Project p
    LEFT JOIN dbo.mst_Division d
        ON d.DivisionID = p.DivisionID
    WHERE ISNULL(p.IsActive,1) = 1
      AND (
            ISNULL(@ScopeDivisionID,0) = 0
            OR p.DivisionID = @ScopeDivisionID
          )
    ORDER BY p.ProjectName;
END

ELSE IF(@Event='EditProject')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
    BEGIN
        RAISERROR('Only Admin can modify project master.',16,1);
        RETURN;
    END

    DECLARE @ModifiedBy_Project INT;
    SET @ModifiedBy_Project = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT);

    IF ISNULL(@DivisionID, 0) = 0
    BEGIN
        SELECT 0 AS Status, 'Division is required.' AS Msg;
        RETURN;
    END;

    IF ISNULL(@ProjectID,0)=0
        RAISERROR('ProjectID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@ProjectCode)),'')=''
        RAISERROR('ProjectCode is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@ProjectName)),'')=''
        RAISERROR('ProjectName is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@Location)),'')=''
        RAISERROR('Location is required.',16,1);

    IF ISNULL(@ModifiedBy_Project,0)=0
        RAISERROR('ModifiedBy is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Project
        WHERE ProjectID=@ProjectID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Project not found.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_Project
        WHERE ProjectCode=@ProjectCode
          AND ProjectID<>@ProjectID
    )
        RAISERROR('ProjectCode already exists.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_Project
        WHERE LTRIM(RTRIM(ProjectName)) = LTRIM(RTRIM(@ProjectName))
          AND LTRIM(RTRIM(Location)) = LTRIM(RTRIM(@Location))
          AND ProjectID<>@ProjectID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Project already exists.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project
            WHERE ProjectID=@ProjectID
              AND DivisionID=@ScopeDivisionID
              AND ISNULL(IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can update only your assigned division projects.',16,1);
            RETURN;
        END;

        IF ISNULL(@DivisionID,0) <> @ScopeDivisionID
        BEGIN
            RAISERROR('You cannot change project division outside your assigned division.',16,1);
            RETURN;
        END
    END

    BEGIN TRAN;

    BEGIN TRY
        UPDATE dbo.mst_Project
        SET
            ProjectCode = @ProjectCode,
            ProjectName = @ProjectName,
            Location = @Location,
            DivisionID = @DivisionID,
            ClientName = @ClientName,
            Status = ISNULL(NULLIF(@Status_Project,''),'Active'),
            StartDate = @StartDate_Project,
            EndDate = @EndDate_Project,
            ModifiedBy = @ModifiedBy_Project,
            ModifiedOn = GETDATE()
        WHERE ProjectID = @ProjectID;

        DELETE FROM dbo.trn_ProjectSite
        WHERE ProjectID = @ProjectID;

        IF ISNULL(LTRIM(RTRIM(@SitesJson)),'') <> ''
        BEGIN
            INSERT INTO dbo.trn_ProjectSite
            (
                ProjectID,
                SiteName,
                SiteHeadUserRoleID,
                Region,
                Address,
                GSTState,
                SiteLocation,
                Pincode,
                IsCompanyYard,
                IsActive,
                CreatedBy,
                CreatedOn,
                ModifiedBy,
                ModifiedOn
            )
            SELECT
                @ProjectID,
                SiteName,
                SiteHeadUserRoleID,
                Region,
                Address,
                GSTState,
                SiteLocation,
                Pincode,
                ISNULL(IsCompanyYard,0),
                ISNULL(IsActive,1),
                @ModifiedBy_Project,
                GETDATE(),
                NULL,
                NULL
            FROM OPENJSON(@SitesJson)
            WITH
            (
                SiteName NVARCHAR(200) '$.SiteName',
                SiteHeadUserRoleID INT '$.SiteHeadUserRoleID',
                Region NVARCHAR(100) '$.Region',
                Address NVARCHAR(500) '$.Address',
                GSTState NVARCHAR(100) '$.GSTState',
                SiteLocation NVARCHAR(200) '$.SiteLocation',
                Pincode NVARCHAR(20) '$.Pincode',
                IsCompanyYard BIT '$.IsCompanyYard',
                IsActive BIT '$.IsActive'
            );
        END

        DELETE FROM dbo.trn_ProjectEmployeeLink
        WHERE ProjectID = @ProjectID;

        IF ISNULL(LTRIM(RTRIM(@EmployeesJson)),'') <> ''
        BEGIN
            INSERT INTO dbo.trn_ProjectEmployeeLink
            (
                ProjectID,
                UserRoleID,
                IsActive,
                CreatedBy,
                CreatedOn,
                ModifiedBy,
                ModifiedOn
            )
            SELECT
                @ProjectID,
                UserRoleID,
                ISNULL(IsActive,1),
                @ModifiedBy_Project,
                GETDATE(),
                NULL,
                NULL
            FROM OPENJSON(@EmployeesJson)
            WITH
            (
                UserRoleID INT '$.UserRoleID',
                IsActive BIT '$.IsActive'
            );
        END

        COMMIT TRAN;

        UPDATE dbo.tbl_Log
        SET Status='Success'
        WHERE Id=@LastId;

        SELECT
            'Success' AS Status,
            'Project updated successfully.' AS Msg,
            @ProjectID AS ProjectID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH
END

ELSE IF(@Event='DeleteProject')
BEGIN
	IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can modify project master.',16,1);
		RETURN;
	END
    DECLARE @ModifiedBy_ProjectDelete INT;
    SET @ModifiedBy_ProjectDelete = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ModifiedBy') AS INT);

    IF ISNULL(@ProjectID,0)=0
        RAISERROR('ProjectID is required.',16,1);

    IF ISNULL(@ModifiedBy_ProjectDelete,0)=0
        RAISERROR('ModifiedBy is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Project
        WHERE ProjectID=@ProjectID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Project not found.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_ProjectMachineAllocation
        WHERE ProjectID=@ProjectID
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
    )
        OR EXISTS (
        SELECT 1
        FROM dbo.trn_ProjectUserAllocation
        WHERE ProjectID=@ProjectID
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
    )
        OR EXISTS (
        SELECT 1
        FROM dbo.trn_MachineOperatorAllocation
        WHERE ProjectID=@ProjectID
          AND EndDate IS NULL
    )
        RAISERROR('Cannot delete project because active allocations exist.',16,1);

		IF ISNULL(@ScopeDivisionID,0) <> 0
		BEGIN
			IF NOT EXISTS (
				SELECT 1
				FROM dbo.mst_Project
				WHERE ProjectID=@ProjectID
				  AND DivisionID=@ScopeDivisionID
				  AND ISNULL(IsActive,1)=1
			)
			BEGIN
				RAISERROR('You can delete only your assigned division projects.',16,1);
				RETURN;
			END
		END

    UPDATE dbo.mst_Project
    SET
        IsActive = 0,
        ModifiedBy = @ModifiedBy_ProjectDelete,
        ModifiedOn = GETDATE()
    WHERE ProjectID = @ProjectID;

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Project deleted successfully.' AS Msg,
        @ProjectID AS ProjectID;
END


ELSE IF(@Event='AddProject')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
    BEGIN
        RAISERROR('Only Admin can modify project master.',16,1);
        RETURN;
    END

    IF ISNULL(@ScopeDivisionID,0) <> 0
       AND ISNULL(@DivisionID,0) <> @ScopeDivisionID
    BEGIN
        RAISERROR('You can add projects only for your assigned division.',16,1);
        RETURN;
    END

    DECLARE @NextProjectNo INT;
    DECLARE @SavedProjectID INT;

    IF ISNULL(@DivisionID, 0) = 0
    BEGIN
        SELECT 0 AS Status, 'Division is required.' AS Msg;
        RETURN;
    END;

    IF ISNULL(LTRIM(RTRIM(@ProjectName)),'')=''
        RAISERROR('ProjectName is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@Location)),'')=''
        RAISERROR('Location is required.',16,1);

    IF ISNULL(@CreatedBy_Project,0)=0
        RAISERROR('CreatedBy is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@ProjectCode)),'')=''
    BEGIN
        SELECT @NextProjectNo = ISNULL(MAX(ProjectID),0) + 1
        FROM dbo.mst_Project;

        SET @NewProjectCode = 'P' + RIGHT('000' + CAST(@NextProjectNo AS VARCHAR(10)), 3);
    END
    ELSE
    BEGIN
        SET @NewProjectCode = @ProjectCode;
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_Project
        WHERE ProjectCode=@NewProjectCode
    )
        RAISERROR('ProjectCode already exists.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_Project
        WHERE LTRIM(RTRIM(ProjectName)) = LTRIM(RTRIM(@ProjectName))
          AND LTRIM(RTRIM(Location)) = LTRIM(RTRIM(@Location))
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Project already exists.',16,1);

    BEGIN TRAN;

    BEGIN TRY
        INSERT INTO dbo.mst_Project
        (
            ProjectCode,
            ProjectName,
            DivisionID,
            Location,
            ClientName,
            Status,
            StartDate,
            EndDate,
            IsActive,
            CreatedBy,
            CreatedOn,
            ModifiedBy,
            ModifiedOn
        )
        VALUES
        (
            @NewProjectCode,
            @ProjectName,
            @DivisionID,
            @Location,
            @ClientName,
            ISNULL(NULLIF(@Status_Project,''),'Active'),
            @StartDate_Project,
            @EndDate_Project,
            1,
            @CreatedBy_Project,
            GETDATE(),
            NULL,
            NULL
        );

        SET @SavedProjectID = CAST(SCOPE_IDENTITY() AS INT);

        IF ISNULL(LTRIM(RTRIM(@SitesJson)),'') <> ''
        BEGIN
            INSERT INTO dbo.trn_ProjectSite
            (
                ProjectID,
                SiteName,
                SiteHeadUserRoleID,
                Region,
                Address,
                GSTState,
                SiteLocation,
                Pincode,
                IsCompanyYard,
                IsActive,
                CreatedBy,
                CreatedOn,
                ModifiedBy,
                ModifiedOn
            )
            SELECT
                @SavedProjectID,
                SiteName,
                SiteHeadUserRoleID,
                Region,
                Address,
                GSTState,
                SiteLocation,
                SitePincode,
                ISNULL(IsCompanyYard,0),
                ISNULL(IsActive,1),
                @CreatedBy_Project,
                GETDATE(),
                NULL,
                NULL
            FROM OPENJSON(@SitesJson)
            WITH
            (
                SiteName NVARCHAR(200) '$.SiteName',
                SiteHeadUserRoleID INT '$.SiteHeadUserRoleID',
                Region NVARCHAR(100) '$.Region',
                Address NVARCHAR(500) '$.Address',
                GSTState NVARCHAR(100) '$.GSTState',
                SiteLocation NVARCHAR(200) '$.SiteLocation',
                SitePincode NVARCHAR(20) '$.SitePincode',
                IsCompanyYard BIT '$.IsCompanyYard',
                IsActive BIT '$.IsActive'
            );
        END

        IF ISNULL(LTRIM(RTRIM(@EmployeesJson)),'') <> ''
        BEGIN
            INSERT INTO dbo.trn_ProjectEmployeeLink
            (
                ProjectID,
                UserRoleID,
                IsActive,
                CreatedBy,
                CreatedOn,
                ModifiedBy,
                ModifiedOn
            )
            SELECT
                @SavedProjectID,
                UserRoleID,
                ISNULL(IsActive,1),
                @CreatedBy_Project,
                GETDATE(),
                NULL,
                NULL
            FROM OPENJSON(@EmployeesJson)
            WITH
            (
                UserRoleID INT '$.UserRoleID',
                IsActive BIT '$.IsActive'
            );
        END

        COMMIT TRAN;

        UPDATE dbo.tbl_Log
        SET Status='Success'
        WHERE Id=@LastId;

        SELECT
            'Success' AS Status,
            'Project added successfully.' AS Msg,
            @SavedProjectID AS ProjectID,
            @NewProjectCode AS ProjectCode;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH
END

ELSE IF(@Event='GetProjectDetails')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        -- Header Details
        (
            SELECT
                p.ProjectID,
                p.ProjectCode,
                p.ProjectName,
                p.Location,
                p.ClientName,
                p.DivisionID,
                d.DivisionName,
                p.Status,
                p.StartDate,
                p.EndDate,
                p.IsActive
            FROM dbo.mst_Project p
            LEFT JOIN dbo.mst_Division d
                ON d.DivisionID = p.DivisionID
            WHERE p.ProjectID = @ProjectID
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS HeaderJson,

        -- Associated Sites
        (
            SELECT
                ps.ProjectSiteID,
                ps.ProjectID,
                ps.SiteName,
                ps.SiteHeadUserRoleID,
                ur.Username AS SiteHead,
                ps.Region,
                ps.Address,
                ps.GSTState,
                ps.SiteLocation,
                ps.Pincode,
                ps.IsCompanyYard,
                ps.IsActive
            FROM dbo.trn_ProjectSite ps
            LEFT JOIN dbo.mst_UserRole ur
                ON ur.UserRoleID = ps.SiteHeadUserRoleID
            WHERE ps.ProjectID = @ProjectID
            FOR JSON PATH
        ) AS SitesJson,

        -- Linked Employees
        (
            SELECT
                el.ProjectEmployeeLinkID,
                el.ProjectID,
                el.UserRoleID,
                ur.EmployeeID,
                ur.Username,
                r.RoleName,
                el.IsActive
            FROM dbo.trn_ProjectEmployeeLink el
            LEFT JOIN dbo.mst_UserRole ur
                ON ur.UserRoleID = el.UserRoleID
            LEFT JOIN dbo.mst_Role r
                ON r.RoleID = ur.RoleID
            WHERE el.ProjectID = @ProjectID
            FOR JSON PATH
        ) AS EmployeesJson;
END




ELSE IF(@Event='SaveAddLog')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @LastEndKMR DECIMAL(18,2);
    SELECT
        @EffectiveAssetID =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID, @AssetID);

    SET @SelectedOperatorID = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'OperatorID') AS INT);

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF @StartDateTime IS NULL
        RAISERROR('StartDateTime is required.',16,1);

    SELECT TOP 1
        @ProjectID = ProjectID,
        @AllocationID = ID
    FROM dbo.trn_ProjectMachineAllocation
    WHERE AssetID=@AssetID
      AND ISNULL(IsActive,1)=1
      AND EndDate IS NULL
    ORDER BY ID DESC;

    SELECT TOP 1
        @OperatorID = OperatorID
    FROM dbo.trn_MachineOperatorAllocation
    WHERE AssetID=@AssetID
      AND ISNULL(ProjectID,0)=ISNULL(@ProjectID,0)
      AND EndDate IS NULL
    ORDER BY ID DESC;

    IF ISNULL(@SelectedOperatorID,0) > 0
        SET @OperatorID = @SelectedOperatorID;

    IF ISNULL(@ProjectID,0)=0
        RAISERROR('ProjectID not found for this asset.',16,1);

    IF ISNULL(@OperatorID,0)=0
        RAISERROR('OperatorID is required.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can add logs only for your assigned division assets.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can add logs only for your assigned division projects.',16,1);
            RETURN;
        END
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Operator'
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Operator o
            WHERE o.OperatorID = @OperatorID
              AND o.EmployeeID = @AuthEmployeeID
              AND ISNULL(o.IsActive,1)=1
        )
        BEGIN
            RAISERROR('Operator can add logs only for their own operator profile.',16,1);
            RETURN;
        END
    END

    SELECT
        @ProductionUnit = a.OutputUnit,
        @AssetRecordingUnit = ISNULL(NULLIF(cd.RecordingUnit,''), ISNULL(NULLIF(a.RecordingUnit,''), 'Hours'))
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = a.CategoryID
       AND ISNULL(cd.IsActive,1)=1
    WHERE a.AssetID=@AssetID;

    SET @AssetRecordingUnit = LTRIM(RTRIM(ISNULL(@AssetRecordingUnit,'Hours')));

    SET @UsesHMR = CASE
        WHEN @AssetRecordingUnit IN ('Hours','Hour','HMR','Both','KMR/HMR') THEN 1
        ELSE 0
    END;

    SET @UsesKMR = CASE
        WHEN @AssetRecordingUnit IN ('Kilometer','Kilometers','KM','KMR','Both','KMR/HMR') THEN 1
        ELSE 0
    END;

    IF @UsesHMR = 1 AND @StartHMR IS NULL
        RAISERROR('StartHMR is required.',16,1);

    IF @UsesKMR = 1 AND @StartKMR IS NULL
        RAISERROR('StartKMR is required.',16,1);

    IF ISNULL(@MachineStatus,'')=''
        RAISERROR('MachineStatus is required.',16,1);

    SET @LogDate = CAST(@StartDateTime AS DATE);

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_DailyLog
        WHERE AssetID=@AssetID
          AND SubmissionStatus='Draft'
    )
        RAISERROR('One draft log is already open for this asset.',16,1);

    SELECT TOP 1
        @LastEndHMR = EndHMR,
        @LastEndKMR = EndKMR
    FROM dbo.trn_DailyLog
    WHERE AssetID=@AssetID
    ORDER BY LogDate DESC, LogID DESC;

    IF @UsesHMR = 1
       AND @LastEndHMR IS NOT NULL
       AND @StartHMR < @LastEndHMR
        RAISERROR('StartHMR cannot be less than last EndHMR.',16,1);

    IF @UsesKMR = 1
       AND @LastEndKMR IS NOT NULL
       AND @StartKMR < @LastEndKMR
        RAISERROR('StartKMR cannot be less than last EndKMR.',16,1);

    IF CONVERT(DATE, ISNULL(@EndDateTime,'1900-01-01')) = '1900-01-01'
        SET @EndDateTime = NULL;

    IF ISNULL(@EndHMR,0)=0
        SET @EndHMR = NULL;

    IF ISNULL(@EndKMR,0)=0
        SET @EndKMR = NULL;

    IF @UsesHMR = 1
       AND @EndHMR IS NOT NULL
       AND @EndHMR < @StartHMR
        RAISERROR('EndHMR cannot be less than StartHMR.',16,1);

    IF @UsesKMR = 1
       AND @EndKMR IS NOT NULL
       AND @EndKMR < @StartKMR
        RAISERROR('EndKMR cannot be less than StartKMR.',16,1);

    IF @EndDateTime IS NOT NULL AND @EndDateTime < @StartDateTime
        RAISERROR('EndDateTime cannot be less than StartDateTime.',16,1);

    INSERT INTO dbo.trn_DailyLog
    (
        LogDate,
        ProjectID,
        ShiftID,
        AssetID,
        AllocationID,
        OperatorID,
        StartDateTime,
        StartHMR,
        StartKMR,
        EndDateTime,
        EndHMR,
        EndKMR,
        MachineStatus,
        ProductionQty,
        ProductionUnit,
        IdleHours,
        BreakdownReason,
        SubmissionStatus,
        Remarks,
        CreatedBy,
        CreatedOn,
        BreakdownHours,
        IsPhotoMandatory,
        IsPhotoUploaded,
        EndReadingPhoto,
        RemarkPhoto,
        LogType,
        LogVerificationStatus,
        LogVerificationDate
    )
    VALUES
    (
        @LogDate,
        @ProjectID,
        NULL,
        @AssetID,
        @AllocationID,
        @OperatorID,
        @StartDateTime,
        ISNULL(@StartHMR, 0),
        ISNULL(@StartKMR, 0),
        @EndDateTime,
        ISNULL(@EndHMR, ISNULL(@StartHMR, 0)),
        ISNULL(@EndKMR, ISNULL(@StartKMR, 0)),
        @MachineStatus,
        ISNULL(@OutputQty, 0),
        ISNULL(NULLIF(@ProductionUnit,''), ''),
        ISNULL(@IdleHours, 0),
        ISNULL(@BreakdownReason, ''),
        'Draft',
        @WorkingRemarks,
        @AuthEmployeeID,
        GETDATE(),
        ISNULL(@BreakdownHours, 0),
        0,
        CASE
            WHEN NULLIF(@EndReadingPhoto, '') IS NOT NULL OR NULLIF(@RemarkPhoto, '') IS NOT NULL THEN 1
            ELSE 0
        END,
        NULLIF(@EndReadingPhoto, ''),
        NULLIF(@RemarkPhoto, ''),
        'Working',
        ISNULL(@LogVerificationStatus, 0),
        CASE WHEN ISNULL(@LogVerificationStatus, 0) = 1 THEN @LogVerificationDate ELSE NULL END
    );

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Add log saved successfully.' AS Msg,
        SCOPE_IDENTITY() AS LogID;
END

ELSE IF(@Event='GetEndLogDetails')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    IF ISNULL(@LogID,0)=0
        RAISERROR('LogID is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.trn_DailyLog
        WHERE LogID=@LogID
          AND SubmissionStatus='Draft'
    )
        RAISERROR('Draft log not found.',16,1);

    SELECT
        dl.LogID,
        dl.LogDate,
        dl.ProjectID,
        dl.ShiftID,
        dl.AssetID,
        dl.AllocationID,
        dl.OperatorID,
        a.AssetName,
        a.RecordingUnit,
        a.OutputUnit,
        dl.StartHMR,
        dl.EndHMR,
        dl.StartKMR,
        dl.EndKMR,
        dl.MachineStatus,
        dl.ProductionQty,
        dl.ProductionUnit,
        dl.IdleHours,
        dl.BreakdownHours,
        dl.BreakdownReason,
        dl.Remarks,
        dl.RemarkPhoto,
        dl.EndReadingPhoto,
        dl.SubmissionStatus,
        dl.StartDateTime,
        dl.EndDateTime
    FROM dbo.trn_DailyLog dl
    JOIN dbo.mst_Asset a
        ON a.AssetID = dl.AssetID
    WHERE dl.LogID=@LogID
      AND dl.SubmissionStatus='Draft';
END


ELSE IF(@Event='GetMachineStatusList')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
    SELECT 'Working' AS MachineStatus
    UNION ALL SELECT 'Idle'
    UNION ALL SELECT 'Breakdown'
    UNION ALL SELECT 'UnderMaintenance';
END

ELSE IF(@Event = 'GetOperatorDashboard')
BEGIN
    IF @OperatorID IS NULL
    BEGIN
        RAISERROR('OperatorID is required for GetOperatorDashboard', 16, 1);
        RETURN;
    END

    ;WITH Last4Days AS
    (
        SELECT CAST(GETDATE() AS DATE) AS WorkDate
        UNION ALL SELECT DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
        UNION ALL SELECT DATEADD(DAY, -2, CAST(GETDATE() AS DATE))
        UNION ALL SELECT DATEADD(DAY, -3, CAST(GETDATE() AS DATE))
    )
    SELECT
        D.WorkDate,
        DATENAME(WEEKDAY, D.WorkDate)   AS DayName,
        DAY(D.WorkDate)                 AS DayNo,
        ISNULL((
            SELECT CAST(SUM(DATEDIFF(MINUTE, StartDateTime, EndDateTime)) / 60.0 AS DECIMAL(10,1))
            FROM dbo.trn_DailyLog
            WHERE OperatorID = @OperatorID
              AND CAST(LogDate AS DATE) = D.WorkDate
        ), 0) AS WorkHours,

        ISNULL((
            SELECT SUM(F.FuelQty)
            FROM dbo.trn_FuelLog F
            WHERE CAST(F.FuelDateTime AS DATE) = D.WorkDate
              AND F.AssetID IN (
                  SELECT AssetID
                  FROM dbo.trn_DailyLog
                  WHERE OperatorID = @OperatorID
                    AND CAST(LogDate AS DATE) = D.WorkDate
              )
        ), 0) AS FuelUsed,

        CASE
            WHEN EXISTS (
                SELECT 1 FROM dbo.trn_DailyLog
                WHERE OperatorID = @OperatorID
                  AND CAST(LogDate AS DATE) = D.WorkDate
            ) THEN 'Completed'
            ELSE 'Not Logged'
        END AS Status,
        T.TotalHours,     
        T.TotalLogs,      
        T.TodayFuelUsed,    
        T.IssuesReported  

    FROM Last4Days D
    CROSS JOIN
    (
        SELECT
            CAST(ISNULL(SUM(DATEDIFF(MINUTE, StartDateTime, EndDateTime)), 0) / 60.0 AS DECIMAL(10,1)) AS TotalHours,
            COUNT(LogID) AS TotalLogs,
            ISNULL((
                SELECT SUM(FL.FuelQty)
                FROM dbo.trn_FuelLog FL
                WHERE CAST(FL.FuelDateTime AS DATE) = CAST(GETDATE() AS DATE)
                  AND FL.AssetID IN (
                      SELECT AssetID
                      FROM dbo.trn_DailyLog
                      WHERE OperatorID = @OperatorID
                        AND CAST(LogDate AS DATE) = CAST(GETDATE() AS DATE)
                  )
            ), 0) AS TodayFuelUsed,
            SUM(CASE
                WHEN MachineStatus IN ('Breakdown', 'Under Maintenance') THEN 1
                ELSE 0
            END) AS IssuesReported

        FROM dbo.trn_DailyLog
        WHERE OperatorID = @OperatorID
          AND CAST(LogDate AS DATE) = CAST(GETDATE() AS DATE)
    ) T
    ORDER BY D.WorkDate DESC;

END
ELSE IF(@Event='SaveEndLog')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
    DECLARE @ProductionUnit_End VARCHAR(100);
    DECLARE @RecordingUnit_End VARCHAR(50);
    DECLARE @StartKMR_End DECIMAL(18,2);

    IF ISNULL(@LogID,0)=0
        RAISERROR('LogID is required.',16,1);

    IF @EndDateTime IS NULL
        RAISERROR('EndDateTime is required.',16,1);

    IF ISNULL(@MachineStatus,'')=''
        RAISERROR('MachineStatus is required.',16,1);

    IF ISNULL(@SubmittedBy,0)=0
        RAISERROR('SubmittedBy is required.',16,1);

    SELECT
        @StartHMR_End = StartHMR,
        @StartKMR_End = StartKMR,
        @StartDateTime = StartDateTime,
        @AssetID = AssetID,
        @ProductionUnit_End = ProductionUnit
    FROM dbo.trn_DailyLog
    WHERE LogID=@LogID
      AND SubmissionStatus='Draft';

    IF @StartHMR_End IS NULL AND @StartKMR_End IS NULL
        RAISERROR('Draft log not found.',16,1);

    SELECT
        @RecordingUnit_End = LTRIM(RTRIM(ISNULL(NULLIF(cd.RecordingUnit,''), ISNULL(NULLIF(a.RecordingUnit,''), 'Hours'))))
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = a.CategoryID
       AND ISNULL(cd.IsActive,1)=1
    WHERE a.AssetID=@AssetID;

    SET @RecordingUnit_End = LTRIM(RTRIM(ISNULL(@RecordingUnit_End,'Hours')));

    SET @UsesHMR_End = CASE
        WHEN @RecordingUnit_End IN ('Hours','Hour','HMR','Both') THEN 1
        ELSE 0
    END;

    SET @UsesKMR_End = CASE
        WHEN @RecordingUnit_End IN ('Kilometer','Kilometers','KM','KMR','Both') THEN 1
        ELSE 0
    END;

    IF @UsesHMR_End = 1 AND @EndHMR IS NULL
        RAISERROR('EndHMR is required.',16,1);

    IF @UsesKMR_End = 1 AND @EndKMR IS NULL
        RAISERROR('EndKMR is required.',16,1);

    IF @UsesHMR_End = 1
       AND @StartHMR_End IS NOT NULL
       AND @EndHMR < @StartHMR_End
        RAISERROR('EndHMR cannot be less than StartHMR.',16,1);

    IF @UsesKMR_End = 1
       AND @StartKMR_End IS NOT NULL
       AND @EndKMR < @StartKMR_End
        RAISERROR('EndKMR cannot be less than StartKMR.',16,1);

    IF @EndDateTime < @StartDateTime
        RAISERROR('EndDateTime cannot be less than StartDateTime.',16,1);

    UPDATE dbo.trn_DailyLog
    SET
        EndHMR = ISNULL(@EndHMR, 0),
        EndKMR = ISNULL(@EndKMR, 0),
        MachineStatus = @MachineStatus,
        ProductionQty = ISNULL(@ProductionQty,0),
        ProductionUnit = ISNULL(@ProductionUnit_End, ProductionUnit),
        IdleHours = ISNULL(@IdleHours,0),
        BreakdownHours = ISNULL(@BreakdownHours,0),
        BreakdownReason = ISNULL(@BreakdownReason,''),
        Remarks = @WorkingRemarks,
        EndReadingPhoto = ISNULL(NULLIF(@EndReadingPhoto,''), EndReadingPhoto),
        RemarkPhoto = ISNULL(NULLIF(@RemarkPhoto,''), RemarkPhoto),
        IsPhotoUploaded = CASE
            WHEN NULLIF(@EndReadingPhoto,'') IS NOT NULL
              OR NULLIF(@RemarkPhoto,'') IS NOT NULL
              OR ISNULL(IsPhotoUploaded,0)=1
            THEN 1 ELSE 0
        END,
        SubmissionStatus = 'Submitted',
        SubmittedBy = @SubmittedBy,
        SubmittedOn = GETDATE(),
        EndDateTime = @EndDateTime,
        ModifiedBy = @SubmittedBy,
        ModifiedOn = GETDATE(),
        LogVerificationStatus = ISNULL(@LogVerificationStatus, 0),
        LogVerificationDate = CASE
            WHEN ISNULL(@LogVerificationStatus, 0) = 1 THEN @LogVerificationDate
            ELSE NULL
        END
    WHERE LogID=@LogID
      AND SubmissionStatus='Draft';

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'End log submitted successfully.' AS Msg,
        @LogID AS LogID;
END


ELSE IF(@Event='SaveAddLogBulk')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    DECLARE @LogJson NVARCHAR(MAX);
    DECLARE @CreatedByBulk INT;
    DECLARE @BulkSessionID UNIQUEIDENTIFIER = NEWID();

    SET @CreatedByBulk = @AuthEmployeeID;
    SET @LogJson = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'logjson');

    IF ISNULL(@AuthEmployeeID,0)=0
        RAISERROR('CreatedBy is required.',16,1);

    IF ISNULL(@LogJson,'')=''
        RAISERROR('logjson is required.',16,1);

    DECLARE @BulkItems TABLE
    (
        RowNo INT,
        LogID INT NULL,
        AssetID INT,
        OperatorID INT,
        ProjectID INT,
        StartDateTime DATETIME,
        StartHMR DECIMAL(18,2) NULL,
        StartKMR DECIMAL(18,2) NULL,
        EndDateTime DATETIME NULL,
        EndHMR DECIMAL(18,2) NULL,
        EndKMR DECIMAL(18,2) NULL,
        MachineStatus VARCHAR(100),
        OutputQty DECIMAL(18,2),
        ProductionUnit VARCHAR(100),
        FuelQty DECIMAL(18,2),
        BreakdownReason VARCHAR(1000),
        WorkingRemarks VARCHAR(2000),
        BreakdownHours DECIMAL(18,2),
        IdleHours DECIMAL(18,2),
        LunchDinnerHours DECIMAL(18,2),
        EndReadingPhoto VARCHAR(500),
        RemarkPhoto VARCHAR(500),
        CreatedBy INT,
        LogVerificationStatus BIT,
        LogVerificationDate DATETIME2(0)
    );

    INSERT INTO @BulkItems
    (
        RowNo,
        LogID,
        AssetID,
        OperatorID,
        ProjectID,
        StartDateTime,
        StartHMR,
        StartKMR,
        EndDateTime,
        EndHMR,
        EndKMR,
        MachineStatus,
        OutputQty,
        ProductionUnit,
        FuelQty,
        BreakdownReason,
        WorkingRemarks,
        BreakdownHours,
        IdleHours,
        LunchDinnerHours,
        EndReadingPhoto,
        RemarkPhoto,
        CreatedBy,
        LogVerificationStatus,
        LogVerificationDate
    )
    SELECT
        RowNo,
        LogID,
        AssetID,
        OperatorID,
        ProjectID,
        StartDateTime,
        StartHMR,
        StartKMR,
        EndDateTime,
        EndHMR,
        EndKMR,
        MachineStatus,
        OutputQty,
        ProductionUnit,
        FuelQty,
        BreakdownReason,
        WorkingRemarks,
        BreakdownHours,
        IdleHours,
        LunchDinnerHours,
        EndReadingPhoto,
        RemarkPhoto,
        ISNULL(CreatedBy, @CreatedByBulk),
        ISNULL(LogVerificationStatus, 0),
        LogVerificationDate
    FROM OPENJSON(@LogJson, '$.items')
    WITH
    (
        RowNo INT '$.RowNo',
        LogID INT '$.LogID',
        AssetID INT '$.AssetID',
        OperatorID INT '$.OperatorID',
        ProjectID INT '$.ProjectID',
        StartDateTime DATETIME '$.StartDateTime',
        StartHMR DECIMAL(18,2) '$.StartHMR',
        StartKMR DECIMAL(18,2) '$.StartKMR',
        EndDateTime DATETIME '$.EndDateTime',
        EndHMR DECIMAL(18,2) '$.EndHMR',
        EndKMR DECIMAL(18,2) '$.EndKMR',
        MachineStatus VARCHAR(100) '$.MachineStatus',
        OutputQty DECIMAL(18,2) '$.OutputQty',
        ProductionUnit VARCHAR(100) '$.ProductionUnit',
        FuelQty DECIMAL(18,2) '$.FuelQty',
        BreakdownReason VARCHAR(1000) '$.BreakdownReason',
        WorkingRemarks VARCHAR(2000) '$.WorkingRemarks',
        BreakdownHours DECIMAL(18,2) '$.BreakdownHours',
        IdleHours DECIMAL(18,2) '$.IdleHours',
        LunchDinnerHours DECIMAL(18,2) '$.LunchDinnerHours',
        EndReadingPhoto VARCHAR(500) '$.EndReadingPhoto',
        RemarkPhoto VARCHAR(500) '$.RemarkPhoto',
        CreatedBy INT '$.CreatedBy',
        LogVerificationStatus BIT '$.LogVerificationStatus',
        LogVerificationDate DATETIME2(0) '$.LogVerificationDate'
    );

    IF NOT EXISTS (SELECT 1 FROM @BulkItems)
        RAISERROR('No bulk log rows found in logjson.',16,1);

    IF EXISTS (SELECT 1 FROM @BulkItems WHERE ISNULL(AssetID,0)=0)
        RAISERROR('AssetID is required in one or more rows.',16,1);

    IF EXISTS (SELECT 1 FROM @BulkItems WHERE StartDateTime IS NULL)
        RAISERROR('StartDateTime is required in one or more rows.',16,1);

    IF EXISTS (SELECT 1 FROM @BulkItems WHERE EndDateTime IS NULL)
        RAISERROR('EndDateTime is required in one or more rows for bulk complete log save.',16,1);

    IF EXISTS (SELECT 1 FROM @BulkItems WHERE ISNULL(OperatorID,0)=0)
        RAISERROR('OperatorID is required in one or more rows.',16,1);

    IF EXISTS (SELECT 1 FROM @BulkItems WHERE ISNULL(CreatedBy,0)=0)
        RAISERROR('CreatedBy is required in one or more rows.',16,1);

    IF EXISTS (SELECT 1 FROM @BulkItems WHERE ISNULL(MachineStatus,'')='')
        RAISERROR('MachineStatus is required in one or more rows.',16,1);

    IF EXISTS (
        SELECT 1
        FROM @BulkItems
        WHERE EndDateTime IS NOT NULL
          AND EndDateTime < StartDateTime
    )
        RAISERROR('EndDateTime cannot be less than StartDateTime in one or more rows.',16,1);

    ;WITH ResolvedRows AS
    (
        SELECT
            b.RowNo,
            b.LogID,
            b.AssetID,
            b.OperatorID,
            b.ProjectID,
            b.StartDateTime,
            b.StartHMR,
            b.StartKMR,
            b.EndDateTime,
            b.EndHMR,
            b.EndKMR,
            b.MachineStatus,
            b.OutputQty,
            b.ProductionUnit,
            b.FuelQty,
            b.BreakdownReason,
            b.WorkingRemarks,
            b.BreakdownHours,
            b.IdleHours,
            b.LunchDinnerHours,
            b.EndReadingPhoto,
            b.RemarkPhoto,
            b.CreatedBy,
            b.LogVerificationStatus,
            b.LogVerificationDate,
            CAST(b.StartDateTime AS DATE) AS LogDate,
            ISNULL(NULLIF(b.ProductionUnit,''), ISNULL(NULLIF(ma.OutputUnit,''), '')) AS FinalProductionUnit,
            ISNULL(NULLIF(ma.FuelType,''), '') AS FinalFuelType,
            LTRIM(RTRIM(ISNULL(NULLIF(cd.RecordingUnit,''), ISNULL(NULLIF(ma.RecordingUnit,''), 'Hours')))) AS FinalRecordingUnit,
            CASE
                WHEN LTRIM(RTRIM(ISNULL(NULLIF(cd.RecordingUnit,''), ISNULL(NULLIF(ma.RecordingUnit,''), 'Hours'))))
                     IN ('Hours','Hour','HMR','Both','KMR/HMR')
                THEN 1 ELSE 0
            END AS UsesHMR,
            CASE
                WHEN LTRIM(RTRIM(ISNULL(NULLIF(cd.RecordingUnit,''), ISNULL(NULLIF(ma.RecordingUnit,''), 'Hours'))))
                     IN ('Kilometer','Kilometers','KM','KMR','Both','KMR/HMR')
                THEN 1 ELSE 0
            END AS UsesKMR,
            ISNULL(NULLIF(b.ProjectID,0), pma.ProjectID) AS FinalProjectID,
            ISNULL(NULLIF(b.OperatorID,0), moa.OperatorID) AS FinalOperatorID
        FROM @BulkItems b
        LEFT JOIN dbo.mst_Asset ma
            ON ma.AssetID = b.AssetID
        LEFT JOIN dbo.mst_AssetCategoryDefaults cd
            ON cd.CategoryID = ma.CategoryID
           AND ISNULL(cd.IsActive,1)=1
        OUTER APPLY
        (
            SELECT TOP 1 ProjectID, ID
            FROM dbo.trn_ProjectMachineAllocation
            WHERE AssetID = b.AssetID
              AND ISNULL(IsActive,1)=1
              AND EndDate IS NULL
            ORDER BY ID DESC
        ) pma
        OUTER APPLY
        (
            SELECT TOP 1 OperatorID
            FROM dbo.trn_MachineOperatorAllocation
            WHERE AssetID = b.AssetID
              AND ISNULL(ProjectID,0)=ISNULL(ISNULL(NULLIF(b.ProjectID,0), pma.ProjectID),0)
              AND EndDate IS NULL
            ORDER BY ID DESC
        ) moa
    )
    SELECT *
    INTO #ResolvedBulkLogs
    FROM ResolvedRows;

	IF EXISTS (SELECT 1 FROM #ResolvedBulkLogs WHERE ISNULL(FinalProjectID,0)=0)
    RAISERROR('ProjectID not found for one or more assets.',16,1);

	IF EXISTS (SELECT 1 FROM #ResolvedBulkLogs WHERE ISNULL(FinalOperatorID,0)=0)
		RAISERROR('OperatorID is required in one or more rows.',16,1);

	IF ISNULL(@ScopeDivisionID,0) <> 0
	BEGIN
		IF EXISTS (
			SELECT 1
			FROM #ResolvedBulkLogs r
			INNER JOIN dbo.mst_Asset a
				ON a.AssetID = r.AssetID
			WHERE ISNULL(a.DivisionID,0) <> @ScopeDivisionID
		)
			RAISERROR('One or more assets are outside your assigned division.',16,1);

		IF EXISTS (
			SELECT 1
			FROM #ResolvedBulkLogs r
			INNER JOIN dbo.mst_Project p
				ON p.ProjectID = r.FinalProjectID
			WHERE ISNULL(p.DivisionID,0) <> @ScopeDivisionID
		)
			RAISERROR('One or more projects are outside your assigned division.',16,1);
	END

IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Operator'
BEGIN
    IF EXISTS (
        SELECT 1
        FROM #ResolvedBulkLogs r
        LEFT JOIN dbo.mst_Operator o
            ON o.OperatorID = r.FinalOperatorID
        WHERE ISNULL(o.EmployeeID,0) <> @AuthEmployeeID
    )
        RAISERROR('Operator can save bulk logs only for their own operator profile.',16,1);
END
    IF EXISTS (SELECT 1 FROM #ResolvedBulkLogs WHERE ISNULL(FinalProjectID,0)=0)
        RAISERROR('ProjectID not found for one or more assets.',16,1);

    IF EXISTS (SELECT 1 FROM #ResolvedBulkLogs WHERE ISNULL(FinalOperatorID,0)=0)
        RAISERROR('OperatorID is required in one or more rows.',16,1);

    IF EXISTS (
        SELECT 1
        FROM #ResolvedBulkLogs
        WHERE UsesHMR = 1
          AND StartHMR IS NULL
    )
        RAISERROR('StartHMR is required in one or more rows.',16,1);

    IF EXISTS (
        SELECT 1
        FROM #ResolvedBulkLogs
        WHERE UsesKMR = 1
          AND StartKMR IS NULL
    )
        RAISERROR('StartKMR is required in one or more rows.',16,1);

    IF EXISTS (
        SELECT 1
        FROM #ResolvedBulkLogs
        WHERE UsesHMR = 1
          AND EndHMR IS NULL
    )
        RAISERROR('EndHMR is required in one or more rows.',16,1);

    IF EXISTS (
        SELECT 1
        FROM #ResolvedBulkLogs
        WHERE UsesKMR = 1
          AND EndKMR IS NULL
    )
        RAISERROR('EndKMR is required in one or more rows.',16,1);

    IF EXISTS (
        SELECT 1
        FROM #ResolvedBulkLogs
        WHERE UsesHMR = 1
          AND EndHMR < StartHMR
    )
        RAISERROR('EndHMR cannot be less than StartHMR in one or more rows.',16,1);

    IF EXISTS (
        SELECT 1
        FROM #ResolvedBulkLogs
        WHERE UsesKMR = 1
          AND EndKMR < StartKMR
    )
        RAISERROR('EndKMR cannot be less than StartKMR in one or more rows.',16,1);

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO dbo.trn_DailyLog
        (
            LogDate,
            ProjectID,
            ShiftID,
            AssetID,
            OperatorID,
            StartDateTime,
            StartHMR,
            StartKMR,
            EndDateTime,
            EndHMR,
            EndKMR,
            MachineStatus,
            ProductionQty,
            ProductionUnit,
            IdleHours,
            LunchDinnerHours,
            BreakdownReason,
            SubmissionStatus,
            SubmittedBy,
            SubmittedOn,
            Remarks,
            CreatedBy,
            CreatedOn,
            ModifiedBy,
            ModifiedOn,
            SessionID,
            BreakdownHours,
            IsPhotoMandatory,
            IsPhotoUploaded,
            EndReadingPhoto,
            RemarkPhoto,
            LogType,
            LogVerificationStatus,
            LogVerificationDate
        )
        SELECT
            LogDate,
            FinalProjectID,
            NULL,
            AssetID,
            FinalOperatorID,
            StartDateTime,
            CASE WHEN UsesHMR = 1 THEN StartHMR ELSE 0 END,
            CASE WHEN UsesKMR = 1 THEN StartKMR ELSE 0 END,
            EndDateTime,
            CASE WHEN UsesHMR = 1 THEN EndHMR ELSE 0 END,
            CASE WHEN UsesKMR = 1 THEN EndKMR ELSE 0 END,
            MachineStatus,
            ISNULL(OutputQty, 0),
            FinalProductionUnit,
            ISNULL(IdleHours, 0),
            ISNULL(LunchDinnerHours, 0),
            ISNULL(BreakdownReason, ''),
            'Submitted',
            CreatedBy,
            GETDATE(),
            WorkingRemarks,
            CreatedBy,
            GETDATE(),
            CreatedBy,
            GETDATE(),
            CAST(@BulkSessionID AS VARCHAR(50)),
            ISNULL(BreakdownHours, 0),
            0,
            CASE
                WHEN NULLIF(EndReadingPhoto, '') IS NOT NULL OR NULLIF(RemarkPhoto, '') IS NOT NULL THEN 1
                ELSE 0
            END,
            NULLIF(EndReadingPhoto, ''),
            NULLIF(RemarkPhoto, ''),
            'Working',
            ISNULL(LogVerificationStatus, 0),
            CASE WHEN ISNULL(LogVerificationStatus, 0) = 1 THEN LogVerificationDate ELSE NULL END
        FROM #ResolvedBulkLogs
        WHERE ISNULL(LogID,0)=0
        ORDER BY RowNo;

        INSERT INTO dbo.trn_FuelLog
        (
            AssetID,
            FuelDateTime,
            FuelQty,
            ReadingAtFueling,
            FuelType,
            Remarks,
            PhotoPath,
            CreatedBy,
            CreatedOn,
            ModifiedBy,
            ModifiedOn,
            IsActive
        )
        SELECT
            AssetID,
            ISNULL(EndDateTime, StartDateTime),
            ISNULL(FuelQty, 0),
            CASE
                WHEN UsesKMR = 1 AND UsesHMR = 0 THEN EndKMR
                ELSE EndHMR
            END,
            FinalFuelType,
            ISNULL(WorkingRemarks, ''),
            NULL,
            CreatedBy,
            GETDATE(),
            NULL,
            NULL,
            1
        FROM #ResolvedBulkLogs
        WHERE ISNULL(LogID,0)=0
          AND ISNULL(FuelQty,0) > 0;

        UPDATE dl
        SET
            dl.ProjectID = r.FinalProjectID,
            dl.OperatorID = r.FinalOperatorID,
            dl.StartDateTime = r.StartDateTime,
            dl.StartHMR = CASE WHEN r.UsesHMR = 1 THEN r.StartHMR ELSE 0 END,
            dl.StartKMR = CASE WHEN r.UsesKMR = 1 THEN r.StartKMR ELSE 0 END,
            dl.EndDateTime = r.EndDateTime,
            dl.EndHMR = CASE WHEN r.UsesHMR = 1 THEN r.EndHMR ELSE 0 END,
            dl.EndKMR = CASE WHEN r.UsesKMR = 1 THEN r.EndKMR ELSE 0 END,
            dl.MachineStatus = r.MachineStatus,
            dl.ProductionQty = ISNULL(r.OutputQty, 0),
            dl.ProductionUnit = r.FinalProductionUnit,
            dl.IdleHours = ISNULL(r.IdleHours, 0),
            dl.LunchDinnerHours = ISNULL(r.LunchDinnerHours, 0),
            dl.BreakdownReason = ISNULL(r.BreakdownReason, ''),
            dl.Remarks = r.WorkingRemarks,
            dl.BreakdownHours = ISNULL(r.BreakdownHours, 0),
            dl.IsPhotoUploaded = CASE
                WHEN NULLIF(r.EndReadingPhoto, '') IS NOT NULL OR NULLIF(r.RemarkPhoto, '') IS NOT NULL THEN 1
                ELSE dl.IsPhotoUploaded
            END,
            dl.EndReadingPhoto = NULLIF(r.EndReadingPhoto, ''),
            dl.RemarkPhoto = NULLIF(r.RemarkPhoto, ''),
            dl.ModifiedBy = r.CreatedBy,
            dl.ModifiedOn = GETDATE(),
            dl.LogVerificationStatus = ISNULL(r.LogVerificationStatus, 0),
            dl.LogVerificationDate = CASE
                WHEN ISNULL(r.LogVerificationStatus, 0) = 1 THEN r.LogVerificationDate
                ELSE NULL
            END
        FROM dbo.trn_DailyLog dl
        INNER JOIN #ResolvedBulkLogs r
            ON dl.LogID = r.LogID
        WHERE ISNULL(r.LogID,0) > 0;

        UPDATE dbo.tbl_Log
        SET Status='Success'
        WHERE Id=@LastId;

        COMMIT TRAN;

        SELECT
            'Success' AS Status,
            CONCAT(COUNT(1), ' bulk log(s) saved successfully.') AS Msg
        FROM #ResolvedBulkLogs;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE @BulkErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@BulkErrorMsg,16,1);
    END CATCH
END

ELSE IF(@Event='DeleteLog')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName, ''))) NOT IN ('Admin', 'Site In Charge')
	BEGIN
		RAISERROR('Only Admin or Site In Charge can delete logs.', 16, 1);
		RETURN;
	END

    IF ISNULL(@LogID,0)=0
        RAISERROR('LogID is required.',16,1);

    SELECT
        @AssetID = AssetID
    FROM dbo.trn_DailyLog
    WHERE LogID = @LogID;

    IF ISNULL(@AssetID,0)=0
        RAISERROR('Log not found.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can delete only your assigned division logs.',16,1);
            RETURN;
        END
    END

    DELETE FROM dbo.trn_DailyLog
    WHERE LogID = @LogID;

    IF @@ROWCOUNT = 0
        RAISERROR('DeleteLog failed.',16,1);

    SELECT
        'Success' AS Status,
        'Log deleted successfully.' AS Msg,
        @LogID AS LogID;
END

ELSE IF(@Event='GetAssetQuickViewHeader')
 BEGIN
	 IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END
		IF ISNULL(@ScopeDivisionID,0) <> 0
		BEGIN
			IF NOT EXISTS (
				SELECT 1
				FROM dbo.mst_Asset a
				WHERE a.AssetID = @AssetID
				  AND a.DivisionID = @ScopeDivisionID
				  AND ISNULL(a.IsActive,1)=1
			)
			BEGIN
				RAISERROR('You can view only your assigned division asset details.',16,1);
				RETURN;
			END
		END

     IF ISNULL(@AssetID,0)=0
         RAISERROR('AssetID is required.',16,1);

     ;WITH ActiveProject AS
     (
         SELECT TOP 1 ProjectID
         FROM dbo.trn_ProjectMachineAllocation
         WHERE AssetID = @AssetID
           AND ISNULL(IsActive,1)=1
           AND EndDate IS NULL
         ORDER BY ID DESC
     ),
     LatestSubmitted AS
     (
         SELECT dl.AssetID, dl.EndHMR,
                ROW_NUMBER() OVER (PARTITION BY dl.AssetID ORDER BY dl.LogDate DESC, dl.LogID DESC) AS rn
         FROM dbo.trn_DailyLog dl
         WHERE dl.SubmissionStatus IN ('Submitted','Locked')
     ),
     OpenWorking AS
     (
         SELECT AssetID, LogID FROM dbo.trn_DailyLog
         WHERE LogType='Working' AND SubmissionStatus='Draft'
     ),
     OpenInterrupt AS
     (
         SELECT AssetID, LogID, LogType FROM dbo.trn_DailyLog
         WHERE LogType IN ('Breakdown','UnderMaintenance') AND SubmissionStatus='Draft'
     )
     SELECT
         a.AssetID,
         a.AssetName,
         a.RegistrationNo,
         a.Make,
         a.ModelName,
         a.PhotoPath,
         a.RecordingUnit,
         a.OutputUnit,
         at.TypeName AS AssetTypeName,
         p.ProjectCode,
         p.ProjectName,
         ISNULL(
             (
                 SELECT STRING_AGG(o2.FullName, ', ')
                 FROM dbo.trn_MachineOperatorAllocation moa2
                 JOIN dbo.mst_Operator o2 ON o2.OperatorID = moa2.OperatorID
                 WHERE moa2.AssetID = a.AssetID
                   AND moa2.EndDate IS NULL
             ),
             ''
         ) AS OperatorName,
         ISNULL(ls.EndHMR,0) AS Reading,
         CASE
             WHEN oi.LogType='Breakdown'        THEN 'Breakdown'
             WHEN oi.LogType='UnderMaintenance' THEN 'Under Maintenance'
             WHEN ow.LogID IS NOT NULL          THEN 'Working'
             ELSE 'Idle'
         END AS CurrentStatus
     FROM dbo.mst_Asset a
     LEFT JOIN dbo.mst_AssetType at ON at.AssetTypeID = a.AssetTypeID
     LEFT JOIN dbo.mst_Project p ON p.ProjectID = (SELECT TOP 1 ProjectID FROM ActiveProject)
     LEFT JOIN LatestSubmitted ls ON ls.AssetID = a.AssetID AND ls.rn = 1
     LEFT JOIN OpenWorking ow     ON ow.AssetID = a.AssetID
     LEFT JOIN OpenInterrupt oi   ON oi.AssetID = a.AssetID
     WHERE a.AssetID = @AssetID AND ISNULL(a.IsActive,1)=1;
 END


ELSE IF(@Event='GetAssetQuickViewSummary')
BEGIN
	IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END
		IF ISNULL(@ScopeDivisionID,0) <> 0
		BEGIN
			IF NOT EXISTS (
				SELECT 1
				FROM dbo.mst_Asset a
				WHERE a.AssetID = @AssetID
				  AND a.DivisionID = @ScopeDivisionID
				  AND ISNULL(a.IsActive,1)=1
			)
			BEGIN
				RAISERROR('You can view only your assigned division asset details.',16,1);
				RETURN;
			END
		END

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    DECLARE @SummaryOpID INT = TRY_CAST(
        NULLIF(LTRIM(RTRIM(SUBSTRING(@ParameterString,
            CHARINDEX('OperatorID:',@ParameterString)+11,
            CASE
                WHEN CHARINDEX('~!',@ParameterString,CHARINDEX('OperatorID:',@ParameterString)+11)>0
                THEN CHARINDEX('~!',@ParameterString,CHARINDEX('OperatorID:',@ParameterString)+11)
                     -(CHARINDEX('OperatorID:',@ParameterString)+11)
                ELSE LEN(@ParameterString)
            END
        ))),'') AS INT);

    DECLARE @SumProjectID INT = NULL;

    IF @SummaryOpID IS NOT NULL
    BEGIN
        SELECT TOP 1 @SumProjectID = ProjectID
        FROM dbo.trn_MachineOperatorAllocation
        WHERE AssetID = @AssetID
          AND OperatorID = @SummaryOpID
          AND EndDate IS NULL
        ORDER BY ID DESC;

        IF @SumProjectID IS NULL
            SELECT TOP 1 @SumProjectID = ProjectID
            FROM dbo.trn_ProjectUserAllocation
            WHERE OperatorID = @SummaryOpID
              AND ISNULL(IsActive,1) = 1
              AND EndDate IS NULL
            ORDER BY ID DESC;
    END;

    ;WITH LogBase AS
    (
        SELECT
            dl.LogID,
            dl.AssetID,
            CAST(dl.LogDate AS DATE) AS LogDt,
            dl.MachineStatus,
            ISNULL(dl.ProductionQty,0) AS ProductionQty,
            ISNULL(dl.StartHMR,0) AS StartHMR,
            ISNULL(dl.EndHMR,0) AS EndHMR,
            ISNULL(dl.StartKMR,0) AS StartKMR,
            ISNULL(dl.EndKMR,0) AS EndKMR,
            CASE
                WHEN dl.StartDateTime IS NOT NULL AND dl.EndDateTime IS NOT NULL
                    THEN DATEDIFF(MINUTE, dl.StartDateTime, dl.EndDateTime) / 60.0
                ELSE ISNULL(dl.TotalHours,0)
            END AS CalcHours
        FROM dbo.trn_DailyLog dl
        WHERE dl.AssetID = @AssetID
          AND dl.SubmissionStatus IN ('Submitted','Locked')
          AND (
                @SummaryOpID IS NULL
                OR dl.OperatorID = @SummaryOpID
                OR (
                    @SumProjectID IS NOT NULL
                    AND dl.OperatorID IN
                    (
                        SELECT OperatorID
                        FROM dbo.trn_MachineOperatorAllocation
                        WHERE AssetID = @AssetID
                          AND ProjectID = @SumProjectID
                          AND EndDate IS NULL

                        UNION

                        SELECT OperatorID
                        FROM dbo.trn_ProjectUserAllocation
                        WHERE ProjectID = @SumProjectID
                          AND ISNULL(IsActive,1)=1
                          AND EndDate IS NULL
                    )
                )
              )
    ),
    FuelBase AS
    (
        SELECT
            fl.FuelLogID,
            fl.AssetID,
            CAST(fl.FuelDateTime AS DATE) AS FuelDt,
            ISNULL(fl.FuelQty,0) AS FuelQty
        FROM dbo.trn_FuelLog fl
        WHERE fl.AssetID = @AssetID
          AND ISNULL(fl.IsActive,1) = 1
    )
    SELECT
        ISNULL(SUM(CASE WHEN lb.LogDt = @Today AND lb.MachineStatus = 'Working' THEN lb.CalcHours ELSE 0 END),0) AS TodayNetWorking,
        ISNULL(SUM(CASE WHEN lb.MachineStatus = 'Working' THEN lb.CalcHours ELSE 0 END),0) AS TillNetWorking,

        ISNULL(SUM(CASE WHEN lb.LogDt = @Today AND lb.MachineStatus = 'Working' THEN lb.CalcHours ELSE 0 END),0) AS TodayLogWorking,
        ISNULL(SUM(CASE WHEN lb.MachineStatus = 'Working' THEN lb.CalcHours ELSE 0 END),0) AS TillLogWorking,

        ISNULL(SUM(CASE WHEN lb.LogDt = @Today AND lb.MachineStatus = 'Idle' THEN lb.CalcHours ELSE 0 END),0) AS TodayIdle,
        ISNULL(SUM(CASE WHEN lb.MachineStatus = 'Idle' THEN lb.CalcHours ELSE 0 END),0) AS TillIdle,

        ISNULL(SUM(CASE WHEN lb.LogDt = @Today AND lb.MachineStatus = 'Breakdown' THEN lb.CalcHours ELSE 0 END),0) AS TodayBreakdown,
        ISNULL(SUM(CASE WHEN lb.MachineStatus = 'Breakdown' THEN lb.CalcHours ELSE 0 END),0) AS TillBreakdown,

        ISNULL(SUM(CASE WHEN lb.LogDt = @Today AND lb.MachineStatus IN ('Under Maintenance','Maintenance','UnderMaintenance') THEN lb.CalcHours ELSE 0 END),0) AS TodayMaintenance,
        ISNULL(SUM(CASE WHEN lb.MachineStatus IN ('Under Maintenance','Maintenance','UnderMaintenance') THEN lb.CalcHours ELSE 0 END),0) AS TillMaintenance,

        ISNULL((SELECT SUM(FuelQty) FROM FuelBase WHERE FuelDt = @Today),0) AS TodayFuel,
        ISNULL((SELECT SUM(FuelQty) FROM FuelBase),0) AS TillFuel,

        ISNULL(SUM(CASE WHEN lb.LogDt = @Today THEN lb.ProductionQty ELSE 0 END),0) AS TodayOutput,
        ISNULL(SUM(lb.ProductionQty),0) AS TillOutput,

        MIN(CASE WHEN lb.LogDt = @Today AND lb.StartHMR > 0 THEN lb.StartHMR END) AS TodayStartHMR,
        MAX(CASE WHEN lb.LogDt = @Today AND lb.EndHMR > 0 THEN lb.EndHMR END) AS TodayEndHMR,
        ISNULL(
            MAX(CASE WHEN lb.LogDt = @Today AND lb.EndHMR > 0 THEN lb.EndHMR END)
            - MIN(CASE WHEN lb.LogDt = @Today AND lb.StartHMR > 0 THEN lb.StartHMR END),
            0
        ) AS TodayUsedHMR,

        MIN(CASE WHEN lb.StartHMR > 0 THEN lb.StartHMR END) AS TillStartHMR,
        MAX(CASE WHEN lb.EndHMR > 0 THEN lb.EndHMR END) AS TillEndHMR,
        ISNULL(
            MAX(CASE WHEN lb.EndHMR > 0 THEN lb.EndHMR END)
            - MIN(CASE WHEN lb.StartHMR > 0 THEN lb.StartHMR END),
            0
        ) AS TillUsedHMR,

        MIN(CASE WHEN lb.LogDt = @Today AND lb.StartKMR > 0 THEN lb.StartKMR END) AS TodayStartKMR,
        MAX(CASE WHEN lb.LogDt = @Today AND lb.EndKMR > 0 THEN lb.EndKMR END) AS TodayEndKMR,
        ISNULL(
            MAX(CASE WHEN lb.LogDt = @Today AND lb.EndKMR > 0 THEN lb.EndKMR END)
            - MIN(CASE WHEN lb.LogDt = @Today AND lb.StartKMR > 0 THEN lb.StartKMR END),
            0
        ) AS TodayUsedKMR,

        MIN(CASE WHEN lb.StartKMR > 0 THEN lb.StartKMR END) AS TillStartKMR,
        MAX(CASE WHEN lb.EndKMR > 0 THEN lb.EndKMR END) AS TillEndKMR,
        ISNULL(
            MAX(CASE WHEN lb.EndKMR > 0 THEN lb.EndKMR END)
            - MIN(CASE WHEN lb.StartKMR > 0 THEN lb.StartKMR END),
            0
        ) AS TillUsedKMR

    FROM LogBase lb;
END


ELSE IF(@Event='GetAssetQuickViewLogs')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END
		IF ISNULL(@ScopeDivisionID,0) <> 0
		BEGIN
			IF NOT EXISTS (
				SELECT 1
				FROM dbo.mst_Asset a
				WHERE a.AssetID = @AssetID
				  AND a.DivisionID = @ScopeDivisionID
				  AND ISNULL(a.IsActive,1)=1
			)
			BEGIN
				RAISERROR('You can view only your assigned division asset details.',16,1);
				RETURN;
			END
		END

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    DECLARE @LogsOpID INT = TRY_CAST(
        NULLIF(LTRIM(RTRIM(SUBSTRING(@ParameterString,
            CHARINDEX('OperatorID:',@ParameterString)+11,
            CASE
                WHEN CHARINDEX('~!',@ParameterString,CHARINDEX('OperatorID:',@ParameterString)+11)>0
                THEN CHARINDEX('~!',@ParameterString,CHARINDEX('OperatorID:',@ParameterString)+11)
                     -(CHARINDEX('OperatorID:',@ParameterString)+11)
                ELSE LEN(@ParameterString)
            END
        ))),'') AS INT);

    DECLARE @WeekOffset INT = TRY_CAST(
        NULLIF(LTRIM(RTRIM(SUBSTRING(@ParameterString,
            CHARINDEX('WeekOffset:',@ParameterString)+11,
            CASE
                WHEN CHARINDEX('~!',@ParameterString,CHARINDEX('WeekOffset:',@ParameterString)+11)>0
                THEN CHARINDEX('~!',@ParameterString,CHARINDEX('WeekOffset:',@ParameterString)+11)
                     -(CHARINDEX('WeekOffset:',@ParameterString)+11)
                ELSE LEN(@ParameterString)
            END
        ))),'') AS INT);

    IF @WeekOffset IS NULL SET @WeekOffset = 0;

    DECLARE @OpProjectID INT = NULL;
    IF @LogsOpID IS NOT NULL
    BEGIN
        SELECT TOP 1 @OpProjectID = ProjectID
        FROM dbo.trn_MachineOperatorAllocation
        WHERE AssetID = @AssetID AND OperatorID = @LogsOpID AND EndDate IS NULL
        ORDER BY ID DESC;

        IF @OpProjectID IS NULL
            SELECT TOP 1 @OpProjectID = ProjectID
            FROM dbo.trn_ProjectUserAllocation
            WHERE OperatorID = @LogsOpID
              AND ISNULL(IsActive,1) = 1
              AND EndDate IS NULL
            ORDER BY ID DESC;
    END

    DECLARE @Dates TABLE (LogDate DATE, RowNum INT);
    
    INSERT INTO @Dates (LogDate, RowNum)
    SELECT DISTINCT CAST(dl.LogDate AS DATE) AS LogDate,
           ROW_NUMBER() OVER (ORDER BY CAST(dl.LogDate AS DATE) DESC) AS RowNum
    FROM dbo.trn_DailyLog dl
    WHERE dl.AssetID = @AssetID
      AND (
            @LogsOpID IS NULL
            OR dl.OperatorID = @LogsOpID
            OR (
                @OpProjectID IS NOT NULL
                AND dl.OperatorID IN (
                    SELECT OperatorID FROM dbo.trn_MachineOperatorAllocation
                    WHERE AssetID = @AssetID AND ProjectID = @OpProjectID AND EndDate IS NULL
                    UNION
                    SELECT OperatorID FROM dbo.trn_ProjectUserAllocation
                    WHERE ProjectID = @OpProjectID
                      AND ISNULL(IsActive,1)=1
                      AND EndDate IS NULL
                )
            )
          );

    DECLARE @StartRow INT = (@WeekOffset * 7) + 1;
    DECLARE @EndRow INT = (@WeekOffset + 1) * 7;

    SELECT
        dl.LogID, dl.ParentLogID, dl.AssetID, dl.LogDate,
        dl.StartDateTime, dl.EndDateTime,
        dl.StartHMR, dl.EndHMR,
        dl.StartKMR, dl.EndKMR,
        CASE
            WHEN dl.StartDateTime IS NOT NULL AND dl.EndDateTime IS NOT NULL
            THEN (DATEDIFF(MINUTE, dl.StartDateTime, dl.EndDateTime) / 60.0)
                - CASE
                    WHEN dl.LogType = 'Working'
                    THEN ISNULL((
                        SELECT SUM(DATEDIFF(MINUTE, c.StartDateTime, c.EndDateTime) / 60.0)
                        FROM dbo.trn_DailyLog c
                        WHERE c.ParentLogID = dl.LogID
                          AND c.LogType IN ('Breakdown','UnderMaintenance')
                          AND c.StartDateTime IS NOT NULL AND c.EndDateTime IS NOT NULL
                    ), 0)
                    ELSE 0
                  END
            ELSE ISNULL(dl.TotalHours,0)
        END AS TotalHours,
        dl.LogType, dl.MachineStatus, dl.ProductionQty, dl.ProductionUnit,
        dl.Remarks, dl.BreakdownReason,
        dl.OperatorID, o.FullName AS OperatorName,
        dl.ProjectID,  p.ProjectName,
        ISNULL(dl.EndReadingPhoto, dl.RemarkPhoto) AS PhotoPath,
		--fn.PhotoPath As FuelPhoto,
        dl.SubmissionStatus,
        dl.LogVerificationStatus,
        dl.LogVerificationDate
    FROM dbo.trn_DailyLog dl
    LEFT JOIN dbo.mst_Operator o ON o.OperatorID = dl.OperatorID
	--LEFT JOIN dbo.trn_FuelLog fn ON fn.AssetID = dl.AssetID
    LEFT JOIN dbo.mst_Project  p ON p.ProjectID  = dl.ProjectID
    WHERE dl.AssetID = @AssetID
      AND CAST(dl.LogDate AS DATE) IN (
          SELECT LogDate FROM @Dates WHERE RowNum BETWEEN @StartRow AND @EndRow
      )
      AND (
            @LogsOpID IS NULL
            OR dl.OperatorID = @LogsOpID
            OR (
                @OpProjectID IS NOT NULL
                AND dl.OperatorID IN (
                    SELECT OperatorID FROM dbo.trn_MachineOperatorAllocation
                    WHERE AssetID = @AssetID AND ProjectID = @OpProjectID AND EndDate IS NULL
                    UNION
                    SELECT OperatorID FROM dbo.trn_ProjectUserAllocation
                    WHERE ProjectID = @OpProjectID
                      AND ISNULL(IsActive,1)=1
                      AND EndDate IS NULL
                )
            )
          )
    ORDER BY dl.LogDate DESC, dl.LogID DESC;
END


ELSE IF(@Event='GetLogDetails')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    IF ISNULL(@LogID,0)=0
        RAISERROR('LogID is required.',16,1);

    SELECT
        dl.LogID,
        dl.AssetID,
        a.AssetName,
        a.PhotoPath,
        a.RecordingUnit,
        dl.ProjectID,
        p.ProjectName,
        dl.OperatorID,
		dl.EndReadingPhoto,
        o.FullName AS OperatorName,
        dl.MachineStatus,
        dl.StartDateTime,
        dl.EndDateTime,
        dl.StartHMR,
        dl.EndHMR,
        dl.StartKMR,
        dl.EndKMR,
        CASE
            WHEN dl.StartDateTime IS NOT NULL AND dl.EndDateTime IS NOT NULL
                THEN DATEDIFF(MINUTE, dl.StartDateTime, dl.EndDateTime) / 60.0
            ELSE ISNULL(dl.TotalHours,0)
        END AS TotalHours,
        dl.ProductionQty,
        dl.ProductionUnit,
        dl.Remarks,
        dl.BreakdownReason,
        dl.IdleHours,
        dl.BreakdownHours,
        ISNULL(fl.FuelQty, 0) AS FuelQty,
        dl.SubmissionStatus,
        dl.LogDate,
        dl.CreatedOn,
        dl.LogVerificationStatus,
        dl.LogVerificationDate
    FROM dbo.trn_DailyLog dl
    LEFT JOIN dbo.mst_Asset a ON a.AssetID = dl.AssetID
    LEFT JOIN dbo.mst_Project p ON p.ProjectID = dl.ProjectID
    LEFT JOIN dbo.mst_Operator o ON o.OperatorID = dl.OperatorID
    OUTER APPLY
    (
        SELECT TOP 1 f.FuelQty
        FROM dbo.trn_FuelLog f
        WHERE f.AssetID = dl.AssetID
          AND ISNULL(f.IsActive,1) = 1
          AND (
                (dl.EndDateTime IS NOT NULL AND f.FuelDateTime = dl.EndDateTime)
                OR
                (dl.EndDateTime IS NULL AND f.FuelDateTime = dl.StartDateTime)
              )
        ORDER BY f.FuelLogID DESC
    ) fl
    WHERE dl.LogID = @LogID;
END

ELSE IF(@Event='GetBulkLogDetails_4E965F53')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF ISNULL(@AssetID,0)=0
    BEGIN
        RAISERROR('AssetID is required.',16,1);
        RETURN;
    END

    SELECT
        dl.LogID,
        dl.AssetID,
        a.AssetName,
        a.PhotoPath,
        a.RecordingUnit,
        dl.ProjectID,
        p.ProjectName,
        dl.OperatorID,
        o.FullName AS OperatorName,
        dl.MachineStatus,
        dl.StartDateTime,
        dl.EndDateTime,
        dl.StartHMR,
        dl.EndHMR,
        dl.StartKMR,
        dl.EndKMR,
        CASE
            WHEN dl.StartDateTime IS NOT NULL AND dl.EndDateTime IS NOT NULL
                THEN DATEDIFF(MINUTE, dl.StartDateTime, dl.EndDateTime) / 60.0
            ELSE ISNULL(dl.TotalHours,0)
        END AS TotalHours,
        dl.ProductionQty,
        dl.ProductionUnit,
        dl.Remarks,
        dl.BreakdownReason,
        dl.IdleHours,
        dl.BreakdownHours,
        ISNULL(fl.FuelQty, 0) AS FuelQty,
        dl.SubmissionStatus,
        dl.LogDate,
        dl.CreatedOn,
        dl.LogVerificationStatus,
        dl.LogVerificationDate
    FROM dbo.trn_DailyLog dl
    LEFT JOIN dbo.mst_Asset a ON a.AssetID = dl.AssetID
    LEFT JOIN dbo.mst_Project p ON p.ProjectID = dl.ProjectID
    LEFT JOIN dbo.mst_Operator o ON o.OperatorID = dl.OperatorID
    OUTER APPLY
    (
        SELECT TOP 1 f.FuelQty
        FROM dbo.trn_FuelLog f
        WHERE f.AssetID = dl.AssetID
          AND ISNULL(f.IsActive,1) = 1
          AND (
                (dl.EndDateTime IS NOT NULL AND f.FuelDateTime = dl.EndDateTime)
                OR
                (dl.EndDateTime IS NULL AND f.FuelDateTime = dl.StartDateTime)
              )
        ORDER BY f.FuelLogID DESC
    ) fl
    WHERE dl.AssetID = @AssetID
    ORDER BY dl.StartDateTime, dl.LogID;
END


ELSE IF(@Event='GetFuelLogForm')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    SELECT TOP 1
        a.AssetID,
        a.AssetName,
        ISNULL(cd.FuelType,   a.FuelType)           AS FuelType,
        ISNULL(cd.FuelUnit,   'Liters')              AS FuelUnit,
        ISNULL(cd.RecordingUnit, a.RecordingUnit)    AS RecordingUnit,
        ISNULL(cd.OutputUnit,    a.OutputUnit)       AS OutputUnit,
        ISNULL(dl.EndHMR, 0)                         AS CurrentReading,
        GETDATE()                                    AS FuelDateTime,
        NULL                                         AS FuelQty,
        NULL                                         AS ReadingAtFueling,
        ''                                           AS Remarks
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = a.CategoryID
       AND ISNULL(cd.IsActive, 1) = 1
    OUTER APPLY
    (
        SELECT TOP 1 EndHMR
        FROM dbo.trn_DailyLog
        WHERE AssetID = a.AssetID
        ORDER BY LogDate DESC, LogID DESC
    ) dl
    WHERE a.AssetID = @AssetID;
END

ELSE IF(@Event='GetFuelLogsForAsset')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END
		IF ISNULL(@ScopeDivisionID,0) <> 0
		BEGIN
			IF NOT EXISTS (
				SELECT 1
				FROM dbo.mst_Asset a
				WHERE a.AssetID = @AssetID
				  AND a.DivisionID = @ScopeDivisionID
				  AND ISNULL(a.IsActive,1)=1
			)
			BEGIN
				RAISERROR('You can view only your assigned division asset details.',16,1);
				RETURN;
			END
		END

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    SELECT
        fl.FuelLogID,
        fl.AssetID,
        CAST(fl.FuelDateTime AS DATE)   AS LogDate,
        fl.FuelDateTime,
        fl.FuelQty,
        fl.ReadingAtFueling,
        fl.FuelType,
        fl.Remarks,
        fl.PhotoPath,
        fl.CreatedBy,
        fl.CreatedOn,
        o.FullName                      AS OperatorName,
        NULL                            AS ProjectName
    FROM dbo.trn_FuelLog fl
    LEFT JOIN dbo.mst_Operator o ON o.OperatorID = fl.CreatedBy
    WHERE fl.AssetID = @AssetID
      AND ISNULL(fl.IsActive, 1) = 1
    ORDER BY fl.FuelDateTime DESC;
END

ELSE IF(@Event='SaveFuelLog')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can save fuel logs only for your assigned division assets.',16,1);
            RETURN;
        END
    END

    DECLARE @FuelType_Log VARCHAR(50);

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF @FuelDateTime IS NULL
        RAISERROR('FuelDateTime is required.',16,1);

    IF ISNULL(@FuelQty,0)<=0
        RAISERROR('FuelQty is required.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.mst_Asset
        WHERE AssetID=@AssetID
          AND ISNULL(IsActive,1)=1
    )
        RAISERROR('Asset not found.',16,1);

    SELECT @FuelType_Log = ISNULL(
        NULLIF(@FuelType, ''),
        ISNULL(cd.FuelType, a.FuelType)
    )
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = a.CategoryID
       AND ISNULL(cd.IsActive, 1) = 1
    WHERE a.AssetID = @AssetID;

    INSERT INTO dbo.trn_FuelLog
    (
        AssetID,
        FuelDateTime,
        FuelQty,
        ReadingAtFueling,
        FuelType,
        Remarks,
        PhotoPath,
        CreatedBy,
        CreatedOn,
        ModifiedBy,
        ModifiedOn,
        IsActive
    )
    VALUES
    (
        @AssetID,
        @FuelDateTime,
        @FuelQty,
        @ReadingAtFueling,
        @FuelType_Log,
        @WorkingRemarks,
        @PhotoPath_Fuel,
        @AuthEmployeeID,
        GETDATE(),
        NULL,
        NULL,
        1
    );

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Fuel log saved successfully.' AS Msg,
        SCOPE_IDENTITY() AS FuelLogID;
END

ELSE IF(@Event='StartWorking')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END
    DECLARE @ResolvedProjectID INT;
    DECLARE @ResolvedAllocationID INT;
    DECLARE @ResolvedOperatorID INT;
    DECLARE @AssetRecordingUnit_Start VARCHAR(50);

    SELECT
        @EffectiveAssetID =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID, @AssetID);

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF @StartDateTime IS NULL
        RAISERROR('StartDateTime is required.',16,1);

    SELECT TOP 1
        @ResolvedProjectID = pma.ProjectID,
        @ResolvedAllocationID = pma.ID
    FROM dbo.trn_ProjectMachineAllocation pma
    WHERE pma.AssetID = @AssetID
      AND ISNULL(pma.IsActive,1)=1
      AND pma.EndDate IS NULL
    ORDER BY pma.ID DESC;

    SELECT TOP 1
        @ResolvedOperatorID = moa.OperatorID
    FROM dbo.trn_MachineOperatorAllocation moa
    WHERE moa.AssetID = @AssetID
      AND ISNULL(moa.ProjectID,0)=ISNULL(@ResolvedProjectID,0)
      AND ISNULL(moa.IsActive,1)=1
      AND moa.EndDate IS NULL
    ORDER BY moa.ID DESC;

    SET @ProjectID = ISNULL(NULLIF(@ProjectID,0), @ResolvedProjectID);
    SET @AllocationID = ISNULL(NULLIF(@AllocationID,0), @ResolvedAllocationID);
    SET @OperatorID = ISNULL(NULLIF(@OperatorID,0), @ResolvedOperatorID);

    IF ISNULL(@ProjectID,0)=0
        RAISERROR('ProjectID not found for this asset.',16,1);

    IF ISNULL(@OperatorID,0)=0
        RAISERROR('OperatorID is required.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can start logs only for your assigned division assets.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can start logs only for your assigned division projects.',16,1);
            RETURN;
        END
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Operator'
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Operator o
            WHERE o.OperatorID = @OperatorID
              AND o.EmployeeID = @AuthEmployeeID
              AND ISNULL(o.IsActive,1)=1
        )
        BEGIN
            RAISERROR('Operator can start logs only for their own operator profile.',16,1);
            RETURN;
        END
    END

    SELECT
        @AssetRecordingUnit_Start = ISNULL(NULLIF(cd.RecordingUnit,''), ISNULL(NULLIF(a.RecordingUnit,''), 'Hours'))
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = a.CategoryID
       AND ISNULL(cd.IsActive,1)=1
    WHERE a.AssetID = @AssetID;

    SET @AssetRecordingUnit_Start = LTRIM(RTRIM(ISNULL(@AssetRecordingUnit_Start,'Hours')));

    SET @UsesHMR = CASE
        WHEN @AssetRecordingUnit_Start IN ('Hours','Hour','HMR','Both','KMR/HMR') THEN 1
        ELSE 0
    END;

    SET @UsesKMR = CASE
        WHEN @AssetRecordingUnit_Start IN ('Kilometer','Kilometers','KM','KMR','Both','KMR/HMR') THEN 1
        ELSE 0
    END;

    IF @UsesHMR = 1 AND @StartHMR IS NULL
        RAISERROR('StartHMR is required.',16,1);

    IF @UsesKMR = 1 AND @StartKMR IS NULL
        RAISERROR('StartKMR is required.',16,1);

    IF ISNULL(@MachineStatus,'')=''
        SET @MachineStatus = 'Working';

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_DailyLog
        WHERE AssetID = @AssetID
          AND SubmissionStatus='Draft'
    )
        RAISERROR('One draft log is already open for this asset.',16,1);

    INSERT INTO dbo.trn_DailyLog
    (
        LogDate,
        ProjectID,
        ShiftID,
        AssetID,
        AllocationID,
        OperatorID,
        StartDateTime,
        StartHMR,
        StartKMR,
        EndDateTime,
        EndHMR,
        EndKMR,
        MachineStatus,
        ProductionQty,
        ProductionUnit,
        IdleHours,
        BreakdownReason,
        SubmissionStatus,
        Remarks,
        CreatedBy,
        CreatedOn,
        BreakdownHours,
        IsPhotoMandatory,
        IsPhotoUploaded,
        EndReadingPhoto,
        RemarkPhoto,
        LogType,
        LogVerificationStatus,
        LogVerificationDate
    )
    VALUES
    (
        CAST(@StartDateTime AS DATE),
        @ProjectID,
        NULL,
        @AssetID,
        @AllocationID,
        @OperatorID,
        @StartDateTime,
        ISNULL(@StartHMR,0),
        ISNULL(@StartKMR,0),
        NULL,
        ISNULL(@StartHMR,0),
        ISNULL(@StartKMR,0),
        'Working',
        ISNULL(@OutputQty,0),
        ISNULL(NULLIF(@ProductionUnit,''),''),
        ISNULL(@IdleHours,0),
        ISNULL(@BreakdownReason,''),
        'Draft',
        @WorkingRemarks,
        @AuthEmployeeID,
        GETDATE(),
        ISNULL(@BreakdownHours,0),
        0,
        CASE
            WHEN NULLIF(@EndReadingPhoto,'') IS NOT NULL OR NULLIF(@RemarkPhoto,'') IS NOT NULL THEN 1
            ELSE 0
        END,
        NULLIF(@EndReadingPhoto,''),
        NULLIF(@RemarkPhoto,''),
        'Working',
        ISNULL(@LogVerificationStatus,0),
        CASE WHEN ISNULL(@LogVerificationStatus,0)=1 THEN @LogVerificationDate ELSE NULL END
    );

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Working started successfully.' AS Msg,
        SCOPE_IDENTITY() AS LogID;
END

ELSE IF(@Event='EndWorking')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @AssetRecordingUnit_End VARCHAR(50);
    DECLARE @WorkingStartDateTime DATETIME;
    DECLARE @WorkingStartHMR DECIMAL(18,2);
    DECLARE @WorkingStartKMR DECIMAL(18,2);
    DECLARE @EffectiveAssetID_End INT;

    IF ISNULL(@LogID,0)=0
        RAISERROR('LogID is required.',16,1);

    IF @EndDateTime IS NULL
        RAISERROR('EndDateTime is required.',16,1);

    SELECT
        @AssetID = dl.AssetID,
        @ProjectID = dl.ProjectID,
        @OperatorID = dl.OperatorID,
        @WorkingStartDateTime = dl.StartDateTime,
        @WorkingStartHMR = dl.StartHMR,
        @WorkingStartKMR = dl.StartKMR
    FROM dbo.trn_DailyLog dl
    WHERE dl.LogID = @LogID
      AND dl.LogType = 'Working'
      AND dl.SubmissionStatus = 'Draft';

    IF ISNULL(@AssetID,0)=0
        RAISERROR('Active Working log not found.',16,1);

    SELECT
        @EffectiveAssetID_End =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID_End, @AssetID);

    IF @EndDateTime <= @WorkingStartDateTime
        RAISERROR('EndDateTime cannot be less than or equal to StartDateTime.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can end logs only for your assigned division assets.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can end logs only for your assigned division projects.',16,1);
            RETURN;
        END
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Operator'
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Operator o
            WHERE o.OperatorID = @OperatorID
              AND o.EmployeeID = @AuthEmployeeID
              AND ISNULL(o.IsActive,1)=1
        )
        BEGIN
            RAISERROR('Operator can end logs only for their own operator profile.',16,1);
            RETURN;
        END
    END

    SELECT
        @AssetRecordingUnit_End = ISNULL(NULLIF(cd.RecordingUnit,''), ISNULL(NULLIF(a.RecordingUnit,''), 'Hours'))
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetCategoryDefaults cd
        ON cd.CategoryID = a.CategoryID
       AND ISNULL(cd.IsActive,1)=1
    WHERE a.AssetID = @AssetID;

    SET @AssetRecordingUnit_End = LTRIM(RTRIM(ISNULL(@AssetRecordingUnit_End,'Hours')));

    SET @UsesHMR_End = CASE
        WHEN @AssetRecordingUnit_End IN ('Hours','Hour','HMR','Both','KMR/HMR') THEN 1
        ELSE 0
    END;

    SET @UsesKMR_End = CASE
        WHEN @AssetRecordingUnit_End IN ('Kilometer','Kilometers','KM','KMR','Both','KMR/HMR') THEN 1
        ELSE 0
    END;

    IF @UsesHMR_End = 1 AND @EndHMR IS NULL
        RAISERROR('EndHMR is required.',16,1);

    IF @UsesKMR_End = 1 AND @EndKMR IS NULL
        RAISERROR('EndKMR is required.',16,1);

    IF @UsesHMR_End = 1 AND @EndHMR < @WorkingStartHMR
        RAISERROR('End HMR cannot be less than Start HMR.',16,1);

    IF @UsesKMR_End = 1 AND @EndKMR < @WorkingStartKMR
        RAISERROR('End KMR cannot be less than Start KMR.',16,1);

    UPDATE dbo.trn_DailyLog
    SET
        EndHMR = CASE
            WHEN @UsesHMR_End = 1 THEN ISNULL(@EndHMR, StartHMR)
            ELSE EndHMR
        END,
        EndKMR = CASE
            WHEN @UsesKMR_End = 1 THEN ISNULL(@EndKMR, StartKMR)
            ELSE EndKMR
        END,
        EndDateTime = @EndDateTime,
		EndReadingPhoto = ISNULL(NULLIF(@EndReadingPhoto,''), EndReadingPhoto),
		RemarkPhoto = ISNULL(NULLIF(@RemarkPhoto,''), RemarkPhoto),
		IsPhotoUploaded = CASE WHEN NULLIF(@EndReadingPhoto,'') IS NOT NULL OR NULLIF(@RemarkPhoto,'') IS NOT NULL OR ISNULL(IsPhotoUploaded,0)=1 THEN 1 ELSE 0 END,
        ProductionQty = ISNULL(@ProductionQty, 0),
        ProductionUnit = ISNULL(NULLIF(@ProductionUnit,''), ProductionUnit),
        Remarks = ISNULL(NULLIF(@WorkingRemarks,''), Remarks),
        SubmissionStatus = 'Submitted',
        SubmittedBy = @AuthEmployeeID,
        SubmittedOn = GETDATE(),
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE()
    WHERE LogID=@LogID
      AND LogType='Working'
      AND SubmissionStatus='Draft';

    IF @@ROWCOUNT = 0
        RAISERROR('EndWorking update failed.',16,1);

    SELECT 'Success' AS Status, 'Working ended successfully.' AS Msg, @LogID AS LogID;
END


ELSE IF(@Event IN ('StartBreakdown','StartUnderMaintenance'))
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @ParentLogID INT,
            @SessionID_Child UNIQUEIDENTIFIER,
            @ChildStatus VARCHAR(30),
            @ParentStartDateTime DATETIME,
            @EffectiveAssetID_Interrupt INT;

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF @StartDateTime IS NULL
        RAISERROR('StartDateTime is required.',16,1);

    SELECT
        @EffectiveAssetID_Interrupt =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID_Interrupt, @AssetID);

    SET @ChildStatus = CASE WHEN @Event='StartBreakdown' THEN 'Breakdown' ELSE 'UnderMaintenance' END;

    SELECT TOP 1
        @ParentLogID = LogID,
        @SessionID_Child = SessionID,
        @ProjectID = ProjectID,
        @AllocationID = AllocationID,
        @OperatorID = OperatorID,
        @ParentStartDateTime = StartDateTime,
        @StartHMR = ISNULL(@StartHMR, EndHMR),
        @StartKMR = ISNULL(@StartKMR, EndKMR)
    FROM dbo.trn_DailyLog
    WHERE AssetID=@AssetID
      AND LogType='Working'
      AND SubmissionStatus='Draft'
    ORDER BY LogID DESC;

    IF ISNULL(@ProjectID, 0) = 0
    BEGIN
        SELECT TOP 1
            @ProjectID = pma.ProjectID,
            @AllocationID = pma.ID
        FROM dbo.trn_ProjectMachineAllocation pma
        WHERE pma.AssetID = @AssetID
          AND ISNULL(pma.IsActive,1) = 1
          AND pma.EndDate IS NULL
        ORDER BY pma.ID DESC;

        SELECT TOP 1
            @OperatorID = moa.OperatorID
        FROM dbo.trn_MachineOperatorAllocation moa
        WHERE moa.AssetID = @AssetID
          AND ISNULL(moa.ProjectID,0) = ISNULL(@ProjectID,0)
          AND moa.EndDate IS NULL
        ORDER BY moa.ID DESC;
    END

    IF ISNULL(@ProjectID,0)=0
        RAISERROR('ProjectID not found for this asset.',16,1);

    IF ISNULL(@OperatorID,0)=0
        RAISERROR('OperatorID is required.',16,1);

    IF @ParentStartDateTime IS NOT NULL AND @StartDateTime < @ParentStartDateTime
        RAISERROR('Interruption start time cannot be less than working start time.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can start interruption logs only for your assigned division assets.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can start interruption logs only for your assigned division projects.',16,1);
            RETURN;
        END
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Operator'
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Operator o
            WHERE o.OperatorID = @OperatorID
              AND o.EmployeeID = @AuthEmployeeID
              AND ISNULL(o.IsActive,1)=1
        )
        BEGIN
            RAISERROR('Operator can start interruption logs only for their own operator profile.',16,1);
            RETURN;
        END
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_DailyLog
        WHERE AssetID=@AssetID
          AND LogType IN ('Breakdown','UnderMaintenance')
          AND SubmissionStatus='Draft'
    )
        RAISERROR('Another interruption log is already open for this asset.',16,1);

    INSERT INTO dbo.trn_DailyLog
    (
        LogDate,
        ProjectID,
        AssetID,
        AllocationID,
        OperatorID,
        StartHMR,
        EndHMR,
        StartKMR,
        EndKMR,
        MachineStatus,
        ProductionQty,
        ProductionUnit,
        SubmissionStatus,
        Remarks,
        BreakdownReason,
        CreatedBy,
        CreatedOn,
        StartDateTime,
        EndDateTime,
        ParentLogID,
        SessionID,
        LogType,
        RemarkPhoto,
        IsPhotoUploaded
    )
    VALUES
    (
        CAST(@StartDateTime AS DATE),
        @ProjectID,
        @AssetID,
        @AllocationID,
        @OperatorID,
        ISNULL(@StartHMR,0),
        ISNULL(@StartHMR,0),
        ISNULL(@StartKMR,0),
        ISNULL(@StartKMR,0),
        @ChildStatus,
        0,
        @ProductionUnit,
        'Draft',
        @WorkingRemarks,
        @BreakdownReason,
        @AuthEmployeeID,
        GETDATE(),
        @StartDateTime,
        NULL,
        @ParentLogID,
        @SessionID_Child,
        @ChildStatus,
        NULLIF(@RemarkPhoto, ''),
        CASE WHEN NULLIF(@RemarkPhoto, '') IS NOT NULL THEN 1 ELSE 0 END
    );

    SELECT 'Success' AS Status, @ChildStatus + ' started successfully.' AS Msg, SCOPE_IDENTITY() AS LogID, @ParentLogID AS ParentLogID;
END


ELSE IF(@Event='GetCurrentAssetLogState')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

	IF ISNULL(@ScopeDivisionID,0) <> 0
	BEGIN
		IF NOT EXISTS (
			SELECT 1
			FROM dbo.mst_Asset a
			WHERE a.AssetID = @AssetID
			  AND a.DivisionID = @ScopeDivisionID
			  AND ISNULL(a.IsActive,1)=1
		)
		BEGIN
			RAISERROR('You can view only your assigned division asset log state.',16,1);
			RETURN;
		END
	END

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    SELECT
        a.AssetID,
        ow.LogID     AS WorkingLogID,
        oi.LogID     AS InterruptionLogID,
        ISNULL(oi.LogID, ow.LogID) AS OpenLogID,
        CASE
            WHEN oi.LogType = 'Breakdown'         THEN 'Breakdown'
            WHEN oi.LogType = 'UnderMaintenance'  THEN 'Under Maintenance'
            WHEN ow.LogID IS NOT NULL             THEN 'Working'
            ELSE 'Idle'
        END AS CurrentStatus
    FROM dbo.mst_Asset a
    LEFT JOIN
    (
        SELECT AssetID, LogID
        FROM dbo.trn_DailyLog
        WHERE LogType = 'Working'
          AND SubmissionStatus = 'Draft'
    ) ow ON ow.AssetID = a.AssetID
    LEFT JOIN
    (
        SELECT AssetID, LogID, LogType
        FROM dbo.trn_DailyLog
        WHERE LogType IN ('Breakdown','UnderMaintenance')
          AND SubmissionStatus = 'Draft'
    ) oi ON oi.AssetID = a.AssetID
    WHERE a.AssetID = @AssetID;
END

ELSE IF(@Event='EndBreakdown')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @BreakdownStartDateTime DATETIME;
    DECLARE @EffectiveAssetID_BreakdownEnd INT;

    IF ISNULL(@LogID,0)=0
        RAISERROR('LogID is required.',16,1);

    IF @EndDateTime IS NULL
        RAISERROR('EndDateTime is required.',16,1);

    SELECT
        @AssetID = dl.AssetID,
        @ProjectID = dl.ProjectID,
        @OperatorID = dl.OperatorID,
        @BreakdownStartDateTime = dl.StartDateTime
    FROM dbo.trn_DailyLog dl
    WHERE dl.LogID = @LogID
      AND dl.LogType = 'Breakdown'
      AND dl.SubmissionStatus = 'Draft';

    IF ISNULL(@AssetID,0)=0
        RAISERROR('Active Breakdown log not found.',16,1);

    SELECT
        @EffectiveAssetID_BreakdownEnd =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID_BreakdownEnd, @AssetID);

    -- 1. Modified check to include EQUAL values to match table check constraint EndGTStart
    IF @EndDateTime <= @BreakdownStartDateTime
        RAISERROR('EndDateTime cannot be less than or equal to StartDateTime.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can end breakdown only for your assigned division assets.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can end breakdown only for your assigned division projects.',16,1);
            RETURN;
        END
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Operator'
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Operator o
            WHERE o.OperatorID = @OperatorID
              AND o.EmployeeID = @AuthEmployeeID
              AND ISNULL(o.IsActive,1)=1
        )
        BEGIN
            RAISERROR('Operator can end breakdown only for their own operator profile.',16,1);
            RETURN;
        END
    END

    UPDATE dbo.trn_DailyLog
    SET
        -- 2. Modified HMR/KMR updates to guard against '0' inputs overriding existing values
        EndHMR = CASE WHEN ISNULL(@EndHMR, 0) = 0 THEN StartHMR ELSE @EndHMR END,
        EndKMR = CASE WHEN ISNULL(@EndKMR, 0) = 0 THEN StartKMR ELSE @EndKMR END,
        EndDateTime = @EndDateTime,
		EndReadingPhoto = ISNULL(NULLIF(@EndReadingPhoto,''), EndReadingPhoto),
        IsPhotoUploaded = CASE WHEN NULLIF(@EndReadingPhoto,'') IS NOT NULL OR NULLIF(@RemarkPhoto,'') IS NOT NULL OR ISNULL(IsPhotoUploaded,0)=1 THEN 1 ELSE 0 END,
        Remarks = ISNULL(NULLIF(@WorkingRemarks,''), Remarks),
        BreakdownReason = ISNULL(NULLIF(@BreakdownReason,''), BreakdownReason),
        RemarkPhoto = ISNULL(NULLIF(@RemarkPhoto,''), RemarkPhoto),
        --IsPhotoUploaded = CASE WHEN NULLIF(@RemarkPhoto,'') IS NOT NULL OR ISNULL(IsPhotoUploaded,0)=1 THEN 1 ELSE 0 END,
        SubmissionStatus = 'Submitted',
        SubmittedBy = @AuthEmployeeID,
        SubmittedOn = GETDATE(),
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE()
    WHERE LogID = @LogID
      AND LogType = 'Breakdown'
      AND SubmissionStatus = 'Draft';

    IF @@ROWCOUNT = 0
        RAISERROR('EndBreakdown update failed.',16,1);

    SELECT 'Success' AS Status, 'Breakdown ended successfully.' AS Msg, @LogID AS LogID;
END


ELSE IF(@Event='EndUnderMaintenance')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @UnderMaintenanceStartDateTime DATETIME;
    DECLARE @EffectiveAssetID_MaintEnd INT;

    IF ISNULL(@LogID,0)=0
        RAISERROR('LogID is required.',16,1);

    IF @EndDateTime IS NULL
        RAISERROR('EndDateTime is required.',16,1);

    SELECT
        @AssetID = dl.AssetID,
        @ProjectID = dl.ProjectID,
        @OperatorID = dl.OperatorID,
        @UnderMaintenanceStartDateTime = dl.StartDateTime
    FROM dbo.trn_DailyLog dl
    WHERE dl.LogID = @LogID
      AND dl.LogType = 'UnderMaintenance'
      AND dl.SubmissionStatus = 'Draft';

    IF ISNULL(@AssetID,0)=0
        RAISERROR('Active Under Maintenance log not found.',16,1);

    SELECT
        @EffectiveAssetID_MaintEnd =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID_MaintEnd, @AssetID);

    IF @EndDateTime < @UnderMaintenanceStartDateTime
        RAISERROR('EndDateTime cannot be less than StartDateTime.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can end maintenance only for your assigned division assets.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can end maintenance only for your assigned division projects.',16,1);
            RETURN;
        END
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) = 'Operator'
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Operator o
            WHERE o.OperatorID = @OperatorID
              AND o.EmployeeID = @AuthEmployeeID
              AND ISNULL(o.IsActive,1)=1
        )
        BEGIN
            RAISERROR('Operator can end maintenance only for their own operator profile.',16,1);
            RETURN;
        END
    END

    UPDATE dbo.trn_DailyLog
    SET
        EndHMR = ISNULL(@EndHMR, StartHMR),
        EndKMR = ISNULL(@EndKMR, StartKMR),
        EndDateTime = @EndDateTime,
        Remarks = ISNULL(NULLIF(@WorkingRemarks,''), Remarks),
        BreakdownReason = ISNULL(NULLIF(@BreakdownReason,''), BreakdownReason),
        RemarkPhoto = ISNULL(NULLIF(@RemarkPhoto,''), RemarkPhoto),
		EndReadingPhoto = ISNULL(NULLIF(@EndReadingPhoto,''), EndReadingPhoto),
        IsPhotoUploaded = CASE WHEN NULLIF(@EndReadingPhoto,'') IS NOT NULL OR NULLIF(@RemarkPhoto,'') IS NOT NULL OR ISNULL(IsPhotoUploaded,0)=1 THEN 1 ELSE 0 END,
        --IsPhotoUploaded = CASE WHEN NULLIF(@RemarkPhoto,'') IS NOT NULL OR ISNULL(IsPhotoUploaded,0)=1 THEN 1 ELSE 0 END,
        SubmissionStatus = 'Submitted',
        SubmittedBy = @AuthEmployeeID,
        SubmittedOn = GETDATE(),
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE()
    WHERE LogID = @LogID
      AND LogType = 'UnderMaintenance'
      AND SubmissionStatus = 'Draft';

    IF @@ROWCOUNT = 0
        RAISERROR('EndUnderMaintenance update failed.',16,1);

    SELECT 'Success' AS Status, 'Under Maintenance ended successfully.' AS Msg, @LogID AS LogID;
END

ELSE IF (@Event = 'SaveUserRole')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Save User Role.',16,1);
		RETURN;
	END
    DECLARE @EmpUsername NVARCHAR(100) = NULLIF(LTRIM(RTRIM(@Username)), '');

    IF EXISTS (SELECT 1 FROM dbo.mst_UserRole WHERE EmployeeID = @EmployeeID AND IsActive = 1)
    BEGIN
        UPDATE dbo.mst_UserRole
        SET DivisionID = @DivisionID,
            RoleID     = @RoleID,
            Username   = ISNULL(@EmpUsername, Username)
        WHERE EmployeeID = @EmployeeID
          AND IsActive = 1;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.mst_UserRole (EmployeeID, DivisionID, RoleID, Username)
        VALUES (@EmployeeID, @DivisionID, @RoleID, @EmpUsername);
    END

    SELECT 'Success' AS Result;
END


ELSE IF (@Event = 'GetAllRoles')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    SELECT RoleID, RoleName, RoleDescription
    FROM dbo.mst_Role
    WHERE ISNULL(IsActive, 1) = 1
    ORDER BY RoleID;
END

ELSE IF (@Event = 'GetAllUserRoles')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        ur.UserRoleID,
        ur.EmployeeID,
        ur.Username,
        ur.DivisionID,
        d.DivisionName,
        ur.RoleID,
        r.RoleName,
        ur.IsActive,
        ur.CreatedDate,
        ur.Guid,
        ur.OperatorID,
        ur.Email 
    FROM dbo.mst_UserRole ur
    INNER JOIN dbo.mst_Role r ON r.RoleID = ur.RoleID
    LEFT JOIN dbo.mst_Division d ON d.DivisionID = ur.DivisionID
    ORDER BY ur.UserRoleID DESC;
END


 ELSE IF (@Event = 'GetEmployeeMenuAccess')
 BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
     DECLARE @EmpID_GA INT;
     DECLARE @p1 NVARCHAR(100) = SUBSTRING(@ParameterString,
         CHARINDEX('EmployeeID:', @ParameterString) + 11,
         CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('EmployeeID:', @ParameterString)) > 0
              THEN CHARINDEX('~!', @ParameterString, CHARINDEX('EmployeeID:', @ParameterString))
                   - CHARINDEX('EmployeeID:', @ParameterString) - 11
              ELSE 20 END);
     SET @EmpID_GA = TRY_CAST(LTRIM(RTRIM(@p1)) AS INT);

     SELECT PermissionKey
     FROM dbo.mst_EmployeeMenuAccess
     WHERE EmployeeID = @EmpID_GA AND IsActive = 1;
 END

 ELSE IF (@Event = 'SaveEmployeeMenuAccess')
 BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Save Employee Menu Access.',16,1);
		RETURN;
	END
     DECLARE @EmpID_SA INT;
     DECLARE @p2 NVARCHAR(100) = SUBSTRING(@ParameterString,
         CHARINDEX('EmployeeID:', @ParameterString) + 11,
         CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('EmployeeID:', @ParameterString)) > 0
              THEN CHARINDEX('~!', @ParameterString, CHARINDEX('EmployeeID:', @ParameterString))
                   - CHARINDEX('EmployeeID:', @ParameterString) - 11
              ELSE 20 END);
     SET @EmpID_SA = TRY_CAST(LTRIM(RTRIM(@p2)) AS INT);

     DECLARE @KeysStart INT = CHARINDEX('PermissionKeys:', @ParameterString) + 15;
     DECLARE @KeysRaw NVARCHAR(MAX) = SUBSTRING(@ParameterString, @KeysStart, LEN(@ParameterString));
     DECLARE @KeysEnd2 INT = CHARINDEX('~!', @KeysRaw);
     DECLARE @Keys NVARCHAR(MAX) = LTRIM(RTRIM(
         CASE WHEN @KeysEnd2 > 0 THEN LEFT(@KeysRaw, @KeysEnd2 - 1) ELSE @KeysRaw END
     ));

     DELETE FROM dbo.mst_EmployeeMenuAccess WHERE EmployeeID = @EmpID_SA;

     INSERT INTO dbo.mst_EmployeeMenuAccess (EmployeeID, PermissionKey)
     SELECT @EmpID_SA, LTRIM(RTRIM(value))
     FROM STRING_SPLIT(@Keys, ',')
     WHERE LTRIM(RTRIM(value)) <> '';

     SELECT 'Success' AS Result;
 END

ELSE IF(@Event='SaveUserAllocation')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) NOT LIKE 'Admin'
    BEGIN
        RAISERROR('Only Admin can Save User Allocation.',16,1);
        RETURN;
    END

    DECLARE @ExistingUserProjectID INT;

    IF ISNULL(@ProjectID_Alloc,0)=0
        RAISERROR('ProjectID is required.',16,1);

    IF ISNULL(@OperatorID_Alloc,0)=0
        RAISERROR('OperatorID is required.',16,1);

    IF @StartDate_Alloc IS NULL
        SET @StartDate_Alloc = GETDATE();

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID_Alloc
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can allocate users only to your assigned division projects.',16,1);
            RETURN;
        END
    END

    SELECT TOP 1
        @ExistingUserProjectID = ProjectID
    FROM dbo.trn_ProjectUserAllocation
    WHERE OperatorID = @OperatorID_Alloc
      AND ISNULL(IsActive,1)=1
      AND EndDate IS NULL
    ORDER BY ID DESC;

    IF ISNULL(@ExistingUserProjectID,0) <> 0
       AND ISNULL(@ExistingUserProjectID,0) <> ISNULL(@ProjectID_Alloc,0)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM dbo.trn_DailyLog
            WHERE OperatorID = @OperatorID_Alloc
              AND SubmissionStatus = 'Draft'
        )
            RAISERROR('Cannot change operator project because an active log exists. Please end the log first.',16,1);

        IF EXISTS (
            SELECT 1
            FROM dbo.trn_MachineOperatorAllocation
            WHERE OperatorID = @OperatorID_Alloc
              AND ISNULL(IsActive,1)=1
              AND EndDate IS NULL
        )
            RAISERROR('Cannot change operator project because the operator is still assigned to a machine. Please release the machine operator allocation first.',16,1);

        RAISERROR('Operator is already allocated to another project. Please release the current project allocation first.',16,1);
    END

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.trn_ProjectUserAllocation
        WHERE ProjectID = @ProjectID_Alloc
          AND OperatorID = @OperatorID_Alloc
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
    )
    BEGIN
        INSERT INTO dbo.trn_ProjectUserAllocation
        (
            OperatorID,
            ProjectID,
            StartDate,
            EndDate,
            Remarks,
            ModifiedBy,
            CreatedAt,
            UpdatedAt,
            IsActive,
            ModifiedOn
        )
        VALUES
        (
            @OperatorID_Alloc,
            @ProjectID_Alloc,
            @StartDate_Alloc,
            NULL,
            ISNULL(NULLIF(@Remarks_Alloc,''),'User Allocation'),
            @AuthEmployeeID,
            GETDATE(),
            GETDATE(),
            1,
            GETDATE()
        );

        SELECT 'Success' AS Status, CAST(SCOPE_IDENTITY() AS INT) AS NewID;
    END
    ELSE
    BEGIN
        SELECT 'AlreadyExists' AS Status, 0 AS NewID;
    END
END

ELSE IF(@Event='ReleaseUserAllocation')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) NOT LIKE 'Admin'
    BEGIN
        RAISERROR('Only Admin can Release User Allocation.',16,1);
        RETURN;
    END

    IF ISNULL(@ProjectID_Alloc,0)=0
        RAISERROR('ProjectID is required.',16,1);

    IF ISNULL(@OperatorID_Alloc,0)=0
        RAISERROR('OperatorID is required.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID_Alloc
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can release user allocations only from your assigned division projects.',16,1);
            RETURN;
        END
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_DailyLog
        WHERE OperatorID = @OperatorID_Alloc
          AND SubmissionStatus = 'Draft'
    )
        RAISERROR('Cannot release operator because an active log exists. Please end the log first.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_MachineOperatorAllocation
        WHERE ProjectID = @ProjectID_Alloc
          AND OperatorID = @OperatorID_Alloc
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
    )
        RAISERROR('Cannot release operator from project because the operator is still assigned to a machine. Please release the machine operator allocation first.',16,1);

    UPDATE dbo.trn_ProjectUserAllocation
    SET
        EndDate = GETDATE(),
        IsActive = 0,
        ModifiedBy = @AuthEmployeeID,
        UpdatedAt = GETDATE(),
        ModifiedOn = GETDATE()
    WHERE ProjectID = @ProjectID_Alloc
      AND OperatorID = @OperatorID_Alloc
      AND ISNULL(IsActive,1)=1
      AND EndDate IS NULL;

    UPDATE dbo.trn_MachineOperatorAllocation
    SET
        EndDate = CAST(GETDATE() AS DATE),
        IsActive = 0,
        ModifiedBy = @AuthEmployeeID,
        UpdatedAt = GETDATE()
    WHERE ProjectID = @ProjectID_Alloc
      AND OperatorID = @OperatorID_Alloc
      AND ISNULL(IsActive,1)=1
      AND EndDate IS NULL;

    SELECT 'Success' AS Status, @@ROWCOUNT AS RowsAffected;
END

ELSE IF(@Event='SaveMachineOperatorAllocation')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
    BEGIN
        RAISERROR('Only Admin can SaveMachineOperatorAllocation.',16,1);
        RETURN;
    END

    SELECT
        @EffectiveAssetID =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID, @AssetID);

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF ISNULL(@ProjectID_Alloc,0)=0
        RAISERROR('ProjectID is required.',16,1);

    IF ISNULL(@OperatorID_Alloc,0)=0
        RAISERROR('OperatorID is required.',16,1);

    IF @StartDate_Alloc IS NULL
        SET @StartDate_Alloc = GETDATE();

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID_Alloc
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can allocate machine operators only for your assigned division projects.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can allocate only your assigned division assets.',16,1);
            RETURN;
        END
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_DailyLog
        WHERE AssetID = @AssetID
          AND SubmissionStatus = 'Draft'
    )
        RAISERROR('Cannot assign operator because this machine has an active log. Please end the log first.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_DailyLog
        WHERE OperatorID = @OperatorID_Alloc
          AND AssetID <> @AssetID
          AND SubmissionStatus = 'Draft'
    )
        RAISERROR('Cannot assign operator because the operator has an active log on another machine. Please end the log first.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.trn_ProjectMachineAllocation
        WHERE AssetID = @AssetID
          AND ProjectID = @ProjectID_Alloc
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
    )
        RAISERROR('Selected machine is not allocated to this project.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.trn_ProjectUserAllocation
        WHERE ProjectID = @ProjectID_Alloc
          AND OperatorID = @OperatorID_Alloc
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
    )
        RAISERROR('Selected operator is not allocated to this project.',16,1);

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.trn_MachineOperatorAllocation
        WHERE AssetID = @AssetID
          AND ProjectID = @ProjectID_Alloc
          AND OperatorID = @OperatorID_Alloc
          AND ISNULL(IsActive,1)=1
          AND EndDate IS NULL
    )
    BEGIN
        INSERT INTO dbo.trn_MachineOperatorAllocation
        (
            AssetID,
            OperatorID,
            ProjectID,
            StartDate,
            EndDate,
            Remarks,
            ModifiedBy,
            CreatedAt,
            UpdatedAt,
            IsActive
        )
        VALUES
        (
            @AssetID,
            @OperatorID_Alloc,
            @ProjectID_Alloc,
            @StartDate_Alloc,
            NULL,
            ISNULL(NULLIF(@Remarks_Alloc,''),'Machine Operator Allocation'),
            @AuthEmployeeID,
            GETDATE(),
            GETDATE(),
            1
        );

        SELECT 'Success' AS Status, CAST(SCOPE_IDENTITY() AS INT) AS NewID;
    END
    ELSE
    BEGIN
        SELECT 'AlreadyExists' AS Status, 0 AS NewID;
    END
END

ELSE IF(@Event='ReleaseMachineOperatorAllocation')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
    BEGIN
        RAISERROR('Only Admin can ReleaseMachineOperatorAllocation.',16,1);
        RETURN;
    END
    SELECT
        @EffectiveAssetID =
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN EXISTS (
                    SELECT 1
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                )
                THEN (
                    SELECT TOP 1 am.VirtualAssetID
                    FROM dbo.trn_AssetMounting am
                    WHERE ISNULL(am.IsActive,1)=1
                      AND am.UnmountedOn IS NULL
                      AND (am.ChassisAssetID = a.AssetID OR am.UpperAssetID = a.AssetID)
                    ORDER BY am.MountingID DESC
                )
                ELSE a.AssetID
            END
    FROM dbo.mst_Asset a
    WHERE a.AssetID = @AssetID
      AND ISNULL(a.IsActive,1)=1;

    SET @AssetID = ISNULL(@EffectiveAssetID, @AssetID);

    IF ISNULL(@AssetID,0)=0
        RAISERROR('AssetID is required.',16,1);

    IF ISNULL(@ProjectID_Alloc,0)=0
        RAISERROR('ProjectID is required.',16,1);

    IF ISNULL(@ScopeDivisionID,0) <> 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Project p
            WHERE p.ProjectID = @ProjectID_Alloc
              AND p.DivisionID = @ScopeDivisionID
              AND ISNULL(p.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can release machine operators only from your assigned division projects.',16,1);
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.mst_Asset a
            WHERE a.AssetID = @AssetID
              AND a.DivisionID = @ScopeDivisionID
              AND ISNULL(a.IsActive,1)=1
        )
        BEGIN
            RAISERROR('You can release only your assigned division assets.',16,1);
            RETURN;
        END
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_DailyLog
        WHERE AssetID = @AssetID
          AND SubmissionStatus = 'Draft'
          AND (@OperatorID_Alloc IS NULL OR @OperatorID_Alloc = 0 OR OperatorID = @OperatorID_Alloc)
    )
        RAISERROR('Cannot release machine operator because an active log exists. Please end the log first.',16,1);

    UPDATE dbo.trn_MachineOperatorAllocation
    SET
        EndDate = GETDATE(),
        IsActive = 0,
        ModifiedBy = @AuthEmployeeID,
        UpdatedAt = GETDATE()
    WHERE AssetID = @AssetID
      AND ProjectID = @ProjectID_Alloc
      AND ISNULL(IsActive,1)=1
      AND EndDate IS NULL
      AND (@OperatorID_Alloc IS NULL OR @OperatorID_Alloc = 0 OR OperatorID = @OperatorID_Alloc);

    SELECT 'Success' AS Status, @@ROWCOUNT AS RowsAffected;
END

ELSE IF @Event = 'GetUserAllocations'
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        ua.ID AS UserAllocationID,
        ua.ProjectID,
        ua.OperatorID,
        ua.StartDate,
        ua.EndDate,
        ua.Remarks
    FROM dbo.trn_ProjectUserAllocation ua
    INNER JOIN dbo.mst_Project p
        ON p.ProjectID = ua.ProjectID
    WHERE ISNULL(ua.IsActive,1)=1
      AND (
            ISNULL(@ScopeDivisionID,0)=0
            OR p.DivisionID = @ScopeDivisionID
          )
    ORDER BY ua.ProjectID, ua.OperatorID, ua.StartDate DESC;
END

ELSE IF(@Event='GetMachineOperatorAllocations')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    ;WITH ActiveMount AS
    (
        SELECT
            am.MountCode,
            am.VirtualAssetID,
            am.ChassisAssetID,
            am.UpperAssetID
        FROM dbo.trn_AssetMounting am
        WHERE ISNULL(am.IsActive,1)=1
          AND am.UnmountedOn IS NULL
    ),
    AssetOperationalMap AS
    (
        SELECT
            a.AssetID AS BaseAssetID,
            CASE
                WHEN ISNULL(a.IsVirtualAsset,0)=1 THEN a.AssetID
                WHEN am.VirtualAssetID IS NOT NULL AND a.CategoryID IN (42,43) THEN am.VirtualAssetID
                ELSE a.AssetID
            END AS EffectiveAssetID
        FROM dbo.mst_Asset a
        LEFT JOIN ActiveMount am
            ON am.ChassisAssetID = a.AssetID
            OR am.UpperAssetID = a.AssetID
        WHERE ISNULL(a.IsActive,1)=1
    ),
    EffectiveAssets AS
    (
        SELECT
            ea.AssetID,
            ea.DivisionID,
            ea.IsVirtualAsset
        FROM dbo.mst_Asset ea
        WHERE ISNULL(ea.IsActive,1)=1
          AND (
                ISNULL(@ScopeDivisionID,0)=0
                OR ea.DivisionID = @ScopeDivisionID
              )
          AND (
                ISNULL(ea.IsVirtualAsset,0)=1
                OR NOT EXISTS
                (
                    SELECT 1
                    FROM ActiveMount amx
                    WHERE amx.ChassisAssetID = ea.AssetID
                       OR amx.UpperAssetID = ea.AssetID
                )
              )
    ),
    AllocationBase AS
    (
        SELECT
            moa.ID AS MachineOperatorAllocationID,
            map.EffectiveAssetID AS AssetID,
            moa.OperatorID,
            moa.ProjectID,
            moa.StartDate,
            moa.EndDate,
            moa.Remarks,
            ISNULL(moa.IsActive,1) AS IsActive,
            ROW_NUMBER() OVER
            (
                PARTITION BY map.EffectiveAssetID, moa.ProjectID, moa.OperatorID
                ORDER BY moa.ID DESC
            ) AS rn
        FROM dbo.trn_MachineOperatorAllocation moa
        INNER JOIN AssetOperationalMap map
            ON map.BaseAssetID = moa.AssetID
        WHERE moa.EndDate IS NULL
          AND ISNULL(moa.IsActive,1)=1
    )
    SELECT
        ab.MachineOperatorAllocationID,
        ab.AssetID,
        ab.OperatorID,
        ab.ProjectID,
        ab.StartDate,
        ab.EndDate,
        ab.Remarks
    FROM AllocationBase ab
    INNER JOIN EffectiveAssets ea
        ON ea.AssetID = ab.AssetID
    WHERE ab.rn = 1
    ORDER BY ab.ProjectID, ab.AssetID, ab.OperatorID;
END

 ELSE IF @Event = 'RemoveOperator'
 BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Remove Operator.',16,1);
		RETURN;
	END
     UPDATE trn_MachineOperatorAllocation
     SET    EndDate = CAST(GETDATE() AS DATE)
     WHERE  AssetID    = @AssetID
       AND  ProjectID  = @ProjectID_Alloc
       AND  OperatorID = @OperatorID_Alloc
       AND  EndDate    IS NULL

     SELECT 'Success' AS Status, @@ROWCOUNT AS RowsAffected
 END

-- Admin Master Division Event Start

ELSE IF (@Event = 'GetDivisionList')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    SELECT
        d.DivisionID,
        d.DivisionName,
        d.IsActive,
        d.CreatedBy,
        d.CreatedOn,
        d.ModifiedBy,
        d.ModifiedOn
    FROM dbo.mst_Division d
    ORDER BY d.DivisionName;
END

ELSE IF (@Event = 'AddDivision')
BEGIN
    SET @DivisionName = LTRIM(RTRIM(ISNULL(@DivisionName, '')));

    IF @DivisionName = ''
    BEGIN
        SELECT 0 AS Status, 'Division name is required.' AS Msg;
        RETURN;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.mst_Division
        WHERE LTRIM(RTRIM(DivisionName)) = @DivisionName
    )
    BEGIN
        SELECT 0 AS Status, 'Division name already exists.' AS Msg;
        RETURN;
    END;

    INSERT INTO dbo.mst_Division
    (
        DivisionName,
        IsActive,
        CreatedBy,
        CreatedOn
    )
    VALUES
    (
        @DivisionName,
        ISNULL(@IsActive, 1),
        ISNULL(@CreatedBy, 0),
        GETDATE()
    );

    SELECT
        1 AS Status,
        'Division added successfully.' AS Msg,
        CAST(SCOPE_IDENTITY() AS INT) AS DivisionID;
END

ELSE IF (@Event = 'EditDivision')
BEGIN
    SET @DivisionName = LTRIM(RTRIM(ISNULL(@DivisionName, '')));

    IF ISNULL(@DivisionID, 0) = 0
    BEGIN
        SELECT 0 AS Status, 'DivisionID is required.' AS Msg;
        RETURN;
    END;

    IF @DivisionName = ''
    BEGIN
        SELECT 0 AS Status, 'Division name is required.' AS Msg;
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.mst_Division
        WHERE DivisionID = @DivisionID
    )
    BEGIN
        SELECT 0 AS Status, 'Division not found.' AS Msg;
        RETURN;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.mst_Division
        WHERE LTRIM(RTRIM(DivisionName)) = @DivisionName
          AND DivisionID <> @DivisionID
    )
    BEGIN
        SELECT 0 AS Status, 'Division name already exists.' AS Msg;
        RETURN;
    END;

    UPDATE dbo.mst_Division
    SET
        DivisionName = @DivisionName,
        IsActive = ISNULL(@IsActive, IsActive),
        ModifiedBy = ISNULL(@ModifiedBy, 0),
        ModifiedOn = GETDATE()
    WHERE DivisionID = @DivisionID;

    SELECT
        1 AS Status,
        'Division updated successfully.' AS Msg,
        @DivisionID AS DivisionID;
END

ELSE IF (@Event = 'DeleteDivision')
BEGIN
    IF ISNULL(@DivisionID, 0) = 0
    BEGIN
        SELECT 0 AS Status, 'DivisionID is required.' AS Msg;
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.mst_Division
        WHERE DivisionID = @DivisionID
    )
    BEGIN
        SELECT 0 AS Status, 'Division not found.' AS Msg;
        RETURN;
    END;

    DELETE FROM dbo.mst_Division
    WHERE DivisionID = @DivisionID;

    SELECT
        1 AS Status,
        'Division deleted successfully.' AS Msg,
        @DivisionID AS DivisionID;
END

-- Admin Master Division Event End

-- Asset Make Start
ELSE IF (@Event = 'GetAssetMakeList')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT mk.MakeID, mk.AssetTypeID, st.SubTypeName, mk.MakeName, mk.IsActive, mk.CreatedBy, mk.CreatedOn, mk.ModifiedBy, mk.ModifiedOn
    FROM dbo.mst_AssetMake mk
    LEFT JOIN dbo.mst_AssetSubType st ON st.AssetTypeID = mk.AssetTypeID
    ORDER BY mk.MakeName;
END

ELSE IF (@Event = 'AddAssetMake')
BEGIN
    -- ... Auth Checks ...
    SET @MakeName = LTRIM(RTRIM(ISNULL(@MakeName,'')));
    IF ISNULL(@AssetTypeID,0) = 0 OR @MakeName = ''
    BEGIN
        SELECT 0 AS Status, 'Sub type and make name are required.' AS Msg;
        RETURN;
    END;

    INSERT INTO dbo.mst_AssetMake (MakeName, AssetTypeID, IsActive, CreatedBy, CreatedOn)
    VALUES (@MakeName, @AssetTypeID, ISNULL(@IsActive,1), ISNULL(@CreatedBy,0), GETDATE());

    SELECT 1 AS Status, 'Make added successfully.' AS Msg, CAST(SCOPE_IDENTITY() AS INT) AS MakeID;
END

ELSE IF (@Event = 'EditAssetMake')
BEGIN
    -- ... Auth Checks ...
    DECLARE @EditAssetTypeID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'AssetTypeID') AS INT);
    SET @MakeName = LTRIM(RTRIM(ISNULL(@MakeName,'')));
    -- ... Validation ...
    UPDATE dbo.mst_AssetMake
    SET MakeName = @MakeName,
        AssetTypeID = @EditAssetTypeID,
        IsActive = ISNULL(@IsActive, IsActive),
        ModifiedBy = ISNULL(@ModifiedBy,0),
        ModifiedOn = GETDATE()
    WHERE MakeID = @MakeID;

    SELECT 1 AS Status, 'Make updated successfully.' AS Msg, @MakeID AS MakeID;
END


ELSE IF (@Event = 'DeleteAssetMake')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Make.',16,1);
		RETURN;
	END
    IF ISNULL(@MakeID,0) = 0
    BEGIN
        SELECT 0 AS Status, 'MakeID is required.' AS Msg;
        RETURN;
    END;

    DELETE FROM dbo.mst_AssetMake WHERE MakeID = @MakeID;
    SELECT 1 AS Status, 'Make deleted successfully.' AS Msg, @MakeID AS MakeID;
END
-- Asset Make End

-- Asset SubType Start
ELSE IF (@Event = 'GetAssetSubTypeList')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT st.AssetTypeID, st.AssetTypeID, ac.AssetCatName, st.SubTypeName, st.IsActive, st.CreatedBy, st.CreatedOn, st.ModifiedBy, st.ModifiedOn
    FROM dbo.mst_AssetSubType st
    LEFT JOIN dbo.mst_AssetCat ac ON ac.CategoryID = st.CategoryID
    ORDER BY ac.AssetCatName, st.SubTypeName;
END

ELSE IF (@Event = 'AddAssetSubType')
BEGIN
    -- ... Auth Checks ...
    SET @SubTypeName = LTRIM(RTRIM(ISNULL(@SubTypeName,'')));
    IF ISNULL(@CategoryID,0) = 0 OR @SubTypeName = ''
    BEGIN
        SELECT 0 AS Status, 'Category and sub type name are required.' AS Msg;
        RETURN;
    END;

    INSERT INTO dbo.mst_AssetSubType (CategoryID, SubTypeName, IsActive, CreatedBy, CreatedOn)
    VALUES (@CategoryID, @SubTypeName, ISNULL(@IsActive,1), ISNULL(@CreatedBy,0), GETDATE());

    SELECT 1 AS Status, 'Sub type added successfully.' AS Msg, CAST(SCOPE_IDENTITY() AS INT) AS AssetTypeID;
END

ELSE IF (@Event = 'EditAssetSubType')
BEGIN
    -- ... Auth Checks ...
    DECLARE @EditCategoryID INT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'CategoryID') AS INT);
    SET @SubTypeName = LTRIM(RTRIM(ISNULL(@SubTypeName,'')));
    -- ... Validation ...
    UPDATE dbo.mst_AssetSubType
    SET CategoryID = @EditCategoryID,
        SubTypeName = @SubTypeName,
        IsActive = ISNULL(@IsActive, IsActive),
        ModifiedBy = ISNULL(@ModifiedBy,0),
        ModifiedOn = GETDATE()
    WHERE AssetTypeID = @AssetTypeID;

    SELECT 1 AS Status, 'Sub type updated successfully.' AS Msg, @AssetTypeID AS AssetTypeID;
END


ELSE IF (@Event = 'DeleteAssetSubType')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Asset SubType.',16,1);
		RETURN;
	END
    IF ISNULL(@AssetTypeID,0) = 0
    BEGIN
        SELECT 0 AS Status, 'AssetTypeID is required.' AS Msg;
        RETURN;
    END;

    DELETE FROM dbo.mst_AssetSubType WHERE AssetTypeID = @AssetTypeID;
    SELECT 1 AS Status, 'Sub type deleted successfully.' AS Msg, @AssetTypeID AS AssetTypeID;
END
-- Asset SubType End

-- Asset Model Start
ELSE IF (@Event = 'GetAssetModelList')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT 
        md.ModelID, 
        md.MakeID, 
        mk.MakeName, 
        md.AssetTypeID, 
        st.SubTypeName, 
        st.CategoryID, 
        st.SubTypeName AS AssetCatName,  -- Groups models under SubType Name
        md.ModelNo, 
        md.IsActive, 
        md.CreatedBy, 
        md.CreatedOn, 
        md.ModifiedBy, 
        md.ModifiedOn
    FROM dbo.mst_AssetModel md
    LEFT JOIN dbo.mst_AssetMake mk ON mk.MakeID = md.MakeID
    LEFT JOIN dbo.mst_AssetSubType st ON st.AssetTypeID = md.AssetTypeID
    ORDER BY st.SubTypeName, mk.MakeName, md.ModelNo;
END



ELSE IF (@Event = 'AddAssetModel')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Add Asset Model.',16,1);
		RETURN;
	END
    SET @ModelNo = LTRIM(RTRIM(ISNULL(@ModelNo,'')));
    IF ISNULL(@MakeID,0) = 0 OR ISNULL(@AssetTypeID,0) = 0 OR @ModelNo = ''
    BEGIN
        SELECT 0 AS Status, 'Make, sub type and model no are required.' AS Msg;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM dbo.mst_AssetModel WHERE MakeID = @MakeID AND AssetTypeID = @AssetTypeID AND LTRIM(RTRIM(ModelNo)) = @ModelNo)
    BEGIN
        SELECT 0 AS Status, 'Model already exists for selected make and sub type.' AS Msg;
        RETURN;
    END;

    INSERT INTO dbo.mst_AssetModel (MakeID, AssetTypeID, ModelNo, IsActive, CreatedBy, CreatedOn)
    VALUES (@MakeID, @AssetTypeID, @ModelNo, ISNULL(@IsActive,1), ISNULL(@CreatedBy,0), GETDATE());

    SELECT 1 AS Status, 'Model added successfully.' AS Msg, CAST(SCOPE_IDENTITY() AS INT) AS ModelID;
END

ELSE IF (@Event = 'EditAssetModel')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Edit Asset Model.',16,1);
		RETURN;
	END
    SET @ModelNo = LTRIM(RTRIM(ISNULL(@ModelNo,'')));
    IF ISNULL(@ModelID,0) = 0
    BEGIN
        SELECT 0 AS Status, 'ModelID is required.' AS Msg;
        RETURN;
    END;

    IF ISNULL(@MakeID,0) = 0 OR ISNULL(@AssetTypeID,0) = 0 OR @ModelNo = ''
    BEGIN
        SELECT 0 AS Status, 'Make, sub type and model no are required.' AS Msg;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM dbo.mst_AssetModel WHERE MakeID = @MakeID AND AssetTypeID = @AssetTypeID AND LTRIM(RTRIM(ModelNo)) = @ModelNo AND ModelID <> @ModelID)
    BEGIN
        SELECT 0 AS Status, 'Model already exists for selected make and sub type.' AS Msg;
        RETURN;
    END;

    UPDATE dbo.mst_AssetModel
    SET MakeID = @MakeID,
        AssetTypeID = @AssetTypeID,
        ModelNo = @ModelNo,
        IsActive = ISNULL(@IsActive, IsActive),
        ModifiedBy = ISNULL(@ModifiedBy,0),
        ModifiedOn = GETDATE()
    WHERE ModelID = @ModelID;

    SELECT 1 AS Status, 'Model updated successfully.' AS Msg, @ModelID AS ModelID;
END

ELSE IF (@Event = 'DeleteAssetModel')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can DeleteAsset Model.',16,1);
		RETURN;
	END
    IF ISNULL(@ModelID,0) = 0
    BEGIN
        SELECT 0 AS Status, 'ModelID is required.' AS Msg;
        RETURN;
    END;

    DELETE FROM dbo.mst_AssetModel WHERE ModelID = @ModelID;
    SELECT 1 AS Status, 'Model deleted successfully.' AS Msg, @ModelID AS ModelID;
END

ELSE IF (@Event = 'GetOwnershipTypeList')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
    SELECT
        OwnershipTypeID,
        OwnershipTypeName,
        IsActive,
        SortOrder,
        CreatedBy,
        CreatedOn,
        ModifiedBy,
        ModifiedOn
    FROM dbo.mst_OwnershipType
    WHERE ISNULL(IsActive, 1) = 1
    ORDER BY SortOrder, OwnershipTypeName;
END

ELSE IF(@Event='AddConcreteProductionEntry')
 BEGIN

     DECLARE @StopDateTime DATETIME;
 
     SET @StartDateTime = DATEADD(MINUTE, ISNULL(@form1_ddl_start_minute,0),
                         DATEADD(HOUR, ISNULL(@form1_ddl_start_hour,0), CAST(@form1_text_start_date AS DATETIME)));
 
     SET @StopDateTime = DATEADD(MINUTE, ISNULL(@form1_ddl_stop_minute,0),
                        DATEADD(HOUR, ISNULL(@form1_ddl_stop_hour,0), CAST(@form1_text_stop_date AS DATETIME)));
 
     SET @empid = COALESCE(
         NULLIF(@empid,''),
         NULLIF(@EmpID,''),
         NULLIF(@EmployeeID,''),
         NULLIF(@CreatedBy,''),
         NULLIF(@form1_CreatedBy,''),
         NULLIF(@form1_mis_session_userid,''),
         NULLIF(@mis_session_userid,'')
     );
 
     INSERT INTO dbo.trn_ConcreteProductionEntry
     (
         InfoProviderEmployeeID,
         CustomerID,
         SiteID,
         PlantID,
         StartDateTime,
         StopDateTime,
         BreakdownHours,
         BreakdownMinutes,
         Volume,
         DieselReceived,
         DieselRate,
         CementReceivedKg,
         HMR,
         MixerHMR,
         ConcreteType,
         PourLocation,
         InChargeCustomer,
         InChargeRohan,
         NoteText,
         CreatedBy,
         CreatedDate,
         IsActive
     )
     VALUES
     (
         @form1_ddl_info_provider,
         @form1_ddl_customer,
         @form1_ddl_site,
         @form1_ddl_plant,
         @StartDateTime,
         @StopDateTime,
         ISNULL(@form1_ddl_breakdown_hour,0),
         ISNULL(@form1_ddl_breakdown_minute,0),
         ISNULL(@form1_text_volume,0),
         ISNULL(@form1_text_diesel_received,0),
         ISNULL(@form1_text_diesel_rate,0),
         ISNULL(@form1_text_cement_received,0),
         ISNULL(@form1_text_hmr,0),
         ISNULL(@form1_text_mixer_hmr,0),
         @form1_ddl_concrete_type,
         @form1_ddl_pour_location,
         @form1_text_incharge_customer,
         @form1_text_incharge_rohan,
         @form1_text_note,
         TRY_CAST(@empid AS INT),
         GETDATE(),
         1
     );
 
     SELECT 'Success' AS Status,'Concrete Production Entry saved successfully.' AS Msg;
 END

ELSE IF (@Event = 'BindRecentEntry')
BEGIN
    SELECT TOP 50
        CAST(cpe.ConcreteEntryID AS varchar(50)) AS Value,
        CAST(cpe.ConcreteEntryID AS varchar(50)) + ': ' +
        CONVERT(varchar(10), cpe.StartDateTime, 103) + '-' +
        ISNULL(a.AssetName, CAST(cpe.PlantID AS varchar(50))) AS Text
    FROM dbo.trn_ConcreteProductionEntry cpe
    LEFT JOIN dbo.mst_Asset a
        ON CAST(a.AssetID AS varchar(50)) = CAST(cpe.PlantID AS varchar(50))
    WHERE ISNULL(cpe.IsActive, 1) = 1
    ORDER BY cpe.ConcreteEntryID DESC;
END

ELSE IF (@Event = 'BindLoadEntry')
BEGIN
    SELECT TOP 1
        cpe.ConcreteEntryID,
        cpe.InfoProviderEmployeeID,
        cpe.CustomerID,
        cpe.SiteID,
        cpe.PlantID,
        cpe.StartDateTime,
        cpe.StopDateTime,
        cpe.BreakdownHours,
        cpe.BreakdownMinutes,
        cpe.Volume,
        cpe.DieselReceived,
        cpe.DieselRate,
        cpe.CementReceivedKg,
        cpe.HMR,
        cpe.MixerHMR,
        cpe.ConcreteType,
        cpe.PourLocation,
        cpe.InChargeCustomer,
        cpe.InChargeRohan,
        cpe.NoteText
    FROM dbo.trn_ConcreteProductionEntry cpe
    WHERE cpe.ConcreteEntryID = TRY_CAST(@form1_ddl_recent_entry AS bigint)
      AND ISNULL(cpe.IsActive, 1) = 1;
END


ELSE IF (@Event = 'GetConcreteProductionLastEntryDate')
BEGIN
    SELECT TOP 1
        CONVERT(varchar(10), StartDateTime, 103) AS LastEntryDate,
        StartDateTime
    FROM dbo.trn_ConcreteProductionEntry
    WHERE CAST(PlantID AS varchar(50)) = CAST(@AssetID AS varchar(50))
       OR CAST(PlantID AS varchar(50)) = CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PlantID') AS varchar(50))
    AND ISNULL(IsActive, 1) = 1
    ORDER BY StartDateTime DESC, ConcreteEntryID DESC;
END

ELSE IF (@Event = 'GetRoleMenuAccess')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    DECLARE @RoleID_Get INT =
        TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'RoleID') AS INT);

    SELECT
        rmp.RoleID,
        mp.PermissionID,
        mp.PermissionKey,
        mp.MenuName,
        mp.SortOrder
    FROM dbo.mst_RoleMenuPermission rmp
    INNER JOIN dbo.mst_MenuPermission mp
        ON mp.PermissionID = rmp.PermissionID
    WHERE rmp.RoleID = @RoleID_Get
      AND ISNULL(rmp.IsActive,1) = 1
      AND ISNULL(mp.IsActive,1) = 1
    ORDER BY mp.SortOrder, mp.MenuName;
END

ELSE IF (@Event = 'SaveRoleMenuAccess')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Save Role Menu Access.',16,1);
		RETURN;
	END
    DECLARE @RoleID_Save INT =
        TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'RoleID') AS INT);

    DECLARE @PermissionKeys_Save NVARCHAR(MAX) =
        DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'PermissionKeys');

    IF ISNULL(@RoleID_Save,0) = 0
        RAISERROR('RoleID is required.',16,1);

    UPDATE dbo.mst_RoleMenuPermission
    SET IsActive = 0
    WHERE RoleID = @RoleID_Save;

    ;WITH PermissionCTE AS
    (
        SELECT LTRIM(RTRIM(value)) AS PermissionKey
        FROM STRING_SPLIT(ISNULL(@PermissionKeys_Save,''), ',')
        WHERE LTRIM(RTRIM(value)) <> ''
    )
    INSERT INTO dbo.mst_RoleMenuPermission
    (
        RoleID,
        PermissionID,
        IsActive
    )
    SELECT
        @RoleID_Save,
        mp.PermissionID,
        1
    FROM PermissionCTE c
    INNER JOIN dbo.mst_MenuPermission mp
        ON mp.PermissionKey = c.PermissionKey
    WHERE ISNULL(mp.IsActive,1) = 1;

    SELECT 'Success' AS Status, 'Role menu access saved successfully.' AS Msg;
END

ELSE IF (@Event = 'GetUserMenuPermissions')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    DECLARE @EmployeeID_Get INT =
        TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'EmployeeID') AS INT);

   SELECT
    ur.EmployeeID,
    ur.RoleID,
    r.RoleName,
    mp.PermissionID,
    mp.PermissionKey,
    mp.MenuName,
    mp.SortOrder,
    mp.ParentPermissionKey,
    mp.MenuType,
    mp.ViewName,
    mp.IconClass,
    mp.IsVisible
FROM dbo.mst_UserRole ur
INNER JOIN dbo.mst_Role r
    ON r.RoleID = ur.RoleID
INNER JOIN dbo.mst_RoleMenuPermission rmp
    ON rmp.RoleID = ur.RoleID
   AND ISNULL(rmp.IsActive,1) = 1
INNER JOIN dbo.mst_MenuPermission mp
    ON mp.PermissionID = rmp.PermissionID
   AND ISNULL(mp.IsActive,1) = 1
WHERE ur.EmployeeID = @EmployeeID_Get
  AND ISNULL(ur.IsActive,1) = 1
ORDER BY mp.SortOrder, mp.MenuName;

END


ELSE IF (@Event = 'GetAllMenuPermissions')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
    SELECT
        PermissionID,
        PermissionKey,
        MenuName,
        SortOrder,
        IsActive,
        ParentPermissionKey,
        MenuType,
        ViewName,
        IconClass,
        IsVisible
    FROM dbo.mst_MenuPermission
    WHERE ISNULL(IsActive,1) = 1
    ORDER BY SortOrder, MenuName;
END

ELSE IF (@Event = 'SaveRoleMenuAccess')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can modify project master.',16,1);
		RETURN;
	END
    IF ISNULL(@RoleID_Save,0) = 0
        RAISERROR('RoleID is required.',16,1);

    UPDATE dbo.mst_RoleMenuPermission
    SET IsActive = 0
    WHERE RoleID = @RoleID_Save;

    ;WITH PermissionCTE AS
    (
        SELECT LTRIM(RTRIM(value)) AS PermissionKey
        FROM STRING_SPLIT(ISNULL(@PermissionKeys_Save,''), ',')
        WHERE LTRIM(RTRIM(value)) <> ''
    )
    INSERT INTO dbo.mst_RoleMenuPermission
    (
        RoleID,
        PermissionID,
        IsActive
    )
    SELECT
        @RoleID_Save,
        mp.PermissionID,
        1
    FROM PermissionCTE c
    INNER JOIN dbo.mst_MenuPermission mp
        ON mp.PermissionKey = c.PermissionKey
    WHERE ISNULL(mp.IsActive,1) = 1;

    SELECT 'Success' AS Status, 'Role menu access saved successfully.' AS Msg;
END

ELSE IF(@Event='SaveMenuPermission')
 BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can SaveMenuPermission.',16,1);
		RETURN;
	END
     IF ISNULL(@PermissionID, 0) = 0
     BEGIN
         INSERT INTO dbo.mst_MenuPermission
             (PermissionKey, MenuName, MenuType, ParentPermissionKey,
              SortOrder, IsActive, IsVisible, ViewName, IconClass)
         VALUES
             (LTRIM(RTRIM(@PermissionKey)),
              LTRIM(RTRIM(@MenuName)),
              ISNULL(@MenuType, 'main'),
              NULLIF(LTRIM(RTRIM(ISNULL(@ParentPermissionKey,''))), ''),
              ISNULL(@SortOrder_Menu, 0),
              ISNULL(@IsActive, 1),
              ISNULL(@IsVisible, 1),
              NULLIF(LTRIM(RTRIM(ISNULL(@ViewName,''))), ''),
              NULLIF(LTRIM(RTRIM(ISNULL(@IconClass,''))), ''));
 
         DECLARE @NewPermissionID INT = SCOPE_IDENTITY();
         INSERT INTO dbo.mst_RoleMenuPermission (RoleID, PermissionID, IsActive)
         SELECT 1, @NewPermissionID, 1
         WHERE NOT EXISTS (
             SELECT 1 FROM dbo.mst_RoleMenuPermission
             WHERE RoleID = 1 AND PermissionID = @NewPermissionID
         );
 
         SELECT 1 AS Status, 'Menu saved successfully.' AS Msg;

     END
     ELSE
     BEGIN
         UPDATE dbo.mst_MenuPermission
         SET
             PermissionKey       = LTRIM(RTRIM(@PermissionKey)),
             MenuName            = LTRIM(RTRIM(@MenuName)),
             MenuType            = ISNULL(@MenuType, 'main'),
             ParentPermissionKey = NULLIF(LTRIM(RTRIM(ISNULL(@ParentPermissionKey,''))), ''),
             SortOrder           = ISNULL(@SortOrder_Menu, 0),
             IsActive            = ISNULL(@IsActive, 1),
             IsVisible           = ISNULL(@IsVisible, 1),
             ViewName            = NULLIF(LTRIM(RTRIM(ISNULL(@ViewName,''))), ''),
             IconClass           = NULLIF(LTRIM(RTRIM(ISNULL(@IconClass,''))), '')
         WHERE PermissionID = @PermissionID;
 
         SELECT 1 AS Status, 'Menu updated successfully.' AS Msg;
     END
 END
 
 ELSE IF(@Event='DeleteMenuPermission')
 BEGIN
 IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Menu Permission.',16,1);
		RETURN;
	END
     DECLARE @DeletePermissionID INT;
 
     SELECT TOP 1 @DeletePermissionID = PermissionID
     FROM dbo.mst_MenuPermission
     WHERE
         (ISNULL(@PermissionID,0) > 0 AND PermissionID = @PermissionID)
         OR (ISNULL(@PermissionKey,'') <> '' AND PermissionKey = LTRIM(RTRIM(@PermissionKey)));
 
     IF ISNULL(@DeletePermissionID, 0) = 0
     BEGIN
         SELECT 0 AS Status, 'Menu not found.' AS Msg;
         RETURN;
     END
 
     DELETE FROM dbo.mst_RoleMenuPermission WHERE PermissionID = @DeletePermissionID;
     DELETE FROM dbo.mst_MenuPermission WHERE PermissionID = @DeletePermissionID;
 
     SELECT 1 AS Status, 'Menu deleted successfully.' AS Msg;
 END


 ELSE IF(@Event='GetAllAssetDocumentFields')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    SELECT
        f.DocumentFieldID,
        f.DocumentTypeID,
        d.DocumentTypeName,
        f.FieldName,
        f.FieldLabel,
        f.FieldDataType,
        f.FieldOptions,
        f.IsMandatory,
        f.SortOrder,
        f.IsActive
    FROM dbo.mst_AssetDocumentTypeField f
    INNER JOIN dbo.mst_AssetDocumentType d
        ON d.DocumentTypeID = f.DocumentTypeID
    WHERE ISNULL(f.IsActive,1) = 1
      AND ISNULL(d.IsActive,1) = 1
    ORDER BY d.DocumentTypeName, f.SortOrder, f.DocumentFieldID;
END


 ELSE IF(@Event='GetAssetDocumentTypeMaster')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    SELECT
        d.DocumentTypeID,
        d.DocumentTypeCode,
        d.DocumentTypeName AS DocumentType,
        d.CategoryName AS Category,
        d.AuthorityName AS Authority,
        d.Notes,
        STUFF((
            SELECT ', ' + f.FieldLabel
            FROM dbo.mst_AssetDocumentTypeField f
            WHERE f.DocumentTypeID = d.DocumentTypeID
              AND ISNULL(f.IsActive,1) = 1
            ORDER BY f.SortOrder, f.DocumentFieldID
            FOR XML PATH(''), TYPE
        ).value('.', 'nvarchar(max)'), 1, 2, '') AS FieldsToMaintain,
        d.IsRecurring,
        d.SortOrder,
        d.IsActive
    FROM dbo.mst_AssetDocumentType d
    WHERE ISNULL(d.IsActive,1) = 1
    ORDER BY d.SortOrder, d.DocumentTypeName;
END

ELSE IF(@Event='GetAssetDocumentTypeFields')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    SELECT
        f.DocumentFieldID,
        f.DocumentTypeID,
        f.FieldName,
        f.FieldLabel,
        f.FieldDataType,
        f.FieldOptions,
        f.IsMandatory,
        f.SortOrder,
        f.IsActive
    FROM dbo.mst_AssetDocumentTypeField f
    WHERE f.DocumentTypeID = @DocumentTypeID
      AND ISNULL(f.IsActive,1) = 1
    ORDER BY f.SortOrder, f.DocumentFieldID;
END

ELSE IF(@Event='AddAssetDocumentAttachment')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Add Asset Document Attachment.',16,1);
		RETURN;
	END
    DECLARE @NewAttachmentID INT,
            @AttachmentCode VARCHAR(50),
            @NextSeq INT;

    IF ISNULL(@AssetID,0) = 0
        RAISERROR('AssetID is required.',16,1);

    IF ISNULL(@DocumentTypeID,0) = 0
        RAISERROR('DocumentTypeID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@FilePath)),'') = ''
        RAISERROR('FilePath is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@FileName)),'') = ''
        RAISERROR('FileName is required.',16,1);

    SELECT @NextSeq = ISNULL(MAX(TRY_CAST(RIGHT(AttachmentCode,4) AS INT)),0) + 1
    FROM dbo.trn_AssetDocumentAttachment
    WHERE AssetID = @AssetID
      AND DocumentTypeID = @DocumentTypeID;

    SET @AttachmentCode =
        'A' + CAST(@AssetID AS VARCHAR(20)) +
        '-D' + CAST(@DocumentTypeID AS VARCHAR(20)) +
        '-' + RIGHT('0000' + CAST(@NextSeq AS VARCHAR(10)), 4);

    INSERT INTO dbo.trn_AssetDocumentAttachment
    (
        AttachmentCode,
        AssetID,
        DocumentTypeID,
        SiteID,
        FilePath,
        FileName,
        FileType,
        FileExtension,
        FileSizeKB,
        Remarks,
        UploadDate,
        IsActive,
        CreatedBy,
        CreatedDate
    )
    VALUES
    (
        @AttachmentCode,
        @AssetID,
        @DocumentTypeID,
        @SiteID,
        @FilePath,
        @FileName,
        @TemplateID,
        @FileExtension,
        @FileSizeKB,
        @Notes_Document,
        GETDATE(),
        1,
        @CreatedBy,
        GETDATE()
    );

    SET @NewAttachmentID = SCOPE_IDENTITY();

    IF ISNULL(LTRIM(RTRIM(@FieldsJson)),'') <> ''
		BEGIN
			INSERT INTO dbo.trn_AssetDocumentAttachmentDetail
			(
				AttachmentID,
				DocumentFieldID,
				FieldValue,
				IsActive,
				CreatedBy,
				CreatedDate
			)
			SELECT
				@NewAttachmentID,
				f.DocumentFieldID,
				j.[value],
				1,
				@CreatedBy,
				GETDATE()
			FROM OPENJSON(@FieldsJson) j
			INNER JOIN dbo.mst_AssetDocumentTypeField f
				ON f.DocumentTypeID = @DocumentTypeID
			   AND f.FieldName COLLATE Latin1_General_BIN2 = j.[key] COLLATE Latin1_General_BIN2
			   AND ISNULL(f.IsActive,1) = 1;
		END


    SELECT
        1 AS Status,
        'Document attachment saved successfully.' AS Msg,
        @NewAttachmentID AS AttachmentID,
        @AttachmentCode AS AttachmentCode;
END

ELSE IF(@Event='GetAssetDocumentAttachments')
BEGIN
	IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END
    SELECT
        a.AttachmentID,
        a.AttachmentCode,
        a.AssetID,
        a.DocumentTypeID,
        d.DocumentTypeName AS DocumentType,
        d.CategoryName AS Category,
        d.AuthorityName AS Authority,
        d.Notes,
        a.SiteID,
        p.ProjectName AS SiteName,
        a.FilePath,
        a.FileName,
        a.FileType,
        a.FileExtension,
        a.FileSizeKB,
        a.Remarks,
        a.UploadDate,
        a.CreatedBy,
        a.CreatedDate,
        a.IsActive,
        (
            SELECT
                f.FieldName,
                f.FieldLabel,
                ad.FieldValue
            FROM dbo.trn_AssetDocumentAttachmentDetail ad
            INNER JOIN dbo.mst_AssetDocumentTypeField f
                ON f.DocumentFieldID = ad.DocumentFieldID
            WHERE ad.AttachmentID = a.AttachmentID
              AND ISNULL(ad.IsActive,1) = 1
            ORDER BY f.SortOrder, f.DocumentFieldID
            FOR JSON PATH
        ) AS FieldsJson
    FROM dbo.trn_AssetDocumentAttachment a
    INNER JOIN dbo.mst_AssetDocumentType d
        ON d.DocumentTypeID = a.DocumentTypeID
    LEFT JOIN dbo.mst_Project p
        ON p.ProjectID = a.SiteID
    WHERE ISNULL(a.IsActive,1) = 1
      AND (ISNULL(@AssetID,0) = 0 OR a.AssetID = @AssetID)
      AND (ISNULL(@DocumentTypeID,0) = 0 OR a.DocumentTypeID = @DocumentTypeID)
    ORDER BY a.CreatedDate DESC, a.AttachmentID DESC;
END


ELSE IF(@Event='DeleteAssetDocumentAttachment')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Asset Document Attachment.',16,1);
		RETURN;
	END
    IF ISNULL(@AttachmentID,0) = 0
        RAISERROR('AttachmentID is required.',16,1);

    UPDATE dbo.trn_AssetDocumentAttachment
    SET
        IsActive = 0,
        ModifiedBy = @CreatedBy,
        ModifiedDate = GETDATE()
    WHERE AttachmentID = @AttachmentID;

    UPDATE dbo.trn_AssetDocumentAttachmentDetail
    SET
        IsActive = 0,
        ModifiedBy = @CreatedBy,
        ModifiedDate = GETDATE()
    WHERE AttachmentID = @AttachmentID;

    SELECT 1 AS Status, 'Document attachment deleted successfully.' AS Msg;
END

ELSE IF(@Event='UpdateAssetDocumentAttachment')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Update Asset Document Attachment.',16,1);
		RETURN;
	END
    IF ISNULL(@AttachmentID,0) = 0
        RAISERROR('AttachmentID is required.',16,1);

    UPDATE dbo.trn_AssetDocumentAttachment
    SET
        DocumentTypeID = @DocumentTypeID,
        SiteID = @SiteID,
        FilePath = @FilePath,
        FileName = @FileName,
        FileType = @TemplateID,
        Remarks = @Notes_Document,
        ModifiedBy = @CreatedBy,
        ModifiedDate = GETDATE()
    WHERE AttachmentID = @AttachmentID;

    UPDATE dbo.trn_AssetDocumentAttachmentDetail
    SET
        IsActive = 0,
        ModifiedBy = @CreatedBy,
        ModifiedDate = GETDATE()
    WHERE AttachmentID = @AttachmentID;

    IF ISNULL(LTRIM(RTRIM(@FieldsJson)),'') <> ''
    BEGIN
        INSERT INTO dbo.trn_AssetDocumentAttachmentDetail
        (
            AttachmentID,
            DocumentFieldID,
            FieldValue,
            IsActive,
            CreatedBy,
            CreatedDate
        )
        SELECT
            @AttachmentID,
            f.DocumentFieldID,
            j.[value],
            1,
            @CreatedBy,
            GETDATE()
        FROM OPENJSON(@FieldsJson) j
        INNER JOIN dbo.mst_AssetDocumentTypeField f
            ON f.DocumentTypeID = @DocumentTypeID
           AND f.FieldName COLLATE Latin1_General_BIN2 = j.[key] COLLATE Latin1_General_BIN2
           AND ISNULL(f.IsActive,1) = 1;
    END

    SELECT 1 AS Status, 'Document attachment updated successfully.' AS Msg;
END

ELSE IF(@Event='GetAssetDocumentTypeFields')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    SELECT
        f.DocumentFieldID,
        f.DocumentTypeID,
        f.FieldName,
        f.FieldLabel,
        f.FieldDataType,
        f.FieldOptions,
        f.IsMandatory,
        f.SortOrder,
        f.IsActive,
        f.CreatedBy,
        f.CreatedDate,
        f.ModifiedBy,
        f.ModifiedDate
    FROM dbo.mst_AssetDocumentTypeField f
    WHERE f.DocumentTypeID = @DocumentTypeID
    ORDER BY f.SortOrder, f.DocumentFieldID;
END

ELSE IF(@Event='SaveAssetDocumentTypeField')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Save Asset Document TypeField.',16,1);
		RETURN;
	END
    IF ISNULL(@DocumentTypeID,0) = 0
        RAISERROR('DocumentTypeID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@FieldName)),'') = ''
        RAISERROR('FieldName is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@FieldLabel)),'') = ''
        RAISERROR('FieldLabel is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@FieldDataType)),'') = ''
        RAISERROR('FieldDataType is required.',16,1);

    IF EXISTS (
        SELECT 1
        FROM dbo.mst_AssetDocumentTypeField
        WHERE DocumentTypeID = @DocumentTypeID
          AND FieldName = @FieldName
          AND ISNULL(DocumentFieldID,0) <> ISNULL(@DocumentFieldID,0)
    )
    BEGIN
        RAISERROR('FieldName already exists for this document type.',16,1);
    END

    IF ISNULL(@DocumentFieldID,0) = 0
    BEGIN
        INSERT INTO dbo.mst_AssetDocumentTypeField
        (
            DocumentTypeID,
            FieldName,
            FieldLabel,
            FieldDataType,
            FieldOptions,
            IsMandatory,
            SortOrder,
            IsActive,
            CreatedBy,
            CreatedDate
        )
        VALUES
        (
            @DocumentTypeID,
            @FieldName,
            @FieldLabel,
            @FieldDataType,
            NULLIF(@FieldOptions,''),
            ISNULL(@IsMandatory,0),
            ISNULL(@SortOrder,0),
            ISNULL(@IsActive_Field,1),
            @CreatedBy,
            GETDATE()
        );

        SELECT 1 AS Status, 'Document field saved successfully.' AS Msg, SCOPE_IDENTITY() AS DocumentFieldID;
    END
    ELSE
    BEGIN
        UPDATE dbo.mst_AssetDocumentTypeField
        SET
            DocumentTypeID = @DocumentTypeID,
            FieldName = @FieldName,
            FieldLabel = @FieldLabel,
            FieldDataType = @FieldDataType,
            FieldOptions = NULLIF(@FieldOptions,''),
            IsMandatory = ISNULL(@IsMandatory,0),
            SortOrder = ISNULL(@SortOrder,0),
            IsActive = ISNULL(@IsActive_Field,1),
            ModifiedBy = @CreatedBy,
            ModifiedDate = GETDATE()
        WHERE DocumentFieldID = @DocumentFieldID;

        SELECT 1 AS Status, 'Document field updated successfully.' AS Msg, @DocumentFieldID AS DocumentFieldID;
    END
END


ELSE IF(@Event='DeleteAssetDocumentTypeField')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete Asset Document TypeField.',16,1);
		RETURN;
	END

    IF ISNULL(@DocumentFieldID,0) = 0
        RAISERROR('DocumentFieldID is required.',16,1);

    UPDATE dbo.mst_AssetDocumentTypeField
    SET
        IsActive = 0,
        ModifiedBy = @CreatedBy,
        ModifiedDate = GETDATE()
    WHERE DocumentFieldID = @DocumentFieldID;

    SELECT 1 AS Status, 'Document field deleted successfully.' AS Msg;
END

ELSE IF(@Event='SaveTransitMixerBundle')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
    BEGIN
        RAISERROR('Only Admin can save Transit Mixer bundle.',16,1);
        RETURN;
    END

    DECLARE @CombinedCategoryID_TM_Bundle INT,
            @ChassisCategoryID_TM_Bundle INT = 43,
            @UpperCategoryID_TM_Bundle INT = 42,
            @VirtualAssetID_TM_Bundle INT,
            @ChassisAssetID_TM_Bundle INT,
            @UpperAssetID_TM_Bundle INT,
            @VirtualRecordingUnit_TM_Bundle VARCHAR(50),
            @VirtualPhotoPath_TM_Bundle VARCHAR(500),
            @VirtualOwnershipType_TM_Bundle VARCHAR(50);

    SET @AssetCode = ISNULL(NULLIF(@AssetCode,''), @AssetCode_AssetPrefix);
    SET @AssetName = ISNULL(NULLIF(@AssetName,''), @AssetName_AssetPrefix);
    SET @OwnershipType = ISNULL(NULLIF(@OwnershipType,''), @OwnershipType_AssetPrefix);
    SET @AssetTypeID_Add = CASE WHEN ISNULL(@AssetTypeID_Add,0)=0 THEN @AssetTypeID_AssetPrefix ELSE @AssetTypeID_Add END;
    SET @Client = ISNULL(NULLIF(@Client,''), @Client_AssetPrefix);
    SET @Division = ISNULL(NULLIF(@Division,''), @Division_AssetPrefix);
    SET @SerialNo = ISNULL(NULLIF(@SerialNo,''), @SerialNo_AssetPrefix);
    SET @PhotoPath = ISNULL(NULLIF(@PhotoPath,''), @PhotoPath_AssetPrefix);
    SET @FuelType_Add = ISNULL(NULLIF(@FuelType_Add,''), @FuelType_AssetPrefix);
    SET @OutputUnit_Add = ISNULL(NULLIF(@OutputUnit_Add,''), @OutputUnit_AssetPrefix);
    SET @MountCode = ISNULL(NULLIF(@MountCode,''), '');


    IF ISNULL(@CreatedBy_Add,0)=0
        SET @CreatedBy_Add = @AuthEmployeeID;

    IF ISNULL(@ModifiedBy,0)=0
        SET @ModifiedBy = @AuthEmployeeID;

    IF ISNULL(@AssetTypeID_Add,0)=0
        RAISERROR('AssetTypeID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@AssetCode)),'')=''
        RAISERROR('Main virtual Asset ID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@AssetName)),'')=''
        RAISERROR('Main virtual Asset Name is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@TMChassisAssetCode)),'')=''
        RAISERROR('Transit Mixer Chassis ROHAN-ID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@TMUpperAssetCode)),'')=''
        RAISERROR('Transit Mixer Upper ROHAN-ID is required.',16,1);

    IF ISNULL(LTRIM(RTRIM(@MountCode)),'')=''
        SET @MountCode = @TMChassisAssetCode;

    SELECT TOP 1
        @CombinedCategoryID_TM_Bundle = c.CategoryID
    FROM dbo.mst_AssetCategory c
    INNER JOIN dbo.mst_AssetType t
        ON t.AssetTypeID = c.AssetTypeID
    WHERE c.AssetTypeID = @AssetTypeID_Add
      AND LTRIM(RTRIM(c.CategoryName)) = 'TRANSIT MIXER - COMBINED'
      AND ISNULL(c.IsActive,1)=1;

    IF ISNULL(@CombinedCategoryID_TM_Bundle,0)=0
        RAISERROR('Transit Mixer combined category not found.',16,1);

    SET @VirtualRecordingUnit_TM_Bundle = 'KMR/HMR';
    SET @VirtualPhotoPath_TM_Bundle = ISNULL(NULLIF(@PhotoPath,''), '');
    SET @VirtualOwnershipType_TM_Bundle = ISNULL(NULLIF(@OwnershipType,''), 'Owned');

    SELECT TOP 1
        @ChassisAssetID_TM_Bundle = a.AssetID
    FROM dbo.mst_Asset a
    WHERE (
            (ISNULL(@TMChassisAssetID,0) > 0 AND a.AssetID = @TMChassisAssetID)
            OR a.AssetCode = @TMChassisAssetCode
          )
      AND a.CategoryID = @ChassisCategoryID_TM_Bundle
      AND ISNULL(a.IsActive,1)=1
    ORDER BY a.AssetID DESC;

    IF ISNULL(@ChassisAssetID_TM_Bundle,0)=0
    BEGIN
        INSERT INTO dbo.mst_Asset
        (
            AssetCode, AssetName, OwnershipType, AssetTypeID, CategoryID, Make, ModelName, YearOfManufacture,
            RegistrationNo, EngineNo, ChassisNo, FuelType, Capacity, RecordingUnit, PurchasePrice, PurchaseDate,
            PurchaseFrom, PurchaseInvoiceNo, DepreciationPct, OutputRate, OutputUnit, VendorID, Status, PhotoPath,
            IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, Client, Division, DivisionID, SerialNo, MountCode, IsVirtualAsset
        )
        VALUES
        (
            @TMChassisAssetCode,
            @TMChassisAssetCode + CASE WHEN ISNULL(@TMChassisSerialNo,'')<>'' THEN '(' + @TMChassisSerialNo + ')' ELSE '' END,
            @VirtualOwnershipType_TM_Bundle,
            @AssetTypeID_Add,
            @ChassisCategoryID_TM_Bundle,
            @TMChassisMake,
            @TMChassisModel,
            @TMChassisYearOfManufacture,
            @TMChassisRegistrationNo,
            @TMChassisEngineNo,
            @TMChassisNo,
            ISNULL(NULLIF(@FuelType_Add,''),'Diesel'),
            @TMChassisCapacity,
            'KMR/HMR',
            ISNULL(@PurchasePrice,0),
            @PurchaseDate,
            @PurchaseFrom,
            @PurchaseInvoiceNo,
            ISNULL(@DepreciationPct,0),
            ISNULL(@OutputRate,0),
            ISNULL(@OutputUnit_Add,''),
            @VendorID,
            'Active',
            @VirtualPhotoPath_TM_Bundle,
            1,
            @CreatedBy_Add,
            GETDATE(),
            NULL,
            NULL,
            @Client,
            @Division,
            @DivisionID,
            @TMChassisSerialNo,
            @MountCode,
            0
        );

        SET @ChassisAssetID_TM_Bundle = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.mst_Asset
        SET
            AssetCode = @TMChassisAssetCode,
            AssetName = @TMChassisAssetCode + CASE WHEN ISNULL(@TMChassisSerialNo,'')<>'' THEN '(' + @TMChassisSerialNo + ')' ELSE '' END,
            OwnershipType = @VirtualOwnershipType_TM_Bundle,
            AssetTypeID = @AssetTypeID_Add,
            CategoryID = @ChassisCategoryID_TM_Bundle,
            Make = @TMChassisMake,
            ModelName = @TMChassisModel,
            YearOfManufacture = @TMChassisYearOfManufacture,
            RegistrationNo = @TMChassisRegistrationNo,
            EngineNo = @TMChassisEngineNo,
            ChassisNo = @TMChassisNo,
            FuelType = ISNULL(NULLIF(@FuelType_Add,''),'Diesel'),
            Capacity = @TMChassisCapacity,
            RecordingUnit = 'KMR/HMR',
            PurchasePrice = ISNULL(@PurchasePrice,0),
            PurchaseDate = @PurchaseDate,
            PurchaseFrom = @PurchaseFrom,
            PurchaseInvoiceNo = @PurchaseInvoiceNo,
            DepreciationPct = ISNULL(@DepreciationPct,0),
            OutputRate = ISNULL(@OutputRate,0),
            OutputUnit = ISNULL(@OutputUnit_Add,''),
            VendorID = @VendorID,
            Status = 'Active',
            PhotoPath = ISNULL(NULLIF(@VirtualPhotoPath_TM_Bundle,''), PhotoPath),
            Client = @Client,
            Division = @Division,
            DivisionID = @DivisionID,
            SerialNo = @TMChassisSerialNo,
            MountCode = @MountCode,
            IsVirtualAsset = 0,
            ModifiedBy = @ModifiedBy,
            ModifiedOn = GETDATE()
        WHERE AssetID = @ChassisAssetID_TM_Bundle;
    END

    SELECT TOP 1
        @UpperAssetID_TM_Bundle = a.AssetID
    FROM dbo.mst_Asset a
    WHERE (
            (ISNULL(@TMUpperAssetID,0) > 0 AND a.AssetID = @TMUpperAssetID)
            OR a.AssetCode = @TMUpperAssetCode
          )
      AND a.CategoryID = @UpperCategoryID_TM_Bundle
      AND ISNULL(a.IsActive,1)=1
    ORDER BY a.AssetID DESC;

    IF ISNULL(@UpperAssetID_TM_Bundle,0)=0
    BEGIN
        INSERT INTO dbo.mst_Asset
        (
            AssetCode, AssetName, OwnershipType, AssetTypeID, CategoryID, Make, ModelName, YearOfManufacture,
            RegistrationNo, EngineNo, ChassisNo, FuelType, Capacity, RecordingUnit, PurchasePrice, PurchaseDate,
            PurchaseFrom, PurchaseInvoiceNo, DepreciationPct, OutputRate, OutputUnit, VendorID, Status, PhotoPath,
            IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, Client, Division, DivisionID, SerialNo, MountCode, IsVirtualAsset
        )
        VALUES
        (
            @TMUpperAssetCode,
            @TMUpperAssetCode + CASE WHEN ISNULL(@TMUpperSerialNo,'')<>'' THEN '(' + @TMUpperSerialNo + ')' ELSE '' END,
            @VirtualOwnershipType_TM_Bundle,
            @AssetTypeID_Add,
            @UpperCategoryID_TM_Bundle,
            @TMUpperMake,
            @TMUpperModel,
            NULL,
            '',
            @TMUpperEngineNo,
            '',
            ISNULL(NULLIF(@FuelType_Add,''),'Diesel'),
            '',
            'KMR/HMR',
            0,
            NULL,
            '',
            '',
            0,
            0,
            '',
            @VendorID,
            'Active',
            '',
            1,
            @CreatedBy_Add,
            GETDATE(),
            NULL,
            NULL,
            @Client,
            @Division,
            @DivisionID,
            @TMUpperSerialNo,
            @MountCode,
            0
        );

        SET @UpperAssetID_TM_Bundle = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.mst_Asset
        SET
            AssetCode = @TMUpperAssetCode,
            AssetName = @TMUpperAssetCode + CASE WHEN ISNULL(@TMUpperSerialNo,'')<>'' THEN '(' + @TMUpperSerialNo + ')' ELSE '' END,
            OwnershipType = @VirtualOwnershipType_TM_Bundle,
            AssetTypeID = @AssetTypeID_Add,
            CategoryID = @UpperCategoryID_TM_Bundle,
            Make = @TMUpperMake,
            ModelName = @TMUpperModel,
            EngineNo = @TMUpperEngineNo,
            FuelType = ISNULL(NULLIF(@FuelType_Add,''),'Diesel'),
            RecordingUnit = 'KMR/HMR',
            VendorID = @VendorID,
            Status = 'Active',
            Client = @Client,
            Division = @Division,
            DivisionID = @DivisionID,
            SerialNo = @TMUpperSerialNo,
            MountCode = @MountCode,
            IsVirtualAsset = 0,
            ModifiedBy = @ModifiedBy,
            ModifiedOn = GETDATE()
        WHERE AssetID = @UpperAssetID_TM_Bundle;
    END

    SELECT TOP 1
        @VirtualAssetID_TM_Bundle = a.AssetID
    FROM dbo.mst_Asset a
    WHERE (
            (ISNULL(@AssetID,0) > 0 AND a.AssetID = @AssetID)
            OR a.AssetCode = @AssetCode
          )
      AND ISNULL(a.IsVirtualAsset,0)=1
      AND ISNULL(a.IsActive,1)=1
    ORDER BY a.AssetID DESC;

    IF ISNULL(@VirtualAssetID_TM_Bundle,0)=0
    BEGIN
        INSERT INTO dbo.mst_Asset
        (
            AssetCode, AssetName, OwnershipType, AssetTypeID, CategoryID, Make, ModelName, YearOfManufacture,
            RegistrationNo, EngineNo, ChassisNo, FuelType, Capacity, RecordingUnit, PurchasePrice, PurchaseDate,
            PurchaseFrom, PurchaseInvoiceNo, DepreciationPct, OutputRate, OutputUnit, VendorID, Status, PhotoPath,
            IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, Client, Division, DivisionID, SerialNo, MountCode, IsVirtualAsset
        )
        VALUES
        (
            @AssetCode,
            @AssetName,
            @VirtualOwnershipType_TM_Bundle,
            @AssetTypeID_Add,
            @CombinedCategoryID_TM_Bundle,
            @TMChassisMake,
            @TMChassisModel,
            @TMChassisYearOfManufacture,
            @TMChassisRegistrationNo,
            @TMChassisEngineNo,
            @TMChassisNo,
            ISNULL(NULLIF(@FuelType_Add,''),'Diesel'),
            @TMChassisCapacity,
            @VirtualRecordingUnit_TM_Bundle,
            ISNULL(@PurchasePrice,0),
            @PurchaseDate,
            @PurchaseFrom,
            @PurchaseInvoiceNo,
            ISNULL(@DepreciationPct,0),
            ISNULL(@OutputRate,0),
            ISNULL(@OutputUnit_Add,''),
            @VendorID,
            'Active',
            @VirtualPhotoPath_TM_Bundle,
            1,
            @CreatedBy_Add,
            GETDATE(),
            NULL,
            NULL,
            @Client,
            @Division,
            @DivisionID,
            @TMUpperSerialNo,
            @MountCode,
            1
        );

        SET @VirtualAssetID_TM_Bundle = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.mst_Asset
        SET
            AssetCode = @AssetCode,
            AssetName = @AssetName,
            OwnershipType = @VirtualOwnershipType_TM_Bundle,
            AssetTypeID = @AssetTypeID_Add,
            CategoryID = @CombinedCategoryID_TM_Bundle,
            Make = @TMChassisMake,
            ModelName = @TMChassisModel,
            YearOfManufacture = @TMChassisYearOfManufacture,
            RegistrationNo = @TMChassisRegistrationNo,
            EngineNo = @TMChassisEngineNo,
            ChassisNo = @TMChassisNo,
            FuelType = ISNULL(NULLIF(@FuelType_Add,''),'Diesel'),
            Capacity = @TMChassisCapacity,
            RecordingUnit = @VirtualRecordingUnit_TM_Bundle,
            PurchasePrice = ISNULL(@PurchasePrice,0),
            PurchaseDate = @PurchaseDate,
            PurchaseFrom = @PurchaseFrom,
            PurchaseInvoiceNo = @PurchaseInvoiceNo,
            DepreciationPct = ISNULL(@DepreciationPct,0),
            OutputRate = ISNULL(@OutputRate,0),
            OutputUnit = ISNULL(@OutputUnit_Add,''),
            VendorID = @VendorID,
            Status = 'Active',
            PhotoPath = ISNULL(NULLIF(@VirtualPhotoPath_TM_Bundle,''), PhotoPath),
            Client = @Client,
            Division = @Division,
            DivisionID = @DivisionID,
            SerialNo = @TMUpperSerialNo,
            MountCode = @MountCode,
            IsVirtualAsset = 1,
            ModifiedBy = @ModifiedBy,
            ModifiedOn = GETDATE()
        WHERE AssetID = @VirtualAssetID_TM_Bundle;
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.trn_AssetMounting
        WHERE MountCode = @MountCode
          AND ISNULL(IsActive,1)=1
    )
    BEGIN
        UPDATE dbo.trn_AssetMounting
        SET
            VirtualAssetID = @VirtualAssetID_TM_Bundle,
            ChassisAssetID = @ChassisAssetID_TM_Bundle,
            UpperAssetID = @UpperAssetID_TM_Bundle,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE MountCode = @MountCode
          AND ISNULL(IsActive,1)=1;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.trn_AssetMounting
        (
            MountCode, VirtualAssetID, ChassisAssetID, UpperAssetID,
            MountedOn, IsActive, CreatedBy, CreatedOn
        )
        VALUES
        (
            @MountCode, @VirtualAssetID_TM_Bundle, @ChassisAssetID_TM_Bundle, @UpperAssetID_TM_Bundle,
            GETDATE(), 1, @AuthEmployeeID, GETDATE()
        );
    END

    UPDATE dbo.tbl_Log
    SET Status='Success'
    WHERE Id=@LastId;

    SELECT
        'Success' AS Status,
        'Transit Mixer bundle saved successfully.' AS Msg,
        @VirtualAssetID_TM_Bundle AS AssetID,
        @AssetCode AS AssetCode,
        @ChassisAssetID_TM_Bundle AS ChassisAssetID,
        @UpperAssetID_TM_Bundle AS UpperAssetID,
        @MountCode AS MountCode;
END


---From-04-07-26
ELSE IF (@Event = 'GetSiteRights_A7B2C3D4')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        el.ProjectEmployeeLinkID,
        el.ProjectID,
        p.ProjectName,
        p.ProjectCode,
        el.UserRoleID,
        ur.EmployeeID,
        ur.Username,
        el.IsActive
    FROM dbo.trn_ProjectEmployeeLink el
    INNER JOIN dbo.mst_UserRole ur ON ur.UserRoleID = el.UserRoleID
    INNER JOIN dbo.mst_Project p ON p.ProjectID = el.ProjectID
    WHERE el.IsActive = 1
    ORDER BY ur.Username, p.ProjectName;
END

ELSE IF (@Event = 'SaveSiteRights_B8C3D4E5')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @UserRoleIDs NVARCHAR(MAX);

    SET @ProjectID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ProjectID:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString))
                  - CHARINDEX('ProjectID:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @UserRoleIDs = SUBSTRING(@ParameterString,
        CHARINDEX('UserRoleIDs:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('UserRoleIDs:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('UserRoleIDs:', @ParameterString))
                  - CHARINDEX('UserRoleIDs:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    IF ISNULL(@ProjectID, 0) = 0 OR ISNULL(@UserRoleIDs, '') = ''
    BEGIN
        RAISERROR('Invalid Site or Employee selection.',16,1);
        RETURN;
    END

    INSERT INTO dbo.trn_ProjectEmployeeLink (ProjectID, UserRoleID, IsActive, CreatedBy, CreatedOn)
    SELECT 
        @ProjectID,
        TRY_CAST(value AS INT),
        1,
        @AuthEmployeeID,
        GETDATE()
    FROM STRING_SPLIT(REPLACE(@UserRoleIDs, '~^', ','), ',')
    WHERE TRY_CAST(value AS INT) IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM dbo.trn_ProjectEmployeeLink
          WHERE ProjectID = @ProjectID
            AND UserRoleID = TRY_CAST(value AS INT)
      );

    UPDATE dbo.trn_ProjectEmployeeLink
    SET IsActive = 1,
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE()
    FROM dbo.trn_ProjectEmployeeLink el
    INNER JOIN STRING_SPLIT(REPLACE(@UserRoleIDs, '~^', ','), ',') s
        ON el.UserRoleID = TRY_CAST(s.value AS INT)
    WHERE el.ProjectID = @ProjectID
      AND el.IsActive = 0;

    SELECT 'Success' AS Result;
END

ELSE IF (@Event = 'DeleteSiteRights_C9D4E5F6')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @ProjectEmployeeLinkID INT;
    DECLARE @UserRoleID INT;
    SET @ProjectEmployeeLinkID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ProjectEmployeeLinkID:', @ParameterString) + 22,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectEmployeeLinkID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectEmployeeLinkID:', @ParameterString))
                  - CHARINDEX('ProjectEmployeeLinkID:', @ParameterString) - 22
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @UserRoleID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('UserRoleID:', @ParameterString) + 11,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('UserRoleID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('UserRoleID:', @ParameterString))
                  - CHARINDEX('UserRoleID:', @ParameterString) - 11
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ProjectID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ProjectID:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString))
                  - CHARINDEX('ProjectID:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END) AS INT);

    IF ISNULL(@ProjectEmployeeLinkID, 0) = 0 AND ISNULL(@UserRoleID, 0) = 0 AND ISNULL(@ProjectID, 0) = 0
    BEGIN
        RAISERROR('Invalid Link ID, User Role ID, or Project ID.',16,1);
        RETURN;
    END

    IF ISNULL(@ProjectEmployeeLinkID, 0) > 0
    BEGIN
        UPDATE dbo.trn_ProjectEmployeeLink
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ProjectEmployeeLinkID = @ProjectEmployeeLinkID;
    END
    ELSE IF ISNULL(@UserRoleID, 0) > 0
    BEGIN
        UPDATE dbo.trn_ProjectEmployeeLink
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE UserRoleID = @UserRoleID;
    END
    ELSE IF ISNULL(@ProjectID, 0) > 0
    BEGIN
        UPDATE dbo.trn_ProjectEmployeeLink
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ProjectID = @ProjectID;
    END

    SELECT 'Success' AS Result;
END

-- 1. GET ALL EMAIL PREFERENCES
ELSE IF (@Event = 'GetEmailPreferences_D1E2F3A4')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        ep.SiteEmailPreferenceID,
        ep.PreferenceType,
        ep.ProjectID,
        p.ProjectName,
        p.ProjectCode,
        ep.ClientEmails,
        ep.UserRoleID,
        ur.EmployeeID,
        ur.Username,
        ur.Email,
        ep.IsActive
    FROM dbo.trn_SiteEmailPreference ep
    INNER JOIN dbo.mst_UserRole ur ON ur.UserRoleID = ep.UserRoleID
    INNER JOIN dbo.mst_Project p ON p.ProjectID = ep.ProjectID
    WHERE ep.IsActive = 1
    ORDER BY p.ProjectName, ep.PreferenceType, ur.Username;
END

-- 2. SAVE SITE EMAIL PREFERENCE
ELSE IF (@Event = 'SaveEmailPreference_E2F3A4B5')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @PreferenceType NVARCHAR(100);
    DECLARE @ClientEmails NVARCHAR(MAX);

    SET @ProjectID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ProjectID:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString))
                  - CHARINDEX('ProjectID:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @PreferenceType = SUBSTRING(@ParameterString,
        CHARINDEX('PreferenceType:', @ParameterString) + 15,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('PreferenceType:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('PreferenceType:', @ParameterString))
                  - CHARINDEX('PreferenceType:', @ParameterString) - 15
             ELSE LEN(@ParameterString)
        END);

    SET @ClientEmails = SUBSTRING(@ParameterString,
        CHARINDEX('ClientEmails:', @ParameterString) + 13,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ClientEmails:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ClientEmails:', @ParameterString))
                  - CHARINDEX('ClientEmails:', @ParameterString) - 13
             ELSE LEN(@ParameterString)
        END);

    SET @UserRoleIDs = SUBSTRING(@ParameterString,
        CHARINDEX('UserRoleIDs:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('UserRoleIDs:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('UserRoleIDs:', @ParameterString))
                  - CHARINDEX('UserRoleIDs:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    IF ISNULL(@ProjectID, 0) = 0 OR ISNULL(@PreferenceType, '') = '' OR ISNULL(@UserRoleIDs, '') = ''
    BEGIN
        RAISERROR('Invalid Email Preference selection.',16,1);
        RETURN;
    END

    -- Deactivate ones not in the new list
    UPDATE dbo.trn_SiteEmailPreference
    SET IsActive = 0,
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE()
    WHERE ProjectID = @ProjectID
      AND PreferenceType = @PreferenceType
      AND IsActive = 1
      AND UserRoleID NOT IN (
          SELECT TRY_CAST(value AS INT) 
          FROM STRING_SPLIT(REPLACE(@UserRoleIDs, '~^', ','), ',')
          WHERE TRY_CAST(value AS INT) IS NOT NULL
      );

    -- Insert new ones
    INSERT INTO dbo.trn_SiteEmailPreference (ProjectID, PreferenceType, ClientEmails, UserRoleID, IsActive, CreatedBy, CreatedOn)
    SELECT 
        @ProjectID,
        @PreferenceType,
        @ClientEmails,
        TRY_CAST(value AS INT),
        1,
        @AuthEmployeeID,
        GETDATE()
    FROM STRING_SPLIT(REPLACE(@UserRoleIDs, '~^', ','), ',') s
    WHERE TRY_CAST(s.value AS INT) IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM dbo.trn_SiteEmailPreference
          WHERE ProjectID = @ProjectID
            AND PreferenceType = @PreferenceType
            AND UserRoleID = TRY_CAST(s.value AS INT)
      );

    -- Reactivate and update existing ones
    UPDATE ep
    SET ep.IsActive = 1,
        ep.ClientEmails = @ClientEmails,
        ep.ModifiedBy = @AuthEmployeeID,
        ep.ModifiedOn = GETDATE()
    FROM dbo.trn_SiteEmailPreference ep
    INNER JOIN STRING_SPLIT(REPLACE(@UserRoleIDs, '~^', ','), ',') s
        ON ep.UserRoleID = TRY_CAST(s.value AS INT)
    WHERE ep.ProjectID = @ProjectID
      AND ep.PreferenceType = @PreferenceType;

    SELECT 'Success' AS Result;
END

-- 3. DELETE/REVOKE EMAIL PREFERENCE
ELSE IF (@Event = 'DeleteEmailPreference_F3A4B5C6')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @SiteEmailPreferenceID INT;

    SET @SiteEmailPreferenceID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('SiteEmailPreferenceID:', @ParameterString) + 22,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('SiteEmailPreferenceID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('SiteEmailPreferenceID:', @ParameterString))
                  - CHARINDEX('SiteEmailPreferenceID:', @ParameterString) - 22
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ProjectID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ProjectID:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString))
                  - CHARINDEX('ProjectID:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @PreferenceType = SUBSTRING(@ParameterString,
        CHARINDEX('PreferenceType:', @ParameterString) + 15,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('PreferenceType:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('PreferenceType:', @ParameterString))
                  - CHARINDEX('PreferenceType:', @ParameterString) - 15
             ELSE LEN(@ParameterString)
        END);

    IF ISNULL(@SiteEmailPreferenceID, 0) = 0 AND (ISNULL(@ProjectID, 0) = 0 OR ISNULL(@PreferenceType, '') = '')
    BEGIN
        RAISERROR('Invalid ID or Site selection.',16,1);
        RETURN;
    END

    IF ISNULL(@SiteEmailPreferenceID, 0) > 0
    BEGIN
        UPDATE dbo.trn_SiteEmailPreference
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE SiteEmailPreferenceID = @SiteEmailPreferenceID;
    END
    ELSE
    BEGIN
        UPDATE dbo.trn_SiteEmailPreference
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ProjectID = @ProjectID
          AND PreferenceType = @PreferenceType;
    END

    SELECT 'Success' AS Result;
END


ELSE IF (@Event = 'SaveEmailPreference_E2F3A4B5')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END


    SET @ProjectID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ProjectID:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString))
                  - CHARINDEX('ProjectID:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @PreferenceType = SUBSTRING(@ParameterString,
        CHARINDEX('PreferenceType:', @ParameterString) + 15,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('PreferenceType:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('PreferenceType:', @ParameterString))
                  - CHARINDEX('PreferenceType:', @ParameterString) - 15
             ELSE LEN(@ParameterString)
        END);

    SET @ClientEmails = SUBSTRING(@ParameterString,
        CHARINDEX('ClientEmails:', @ParameterString) + 13,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ClientEmails:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ClientEmails:', @ParameterString))
                  - CHARINDEX('ClientEmails:', @ParameterString) - 13
             ELSE LEN(@ParameterString)
        END);

    SET @UserRoleIDs = SUBSTRING(@ParameterString,
        CHARINDEX('UserRoleIDs:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('UserRoleIDs:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('UserRoleIDs:', @ParameterString))
                  - CHARINDEX('UserRoleIDs:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    IF ISNULL(@ProjectID, 0) = 0 OR ISNULL(@PreferenceType, '') = '' OR ISNULL(@UserRoleIDs, '') = ''
    BEGIN
        RAISERROR('Invalid Email Preference selection.',16,1);
        RETURN;
    END

    UPDATE dbo.trn_SiteEmailPreference
    SET IsActive = 0,
        ModifiedBy = @AuthEmployeeID,
        ModifiedOn = GETDATE()
    WHERE ProjectID = @ProjectID
      AND PreferenceType = @PreferenceType
      AND IsActive = 1
      AND UserRoleID NOT IN (
          SELECT TRY_CAST(value AS INT) 
          FROM STRING_SPLIT(REPLACE(@UserRoleIDs, '~^', ','), ',')
          WHERE TRY_CAST(value AS INT) IS NOT NULL
      );

    INSERT INTO dbo.trn_SiteEmailPreference (ProjectID, PreferenceType, ClientEmails, UserRoleID, IsActive, CreatedBy, CreatedOn)
    SELECT 
        @ProjectID,
        @PreferenceType,
        @ClientEmails,
        TRY_CAST(value AS INT),
        1,
        @AuthEmployeeID,
        GETDATE()
    FROM STRING_SPLIT(REPLACE(@UserRoleIDs, '~^', ','), ',') s
    WHERE TRY_CAST(s.value AS INT) IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM dbo.trn_SiteEmailPreference
          WHERE ProjectID = @ProjectID
            AND PreferenceType = @PreferenceType
            AND UserRoleID = TRY_CAST(s.value AS INT)
      );

    UPDATE ep
    SET ep.IsActive = 1,
        ep.ClientEmails = @ClientEmails,
        ep.ModifiedBy = @AuthEmployeeID,
        ep.ModifiedOn = GETDATE()
    FROM dbo.trn_SiteEmailPreference ep
    INNER JOIN STRING_SPLIT(REPLACE(@UserRoleIDs, '~^', ','), ',') s
        ON ep.UserRoleID = TRY_CAST(s.value AS INT)
    WHERE ep.ProjectID = @ProjectID
      AND ep.PreferenceType = @PreferenceType;

    SELECT 'Success' AS Result;
END

ELSE IF (@Event = 'DeleteEmailPreference_F3A4B5C6')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END


    SET @SiteEmailPreferenceID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('SiteEmailPreferenceID:', @ParameterString) + 22,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('SiteEmailPreferenceID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('SiteEmailPreferenceID:', @ParameterString))
                  - CHARINDEX('SiteEmailPreferenceID:', @ParameterString) - 22
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ProjectID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ProjectID:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ProjectID:', @ParameterString))
                  - CHARINDEX('ProjectID:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @PreferenceType = SUBSTRING(@ParameterString,
        CHARINDEX('PreferenceType:', @ParameterString) + 15,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('PreferenceType:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('PreferenceType:', @ParameterString))
                  - CHARINDEX('PreferenceType:', @ParameterString) - 15
             ELSE LEN(@ParameterString)
        END);

    IF ISNULL(@SiteEmailPreferenceID, 0) = 0 AND (ISNULL(@ProjectID, 0) = 0 OR ISNULL(@PreferenceType, '') = '')
    BEGIN
        RAISERROR('Invalid ID or Site selection.',16,1);
        RETURN;
    END

    IF ISNULL(@SiteEmailPreferenceID, 0) > 0
    BEGIN
        UPDATE dbo.trn_SiteEmailPreference
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE SiteEmailPreferenceID = @SiteEmailPreferenceID;
    END
    ELSE
    BEGIN
        UPDATE dbo.trn_SiteEmailPreference
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ProjectID = @ProjectID
          AND PreferenceType = @PreferenceType;
    END

    SELECT 'Success' AS Result;
END


-- 1. GET ALL SERVICE SCHEDULES
ELSE IF (@Event = 'GetMachineServiceSchedules')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT 
        ScheduleID,CategoryID,AssetTypeID,MakeID,ModelID,ServiceTypeID,ServiceType, UOM,
        ThresholdFirst, ThresholdSecond, ThresholdEvery,
        AlertFirst, AlertFirstTemplate, AlertSecond, AlertSecondTemplate,
        AlertThird, AlertThirdTemplate, AlertLast, AlertLastTemplate,
        Remarks, IsActive
    FROM dbo.trn_MachineServiceSchedule
    WHERE IsActive = 1
    ORDER BY CategoryID, MakeID, ModelID;
END

-- 2. SAVE SERVICE SCHEDULE
ELSE IF (@Event = 'SaveMachineServiceSchedule')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @ScheduleID INT;
    DECLARE @ServiceArea NVARCHAR(200);
    DECLARE @ServiceType NVARCHAR(200);
    DECLARE @UOM NVARCHAR(50);
    DECLARE @ThresholdFirst INT;
    DECLARE @ThresholdSecond INT;
    DECLARE @ThresholdEvery INT;
    DECLARE @AlertFirst INT;
    DECLARE @AlertFirstTemplate NVARCHAR(MAX);
    DECLARE @AlertSecond INT;
    DECLARE @AlertSecondTemplate NVARCHAR(MAX);
    DECLARE @AlertThird INT;
    DECLARE @AlertThirdTemplate NVARCHAR(MAX);
    DECLARE @AlertLast INT;
    DECLARE @AlertLastTemplate NVARCHAR(MAX);

    -- Extract ScheduleID
    SET @ScheduleID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ScheduleID:', @ParameterString) + 11,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ScheduleID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ScheduleID:', @ParameterString))
                  - CHARINDEX('ScheduleID:', @ParameterString) - 11
             ELSE LEN(@ParameterString)
        END) AS INT);

    -- Extract ID Parameters
    SET @CategoryID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('CategoryID:', @ParameterString) + 11,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('CategoryID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('CategoryID:', @ParameterString))
                  - CHARINDEX('CategoryID:', @ParameterString) - 11
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @AssetTypeID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('AssetTypeID:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AssetTypeID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AssetTypeID:', @ParameterString))
                  - CHARINDEX('AssetTypeID:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @MakeID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('MakeID:', @ParameterString) + 7,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('MakeID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('MakeID:', @ParameterString))
                  - CHARINDEX('MakeID:', @ParameterString) - 7
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ModelID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ModelID:', @ParameterString) + 8,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ModelID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ModelID:', @ParameterString))
                  - CHARINDEX('ModelID:', @ParameterString) - 8
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ServiceTypeID = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceTypeID:', @ParameterString) + 14,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceTypeID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceTypeID:', @ParameterString))
                  - CHARINDEX('ServiceTypeID:', @ParameterString) - 14
             ELSE LEN(@ParameterString)
        END);

    -- Extract Remaining Fields
    SET @ServiceArea = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceArea:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceArea:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceArea:', @ParameterString))
                  - CHARINDEX('ServiceArea:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceType = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceType:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceType:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceType:', @ParameterString))
                  - CHARINDEX('ServiceType:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    SET @UOM = SUBSTRING(@ParameterString,
        CHARINDEX('UOM:', @ParameterString) + 4,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('UOM:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('UOM:', @ParameterString))
                  - CHARINDEX('UOM:', @ParameterString) - 4
             ELSE LEN(@ParameterString)
        END);

    SET @ThresholdFirst = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ThresholdFirst:', @ParameterString) + 15,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ThresholdFirst:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ThresholdFirst:', @ParameterString))
                  - CHARINDEX('ThresholdFirst:', @ParameterString) - 15
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ThresholdSecond = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ThresholdSecond:', @ParameterString) + 16,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ThresholdSecond:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ThresholdSecond:', @ParameterString))
                  - CHARINDEX('ThresholdSecond:', @ParameterString) - 16
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ThresholdEvery = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ThresholdEvery:', @ParameterString) + 15,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ThresholdEvery:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ThresholdEvery:', @ParameterString))
                  - CHARINDEX('ThresholdEvery:', @ParameterString) - 15
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @AlertFirst = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('AlertFirst:', @ParameterString) + 11,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertFirst:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertFirst:', @ParameterString))
                  - CHARINDEX('AlertFirst:', @ParameterString) - 11
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @AlertFirstTemplate = SUBSTRING(@ParameterString,
        CHARINDEX('AlertFirstTemplate:', @ParameterString) + 19,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertFirstTemplate:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertFirstTemplate:', @ParameterString))
                  - CHARINDEX('AlertFirstTemplate:', @ParameterString) - 19
             ELSE LEN(@ParameterString)
        END);

    SET @AlertSecond = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('AlertSecond:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertSecond:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertSecond:', @ParameterString))
                  - CHARINDEX('AlertSecond:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @AlertSecondTemplate = SUBSTRING(@ParameterString,
        CHARINDEX('AlertSecondTemplate:', @ParameterString) + 20,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertSecondTemplate:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertSecondTemplate:', @ParameterString))
                  - CHARINDEX('AlertSecondTemplate:', @ParameterString) - 20
             ELSE LEN(@ParameterString)
        END);

    SET @AlertThird = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('AlertThird:', @ParameterString) + 11,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertThird:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertThird:', @ParameterString))
                  - CHARINDEX('AlertThird:', @ParameterString) - 11
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @AlertThirdTemplate = SUBSTRING(@ParameterString,
        CHARINDEX('AlertThirdTemplate:', @ParameterString) + 19,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertThirdTemplate:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertThirdTemplate:', @ParameterString))
                  - CHARINDEX('AlertThirdTemplate:', @ParameterString) - 19
             ELSE LEN(@ParameterString)
        END);

    SET @AlertLast = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('AlertLast:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertLast:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertLast:', @ParameterString))
                  - CHARINDEX('AlertLast:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @AlertLastTemplate = SUBSTRING(@ParameterString,
        CHARINDEX('AlertLastTemplate:', @ParameterString) + 18,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertLastTemplate:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AlertLastTemplate:', @ParameterString))
                  - CHARINDEX('AlertLastTemplate:', @ParameterString) - 18
             ELSE LEN(@ParameterString)
        END);

    SET @Remarks = SUBSTRING(@ParameterString,
        CHARINDEX('Remarks:', @ParameterString) + 8,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('Remarks:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('Remarks:', @ParameterString))
                  - CHARINDEX('Remarks:', @ParameterString) - 8
             ELSE LEN(@ParameterString)
        END);

    IF EXISTS (SELECT 1 FROM dbo.trn_MachineServiceSchedule WHERE ScheduleID = @ScheduleID)
    BEGIN
        UPDATE dbo.trn_MachineServiceSchedule
        SET CategoryID = @CategoryID,
            AssetTypeID = @AssetTypeID,
            MakeID = @MakeID,
            ModelID = @ModelID,
            ServiceTypeID = @ServiceTypeID,
            ServiceArea = @ServiceArea,
            ServiceType = @ServiceType,
            UOM = @UOM,
            ThresholdFirst = ISNULL(@ThresholdFirst, 0),
            ThresholdSecond = ISNULL(@ThresholdSecond, 0),
            ThresholdEvery = ISNULL(@ThresholdEvery, 0),
            AlertFirst = ISNULL(@AlertFirst, 0),
            AlertFirstTemplate = @AlertFirstTemplate,
            AlertSecond = ISNULL(@AlertSecond, 0),
            AlertSecondTemplate = @AlertSecondTemplate,
            AlertThird = ISNULL(@AlertThird, 0),
            AlertThirdTemplate = @AlertThirdTemplate,
            AlertLast = ISNULL(@AlertLast, 0),
            AlertLastTemplate = @AlertLastTemplate,
            Remarks = @Remarks,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ScheduleID = @ScheduleID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.trn_MachineServiceSchedule (
            CategoryID, AssetTypeID, MakeID, ModelID, ServiceTypeID,
            ServiceArea, ServiceType, UOM,
            ThresholdFirst, ThresholdSecond, ThresholdEvery,
            AlertFirst, AlertFirstTemplate, AlertSecond, AlertSecondTemplate,
            AlertThird, AlertThirdTemplate, AlertLast, AlertLastTemplate,
            Remarks, IsActive, CreatedBy, CreatedOn
        ) VALUES (
            @CategoryID, @AssetTypeID, @MakeID, @ModelID, @ServiceTypeID,
            @ServiceArea, @ServiceType, @UOM,
            ISNULL(@ThresholdFirst, 0), ISNULL(@ThresholdSecond, 0), ISNULL(@ThresholdEvery, 0),
            ISNULL(@AlertFirst, 0), @AlertFirstTemplate, ISNULL(@AlertSecond, 0), @AlertSecondTemplate,
            ISNULL(@AlertThird, 0), @AlertThirdTemplate, ISNULL(@AlertLast, 0), @AlertLastTemplate,
            @Remarks, 1, @AuthEmployeeID, GETDATE()
        );
    END

    SELECT 'Success' AS Result;
END


-- 3. DELETE SERVICE SCHEDULE
ELSE IF (@Event = 'DeleteMachineServiceSchedule')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @DelScheduleID INT;

    SET @DelScheduleID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ScheduleID:', @ParameterString) + 11,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ScheduleID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ScheduleID:', @ParameterString))
                  - CHARINDEX('ScheduleID:', @ParameterString) - 11
             ELSE LEN(@ParameterString)
        END) AS INT);

    IF ISNULL(@DelScheduleID, 0) > 0
    BEGIN
        UPDATE dbo.trn_MachineServiceSchedule
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ScheduleID = @DelScheduleID;
    END

    SELECT 'Success' AS Result;
END


ELSE IF (@Event = 'GetMachineServiceEntries')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT 
        EntryID, Owner, Employee, MachineID, HMR, KMR, Cum,
        ServiceArea, ServiceType, ServiceDetail, ServiceLocation,
        ServiceDate, ServiceTime, ServiceAmount, DoneBy, Supervisor,
        InstructedBy, WasteMaterial, HasAttachment, IsActive
    FROM dbo.trn_MachineServiceEntry
    WHERE IsActive = 1
    ORDER BY CreatedOn DESC;
END

ELSE IF (@Event = 'SaveMachineServiceEntry')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @EntryID NVARCHAR(100);
    DECLARE @Owner NVARCHAR(200);
    DECLARE @Employee NVARCHAR(200);
    DECLARE @HMR DECIMAL(18,2);
    DECLARE @KMR DECIMAL(18,2);
    DECLARE @Cum DECIMAL(18,2);
    DECLARE @ServiceDetail NVARCHAR(MAX);
    DECLARE @ServiceLocation NVARCHAR(200);
    DECLARE @ServiceDate NVARCHAR(50);
    DECLARE @ServiceTime NVARCHAR(50);
    DECLARE @ServiceAmount DECIMAL(18,2);
    DECLARE @DoneBy NVARCHAR(200);
    DECLARE @Supervisor NVARCHAR(200);
    DECLARE @InstructedBy NVARCHAR(200);
    DECLARE @WasteMaterial NVARCHAR(500);
    DECLARE @HasAttachment NVARCHAR(10);

    SET @EntryID = SUBSTRING(@ParameterString,
        CHARINDEX('EntryID:', @ParameterString) + 8,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('EntryID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('EntryID:', @ParameterString))
                  - CHARINDEX('EntryID:', @ParameterString) - 8
             ELSE LEN(@ParameterString)
        END);

    SET @Owner = SUBSTRING(@ParameterString,
        CHARINDEX('Owner:', @ParameterString) + 6,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('Owner:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('Owner:', @ParameterString))
                  - CHARINDEX('Owner:', @ParameterString) - 6
             ELSE LEN(@ParameterString)
        END);

    SET @Employee = SUBSTRING(@ParameterString,
        CHARINDEX('Employee:', @ParameterString) + 9,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('Employee:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('Employee:', @ParameterString))
                  - CHARINDEX('Employee:', @ParameterString) - 9
             ELSE LEN(@ParameterString)
        END);

    SET @MachineID = SUBSTRING(@ParameterString,
        CHARINDEX('MachineID:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('MachineID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('MachineID:', @ParameterString))
                  - CHARINDEX('MachineID:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END);

    SET @HMR = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('HMR:', @ParameterString) + 4,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('HMR:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('HMR:', @ParameterString))
                  - CHARINDEX('HMR:', @ParameterString) - 4
             ELSE LEN(@ParameterString)
        END) AS DECIMAL(18,2));

    SET @KMR = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('KMR:', @ParameterString) + 4,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('KMR:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('KMR:', @ParameterString))
                  - CHARINDEX('KMR:', @ParameterString) - 4
             ELSE LEN(@ParameterString)
        END) AS DECIMAL(18,2));

    SET @Cum = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('Cum:', @ParameterString) + 4,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('Cum:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('Cum:', @ParameterString))
                  - CHARINDEX('Cum:', @ParameterString) - 4
             ELSE LEN(@ParameterString)
        END) AS DECIMAL(18,2));

    SET @ServiceArea = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceArea:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceArea:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceArea:', @ParameterString))
                  - CHARINDEX('ServiceArea:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceType = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceType:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceType:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceType:', @ParameterString))
                  - CHARINDEX('ServiceType:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceDetail = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceDetail:', @ParameterString) + 14,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceDetail:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceDetail:', @ParameterString))
                  - CHARINDEX('ServiceDetail:', @ParameterString) - 14
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceLocation = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceLocation:', @ParameterString) + 16,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceLocation:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceLocation:', @ParameterString))
                  - CHARINDEX('ServiceLocation:', @ParameterString) - 16
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceDate = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceDate:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceDate:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceDate:', @ParameterString))
                  - CHARINDEX('ServiceDate:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceTime = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceTime:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceTime:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceTime:', @ParameterString))
                  - CHARINDEX('ServiceTime:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceAmount = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ServiceAmount:', @ParameterString) + 14,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceAmount:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceAmount:', @ParameterString))
                  - CHARINDEX('ServiceAmount:', @ParameterString) - 14
             ELSE LEN(@ParameterString)
        END) AS DECIMAL(18,2));

    SET @DoneBy = SUBSTRING(@ParameterString,
        CHARINDEX('DoneBy:', @ParameterString) + 7,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('DoneBy:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('DoneBy:', @ParameterString))
                  - CHARINDEX('DoneBy:', @ParameterString) - 7
             ELSE LEN(@ParameterString)
        END);

    SET @Supervisor = SUBSTRING(@ParameterString,
        CHARINDEX('Supervisor:', @ParameterString) + 11,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('Supervisor:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('Supervisor:', @ParameterString))
                  - CHARINDEX('Supervisor:', @ParameterString) - 11
             ELSE LEN(@ParameterString)
        END);

    SET @InstructedBy = SUBSTRING(@ParameterString,
        CHARINDEX('InstructedBy:', @ParameterString) + 13,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('InstructedBy:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('InstructedBy:', @ParameterString))
                  - CHARINDEX('InstructedBy:', @ParameterString) - 13
             ELSE LEN(@ParameterString)
        END);

    SET @WasteMaterial = SUBSTRING(@ParameterString,
        CHARINDEX('WasteMaterial:', @ParameterString) + 14,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('WasteMaterial:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('WasteMaterial:', @ParameterString))
                  - CHARINDEX('WasteMaterial:', @ParameterString) - 14
             ELSE LEN(@ParameterString)
        END);

    SET @HasAttachment = SUBSTRING(@ParameterString,
        CHARINDEX('HasAttachment:', @ParameterString) + 14,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('HasAttachment:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('HasAttachment:', @ParameterString))
                  - CHARINDEX('HasAttachment:', @ParameterString) - 14
             ELSE LEN(@ParameterString)
        END);

    -- Parse and Extract ID Parameters
    SET @CategoryID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('CategoryID:', @ParameterString) + 11,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('CategoryID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('CategoryID:', @ParameterString))
                  - CHARINDEX('CategoryID:', @ParameterString) - 11
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @AssetTypeID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('AssetTypeID:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('AssetTypeID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('AssetTypeID:', @ParameterString))
                  - CHARINDEX('AssetTypeID:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @MakeID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('MakeID:', @ParameterString) + 7,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('MakeID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('MakeID:', @ParameterString))
                  - CHARINDEX('MakeID:', @ParameterString) - 7
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ModelID = TRY_CAST(SUBSTRING(@ParameterString,
        CHARINDEX('ModelID:', @ParameterString) + 8,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ModelID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ModelID:', @ParameterString))
                  - CHARINDEX('ModelID:', @ParameterString) - 8
             ELSE LEN(@ParameterString)
        END) AS INT);

    SET @ServiceTypeID = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceTypeID:', @ParameterString) + 14,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceTypeID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceTypeID:', @ParameterString))
                  - CHARINDEX('ServiceTypeID:', @ParameterString) - 14
             ELSE LEN(@ParameterString)
        END);

    IF EXISTS (SELECT 1 FROM dbo.trn_MachineServiceEntry WHERE EntryID = @EntryID)
    BEGIN
        UPDATE dbo.trn_MachineServiceEntry
        SET Owner = @Owner,
            CategoryID = @CategoryID,
            AssetTypeID = @AssetTypeID,
            MakeID = @MakeID,
            ModelID = @ModelID,
            ServiceTypeID = @ServiceTypeID,
            Employee = @Employee,
            MachineID = @MachineID,
            HMR = @HMR,
            KMR = @KMR,
            Cum = @Cum,
            ServiceArea = @ServiceArea,
            ServiceType = @ServiceType,
            ServiceDetail = @ServiceDetail,
            ServiceLocation = @ServiceLocation,
            ServiceDate = @ServiceDate,
            ServiceTime = @ServiceTime,
            ServiceAmount = @ServiceAmount,
            DoneBy = @DoneBy,
            Supervisor = @Supervisor,
            InstructedBy = @InstructedBy,
            WasteMaterial = @WasteMaterial,
            HasAttachment = @HasAttachment,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE EntryID = @EntryID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.trn_MachineServiceEntry (
            EntryID, Owner, Employee, MachineID, HMR, KMR, Cum,
            ServiceArea, ServiceType, ServiceDetail, ServiceLocation,
            ServiceDate, ServiceTime, ServiceAmount, DoneBy, Supervisor,
            InstructedBy, WasteMaterial, HasAttachment, IsActive, CreatedBy, CreatedOn,
            CategoryID, AssetTypeID, MakeID, ModelID, ServiceTypeID
        ) VALUES (
            @EntryID, @Owner, @Employee, @MachineID, @HMR, @KMR, @Cum,
            @ServiceArea, @ServiceType, @ServiceDetail, @ServiceLocation,
            @ServiceDate, @ServiceTime, @ServiceAmount, @DoneBy, @Supervisor,
            @InstructedBy, @WasteMaterial, @HasAttachment, 1, @AuthEmployeeID, GETDATE(),
            @CategoryID, @AssetTypeID, @MakeID, @ModelID, @ServiceTypeID
        );
    END

    SELECT 'Success' AS Result;
END



ELSE IF (@Event = 'DeleteMachineServiceEntry')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @DelEntryID NVARCHAR(100);

    SET @DelEntryID = SUBSTRING(@ParameterString,
        CHARINDEX('EntryID:', @ParameterString) + 8,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('EntryID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('EntryID:', @ParameterString))
                  - CHARINDEX('EntryID:', @ParameterString) - 8
             ELSE LEN(@ParameterString)
        END);

    IF ISNULL(@DelEntryID, '') <> ''
    BEGIN
        UPDATE dbo.trn_MachineServiceEntry
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE EntryID = @DelEntryID;
    END

    SELECT 'Success' AS Result;
END

ELSE IF (@Event = 'GetServiceAreaList')
BEGIN
    SELECT DISTINCT ServiceAreaName
    FROM dbo.mst_ServiceArea
    WHERE ISNULL(IsActive, 1) = 1
    ORDER BY ServiceAreaName;
END

ELSE IF (@Event = 'GetAssetCategoryList')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        c.CategoryID,
        c.CategoryName,
        c.AssetTypeID,
        c.IsActive
    FROM dbo.mst_AssetCategory c
    WHERE ISNULL(c.IsActive,1)=1
    ORDER BY c.CategoryName;
END

ELSE IF (@Event = 'GetAssetCategoryList')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        c.CategoryID,
        c.CategoryName,
        c.AssetTypeID,
        c.IsActive
    FROM dbo.mst_AssetCategory c
    WHERE ISNULL(c.IsActive,1)=1
    ORDER BY c.CategoryName;
END

ELSE IF (@Event = 'GetAssetCategoryListNew')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT
        c.CategoryID,
        c.AssetUniqueId,
        c.AssetCatName,
        c.IsActive
    FROM dbo.mst_AssetCat c
    WHERE ISNULL(c.IsActive,1)=1
    ORDER BY c.AssetCatName;
END

ELSE IF (@Event = 'GetServiceTypeList')
BEGIN
    SELECT 
        st.ServiceTypeID, 
        sa.ServiceAreaName,
        st.ServiceTypeName, 
        sa.CategoryID,
        c.CategoryName,
        st.ApproximateCost,
        sa.IsCheckType,
        sa.Priority,
        st.IsActive, 
        st.CreatedOn, 
        st.ModifiedOn
    FROM dbo.mst_ServiceType st
    INNER JOIN dbo.mst_ServiceArea sa ON sa.ServiceAreaID = st.ServiceAreaID
    LEFT JOIN dbo.mst_AssetCategory c ON c.CategoryID = sa.CategoryID
    ORDER BY st.ServiceTypeName;
END

ELSE IF (@Event = 'SaveServiceType')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @ServiceAreaID NVARCHAR(100);
    DECLARE @ServiceAreaName NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ServiceAreaName');
    DECLARE @ServiceTypeName NVARCHAR(200) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ServiceTypeName');
    DECLARE @ApproximateCost DECIMAL(18,2) = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'ApproximateCost') AS DECIMAL(18,2));
    DECLARE @IsCheckType BIT = ISNULL(TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IsCheckType') AS BIT), 0);
    DECLARE @Priority NVARCHAR(50) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'Priority');
    DECLARE @TypeIsActive BIT = TRY_CAST(DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'IsActive') AS BIT);

    -- Check if service area already exists, otherwise create it
    SELECT TOP 1 @ServiceAreaID = ServiceAreaID 
    FROM dbo.mst_ServiceArea 
    WHERE LTRIM(RTRIM(ServiceAreaName)) = LTRIM(RTRIM(@ServiceAreaName));

    IF ISNULL(@ServiceAreaID, '') = ''
    BEGIN
        SET @ServiceAreaID = 'SA-' + REPLACE(CAST(NEWID() AS NVARCHAR(50)), '-', '');

        INSERT INTO dbo.mst_ServiceArea (
            ServiceAreaID, ServiceAreaName, CategoryID, IsCheckType, Priority, IsActive, CreatedBy, CreatedOn
        ) VALUES (
            @ServiceAreaID, @ServiceAreaName, @CategoryID, @IsCheckType, @Priority, 1, @AuthEmployeeID, GETDATE()
        );
    END
    ELSE
    BEGIN
        UPDATE dbo.mst_ServiceArea
        SET CategoryID = @CategoryID,
            IsCheckType = @IsCheckType,
            Priority = @Priority,
            IsActive = 1,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ServiceAreaID = @ServiceAreaID;
    END

    -- Insert or Update Service Type
    IF EXISTS (SELECT 1 FROM dbo.mst_ServiceType WHERE ServiceTypeID = @ServiceTypeID)
    BEGIN
        UPDATE dbo.mst_ServiceType
        SET ServiceAreaID = @ServiceAreaID,
            ServiceTypeName = @ServiceTypeName,
            ApproximateCost = @ApproximateCost,
            IsActive = ISNULL(@TypeIsActive, 1),
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ServiceTypeID = @ServiceTypeID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.mst_ServiceType (
            ServiceTypeID, ServiceAreaID, ServiceTypeName, ApproximateCost, IsActive, CreatedBy, CreatedOn
        ) VALUES (
            @ServiceTypeID, @ServiceAreaID, @ServiceTypeName, @ApproximateCost, ISNULL(@TypeIsActive, 1), @AuthEmployeeID, GETDATE()
        );
    END

    SELECT 'Success' AS Result;
END

ELSE IF (@Event = 'DeleteServiceType')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @DelServiceTypeID NVARCHAR(100);

    SET @DelServiceTypeID = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceTypeID:', @ParameterString) + 14,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceTypeID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceTypeID:', @ParameterString))
                  - CHARINDEX('ServiceTypeID:', @ParameterString) - 14
             ELSE LEN(@ParameterString)
        END);

    IF ISNULL(@DelServiceTypeID, '') <> ''
    BEGIN
        UPDATE dbo.mst_ServiceType
        SET IsActive = 0,
            ModifiedBy = @AuthEmployeeID,
            ModifiedOn = GETDATE()
        WHERE ServiceTypeID = @DelServiceTypeID;
    END

    SELECT 'Success' AS Result;
END

ELSE IF (@Event = 'GetMachineLocation')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    DECLARE @ReqAssetID NVARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetId');

    DECLARE @BaseAssetID INT = NULL;
    SELECT TOP 1 @BaseAssetID = AssetID
    FROM dbo.mst_Asset
    WHERE AssetCode = @ReqAssetID OR AssetID = TRY_CAST(@ReqAssetID AS INT) OR RegistrationNo = @ReqAssetID;

    IF @BaseAssetID IS NULL
    BEGIN
        SELECT '' AS ProjectName, '' AS ProjectID;
        RETURN;
    END

  
    SELECT TOP 1 @ProjectID = ProjectID
    FROM dbo.trn_ProjectMachineAllocation
    WHERE AssetID = @BaseAssetID
      AND IsActive = 1
      AND EndDate IS NULL
    ORDER BY ID DESC;

    IF @ProjectID IS NOT NULL
    BEGIN
        SELECT TOP 1 
            ProjectName, 
            ProjectID
        FROM dbo.mst_Project
        WHERE ProjectID = @ProjectID;
    END
    
END


ELSE IF(@Event = 'GetMachineReadingForServiceSchedule')
BEGIN
   if ISNULL (@AuthEmployeeID,0) =0
   begin
    RAISERROR('Unauthoried access',16,1);
	return;
   end
   --declare @assetId NVARCHAR(100) = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString,'AssetId');
   SET @assetId = DB_Masters.dbo.GetParameterValue_CSS_Lang(@ParameterString, 'AssetId');
   select TOP 1 AssetID,EndHMR AS HMR,EndKMR As KMR , ProductionQty as Cum,
   CONVERT(VARCHAR(10), EndDateTime, 103) + ' Time :- ' + CONVERT(VARCHAR(8), EndDateTime, 108) AS Date   
   from trn_DailyLog td where AssetID = @assetId order by EndDateTime desc;

END

ELSE IF (@Event = 'GetAssetCategory')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthoried access',16,1);
        RETURN;
    END

    SELECT DISTINCT
        c.AssetCatName AS SubTypeName,
        m.MakeName AS MakeName,
        md.ModelNo AS ModelNo
    FROM dbo.mst_AssetModel md
    INNER JOIN dbo.mst_AssetMake m ON m.MakeID = md.MakeID
    INNER JOIN dbo.mst_AssetSubType s ON s.AssetTypeID = md.AssetTypeID
    INNER JOIN dbo.mst_AssetCat c ON c.CategoryID = s.CategoryID
    WHERE ISNULL(md.IsActive, 1) = 1
      AND ISNULL(m.IsActive, 1) = 1
      AND ISNULL(s.IsActive, 1) = 1
      AND ISNULL(c.IsActive, 1) = 1;
END


ELSE IF (@Event = 'GetMachineServiceSchedules')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SELECT DISTINCT
        s.ScheduleID,S.AssetTypeID, s.CategoryID, s.MakeID, s.ModelID, s.ServiceArea, s.ServiceType, s.UOM,
        s.ThresholdFirst, s.ThresholdSecond, s.ThresholdEvery,
        s.AlertFirst, s.AlertFirstTemplate, s.AlertSecond, s.AlertSecondTemplate,
        s.AlertThird, s.AlertThirdTemplate, s.AlertLast, s.AlertLastTemplate,
        s.Remarks, s.IsActive
    FROM dbo.trn_MachineServiceSchedule s
    INNER JOIN dbo.mst_AssetCat ac ON ac.AssetCatName = s.CategoryID
    WHERE s.IsActive = 1
      AND ac.IsActive = 1
    ORDER BY s.CategoryID,s.AssetTypeID, s.MakeID, s.ModelID;
END

ELSE IF (@Event = 'GetAssetCategoryFromCatMaster')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthoried access',16,1);
        RETURN;
    END
    SELECT DISTINCT
        AssetTypeID AS CategoryID,
        SubTypeName AS AssetCatName
    FROM dbo.mst_AssetSubType
    WHERE ISNULL(IsActive, 1) = 1;
END


ELSE IF (@Event = 'GetAssetSubTypeFromCatMaster')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthoried access',16,1);
        RETURN;
    END
    SELECT DISTINCT
	    AssetTypeID as AssetTypeID,
        SubTypeName AS SubTypeName
    FROM dbo.mst_AssetSubType  where CategoryID = @CategoryID
END


ELSE IF (@Event = 'GetAssetCatList')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END

    SELECT CategoryID, AssetCatName, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
    FROM dbo.mst_AssetCat
    ORDER BY AssetCatName;
END

ELSE IF (@Event = 'AddAssetCat')
BEGIN
	IF ISNULL(@AuthEmployeeID,0)=0
		BEGIN
			RAISERROR('Unauthorized access.',16,1);
			RETURN;
		END
		IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
		BEGIN
			RAISERROR('Only Admin can Add AssetCat.',16,1);
			RETURN;
		END
    SET @AssetCatName = LTRIM(RTRIM(ISNULL(@AssetCatName,'')));
    IF @AssetCatName = ''
    BEGIN
        SELECT 0 AS Status, 'AssetCat name is required.' AS Msg;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM dbo.mst_AssetCat WHERE LTRIM(RTRIM(AssetCatName)) = @AssetCatName)
    BEGIN
        SELECT 0 AS Status, 'AssetCat name already exists.' AS Msg;
        RETURN;
    END;

    INSERT INTO dbo.mst_AssetCat (AssetCatName, IsActive, CreatedBy, CreatedOn)
    VALUES (@AssetCatName, ISNULL(@IsActive,1), ISNULL(@CreatedBy,0), GETDATE());

    SELECT 1 AS Status, 'AssetCat added successfully.' AS Msg, CAST(SCOPE_IDENTITY() AS INT) AS CategoryID;
END

ELSE IF (@Event = 'EditAssetCat')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Edit Make.',16,1);
		RETURN;
	END

    SET @AssetCatName = LTRIM(RTRIM(ISNULL(@AssetCatName,'')));
    IF ISNULL(@CategoryID,0) = 0
    BEGIN
        SELECT 0 AS Status, 'CategoryID is required.' AS Msg;
        RETURN;
    END;

    IF @AssetCatName = ''
    BEGIN
        SELECT 0 AS Status, 'AssetCat name is required.' AS Msg;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM dbo.mst_AssetCat WHERE LTRIM(RTRIM(AssetCatName)) = @AssetCatName AND CategoryID <> @CategoryID)
    BEGIN
        SELECT 0 AS Status, 'AssetCat name already exists.' AS Msg;
        RETURN;
    END;

    UPDATE dbo.mst_AssetCat
    SET AssetCatName = @AssetCatName,
        IsActive = ISNULL(@IsActive, IsActive),
        ModifiedBy = ISNULL(@ModifiedBy,0),
        ModifiedOn = GETDATE()
    WHERE CategoryID = @CategoryID;

    SELECT 1 AS Status, 'AssetCat updated successfully.' AS Msg, @CategoryID AS CategoryID;
END

ELSE IF (@Event = 'DeleteAssetCat')
BEGIN
IF ISNULL(@AuthEmployeeID,0)=0
	BEGIN
		RAISERROR('Unauthorized access.',16,1);
		RETURN;
	END
	IF LTRIM(RTRIM(ISNULL(@AuthRoleName,''))) <> 'Admin'
	BEGIN
		RAISERROR('Only Admin can Delete AssetCat.',16,1);
		RETURN;
	END
    IF ISNULL(@CategoryID,0) = 0
    BEGIN
        SELECT 0 AS Status, 'CategoryID is required.' AS Msg;
        RETURN;
    END;

    DELETE FROM dbo.mst_AssetCat WHERE CategoryID = @CategoryID;
    SELECT 1 AS Status, 'AssetCat deleted successfully.' AS Msg, @CategoryID AS CategoryID;
END

ELSE IF (@Event = 'GetMachineServiceSchedulePreview')
BEGIN
    IF ISNULL(@AuthEmployeeID,0)=0
    BEGIN
        RAISERROR('Unauthorized access.',16,1);
        RETURN;
    END

    SET @MachineID = SUBSTRING(@ParameterString,
        CHARINDEX('MachineID:', @ParameterString) + 10,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('MachineID:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('MachineID:', @ParameterString))
                  - CHARINDEX('MachineID:', @ParameterString) - 10
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceArea = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceArea:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceArea:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceArea:', @ParameterString))
                  - CHARINDEX('ServiceArea:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    SET @ServiceType = SUBSTRING(@ParameterString,
        CHARINDEX('ServiceType:', @ParameterString) + 12,
        CASE WHEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceType:', @ParameterString)) > 0
             THEN CHARINDEX('~!', @ParameterString, CHARINDEX('ServiceType:', @ParameterString))
                  - CHARINDEX('ServiceType:', @ParameterString) - 12
             ELSE LEN(@ParameterString)
        END);

    DECLARE @AssetModelID INT;
    DECLARE @AssetMakeID INT;
    DECLARE @AssetTypeID_Var INT;
    DECLARE @AssetCategoryID INT;

    -- 2. Resolve Category, SubType, MakeID, and ModelID using name-based joins on the Machine
    SELECT TOP 1 
        @AssetCategoryID = a.CategoryID,
        @AssetTypeID_Var = a.AssetTypeID,
        @AssetMakeID = mk.MakeID,
        @AssetModelID = md.ModelID
    FROM dbo.mst_Asset a
    LEFT JOIN dbo.mst_AssetMake mk ON LTRIM(RTRIM(UPPER(mk.MakeName))) = LTRIM(RTRIM(UPPER(a.Make))) AND mk.AssetTypeID = a.AssetTypeID
    LEFT JOIN dbo.mst_AssetModel md ON LTRIM(RTRIM(UPPER(md.ModelNo))) = LTRIM(RTRIM(UPPER(a.ModelName))) AND md.AssetTypeID = a.AssetTypeID
    WHERE a.AssetCode = @MachineID OR CAST(a.AssetID AS NVARCHAR(100)) = @MachineID;

    -- 3. Resolve ServiceTypeID using ServiceType Name
    DECLARE @ResolvedServiceTypeID NVARCHAR(100);
    SELECT TOP 1 @ResolvedServiceTypeID = ServiceTypeID 
    FROM dbo.mst_ServiceType 
    WHERE LTRIM(RTRIM(UPPER(ServiceTypeName))) = LTRIM(RTRIM(UPPER(@ServiceType)));

    -- 4. Query trn_MachineServiceSchedule by resolved model specifications
    SELECT TOP 1
        UOM,
        ThresholdFirst,
        ThresholdSecond,
        ThresholdEvery,
        Remarks,
        IsActive
    FROM dbo.trn_MachineServiceSchedule
    WHERE IsActive = 1
      AND (
          (ModelID = @AssetModelID AND ISNULL(ModelID, 0) > 0)
          OR
          (MakeID = @AssetMakeID AND CategoryID = @AssetCategoryID AND ISNULL(ModelID, 0) = 0)
          OR
          (CategoryID = @AssetCategoryID AND ISNULL(MakeID, 0) = 0 AND ISNULL(ModelID, 0) = 0)
      )
      AND (
          ServiceTypeID = @ResolvedServiceTypeID 
          OR 
          LTRIM(RTRIM(UPPER(ServiceType))) = LTRIM(RTRIM(UPPER(@ServiceType)))
      );
END

ELSE IF(@Event='GetLogsheetDetailReport')
BEGIN

    -- 1. Default date values if empty
    IF @datefrom IS NULL OR @datefrom = ''
        SET @datefrom = CONVERT(VARCHAR(19), DATEADD(DAY, -1, GETDATE()), 120);

    IF @dateto IS NULL OR @dateto = ''
        SET @dateto = CONVERT(VARCHAR(19), GETDATE(), 120);

    -- 2. Detect User Role & Operator ID using actual schema columns
    DECLARE @UserRole VARCHAR(50) = '';
    DECLARE @UserOperatorID INT = NULL;

    IF ISNULL(@mis_session_userid, '') <> '' AND @mis_session_userid <> '0'
    BEGIN
        SELECT TOP 1 
            @UserRole = ISNULL(r.RoleName, ''),
            @UserOperatorID = ISNULL(ur.OperatorID, o.OperatorID)
        FROM dbo.mst_UserRole ur
        LEFT JOIN dbo.mst_Role r ON r.RoleID = ur.RoleID
        LEFT JOIN dbo.mst_Operator o ON o.EmployeeID = ur.EmployeeID OR o.OperatorID = ur.OperatorID
        WHERE CAST(ur.EmployeeID AS VARCHAR(50)) = @mis_session_userid 
           OR CAST(ur.UserRoleID AS VARCHAR(50)) = @mis_session_userid;
    END

    -- 3. Log Data CTE
    ;WITH LogData AS
    (
        SELECT
            a.AssetName,
            a.AssetID,
            dl.LogType AS Status,
            CONVERT(VARCHAR(10), dl.StartDateTime, 105) AS [Start Date],
            CONVERT(VARCHAR(5), CAST(dl.StartDateTime AS TIME), 108) AS [Start Time],
            CONVERT(VARCHAR(10), CAST(dl.EndDateTime AS DATE), 105) AS [Stop Date],
            CONVERT(VARCHAR(5), CAST(dl.EndDateTime AS TIME), 108) AS [Stop Time],

            DATEDIFF(MINUTE, dl.StartDateTime, dl.EndDateTime) AS WorkingMinutes,

            CASE
                WHEN dl.StartDateTime IS NULL OR dl.EndDateTime IS NULL THEN NULL
                ELSE
                    CAST(DATEDIFF(MINUTE, dl.StartDateTime, dl.EndDateTime)/60 AS VARCHAR(10))
                    + ':'
                    + RIGHT('00' + CAST(DATEDIFF(MINUTE, dl.StartDateTime, dl.EndDateTime)%60 AS VARCHAR(2)), 2)
            END AS [Total Working],

            ISNULL(dl.BreakdownHours, 0) AS [Break Down],

            ISNULL(dl.StartHMR, 0) AS StartHMR,
            ISNULL(dl.EndHMR, 0) AS EndHMR,
            ISNULL(dl.EndHMR, 0) - ISNULL(dl.StartHMR, 0) AS TotalHMR,

            ISNULL(dl.StartKMR, 0) AS StartKMR,
            ISNULL(dl.EndKMR, 0) AS EndKMR,
            ISNULL(dl.EndKMR, 0) - ISNULL(dl.StartKMR, 0) AS TotalKMR,

            0 AS [Diesel Issued],

            ISNULL(dl.ProductionQty, 0) AS [Cum.Ton],
            ISNULL(dl.ProductionQty, 0) AS Qty,

            ISNULL(dl.Remarks, '') AS Remarks,
            ISNULL(u.UserName, '') AS [Entered By],
            ISNULL(o.FullName, '') AS Operator,

            CASE
                WHEN ISNULL(dl.EndReadingPhoto, '') <> '' THEN dl.EndReadingPhoto
                WHEN ISNULL(dl.RemarkPhoto, '') <> '' THEN dl.RemarkPhoto
                ELSE ''
            END AS Photo,

            dl.StartDateTime

        FROM dbo.trn_DailyLog dl
        LEFT JOIN dbo.mst_Asset a ON a.AssetID = dl.AssetID
        LEFT JOIN dbo.mst_AssetType at ON at.AssetTypeID = a.AssetTypeID
        LEFT JOIN dbo.mst_Project p ON p.ProjectID = dl.ProjectID
        LEFT JOIN dbo.mst_Division d ON d.DivisionID = p.DivisionID
        LEFT JOIN dbo.mst_Operator o ON o.OperatorID = dl.OperatorID
        LEFT JOIN dbo.mst_UserRole u ON u.EmployeeID = dl.CreatedBy

        WHERE
            CAST(dl.LogDate AS DATE) BETWEEN TRY_CAST(@datefrom AS DATE) AND TRY_CAST(@dateto AS DATE)
            AND (ISNULL(@ddl_month, '') = '' OR RIGHT('0' + CAST(MONTH(dl.LogDate) AS VARCHAR(2)), 2) = @ddl_month)
            AND (ISNULL(@text_year, '') = '' OR CAST(YEAR(dl.LogDate) AS VARCHAR(4)) = @text_year)
            AND (ISNULL(@ddl_division, '') = '' OR CAST(p.DivisionID AS VARCHAR(20)) = @ddl_division)
            AND (ISNULL(@ddl_customer, '') = '' OR a.OwnershipType = @ddl_customer)
            AND (ISNULL(@ddl_site, '') = '' OR CAST(dl.ProjectID AS VARCHAR(20)) = @ddl_site)
            AND (ISNULL(@ddl_machine, '') = '' OR CAST(dl.AssetID AS VARCHAR(20)) = @ddl_machine)
            AND (ISNULL(@ddl_machinetype, '') = '' OR at.TypeName = @ddl_machinetype)
            AND (ISNULL(@chk_breakdownonly, 0) = 0
                OR ISNULL(dl.MachineStatus, '') IN ('Breakdown', 'Under Maintenance'))

            -- 4. Role-Based Scoping
            AND (
                @UserRole <> 'Operator' 
                OR @UserOperatorID IS NULL 
                OR dl.OperatorID = @UserOperatorID
            )
    )

    -- 5. Result Output
    SELECT *
    FROM
    (
        SELECT
            AssetName,		
            AssetID,
            Status,
            [Start Date],
            [Start Time],
            [Stop Date],
            [Stop Time],
            [Total Working],
            [Break Down],
            StartHMR,
            EndHMR,
            TotalHMR,
            StartKMR,
            EndKMR,
            TotalKMR,
            [Diesel Issued],
            [Cum.Ton],
            Qty,
            Remarks,
            [Entered By],
            Operator,
            Photo,
            0 AS SortOrder,
            StartDateTime
        FROM LogData

        UNION ALL

        SELECT
            'Total',
            AssetID,
            '', 
            '', 
            '', 
            '', 
            '', 

            CAST(SUM(WorkingMinutes)/60 AS VARCHAR(10))
            + ':'
            + RIGHT('00' + CAST(SUM(WorkingMinutes)%60 AS VARCHAR(2)), 2),

            SUM([Break Down]),

            NULL,
            NULL,
            SUM(TotalHMR),

            NULL,
            NULL,
            SUM(TotalKMR),

            SUM([Diesel Issued]),
            SUM([Cum.Ton]),
            SUM(Qty),

            '',
            '',
            '',
            '',

            1,
            MAX(StartDateTime)

        FROM LogData
        GROUP BY AssetID
    ) A

    ORDER BY
        AssetID,
        SortOrder,
        StartDateTime;

END

UPDATE dbo.tbl_Log SET executiontime = datediff(ms,CreatedDate,getdate()) WHERE Id=@LastId;

END TRY
BEGIN CATCH
UPDATE dbo.tbl_Log SET Reasons=ERROR_MESSAGE(),Status='Error',executiontime = datediff(ms,CreatedDate,getdate()) WHERE Id=@LastId;
SELECT 'Error' Status,ERROR_MESSAGE() Msg;
END CATCH
END