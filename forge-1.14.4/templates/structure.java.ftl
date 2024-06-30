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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
package ${package}.world.structure;

@Mod.EventBusSubscriber public class ${name}Structure {

	private static Feature<NoFeatureConfig> feature = null;

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) private static class FeatureRegisterHandler {

		@SubscribeEvent public static void registerFeature(RegistryEvent.Register<Feature<?>> event) {
			feature = new Feature<NoFeatureConfig>(NoFeatureConfig::deserialize) {
				@Override public boolean place(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, NoFeatureConfig config) {
					int ci = (pos.getX() >> 4) << 4;
					int ck = (pos.getZ() >> 4) << 4;

					DimensionType dimensionType = world.getDimension().getType();
					boolean dimensionCriteria = false;

				<#if data.spawnBiomes?has_content>
					<#list data.spawnBiomes as restrictionBiome>
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
				</#if>

					if(!dimensionCriteria)
						return false;

					if ((random.nextInt(1000000) + 1) <= ${data.spawnProbability}) {
						int count = random.nextInt(${data.spacing - data.separation + 1}) + ${data.separation};
						for(int a = 0; a < count; a++) {
							int i = ci + random.nextInt(16);
							int k = ck + random.nextInt(16);
							int j = world.getHeight(Heightmap.Type.${data.surfaceDetectionType}, i, k);

							<#if generator.map(data.generationStep, "generationsteps") == "SURFACE_STRUCTURES" || generator.map(data.generationStep, "generationsteps") == "VEGETAL_DECORATION">
								j -= 1;
							<#elseif generator.map(data.generationStep, "generationsteps") == "RAW_GENERATION">
								j += random.nextInt(64) + 16;
							<#elseif generator.map(data.generationStep, "generationsteps") == "UNDERGROUND_STRUCTURES" || generator.map(data.generationStep, "generationsteps") == "UNDERGROUND_ORES" || generator.map(data.generationStep, "generationsteps") == "UNDERGROUND_DECORATION">
								j = MathHelper.nextInt(random, 8, Math.max(j, 9));
							</#if>

							<#if data.restrictionBlocks?has_content>
								BlockState blockAt = world.getBlockState(new BlockPos(i, j, k));
								boolean blockCriteria = false;
								<#list data.restrictionBlocks as restrictionBlock>
									if (blockAt.getBlock() == ${mappedBlockToBlock(restrictionBlock)})
										blockCriteria = true;
								</#list>
								if (!blockCriteria)
									continue;
							</#if>

								Rotation rotation = Rotation.values()[random.nextInt(3)];
								Mirror mirror = Mirror.values()[random.nextInt(2)];

							BlockPos spawnTo = new BlockPos(i, j + ${data.spawnHeightOffset}, k);

							int x = spawnTo.getX();
							int y = spawnTo.getY();
							int z = spawnTo.getZ();

							<#if hasProcedure(data.generateCondition)>
							if (!<@procedureOBJToConditionCode data.generateCondition/>)
								continue;
							</#if>

							Template template = ((ServerWorld) world.getWorld()).getSaveHandler().getStructureTemplateManager().getTemplateDefaulted(new ResourceLocation("${modid}" ,"${data.structure}"));

							if (template == null)
								return false;

							template.addBlocksToWorld(world, spawnTo,
									new PlacementSettings()
											.setRotation(rotation)
											.setRandom(random)
											.setMirror(mirror)
											 <#if data.ignoredBlocks?has_content>.addProcessor(new BlockIgnoreStructureProcessor(ImmutableList.of(<#list data.ignoredBlocks as block>${mappedBlockToBlockStateCode(block)}<#sep>,</#list>)))</#if>
											.setChunk(null)
											.setIgnoreEntities(false));

							<#if hasProcedure(data.onStructureGenerated)>
								<@procedureOBJToCode data.onStructureGenerated/>
							</#if>
						}
					}

					return true;
				}
			};

			event.getRegistry().register(feature.setRegistryName("${registryname}"));
		}

		@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
			for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
				<#if data.spawnBiomes?has_content>
					boolean biomeCriteria = false;
					<#list data.spawnBiomes as restrictionBiome>
						<#if restrictionBiome.canProperlyMap() && !restrictionBiome.getUnmappedValue().startsWith("TAG:")>
						if (ForgeRegistries.BIOMES.getKey(biome).equals(new ResourceLocation("${restrictionBiome}")))
							biomeCriteria = true;
						</#if>
					</#list>
					if (!biomeCriteria)
						continue;
				</#if>
	
				biome.addFeature(GenerationStage.Decoration.${generator.map(data.generationStep, "generationsteps")},
					Biome.createDecoratedFeature(feature, IFeatureConfig.NO_FEATURE_CONFIG, Placement.NOPE, IPlacementConfig.NO_PLACEMENT_CONFIG));
			}
		}
	}
}
<#-- @formatter:on -->
