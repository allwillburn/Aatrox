local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Aatrox" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Aatrox/master/Aatrox.lua', SCRIPT_PATH .. 'Aatrox.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Aatrox/master/Aatrox.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local AatroxMenu = Menu("Aatrox", "Aatrox")

AatroxMenu:SubMenu("Combo", "Combo")

AatroxMenu.Combo:Boolean("Q", "Use Q in combo", true)
AatroxMenu.Combo:Boolean("W", "Use W in combo", true)
AatroxMenu.Combo:Boolean("E", "Use E in combo", true)
AatroxMenu.Combo:Boolean("R", "Use R in combo", true)
AatroxMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
AatroxMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
AatroxMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
AatroxMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
AatroxMenu.Combo:Boolean("RHydra", "Use RHydra", true)
AatroxMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
AatroxMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
AatroxMenu.Combo:Boolean("Randuins", "Use Randuins", true)


AatroxMenu:SubMenu("AutoMode", "AutoMode")
AatroxMenu.AutoMode:Boolean("Level", "Auto level spells", false)
AatroxMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
AatroxMenu.AutoMode:Boolean("Q", "Auto Q", false)
AatroxMenu.AutoMode:Boolean("W", "Auto W", false)
AatroxMenu.AutoMode:Boolean("E", "Auto E", false)
AatroxMenu.AutoMode:Boolean("R", "Auto R", false)

AatroxMenu:SubMenu("LaneClear", "LaneClear")
AatroxMenu.LaneClear:Boolean("Q", "Use Q", true)
AatroxMenu.LaneClear:Boolean("W", "Use W", true)
AatroxMenu.LaneClear:Boolean("E", "Use E", true)
AatroxMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
AatroxMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

AatroxMenu:SubMenu("Harass", "Harass")
AatroxMenu.Harass:Boolean("Q", "Use Q", true)
AatroxMenu.Harass:Boolean("W", "Use W", true)

AatroxMenu:SubMenu("KillSteal", "KillSteal")
AatroxMenu.KillSteal:Boolean("Q", "KS w Q", true)
AatroxMenu.KillSteal:Boolean("E", "KS w E", true)

AatroxMenu:SubMenu("AutoIgnite", "AutoIgnite")
AatroxMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

AatroxMenu:SubMenu("Drawings", "Drawings")
AatroxMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

AatroxMenu:SubMenu("SkinChanger", "SkinChanger")
AatroxMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
AatroxMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if AatroxMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if AatroxMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
				if target ~= nil then 
                                      CastSkillShot(_Q, target)
                                end
            end

            if AatroxMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 150) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if AatroxMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if AatroxMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if AatroxMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if AatroxMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if AatroxMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1000) then
			 CastSkillShot(_E, target)
	    end

            if AatroxMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end

            if AatroxMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if AatroxMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if AatroxMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if AatroxMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 150) then
			CastSpell(_W)
	    end
	    
	    
            if AatroxMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 550) and (EnemiesAround(myHeroPos(), 550) >= AatroxMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and AatroxMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSkillShot(_Q, target)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and AatroxMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if AatroxMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 700) then
	        	CastSkillShot(_Q, closeminion)
                end

                if AatroxMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 150) then
	        	CastSpell(_W)
	        end

                if AatroxMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 1000) then
	        	CastSkillShot(_E, closeminion)
	        end

                if AatroxMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if AatroxMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if AatroxMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 700) then
		      CastSkillShot(_Q, target)
          end
        end 
        if AatroxMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 150) then
	  	      CastSpell(_W)
          end
        end
        if AatroxMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 1000) then
		      CastSkillShot(_E, target)
	  end
        end
        if AatroxMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 550) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if AatroxMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if AatroxMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 700, 0, 200, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
               
        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if AatroxMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Aatrox</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





