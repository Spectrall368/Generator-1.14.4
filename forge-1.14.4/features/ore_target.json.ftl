<#include "mcitems.ftl">
Target(${input$target}), State(<#if !mappedBlockToBlockStateCode(input$state)?contains("blockAt")>${mappedBlockToBlockStateCode(input$state)}</#if>)
