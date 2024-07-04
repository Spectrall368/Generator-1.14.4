<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onUseHoe(UseHoeEvent event) {
		if (event.getPlayer() != null) {
			<#assign dependenciesCode><#compress>
				<@procedureDependenciesCode dependencies, {
				"x": "event.getContext().getPos().getX()",
				"y": "event.getContext().getPos().getY()",
				"z": "event.getContext().getPos().getZ()",
				"world": "event.getContext().getWorld()",
				"entity": "event.getContext()",
				"blockstate": "event.getContext().getWorld().getBlockState(event.getContext().getPos())",
				"event": "event"
				}/>
			</#compress></#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
