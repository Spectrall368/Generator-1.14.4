<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
package ${package}.world.dimension;

<#compress>
@Mod.EventBusSubscriber public class ${name}Dimension {

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public static class Fixers {
		@SubscribeEvent public static void onRegisterDimensionsEvent(RegisterDimensionsEvent event) {
			if (DimensionType.byName(new ResourceLocation("${modid}:${registryname}")) == null) {
				DimensionManager.registerDimension(new ResourceLocation("${modid}:${registryname}"), ${JavaModName}Dimensions.${name.getRegistryNameUpper()}.get(), null, ${data.hasSkyLight});
			}
		}
	
		@SubscribeEvent public static void registerDimensionGen(FMLCommonSetupEvent event) {
			private static Biome [] dimensionBiomes = new Biome[] {
	    		<#list data.biomesInDimension as biome>
					<#if biome.canProperlyMap()>
					ForgeRegistries.BIOMES.getValue(new ResourceLocation("${biome}")),
					</#if>
				</#list>
			};
		}
	}

	<#if hasProcedure(data.onPlayerLeavesDimension) || hasProcedure(data.onPlayerEntersDimension)>
	@SubscribeEvent public void onPlayerChangedDimensionEvent(PlayerEvent.PlayerChangedDimensionEvent event) {
		Entity entity = event.getPlayer();
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;

		<#if hasProcedure(data.onPlayerLeavesDimension)>
		if (event.getFrom() == DimensionType.byName(new ResourceLocation("${modid}:${registryname}"))) {
			<@procedureOBJToCode data.onPlayerLeavesDimension/>
		}
        	</#if>

		<#if hasProcedure(data.onPlayerEntersDimension)>
		if (event.getTo() == DimensionType.byName(new ResourceLocation("${modid}:${registryname}"))) {
			<@procedureOBJToCode data.onPlayerEntersDimension/>
		}
	        </#if>
	}
	</#if>

	<#if data.worldGenType == "Normal world gen">
	        <#include "cp_normal.java.ftl">
    	<#elseif data.worldGenType == "Nether like gen">
	        <#include "cp_nether.java.ftl">
    	<#elseif data.worldGenType == "End like gen">
	        <#include "cp_end.java.ftl">
    	</#if>

	<#include "biomegen.java.ftl">
}
</#compress>
