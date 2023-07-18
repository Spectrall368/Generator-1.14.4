<#include "mcelements.ftl">
<#include "mcitems.ftl">
(ItemTags.getCollection().getOrCreate(${toResourceLocation(input$b)}).contains(${mappedMCItemToItem(input$a)}))
