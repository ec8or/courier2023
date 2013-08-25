local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--local widget = require "widget"

function scene:createScene( event )
   
	local group = self.view

	storyboard.removeAll()
	
	local map = display.newGroup()
    group:insert(map) 
	
    map.x = 0
    map.y = 0
    
    local moves = 0
	local gameover = 0
	
    -- Game specific variables
	local phase = 1
	local gotPackage = 0
	local gotDisguise = 0

    -- Map size
	local mapWidth = 10
    local mapHeight = 7
    local xOffset = 100
    local yOffset = 100

    -- Player start
	local startX = 1
    local startY = 7

	native.showAlert("START", "Your have to collect the package from your contact hiding in one of the bars and deliver it to the intended target. Time is running out so hurry up!", { "OK" })
				
    local function inGrid(x, y)
        --print("Y=" .. y .. " startY=" .. startY)
        --print("X=" .. x .. " startX=" .. startX)
		if (x == startX) and (y == startY + 1 or y == startY - 1) then
			return true
		elseif (y == startY) and (x == startX + 1 or x == startX - 1) then
			return true
		end
		return false
    end

    local function ClickHandler(event)
		if(event.phase=="ended")then
            print(event.target.value)
			if string.sub(event.target.value, 1, 1) == "S" and inGrid(event.target.gridX, event.target.gridY) then
                -- Revert old hex
                print("Came from " .. startX .. "," .. startY .. " value: " .. event.target.value)
                -- Set new active hex
                startX = event.target.gridX
                startY = event.target.gridY

                -- Replace bitmap
                -- Replace with float and animation
                x = event.target.x
                y = event.target.y

				if player then
					player:removeSelf()
					player=display.newImage("images/player.png", true);
					player.x = x
					player.y = y
					map:insert(player);
				end
				
				-- One move
                moves = moves + 1
                print ("Moves: " .. moves)
				
				-- Do Tile
				print(event.target.chart)
				if event.target.chart == "getPackage" then
					if gotPackage == 0 then
						getPackage()
					end
				elseif event.target.chart == "lookout" then
					lookout()
				elseif event.target.chart == "streetDoctor" then
					streetDoctor()
				elseif event.target.chart == "spotted" then
					spotted()
				elseif event.target.chart == "deliverPackage" then
					deliverPackage()
				end
				if gotPackage == 0 and moves > 10 then
					native.showAlert("GAME OVER", "You have taken too long to retrieve the package.", { "OK" }, gameOver )
				elseif moves > 24 then
					native.showAlert("GAME OVER", "You have taken too long to deliver the package.", { "OK" }, gameOver )
				end
            end
        end
        print ("here we are")
		return true
    end

	--- SCENES
	---
	
	local function onStreetDoctor( event )
		if "clicked" == event.action then
			local i = event.index
			if 1 == i then
				gotDisguise = 1
				native.showAlert("STREET DOCTOR", "You enter an underground street surgery and pay the doctor for some temporary plastic surgery and some new clothes. Noone will recognize you now.", { "OK" })		
			elseif 2 == i then
				-- Nothing
			end
		end
	end

	local function onBar( event )
		print("IN BAR")
		if "clicked" == event.action then
			local i = event.index
			if 1 == i then
				gotPackage = 1
				native.showAlert("GOT PACKAGE", "You enter the bar and spot your contact who discreetly hands over the package. It is to be delivered to the other bar across town.", { "OK" })
			elseif 2 == i then
				-- Nothing
			end
		end
	end

	local function onOtherBar( event )
		if "clicked" == event.action then
			local i = event.index
			if 1 == i then
				native.showAlert("PACKAGE DELIVERED", "You spot the target and deliver the package. You've won the game!", { "OK" }, gameWon)	
			elseif 2 == i then
				-- Nothing
			end
		end
	end

	local function onLookout( event )
		if "clicked" == event.action then
			local i = event.index
			if 1 == i then
				native.showAlert("SLIPPED BY", "The man doesn't seem to pay you any notice.", { "OK" })	
			elseif 2 == i then
				gameover = 1
				native.showAlert("GAME OVER", "The man produces a gun and proceeds to blow your head off.", { "OK" }, endThis)
			end
		end
	end

	function getPackage()
		native.showAlert("THE BAR", "You arrive outside the bar.", { "Enter", "Leave" }, onBar )		
	end

	function lookout()
		if gotPackage == 0 then 
			native.showAlert("LOOKOUT", "You notice a man dressed in a black leather trenchcoat overlooking the streetcorner. He looks suspicious and pretty tough but it doesn't seem like he has noticed you.", { "OK" } )
		else
			native.showAlert("GAME OVER", "You are spotted carrying the package by a man across the street who shoots you down and takes it.", { "OK" }, gameOver )
		end
	end

	function deliverPackage()
		native.showAlert("THE OTHER BAR", "You arrive outside the other bar. The window is blacked out so you can't see what is going on inside.", { "Enter", "Leave" }, onOtherBar )		
	end

	function streetDoctor()
		native.showAlert("ALLEY", "You arrive outside an unmarked door with a com system outside.", { "Enter", "Leave" }, onStreetDoctor)
	end
		
	function spotted()
		if gotDisguise == 0 then
			native.showAlert("GAME OVER", "A man is waiting for you outside the bar. You are no match for his weapons and skills and lose both package and life.", { "OK" }, gameOver )
		else
			native.showAlert("SAFE", "There are men waiting on either side of the bar but they can't recognize you as you slip past.", { "OK" })
		end
	end

	function gameOver()
		print("GAME OVER")
		storyboard.gotoScene("newgame")
	end
		
	--- INIT MAP
	------------------------------------

    myMap = {}
    terrainMap = {}
    terrainMap[1] =  {"B2","B2","B2","BAR","B2","B2","B2","S",  "B2","B2"}
    terrainMap[2] =  {"S3", "S2","S3","S3","S3","S3","S3","S2", "S3","S3"}
    terrainMap[3] =  {"B",  "S", "B", "B", "B", "B", "S", "B2", "B", "B"}
    terrainMap[4] =  {"B",  "S2", "S3","S3","S3","S3","S2", "S3", "S2", "B"}
    terrainMap[5] =  {"B",  "S", "B2","B2","S2","B2","S","B2", "S", "B"}
    terrainMap[6] =  {"B",  "S", "B2","B2","B2","B2","S", "BAR","S", "B2"}
    terrainMap[7] =  {"S3", "S2","S3","S3","S3","S3","S2","S3", "S3","B"}

    chartMap = {}
    chartMap[1] =  {0,0,0,"deliverPackage",0,0,0,0,0,0}
    chartMap[2] =  {0,0,"spotted",0,"spotted",0,0,0,0,0}
    chartMap[3] =  {0,0,0,0,0,0,0,0,0,0}
    chartMap[4] =  {0,0,0,0,0,0,0,0,0,0}
    chartMap[5] =  {0,0,0,0,"streetDoctor",0,"lookout",0,0,0}
    chartMap[6] =  {0,0,0,0,0,0,0,0,0,0}
    chartMap[7] =  {0,0,0,0,0,"lookout",0,"getPackage",0,0}

    print "-----"
    print(terrainMap[1][1])

    
    for y=1,mapHeight do
        myMap[y] = {}     -- create a new row
        for x=1,mapWidth do
            -- OK, we're making our actual object a table that we
            -- can throw goodies in later on...
            myMap[y][x] = {}
            -- We'll assign the variable 'value' a text value so we can parse
            -- it later on
     
            -- Here's where we'll randomize it a little bit
            --local tempValue = math.random(0,2)
            local tempValue = terrainMap[y][x]
            print(tempValue)
            local fileName = ""
            if(tempValue=="B") then
                myMap[y][x].value = "B"
                fileName="images/tile_roof.png"
            elseif(tempValue=="B2") then
                myMap[y][x].value = "B"
                fileName="images/tile_roof.png"
            elseif(tempValue=="BAR") then
                myMap[y][x].value = "B"
                fileName="images/tile_bar.png"
            elseif(tempValue=="S") then
                myMap[y][x].value = "S2"
                fileName="images/tile_street.png"
            elseif(tempValue=="S3") then
                myMap[y][x].value = "S"
                fileName="images/tile_street-2.png"
            elseif(tempValue=="S2") then
                myMap[y][x].value = "S"
                fileName="images/tile_street-3.png"
            end

            -- Start hex
            if (x == startX and y == startY) then
                currentTile = {}
                currentTile.x = x;
                currentTile.y = y;
    
				player=display.newImage("images/player.png", true);
				player.x = x * xOffset
				player.y = y * yOffset


	
				--currentTile.graphic = display.newImage("images/tile_highlight.png")
				--currentTile.graphic.x = x*xOffset
				--currentTile.graphic.y = (y * yOffset)
            end
            myMap[y][x].graphic = display.newImage(fileName)

            myMap[y][x].graphic.name = x..","..y
            myMap[y][x].graphic.gridX = x
            myMap[y][x].graphic.gridY = y
            myMap[y][x].graphic.value = myMap[y][x].value
            myMap[y][x].graphic.chart = chartMap[y][x]

            -- Add event handler to the graphic
            myMap[y][x].graphic:addEventListener("touch", ClickHandler )
			myMap[y][x].graphic.x = x*xOffset
			myMap[y][x].graphic.y = (y * yOffset)
			map:insert(myMap[y][x].graphic)
			print (x*xOffset)
        end
    end

	map:insert(player);
    map:setReferencePoint(display.TopLeftReferencePoint)    

	--- SCROLL MAP
	--- 
    function map.updateDisplay()
		map.x = -(map.xScroll)
		map.y = -(map.yScroll)
    end

    local prevX, prevY
    local function drag(event)
		if event.phase == "began" then
			print("began scroll")
			prevX = event.x
			prevY = event.y
		elseif event.phase == "moved" then
			print("scrolling")
			moveX = math.abs(event.x - prevX)
			moveY = math.abs(event.y - prevY)
			if (moveX > 12 or moveY > 12) then
				map.xScroll = map.xScroll + prevX - event.x
				map.yScroll = map.yScroll + prevY - event.y
				map.updateDisplay()
				prevX = event.x
				prevY = event.y
			end
		elseif event.phase == "ended" then
			print "stopped scrolling"
		end

    end
    --map:addEventListener("touch", drag)

    -- create huge rectangle
    local movingRectangle = display.newRect( 0, 0, 1000, 700 )
    movingRectangle:setFillColor( 0,0,0,255 )
    movingRectangle.alpha = 0.01

    movingRectangle:setReferencePoint(display.TopLeftReferencePoint)    
    
    function movingRectangle:touch( event )
        if event.phase == "began" then
            print("began scroll")

            self.markX = self.x -- store x location of object
            self.markY = self.y -- store y location of object

        elseif event.phase == "moved" then

            local x = (event.x - event.xStart) + self.markX
            local y = (event.y - event.yStart) + self.markY

            self.x, self.y = x, y -- move object based on calculations above
            -- OK, we've moved our little shite rectangle, so
            -- let's move our group too.
            map.x = self.x
            map.y = self.y
            return true
        end
    end

    movingRectangle:addEventListener( "touch", movingRectangle )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene