<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityTravelToDimension(EntityTravelToDimensionEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getEntity().posX",
			"y": "event.getEntity().posY",
			"z": "event.getEntity().posZ",
			"world": "event.getEntity().world",
			"dimension": "event.getDimension().getId()",
			"entity": "event.getEntity()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
