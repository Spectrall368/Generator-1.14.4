<#include "mcitems.ftl">
<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new TemptGoal(this, ${field$speed}, Ingredient.fromItems(${mappedMCItemToItem(input$item)}), ${field$scared?lower_case})<@conditionCode field$condition/>);
