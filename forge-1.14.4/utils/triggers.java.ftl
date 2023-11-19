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
