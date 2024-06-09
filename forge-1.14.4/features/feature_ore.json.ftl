new OreFeatureConfig(OreFeatureConfig.FillerBlockType.create("${registryname}", "${registryname}", blockAt -> {
boolean blockCriteria = false;
if(${target?keep_after("Target(")?keep_before(")")}blockAt.getBlock())
  blockCriteria = true;
}), Lists.newArrayList(<#list input_list$target as target>${target?keep_after("State(")?keep_before(")")}<#sep>,</#list>), ${field$size})
