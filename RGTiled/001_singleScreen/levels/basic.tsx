<?xml version="1.0" encoding="UTF-8"?>
<tileset name="basic" tilewidth="80" tileheight="80" tilecount="7" columns="0">
 <grid orientation="orthogonal" width="1" height="1"/>
 <tile id="0">
  <properties>
   <property name="bounce" type="float" value="0"/>
   <property name="friction" type="float" value="1"/>
   <property name="hasBody" type="bool" value="true"/>
   <property name="isSensor" type="bool" value="false"/>
  </properties>
  <image width="80" height="80" source="tiles/block.png"/>
 </tile>
 <tile id="1">
  <properties>
   <property name="bodyType" value="kinematic"/>
   <property name="bounce" type="float" value="0"/>
   <property name="friction" type="float" value="0"/>
   <property name="hasBody" type="bool" value="true"/>
   <property name="isSensor" type="bool" value="true"/>
   <property name="radius" type="float" value="20"/>
  </properties>
  <image width="40" height="40" source="tiles/coin1.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="bodyType" value="kinematic"/>
   <property name="bounce" type="float" value="0"/>
   <property name="friction" type="float" value="0"/>
   <property name="hasBody" type="bool" value="true"/>
   <property name="isSensor" type="bool" value="true"/>
   <property name="radius" type="float" value="20"/>
  </properties>
  <image width="40" height="40" source="tiles/coin2.png"/>
 </tile>
 <tile id="3">
  <properties>
   <property name="bodyType" value="kinematic"/>
   <property name="bounce" type="float" value="0"/>
   <property name="friction" type="float" value="0"/>
   <property name="hasBody" type="bool" value="true"/>
   <property name="isSensor" type="bool" value="false"/>
   <property name="radius" type="float" value="20"/>
  </properties>
  <image width="40" height="40" source="tiles/enemy.png"/>
 </tile>
 <tile id="4">
  <properties>
   <property name="bodyType" value="kinematic"/>
   <property name="bounce" type="float" value="0"/>
   <property name="friction" type="float" value="0"/>
   <property name="hasBody" type="bool" value="true"/>
   <property name="isSensor" type="bool" value="true"/>
  </properties>
  <image width="80" height="80" source="tiles/gate.png"/>
 </tile>
 <tile id="5">
  <properties>
   <property name="bodyType" value="dynamic"/>
   <property name="bounce" type="float" value="0.2"/>
   <property name="friction" type="float" value="0"/>
   <property name="hasBody" type="bool" value="true"/>
   <property name="isSensor" type="bool" value="false"/>
   <property name="radius" type="float" value="20"/>
  </properties>
  <image width="40" height="40" source="tiles/player.png"/>
 </tile>
 <tile id="6">
  <properties>
   <property name="hasBody" type="bool" value="true"/>
  </properties>
  <image width="80" height="44" source="tiles/spikes.png"/>
  <objectgroup draworder="index">
   <object id="2" x="5.45455" y="40">
    <polygon points="0.363636,0.727273 10.5455,-34.5455 58.9091,-34.3636 69.6364,0.727273"/>
   </object>
  </objectgroup>
 </tile>
</tileset>
