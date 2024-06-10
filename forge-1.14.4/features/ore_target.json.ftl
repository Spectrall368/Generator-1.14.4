<#include "mcitems.ftl">
Target(${input$target}), State(<#if !state.contains("blockAt)>${mappedBlockToBlockStateCode(input$state)}</#if>)
