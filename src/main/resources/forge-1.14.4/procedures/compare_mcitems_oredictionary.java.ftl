<#include "mcelements.ftl">
<#include "mcitems.ftl">
(${mappedMCItemToItem(input$a)}.isIn(ItemTags.getCollection().getOrCreate(${toResourceLocation(input$b)})))