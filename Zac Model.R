library(dplyr)
library(rpart)
library(rpart.plot)
library(caret)
library(readxl)


#Load data from excel files 
Engagement_Score <- read_excel("S:/Competitions/Round Analysis/2021-2022/Member Engagement Project/Files for past analysis/Engagement Score.xlsx", sheet = "Engagement Score") %>% 
  rename(Member_Number = `Member Number`, 
         Member_Type = `Member Type`) 

Membership_status <- read_excel("S:/Competitions/Round Analysis/2021-2022/Member Engagement Project/Fields for Data Lake-data model.xlsx", sheet = "Membership Demographics") %>% 
  rename(Member_Number = `Member Number`,
         Member_Type = `Member Type`,
         Mamber_Full_Name = `Member Full Name`,
         Member_Since = `Member Since`,
         Date_Of_Birth = `Date of Birth`,
         Member_Activation = `Member Activation`) %>% 
  filter(!is.na(Member_Number)) %>%  #remove people with no member number 
  filter()



#data cleaning and summarising 
full_data <- Engagement_Score %>% 
  inner_join(Membership_status, by = 'Member_Number') %>%
  mutate(Gender.x = as.factor(Gender.x),
         Status = as.factor(Status),
         Member_Type.x = as.factor(Member_Type.x), 
         Age.x = as.integer(Age.x))

input <- full_data %>%   
  select(Status, 1:13) %>% 
  select(-Name)


#Model creation 
# Create the training and test datasets
set.seed(42) #(Allows to repeat tests and get same results - sampling thing)

# Step 1: Get row numbers for the training data
trainRowNumbers <- createDataPartition(input$Status, p=0.8, list=FALSE)

# Step 2: Create the training  dataset
trainData <- input[trainRowNumbers,]

# Step 3: Create the test dataset
testData <- input[-trainRowNumbers,]

#peak data being used 
trainData %>% head(15)

#create decision tree (ML)
tree_model <- rpart(Status~., 
                    data = trainData %>% select(-Member_Number), 
                    control=rpart.control(maxdepth=6))


plot(tree_model)
rpart.plot(tree_model)
text(tree_model)



odds <- predict(tree_model, testData, type = "prob")
pick <- predict(tree_model, testData, type = "class")


#test fit/ Overall accuracy 
confusionMatrix(as.factor(pick), as.factor(testData$Status))

#We have a very good model for seeing whos going to be inactive vs active but it wont say who will resign 
#Why?
#there are no scores for people who resigned, their behaviour has not been modeled in the egagment score data set 
