<#function mappedBlockToBlockStateCode mappedBlock>
    <#if mappedBlock?starts_with("/*@BlockState*/")>
        <#return mappedBlock?replace("/*@BlockState*/","")>
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedBlockToBlockStateCode(outputs?keep_before("/*@:*/"))
            + ":" + mappedBlockToBlockStateCode(outputs?keep_after("/*@:*/")) + ")">
    <#else>
        <#return mappedBlockToBlock(mappedBlock) + ".getDefaultState()">
    </#if>
</#function>

<#function mappedBlockToBlock mappedBlock>
    <#if mappedBlock?starts_with("/*@BlockState*/")>
        <#return mappedBlock?replace("/*@BlockState*/","") + ".getBlock()">
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedBlockToBlock(outputs?keep_before("/*@:*/"))
            + ":" + mappedBlockToBlock(outputs?keep_after("/*@:*/")) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return mappedElementToRegistryEntry(mappedBlock)>
    <#else>
        <#return mappedBlock>
    </#if>
</#function>

<#function mappedMCItemToItemStackCode mappedBlock amount=1>
    <#if mappedBlock?starts_with("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "")>
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedMCItemToItemStackCode(outputs?keep_before("/*@:*/"), amount)
            + ":" + mappedMCItemToItemStackCode(outputs?keep_after("/*@:*/"), amount) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return toItemStack(mappedElementToRegistryEntry(mappedBlock), amount)>
    <#else>
        <#return toItemStack(mappedBlock, amount)>
    </#if>
</#function>

<#function toItemStack item amount>
    <#if amount == 1>
        <#return "new ItemStack(" + item + ")">
    <#else>
        <#return "new ItemStack(" + item + "," + (amount == amount?floor)?then(amount + ")","(int)(" + amount + "))")>
    </#if>
</#function>

<#function mappedMCItemToItem mappedBlock>
    <#if mappedBlock?starts_with("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "") + ".getItem()">
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedMCItemToItem(outputs?keep_before("/*@:*/"))
            + ":" + mappedMCItemToItem(outputs?keep_after("/*@:*/")) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return mappedElementToRegistryEntry(mappedBlock) + generator.isBlock(mappedBlock)?then(".asItem()", "")>
    <#else>
        <#return mappedBlock + mappedBlock?contains("Blocks.")?then(".asItem()","")>
    </#if>
</#function>

<#function mappedMCItemToIngredient mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "Ingredient.fromTag(ItemTags.getCollection().getOrCreate(new ResourceLocation(\"" + mappedBlock.getUnmappedValue().replace("TAG:", "") + "\")))">
    <#elseif mappedBlock.getMappedValue(1).startsWith("#")>
        <#return "Ingredient.fromTag(ItemTags.getCollection().getOrCreate(new ResourceLocation(\"" + mappedBlock.getMappedValue(1).replace("#", "") + "\")))">
    <#else>
        <#return "Ingredient.fromStacks(" + mappedMCItemToItemStackCode(mappedBlock, 1) + ")">
    </#if>
</#function>

<#function mappedMCItemsToIngredient mappedBlocks=[]>
    <#if !mappedBlocks??>
        <#return "Ingredient.EMPTY">
    <#elseif mappedBlocks?size == 1>
        <#return mappedMCItemToIngredient(mappedBlocks[0])>
    <#else>
        <#assign itemsOnly = true>

        <#list mappedBlocks as mappedBlock>
            <#if mappedBlock.getUnmappedValue().startsWith("TAG:") || mappedBlock.getMappedValue(1).startsWith("#")>
                <#assign itemsOnly = false>
                <#break>
            </#if>
        </#list>

        <#if itemsOnly>
            <#assign retval = "Ingredient.fromStacks(">
            <#list mappedBlocks as mappedBlock>
                <#assign retval += mappedMCItemToItemStackCode(mappedBlock, 1)>

                <#if mappedBlock?has_next>
                    <#assign retval += ",">
                </#if>
            </#list>
            <#return retval + ")">
        <#else>
            <#assign retval = "Ingredient.merge(Arrays.asList(">
            <#list mappedBlocks as mappedBlock>
                <#assign retval += mappedMCItemToIngredient(mappedBlock)>

                <#if mappedBlock?has_next>
                    <#assign retval += ",">
                </#if>
            </#list>
            <#return retval + "))">
        </#if>
    </#if>
</#function>

<#function mappedElementToRegistryEntry mappedElement>
    <#return JavaModName + generator.isBlock(mappedElement)?then("Blocks", "Items") + "."
    + generator.getRegistryNameFromFullName(mappedElement)?upper_case + transformExtension(mappedElement)?upper_case + ".get()">
</#function>

<#function transformExtension mappedBlock>
    <#assign extension = mappedBlock?keep_after_last(".")?replace("body", "chestplate")?replace("legs", "leggings")>
    <#return (extension?has_content)?then("_" + extension, "")>
</#function>

<#function mappedMCItemToItemObjectJSON mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign customelement = generator.getRegistryNameFromFullName(mappedBlock.getUnmappedValue())!""/>
        <#if customelement?has_content>
            <#return "\"item\": \"" + "${modid}:" + customelement
            + transformExtension(mappedBlock)
            + "\"">
        <#else>
            <#return "\"item\": \"minecraft:air\"">
        </#if>
    <#elseif mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "\"tag\": \"" + mappedBlock.getUnmappedValue().replace("TAG:", "")?lower_case + "\"">
    <#else>
        <#assign mapped = mappedBlock.getMappedValue(1) />
        <#if mapped.startsWith("#")>
            <#return "\"tag\": \"" + mapped.replace("#", "") + "\"">
        <#elseif mapped.contains(":")>
            <#return "\"item\": \"" + mapped + "\"">
        <#else>
            <#return "\"item\": \"minecraft:" + mapped + "\"">
        </#if>
    </#if>
</#function>

<#function mappedMCItemToRegistryName mappedBlock acceptTags=false>
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign customelement = generator.getRegistryNameFromFullName(mappedBlock.getUnmappedValue())!""/>
        <#if customelement?has_content>
            <#return "${modid}:" + customelement + transformExtension(mappedBlock)>
        <#else>
            <#return "minecraft:air">
        </#if>
    <#elseif mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#if acceptTags>
            <#return "#" + mappedBlock.getUnmappedValue().replace("TAG:", "")?lower_case>
        <#else>
            <#return "minecraft:air">
        </#if>
    <#else>
        <#assign mapped = mappedBlock.getMappedValue(1) />
        <#if mapped.startsWith("#")>
            <#if acceptTags>
                <#return mapped>
            <#else>
                <#return "minecraft:air">
            </#if>
        <#elseif mapped.contains(":")>
            <#return mapped>
        <#else>
            <#return "minecraft:" + mapped>
        </#if>
    </#if>
</#function>
