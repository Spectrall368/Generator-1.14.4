{
  "parent": "forge:item/default",
  "loader": "forge:composite",
  "parts": {
    "part1": {
      "loader": "forge:obj",
      "model": "${modid}:models/item/${data.customModelName.split(":")[0]}.obj",
      "ambientToFullbright": true
      <#if data.getTextureMap()??>,
        "textures": {
        <#list data.getTextureMap().entrySet() as texture>
          "#${texture.getKey()}": "${texture.getValue().format("%s:block/%s")}"<#sep>,
        </#list>
        }
      </#if>
    }
  },
  "textures": {
    "particle": "${data.getParticleTexture().format("%s:block/%s")}"
  }
}
