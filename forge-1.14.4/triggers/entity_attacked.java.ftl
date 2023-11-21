<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityAttacked(LivingAttackEvent event) {
		if (event!=null && event.getEntity()!=null) {
			<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntity().posX",
				"y": "event.getEntity().posY",
				"z": "event.getEntity().posZ",
				"amount": "event.getAmount()",
				"world": "event.getEntity().world",
				"entity": "event.getEntity()",
				"sourceentity": "event.getSource().getTrueSource()",
				"immediatesourceentity": "event.getSource().getImmediateSource()",
				"event": "event"
				}/>
			</#compress></#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
