<#include "mcitems.ftl">
/*@BlockState*/(${mappedBlockToBlock(input$block)}.getBlock().getStateContainer().getProperty(${input$property}) instanceof BooleanProperty ?
	${mappedBlockToBlockStateCode(input$block)}.with((BooleanProperty) ${mappedBlockToBlock(input$block)}.getBlock().getStateContainer().getProperty(${input$property}), ${input$value}) : ${mappedBlockToBlockStateCode(input$block)})
