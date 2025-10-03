$origin = origin.add(origin.getX(), random.nextInt(${input$max} - (<#if input$min == input$max> ${input$max} - 1<#else>${input$max} - ${input$min}</#if>)) + ${input$min}, origin.getZ());$
