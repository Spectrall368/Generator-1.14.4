<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onBlockPlace(BlockEvent.EntityPlaceEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPos().getX()",
			"y": "event.getPos().getY()",
			"z": "event.getPos().getZ()",
			"px": "event.getEntity().posX",
			"py": "event.getEntity().posY",
			"pz": "event.getEntity().posZ",
			"world": "event.getWorld()",
			"entity": "event.getEntity()",
			"blockstate": "event.getState()",
			"placedagainst": "event.getPlacedAgainst()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
