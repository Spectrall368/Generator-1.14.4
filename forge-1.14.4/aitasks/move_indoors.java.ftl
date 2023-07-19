<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${customBlockIndex+1}, new MoveTowardsVillageGoal(this, 0.6)<@conditionCode field$condition/>);
