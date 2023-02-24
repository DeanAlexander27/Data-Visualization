# UI

library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(
    title = "Gap Earnings Analysis"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", 
               tabName = "dashboard", 
               icon = icon("dashboard")),
      menuItem("Plot", 
               tabName = "dist", 
               icon = icon("dashboard")),
      menuItem("Data Table", 
               tabName = "table", 
               icon = icon("dashboard")),
      selectInput(inputId = "input1",
                  label = "Choose year:",
                  choices = levels(workers_clean$year))
      
    )
  ),
  
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              h2("Gap Gender Annually Report", align="center"),
              br(),
              fluidRow(
                infoBox(title = "Data",
                        value = nrow(workers_clean),
                        icon = icon("credit-card"),
                        fill = T,
                        color = "red", width = 4),
                infoBox(title = "Mean Earnings",
                        value = round(mean(workers_clean$total_earnings),2),
                        icon = icon("credit-card"),
                        fill = T,
                        color = "red", width = 4),
                infoBox(title = "Mean Total Workers",
                        value = round(mean(workers_clean$total_workers),2),
                        icon = icon("credit-card"),
                        fill = T,
                        color = "red", width = 4)
                
              ),
              
              fluidRow(box(plotlyOutput(outputId = "plot_ranking"), width = 12))
              
              
      ),
      tabItem(tabName = "dist",
              radioButtons(inputId = "corrid",
                           label = "Choose Numerical Variable",
                           choiceNames  = str_to_title(str_replace_all(names(select_if(workers_clean, 
                                                                                       is.numeric)),"_"," ")),
                           choiceValues = names(select_if(workers_clean, is.numeric))
              ), 
              plotlyOutput("corr_plot")),
      tabItem(tabName = "table",
              dataTableOutput("table_data"))
    )
    
  )
)


