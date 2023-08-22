/*

Cleaning Data in SQL Queries

*/

select * from NashvilleHousing;

-- Standardize Date Format
select SaleDate from NashvilleHousing
select convert(date,SaleDate) from NashvilleHousing;

update  NashvilleHousing
set SaleDate= convert(date,SaleDate); 

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate);

select SaleDate,SaleDateConverted from NashvilleHousing

-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
---Where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress,ISNULL(a.propertyAddress,b.PropertyAddress) from 
NashvilleHousing a join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.propertyAddress,b.PropertyAddress) from 
NashvilleHousing a join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)
select PropertyAddress from NashvilleHousing


select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
       SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as city 
from NashvilleHousing;

Alter table NashvilleHousing
add Propertysplitaddress nvarchar(255);

update NashvilleHousing
set Propertysplitaddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * from NashvilleHousing


select OwnerAddress from NashvilleHousing

select PARSENAME(replace(ownerAddress,',','.'),3),
       PARSENAME(replace(ownerAddress,',','.'),2),
       PARSENAME(replace(ownerAddress,',','.'),1) from NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * from NashvilleHousing;


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant),COUNT(SoldAsVacant) 
from NashvilleHousing
group by SoldAsVacant
order by 2;


select SoldAsVacant ,
case when SoldAsVacant ='Yes' then 'Y'
     When SoldAsVacant ='No' Then 'N'
	 else SoldAsVacant
	 end 
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant ='Yes' then 'Y'
     When SoldAsVacant ='No' Then 'N'
	 else SoldAsVacant
	 end 

 select distinct(SoldAsVacant),COUNT(SoldAsVacant) 
from NashvilleHousing
group by SoldAsVacant
order by 2;

-- Remove Duplicates
with RownumCTE As (
select *, ROW_NUMBER() over (partition by  ParcelID,
				                           PropertyAddress,
				                            SalePrice,
				                            SaleDate,
				                           LegalReference
				                         ORDER BY
					                      UniqueID) as rownum
from NashvilleHousing)

select * from RownumCTE
where rownum>1
Order by PropertyAddress

/* select * from RownumCTE
where rownum>1
for deleting that duplicates
*/

/* -- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


*/




