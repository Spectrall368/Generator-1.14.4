<#include "mcelements.ftl">
<#include "mcitems.ftl">
(${mappedBlockToBlock(input$a)}.isIn(BlockTags.getCollection().getOrCreate(${toResourceLocation(input$b)})))