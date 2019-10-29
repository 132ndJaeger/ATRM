range_10_menu_root = MENU_MISSION:New("Range 10",range_root_menu)
---BASIC AR Tasking at Range10
local function range_10()
  local timeuntilmove = 15 -- time in minutes to move the groups
  local minmovedistance =  500 --min distance they move
  local maxmovedistance =  1500 --max distance they move
  local numberofoptions = math.random(1,5)
  local numberofoptions_sam = math.random(1,2)
  local numberofoptions_sam_2 = math.random(1,2)
  local templatename = "R10_Option"..numberofoptions
  local templatename_sam = "R10_AD#"..numberofoptions.."_"..numberofoptions_sam.."_"..numberofoptions_sam_2
  -- env.info("Templatename is "..templatename.." Sam is "..templatename_sam)
  local range_10_zone = ZONE_POLYGON:New("range_10_zone",GROUP:FindByName("AR_zone_R10"))
  function range_10_SAMs()
    range_10_menu_sam_menu:Remove()
    local templatename_sam_spawner = SPAWN:New(templatename_sam):SpawnInZone(range_10_zone,true)
  end
  range_10_menu:Remove()
  range_10_menu_sam_menu = MENU_MISSION_COMMAND:New("Activate Anti Air at Range 10",range_10_menu_root,range_10_SAMs)
  range_10_template_set = SET_GROUP:New():FilterPrefixes(templatename):FilterStart()
  range_10_template_set:ForEachGroup(function(_group)
    local range_10_spawnedgroups = SPAWN:New(_group:GetName()):SpawnInZone(range_10_zone,true)
  end
  )
  -- move targets_periodically
  SCHEDULER:New(nil,function ()
    range_10_template_set:ForEachGroupAlive(function (move)
      -- Get the current coordinate of GroundGroup
      local FromCoord = move:GetCoordinate()
      -- From the current coordinate, calculate vector with an random angle.
      local ToCoord = FromCoord:Translate( math.random(minmovedistance,maxmovedistance), math.random(1,360) )
      move:RouteGroundTo(ToCoord,20,5)
    end)
  end,{},5,timeuntilmove*60,0.5)
end

range_10_menu = MENU_MISSION_COMMAND:New("Activate AR Targets at Range 10",range_10_menu_root,range_10)
---/BASIC AR Tasking at Range10




---IADS Range 10
--IADS EASY

range_10_threatsites = {
  "Threatsite_1",
  "Threatsite_2",
  "Threatsite_3",
  "Threatsite_4_mobile",
}


local function IADS_easy()
  -- range_10_IADS_easy:Remove()
  local option1 = math.random(1,4)
  local option2 = math.random(1,3)
  for i,_group in ipairs(range_10_threatsites) do
    if i == option1 then
      SPAWN:New(_group):Spawn()
      table.remove(range_10_threatsites,option1)
      for i,_group in ipairs(range_10_threatsites) do
        if i == option2 then
          SPAWN:New(_group):Spawn()
          table.remove(range_10_threatsites,option2)
        end
      end
    end
  end
end
range_10_IADS_easy = MENU_MISSION_COMMAND:New("Scenariotraing, IADS easy",range_10_menu_root,IADS_easy)
---/BASIC AR Tasking at Range10

























--BASE:HandleEvent(EVENTS.Shot)
--
--  local SEAD_enabled_Sams = SET_GROUP:New():FilterPrefixes(prefix)
--  SEAD_enabled_Sams:FilterStart()
--
--  _evadeRadars = {}  -- table that will be filled with all radar-containing units that are taking evasive action
--
--  SEAD_enabled_Sams:ForEachGroupAlive(
--    function(_group)
--      Sam_group_name = _group:GetName()
--      --env.info("Sam GROUP Name is "..Sam_group_name)
--      Sam_units = _group:GetUnits()
--      for i,_unit in ipairs(Sam_units) do
--        if
--          _unit:HasAttribute("SAM SR") or _unit:HasAttribute("SAM TR")
--        then
--          env.info("Radar detected for UNIT ".._unit:GetName())
--          table.insert(_evadeRadars,_unit:GetName())
--        else
--        end
--      end
--    end
--  )
--  if evasion_for_client_planes_only == true
--  then
--    function BASE:OnEventShot(EventData)
--      local clientplane = EventData.IniPlayerName
--      if clientplane ~= nil
--      then
--        env.info("a missile has been shot by "..clientplane)
--        local SEAD_Weapon_Name = EventData.Weapon:getTypeName()
--        if SEAD_Weapon_Name == "weapons.missiles.AGM_88" then
--          local SEAD_Target = EventData.Weapon:getTarget()
--          local SEAD_Target_Name = Unit.getName(SEAD_Target)
--          local SEAD_Target_Unit = UNIT:FindByName(SEAD_Target_Name)
--          local SEAD_Target_GROUP = SEAD_Target_Unit:GetGroup()
--          local SEAD_Shooter_Unit = EventData.IniUnit
--          local SEAD_Shooter_Name = SEAD_Shooter_Unit:GetName()
--          for _,evasive_radar in pairs(_evadeRadars) do
--            if evasive_radar == SEAD_Target_Name
--            then
--              env.info(SEAD_Shooter_Name.." has fired "..SEAD_Weapon_Name.." at "..SEAD_Target_Name)
--              env.info("AGM_88 shot detected from  "..SEAD_Shooter_Name.." on "..SEAD_Target_Name)
--              if math.random(1,100) <= chance_for_evasive_action
--              then
--                Radar_Unit_Evasive_Action(SEAD_Target_Unit)
--              end
--            end
--          end
--        end
--      end
--    end
--  else
--    function BASE:OnEventShot(EventData)
--      local SEAD_Weapon_Name = EventData.Weapon:getTypeName()
--      if SEAD_Weapon_Name == "weapons.missiles.AGM_88" then
--        local SEAD_Target = EventData.Weapon:getTarget()
--        local SEAD_Target_Name = Unit.getName(SEAD_Target)
--        local SEAD_Target_Unit = UNIT:FindByName(SEAD_Target_Name)
--        local SEAD_Target_GROUP = SEAD_Target_Unit:GetGroup()
--        local SEAD_Shooter_Unit = EventData.IniUnit
--        local SEAD_Shooter_Name = SEAD_Shooter_Unit:GetName()
--        for _,evasive_radar in pairs(_evadeRadars) do
--          if evasive_radar == SEAD_Target_Name
--          then
--            env.info(SEAD_Shooter_Name.." has fired "..SEAD_Weapon_Name.." at "..SEAD_Target_Name)
--            env.info("AGM_88 shot detected from  "..SEAD_Shooter_Name.." on "..SEAD_Target_Name)
--            if math.random(1,100) <= chance_for_evasive_action
--            then
--              Radar_Unit_Evasive_Action(SEAD_Target_Unit)
--            end
--          end
--        end
--      end
--    end
--  end
--
--  function Radar_Unit_Evasive_Action(_unit) -- define the evasive action of the SAMsite when shot at by a HARM
--    if Target_Smoke == true then
--      _unit:SmokeRed()
--  end
--  env.info("Sam waiting "..evasion_delay.."seconds before taking evasive measure")
--  SCHEDULER:New(nil,
--    function()
--      if  math.random(1,100) <= chance_for_group_relocating
--      then
--        env.info(_unit:GetName().."Air Defemse System now relocating "..relocating_distance.." meters")
--        _unit:OptionAlarmStateGreen()
--        local _groupcoordinate = _unit:GetCoordinate()
--        local _tocoordinate = _groupcoordinate:Translate( relocating_distance, math.random(359) )
--        local _ToCoord_vec2 = _tocoordinate:GetVec2()
--        _unit:TaskRouteToVec2( _ToCoord_vec2 )
--        _unit:OptionAlarmStateGreen()
--        radarbackon = SCHEDULER:New(nil,
--          function()
--            _unit:OptionAlarmStateRed()
--            env.info("radar back on")
--          end,{},radar_delay)
--      else
--        env.info(_unit:GetName().." now taking evasive action")
--        _unit:OptionAlarmStateGreen()
--        local _groupcoordinate = _unit:GetCoordinate()
--        local _tocoordinate = _groupcoordinate:Translate( move_distance, math.random(359) )
--        local _ToCoord_vec2 = _tocoordinate:GetVec2()
--        _unit:TaskRouteToVec2( _ToCoord_vec2 )
--        _unit:OptionAlarmStateGreen()
--        radarbackon = SCHEDULER:New(nil,
--          function()
--            _unit:OptionAlarmStateRed()
--            env.info("radar back on")
--          end,{},radar_delay)
--      end
--    end,{},evasion_delay)
--  end









  