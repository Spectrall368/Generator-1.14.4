<#include "mcelements.ftl">
(BiomeDictionary.hasType(world.getBiome(${toBlockPos(input$x,input$y,input$z)}),
        BiomeDictionary.Type.${generator.map(field$biomedict, "biomedictionarytypes")}))
