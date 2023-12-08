<#include "mcitems.ftl">
(${mappedBlockToBlockStateCode(input$block)}.getBlock().getStateContainer().getProperty(${input$property}) instanceof EnumProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((EnumProperty<?>) ${mappedBlockToBlockStateCode(input$block)}.getBlock().getStateContainer().getProperty(${input$property})).toString() : "")
