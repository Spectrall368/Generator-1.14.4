<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
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
<#include "../procedures.java.ftl">
package ${package}.world.features;

<#assign configuration = generator.map(featuretype, "features", 1)>
<#assign placementconfig = "Placement.NOPE">
<#assign isworking = false>
<#if placementcode.contains("LAVA") && configuration == "LakesConfig">
	<#if placementcode.contains("ChanceConfig")>
		<#assign placementconfig = "Placement.LAVA_LAKE">
		<#assign placementcode = placementcode?keep_after("new Ch")?keep_before("),")?replace("anceConfig", "new LakeChanceConfig")>
		<#assign isworking = true>
	</#if>
<#elseif configuration == "LakesConfig">
	<#if placementcode.contains("ChanceConfig")>
		<#assign placementconfig = "Placement.WATER_LAKE">
		<#assign placementcode = placementcode?keep_after("new Ch")?keep_before("),")?replace("anceConfig", "new LakeChanceConfig")>
		<#assign isworking = true>
	</#if>
<#elseif generator.map(featuretype, "features") == "BlockPileFeature" || configuration == "BlockBlobConfig">
	<#if placementcode.contains("ChanceConfig")>
		<#assign placementconfig = "Placement.FOREST_ROCK">
		<#assign placementcode = placementcode?keep_after("new Ch")?keep_before("),")?replace("anceConfig", "new FrequencyConfig")>
		<#assign isworking = true>
	</#if>
<#elseif generator.map(featuretype, "features") == "CoralClawFeature" || generator.map(featuretype, "features") == "CoralMushroomFeature" || generator.map(featuretype, "features") == "CoralTreeFeature">
	<#assign placementconfig = "Placement.COUNT_HEIGHTMAP_32">
<#elseif configuration == "BigMushroomFeatureConfig">
	<#if placementcode.contains("ChanceConfig")>
		<#assign placementconfig = "Placement.COUNT_HEIGHTMAP">
		<#assign placementcode = placementcode?keep_after("new Ch")?keep_before("),")?replace("anceConfig", "new FrequencyConfig")>
		<#assign isworking = true>
	</#if>
<#elseif configuration == "SphereReplaceConfig">
	<#if placementcode.contains("ChanceConfig")>
		<#assign placementconfig = "Placement.COUNT_TOP_SOLID">
		<#assign placementcode = placementcode?keep_after("new Ch")?keep_before("),")?replace("anceConfig", "new FrequencyConfig")>
		<#assign isworking = true>
	</#if>
<#elseif placementcode.contains("TOP_SOLID_HEIGHTMAP") || configuration == "SeaGrassConfig">
	<#if configuration != "SeaGrassConfig">
		<#assign placementconfig = "Placement.TOP_SOLID_HEIGHTMAP">
		<#assign placementcode = placementcode?replace("Placement.TOP_SOLID_HEIGHTMAP,", "")>
	</#if>
<#elseif configuration == "ProbabilityConfig">
	<#if placementcode.contains("ChanceConfig")>
		<#assign placementconfig = "Placement.COUNT_HEIGHTMAP_DOUBLE">
		<#assign placementcode = placementcode?keep_after("new Ch")?keep_before("),")?replace("anceConfig", "new FrequencyConfig")>
		<#assign isworking = true>
	</#if>
<#elseif configuration == "OreFeatureConfig">
	<#if placementcode.contains("CountRangeConfig")>
		<#assign placementconfig = "Placement.COUNT_RANGE">
		<#assign isworking = true>
		<#assign placementcode = "new CountR" + placementcode?replace("?", configurationcode?keep_after_last(") "))?keep_after("new CountR")?keep_before("),")>
		<#assign configurationcode = configurationcode?keep_before_last(" ")>
	<#elseif placementcode.contains("DepthAverageConfig")>
		<#assign placementconfig = "Placement.COUNT_DEPTH_AVERAGE">
		<#assign placementcode = "new DepthA" + placementcode?replace("?", configurationcode?keep_after_last(") "))?keep_after("new DepthA")?keep_before("),")>
		<#assign configurationcode = configurationcode?keep_before_last(" ")>
		<#assign isworking = true>
	</#if>
<#elseif configuration == "ReplaceBlockConfig">
	<#assign placementconfig = "Placement.EMERALD_ORE">
</#if>
<#compress>
@Mod.EventBusSubscriber public class ${name}Feature extends ${generator.map(featuretype, "features")} {
	private static Feature<${configuration}> feature = null;

	public ${name}Feature() {
		super(${configuration}::deserialize);
	}

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) private static class FeatureRegisterHandler {
		@SubscribeEvent public static void registerFeature(RegistryEvent.Register<Feature<?>> event) {
			feature = new ${name}Feature() {
			@Override public boolean place(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, ${configuration} config) {
				DimensionType dimensionType = world.getDimension().getType();
				boolean dimensionCriteria = false;

    				<#list data.restrictionDimensions as worldType>
					<#if worldType == "Surface">
					if(dimensionType == DimensionType.OVERWORLD)
						dimensionCriteria = true;
					<#elseif worldType == "Nether">
					if(dimensionType == DimensionType.THE_NETHER)
						dimensionCriteria = true;
					<#elseif worldType == "End">
					if(dimensionType == DimensionType.THE_END)
						dimensionCriteria = true;
					<#else>
					if(dimensionType == DimensionType.byName(new ResourceLocation("${generator.getResourceLocationForModElement(worldType.toString().replace("CUSTOM:", ""))}")))
						dimensionCriteria = true;
					</#if>
				</#list>

				if(!dimensionCriteria)
					return false;

				<#if hasProcedure(data.generateCondition)>
				int x = pos.getX();
				int y = pos.getY();
				int z = pos.getZ();
				if (!<@procedureOBJToConditionCode data.generateCondition/>)
					return false;
				</#if>

				return super.place(world, generator, random, pos, config);
			}
			};

			event.getRegistry().register(feature.setRegistryName("${registryname}"));
		}

		@SubscribeEvent public static void addFeatureToBiomes(FMLCommonSetupEvent event) {
			for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
			<#if data.restrictionBiomes?has_content>
				boolean biomeCriteria = false;
				<#list data.restrictionBiomes as restrictionBiome>
					<#if restrictionBiome.canProperlyMap()>
					if (ForgeRegistries.BIOMES.getKey(biome).equals(new ResourceLocation("${restrictionBiome}")))
						biomeCriteria = true;
					</#if>
				</#list>
				if (!biomeCriteria)
					continue;
			</#if>
	
			biome.addFeature(GenerationStage.Decoration.${generator.map(data.generationStep, "generationsteps")},
				Biome.createDecoratedFeature(feature, ${configurationcode}, ${placementconfig}, <#if isworking>${placementcode})<#else>IPlacementConfig.NO_PLACEMENT_CONFIG</#if>));
			}
		}
	}
}</#compress>
<#-- @formatter:on -->
