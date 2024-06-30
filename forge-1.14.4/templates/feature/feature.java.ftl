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
<#assign placement = "IPlacementConfig.NO_PLACEMENT_CONFIG">
<#assign placementconfig = "Placement.NOPE">
<#if configuration == "OreFeatureConfig">
	<#if placementcode.contains("CountRangeConfig")>
		<#assign placementconfig = "Placement.COUNT_RANGE">
		<#assign placement = "new CountR" + placementcode?replace("?", configurationcode?keep_after_last(") "))?keep_after("new CountR")?keep_before(");")>
		<#assign configurationcode = configurationcode?keep_before_last(" ")>
	<#elseif placementcode.contains("DepthAverageConfig")>
		<#assign placementconfig = "Placement.COUNT_DEPTH_AVERAGE">
		<#assign placement = "new DepthA" + placementcode?replace("?", configurationcode?keep_after_last(") "))?keep_after("new DepthA")?keep_before(");")>
		<#assign configurationcode = configurationcode?keep_before_last(" ")>
	</#if>
</#if>
<#assign cond = false>
<#if data.restrictionBiomes?has_content>
	<#list data.restrictionBiomes as restrictionBiome>
		<#if restrictionBiome?contains("#")>
			<#assign cond = true>
			 <#break>
		</#if>
		<#break>
	</#list>
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
				BlockPos placePos = pos;
				<#if data.restrictionBiomes?has_content && cond>
					DimensionType dimensionType = world.getDimension().getType();
					boolean dimensionCriteria = false;
					<#list data.restrictionBiomes as restrictionBiome>
						<#if restrictionBiome?contains("#")>
							<#if restrictionBiome == "#is_overworld">
								if(dimensionType == DimensionType.OVERWORLD)
									dimensionCriteria = true;
							<#elseif restrictionBiome == "#is_nether">
								if(dimensionType == DimensionType.THE_NETHER)
									dimensionCriteria = true;
							<#elseif restrictionBiome == "#is_end">
								if(dimensionType == DimensionType.THE_END)
									dimensionCriteria = true;
							<#else>
								if(dimensionType == DimensionType.byName(new ResourceLocation(${JavaModName}.MODID, "${restrictionBiome?keep_after("#is_")}")))
									dimensionCriteria = true;
							</#if>
						</#if>
					</#list>

					if(!dimensionCriteria)
						return false;
				</#if>

				<#if hasProcedure(data.generateCondition)>
				int x = pos.getX();
				int y = pos.getY();
				int z = pos.getZ();
				if (!<@procedureOBJToConditionCode data.generateCondition/>)
					return false;
				</#if>

				<#if featuretype == "placement_rarity">
				if(random.nextFloat() < 1.0F / (float) ${placementcode?keep_after("Rarity(")?keep_before(")")}) {
				</#if>
				<#if featuretype == "placement_count">
				int count = ${placementcode?keep_after("Count(")?keep_before(")")};
				for(int a = 0; a < count; a++) {
				</#if>

				${removeStrings(placementcode)}

				return super.place(world, generator, random, pos, config);

				<#if featuretype == "placement_count">}</#if>
				<#if featuretype == "placement_rarity">}</#if>
			}};

			event.getRegistry().register(feature.setRegistryName("${registryname}"));
		}

		@SubscribeEvent public static void addFeatureToBiomes(FMLCommonSetupEvent event) {
			for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
				<#if data.restrictionBiomes?has_content && !cond>
					boolean biomeCriteria = false;
					<#list data.restrictionBiomes as restrictionBiome>
						<#if restrictionBiome.canProperlyMap() && !restrictionBiome?contains("#")>
						if (ForgeRegistries.BIOMES.getKey(biome).equals(new ResourceLocation("${restrictionBiome}")))
							biomeCriteria = true;
						</#if>
					</#list>
					if (!biomeCriteria)
						continue;
				</#if>
	
			biome.addFeature(GenerationStage.Decoration.${generator.map(data.generationStep, "generationsteps")},
				Biome.createDecoratedFeature(feature, ${configurationcode}, ${placementconfig}, ${placement}));
			}
		}
	}
}</#compress>
<#-- @formatter:on -->
<#function removeStrings str>
<#assign result = str>
<#list 1..4 as i>
<#assign result_str = "/" + result?keep_after("/")?keep_before("/") + "/">
<#assign result = result?replace(result_str, "")>
</#list>
<#return result>
</#function>
