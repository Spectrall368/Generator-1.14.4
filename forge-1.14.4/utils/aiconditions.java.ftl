<#include "procedures.java.ftl">
<#-- @formatter:off -->
<#macro conditionCode condition="" includeBraces=true>
	<#if condition?has_content>
		<#assign conditions = generator.procedureNamesToObjects(condition)>
		<#if hasProcedure(conditions[0]) || hasProcedure(conditions[1])>
			<#if includeBraces>{</#if>
				<#if hasProcedure(conditions[0])>
				@Override public boolean shouldExecute() {
					double x = CustomEntity.this.posX;
					double y = CustomEntity.this.posY;
					double z = CustomEntity.this.posZ;
					Entity entity = CustomEntity.this;
					World world = CustomEntity.this.world;
					return super.shouldExecute() && <@procedureOBJToConditionCode conditions[0]/>;
				}
				</#if>
				<#if hasProcedure(conditions[1])>
				@Override public boolean shouldContinueExecuting() {
					double x = CustomEntity.this.posX;
					double y = CustomEntity.this.posY;
					double z = CustomEntity.this.posZ;
					Entity entity = CustomEntity.this;
					Level world = CustomEntity.this.world;
					return super.shouldContinueExecuting() && <@procedureOBJToConditionCode conditions[0]/>;
				}
				</#if>
			<#if includeBraces>}</#if>
		</#if>
	</#if>
</#macro>
<#-- @formatter:on -->
