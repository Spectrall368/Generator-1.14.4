((5 + ${input$max}) - (5 + ${input$min}) - ${field$inner} + 1) <= 0 ? (getMinGenY() + ${input$min}) : (random.nextInt(random.nextInt((5 + ${input$max}) - (5 + ${input$min}) - ${field$inner} + 1) + ${field$inner}) + (getMinGenY() + ${input$min}))
