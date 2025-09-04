<#assign firstNonBlockAtTarget = "?">
<#list input_list$target as target>
    <#if !target?contains("blockAt")>
        <#assign firstNonBlockAtTarget = target>
        <#break>
    </#if>
</#list>
new ReplaceBlockConfig(<#if firstNonBlockAtTarget != "?">${target?keep_after("State(")?keep_before_last(")")}<#else>Blocks.STONE.getDefaultState()</#if>, <#if firstNonBlockAtTarget != "?">${target?keep_after("State(")?keep_before_last(")")}<#else>Blocks.AIR.getDefaultState()</#if>)
