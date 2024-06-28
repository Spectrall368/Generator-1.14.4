<#include "mcitems.ftl">
ImmutableList.of(<#list field_list$block as block>${mappedBlockToBlockStateCode(toMappedMCItem(block))}<#sep>,</#list>)
