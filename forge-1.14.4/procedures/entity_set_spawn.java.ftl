<#include "mcelements.ftl">
if(${input$entity} instanceof PlayerEntity) ((PlayerEntity) ${input$entity}).setSpawnPoint(${toBlockPos(input$x,input$y,input$z)}, true, ${input$entity}.dimension);
