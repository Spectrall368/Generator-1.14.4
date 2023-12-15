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
 # along setValue this program.  If not, see <https://www.gnu.org/licenses/>.
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
package ${package}.world.biome;

public class ${name}Biome extends Biome {

	public static void init() {
	<#if data.spawnBiome>
	BiomeManager.addSpawnBiome(biome);
		BiomeManager.addBiome(BiomeManager.BiomeType.
		<#if (data.temperature < -0.25)>
		ICY
		<#elseif (data.temperature > -0.25) && (data.temperature <= 0.15)>
		COOL
		<#elseif (data.temperature > 0.15) && (data.temperature <= 1.0)>
		WARM
		<#elseif (data.temperature > 1.0)>
		DESERT
		</#if>, new BiomeManager.BiomeEntry(${name}Biome, ${data.biomeWeight}));
        </#if>
	}

	public ${name}Biome() {
		super(new Biome.Builder()
			.downfall(${data.rainingPossibility}f)
			.depth(${data.baseHeight}f)
			.scale(${data.heightVariation}f)
			.temperature(${data.temperature}f)
			.precipitation(Biome.RainType.<#if (data.rainingPossibility > 0)><#if (data.temperature > 0.15)>RAIN<#else>SNOW</#if><#else>NONE</#if>)
			.category(Biome.Category.NONE)
			.waterColor(${data.waterColor?has_content?then(data.waterColor.getRGB(), 4159204)})
			.waterFogColor(${data.waterFogColor?has_content?then(data.waterFogColor.getRGB(), 329011)})
			<#if data.parent?? && data.parent.getUnmappedValue() != "No parent">
			.parent("${data.parent}")
			</#if>
			.surfaceBuilder(SurfaceBuilder.DEFAULT, new SurfaceBuilderConfig(${mappedBlockToBlockStateCode(data.groundBlock)}, ${mappedBlockToBlockStateCode(data.undergroundBlock)}, ${mappedBlockToBlockStateCode(data.getUnderwaterBlock())})));

        	<#list data.defaultFeatures as defaultFeature>
        	<#assign mfeat = generator.map(defaultFeature, "defaultfeatures")>
        		<#if mfeat != "null">
			DefaultBiomeFeatures.add${mfeat}(this);
			</#if>
		</#list>

		<#if data.spawnStronghold>
		this.addStructure(Feature.STRONGHOLD, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if data.spawnMineshaft>
		this.addStructure(Feature.MINESHAFT, new MineshaftConfig(0.004D, MineshaftStructure.Type.NORMAL));
		</#if>

		<#if data.spawnMineshaftMesa>
		this.addStructure(Feature.MINESHAFT, new MineshaftConfig(0.004D, MineshaftStructure.Type.MESA));
		</#if>

		<#if data.spawnPillagerOutpost>
		this.addStructure(Feature.PILLAGER_OUTPOST, new PillagerOutpostConfig(0.004D));
		</#if>

		<#if data.villageType != "none">
		this.addStructure(Feature.VILLAGE, new VillageConfig("village/${data.villageType}/town_centers", 6));
		</#if>

		<#if data.spawnWoodlandMansion>
		this.addStructure(Feature.WOODLAND_MANSION, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if data.spawnJungleTemple>
		this.addStructure(Feature.JUNGLE_TEMPLE, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if data.spawnDesertPyramid>
		this.addStructure(Feature.DESERT_PYRAMID, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if data.spawnSwampHut>
		this.addStructure(Feature.SWAMP_HUT, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if data.spawnIgloo>
		this.addStructure(Feature.IGLOO, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if data.spawnOceanMonument>
		this.addStructure(Feature.OCEAN_MONUMENT, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if data.spawnShipwreck>
		this.addStructure(Feature.SHIPWRECK, new ShipwreckConfig(false));
		</#if>

		<#if data.spawnShipwreckBeached>
		this.addStructure(Feature.SHIPWRECK, new ShipwreckConfig(true));
		</#if>

		<#if data.spawnBuriedTreasure>
		this.addStructure(Feature.BURIED_TREASURE, new BuriedTreasureConfig(0.01F));
		</#if>

		<#if data.oceanRuinType != "NONE">
		this.addStructure(Feature.OCEAN_RUIN, new OceanRuinConfig(OceanRuinStructure.Type.${data.oceanRuinType}, 0.3F, 0.9F));
		</#if>

		<#if data.spawnNetherBridge>
		this.addStructure(Feature.NETHER_BRIDGE, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if data.spawnEndCity>
		this.addStructure(Feature.END_CITY, IFeatureConfig.NO_FEATURE_CONFIG);
		</#if>

		<#if (data.flowersPerChunk > 0)>
		this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.DEFAULT_FLOWER, IFeatureConfig.NO_FEATURE_CONFIG, Placement.COUNT_HEIGHTMAP_32, new FrequencyConfig(${data.flowersPerChunk})));
		</#if>

		<#if (data.grassPerChunk > 0)>
		this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.GRASS, new GrassFeatureConfig(Blocks.GRASS.getDefaultState()), Placement.COUNT_HEIGHTMAP_DOUBLE, new FrequencyConfig(${data.grassPerChunk})));
		</#if>

		<#if (data.seagrassPerChunk > 0)>
		this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, createDecoratedFeature(Feature.SEAGRASS, new SeaGrassConfig(${data.seagrassPerChunk}, 0.3D), Placement.TOP_SOLID_HEIGHTMAP, IPlacementConfig.NO_PLACEMENT_CONFIG));
		</#if>

		<#if (data.mushroomsPerChunk > 0)>
		this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.BUSH, new BushConfig(Blocks.BROWN_MUSHROOM.getDefaultState()), Placement.CHANCE_HEIGHTMAP_DOUBLE, new ChanceConfig(${data.mushroomsPerChunk})));
		this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.BUSH, new BushConfig(Blocks.RED_MUSHROOM.getDefaultState()), Placement.CHANCE_HEIGHTMAP_DOUBLE, new ChanceConfig(${data.mushroomsPerChunk})));
		</#if>

		<#if (data.treesPerChunk > 0)>
			<#if data.treeType == data.TREES_CUSTOM>
			this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(new ${name}TreeFeature(), IFeatureConfig.NO_FEATURE_CONFIG, Placement.COUNT_EXTRA_HEIGHTMAP, new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1)));
            		<#elseif data.vanillaTreeType == "Big trees">
			this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.RANDOM_SELECTOR, new MultipleRandomFeatureConfig(new Feature[]{Feature.FANCY_TREE}, new IFeatureConfig[]{IFeatureConfig.NO_FEATURE_CONFIG}, new float[]{0.1F}, Feature.NORMAL_TREE, IFeatureConfig.NO_FEATURE_CONFIG), Placement.COUNT_EXTRA_HEIGHTMAP, new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1)));
            		<#elseif data.vanillaTreeType == "Savanna trees">
			this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.RANDOM_SELECTOR, new MultipleRandomFeatureConfig(new Feature[]{Feature.SAVANNA_TREE}, new IFeatureConfig[]{IFeatureConfig.NO_FEATURE_CONFIG}, new float[]{0.8F}, Feature.NORMAL_TREE, IFeatureConfig.NO_FEATURE_CONFIG), Placement.COUNT_EXTRA_HEIGHTMAP, new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1)));
            		<#elseif data.vanillaTreeType == "Mega pine trees">
			this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.RANDOM_SELECTOR, new MultipleRandomFeatureConfig(new Feature[]{Feature.MEGA_PINE_TREE}, new IFeatureConfig[]{IFeatureConfig.NO_FEATURE_CONFIG, IFeatureConfig.NO_FEATURE_CONFIG}, new float[]{1f/3, 1f/3}, Feature.SPRUCE_TREE, IFeatureConfig.NO_FEATURE_CONFIG), Placement.COUNT_EXTRA_HEIGHTMAP, new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1)));
            		<#elseif data.vanillaTreeType == "Mega spruce trees">
			this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.RANDOM_SELECTOR, new MultipleRandomFeatureConfig(new Feature[]{Feature.MEGA_SPRUCE_TREE}, new IFeatureConfig[]{IFeatureConfig.NO_FEATURE_CONFIG, IFeatureConfig.NO_FEATURE_CONFIG}, new float[]{1f/3, 1f/3}, Feature.SPRUCE_TREE, IFeatureConfig.NO_FEATURE_CONFIG), Placement.COUNT_EXTRA_HEIGHTMAP, new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1)));
            		<#elseif data.vanillaTreeType == "Birch trees">
			this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.BIRCH_TREE, IFeatureConfig.NO_FEATURE_CONFIG, Placement.COUNT_EXTRA_HEIGHTMAP, new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1)));
            		<#else>
			this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.RANDOM_SELECTOR, new MultipleRandomFeatureConfig(new Feature[]{Feature.BIRCH_TREE, Feature.FANCY_TREE}, new IFeatureConfig[]{IFeatureConfig.NO_FEATURE_CONFIG, IFeatureConfig.NO_FEATURE_CONFIG}, new float[]{0.2F, 0.1F}, Feature.NORMAL_TREE, IFeatureConfig.NO_FEATURE_CONFIG), Placement.COUNT_EXTRA_HEIGHTMAP, new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1)));
			</#if>
		</#if>

		<#if (data.bigMushroomsChunk > 0)>
		this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.RANDOM_BOOLEAN_SELECTOR, new TwoFeatureChoiceConfig(Feature.HUGE_RED_MUSHROOM, new BigMushroomFeatureConfig(false), Feature.HUGE_BROWN_MUSHROOM, new BigMushroomFeatureConfig(false)), Placement.COUNT_HEIGHTMAP, new FrequencyConfig(${data.bigMushroomsChunk})));
		</#if>

		<#if (data.reedsPerChunk > 0)>
		this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.REED, IFeatureConfig.NO_FEATURE_CONFIG, Placement.COUNT_HEIGHTMAP_DOUBLE, new FrequencyConfig(${data.reedsPerChunk})));
		</#if>

		<#if (data.cactiPerChunk > 0)>
		this.addFeature(GenerationStage.Decoration.VEGETAL_DECORATION, Biome.createDecoratedFeature(Feature.CACTUS, IFeatureConfig.NO_FEATURE_CONFIG, Placement.COUNT_HEIGHTMAP_DOUBLE, new FrequencyConfig(${data.cactiPerChunk})));
		</#if>

		<#if (data.sandPatchesPerChunk > 0)>
		this.addFeature(GenerationStage.Decoration.UNDERGROUND_ORES, Biome.createDecoratedFeature(Feature.DISK, new SphereReplaceConfig(Blocks.SAND.getDefaultState(), 7, 2, Lists.newArrayList(${mappedBlockToBlockStateCode(data.groundBlock)}, ${mappedBlockToBlockStateCode(data.undergroundBlock)})), Placement.COUNT_TOP_SOLID, new FrequencyConfig(${data.sandPatchesPerChunk})));
		</#if>

		<#if (data.gravelPatchesPerChunk > 0)>
		this.addFeature(GenerationStage.Decoration.UNDERGROUND_ORES, Biome.createDecoratedFeature(Feature.DISK, new SphereReplaceConfig(Blocks.GRAVEL.getDefaultState(), 6, 2, Lists.newArrayList(${mappedBlockToBlockStateCode(data.groundBlock)}, ${mappedBlockToBlockStateCode(data.undergroundBlock)})), Placement.COUNT_TOP_SOLID, new FrequencyConfig(${data.gravelPatchesPerChunk})));
		</#if>

		<#list data.spawnEntries as spawnEntry>
			<#assign entity = generator.map(spawnEntry.entity.getUnmappedValue(), "entities", 1)!"null">
			<#if entity != "null">
			this.addSpawn(${generator.map(spawnEntry.spawnType, "mobspawntypes")}, new Biome.SpawnListEntry(${entity}, ${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
			</#if>
		</#list>
		}

		@OnlyIn(Dist.CLIENT) @Override public int getGrassColor(BlockPos pos) {
			return ${data.grassColor?has_content?then(data.grassColor.getRGB(), 9470285)};
		}

        	@OnlyIn(Dist.CLIENT) @Override public int getFoliageColor(BlockPos pos) {
        	return ${data.foliageColor?has_content?then(data.foliageColor.getRGB(), 10387789)};
       	 	}

		@OnlyIn(Dist.CLIENT) @Override public int getSkyColorByTemp(float currentTemperature) {
			return ${data.airColor?has_content?then(data.airColor.getRGB(), 7972607)};
		}

    <#if data.treeType == data.TREES_CUSTOM && (data.treesPerChunk > 0)>
	static class ${name}TreeFeature extends AbstractTreeFeature<NoFeatureConfig> {

		${name}TreeFeature() {
			super(NoFeatureConfig::deserialize, false);
		}

		@Override public boolean place(Set<BlockPos> changedBlocks, IWorldGenerationReader worldgen, Random rand, BlockPos position, MutableBoundingBox bbox) {
			if (!(worldgen instanceof IWorld))
				return false;

			IWorld world = (IWorld) worldgen;
			int height = rand.nextInt(5) + ${data.minHeight};
			boolean spawnTree = true;

			if (position.getY() >= 1 && position.getY() + height + 1 <= world.getHeight()) {
				for (int j = position.getY(); j <= position.getY() + 1 + height; j++) {
					int k = 1;

					if (j == position.getY())
						k = 0;

					if (j >= position.getY() + height - 1)
						k = 2;

					for (int px = position.getX() - k; px <= position.getX() + k && spawnTree; px++) {
						for (int pz = position.getZ() - k; pz <= position.getZ() + k && spawnTree; pz++) {
							if (j >= 0 && j < world.getHeight()) {
								if (!this.isReplaceable(world, new BlockPos(px, j, pz)))
									spawnTree = false;
							} else {
								spawnTree = false;
							}
						}
					}
				}

				if (!spawnTree) {
					return false;
				} else {
					Block ground = world.getBlockState(position.add(0, -1, 0)).getBlock();
					Block ground2 = world.getBlockState(position.add(0, -2, 0)).getBlock();
					if (!((ground == ${mappedBlockToBlock(data.groundBlock)}
						|| ground == ${mappedBlockToBlock(data.undergroundBlock)})
						&& (ground2 == ${mappedBlockToBlock(data.groundBlock)}
						|| ground2 == ${mappedBlockToBlock(data.undergroundBlock)})))
						return false;

					BlockState state = world.getBlockState(position.down());
					if (position.getY() < world.getHeight() - height - 1) {
						setTreeBlockState(changedBlocks, world, position.down(), ${mappedBlockToBlockStateCode(data.undergroundBlock)}, bbox);

						for (int genh = position.getY() - 3 + height; genh <= position.getY() + height; genh++) {
							int i4 = genh - (position.getY() + height);
							int j1 = (int) (1 - i4 * 0.5);

							for (int k1 = position.getX() - j1; k1 <= position.getX() + j1; ++k1) {
								for (int i2 = position.getZ() - j1; i2 <= position.getZ() + j1; ++i2) {
									int j2 = i2 - position.getZ();

									if (Math.abs(position.getX()) != j1 || Math.abs(j2) != j1 || rand.nextInt(2) != 0 && i4 != 0) {
										BlockPos blockpos = new BlockPos(k1, genh, i2);
										state = world.getBlockState(blockpos);

										if (state.getBlock().isAir(state, world, blockpos)
												|| state.getMaterial().blocksMovement()
												|| state.isIn(BlockTags.LEAVES)
												|| state.getBlock() == <#if (data.treeVines?has_content && !data.treeVines.isEmpty())> ${mappedBlockToBlock(data.treeVines)}<#else> Blocks.AIR</#if>
												|| state.getBlock() == ${mappedBlockToBlock(data.treeBranch)}) {
											setTreeBlockState(changedBlocks, world, blockpos, ${mappedBlockToBlockStateCode(data.treeBranch)}, bbox);
											}
									}
								}
							}
						}

						for (int genh = 0; genh < height; genh++) {
							BlockPos genhPos = position.up(genh);
							state = world.getBlockState(genhPos);

							setTreeBlockState(changedBlocks, world, genhPos, ${mappedBlockToBlockStateCode(data.treeStem)}, bbox);

							if (state.getBlock().isAir(state, world, genhPos)
										|| state.getMaterial().blocksMovement()
										|| state.isIn(BlockTags.LEAVES)
										|| state.getBlock() == <#if (data.treeVines?has_content && !data.treeVines.isEmpty())> ${mappedBlockToBlock(data.treeVines)}<#else> Blocks.AIR</#if>
										|| state.getBlock() == ${mappedBlockToBlock(data.treeBranch)}) {

								<#if (data.treeVines?has_content && !data.treeVines.isEmpty())>
								if (genh > 0) {
									if (rand.nextInt(3) > 0 && world.isAirBlock(position.add(-1, genh, 0)))
										setTreeBlockState(changedBlocks, world, position.add(-1, genh, 0), ${mappedBlockToBlockStateCode(data.treeVines)}, bbox);

									if (rand.nextInt(3) > 0 && world.isAirBlock(position.add(1, genh, 0)))
										setTreeBlockState(changedBlocks, world, position.add(1, genh, 0), ${mappedBlockToBlockStateCode(data.treeVines)}, bbox);

									if (rand.nextInt(3) > 0 && world.isAirBlock(position.add(0, genh, -1)))
										setTreeBlockState(changedBlocks, world, position.add(0, genh, -1), ${mappedBlockToBlockStateCode(data.treeVines)}, bbox);

									if (rand.nextInt(3) > 0 && world.isAirBlock(position.add(0, genh, 1)))
										setTreeBlockState(changedBlocks, world, position.add(0, genh, 1), ${mappedBlockToBlockStateCode(data.treeVines)}, bbox);
								}
                                				</#if>
								}
						}

						<#if (data.treeVines?has_content && !data.treeVines.isEmpty())>
						for (int genh = position.getY() - 3 + height; genh <= position.getY() + height; genh++) {
							int k4 = (int) (1 - (genh - (position.getY() + height)) * 0.5);
							for (int genx = position.getX() - k4; genx <= position.getX() + k4; genx++) {
								for (int genz = position.getZ() - k4; genz <= position.getZ() + k4; genz++) {
									BlockPos bpos = new BlockPos(genx, genh, genz);
									state = world.getBlockState(bpos);
									if (state.isIn(BlockTags.LEAVES)
										|| state.getBlock() == ${mappedBlockToBlock(data.treeBranch)}) {
										BlockPos blockpos1 = bpos.south();
										BlockPos blockpos2 = bpos.west();
										BlockPos blockpos3 = bpos.east();
										BlockPos blockpos4 = bpos.north();

										if (rand.nextInt(4) == 0 && world.isAirBlock(blockpos2))
											this.addVines(world, blockpos2, changedBlocks, bbox);

										if (rand.nextInt(4) == 0 && world.isAirBlock(blockpos3))
											this.addVines(world, blockpos3, changedBlocks, bbox);

										if (rand.nextInt(4) == 0 && world.isAirBlock(blockpos4))
											this.addVines(world, blockpos4, changedBlocks, bbox);

										if (rand.nextInt(4) == 0 && world.isAirBlock(blockpos1))
											this.addVines(world, blockpos1, changedBlocks, bbox);
									}
								}
							}
						}
                        			</#if>

						<#if (data.treeFruits?has_content && !data.treeFruits.isEmpty())>
						if (rand.nextInt(4) == 0 && height > 5) {
							for (int hlevel = 0; hlevel < 2; hlevel++) {
								for (Direction Direction : Direction.Plane.HORIZONTAL) {
									if (rand.nextInt(4 - hlevel) == 0) {
										Direction dir = Direction.getOpposite();
										setTreeBlockState(changedBlocks, world, position.add(dir.getXOffset(), height - 5 + hlevel, dir.getZOffset()), ${mappedBlockToBlockStateCode(data.treeFruits)}, bbox);
									}
								}
							}
						}
						</#if>

						return true;
					} else {
						return false;
					}
				}
			} else {
				return false;
			}
		}

		private void addVines(IWorld world, BlockPos pos, Set<BlockPos> changedBlocks, MutableBoundingBox bbox) {
			setTreeBlockState(changedBlocks, world, pos, <#if (data.treeVines?has_content && !data.treeVines.isEmpty())> ${mappedBlockToBlockStateCode(data.treeVines)}<#else> Blocks.AIR.getDefaultState()</#if>, bbox);
			int i = 5;
			for (BlockPos blockpos = pos.down(); world.isAirBlock(blockpos) && i > 0; --i) {
				setTreeBlockState(changedBlocks, world, blockpos, <#if (data.treeVines?has_content && !data.treeVines.isEmpty())> ${mappedBlockToBlockStateCode(data.treeVines)}<#else> Blocks.AIR.getDefaultState()</#if>, bbox);
				blockpos = blockpos.down();
			}
		}

		private boolean canGrowInto(Block blockType) {
        		return blockType.getDefaultState().getMaterial() == Material.AIR ||
				blockType == ${mappedBlockToBlock(data.treeStem)} ||
				blockType == ${mappedBlockToBlock(data.treeBranch)} ||
				blockType == ${mappedBlockToBlock(data.groundBlock)} ||
				blockType == ${mappedBlockToBlock(data.undergroundBlock)};
		}

		private boolean isReplaceable(IWorld world, BlockPos pos) {
			BlockState state = world.getBlockState(pos);
        		return state.getBlock().isAir(state, world, pos) || canGrowInto(state.getBlock()) || !state.getMaterial().blocksMovement();
		}

		private void setTreeBlockState(Set<BlockPos> changedBlocks, IWorldWriter world, BlockPos pos, BlockState state, MutableBoundingBox mbb) {
			super.setLogState(changedBlocks, world, pos, state, mbb);
			changedBlocks.add(pos.toImmutable());
		}
	}
    </#if>
}
<#-- @formatter:on -->
