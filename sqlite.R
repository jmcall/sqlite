library(RSQLite)
library(DBI)
library(dplyr)

#Create new Database

mydb <- dbConnect(RSQLite::SQLite(), "mydb.sqlite")

#Prepare Data for Database Table

df = mtcars

df = tibble::rownames_to_column(df, "make")

#Create New Database Table

dbExecute(mydb, "CREATE TABLE mtcars (
          make TEXT PRIMARY KEY, 
          mpg REAL,
          cyl REAL,
          disp REAL,
          hp REAL,
          drat REAL,
          wt REAL,
          qsec REAL,
          vs REAL,
          am REAL,
          gear REAL,
          carb REAL)")

#Wrtie Data to database table

dbWriteTable(mydb, "mtcars", df, append = TRUE,temporary = FALSE, row.names = FALSE)

#List database tables

dbListTables(mydb)

#Execute queries like delete

dbExecute(mydb, 'DELETE FROM mtcars')

#Read Database Table

df2 = dbGetQuery(mydb, 'SELECT * FROM mtcars LIMIT 100')

#Update Database Table

mtcars2 <- subset(mtcars, hp >= 150)

mtcars2 = tibble::rownames_to_column(mtcars2, "make")

mtcars2$mpg = 99

num_rows = seq(1,nrow(mtcars2))

for (n in num_rows){
  
  rs = dbSendStatement(mydb, paste("UPDATE mtcars SET mpg =",mtcars2[n,2],"WHERE make = :x"))
  
  dbBind(rs, params = list(x = mtcars2[n,1]))
  
  dbGetRowsAffected(rs)
  
  dbClearResult(rs)
  
}

#Disconnect From Database

dbDisconnect(mydb)

