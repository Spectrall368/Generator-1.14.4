<#include "mcitems.ftl">
Target(${input$target}), State(<#if !(input$state?contains("blockAt"))>${mappedBlockToBlockStateCode(input$state)}</#if>)
