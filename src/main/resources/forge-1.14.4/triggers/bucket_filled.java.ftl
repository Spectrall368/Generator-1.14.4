<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onBucketFill(FillBucketEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPlayer().posX",
			"y": "event.getPlayer().posY",
			"z": "event.getPlayer().posZ",
			"world": "event.getWorld()",
			"itemstack": "event.getFilledBucket()",
			"entity": "event.getPlayer()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
