# SERVER

function(input,output){
  
  output$plot_ranking <- renderPlotly({
    data_agg1 <- workers_clean %>% 
      filter(year==input$input1) %>% 
      mutate(gap_earnings=total_earnings_male-total_earnings_female) %>% 
      group_by(major_category) %>% 
      summarise(mean_gap = round(mean(gap_earnings),2)) %>% 
      arrange(-mean_gap)
    
    data_agg1 <- data_agg1 %>% 
      mutate(label=glue("Mean gap: ${mean_gap}"))
    # data vis data 1
    
    plot_ranking <- data_agg1 %>% 
      ggplot(mapping = aes(x=mean_gap,
                           y=reorder(major_category, mean_gap),
                           text=label))+
      geom_col(fill="#182587")+
      geom_col(data=data_agg1 %>% filter(major_category=="Computer, Engineering, and Science"), fill="#590c0d")+
      labs(title = glue("Gap Earnings on Female and Male {input$input1}"),
           x=NULL,
           y="Major Category")+
      scale_y_discrete(labels=wrap_format(30))+ # untuk menyingkat penulisan label
      scale_x_continuous(labels = dollar_format(prefix = "$"))+ # memberikan simbol $ di depan angka
      theme_algoritma
    ggplotly(plot_ranking, tooltip = "text")
    
    
  })
  
  output$corr_plot <- renderPlotly({
    
    plot_dist <- workers_clean %>% 
      ggplot(aes(x = total_earnings_male, 
                 y = workers_clean[,input$corrid])) + 
      geom_jitter(aes(col = major_category ,
                      text = glue("{str_to_upper(major_category)}
                         Earnings Male: {total_earnings_male}
                         {str_to_title(str_replace_all(input$corrid, 
                          pattern = '_', 
                          replacement =' '))}: {workers_clean[,input$corrid]}")
      )) +
      
      
      geom_smooth() +
      labs(y = glue("{str_to_title(str_replace_all(input$corrid, 
                          pattern = '_', 
                          replacement =' '))}"),
           x = "Total Earnings Male",
           title = "Distribution of Plot Earnings") +
      scale_color_brewer(palette = "Set3") +
      theme_algoritma +
      theme(legend.position = "none")
    
    ggplotly(plot_dist, tooltip = "text")
  })
  
  output$table_data <- renderDataTable({datatable(workers_clean, options = list(scrollX=T))})
  
  
  
}
