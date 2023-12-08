<#include "mcitems.ftl">
(${mappedBlockToBlock(input$block)}.getBlock().getStateContainer().getProperty(${input$property}) instanceof EnumProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((EnumProperty<?>) ${mappedBlockToBlock(input$block)}.getBlock().getStateContainer().getProperty(${input$property})).toString() : "")
