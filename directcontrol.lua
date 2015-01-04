scriptId = 'com.marcelloricottone.directcontrol'
scriptTitle = 'Direct Control'
scriptDetailsUrl = ''


function activeAppName()
	return appTitle
end

function onForegroundWindowChange(app,title)

	myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	appTitle = title
	appname = app
	return true
end



function onPoseEdge (pose,edge)
	myo.debug("onPoseEdge: " .. pose .. ":" .. edge)

	
	if (edge == 'on') then
		mouseEdge = 'down'
	else
		mouseEdge = 'up'
		releaseScrollHold()
	end


-- if edge == "on" and pose == "fingersSpread" then
--         currentPlayer:playPause()
--         myo.unlock("timed")
--         myo.notifyUserAction()
--     end

	if (pose == 'waveOut') then
		onWaveOut(mouseEdge)
	end

	if (pose == 'waveIn') then
		onWaveIn(mouseEdge)
	end

	if (pose == "fist" and appname ~= "spotify.exe") then
		onFist(mouseEdge)
	elseif (pose =="fist" and appname ~= "chrome.exe") then
		chromefist(mouseEdge)
	elseif (pose == "fist" and appname == "spotify.exe") then
		spotifyfist(mouseEdge)
	end 

	if (pose == 'fingersSpread' and appname == "chrome.exe") then
		onFingersSpread()
	elseif (edge == "on" and pose == 'fingersSpread' and appname == "spotify.exe") then
		currentPlayer:playPause()
        myo.notifyUserAction()
	end

	if (pose =='doubleTap') then
		onDoubleTap()
	end
	
end

function onUnlock()
	myo.controlMouse(true)
	myo.unlock("hold")

end

function onlock()
	myo.controlMouse(false)
	myo.lock()
	myo.keyboard("right_alt","up")
end	


function onWaveOut()
	--myo.debug("Next")
	
	local now = myo.getTimeMilliseconds()
	repeat until myo.getTimeMilliseconds() > now +1000

	if (mouseEdge =="down" and myo.getTimeMilliseconds() > now +500) then
		myo.keyboard("t","press","control","shift")
	else 
		myo.keyboard("w","press","control")
	end
	
				
end

function onDoubleTap()

	onlock()

end


function onWaveIn(mouseEdge)
	--myo.debug("previous")
	myo.keyboard("right_alt",mouseEdge)
	-- myo.keyboard("tab","press")
	-- myo.keyboard("tab","press")

	tab = 1
	while tab == 1 do

		local now = myo.getTimeMilliseconds()
		repeat until myo.getTimeMilliseconds() > now +1000

		if (mouseEdge =="down" and myo.getTimeMilliseconds() > now +500) then
			myo.keyboard("tab","press")
		else 
			tab = 2
		end
	end
end


function onFist(mouseEdge)
	--myo.debug("left click")

	myo.mouse("left",mouseEdge)
	myo.vibrate("short")
end

function chromefist(mouseEdge)
	--myo.debug("left click")

	myo.mouse("left","click")
	myo.vibrate("short")

	local now = myo.getTimeMilliseconds()
	repeat until myo.getTimeMilliseconds() > now +1250

	if (mouseEdge =="down" and myo.getTimeMilliseconds() > now +500) then
		-- myo.debug("double click" .. now .. "  " .. myo.getTimeMilliseconds())
		startingPitch = myo.getPitch()
		lastTime = myo.getTimeMilliseconds()
		isScrolling = true
	end

end

function spotifyfist(mouseEdge)
	
	myo.mouse("left","click")
	myo.vibrate("short")
			
	local now = myo.getTimeMilliseconds()
	repeat until myo.getTimeMilliseconds() > now +1250

	if (mouseEdge =="down" and myo.getTimeMilliseconds() > now +500) then
		-- myo.debug("double click" .. now .. "  " .. myo.getTimeMilliseconds())
		myo.mouse("left","click")
		myo.mouse("left","click")
		myo.vibrate("medium")
	end

	
end

function onFingersSpread()
	--myo.debug("back")
	-- myo.keyboard("Escape","press")

	local titleMatch = string.match(appTitle, "Plex") ~= nil or string.match(appTitle, "plex") ~= nil;
	myo.debug("Plex: "  .. tostring(titleMatch))
    if (titleMatch) then
    	myo.keyboard("space","press")
    else 
    	myo.mouse("center","click")
    end
    
	
	myo.vibrate("short")	
end

-- spotify control adapted and condensed from spotify.myo on market

MediaPlayer = {}

function MediaPlayer:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

currentPlayer = MediaPlayer:new()

function currentPlayer:playPause()
    myo.keyboard("space", "press")
end	

function currentPlayer:shuttleJumpForward()
    -- Skip to the next track
   
    myo.keyboard("right_arrow", "press", "control")
    
end

-- chrome control adapted and condensed from webbrowser.myo on maret


startingPitch = 0
isScrolling = false
lastTime = 0
pitchTolerance = 0.15

function onPeriodic()
	if isScrolling then
		local scrollTime = myo.getTimeMilliseconds()
		local differenceTime = scrollTime - lastTime

		if scrollTime - lastTime > 100 then
			local currentPitch = myo.getPitch()
			local differencePitch = currentPitch - startingPitch 

			if differencePitch > pitchTolerance then
				myo.keyboard("up_arrow", "press")
			elseif differencePitch < -pitchTolerance then
				myo.keyboard("down_arrow", "press")
			end

			lastTime = myo.getTimeMilliseconds()
		end
	end
end

function onActiveChange(isActive)
	if not isActive then
		isScrolling = false
	end
end

function releaseScrollHold()
	isScrolling = false
end