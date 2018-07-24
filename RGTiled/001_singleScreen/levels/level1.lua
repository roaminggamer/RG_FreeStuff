return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "2018.06.01",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 12,
  height = 8,
  tilewidth = 80,
  tileheight = 80,
  nextlayerid = 9,
  nextobjectid = 1060,
  properties = {},
  tilesets = {
    {
      name = "basic",
      firstgid = 1,
      filename = "basic.tsx",
      tilewidth = 80,
      tileheight = 80,
      spacing = 0,
      margin = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 7,
      tiles = {
        {
          id = 0,
          properties = {
            ["bounce"] = 0,
            ["friction"] = 1,
            ["hasBody"] = true,
            ["isSensor"] = false
          },
          image = "tiles/block.png",
          width = 80,
          height = 80
        },
        {
          id = 1,
          properties = {
            ["bodyType"] = "kinematic",
            ["bounce"] = 0,
            ["friction"] = 0,
            ["hasBody"] = true,
            ["isSensor"] = true,
            ["radius"] = 20
          },
          image = "tiles/coin1.png",
          width = 40,
          height = 40
        },
        {
          id = 2,
          properties = {
            ["bodyType"] = "kinematic",
            ["bounce"] = 0,
            ["friction"] = 0,
            ["hasBody"] = true,
            ["isSensor"] = true,
            ["radius"] = 20
          },
          image = "tiles/coin2.png",
          width = 40,
          height = 40
        },
        {
          id = 3,
          properties = {
            ["bodyType"] = "kinematic",
            ["bounce"] = 0,
            ["friction"] = 0,
            ["hasBody"] = true,
            ["isSensor"] = false,
            ["radius"] = 20
          },
          image = "tiles/enemy.png",
          width = 40,
          height = 40
        },
        {
          id = 4,
          properties = {
            ["bodyType"] = "kinematic",
            ["bounce"] = 0,
            ["friction"] = 0,
            ["hasBody"] = true,
            ["isSensor"] = true
          },
          image = "tiles/gate.png",
          width = 80,
          height = 80
        },
        {
          id = 5,
          properties = {
            ["bodyType"] = "dynamic",
            ["bounce"] = 0.2,
            ["friction"] = 0,
            ["hasBody"] = true,
            ["isSensor"] = false,
            ["radius"] = 20
          },
          image = "tiles/player.png",
          width = 40,
          height = 40
        },
        {
          id = 6,
          properties = {
            ["hasBody"] = true
          },
          image = "tiles/spikes.png",
          width = 80,
          height = 44,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {},
            objects = {
              {
                id = 2,
                name = "",
                type = "",
                shape = "polygon",
                x = 5.45455,
                y = 40,
                width = 0,
                height = 0,
                rotation = 0,
                visible = true,
                polygon = {
                  { x = 0.363636, y = 0.727273 },
                  { x = 10.5455, y = -34.5455 },
                  { x = 58.9091, y = -34.3636 },
                  { x = 69.6364, y = 0.727273 }
                },
                properties = {}
              }
            }
          }
        }
      }
    },
    {
      name = "proto",
      firstgid = 8,
      filename = "proto.tsx",
      tilewidth = 40,
      tileheight = 40,
      spacing = 0,
      margin = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 34,
      tiles = {
        {
          id = 0,
          image = "proto/player.png",
          width = 40,
          height = 40
        },
        {
          id = 1,
          image = "proto/projectile.png",
          width = 40,
          height = 40
        },
        {
          id = 2,
          image = "proto/shot0.png",
          width = 40,
          height = 40
        },
        {
          id = 3,
          image = "proto/shot1.png",
          width = 40,
          height = 40
        },
        {
          id = 4,
          image = "proto/shot2.png",
          width = 40,
          height = 40
        },
        {
          id = 5,
          image = "proto/spawner.png",
          width = 40,
          height = 40
        },
        {
          id = 6,
          image = "proto/weapon.png",
          width = 40,
          height = 40
        },
        {
          id = 7,
          type = "easyInput",
          properties = {
            ["debugEn"] = false,
            ["doNorm"] = false,
            ["easyInput"] = "oneTouch",
            ["keyboardEn"] = true
          },
          image = "proto/actionMapHelper.png",
          width = 40,
          height = 40
        },
        {
          id = 8,
          image = "proto/ball.png",
          width = 40,
          height = 40
        },
        {
          id = 9,
          image = "proto/block.png",
          width = 40,
          height = 40
        },
        {
          id = 10,
          image = "proto/blockA.png",
          width = 40,
          height = 40
        },
        {
          id = 11,
          image = "proto/blockB.png",
          width = 40,
          height = 40
        },
        {
          id = 12,
          image = "proto/blockC.png",
          width = 40,
          height = 40
        },
        {
          id = 13,
          image = "proto/blockD.png",
          width = 40,
          height = 40
        },
        {
          id = 14,
          image = "proto/blockE.png",
          width = 40,
          height = 40
        },
        {
          id = 15,
          image = "proto/blockE0.png",
          width = 40,
          height = 40
        },
        {
          id = 16,
          image = "proto/blockE1.png",
          width = 40,
          height = 40
        },
        {
          id = 17,
          image = "proto/blockE2.png",
          width = 40,
          height = 40
        },
        {
          id = 18,
          image = "proto/blockE3.png",
          width = 40,
          height = 40
        },
        {
          id = 19,
          image = "proto/blockF.png",
          width = 40,
          height = 40
        },
        {
          id = 20,
          image = "proto/blockG.png",
          width = 40,
          height = 40
        },
        {
          id = 21,
          image = "proto/blockH.png",
          width = 40,
          height = 40
        },
        {
          id = 22,
          image = "proto/blockP0.png",
          width = 40,
          height = 40
        },
        {
          id = 23,
          image = "proto/blockP1.png",
          width = 40,
          height = 40
        },
        {
          id = 24,
          image = "proto/blockP2.png",
          width = 40,
          height = 40
        },
        {
          id = 25,
          image = "proto/blockP3.png",
          width = 40,
          height = 40
        },
        {
          id = 26,
          properties = {
            ["camera"] = "fixed"
          },
          image = "proto/camera.png",
          width = 40,
          height = 40
        },
        {
          id = 27,
          image = "proto/damageBlockGreen.png",
          width = 40,
          height = 40
        },
        {
          id = 28,
          image = "proto/damageBlockRed.png",
          width = 40,
          height = 40
        },
        {
          id = 29,
          image = "proto/damageBlockYellow.png",
          width = 40,
          height = 40
        },
        {
          id = 30,
          properties = {
            ["bodyType"] = "dynamic",
            ["hasBody"] = true,
            ["isEnemy"] = true
          },
          image = "proto/enemy.png",
          width = 40,
          height = 40
        },
        {
          id = 31,
          image = "proto/gamelogic.png",
          width = 40,
          height = 40
        },
        {
          id = 32,
          image = "proto/keyboard.png",
          width = 40,
          height = 40
        },
        {
          id = 33,
          image = "proto/null.png",
          width = 40,
          height = 40
        }
      }
    }
  },
  layers = {
    {
      type = "objectgroup",
      id = 7,
      name = "logic",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1042,
          name = "",
          type = "",
          shape = "rectangle",
          x = 346,
          y = 135,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 15,
          visible = true,
          properties = {
            ["debugEn"] = true,
            ["easyInput"] = "twoTouch"
          }
        }
      }
    },
    {
      type = "objectgroup",
      id = 8,
      name = "background",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {}
    },
    {
      type = "objectgroup",
      id = 4,
      name = "content",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 980,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 981,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 982,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 983,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 984,
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 985,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 986,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 987,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 988,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 989,
          name = "",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 990,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 991,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 640,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 992,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 993,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 994,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 995,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 996,
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 997,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 998,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 999,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1000,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1001,
          name = "",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1002,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1003,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 80,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1004,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 240,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1005,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 160,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1006,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 320,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1007,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 400,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1008,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 480,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1009,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 560,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1010,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1011,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 160,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1012,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 320,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1013,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 400,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1014,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 480,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1015,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 560,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1016,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 240,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1017,
          name = "",
          type = "",
          shape = "rectangle",
          x = 105,
          y = 136,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {
            ["b_onEventApplyTorque_left"] = "event=onTwoTouchLeft,torque=-100",
            ["b_onEventApplyTorque_right"] = "torque=100",
            ["bounce"] = 0.5,
            ["friction"] = 1,
            ["linearDamping"] = 0.5
          }
        },
        {
          id = 1018,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 560,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 5,
          visible = true,
          properties = {
            ["b_fillColor"] = "color = #53d5fd",
            ["b_jiggler"] = "x1 = -1\nx2 = 1\ny1 = -1\ny2 = 1\n",
            ["b_onLocalEventPost"] = "event=collision\nphase=began\npost=onLevelComplete",
            ["bodyType"] = "static"
          }
        },
        {
          id = 1031,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 240,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1032,
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 320,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1033,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 320,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1034,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 480,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1035,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 480,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1036,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 480,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1037,
          name = "",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 480,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1038,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 480,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1039,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 480,
          width = 80,
          height = 80,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1045,
          name = "",
          type = "",
          shape = "rectangle",
          x = 264,
          y = 225,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {
            ["b_coinSpinner"] = "",
            ["b_pickup"] = "type='coin',value=1"
          }
        },
        {
          id = 1053,
          name = "",
          type = "",
          shape = "rectangle",
          x = 420,
          y = 300,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {
            ["b_coinSpinner"] = "",
            ["b_pickup"] = "type='coin',value=1"
          }
        },
        {
          id = 1054,
          name = "",
          type = "",
          shape = "rectangle",
          x = 736,
          y = 379,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {
            ["b_coinSpinner"] = "",
            ["b_pickup"] = "type='coin',value=1"
          }
        },
        {
          id = 1055,
          name = "",
          type = "",
          shape = "rectangle",
          x = 338,
          y = 463,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {
            ["b_coinSpinner"] = "",
            ["b_pickup"] = "type='coin',value=1"
          }
        },
        {
          id = 1056,
          name = "",
          type = "",
          shape = "rectangle",
          x = 666,
          y = 541,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {
            ["b_coinSpinner"] = "",
            ["b_pickup"] = "type='coin',value=1"
          }
        },
        {
          id = 1057,
          name = "",
          type = "",
          shape = "rectangle",
          x = 101,
          y = 542,
          width = 40,
          height = 40,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {
            ["b_coinSpinner"] = "",
            ["b_pickup"] = "type='coin',value=1"
          }
        }
      }
    }
  }
}
