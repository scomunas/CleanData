## Script that merges train and data DataSets in only one, put the correct
## activity and label all as it needs

library(dplyr) ## Used for create final DataSet

## Read labels for each activity and each column in the data table
NombresColumnas <- read.table("features.txt")
NombresColumnas <- c("Activity","Subject",
                     as.character(NombresColumnas$V2))
nombresActividades <- read.table("activity_labels.txt")

## Read all TRAIN tables and add columns for Activity and Subject
TablaDatosTrain <- read.table("train/X_train.txt", stringsAsFactors = FALSE)
TablaActividadesTrain <- read.table("train/Y_train.txt", stringsAsFactors = FALSE)
TablaSujetosTrain <- read.table("train/subject_train.txt", stringsAsFactors = FALSE)

TablaDatosTrain <- cbind(TablaActividadesTrain,TablaSujetosTrain,TablaDatosTrain)

## Read all TEST tables and add columns for Activity and Subject
TablaDatosTest <- read.table("test/X_test.txt", stringsAsFactors = FALSE)
TablaActividadesTest <- read.table("test/Y_test.txt", stringsAsFactors = FALSE)
TablaSujetosTest<- read.table("test/subject_test.txt", stringsAsFactors = FALSE)

TablaDatosTest <- cbind(TablaActividadesTest,TablaSujetosTest,TablaDatosTest)

## Add the correct column names
names(TablaDatosTest) <- NombresColumnas
names(TablaDatosTrain) <- NombresColumnas

## Merge TRAIN and TEST DataSets into one
TablaDatosMerged <- rbind(TablaDatosTest,TablaDatosTrain)

## Extract column namber for final DataSet
FixedColumns <- c(1,2)
MeanColumns <- grep("mean[(][)]",NombresColumnas)
StdColumns <- grep("std[(][)]",NombresColumnas)
TotalColumns <- c(FixedColumns,MeanColumns,StdColumns)

## Extract final DataSet
TablaDatosFinal <- TablaDatosMerged[,TotalColumns]

## Create grouped final Dataset
TablaDatosAggreated <- aggregate(TablaDatosFinal[,3:68],
                                 list(TablaDatosFinal$Activity,
                                           TablaDatosFinal$Subject),mean)
names(TablaDatosAggreated) <- names(TablaDatosFinal)

## Write results to a file
write.table(TablaDatosAggreated,"Tidy_DataSet.txt",row.name=FALSE)

