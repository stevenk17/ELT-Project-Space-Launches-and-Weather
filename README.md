
# Data Alliance For Science

# ELT-Project-Space-Launches-and-Meteorite Landings

<img src="https://media.giphy.com/media/3ohs4gSs3V0Q7qOtKU/giphy.gif" width=800> 
<img src="https://media.giphy.com/media/8vkEB6e3xgU5CusLES/giphy.gif" width=800, height=400>


## Project Proposal 

The proposal of this ETL is to extract data from a space launch data CSV and meteorite landing CSV, both from Kaggle. All this data will be transformed, centered around the launch date of each space craft, loaded into a Postgres SQL, hoping to tell a story of space launches in relation to meteorite landings. 

<img src="Images/ETL%20Image.PNG">

## Data Sources 
   Our Data sources were from kaggle and are CSVs.  
   
  - [x]  Space Launches (Source 1):https://www.kaggle.com/rosetabares/spacemissionsflightstatus
   
  - [x]  Meteorite Landings (Source 2):https://www.kaggle.com/nasa/meteorite-landings



## Project Report

### Extract:
The first step of the process was to import the CSV files into the Jupyter Notebook. Please note that there was some
editing done in Microsoft Excel so the files could be read better. Please see the code below in understanding the extraction process. 

It is important to note that in the beginning of our process of extracting data, we orginally wanted to scrape
a website with launch data. The results of scraping allowed us to realize that this wasn't what we were looking for. It wasn't
going to help us tell a story about space launches in relation to meteorite landings. But, please see the files attached in our repo for examination.

```Python
#Import CSV File
csv_file="Resources/SpaceMissions.csv"

#Store CSV File in Dataframe
space_missions_df=pd.read_csv(csv_file)

#Read Dataframe
space_missions_df.head()


```
```Python

#Import CSV File
csv_file="Resources/MTlanding.csv"

#Store CSV File in Dataframe
MT_landings_df=pd.read_csv(csv_file)

#Read Dataframe
MT_landings_df.head()


```


### Transform: 

After extracting the data, a new dataframe was established with the columns we needed. 

```Python
#Creating new dataframe with selected columns" Company, Launch Date, Launch Time, Launch Site, and Vehicle Type" 
new_space_missions_df = space_missions_df[["id","Company","Year","Launch Time","Launch Site","Vehicle Type"]]

#Highlight any nans with the color red. 
new_space_missions_df.style.highlight_null(null_color='red')

```

```Python
#create new data frame with selected columns
MT_landings_df=MT_landings_df[["name", "id", "mass", "year", "Lat","Long"]]
#display head
MT_landings_df.head()
```


In addition, we renamed some of the columns so PostgreSQL could read the dataframes better. In the early process of transfering the data, it was discovered that PostgreSQL did not like the column names. Also, the dataframes were both sorted by year to understand the dataframes better.

```Python
#Sort by date. 

spacemissions_df=spacemissions_df.rename(columns={"Company":"company"})

spacemissions_df=spacemissions_df.rename(columns={"Year":"year"})

spacemissions_df=spacemissions_df.rename(columns={"Launch Time":"launchtime"})

spacemissions_df=spacemissions_df.rename(columns={"Launch Site":"launchsite"})

spacemissions_df=spacemissions_df.rename(columns={"Vehicle Type":"vehicletype"})

spacemissions_df=spacemissions_df.sort_values(by='year')

#read as .style to show sorted 
spacemissions_df.head()
``` 
```Python
#Drop NANs
MT_landings_df=MT_landings_df.dropna(how="any")

#Rename columns
MT_landings_df=MT_landings_df.rename(columns={"Year":"year"})
MT_landings_df=MT_landings_df.rename(columns={"Lat":"lat"})
MT_landings_df=MT_landings_df.rename(columns={"Long":"long"})

#sort by year
MT_landings_df= MT_landings_df.sort_values(by='year')

#display df
MT_landings_df.head()

```


### Load:

Below is the python code used to load each dataframe into each table in PostgreSQL. 

```Python
spacemissions_df.to_sql(name='spacelaunch', con=engine, if_exists='append', index=False)

```
```Python
MT_landings_df.to_sql(name='spacelaunchdetail', con=engine, if_exists='append', index=False)
```

Below is the code used to create tables, which include declaring SQL table variables. Also, below is the code for the Query, which was used in helping us load the data we wanted in creating our database. 

```SQL
CREATE TABLE "spacelaunch"(
id INT,
company varchar(255),
year INT NOT NULL,
launchtime TIME NOT NULL,
launchsite varchar(255),
vehicletype varchar(255)
);
	
CREATE TABLE "spacelaunchdetail"(
name varchar(255) NOT NULL, 
id INT, 
mass INT, 
year INT NOT NULL, 
lat DECIMAL,
long DECIMAL
);

--Creating Query to form a database based on information that we are looking for which is: name of meteor, lat, long, meteor size, 
--Vehicle Launch Year, Vehicle Type, Company, Launch Site

Select spacelaunchdetail.name,
spacelaunchdetail.lat, 
spacelaunchdetail.long,
spacelaunchdetail.mass as "Meteor Size (meters)",
spacelaunch.year as "Vehicle Launch Year", 
spacelaunch.vehicletype, 
spacelaunch.company , 
spacelaunch.launchsite 
from spacelaunch
Full outer join spacelaunchdetail
On spacelaunch.year = spacelaunchdetail.year
WHERE spacelaunchdetail.year > 1964;

```

### Conclusion: 

In conclusion, we were able to create a database that captured information on meteorite landings during the years that
space vehicles were launched into space. We discovered that there were meteorite landings during the years that space vehicles 
were launched into space and possibly played some role in trajectory calculations for each vehicle. When we think about probability,
we think about calculations made on passed events to predict future outcomes. Perhaps, this database can be used to make probability calculations in relation to vehicle launch trajectory. In addition, this database can be modified and used with a a new recent development from PostgreSQL, called: PostGIS. PostGIS allows for location queries to be run and opens up new potential for this ETL project.







| name            | lat         | long         | Meteor Size \(meters\) | Vehicle Launch Year | vehicletype | company      | launchsite     |
|-----------------|-------------|--------------|------------------------|---------------------|-------------|--------------|----------------|
| Anton           | 33\.7825    | \-102\.18111 | 41800                  | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |
| River           | \-30\.36667 | 126\.01667   | 191                    | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |
| Kyle            | 29\.975     | \-97\.86667  | 7780                   | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |
| McCook          | 40\.02      | \-100\.78333 | 3602                   | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |
| Burnabbie       | \-32\.05    | 126\.16667   | 2515                   | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |
| Dingo Pup Donga | \-30\.43333 | 126\.1       | 123                    | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |
| Verissimo       | \-19\.73333 | \-48\.31667  | 14000                  | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |
| Bocaiuva        | \-17\.16667 | \-43\.83333  | 64000                  | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |
| New York        | 0           | 0            | 2950                   | 1965                | Titan IIIC  | US Air Force | Cape Canaveral |



<img src="https://media.giphy.com/media/tXLpxypfSXvUc/giphy.gif"> 


**Additional Notes:**
Please note that this ETL was created with original thought.  

 
