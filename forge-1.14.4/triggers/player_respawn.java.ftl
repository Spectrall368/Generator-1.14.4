<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onPlayerRespawned(PlayerEvent.PlayerRespawnEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPlayer().posX",
			"y": "event.getPlayer().posY",
			"z": "event.getPlayer().posZ",
			"world": "event.getPlayer().world",
			"entity": "event.getPlayer()",
			"endconquered": "event.isEndConquered()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
