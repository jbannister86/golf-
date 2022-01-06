library(dplyr)
library(rpart)
library(rpart.plot)
library(caret)
library(readxl)


#Load data from excel files 
Engagement_Score <- read_excel("/Users/joshbannister/Desktop/Data Project/RPOS.xlsx", sheet = "RPOS") %>%
  filter(!is.na(Member_Number)) %>%  #remove people with no member number 
  filter()

Full_Data <- Engagement_Score %>%
  mutate(Member_Type = as.factor(Member_Type))


input <- Full_Data %>%   
  select(Member_Type, 1:18) 


#Model creation 
# Create the training and test datasets
set.seed(42) #(Allows to repeat tests and get same results - sampling thing)

# Step 1: Get row numbers for the training data
trainRowNumbers <- createDataPartition(input$Member_Type, p=0.8, list=FALSE)

# Step 2: Create the training  dataset
trainData <- input[trainRowNumbers,]

# Step 3: Create the test dataset
testData <- input[-trainRowNumbers,]

#peak data being used 
trainData %>% head(15)

#create decision tree (ML)
tree_model <- rpart(Member_Type~., 
                    data = trainData %>% select(-Member_Number), 
                    control=rpart.control(maxdepth=6))


plot(tree_model)
rpart.plot(tree_model)


odds <- predict(tree_model, testData, type = "prob")
pick <- predict(tree_model, testData, type = "class")


#test fit/ Overall accuracy 
confusionMatrix(as.factor(pick), as.factor(testData$Member_Type))

