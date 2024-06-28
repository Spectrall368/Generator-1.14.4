<#include "mcitems.ftl">
ImmutableList.of(<#list field_list$block as block>${mappedBlockToBlockStateCode(w.itemBlock(block))}<#sep>,</#list>)
