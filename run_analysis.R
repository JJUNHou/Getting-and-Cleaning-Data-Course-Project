library(dplyr)
dir <- getwd()

##phase1#############
train_dir <-paste0(dir,'/UCI HAR Dataset/train')
X_train.dir <- paste0(train_dir,'/X_train.txt')
X_train <- read.table(X_train.dir,header=F,encoding = 'UTF-8')

test_dir <- paste0(dir,'/UCI HAR Dataset/test')
X_test.dir <- paste0(test_dir,'/X_test.txt')
X_test <- read.table(X_test.dir,header=F,encoding = 'UTF-8')

merge.df <- rbind(X_test,X_train)
##phase2############

features.dir <- paste0(dir,'/UCI HAR Dataset/features.txt')
features <- read.table(features.dir,header=F,encoding = 'UTF-8')
features <- features[,2]
features <- as.character(features)

colnames(merge.df) <- features

df.mean<- grep('mean()',features,fixed = T)
df.std <- grep('std()',features,fixed = T)

df.extract <- merge.df[,c(df.mean,df.std)]

##phase3############
activity.dir <- paste0(dir,'/UCI HAR Dataset/activity_labels.txt')
activity.df <- read.table(activity.dir,header=F,encoding = 'UTF-8')

Y_train.dir <- paste0(train_dir,'/Y_train.txt')
Y_train <- read.table(Y_train.dir,header=F,encoding = 'UTF-8')

Y_test.dir <- paste0(test_dir,'/Y_test.txt')
Y_test <- read.table(Y_test.dir,header=F,encoding = 'UTF-8')

Y_labels <- rbind(Y_test,Y_train)
Y_labels <- as.vector(Y_labels$V1)

activities<- factor(x=Y_labels,labels=activity.df$V2)


##phase4############
subject_test.dir <- paste0(dir,'/UCI HAR Dataset/test/subject_test.txt')
subject_train.dir <- paste0(dir,'/UCI HAR Dataset/train/subject_train.txt')

subject_test <- read.table(subject_test.dir,encoding = 'UTF-8',header=F)
subject_train <- read.table(subject_train.dir,encoding = 'UTF-8',header=F)

subject <- as.vector(rbind(subject_test,subject_train)$V1)

df.label_var <- cbind(activities,subject,df.extract)

##phase5###########
df.tiny <- df.label_var %>% group_by(activities,subject) %>% summarize_all(mean)
write.table(df.tiny,'./RESULTS/q5_df.tiny.txt',row.names = F)
