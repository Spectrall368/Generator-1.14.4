<#include "procedures.java.ftl">

<#-- Item-related triggers -->
<#macro addSpecialInformation procedure="" isBlock=false>
	<#if procedure?has_content>
		@Override public void addInformation(ItemStack itemstack, <#if isBlock>IBlockReader<#else>World</#if> world, List<ITextComponent> list, ITooltipFlag flag) {
		super.addInformation(itemstack, world, list, flag);
		<#list procedure as entry>
		list.add(new StringTextComponent("${JavaConventions.escapeStringForJava(entry)}"));
		</#list>
		}
	</#if>
</#macro>

<#macro onEntitySwing procedure="">
<#if hasProcedure(procedure)>
@Override public boolean onEntitySwing(ItemStack itemstack, LivingEntity entity) {
	boolean retval = super.onEntitySwing(itemstack, entity);
	<@procedureCode procedure, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "entity.world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
	return retval;
}
</#if>
</#macro>

<#macro onCrafted procedure="">
<#if hasProcedure(procedure)>
@Override public void onCreated(ItemStack itemstack, World world, PlayerEntity entity) {
	super.onCreated(itemstack, world, entity);
	<@procedureCode data.onCrafted, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
}
</#if>
</#macro>

<#macro onStoppedUsing procedure="">
<#if hasProcedure(procedure)>
@Override public void onPlayerStoppedUsing(ItemStack itemstack, World world, LivingEntity entity, int time) {
	<@procedureCode data.onStoppedUsing, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "world",
		"entity": "entity",
		"itemstack": "itemstack",
		"time": "time"
	}/>
}
</#if>
</#macro>

<#macro onEntityHitWith procedure="" hurtStack=false>
<#if hasProcedure(procedure) || hurtStack>
@Override public boolean hitEntity(ItemStack itemstack, LivingEntity entity, LivingEntity sourceentity) {
	<#if hurtStack>
		itemstack.hurtAndBreak(2, entity, i -> i.broadcastBreakEvent(EquipmentSlotType.MAINHAND));
	<#else>
		boolean retval = super.hitEntity(itemstack, entity, sourceentity);
	</#if>
	<#if hasProcedure(procedure)>
		<@procedureCode procedure, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "entity.world",
			"entity": "entity",
			"sourceentity": "sourceentity",
			"itemstack": "itemstack"
		}/>
	</#if>
	return <#if hurtStack>true<#else>retval</#if>;
}
</#if>
</#macro>

<#macro onBlockDestroyedWith procedure="" hurtStack=false>
<#if hasProcedure(procedure) || hurtStack>
@Override public boolean onBlockDestroyed(ItemStack itemstack, World world, BlockState blockstate, BlockPos pos, LivingEntity entity) {
	<#if hurtStack>
		itemstack.hurtAndBreak(1, entity, i -> i.broadcastBreakEvent(EquipmentSlotType.MAINHAND));
	<#else>
		boolean retval = super.onBlockDestroyed(itemstack,world,blockstate,pos,entity);
	</#if>
	<#if hasProcedure(procedure)>
		<@procedureCode procedure, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"blockstate": "blockstate"
		}/>
	</#if>
	return <#if hurtStack>true<#else>retval</#if>;
}
</#if>
</#macro>

<#macro onRightClickedInAir procedure="">
<#if hasProcedure(procedure)>
@Override public ActionResult<ItemStack> onItemRightClick(World world, PlayerEntity entity, Hand hand) {
	ActionResult<ItemStack> ar = super.onItemRightClick(world, entity, hand);
	<@procedureCode procedure, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "world",
		"entity": "entity",
		"itemstack": "ar.getResult()"
	}/>
	return ar;
}
</#if>
</#macro>

<#macro onItemTick inUseProcedure="" inInvProcedure="">
<#if hasProcedure(inUseProcedure) || hasProcedure(inInvProcedure)>
@Override public void inventoryTick(ItemStack itemstack, World world, Entity entity, int slot, boolean selected) {
	super.inventoryTick(itemstack, world, entity, slot, selected);
	<#if hasProcedure(inUseProcedure)>
	if (selected)
		<@procedureCode inUseProcedure, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"slot": "slot"
		}/>
	</#if>
	<#if hasProcedure(inInvProcedure)>
		<@procedureCode inInvProcedure, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"slot": "slot"
		}/>
	</#if>
}
</#if>
</#macro>

<#macro onDroppedByPlayer procedure="">
<#if hasProcedure(procedure)>
@Override public boolean onDroppedByPlayer(ItemStack itemstack, PlayerEntity entity) {
	<@procedureCode procedure, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "entity.world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
	return true;
}
</#if>
</#macro>

<#macro onItemUsedOnBlock procedure="">
<#if hasProcedure(procedure)>
@Override public ActionResultType onItemUseFirst(ItemStack stack, ItemUseContext context) {
	super.onItemUseFirst(stack, context);
	<@procedureCodeWithOptResult procedure, "actionresulttype", "ActionResultType.SUCCESS", {
		"world": "context.getWorld()",
		"x": "context.getPos().getX()",
		"y": "context.getPos().getY()",
		"z": "context.getPos().getZ()",
		"blockstate": "world.getBlockState(context.getPos())",
		"pos": "context.getPos()",
		"entity": "context.getPlayer()",
		"direction": "context.getFace()",
		"itemstack": "context.getItem()"
	}/>
}
</#if>
</#macro>

<#macro hasGlow procedure="">
@Override @OnlyIn(Dist.CLIENT) public boolean hasEffect(ItemStack itemstack) {
	<#if hasProcedure(procedure)>
	<#assign dependencies = procedure.getDependencies(generator.getWorkspace())>
	<#if !(dependencies.isEmpty() || (dependencies.size() == 1 && dependencies.get(0).getName() == "itemstack"))>
	Entity entity = Minecraft.getInstance().player;
	</#if>
	return <@procedureCode procedure, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"entity": "entity",
		"world": "entity.world",
		"itemstack": "itemstack"
	}/>
	<#else>
	return true;
	</#if>
}
</#macro>

<#-- Armor triggers -->
<#macro onArmorTick procedure="">
	<#if hasProcedure(procedure)>
@Override public void onArmorTick(ItemStack itemstack, World world, PlayerEntity entity) {
	<@procedureCode procedure, {
	"x": "entity.posX",
	"y": "entity.posY",
	"z": "entity.posZ",
	"world": "world",
	"entity": "entity",
	"itemstack": "itemstack"
	}/>
			}
	</#if>
</#macro>
