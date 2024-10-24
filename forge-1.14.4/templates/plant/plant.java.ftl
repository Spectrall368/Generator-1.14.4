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
<#include "../boundingboxes.java.ftl">
<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">
<#include "../mcitems.ftl">
package ${package}.block;

import net.minecraftforge.common.property.Properties;

<#compress>
<#assign interfaces = []>
<#if data.isBonemealable>
	<#assign interfaces += ["IGrowable"]>
</#if>
public class ${name}Block extends <#if data.plantType == "normal">Flower<#elseif data.plantType == "growapable">SugarCane<#elseif data.plantType == "double">DoublePlant</#if>Block
	<#if interfaces?size gt 0>
		implements ${interfaces?join(",")}
	</#if>{
	public ${name}Block() {
		super(<#if data.plantType == "normal">${generator.map(data.suspiciousStewEffect, "effects")}, ${data.suspiciousStewDuration},</#if>
		<#if generator.map(data.colorOnMap, "mapcolors") != "DEFAULT">
		Block.Properties.create(Material.PLANTS, MaterialColor.${generator.map(data.colorOnMap, "mapcolors")})
		<#else>
		Block.Properties.create(Material.PLANTS)
		</#if>
		<#if data.plantType == "growapable" || data.forceTicking>
		.tickRandomly()
		</#if>
		<#if data.isCustomSoundType>
			.sound(new SoundType(1.0f, 1.0f, null, null, null, null, null) {
				@Override public SoundEvent getBreakSound() { return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${(data.breakSound?has_content && data.breakSound.getMappedValue()?has_content)?then(data.breakSound, "intentionally_empty")}")); }
				@Override public SoundEvent getStepSound() { return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${(data.stepSound?has_content && data.stepSound.getMappedValue()?has_content)?then(data.stepSound, "intentionally_empty")}")); }
				@Override public SoundEvent getPlaceSound() { return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${(data.placeSound?has_content && data.placeSound.getMappedValue()?has_content)?then(data.placeSound, "intentionally_empty")}")); }
				@Override public SoundEvent getHitSound() { return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${(data.hitSound?has_content && data.hitSound.getMappedValue()?has_content)?then(data.hitSound, "intentionally_empty")}")); }
				@Override public SoundEvent getFallSound() { return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${(data.fallSound?has_content && data.fallSound.getMappedValue()?has_content)?then(data.fallSound, "intentionally_empty")}")); }
			})
		<#else>
			.sound(SoundType.${data.soundOnStep})
		</#if>
		<#if data.unbreakable>
		.hardnessAndResistance(-1, 3600000)
		<#elseif data.hardness == data.resistance>
		.hardnessAndResistance(${data.hardness}f)
		<#else>
		.hardnessAndResistance(${data.hardness}f, ${data.resistance}f)
		</#if>
		<#if data.luminance != 0>
		.lightValue(${data.luminance})
		</#if>
		<#if data.isSolid>
			<#if (data.customBoundingBox && data.boundingBoxes??) || (data.offsetType != "NONE")>
			.variableOpacity()
			</#if>
		<#else>
		.doesNotBlockMovement()
		</#if>
		);
	}

	<#if data.customBoundingBox && data.boundingBoxes??>
	@Override public VoxelShape getShape(BlockState state, IBlockReader world, BlockPos pos, ISelectionContext context) {
		<#if data.isBoundingBoxEmpty()>
			return VoxelShapes.empty();
		<#else>
			<#if !data.disableOffset> Vec3d offset = state.getOffset(world, pos); </#if>
			<@boundingBoxWithRotation data.positiveBoundingBoxes() data.negativeBoundingBoxes() data.disableOffset 0/>
		</#if>
	}
	</#if>

	<#if data.plantType == "normal">
		<#if data.suspiciousStewEffect?starts_with("CUSTOM:")>
		@Override public Effect getStewEffect() {
			return ${generator.map(data.suspiciousStewEffect, "effects")};
		}
		</#if>

		<#if (data.suspiciousStewDuration > 0)>
		@Override public int getStewEffectDuration() {
			return ${data.suspiciousStewDuration};
		}
		</#if>
	</#if>

	<#if data.isReplaceable>
	@Override public boolean isReplaceable(BlockState state, BlockItemUseContext useContext) {
		return useContext.getItem().getItem() != this.asItem();
	}
	</#if>

	<#if data.flammability != 0>
	@Override public int getFlammability(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.flammability};
	}
	</#if>

	<#if generator.map(data.aiPathNodeType, "pathnodetypes") != "DEFAULT">
	@Override public PathNodeType getAiPathNodeType(BlockState state, IBlockReader world, BlockPos pos, MobEntity entity) {
		return PathNodeType.${generator.map(data.aiPathNodeType, "pathnodetypes")};
	}
	</#if>

	<#if data.offsetType != "XZ">
	@Override public Block.OffsetType getOffsetType() {
		return Block.OffsetType.${data.offsetType};
	}
	</#if>

	<#if data.emissiveRendering>
        @OnlyIn(Dist.CLIENT) @Override public int getPackedLightmapCoords(BlockState state, IEnviromentBlockReader worldIn, BlockPos pos) {
		return 15728880;
	}
	</#if>

	<#if data.isSolid>
   	@Override public boolean isSolid(BlockState state) {
     	 	return true;
   	}
	</#if>

	<@addSpecialInformation data.specialInformation, true/>

	<#if data.fireSpreadSpeed != 0>
	@Override public int getFireSpreadSpeed(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.fireSpreadSpeed};
	}
	</#if>

	<#if data.creativePickItem?? && !data.creativePickItem.isEmpty()>
	@Override public ItemStack getPickBlock(BlockState state, RayTraceResult target, IBlockReader world, BlockPos pos, PlayerEntity player) {
		return ${mappedMCItemToItemStackCode(data.creativePickItem, 1)};
	}
	</#if>

	<#if (data.canBePlacedOn?size > 0) || hasProcedure(data.placingCondition)>
		<#if data.plantType != "growapable">
		@Override public boolean isValidGround(BlockState groundState, IBlockReader worldIn, BlockPos pos) {
			<#if hasProcedure(data.placingCondition)>
			boolean additionalCondition = true;
			if (worldIn instanceof IWorld world) {
				int x = pos.getX();
				int y = pos.getY() + 1;
				int z = pos.getZ();
				BlockState blockstate = world.getBlockState(pos.up());
				additionalCondition = <@procedureOBJToConditionCode data.placingCondition/>;
			}
			</#if>

			return
			<#if (data.canBePlacedOn?size > 0)>
				<@canPlaceOnList data.canBePlacedOn hasProcedure(data.placingCondition)/>
			</#if>
			<#if (data.canBePlacedOn?size > 0) && hasProcedure(data.placingCondition)> && </#if>
			<#if hasProcedure(data.placingCondition)> additionalCondition </#if>;
		}
		</#if>

		@Override public boolean isValidPosition(BlockState blockstate, IWorldReader worldIn, BlockPos pos) {
			BlockPos blockpos = pos.down();
			BlockState groundState = worldIn.getBlockState(blockpos);

			<#if data.plantType = "normal">
				return this.isValidGround(groundState, worldIn, blockpos)
			<#elseif data.plantType == "growapable">
				<#if hasProcedure(data.placingCondition)>
				boolean additionalCondition = true;
				if (worldIn instanceof IWorld world) {
					int x = pos.getX();
					int y = pos.getY();
					int z = pos.getZ();
					additionalCondition = <@procedureOBJToConditionCode data.placingCondition/>;
				}
				</#if>

				return groundState.getBlock() == this ||
				<#if (data.canBePlacedOn?size > 0)>
					<@canPlaceOnList data.canBePlacedOn hasProcedure(data.placingCondition)/>
				</#if>
				<#if (data.canBePlacedOn?size > 0) && hasProcedure(data.placingCondition)> && </#if>
				<#if hasProcedure(data.placingCondition)> additionalCondition </#if>
			<#else>
				if (blockstate.get(HALF) == DoubleBlockHalf.UPPER)
					return groundState.getBlock() == this && groundState.get(HALF) == DoubleBlockHalf.LOWER;
				else
					return this.isValidGround(groundState, worldIn, blockpos)
			</#if>;
		}
	</#if>

	<#if !(data.growapableSpawnType == "Plains" && data.plantType == "normal")>
	@Override public PlantType getPlantType(IBlockReader world, BlockPos pos) {
		return PlantType.${generator.map(data.growapableSpawnType, "planttypes")};
	}
	</#if>

	<@onBlockAdded data.onBlockAdded, false, 0/>

	<#if data.plantType == "growapable" || hasProcedure(data.onTickUpdate)>
	@Override public void randomTick(BlockState blockstate, World world, BlockPos pos, Random random) {
		<#if data.plantType == "growapable">
		if (world.isAirBlock(pos.up())) {
			int i = 1;
			for(;world.getBlockState(pos.down(i)).getBlock() == this; ++i);
			if (i < ${data.growapableMaxHeight}) {
				int j = blockstate.get(AGE);
				if (ForgeHooks.onCropsGrowPre(world, pos, blockstate, true)) {
					if (j == 15) {
						world.setBlockState(pos.up(), getDefaultState());
						world.setBlockState(pos, blockstate.with(AGE, 0), 4);
					} else {
						world.setBlockState(pos, blockstate.with(AGE, j + 1), 4);
					}
				}
			}
		}
		</#if>

		<#if hasProcedure(data.onTickUpdate)>
			<@procedureCode data.onTickUpdate, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate"
			}/>
		</#if>
	}
	</#if>

	<@onAnimateTick data.onRandomUpdateEvent/>

	<@onRedstoneOrNeighborChanged "", "", data.onNeighbourBlockChanges/>

	<@onEntityCollides data.onEntityCollides/>

	<@onDestroyedByPlayer data.onDestroyedByPlayer/>

	<@onDestroyedByExplosion data.onDestroyedByExplosion/>

	<@onStartToDestroy data.onStartToDestroy/>

	<@onBlockPlacedBy data.onBlockPlacedBy/>

	<@onBlockRightClicked data.onRightClicked/>

	<@onEntityWalksOn data.onEntityWalksOn/>

	<@onHitByProjectile data.onHitByProjectile/>

	<#if data.isBonemealable>
	<@bonemealEvents data.isBonemealTargetCondition, data.bonemealSuccessCondition, data.onBonemealSuccess/>
	</#if>

	<#if data.hasTileEntity>
	@Override public boolean hasTileEntity(BlockState state) {
		return true;
	}

	@Override public TileEntity createTileEntity(BlockState state, IBlockReader world) {
		return new ${name}BlockEntity();
	}

	@Override public boolean eventReceived(BlockState state, World world, BlockPos pos, int eventID, int eventParam) {
		super.eventReceived(state, world, pos, eventID, eventParam);
		TileEntity blockEntity = world.getTileEntity(pos);
		return blockEntity == null ? false : blockEntity.receiveClientEvent(eventID, eventParam);
	}
	</#if>

	@OnlyIn(Dist.CLIENT) @Override public BlockRenderLayer getRenderLayer() {
		return BlockRenderLayer.CUTOUT;
	}

	<#if data.tintType != "No tint">
		@OnlyIn(Dist.CLIENT) public static void blockColorLoad(ColorHandlerEvent.Block event) {
			event.getBlockColors().register((bs, world, pos, index) -> {
				<#if data.tintType == "Default foliage">
					return FoliageColors.getDefault();
				<#elseif data.tintType == "Birch foliage">
					return FoliageColors.getBirch();
				<#elseif data.tintType == "Spruce foliage">
					return FoliageColors.getSpruce();
				<#else>
					return world != null && pos != null ?
					<#if data.tintType == "Grass">
						BiomeColors.getGrassColor(world, pos) : GrassColors.get(0.5D, 1.0D);
					<#elseif data.tintType == "Foliage">
						BiomeColors.getFoliageColor(world, pos) : FoliageColors.getDefault();
					<#elseif data.tintType == "Water">
						BiomeColors.getWaterColor(world, pos) : -1;
					<#else>
						Minecraft.getInstance().world.getBiome(pos).getWaterFogColor() : 329011;
					</#if>
				</#if>
			}, ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get());
		}

		<#if data.isItemTinted>
		@OnlyIn(Dist.CLIENT) public static void itemColorLoad(ColorHandlerEvent.Item event) {
			event.getItemColors().register((stack, index) -> {
				<#if data.tintType == "Grass">
					return GrassColors.get(0.5D, 1.0D);
				<#elseif data.tintType == "Foliage" || data.tintType == "Default foliage">
					return FoliageColors.getDefault();
				<#elseif data.tintType == "Birch foliage">
					return FoliageColors.getBirch();
				<#elseif data.tintType == "Spruce foliage">
					return FoliageColors.getSpruce();
				<#elseif data.tintType == "Water">
					return 3694022;
				<#else>
					return 329011;
				</#if>
			}, ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get());
		}
		</#if>
	</#if>
}
</#compress>
<#-- @formatter:on -->
<#macro canPlaceOnList blockList condition>
<#if (blockList?size > 1) && condition>(</#if>
<#list blockList as canBePlacedOn>
groundState.getBlock() == ${mappedBlockToBlock(canBePlacedOn)}<#sep>||
</#list><#if (blockList?size > 1) && condition>)</#if>
</#macro>
