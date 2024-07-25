{
  "multipart": [
    {
      "when": {
        "up": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}_post"
      }
    },
    {
      "when": {
        "north": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}",
        "uvlock": true
      }
    },
    {
      "when": {
        "east": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}",
        "y": 90,
        "uvlock": true
      }
    },
    {
      "when": {
        "south": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}",
        "y": 180,
        "uvlock": true
      }
    },
    {
      "when": {
        "west": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}",
        "y": 270,
        "uvlock": true
      }
    },
    {
      "when": {
        "north": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}_side_tall",
        "uvlock": true
      }
    },
    {
      "when": {
        "east": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}_side_tall",
        "y": 90,
        "uvlock": true
      }
    },
    {
      "when": {
        "south": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}_side_tall",
        "y": 180,
        "uvlock": true
      }
    },
    {
      "when": {
        "west": "true"
      },
      "apply": {
        "model": "${modid}:block/${registryname}_side_tall",
        "y": 270,
        "uvlock": true
      }
    }
  ]
}
