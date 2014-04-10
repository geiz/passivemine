-- Copyright 2014 Opplet LLC
---------------------------------

display.setStatusBar( display.HiddenStatusBar ) 

local config = require ("configuration")
local widget = require ("widget")


local _W, _H = display.contentWidth, display.contentHeight
local viewable_W, viewable_H = display.viewableContentWidth, display.viewableContentHeight
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local imgNum = 1 -- Starts at 1 for new game.
local imgMax = 6 -- maximum number of images ingame
local loadedImgs = {nil,nil,nil}
		-- Array of Size 3, stores image number
		-- These imgs are a list of displays grouped together
local background
local imageNumberText, imageNumberTextShadow
local display_may_need_update = true

local playerstats = config.loadPlayerStats()

--function newSlide(rockdefs, slideBackground)
	local pad = 20
	local x_anchor = _W/2
	local y_anchor = 340
	local x_offset_img = _W
	local x_offset_text = _W/2
	local y_offset_text = 18


	local g = display.newGroup()
		
	--[[if slideBackground then
		background = display.newImage(slideBackground, 0, 0, true)
	else]]
		background = display.newRect( 0, 0, _W, _H)

		-- set anchors on the background
		background.anchorX = 0
		background.anchorY = 0

		background:setFillColor(1) 
		background.alpha = 1 -- 0 will set BG as invisible
		background.isHitTestable = true -- Allows invisible to be hit 
	--end
	-- Positions background
	g.x = 0
	--g.y = display.screenOriginY  -- screenOriginY is from the top part of screen
	g:insert(background)

	--Creates invisible hitbox
	mine_box = display.newRect(20,145,280,190,true)
	mine_box.anchorX = 0
	mine_box.anchorY = 0
	--mine_box.x = 25
	--mine_box.y = 200
	mine_box:setFillColor(0.5,0,0)
	mine_box.alpha = 0.5
	mine_box.isHitTestable = true
	g:insert(mine_box)


	-- array 2 is the shown one. 1 is left, 3 is right.
	-- This function starts the game from beginning
	function init() 
		loadedImgs[1] = nil
		loadedImgs[2] = Load_Slidable_Display(1, 0)
		loadedImgs[3] = Load_Slidable_Display(2,x_offset_img)
		print(loadedImgs[1])
		print(loadedImgs[2])
		print(loadedImgs[3])
		-- imgNum = loadedImgs[2].id -- This line doesn't work.... not sure why
		imgNum = 1
		---------
		--dollars = addStat("$")
	end

	-- Adds static texts onto the screen, stored in text_Boxes table.
	---- Anchor for the texts are set as top left corner of text
	function Load_Screen_Texts (x, y, text, fontSize, font)
		local tempText
		local defaultFont = native.systemFont
		
		if font then 
		else font = defaultFont end

		-- Creates new text on screen
		tempText = display.newText(text, x, y, font, fontSize)
		tempText.anchorX = 0 --afssssssssssssssssssssssssssssssss
		tempText.anchorY = 0 
		tempText:setFillColor(0)
		-- Adds Created text to array
		--table.insert(text_boxes, temp_text
		return tempText
	end







	 display_table_length = 1  -- Represents number of elements in display_table

	-- rID: Int, rockID. The key for the  array 
	-- loadedImgNum: Int[1..3], defines the arrays. 1 is leftmost, 3 is rightmost
	function Load_Slidable_Display (rID, x_offset_img)
		local rockdef = config.getRockDefinition(rID)
		if (rockdef) then
			local displayImg
			local displayTable = {
				image = display.newImage(rockdef.image, x_anchor+x_offset_img, y_anchor-100),
				id = rockdef.id
			}
			return displayTable
		else
			return nil
		end
	end

	init()

	-- These are Passive, they do not change.
	local symbols = {
		hp = "HP: ",
		defense = "D: ",
		gem = "Gem: ",
		dollar = "$ ",
		pick_power = "Pick Power: ",
		pick_quality = "Q: ",
		active_multiplier = "Active Multiplier: ",
		passive_multiplier = "Passive Multiplier: ",
	}

	local rockdef = config.getRockDefinition (loadedImgs[2].id)

	local values = {
		rock_name = rockdef.name,
		rock_hp = symbols.hp .. rockdef.curr_hp,
		rock_defense = symbols.defense .. rockdef.defense,
		rock_dollar = symbols.dollar .. rockdef.dollar,

		player_name = playerstats.name,
		player_dollar = symbols.dollar .. playerstats.dollar,
		player_gem = symbols.gem .. playerstats.gem,
		player_pickaxe_power = symbols.pick_power .. playerstats.pickaxe_power,
		player_pickaxe_quality = symbols.pick_quality .. playerstats.pickaxe_quality,
		player_active_multiplier = symbols.active_multiplier ..  playerstats.active_multiplier,
		player_passive_multiplier = symbols.passive_multiplier .. playerstats.passive_multiplier,

		player_active_hit = playerstats.pickaxe_power * playerstats.pickaxe_quality* playerstats.active_multiplier,
		player_passive_hit = playerstats.pickaxe_power * playerstats.pickaxe_quality* playerstats.passive_multiplier,
	}

	-- Lists of default textboxes. This occurs on first load
	local text_boxes = {
		r_name = Load_Screen_Texts(0,0, values.rock_name, 15),
		r_hp = Load_Screen_Texts(0,y_offset_text, values.rock_hp, 15),
		r_defense = Load_Screen_Texts(0,y_offset_text*2,values.rock_defense, 15),
		r_dollar = Load_Screen_Texts(0,y_offset_text*3,values.rock_dollar, 15),
		
		p_name = Load_Screen_Texts( x_offset_text, 0, values.player_name, 15),
		p_dollar = Load_Screen_Texts( x_offset_text, y_offset_text, values.player_dollar, 15),
		p_gem = Load_Screen_Texts( x_offset_text, y_offset_text*2, values.player_gem, 15),
		p_pickaxe_power = Load_Screen_Texts( x_offset_text, y_offset_text*3, values.player_pickaxe_power, 15),
		p_pickaxe_quality = Load_Screen_Texts( x_offset_text, y_offset_text*4, values.player_pickaxe_quality, 15),
		p_active_multiplier = Load_Screen_Texts( x_offset_text, y_offset_text*5, values.player_active_multiplier, 15),
		p_passive_multiplier = Load_Screen_Texts( x_offset_text, y_offset_text*6, values.player_passive_multiplier, 15),
	
	}



		-- Things that need to be updated
	function Update_Values ()
		local rockdef = config.getRockDefinition(loadedImgs[2].id)
		values.rock_name = rockdef.name
		values.rock_hp = symbols.hp .. rockdef.curr_hp
		values.rock_defense = symbols.defense .. rockdef.defense
		values.rock_dollar = symbols.dollar .. rockdef.dollar

		values.player_dollar = symbols.dollar .. playerstats.dollar
		values.player_gem = symbols.gem .. playerstats.gem
		values.player_pickaxe_power = symbols.pick_power .. playerstats.pickaxe_power
		values.player_active_multiplier = symbols.active_multiplier ..  playerstats.active_multiplier
		values.player_passive_multiplier = symbols.passive_multiplier .. playerstats.passive_multiplier

		text_boxes["r_name"].text = values.rock_name
		text_boxes["r_hp"].text = values.rock_hp
		text_boxes["r_defense"].text = values.rock_defense
		text_boxes["r_dollar"].text = values.rock_dollar

		text_boxes["p_dollar"].text = values.player_dollar
		text_boxes["p_gem"].text = values.player_gem
		text_boxes["p_pickaxe_power"].text = values.player_pickaxe_power
		text_boxes["p_active_multiplier"].text = values.player_active_multiplier
		text_boxes["p_passive_multiplier"].text = values.player_passive_multiplier


	end

	-- Moves a display_table from its current location to xEnd instantaniously
	---- 
	function Move_Image_Table (displayTable, xEnd)
		displayTable.image.x = xEnd
	end

	-- removes an image from screen and memory
	function Remove_Img(image)
		image:removeSelf() -- remove from screen
		image = nil -- remove from memory
		--return image 
	end

	function Remove_Image_Table (imageTable)
	--	imageTable.image = Remove_Img(imageTable.image)
	Remove_Img(imageTable.image)
	
	end

	function abs (num)
		if num > 0 then
			return
		else
			return -num
		end
	end


	function Touch_Listener (self, touch)
		local phase = touch.phase
		if (phase == "began") then
            display.getCurrentStage():setFocus( self )
            self.isFocus = true

			startPos = touch.x
			prevPos = touch.x
		
		elseif( self.isFocus ) then

			local deltaX = touch.x - prevPos
			prevPos = touch.x

			local deltaXFromStartstart = touch.x - startPos

			if ( phase == "moved" ) then
			
						
				if tween then transition.cancel(tween) end
				
				-- Drags current image around by hand
				--Move_Image_Table(loadedImgs[2],loadedImgs[2].displayImg1.x+deltaX)
				
				-- This part allows next images to be dragged into view before hand is lifted
				if (loadedImgs[1]) then
					Move_Image_Table(loadedImgs[1],loadedImgs[1].image.x+deltaX)
				end
				
				if (loadedImgs[3]) then
					Move_Image_Table(loadedImgs[3],loadedImgs[3].image.x+deltaX)
				end

			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				--if touch.x < 100 --[[and abs(deltaX) > 50]] then
				if (deltaXFromStartstart < -100) then
					Next_Image()
				--elseif touch.x > _W - 100 --[[and abs(deltaX) > 50]] then
				elseif (deltaXFromStartstart > 100) then
					Prev_Image()
				else 
					Cancel_Move_And_Click()
				end
				
				if ( phase == "cancelled" ) then		
					Cancel_Move_And_Click()
				end

                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
														
			end
		end
					
		return true
		
	end

	function Active_Mine ()
		
		values.rock_hp = values.rock_hp - values.player_pickaxe_power
	end

	function Cancel_Tween()
		if prevTween then 
			transition.cancel(prevTween)
		end
		prevTween = tween 
	end
	

	function Next_Image()
		-- Resets rock health values. TODO: Problem because these lines mutate the rock definitions. Resolve!
		local rockdef = config.getRockDefinition(loadedImgs[2].id)
		rockdef.curr_hp = rockdef.start_hp

		if imgNum > imgMax - 1 then
			print("At the Final Rock!")
			Cancel_Move_And_Click()
			return
		end

		-- Removes loadedImgs[1] from offScreen display and memory if it exists
		if loadedImgs[1] then Remove_Image_Table(loadedImgs[1]) else print("loadedImgs[1] does not exist!") end
		-- Load new images
		loadedImgs[1] = loadedImgs[2]
		loadedImgs[2] = loadedImgs[3]
		loadedImgs[3] = Load_Slidable_Display(imgNum + 2, x_offset_img)

		print(loadedImgs[1] )
		print(loadedImgs[2] )
		print(loadedImgs[3] )

		tween = transition.to( loadedImgs[1], {time=400, Move_Image_Table(loadedImgs[1],x_anchor-x_offset_img), transition=easing.outExpo } )
		tween = transition.to( loadedImgs[2], {time=400, Move_Image_Table(loadedImgs[2],x_anchor), transition=easing.outExpo } )

		imgNum = imgNum + 1
	end

	
	function Prev_Image()
		-- Resets rock health values. TODO: Problem because these lines mutate the rock definitions. Resolve!
		local rockdef = config.getRockDefinition(loadedImgs[2].id)
		rockdef.curr_hp = rockdef.start_hp


		if imgNum < 2 then
			print("At the First Rock!")
			Cancel_Move_And_Click()
			return
		end

		-- Removes loadedImgs[3] from offScreen display and memory if it exists
		if loadedImgs[3] then Remove_Image_Table(loadedImgs[3]) else print("loadedImgs[3] does not exist!") end
		-- Load new images
		loadedImgs[3] = loadedImgs[2] 
		loadedImgs[2] = loadedImgs[1]
		loadedImgs[1] = Load_Slidable_Display(imgNum - 2, -x_offset_img)

		print(loadedImgs[1] )
		print(loadedImgs[2] )
		print(loadedImgs[3] )

		tween = transition.to(loadedImgs[2], {time=400, Move_Image_Table(loadedImgs[2],x_anchor), transition=easing.outExpo } )
		tween = transition.to(loadedImgs[3], {time=400, Move_Image_Table(loadedImgs[3],x_anchor+x_offset_img), transition=easing.outExpo } )

		imgNum = imgNum - 1
	end

	
	function Cancel_Move_And_Click()
		-- Resets Positioning of the 3 loaded images
		tween = transition.to( loadedImgs[2], {time=400, Move_Image_Table(loadedImgs[2],x_anchor), transition=easing.outExpo } )
		if loadedImgs[1] then
			tween = transition.to( loadedImgs[1], {time=400, Move_Image_Table(loadedImgs[1],x_anchor-x_offset_img), transition=easing.outExpo } )
		end
		if loadedImgs[3] then
			tween = transition.to( loadedImgs[3], {time=400, Move_Image_Table(loadedImgs[3],x_anchor+x_offset_img), transition=easing.outExpo } )
		end

		-- Manual Click logic. TODO: Problem because these lines mutate the rock definitions. Resolve!
		local rockdef = config.getRockDefinition(loadedImgs[2].id)
		if rockdef.defense > values.player_active_hit then -- if player's hit bypasses defense
		else
			rockdef.curr_hp = rockdef.curr_hp - values.player_active_hit
			if rockdef.curr_hp <= 0 then
				playerstats.dollar = playerstats.dollar + rockdef.dollar
				print(playerstats.dollar)
				rockdef.curr_hp = rockdef.start_hp
			end
		end
	end

	mine_box.touch = Touch_Listener
	mine_box:addEventListener( "touch", mine_box )
	Runtime:addEventListener ("enterFrame", function (event) if display_may_need_update then Update_Values () end end)



--end

--newSlide(rockdefs, nil, 25, 1)
