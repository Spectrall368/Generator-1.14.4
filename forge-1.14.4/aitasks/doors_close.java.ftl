<#if !data.flyingMob && !data.waterMob>
<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new OpenDoorGoal(this, false)<@conditionCode field$condition/>);
this.getNavigator().getNodeProcessor().setCanOpenDoors(true);
</#if>
