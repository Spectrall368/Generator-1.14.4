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
package ${package}.world.features.plants;
<#assign configuration = "NoFeatureConfig">
<#assign featurename = "Feature<NoFeatureConfig>">
<#if data.plantType == "normal">
	<#if data.generationType != "Flower">
		<#assign configuration = "GrassFeatureConfig">
		<#assign featurename = "GrassFeature">
	<#else>
		<#assign featurename = "FlowersFeature">
	</#if>
<#elseif data.plantType == "double">
	<#if data.generationType == "Flower">
		<#assign configuration = "DoublePlantConfig">
		<#assign featurename = "DoublePlantFeature">
	</#if>
</#if>
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

@Mod.EventBusSubscriber public class ${name}Feature {

	private static Feature<${configuration}> feature = null;

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) private static class FeatureRegisterHandler {

		@SubscribeEvent public static void registerFeature(RegistryEvent.Register<Feature<?>> event) {
			feature = new ${featurename}(${configuration}::deserialize) {
			<#if data.plantType == "normal">
				<#if data.generationType == "Flower">
				@Override public BlockState getRandomFlower(Random random, BlockPos pos) {
      					return ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState();
   				}
				</#if>
			</#if>
				@Override public boolean place(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, ${configuration} config) {
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

					<#if data.plantType == "growapable">
					int generated = 0;
      					for(int j = 0; j < ${data.frequencyOnChunks}; ++j) {
						BlockPos blockpos = pos.add(random.nextInt(4) - random.nextInt(4), 0, random.nextInt(4) - random.nextInt(4));
						if (world.isAirBlock(blockpos)) {
							BlockPos blockpos1 = blockpos.down();
							int k = 1 + random.nextInt(random.nextInt(${data.growapableMaxHeight}) + 1);
							k = Math.min(${data.growapableMaxHeight}, k);
							for(int l = 0; l < k; ++l) {
								if (${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState().isValidPosition(world, blockpos)) {
									world.setBlockState(blockpos.up(l), ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState(), 2);
									generated++;
								}
							}
						}
      					}
      					return generated > 0;
					<#elseif data.plantType == "double">
                        			<#if data.generationType == "Flower">
                	    			return super.place(world, generator, random, pos, config);
                	    			<#else>
                	    			for (BlockState blockstate = world.getBlockState(pos); (blockstate.isAir() || blockstate.isIn(BlockTags.LEAVES)) && pos.getY() > 0; blockstate = world.getBlockState(pos))
                        				pos = pos.down();
                        			int i = 0;
                        			for (int j = 0; j < 128; ++j) {
                        				BlockPos blockpos = pos.add(random.nextInt(8) - random.nextInt(8), random.nextInt(4) - random.nextInt(4), random.nextInt(8) - random.nextInt(8));
                        				if (world.isAirBlock(blockpos) && ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState().isValidPosition(world, blockpos)) {
                        					((DoublePlantBlock) ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get()).placeAt(world, blockpos, 2);
                        					++i;
                        				}
                        			}
                        			return i > 0;
                	    			</#if>
					<#else>
					return super.place(world, generator, random, pos, config);
					</#if>
				}
			};
			event.getRegistry().register(feature.setRegistryName("${registryname}"));
		}

		@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
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

				<#if ((data.plantType == "normal" || data.plantType == "double") && data.generationType == "Grass")>
				biome.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(feature,
				    new <#if data.plantType == "normal">GrassFeatureConfig(${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState())<#else>NoFeatureConfig()</#if>,
						<#if !data.generateAtAnyHeight>Placement.NOISE_HEIGHTMAP_32, new NoiseDependant(-0.8, 0, ${data.frequencyOnChunks}<#else>Placement.HELL_FIRE, new FrequencyConfig(${data.frequencyOnChunks}</#if>)
				));
				<#else>
				biome.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(feature,
				<#if data.plantType == "double">new DoublePlantConfig(${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState())<#else>IFeatureConfig.NO_FEATURE_CONFIG</#if>,
						<#if !data.generateAtAnyHeight>Placement.<#if data.plantType == "normal" || data.plantType == "double">COUNT_HEIGHTMAP_32<#else>COUNT_HEIGHTMAP_DOUBLE</#if><#else>Placement.HELL_FIRE</#if>, new FrequencyConfig(${data.frequencyOnChunks})
				));
				</#if>
			}
		}
	}
}
<#-- @formatter:on -->
