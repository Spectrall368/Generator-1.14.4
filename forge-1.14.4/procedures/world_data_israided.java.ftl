<#include "mcelements.ftl">
(world.getWorld() instanceof ServerWorld && ((ServerWorld) world.getWorld()).findRaid(${toBlockPos(input$x,input$y,input$z)}))