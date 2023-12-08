<#include "mcitems.ftl">
(${mappedBlockToBlock(input$block)}.getBlock().getStateContainer().getProperty(${input$property}) instanceof BooleanProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((BooleanProperty) ${mappedBlockToBlock(input$block)}.getBlock().getStateContainer().getProperty(${input$property})) : false)
