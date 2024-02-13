<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityAttacked(LivingHurtEvent event) {
		if (event != null && event.getEntity() != null) {
			<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntity().posX",
				"y": "event.getEntity().posY",
				"z": "event.getEntity().posZ",
				"world": "event.getEntity().world",
				"amount": "event.getAmount()",
				"entity": "event.getEntity()",
				"sourceentity": "event.getSource().getTrueSource()",
				"event": "event"
				}/>
			</#compress></#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
