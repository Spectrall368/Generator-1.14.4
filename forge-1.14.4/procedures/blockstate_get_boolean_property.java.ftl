<#include "mcitems.ftl">
return ${mappedBlockToBlockStateCode(input$block)}.getBlock().getStateContainer().getProperty(${input$property}) instanceof BooleanProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((BooleanProperty) ${mappedBlockToBlockStateCode(input$block)}.getBlock().getStateContainer().getProperty(${input$property})) : false
