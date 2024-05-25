


--Data Cleaning Project in SQL Queries


Select*
From PortfolioProject.dbo.NashvilleHousing


-- Standardize Date Format


Select SaleDateConverted, Convert (Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate = Convert (Date, SaleDate)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = Convert (Date, SaleDate)

--Populate Property Address Data


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is Null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
IsNull (a.PropertyAddress, b.PropertyAddress)
From  PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
On a.ParcelID = b.ParcelID
And a.UniqueID <> b.UniqueID
Where a.PropertyAddress is Null

Update a
Set PropertyAddress = IsNull (a.PropertyAddress, b.PropertyAddress)
From  PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
On a.ParcelID = b.ParcelID
And a.UniqueID <> b.UniqueID
Where a.PropertyAddress is Null

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is Null
--Order by ParcelID

Select
Substring(PropertyAddress,1,Charindex(',', PropertyAddress)-1) as Address
From PortfolioProject.dbo.NashvilleHousing


Select
Substring(PropertyAddress,1,Charindex(',', PropertyAddress)-1) as Address
,Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress,1,Charindex(',', PropertyAddress)-1) 

Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress))

Select*
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

Select*
From PortfolioProject.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'N' then 'No'
 When SoldAsVacant = 'Y' then 'Yes'
 Else SoldAsVacant
 End
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'N' then 'No'
 When SoldAsVacant = 'Y' then 'Yes'
 Else SoldAsVacant
 End

 --Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

Select*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing

-- Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing

  

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  DROP COLUMN  PropertyAddress, TaxDistrict

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  DROP COLUMN  SaleDate
