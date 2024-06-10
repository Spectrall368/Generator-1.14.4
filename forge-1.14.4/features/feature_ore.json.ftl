<#assign chance = (field$discardOnAirChance?number * 64)?round>
new OreFeatureConfig(OreFeatureConfig.FillerBlockType.create("${registryname}", "${registryname}", blockAt -> {
boolean blockCriteria = false;
<#list input_list$target as target>
if(${target?keep_after("Target(")?keep_before("), State")})
  blockCriteria = true;
</#list>
return blockCriteria;
<#assign firstNonBlockAtTarget = "?">
<#list input_list$target as target>
    <#if !target?contains("blockAt")>
        <#-- Questo è il primo valore che non contiene "blockAt" -->
        <#assign firstNonBlockAtTarget = target>
        <#break>
    </#if>
</#list>
}), <#if firstNonBlockAtTarget != "?">${target?keep_after("State(")?keep_before_last(")")}<#else>Blocks.AIR.getDefaultState()</#if>, ${field$size}) ${chance}
