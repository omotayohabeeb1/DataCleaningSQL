/* 
Cleaning Data in SQL Queries
*/

USE NewPortfolioProject
SELECT *
FROM NewPortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------

-- Standardize Date Format
SELECT SaleDateConverted, CONVERT (Date, SaleDate)
FROM NewPortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT (Date, SaleDate) 

ALTER TABLE NashvilleHousing
ADD SaleDateConverted1 Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT (Date, SaleDate)

-----------------------------------------------------------------------------


-- Populate Property Address Data

SELECT *
FROM NewPortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NewPortfolioProject.dbo.NashvilleHousing a
JOIN NewPortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NewPortfolioProject.dbo.NashvilleHousing a
JOIN NewPortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



-------------------------------------------------------------------------------

-- Breaking out address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM NewPortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null
-- ORDER BY ParcelID


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address, SUBSTRING
(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address

FROM NewPortfolioProject.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NvarChar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVarChar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



SELECT *
FROM NewPortfolioProject.dbo.NashvilleHousing


SELECT OwnerAddress
FROM NewPortfolioProject.dbo.NashvilleHousing


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM NewPortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NvarChar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVarChar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVarChar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


SELECT *
FROM NewPortfolioProject.dbo.NashvilleHousing



-----------------------------------------------------------------------------



-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NewPortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2




SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NewPortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




----------------------------------------------------------------------------------------


-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelId,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueId
					) row_num

FROM NewPortfolioProject.dbo.NashvilleHousing
-- ORDER BY ParcelId
)
--DELETE
--FROM RowNumCTE
--WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress




SELECT *
FROM NewPortfolioProject.dbo.NashvilleHousing



---------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
FROM NewPortfolioProject.dbo.NashvilleHousing

ALTER TABLE NewPortfolioProject.dbo.NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NewPortfolioProject.dbo.NashvilleHousing
DROP Column SaleDate