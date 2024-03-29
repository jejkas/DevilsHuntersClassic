DevilsHunters_LastUpdate = GetTime();
function DevilsHunters_OnUpdate()
	if DevilsHunters_LastUpdate + 0.1 <= GetTime()
	then
		DevilsHunters_UpdateString();
	end;
end

DevilsHunters_Locations = {}
DevilsHunters_Locations["NW"] = {x = 35, y = 24}
DevilsHunters_Locations["West"] = {x = 32, y = 36}
DevilsHunters_Locations["North"] = {x = 56, y = 24}
DevilsHunters_Locations["Mid"] = {x = 58, y = 75}
DevilsHunters_Locations["East"] = {x = 73, y = 32}
DevilsHunters_Locations["South"] = {x = 44, y = 80}

DevilsHunters_respawnDuration = 960


function DevilsHunters_GetClosest()
	local closestSpot = "";
	local closestDistance = 999999999;
	--local px,py=GetPlayerMapPosition("player")
	
	local px, py = DevilsHunters_GetPosition();
	
	for locationName, loc in pairs(DevilsHunters_Locations)
	do
		local distance = math.dist(loc.x, loc.y, px*100, py*100)
		if distance < closestDistance
		then
			closestSpot = locationName;
			closestDistance = distance;
		end
	end
	
	return closestSpot;
end

function DevilsHunters_GetPosition()
	local map = C_Map.GetBestMapForUnit("player");
	if map
	then
		local position = C_Map.GetPlayerMapPosition(map, "player");
	
		local px, py = position:GetXY();
		return px, py;
	else
		return 0, 0;
	end
end

function DevilsHunters_PrintDistance() -- /script DevilsHunters_PrintDistance();
	local px, py = DevilsHunters_GetPosition();
	
	for locationName, loc in pairs(DevilsHunters_Locations)
	do
		local distance = math.dist(loc.x, loc.y, px*100, py*100);
		--DevilsHunters_(locationName .. ": " .. distance);
	end
end

-- /script DevilsHunters_UpdateString();
function DevilsHunters_UpdateString()
	local px, py = DevilsHunters_GetPosition();
	if DevilsHunters_Frame_Font
	then
		DevilsHunters_Frame_Font:SetText(DevilsHunters_GetClosest());
	end
end;

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

SLASH_DevilsHunters1 = "/DevilsHunters";


SlashCmdList["DevilsHunters"] = function(args)
	--DevilsHunters_(args);
	if args == ""
	then
		DevilsHunters_("/DevilsHunters lock | hide")
	elseif args == "lock"
	then
		if DevilsHunters_Frame:IsMovable()
		then
			DevilsHunters_("Frame locked");
			DevilsHuntersClassic_Settings["frameLocked"] = true;
			DevilsHunters_Frame.texture:SetVertexColor(0,0,0,0)
			DevilsHunters_Frame:SetMovable(false);
			DevilsHunters_Frame:EnableMouse(false);
			DevilsHunters_Frame:SetResizable(false);
		else
			DevilsHunters_("Frame unlocked");
			DevilsHuntersClassic_Settings["frameLocked"] = false;
			DevilsHunters_Frame.texture:SetVertexColor(0,0,0,0.4)
			DevilsHunters_Frame:SetMovable(true);
			DevilsHunters_Frame:EnableMouse(true);
			DevilsHunters_Frame:SetResizable(true);
		end
	elseif args == "hide"
	then
		if DevilsHunters_Frame:IsVisible()
		then
			DevilsHuntersClassic_Settings["frameShown"] = false;
			DevilsHunters_Frame:Hide();
		else
			DevilsHuntersClassic_Settings["frameShown"] = true;
			DevilsHunters_Frame:Show();
		end;
	end
end;



DevilsHunters_LastResponsSent = 0;

function DevilsHunters_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	--print(self, event, ...);
	if event == "ADDON_LOADED" and arg1 == "DevilsHunters"
	then
		if not DevilsHuntersClassic_Settings
		then
			DevilsHuntersClassic_Settings = {}
			DevilsHuntersClassic_Settings["frameLocked"] = false;
			DevilsHuntersClassic_Settings["frameShown"] = false;
 			DevilsHuntersClassic_Settings["frameRelativePos"] = "TOPLEFT";
			DevilsHuntersClassic_Settings["frameXPos"] = 0;
			DevilsHuntersClassic_Settings["frameYPos"] = 0;
		end
		DevilsHunters_MakeFrame();
	end
	
	if event == "COMBAT_LOG_EVENT_UNFILTERED"
	then
		local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
		if subevent == "UNIT_DIED"
		then
			--print(destName, string.find(destName, "gre"));
		end
		if subevent == "UNIT_DIED" and string.find(destName, "evilsaur") ~= nil
		then
			--print("We are here!");
			if SlashCmdList.BIGWIGSLOCALBAR ~= nil
			then
				SlashCmdList.BIGWIGSLOCALBAR(DevilsHunters_respawnDuration .. " " .. DevilsHunters_GetClosest());
				SlashCmdList.BIGWIGSRAIDBAR(DevilsHunters_respawnDuration .. " " .. DevilsHunters_GetClosest());
			end
		end
	end
end




function DevilsHunters_(str)
	local c = ChatFrame1;
	
	if str == nil
	then
		c:AddMessage('DevilsHunters: NIL'); --ChatFrame1
	elseif type(str) == "boolean"
	then
		if str == true
		then
			c:AddMessage('DevilsHunters: true');
		else
			c:AddMessage('DevilsHunters: false');
		end;
	elseif type(str) == "table"
	then
		c:AddMessage('DevilsHunters: array');
		DevilsHunters_printArray(str);
	else
		c:AddMessage('DevilsHunters: '..str);
	end;
end;

function DevilsHunters_printArray(arr, n)
	if n == nil
	then
		 n = "arr";
	end
	for key,value in pairs(arr)
	do
		if type(arr[key]) == "table"
		then
			DevilsHunters_printArray(arr[key], n .. "[\"" .. key .. "\"]");
		else
			if type(arr[key]) == "string"
			then
				DevilsHunters_(n .. "[\"" .. key .. "\"] = \"" .. arr[key] .."\"");
			elseif type(arr[key]) == "number" 
			then
				DevilsHunters_(n .. "[\"" .. key .. "\"] = " .. arr[key]);
			elseif type(arr[key]) == "boolean" 
			then
				if arr[key]
				then
					DevilsHunters_(n .. "[\"" .. key .. "\"] = true");
				else
					DevilsHunters_(n .. "[\"" .. key .. "\"] = false");
				end;
			else
				DevilsHunters_(n .. "[\"" .. key .. "\"] = " .. type(arr[key]));
				
			end;
		end;
	end
end;

function __strsplit(sep,str)
	if str == nil
	then
		return false;
	end;
	local arr = {}
	local tmp = "";
	
	--printDebug(string.len(str));
	local chr;
	for i = 1, string.len(str)
	do
		chr = string.sub(str, i, i);
		if chr == sep
		then
			table.insert(arr,tmp);
			tmp = "";
		else
			tmp = tmp..chr;
		end;
	end
	table.insert(arr,tmp);
	
	return arr
end

-- UI stuff, should be it's own file

function DevilsHunters_UI_MoveFrameStart(arg1, frame)
	if not frame.isMoving
	then
		if arg1 == "LeftButton" and frame:IsMovable()
		then
			frame:StartMoving();
			frame.isMoving = true;
		end
	end;
end;

function DevilsHunters_UI_MoveFrameStop(arg1, frame)
	if frame.isMoving
	then
		local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
		DevilsHuntersClassic_Settings["frameRelativePos"] = relativePoint;
		DevilsHuntersClassic_Settings["frameXPos"] = xOfs;
		DevilsHuntersClassic_Settings["frameYPos"] = yOfs;
		frame:StopMovingOrSizing();
		frame.isMoving = false;
	end
end;

DevilsHunters_Frame = nil;
DevilsHunters_Frame_Font = nil;

function DevilsHunters_MakeFrame()
	local f = DevilsHunters_Frame;
	f.texture = f:CreateTexture(nil,"OVERLAY");
	f.texture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background");
	f:SetWidth(500)
	f:SetHeight(30)
	f:SetPoint(DevilsHuntersClassic_Settings["frameRelativePos"], DevilsHuntersClassic_Settings["frameXPos"], DevilsHuntersClassic_Settings["frameYPos"])
	f:SetFrameStrata("MEDIUM")
	
	if DevilsHuntersClassic_Settings["frameLocked"]
	then
		f.texture:SetVertexColor(0,0,0,0)
	else
		f.texture:SetVertexColor(0,0,0,0.4)
	end
	
	f:SetMovable(not DevilsHuntersClassic_Settings["frameLocked"]);
	f:EnableMouse(not DevilsHuntersClassic_Settings["frameLocked"]);
	f:SetResizable(not DevilsHuntersClassic_Settings["frameLocked"]);
	f.texture:SetAllPoints(f)

	f:SetScript("OnMouseDown", function() DevilsHunters_UI_MoveFrameStart(arg1, this); end)
	f:SetScript("OnMouseUp", function() DevilsHunters_UI_MoveFrameStop(arg1, this); end)

	DevilsHunters_Frame_Font = DevilsHunters_Frame:CreateFontString();
	DevilsHunters_Frame_Font:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
	DevilsHunters_Frame_Font:SetPoint("LEFT", DevilsHunters_Frame, 0, 0)
	DevilsHunters_Frame_Font:SetWidth(500);
	DevilsHunters_Frame_Font:SetHeight(30);
	DevilsHunters_Frame_Font:SetText("BACON");
	DevilsHunters_Frame:Hide();
	if DevilsHuntersClassic_Settings["frameShown"]
	then
		DevilsHunters_Frame:Show();
	end;
end

DevilsHunters_Frame = CreateFrame("FRAME", "DevilsHunters_Frame");
DevilsHunters_Frame:RegisterEvent("ADDON_LOADED");
DevilsHunters_Frame:RegisterEvent("PLAYER_LOGIN");
DevilsHunters_Frame:RegisterEvent("CHAT_MSG_SYSTEM");
DevilsHunters_Frame:RegisterEvent("CHAT_MSG_ADDON");
DevilsHunters_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
DevilsHunters_Frame:SetScript("OnUpdate", DevilsHunters_OnUpdate);
DevilsHunters_Frame:SetScript("OnEvent", DevilsHunters_OnEvent);