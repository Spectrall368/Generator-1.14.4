<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onPlayerCriticalHit(CriticalHitEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getEntity().posX",
			"y": "event.getEntity().posY",
			"z": "event.getEntity().posZ",
			"world": "event.getEntity().world",
			"entity": "event.getTarget()",
			"sourceentity": "event.getEntity()",
			"damagemodifier": "event.getDamageModifier()",
			"isvanillacritical": "event.isVanillaCritical()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
