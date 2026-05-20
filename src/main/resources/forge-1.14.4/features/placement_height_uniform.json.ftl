$origin = origin.add(0, ${JavaModName}Features.RAND.nextInt(${input$max} - (<#if input$min == input$max> ${input$max} - 1<#else>${input$max} - ${input$min}</#if>)) + ${input$min}, 0);$
