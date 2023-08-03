<#include "mcelements.ftl">
(world.getBiome(${toBlockPos(input$x,input$y,input$z)}).is(TagKey.getCollection().getOrCreate(Registry.BIOME_KEY, ${toResourceLocation(input$tag)})))
