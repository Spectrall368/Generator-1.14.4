<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new LookAtGoal(this, ${generator.map(field$entity, "entities")}.class,(float)${field$radius})<@conditionCode field$condition/>);
