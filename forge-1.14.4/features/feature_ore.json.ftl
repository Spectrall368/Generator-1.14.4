new OreFeatureConfig(OreFeatureConfig.FillerBlockType.create("${registryname}", "${registryname}", blockAt -> {
boolean blockCriteria = false;
<#list input_list$target as target>
if(${target?keep_after("Target(")?keep_before("), State")})
  blockCriteria = true;
</#list>
return blockCriteria;
}), Lists.newArrayList(<#list input_list$target as target>${target?keep_after("State(")?keep_before_last(")")}<#sep>,</#list>), ${field$size})
