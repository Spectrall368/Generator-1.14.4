<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onPlayerXPChange(PlayerXpEvent.XpChange event) {
		if (event != null && event.getPlayer() != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPlayer().posX",
				"y": "event.getPlayer().posY",
				"z": "event.getPlayer().posZ",
				"world": "event.getPlayer().world",
				"entity": "event.getPlayer()",
				"amount": "event.getAmount()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
