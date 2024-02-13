<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityFall(LivingFallEvent event) {
		if (event != null && event.getEntity() != null) {
			<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntity().posX",
				"y": "event.getEntity().posY",
				"z": "event.getEntity().posZ",
				"damagemultiplier": "event.getDamageMultiplier()",
				"distance": "event.getDistance()",
				"world": "event.getEntity().world",
				"entity": "event.getEntity()",
				"event": "event"
				}/>
			</#compress></#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
