select CustomerKey,
	FirstName + ISNULL(MiddleName, '') + LastName as FullName,
	BirthDate,
	Gender
From DimCustomer

