<#if generator.map(field$gamerulesboolean, "gamerules") != "null">
if(world.getWorld() instanceof World)
    ((World) world.getWorld()).getGameRules().get(${generator.map(field$gamerulesboolean, "gamerules")}).set(${input$gameruleValue}, ((World) world.getWorld()).getServer());
</#if>
