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
<#include "../boundingboxes.java.ftl">
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">
package ${package}.block;

<#compress>
public class ${name}Block extends
	<#if data.hasGravity>
		FallingBlock
	<#elseif data.blockBase?has_content && data.blockBase == "Button">
		<#if (data.material.getUnmappedValue() == "WOOD") || (data.material.getUnmappedValue() == "NETHER_WOOD")>Wood<#else>Stone</#if>ButtonBlock
	<#elseif data.blockBase?has_content>
		${data.blockBase}Block
	<#else>
		Block
	</#if>

	<#assign interfaces = []>
	<#if data.isWaterloggable>
		<#assign interfaces += ["IWaterLoggable"]>
	</#if>
	<#if data.isBonemealable>
		<#assign interfaces += ["IGrowable"]>
	</#if>
	<#if interfaces?size gt 0>
		implements ${interfaces?join(",")}
	</#if>
{

	<#if data.rotationMode == 1 || data.rotationMode == 3>
		public static final DirectionProperty FACING = HorizontalBlock.HORIZONTAL_FACING;
		<#if data.enablePitch>
		public static final EnumProperty<AttachFace> FACE = HorizontalFaceBlock.FACE;
		</#if>
	<#elseif data.rotationMode == 2 || data.rotationMode == 4>
		public static final DirectionProperty FACING = DirectionalBlock.FACING;
	<#elseif data.rotationMode == 5>
		public static final EnumProperty<Direction.Axis> AXIS = BlockStateProperties.AXIS;
	</#if>
	<#if data.isWaterloggable>
		public static final BooleanProperty WATERLOGGED = BlockStateProperties.WATERLOGGED;
	</#if>
	<#list data.customProperties as prop>
		<#assign propName = prop.property().getName().replace("CUSTOM:", "")>
		<#if prop.property().getClass().getSimpleName().equals("LogicType")>
			public static final BooleanProperty ${propName?upper_case} = BooleanProperty.create("${propName}");
		<#elseif prop.property().getClass().getSimpleName().equals("IntegerType")>
			public static final IntegerProperty ${propName?upper_case} = IntegerProperty.create("${propName}", ${prop.property().getMin()}, ${prop.property().getMax()});
		<#elseif prop.property().getClass().getSimpleName().equals("StringType")>
			public static final EnumProperty<${StringUtils.snakeToCamel(propName)}Property> ${propName?upper_case} = EnumProperty.create("${propName}", ${StringUtils.snakeToCamel(propName)}Property.class);
		</#if>
	</#list>

	<#macro blockProperties>
		<#if generator.map(data.colorOnMap, "mapcolors") != "DEFAULT">
			Block.Properties.create(Material.${data.material}, MaterialColor.${generator.map(data.colorOnMap, "mapcolors")})
		<#else>
			Block.Properties.create(Material.${data.material})
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
		<#if data.destroyTool != "Not specified">
			.harvestLevel(<#if data.vanillaToolTier == "NONE">
			 0
			<#elseif data.vanillaToolTier == "STONE">
			1
			<#elseif data.vanillaToolTier == "IRON">
			2
			<#else>
			3
			</#if>)
			.harvestTool(ToolType.${data.destroyTool?upper_case})
		</#if>
		<#if data.isNotColidable>
			.doesNotBlockMovement()
		</#if>
		<#if data.slipperiness != 0.6>
			.slipperiness(${data.slipperiness}f)
		</#if>
		<#if data.tickRandomly>
			.tickRandomly()
		</#if>
		<#if (data.boundingBoxes?? && !data.blockBase?? && !data.isFullCube() && data.offsetType != "NONE")
				|| (data.blockBase?has_content && !data.isFullCube() && data.offsetType != "NONE")>
			.variableOpacity()
		</#if>
	</#macro>

	public ${name}Block() {
		<#if data.blockBase?has_content && data.blockBase == "Stairs">
			super(() -> Blocks.AIR.getDefaultState(), <@blockProperties/>);
		<#elseif data.blockBase?has_content && data.blockBase == "PressurePlate">
		    <#if data.material.getUnmappedValue() == "WOOD">
		        super(Sensitivity.EVERYTHING, <@blockProperties/>);
		    <#else>
		        super(Sensitivity.MOBS, <@blockProperties/>);
		    </#if>
		<#elseif data.blockBase?has_content && data.blockBase == "Button">
			<#if data.material.getUnmappedValue() == "WOOD">
		        super(true, <@blockProperties/>);
			<#else>
		        super(false, <@blockProperties/>);
			</#if>
		<#else>
			super(<@blockProperties/>);
		</#if>

	    <#if data.rotationMode != 0 || data.isWaterloggable || data.customProperties?has_content>
	    this.setDefaultState(this.stateContainer.getBaseState()
	    	<#if data.rotationMode == 1 || data.rotationMode == 3>
	    	.with(FACING, Direction.NORTH)
	    	    <#if data.enablePitch>
	    	    .with(FACE, AttachFace.WALL)
	    	    </#if>
	    	<#elseif data.rotationMode == 2 || data.rotationMode == 4>
	    	.with(FACING, Direction.NORTH)
	    	<#elseif data.rotationMode == 5>
	    	.with(AXIS, Direction.Axis.Y)
	    	</#if>
		<@initCustomBlockStateProperties/>
	    	<#if data.isWaterloggable>
	    	.with(WATERLOGGED, false)
	    	</#if>
	    );
		</#if>
	}

		<#if data.blockBase?has_content && data.blockBase == "Fence">
		@Override public boolean func_220111_a(BlockState state, boolean checkattach, Direction face) {
	    	  boolean flag = state.getBlock() instanceof FenceBlock && state.getMaterial() == this.material;
	    	  boolean flag1 = state.getBlock() instanceof FenceGateBlock && FenceGateBlock.isParallel(state, face);
	    	  return !cannotAttach(state.getBlock()) && checkattach || flag || flag1;
   		}
   		<#elseif data.blockBase?has_content && data.blockBase == "Wall">
		private boolean func_220113_a(BlockState state, boolean checkattach, Direction face) {
	    	  boolean flag = state.getBlock() instanceof WallBlock || state.getBlock() instanceof FenceGateBlock && FenceGateBlock.isParallel(state, face);
	    	  return !cannotAttach(state.getBlock()) && checkattach || flag;
   		}

	   	@Override ${mcc.getMethod("net.minecraft.block.WallBlock", "getStateForPlacement", "BlockItemUseContext")}

	   	@Override ${mcc.getMethod("net.minecraft.block.WallBlock", "updatePostPlacement", "BlockState", "Direction", "BlockState", "IWorld", "BlockPos", "BlockPos")}
		</#if>

	<#if data.blockBase?has_content && data.blockBase == "Stairs">
   	@Override public float getExplosionResistance() {
		return ${data.resistance}f;
   	}

   	@Override public boolean ticksRandomly(BlockState state) {
		return ${data.tickRandomly?c};
   	}
	</#if>

	<@addSpecialInformation data.specialInformation, true/>

	@OnlyIn(Dist.CLIENT) @Override public BlockRenderLayer getRenderLayer() {
	<#if data.transparencyType != "SOLID">
		return BlockRenderLayer.${data.transparencyType};
	<#elseif data.hasTransparency> <#-- for cases when user selected SOLID but checked transparency -->
		return BlockRenderLayer.CUTOUT;
	<#else>
		return BlockRenderLayer.SOLID;
	</#if>
	}

	<#if data.emissiveRendering>
	@OnlyIn(Dist.CLIENT) @Override public int getPackedLightmapCoords(BlockState state, IEnviromentBlockReader worldIn, BlockPos pos) {
		return 15728880;
	}
	</#if>

	<#if data.beaconColorModifier?has_content>
	@Override public float[] getBeaconColorMultiplier(BlockState state, IWorldReader world, BlockPos pos, BlockPos beaconPos) {
		return new float[] { ${data.beaconColorModifier.getRed()/255}f, ${data.beaconColorModifier.getGreen()/255}f, ${data.beaconColorModifier.getBlue()/255}f };
	}
	</#if>

	<#if data.hasTransparency>
  	@Override public boolean isNormalCube(BlockState state, IBlockReader worldIn, BlockPos pos) {
		return false;
	}
	</#if>

	<#if data.connectedSides>
	@Override public boolean isSideInvisible(BlockState state, BlockState adjacentBlockState, Direction side) {
		return adjacentBlockState.getBlock() == this ? true : super.isSideInvisible(state, adjacentBlockState, side);
	}
	</#if>

	<#if (!data.blockBase?has_content || data.blockBase == "Leaves") && data.lightOpacity == 0>
	@Override public boolean propagatesSkylightDown(BlockState state, IBlockReader reader, BlockPos pos) {
		return <#if data.isWaterloggable>state.getFluidState().isEmpty()<#else>true</#if>;
	}
	</#if>

	<#if !data.blockBase?has_content || data.blockBase == "Leaves" || data.lightOpacity != 0>
	@Override public int getOpacity(BlockState state, IBlockReader worldIn, BlockPos pos) {
		return ${data.lightOpacity};
	}
	</#if>

	<#if data.hasTransparency && !data.blockBase?has_content>
	@Override public VoxelShape getRaytraceShape(BlockState state, IBlockReader world, BlockPos pos) {
		return VoxelShapes.empty();
	}
	</#if>

	<#if data.boundingBoxes?? && !data.blockBase?? && !data.isFullCube()>
	@Override public VoxelShape getShape(BlockState state, IBlockReader world, BlockPos pos, ISelectionContext context) {
		<#if data.isBoundingBoxEmpty()>
			return VoxelShapes.empty();
		<#else>
			<#if !data.shouldDisableOffset()>Vec3d offset = state.getOffset(world, pos);</#if>
			<@boundingBoxWithRotation data.positiveBoundingBoxes() data.negativeBoundingBoxes() data.shouldDisableOffset() data.rotationMode data.enablePitch/>
		</#if>
	}
	</#if>

	<#if data.rotationMode != 0 || data.isWaterloggable || data.customProperties?has_content>
	@Override protected void fillStateContainer(StateContainer.Builder<Block, BlockState> builder) {
		super.fillStateContainer(builder);
		<#assign props = []>
		<#if data.rotationMode == 5>
			<#assign props += ["AXIS"]>
		<#elseif data.rotationMode != 0>
			<#assign props += ["FACING"]>
			<#if (data.rotationMode == 1 || data.rotationMode == 3) && data.enablePitch>
				<#assign props += ["FACE"]>
			</#if>
		</#if>
		<#list data.customProperties as prop>
			<#assign props += [prop.property().getName().replace("CUSTOM:", "")?upper_case]>
		</#list>
		<#if data.isWaterloggable>
			<#assign props += ["WATERLOGGED"]>
		</#if>
		builder.add(${props?join(", ")});
	}

	@Override
	public BlockState getStateForPlacement(BlockItemUseContext context) {
		<#if data.isWaterloggable>
		boolean flag = context.getWorld().getFluidState(context.getPos()).getFluid() == Fluids.WATER;
		</#if>
		<#if data.rotationMode != 3>
		return super.getStateForPlacement(context)
			<#if data.rotationMode == 1>
			    <#if data.enablePitch>
			    .with(FACE, faceForDirection(context.getNearestLookingDirection()))
			    </#if>
			.with(FACING, context.getPlacementHorizontalFacing().getOpposite())
			<#elseif data.rotationMode == 2>
			.with(FACING, context.getNearestLookingDirection().getOpposite())
			<#elseif data.rotationMode == 4>
			.with(FACING, context.getFace())
			<#elseif data.rotationMode == 5>
			.with(AXIS, context.getFace().getAxis())
			</#if>
	    		<@initCustomBlockStateProperties />
			<#if data.isWaterloggable>
			.with(WATERLOGGED, flag)
			</#if>;
		<#elseif data.rotationMode == 3>
	    if (context.getFace().getAxis() == Direction.Axis.Y)
	        return super.getStateForPlacement(context)
	    		<#if data.enablePitch>
	    		    .with(FACE, context.getFace().getOpposite() == Direction.UP ? AttachFace.CEILING : AttachFace.FLOOR)
	    		    .with(FACING, context.getPlacementHorizontalFacing())
	    		<#else>
	    		    .with(FACING, Direction.NORTH)
	    		</#if>
	    		<@initCustomBlockStateProperties />
	    		<#if data.isWaterloggable>
	    		.with(WATERLOGGED, flag)
	    		</#if>;

	    return super.getStateForPlacement(context)
	    	<#if data.enablePitch>
	    	    .with(FACE, AttachFace.WALL)
	    	</#if>
	    	.with(FACING, context.getFace())
	    	<@initCustomBlockStateProperties />
	    	<#if data.isWaterloggable>
	    	.with(WATERLOGGED, flag)
	    	</#if>;
		</#if>
	}
	</#if>

	<#macro initCustomBlockStateProperties>
		<#list data.customProperties as prop>
			<#assign propName = prop.property().getName().replace("CUSTOM:", "")>
			.with(${propName?upper_case},
				<#if prop.property().getClass().getSimpleName().equals("StringType")>
				${StringUtils.snakeToCamel(propName)}Property.${prop.value()?upper_case}
				<#else>
				${prop.value()}
				</#if>
			)
		</#list>
	</#macro>

	<#if data.rotationMode != 0>
		<#if data.rotationMode != 5>
		public BlockState rotate(BlockState state, Rotation rot) {
			return state.with(FACING, rot.rotate(state.get(FACING)));
		}

		public BlockState mirror(BlockState state, Mirror mirrorIn) {
			return state.rotate(mirrorIn.toRotation(state.get(FACING)));
		}
		<#else>
		@Override public BlockState rotate(BlockState state, Rotation rot) {
			if(rot == Rotation.CLOCKWISE_90 || rot == Rotation.COUNTERCLOCKWISE_90) {
				if (state.get(AXIS) == Direction.Axis.X) {
					return state.with(AXIS, Direction.Axis.Z);
				} else if (state.get(AXIS) == Direction.Axis.Z) {
					return state.with(AXIS, Direction.Axis.X);
				}
			}
			return state;
		}
		</#if>

		<#if data.rotationMode == 1 && data.enablePitch>
		private AttachFace faceForDirection(Direction direction) {
			if (direction.getAxis() == Direction.Axis.Y)
				return direction == Direction.UP ? AttachFace.CEILING : AttachFace.FLOOR;
			else
				return AttachFace.WALL;
		}
		</#if>
	</#if>

	<#if hasProcedure(data.placingCondition)>
	@Override public boolean isValidPosition(BlockState blockstate, IWorldReader worldIn, BlockPos pos) {
		if (worldIn instanceof IWorld) {
			World world = worldIn.getDimension().getWorld();
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			return <@procedureOBJToConditionCode data.placingCondition/>;
		}
		return super.isValidPosition(blockstate, worldIn, pos);
	}
	</#if>

	<#if data.isWaterloggable>
	@Override public IFluidState getFluidState(BlockState state) {
	    return state.get(WATERLOGGED) ? Fluids.WATER.getStillFluidState(false) : super.getFluidState(state);
	}
	</#if>

	<#if data.isWaterloggable || hasProcedure(data.placingCondition)>
	@Override public BlockState updatePostPlacement(BlockState state, Direction facing, BlockState facingState, IWorld world, BlockPos currentPos, BlockPos facingPos) {
	    <#if data.isWaterloggable>
		if (state.get(WATERLOGGED)) {
			world.getPendingFluidTicks().scheduleTick(currentPos, Fluids.WATER, Fluids.WATER.getTickRate(world));
		}
		</#if>
		return <#if hasProcedure(data.placingCondition)>
		!state.isValidPosition(world, currentPos) ? Blocks.AIR.getDefaultState() :
		</#if> super.updatePostPlacement(state, facing, facingState, world, currentPos, facingPos);
	}
	</#if>

	<#if data.enchantPowerBonus != 0>
	@Override public float getEnchantPowerBonus(BlockState state, IWorldReader world, BlockPos pos) {
		return ${data.enchantPowerBonus}f;
	}
	</#if>

	<#if data.isReplaceable>
	@Override public boolean isReplaceable(BlockState state, BlockItemUseContext context) {
		return context.getItem().getItem() != this.asItem();
	}
	</#if>

	<#if data.canProvidePower && data.emittedRedstonePower??>
	@Override public boolean canProvidePower(BlockState state) {
		return true;
	}

	@Override public int getWeakPower(BlockState blockstate, IBlockReader blockAccess, BlockPos pos, Direction direction) {
		<#if hasProcedure(data.emittedRedstonePower)>
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			World world = (World) blockAccess;
			return (int) <@procedureOBJToNumberCode data.emittedRedstonePower/>;
		<#else>
			return ${data.emittedRedstonePower.getFixedValue()};
		</#if>
	}
	</#if>

	<#if data.flammability != 0>
	@Override public int getFlammability(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.flammability};
	}
	</#if>

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

	<#if generator.map(data.colorOnMap, "mapcolors") != "DEFAULT">
	@Override public MaterialColor getMaterialColor(BlockState state, IBlockReader blockAccess, BlockPos pos) {
		return MaterialColor.${generator.map(data.colorOnMap, "mapcolors")};
	    	}
	</#if>

	<#if generator.map(data.aiPathNodeType, "pathnodetypes") != "DEFAULT">
	@Override public PathNodeType getAiPathNodeType(BlockState state, IBlockReader world, BlockPos pos, MobEntity entity) {
		return PathNodeType.${generator.map(data.aiPathNodeType, "pathnodetypes")};
	}
	</#if>

	<#if data.offsetType != "NONE">
	@Override public Block.OffsetType getOffsetType() {
		return Block.OffsetType.${data.offsetType};
	}
	</#if>

	<#if data.plantsGrowOn>
	@Override public boolean canSustainPlant(BlockState state, IBlockReader world, BlockPos pos, Direction direction, IPlantable plantable) {
		return true;
	}
	</#if>

	<#if data.isLadder>
	@Override public boolean isLadder(BlockState state, IWorldReader world, BlockPos pos, LivingEntity entity) {
		return true;
	}
	</#if>

	<#if data.reactionToPushing != "NORMAL">
	@Override public PushReaction getPushReaction(BlockState state) {
		return PushReaction.${data.reactionToPushing};
	}
	</#if>

	<#if data.canRedstoneConnect>
	@Override public boolean canConnectRedstone(BlockState state, IBlockReader world, BlockPos pos, Direction side) {
		return true;
	}
	</#if>

	<#if hasProcedure(data.additionalHarvestCondition)>
	@Override public boolean canHarvestBlock(BlockState state, IBlockReader world, BlockPos pos, PlayerEntity player) {
		return super.canHarvestBlock(state, world, pos, player) && <@procedureCode data.additionalHarvestCondition, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"entity": "player",
			"world": "player.world",
			"blockstate": "state"
		}, false/>;
	}
	</#if>

	<@onBlockAdded data.onBlockAdded, hasProcedure(data.onTickUpdate) && data.shouldScheduleTick(), data.tickRate/>

	<@onRedstoneOrNeighborChanged data.onRedstoneOn, data.onRedstoneOff, data.onNeighbourBlockChanges/>

	<#if hasProcedure(data.onTickUpdate)>
	@Override public void <#if data.tickRandomly && (data.blockBase?has_content && data.blockBase == "Stairs")>randomTick<#else>tick</#if>
			(BlockState blockstate, World world, BlockPos pos, Random random) {
		super.<#if data.tickRandomly && (data.blockBase?has_content && data.blockBase == "Stairs")>randomTick<#else>tick</#if>(blockstate, world, pos, random);
		int x = pos.getX();
		int y = pos.getY();
		int z = pos.getZ();

		<@procedureOBJToCode data.onTickUpdate/>

		<#if data.shouldScheduleTick()>
		world.getPendingBlockTicks().scheduleTick(pos, this, ${data.tickRate});
		</#if>
	}
	</#if>

	<#if hasProcedure(data.onRandomUpdateEvent)>
	@OnlyIn(Dist.CLIENT) @Override public void animateTick(BlockState blockstate, World world, BlockPos pos, Random random) {
		super.animateTick(blockstate, world, pos, random);
		PlayerEntity entity = Minecraft.getInstance().player;
		int x = pos.getX();
		int y = pos.getY();
		int z = pos.getZ();
		<@procedureOBJToCode data.onRandomUpdateEvent/>
	}
	</#if>

	<@onDestroyedByPlayer data.onDestroyedByPlayer/>

	<@onDestroyedByExplosion data.onDestroyedByExplosion/>

	<@onStartToDestroy data.onStartToDestroy/>

	<@onEntityCollides data.onEntityCollides/>

	<@onEntityWalksOn data.onEntityWalksOn/>

	<@onHitByProjectile data.onHitByProjectile/>

	<@onBlockPlacedBy data.onBlockPlayedBy/>

	<#if hasProcedure(data.onRightClicked) || data.shouldOpenGUIOnRightClick()>
	@Override public boolean onBlockActivated(BlockState blockstate, World world, BlockPos pos, PlayerEntity entity, Hand hand, BlockRayTraceResult hit) {
		<#if data.shouldOpenGUIOnRightClick()>
		if(entity instanceof ServerPlayerEntity) {
			NetworkHooks.openGui((ServerPlayerEntity) entity, new INamedContainerProvider() {
				@Override public ITextComponent getDisplayName() {
					return new StringTextComponent("${data.name}");
				}
				@Override public Container createMenu(int id, PlayerInventory inventory, PlayerEntity player) {
					return new ${data.guiBoundTo}Menu(id, inventory, new PacketBuffer(Unpooled.buffer()).writeBlockPos(pos));
				}
			}, pos);
		}
		</#if>

		<#if hasProcedure(data.onRightClicked)>
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			double hitX = hit.getHitVec().x;
			double hitY = hit.getHitVec().y;
			double hitZ = hit.getHitVec().z;
			Direction direction = hit.getFace();
			<#if hasReturnValueOf(data.onRightClicked, "actionresulttype")>
			ActionResultType result = <@procedureOBJToInteractionResultCode data.onRightClicked/>;
			<#else>
			<@procedureOBJToCode data.onRightClicked/>
			</#if>
		</#if>

		<#if data.shouldOpenGUIOnRightClick() || !hasReturnValueOf(data.onRightClicked, "actionresulttype")>
		return true;
		<#else>
		return result != ActionResultType.FAIL;
		</#if>
	}
	</#if>

	<#if data.isBonemealable>
	<@bonemealEvents data.isBonemealTargetCondition, data.bonemealSuccessCondition, data.onBonemealSuccess/>
	</#if>

	<#if data.hasInventory>
		@Override public INamedContainerProvider getContainer(BlockState state, World worldIn, BlockPos pos) {
			TileEntity tileEntity = worldIn.getTileEntity(pos);
			return tileEntity instanceof INamedContainerProvider ? (INamedContainerProvider) tileEntity : null;
		}

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

	    <#if data.inventoryDropWhenDestroyed>
		@Override public void onReplaced(BlockState state, World world, BlockPos pos, BlockState newState, boolean isMoving) {
			if (state.getBlock() != newState.getBlock()) {
				TileEntity blockEntity = world.getTileEntity(pos);
				if (blockEntity instanceof ${name}BlockEntity) {
					InventoryHelper.dropInventoryItems(world, pos, (${name}BlockEntity) blockEntity);
					world.updateComparatorOutputLevel(pos, this);
				}

				super.onReplaced(state, world, pos, newState, isMoving);
			}
		}
	    </#if>

	    <#if data.inventoryComparatorPower>
	    @Override public boolean hasComparatorInputOverride(BlockState state) {
			return true;
		}

	    @Override public int getComparatorInputOverride(BlockState blockState, World world, BlockPos pos) {
			TileEntity tileentity = world.getTileEntity(pos);
			if (tileentity instanceof ${name}BlockEntity)
				return Container.calcRedstoneFromInventory((${name}BlockEntity) tileentity);
			else
				return 0;
		}
	    </#if>
	</#if>

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
	<#list data.customProperties as prop>
		<#if prop.property().getClass().getSimpleName().equals("StringType")>
		<#assign propClassName = StringUtils.snakeToCamel(prop.property().getName().replace("CUSTOM:", ""))>
		private enum ${propClassName}Property implements IStringSerializable {
			<#list prop.property.getArrayData() as value>
			${value?upper_case}("${value}")<#sep>,
			</#list>;
			private final String name;
			private ${propClassName}Property(String name) {
				this.name = name;
			}
			@Override public String getName() {
				return this.name;
			}
		}
		</#if>
	</#list>
}
</#compress>
<#-- @formatter:on -->
