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

@Mod.EventBusSubscriber public class ${name}Feature {

	private static Feature<OreFeatureConfig> feature = null;

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) private static class FeatureRegisterHandler {

		@SubscribeEvent public static void registerFeature(RegistryEvent.Register<Feature<?>> event) {
			feature = new OreFeatureConfig<OreFeatureConfig>(OreFeatureConfig::deserialize) {
				@Override public boolean place(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, OreFeatureConfig config) {
					DimensionType dimensionType = world.getDimension().getType();
					boolean dimensionCriteria = false;

    				<#list data.spawnWorldTypes as worldType>
						<#if worldType=="Surface">
							if(dimensionType == DimensionType.OVERWORLD)
								dimensionCriteria = true;
						<#elseif worldType=="Nether">
							if(dimensionType == DimensionType.THE_NETHER)
								dimensionCriteria = true;
						<#elseif worldType=="End">
							if(dimensionType == DimensionType.THE_END)
								dimensionCriteria = true;
						<#else>
							if(dimensionType == ${(worldType.toString().replace("CUSTOM:", ""))}Dimension.type)
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

					return super.place(world, generator, rand, pos, config);
						}
			};

			event.getRegistry().register(feature.setRegistryName("${registryname}"));
		}

		@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
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
	
				biome.addFeature(GenerationStage.Decoration.UNDERGROUND_ORES,
					Biome.createDecoratedFeature(feature, new OreFeatureConfig(OreFeatureConfig.FillerBlockType.create("${registryname}", "${registryname}", blockAt -> {
					boolean blockCriteria = false;
					<#list data.blocksToReplace as replacementBlock>
						if(blockAt.getBlock() == ${mappedBlockToBlock(replacementBlock)})
							blockCriteria = true;
					</#list>
					return blockCriteria;
				}), block.getDefaultState(), ${data.frequencyOnChunk}), Placement.COUNT_RANGE, new CountRangeConfig(${data.frequencyPerChunks}, <#if data.minGenerateHeight gt 256>256<#elseif data.minGenerateHeight lt 0>0<#else>${data.minGenerateHeight}</#if>, <#if data.minGenerateHeight gt 256>256<#elseif data.minGenerateHeight lt 0>0<#else>${data.minGenerateHeight}</#if>, <#if data.maxGenerateHeight gt 256>256<#elseif data.maxGenerateHeight lt 0>0<#else>${data.maxGenerateHeight}</#if>)));
			}
		}
  }
}
<#-- @formatter:on -->
