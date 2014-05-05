-- Copyright 2014 Opplet LLC
---------------------------------

display.setStatusBar( display.HiddenStatusBar ) 

require ("playerstate")
require ("rockstate")
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
local imageNumberText, imageNumberTextShadow2
local display_may_need_update = true

	local pad = 20
	local x_anchor = _W/2
	local y_anchor = 340
	local x_offset_img = _W
	local x_offset_ptext = 10 
	local y_offset_ptext = 18
	local x_offset_rtext = _W/2
	local y_offset_rtext = _H/2+110
	local y_spacing_rtext = 18

	-- Create a group to hold all images and displayed objects.
	local view = display.newGroup()
	view.x = 0

	-- Create sub groups to act as "pages" that player can switch between
	local main_view = display.newGroup()
	main_view.anchorX = 0
	main_view.anchorY = 0
	main_view.x = 0
	view:insert(main_view)

	local upgrade_view = display.newGroup()
	--upgrade_view:translate(_W/2  + _W, _H/2) -- Starts below main screen
	upgrade_view.anchorX = 0
	upgrade_view.anchorX = 0
	upgrade_view.x = -_W
	view:insert(upgrade_view)

	--------------------------------------	
	--[[main_view display objects]]
	--------------------------------------		
	-- Positions Display Container
	testground = display.newRect(upgrade_view, 0, 0, _W,_H)
	testground:setFillColor(0.5)
	testground.anchorX = 0
	testground.anchorY = 0
	testground.x = 0
	testground.y = 0
	upgrade_view:insert(testground)


	-- Creates Background
	background = display.newRect(main_view, 0, 0, _W, _H)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0
	background.y = 0
	background:setFillColor(1) 
	background.alpha = 1 -- 0 will set BG as invisible
	--background.isHitTestable = true -- Allows invisible to be hit 
	main_view:insert(background)

	--Creates invisible hitbox
	mine_box = display.newRect(20,145,280,190,true)
	mine_box.anchorX = 0
	mine_box.anchorY = 0
	mine_box:setFillColor(0.5,0,0)
	mine_box.alpha = 0.5
	mine_box.isHitTestable = true
	main_view:insert(mine_box)
	


	-- array 2 is the shown one. 1 is left, 3 is right.
	-- This function starts the game from beginning
	function init() 
		loadedImgs[1] = nil
		loadedImgs[2] = Load_Slidable_Display(1, 0)
		loadedImgs[3] = Load_Slidable_Display(2,x_offset_img)
		selectRock(loadedImgs[2].id)
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
	function Load_Screen_Texts (x, y, text, fontSize, anchorCenter)
		local tempText
		local defaultFont = native.systemFont
		 
		local font = defaultFont

		tempText = display.newText(text, x, y, font, fontSize)
		tempText:setFillColor(0)

		-- Creates new text on screen
		if anchorCenter then 
			tempText.anchorX = tempText.width / 2
			tempText.anchorY = tempText.height / 2
		else
			tempText.anchorX = 0 
			tempText.anchorY = 0 
		end
		
		return tempText
	end

	local toUpgradeScreen = function()
		print("trigger")
		transition.to(main_view, { x = _W , time = 400, transition = easing.outExpo} )
		transition.to(upgrade_view, { x = 0, time = 400, transition = easing.outExpo} )
	end

	local toMainScreen = function ()
		transition.to(main_view, { x = 0 , time = 400, transition = easing.outExpo} )
		transition.to(upgrade_view, { x = -_W, time = 400, transition = easing.outExpo} )

	end


	-- Creates a game-style button with a callbackfunction
	-- ID Must be unique for each button.
	function Load_Button (x, y, ID, defaultImg, overImg, displayContainer, onRelease)
		local tempButton = widget.newButton 
		{
			id = ID,
			defaultFile = defaultImg,
			overFile = overImg,
			--label = Label,
			emboss = false,
			onPress = nil, -- We only want interaction on release
			onRelease = onRelease,
			x = x,
			y = y,
		}

		displayContainer:insert(tempButton)

		-- Adds to table
		--buttons[tempButton.id] = tempButton
		return tempButton
	end


	-- Manually Load all of the buttons on main screen
	function Load_Main_Buttons ()
		upgrades = Load_Button (_W/6, _H -_H/15, "upgrades", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", main_view, toUpgradeScreen )--onTouch())
		mainscreen = Load_Button(_W/3*2, _H -_H/15, "upgrades", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view,toMainScreen )--onTouch())
		
		upgrade_menu_buttons = { -- a key/value pair for the buttons ingame
			bs_upgrade = Load_Button (_W/4, _H -_H/10 *5, "bs_upgrade", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			bs_skill = Load_Button (_W/4, _H -_H/10 *4, "bs_skill", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			bs_expertise = Load_Button (_W/4, _H -_H/10 *3, "bs_expertise", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			bs_efficiency = Load_Button (_W/4, _H -_H/10 *2, "bs_efficiency", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			mc_power = Load_Button (_W/4*2, _H -_H/10 *5, "mc_power", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			ac_power = Load_Button (_W/4*2, _H -_H/10 *4, "ac_power", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			ac_frequency = Load_Button (_W/4*2, _H -_H/10 *3, "ac_frequency", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			idle_power = Load_Button (_W/4*2, _H -_H/10 *2, "idle_power", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			gem_finder = Load_Button (_W/4*3, _H -_H/10 *5, "gem_finder", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
			gem_waster = Load_Button (_W/4*3, _H -_H/10 *4, "gem_waster", "buttonUpgradeDefault.png", "buttonUpgradeOver.png", upgrade_view, nil),
		}
		--[[]]
	end

	Load_Main_Buttons(true)



--[[
	local function onTouch (event)
		local phase = event.phase
		local target = event.target

		if "press" == phase then
		elseif "release" == phase then
			transition.to(main_view, { x = _W/2 + display.screenOriginX, time = 400, transition = easing.outExpo} )
			transition.to(upgrade_view, { x = _W/2 +upgrade_view.contentWidth * 0.5, time = 400, transition = easing.outExpo} )
		end
	end
]]


	-- rID: Int, rID. The key for the table 
	-- loadedImgNum: Int[1..3], defines the arrays. 1 is leftmost, 3 is rightmost
	function Load_Slidable_Display (rID, x_offset_img)	
		local rockdef = config.getRockDefinition(rID)
		if (rockdef) then
			--local displayImg
			local displayTable = {
				image = display.newImage(rockdef.image, x_anchor+x_offset_img, y_anchor-100),
				id = rockdef.id
			}
			main_view:insert(displayTable.image) -- 
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

	local values = {
		rock_name = getRockState().name,
		rock_hp = symbols.hp .. getRockState().curr_hp,
		rock_defense = symbols.defense .. getRockState().defense,
		rock_dollar = symbols.dollar .. getRockState().dollar,

		player_name = getPlayerState().name,
		player_dollar = symbols.dollar .. getPlayerState().dollar,
		player_gem = symbols.gem .. getPlayerState().gem,
		player_pickaxe_power = symbols.pick_power .. getPlayerState().pickaxe_power,
		player_pickaxe_quality = symbols.pick_quality .. getPlayerState().pickaxe_quality,
		player_active_multiplier = symbols.active_multiplier ..  getPlayerState().active_multiplier,
		player_passive_multiplier = symbols.passive_multiplier .. getPlayerState().passive_multiplier,
	}

	-- Lists of default textboxes. This occurs on first load
	local text_boxes = {
		r_name = Load_Screen_Texts(x_offset_rtext, y_offset_rtext, values.rock_name, 15, true),
		r_hp = Load_Screen_Texts(x_offset_rtext, y_offset_rtext+y_spacing_rtext, values.rock_hp, 15, true),
		r_defense = Load_Screen_Texts(x_offset_rtext, y_offset_rtext+y_spacing_rtext*2,values.rock_defense, 15, true),
		r_dollar = Load_Screen_Texts(x_offset_rtext, y_offset_rtext+y_spacing_rtext*3,values.rock_dollar, 15, true),
		
		p_name = Load_Screen_Texts( x_offset_ptext, 0, values.player_name, 15),
		p_dollar = Load_Screen_Texts( x_offset_ptext, y_offset_ptext, values.player_dollar, 15),
		p_gem = Load_Screen_Texts( x_offset_ptext, y_offset_ptext*2, values.player_gem, 15),
		p_pickaxe_power = Load_Screen_Texts( x_offset_ptext, y_offset_ptext*3, values.player_pickaxe_power, 15),
		p_pickaxe_quality = Load_Screen_Texts( x_offset_ptext, y_offset_ptext*4, values.player_pickaxe_quality, 15),
		p_active_multiplier = Load_Screen_Texts( x_offset_ptext, y_offset_ptext*5, values.player_active_multiplier, 15),
		p_passive_multiplier = Load_Screen_Texts( x_offset_ptext, y_offset_ptext*6, values.player_passive_multiplier, 15),
	}
	-- adds certain text_boxes to main view display container
	main_view:insert(text_boxes.r_name)
	main_view:insert(text_boxes.r_hp)
	main_view:insert(text_boxes.r_defense)
	main_view:insert(text_boxes.r_dollar)




		-- Things that need to be updated
	function Update_Values ()
		values.rock_name = getRockState().name
		values.rock_hp = symbols.hp .. getRockState().curr_hp
		values.rock_defense = symbols.defense .. getRockState().defense
		values.rock_dollar = symbols.dollar .. getRockState().dollar

		values.player_dollar = symbols.dollar .. getPlayerState().dollar
		values.player_gem = symbols.gem .. getPlayerState().gem
		values.player_pickaxe_power = symbols.pick_power .. getPlayerState().pickaxe_power
		values.player_active_multiplier = symbols.active_multiplier ..  getPlayerState().active_multiplier
		values.player_passive_multiplier = symbols.passive_multiplier .. getPlayerState().passive_multiplier

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
	end

	function Remove_Image_Table (imageTable)
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

	function Cancel_Tween()
		if prevTween then 
			transition.cancel(prevTween)
		end
		prevTween = tween 
	end
	

	function Next_Image()
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
		selectRock (loadedImgs[2].id) -- Acts as confirming function 
		print(loadedImgs[1] )
		print(loadedImgs[2] )
		print(loadedImgs[3] )

		tween = transition.to( loadedImgs[1], {time=400, Move_Image_Table(loadedImgs[1],x_anchor-x_offset_img), transition=easing.outExpo } )
		tween = transition.to( loadedImgs[2], {time=400, Move_Image_Table(loadedImgs[2],x_anchor), transition=easing.outExpo } )

		imgNum = imgNum + 1
	end

	
	function Prev_Image()
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
		selectRock (loadedImgs[2].id)
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

		-- Manual Click logic.
		mineCurrentRock()

	end

	mine_box.touch = Touch_Listener
	mine_box:addEventListener( "touch", mine_box )
	Runtime:addEventListener ("enterFrame", function (event) if display_may_need_update then Update_Values () end end)

