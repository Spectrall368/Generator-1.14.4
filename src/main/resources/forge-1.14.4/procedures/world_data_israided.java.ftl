<#include "mcelements.ftl">
(world.getWorld() instanceof ServerWorld && ((ServerWorld) world.getWorld()).hasRaid(${toBlockPos(input$x,input$y,input$z)}))
