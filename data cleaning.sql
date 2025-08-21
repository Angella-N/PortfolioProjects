--cleaning Data

SELECT *
FROM PortfolioProject.dbo.[NashvileHousing]

--Standardize Date Format


SELECT SaleDate
FROM PortfolioProject.dbo.[NashvileHousing]

--This is for when theres time that is put against the date eg the zeroes
SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.[NashvileHousing] 

UPDATE NashvileHousing
SET SaleDate = CONVERT(Date,SaleDate)

--option two
ALTER TABLE PortfolioProject.dbo.NashvileHousing
ADD SaleDateConverted DATE;

UPDATE PortfolioProject.dbo.NashvileHousing
SET SaleDateConverted = TRY_CONVERT(DATE, SaleDate);

--Populate Property Adress data

SELECT PropertyAddress
FROM PortfolioProject.dbo.[NashvileHousing]

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject.dbo.NashvileHousing A
JOIN PortfolioProject.dbo.NashvileHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress is null

Update A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject.dbo.NashvileHousing A
JOIN PortfolioProject.dbo.NashvileHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress is null

--Breaking out  Adress into individual columns (Adress, City, State)
Select PropertyAddress
from PortfolioProject.dbo.NashvileHousing

SELECT 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address
  FROM PortfolioProject.dbo.NashvileHousing;

SELECT 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address,
  CHARINDEX(',', PropertyAddress) 
FROM PortfolioProject.dbo.NashvileHousing;

--Removing the Comas--
SELECT 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
  , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject.dbo.NashvileHousing;


ALTER TABLE PortfolioProject.dbo.NashvileHousing
ADD PropertySplitAdress Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvileHousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.NashvileHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvileHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT*
FROM PortfolioProject.dbo.NashvileHousing

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvileHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM PortfolioProject.dbo.NashvileHousing


ALTER TABLE PortfolioProject.dbo.NashvileHousing
ADD OwnerSplitAdress Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvileHousing
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE PortfolioProject.dbo.NashvileHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvileHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE PortfolioProject.dbo.NashvileHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvileHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


--Change 1 and 0 to Yes and No in "Sold as vacant"


SELECT Distinct(SoldAsVacant)
FROM PortfolioProject.dbo.NashvileHousing

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvileHousing
Group by SoldAsVacant
Order by 2

select SoldAsVacant
, CASE When SoldAsVacant = '1' then 'Yes'
		When SoldAsVacant = '0' THEN 'No'
		END
FROM PortfolioProject.dbo.NashvileHousing

UPDATE PortfolioProject.dbo.NashvileHousing
SET SoldAsVacant =  CASE When SoldAsVacant = '1' then 'Yes'
		When SoldAsVacant = '0' THEN 'No'
		END
--Alternatively incase column SoldAsVacant is of data type BIT, which only accepts: 0 or 1 (or TRUE/FALSE in some systems), Not text values like 'Yes' or 'No'. Then leave it. However, i changed the column data type

ALTER TABLE PortfolioProject.dbo.NashvileHousing
ALTER COLUMN SoldAsVacant VARCHAR(10);

UPDATE PortfolioProject.dbo.NashvileHousing
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = '1' THEN 'Yes'
    WHEN SoldAsVacant = '0' THEN 'No'
END;

--Removing Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 SalePrice,
	             SaleDate,
	             LegalReference
	             ORDER BY
		         UniqueID
		         ) row_num

From  PortfolioProject.dbo.NashvileHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 SalePrice,
	             SaleDate,
	             LegalReference
	             ORDER BY
		         UniqueID
		         ) row_num

From  PortfolioProject.dbo.NashvileHousing
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

--Delete unused columns
SELECT *
From  PortfolioProject.dbo.NashvileHousing

ALTER TABLE PortfolioProject.dbo.NashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







