<#assign entity = generator.map(field$entity, "entities", 1)!"null">
(<#if entity != "null">new ${generator.map(field$entity, "entities", 0)}(${entity}, world.getWorld())<#else>null</#if>)
