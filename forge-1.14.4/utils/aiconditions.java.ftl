<#include "procedures.java.ftl">
<#-- @formatter:off -->
<#macro conditionCode condition="" includeBraces=true>
	<#if condition?has_content>
		<#assign conditions = generator.procedureNamesToObjects(condition)>
		<#if hasProcedure(conditions[0]) || hasProcedure(conditions[1])>
			<#if includeBraces>{</#if>
				<#if hasProcedure(conditions[0])>
				@Override public boolean shouldExecute() {
					double x = ${name}Entity.this.posX;
					double y = ${name}Entity.this.posY;
					double z = ${name}Entity.this.posZ;
					Entity entity = ${name}Entity.this;
					World world = ${name}Entity.this.world;
					return super.shouldExecute() && <@procedureOBJToConditionCode conditions[0]/>;
				}
				</#if>
				<#if hasProcedure(conditions[1])>
				@Override public boolean shouldContinueExecuting() {
					double x = ${name}Entity.this.posX;
					double y = ${name}Entity.this.posY;
					double z = ${name}Entity.this.posZ;
					Entity entity = ${name}Entity.this;
					Level world = ${name}Entity.this.world;
					return super.shouldContinueExecuting() && <@procedureOBJToConditionCode conditions[0]/>;
				}
				</#if>
			<#if includeBraces>}</#if>
		</#if>
	</#if>
</#macro>
<#-- @formatter:on -->
