<#include "mcelements.ftl">
<#include "mcitems.ftl">
(BlockTags.getCollection().getOrCreate(${toResourceLocation(input$b)}).contains(${mappedBlockToBlock(input$a)}))
