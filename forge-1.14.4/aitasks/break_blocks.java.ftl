<#include "mcitems.ftl">
<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new BreakBlockGoal(${mappedBlockToBlock(input$block)},
        this, ${field$speed}, (int) ${field$y_max})<@conditionCode field$condition/>);
