library(dplyr)
library(rpart)
library(rpart.plot)
library(caret)
library(readxl)


#Load data from excel files 
Engagement_Score <- read_excel("/Users/joshbannister/Desktop/Data Project/PastScoreTotal.xlsx")%>%
  subset(select = -c(Member_Since,Member_Type,Resignation_Date)) %>%
  filter(!is.na(Member_Number)) %>%  #remove people with no member number 
  filter()

Full_Data <- Engagement_Score %>%
  mutate(Resigned = as.factor(Resigned))


input <- Full_Data %>%   
  select(Resigned, 1:18) 


#Model creation 
# Create the training and test datasets
set.seed(42) #(Allows to repeat tests and get same results - sampling thing)

# Step 1: Get row numbers for the training data
trainRowNumbers <- createDataPartition(input$Resigned, p=0.8, list=FALSE)

# Step 2: Create the training  dataset
trainData <- input[trainRowNumbers,]

# Step 3: Create the test dataset
testData <- input[-trainRowNumbers,]

#peak data being used 
trainData %>% head(15)

#create decision tree (ML)
tree_model <- rpart(Resigned~., 
                    data = trainData %>% select(-Member_Number), 
                    control=rpart.control(maxdepth=6))


plot(tree_model)
rpart.plot(tree_model)


odds <- predict(tree_model, testData, type = "prob")
pick <- predict(tree_model, testData, type = "class")


#test fit/ Overall accuracy 
confusionMatrix(as.factor(pick), as.factor(testData$Resigned))

