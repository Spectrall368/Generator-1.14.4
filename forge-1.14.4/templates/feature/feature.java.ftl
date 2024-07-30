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
<#include "../procedures.java.ftl">
package ${package}.world.features;

<#assign configuration = generator.map(featuretype, "features", 1)>
<#assign cond = false>
<#if data.restrictionBiomes?has_content>
	<#list data.restrictionBiomes as restrictionBiome>
		<#if restrictionBiome?contains(":is_")>
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

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) private static class ${name}FeatureRegisterHandler {
		@SubscribeEvent public static void registerFeature(RegistryEvent.Register<Feature<?>> event) {
			feature = new ${name}Feature() {
			@Override public boolean place(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, ${configuration} config) {
				BlockPos placePos = pos;
				<#if data.restrictionBiomes?has_content && cond>
					DimensionType dimensionType = world.getDimension().getType();
					boolean dimensionCriteria = false;
					<#list data.restrictionBiomes as restrictionBiome>
							<#if restrictionBiome == "#minecraft:is_overworld">
								if(dimensionType == DimensionType.OVERWORLD)
									dimensionCriteria = true;
							<#elseif restrictionBiome == "#minecraft:is_nether">
								if(dimensionType == DimensionType.THE_NETHER)
									dimensionCriteria = true;
							<#elseif restrictionBiome == "#minecraft:is_end">
								if(dimensionType == DimensionType.THE_END)
									dimensionCriteria = true;
							<#else>
								if(dimensionType == DimensionType.byName(new ResourceLocation("${modid}:${restrictionBiome?keep_after("is_")}")))
									dimensionCriteria = true;
							</#if>
					</#list>

					if(!dimensionCriteria)
						return false;
				</#if>

				<#if data.hasPlacedFeature()>
					<#if placementcode.contains("Rarity")>
					if(random.nextFloat() < 1.0F / (float) ${placementcode?keep_after("Rarity(")?keep_before(")")}) {
					</#if>
					<#if placementcode.contains("Count")>
					int count = ${placementcode?keep_after("Count(")?keep_before(")")};
					for(int a = 0; a < count; a++) {
					</#if>

					<#if placementcode != "">
					${removeStrings(placementcode)}
					</#if>
	
					<#if hasProcedure(data.generateCondition)>
					int x = placePos.getX();
					int y = placePos.getY();
					int z = placePos.getZ();
					if (!<@procedureOBJToConditionCode data.generateCondition/>)
						return false;
					</#if>
	
					return super.place(world, generator, random, placePos, config);
	
					<#if placementcode.contains("Count")>}</#if>
					<#if placementcode.contains("Rarity")>}</#if>
					<#if placementcode.contains("Rarity") || placementcode.contains("Count")>return false;</#if>
				<#else>
					return super.place(world, generator, random, placePos, config);
				</#if>
			}};

			event.getRegistry().register(feature.setRegistryName("${registryname}"));
		}

		<#if data.hasPlacedFeature()>
		@SubscribeEvent public static void addFeatureToBiomes(FMLCommonSetupEvent event) {
			for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
				<#if data.restrictionBiomes?has_content && !cond>
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
				Biome.createDecoratedFeature(feature, ${configurationcode}, Placement.NOPE, IPlacementConfig.NO_PLACEMENT_CONFIG));
			}
		}
		</#if>
	}
}</#compress>
<#-- @formatter:on -->
<#function removeStrings str>
<#assign result = str>
<#list 1..countOccurrencesOfSlash(result) as i>
<#assign result_str = "/" + result?keep_after("/")?keep_before("/") + "/">
<#assign result = result?replace(result_str, "")>
</#list>
<#return result>
</#function>
<#function countOccurrencesOfSlash input>
  <#local count = 0>
  <#list 0..(input?length - 1) as i>
    <#if input[i] == "/">
      <#assign count = count + 1>
    </#if>
  </#list>
  <#return count>
</#function>
