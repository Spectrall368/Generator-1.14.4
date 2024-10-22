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
<#include "../mcitems.ftl">
package ${package}.world.features.ores;
<#if data.maxGenerateHeight gt 256>
	<#assign maxGenerateHeight = 256>
<#elseif data.maxGenerateHeight lt 0>
	<#assign maxGenerateHeight = 0>
<#else>
	<#assign maxGenerateHeight = data.maxGenerateHeight>
</#if>
<#if data.minGenerateHeight gt 256>
	<#assign minGenerateHeight = 256>
<#elseif data.minGenerateHeight lt 0>
	<#assign minGenerateHeight = 0>
<#else>
	<#assign minGenerateHeight = data.minGenerateHeight>
</#if>
<#if data.generationShape != "UNIFORM">
	<#assign averageHeight = (maxGenerateHeight + minGenerateHeight) / 2>
	<#assign averageHeight = averageHeight?int>
</#if>
<#assign cond = false>
<#if data.restrictionBiomes?has_content>
	<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
		<#if restrictionBiome?contains(":is_")>
			<#assign cond = true>
			 <#break>
		</#if>
		<#break>
	</#list>
</#if>

@Mod.EventBusSubscriber public class ${name}Feature {

	private static Feature<OreFeatureConfig> feature = null;

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) private static class ${name}FeatureRegisterHandler {
		@SubscribeEvent public static void registerFeature(RegistryEvent.Register<Feature<?>> event) {
			feature = new OreFeature(OreFeatureConfig::deserialize) {
				@Override public boolean place(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, OreFeatureConfig config) {
				<#if data.restrictionBiomes?has_content && cond>
					DimensionType dimensionType = world.getDimension().getType();
					boolean dimensionCriteria = false;
					<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
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

					return super.place(world, generator, random, pos, config);
				}
			};

			event.getRegistry().register(feature.setRegistryName("${registryname}"));
		}

		@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
			for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
				<#if data.restrictionBiomes?has_content && !cond>
					boolean biomeCriteria = false;
					<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
						if (ForgeRegistries.BIOMES.getKey(biome).equals(new ResourceLocation("${restrictionBiome}")))
							biomeCriteria = true;
					</#list>
					if (!biomeCriteria)
						continue;
				</#if>
	
				biome.addFeature(GenerationStage.Decoration.UNDERGROUND_ORES,
					Biome.createDecoratedFeature(feature, new OreFeatureConfig(OreFeatureConfig.FillerBlockType.create("${registryname}", "${registryname}", blockAt -> {
					boolean blockCriteria = false;
					<#list data.blocksToReplace as replacementBlock>
							<#if replacementBlock.getUnmappedValue().startsWith("TAG:")>
								if (BlockTags.getCollection().getOrCreate(new ResourceLocation("${replacementBlock.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":").replace("stone_ore_replaceables", "minecraft:overworld_carver_replaceables")}")).contains(blockAt.getBlock()))
							<#elseif replacementBlock.getMappedValue(1).startsWith("#")>
								if (BlockTags.getCollection().getOrCreate(new ResourceLocation("${replacementBlock.getMappedValue(1).replace("#", "")}")).contains(blockAt.getBlock()))
							<#else>
								if(blockAt == ${mappedBlockToBlockStateCode(replacementBlock)})
							</#if>
									blockCriteria = true;
					</#list>
					return blockCriteria;
				}), ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState(), ${data.frequencyOnChunk}), <#if data.generationShape == "UNIFORM">Placement.COUNT_RANGE<#else>Placement.COUNT_DEPTH_AVERAGE</#if>, new <#if data.generationShape == "UNIFORM">CountRangeConfig(${data.frequencyPerChunks}, ${minGenerateHeight}, 0, ${maxGenerateHeight}<#else>DepthAverageConfig(${data.frequencyPerChunks}, ${averageHeight}, ${averageHeight}</#if>)));
			}
		}
	}
}
<#-- @formatter:on -->
