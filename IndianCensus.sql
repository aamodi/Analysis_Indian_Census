/*
 Portfolio Project
 Data Set = Indian Census 2011
*/

Select *
From [CENSUS PROJECT]..[Data1]

Select *
From [CENSUS PROJECT]..[Data2]


--Total Population of India in 2011

Select Sum(Population) AS Total_Population
From [CENSUS PROJECT]..Data2

--AVG Grwoth rate by state

Select
	State,
	AVG(Growth)*100 as Avg_Growth_Per
From [CENSUS PROJECT]..[Data1]
Group by State
Order By Avg_Growth_Per DESC

--AVG Literacy ratio by state

Select
	State,
	Round(AVG(Literacy),2) as Avg_Literacy_Ratio
From [CENSUS PROJECT]..[Data1]
Group by State
Order By Avg_Literacy_Ratio DESC

----AVG Literacy ratio by state greater than 90

Select
	State,
	Round(AVG(Literacy),2) as Avg_Literacy_Ratio
From [CENSUS PROJECT]..[Data1]
Group by State
Having Round(AVG(Literacy),2) > 90
Order By Avg_Literacy_Ratio DESC

--Calculating Male and Female

Select
	c.district,
	c.[State ],
	Round(c.population/(c.Sex_Ratio+1),0) as Males,
	Round((c.population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) as Females
From
	(Select
		a.District,
		a.[State ],
		a.Sex_Ratio/1000 as sex_ratio,
		b.Population

	From [CENSUS PROJECT]..[Data1] a
	Join [CENSUS PROJECT]..[Data2] b
	ON a.District=b.District) c

--Calculating Male and Female w.r.t States

Select
	d.[State ],
	Sum(d.Males) as Total_Males,
	Sum(d.Females) as Total_Females
From
	(Select
		c.district,
		c.[State ],
		Round(c.population/(c.Sex_Ratio+1),0) as Males,
		Round((c.population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) as Females
	From
		(Select
			a.District,
			a.[State ],
			a.Sex_Ratio/1000 as sex_ratio,
			b.Population

		From [CENSUS PROJECT]..[Data1] a
		Join [CENSUS PROJECT]..[Data2] b
		ON a.District=b.District) c) d
Group by d.[State ]

--Calculating total number of literate and illiterate people

Select
	district,
	state,
	d.Literate_People as Literate_People,
	population-d.Literate_People as Illiterate_People,
	d.population
From
	(Select
		district,
		state,
		population,
		Round(c.Literacy_rate*population,0) as Literate_People
	From
		(Select
			a.District,
			a.[State ],
			a.Literacy/100 as Literacy_rate,
			b.Population

		From [CENSUS PROJECT]..[Data1] a
		Join [CENSUS PROJECT]..[Data2] b
		ON a.District=b.District) c ) d

--Calculating total number of literate and illiterate people w.r.t States

Select
	state,
	SUM(e.Literate_People) as Total_Literate_People,
	Sum(e.Illiterate_People) as Total_Illiterate_people
From
	(Select
		district,
		state,
		d.Literate_People as Literate_People,
		population-d.Literate_People as Illiterate_People,
		d.population
	From
		(Select
			district,
			state,
			population,
			Round(c.Literacy_rate*population,0) as Literate_People
		From
			(Select
				a.District,
				a.[State ],
				a.Literacy/100 as Literacy_rate,
				b.Population

			From [CENSUS PROJECT]..[Data1] a
			Join [CENSUS PROJECT]..[Data2] b
			ON a.District=b.District) c ) d) e
Group By state

--Getting top 3 districts with highest literacy rate from each states

Select
	a.*
From
	(Select 
		district,
		state,
		literacy,
		rank() over(Partition by state Order by literacy desc) as rnk
	From 
		[CENSUS PROJECT]..[Data1]) a
Where
	rnk in (1,2,3)	

--Getting bottom 3 districts with lowest literacy rate from each states

Select
	a.*
From
	(Select 
		district,
		state,
		literacy,
		rank() over(Partition by state Order by literacy asc) as rnk
	From 
		[CENSUS PROJECT]..[Data1]) a
Where
	rnk in (1,2,3)