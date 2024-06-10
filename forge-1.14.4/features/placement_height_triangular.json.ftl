<#assign minValue = input$min>
<#assign maxValue = input$max>
<#assign difference = maxValue?number - minValue?number>
new DepthAverageConfig(?, ${difference}, ${difference}),
