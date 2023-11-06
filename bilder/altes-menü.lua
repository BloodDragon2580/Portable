	-- Center of Attention 中间为主
	elseif (me.db.profile.iconLayout == 3) then
		me.ui.button4:SetPoint("TOPLEFT", me.ui.container, "TOPLEFT", pad, -pad)
		
		me.ui.button2:SetPoint("TOPLEFT", me.ui.button4, "TOPRIGHT", space, 0)
		me.ui.button2:SetSize(size * 1 + space, size * 1 + space)
		me.ui.button2.text.name:ClearAllPoints()
		me.ui.button2.text.name:SetPoint(me.db.profile.textPos, me.ui.button2.text, me.db.profile.textPos, me.db.profile.textOffX * 1, me.db.profile.textOffY * 1)
		me:Helper_AdjustFont(me.ui.button2.text.name, me.db.profile.textFont, me.db.profile.textSize * 1, me.db.profile.textFlags)
		
		me.ui.button1:SetPoint("TOPLEFT", me.ui.button14, "TOPRIGHT",  space, 0)
		me.ui.button1:SetSize(size * 3 + space + space, size * 3 + space + space)
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2, me.db.profile.textOffY * 2)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2, me.db.profile.textFlags)
		
		me.ui.button3:SetPoint("TOPLEFT", me.ui.button1, "TOPRIGHT", space, 0)
		me.ui.button3:SetSize(size * 1 + space, size * 1 + space)
		me.ui.button3.text.name:ClearAllPoints()
		me.ui.button3.text.name:SetPoint(me.db.profile.textPos, me.ui.button3.text, me.db.profile.textPos, me.db.profile.textOffX * 1.5, me.db.profile.textOffY * 1.5)
		me:Helper_AdjustFont(me.ui.button3.text.name, me.db.profile.textFont, me.db.profile.textSize * 1.5, me.db.profile.textFlags)
		
		me.ui.button5:SetPoint("TOPLEFT", me.ui.button3, "TOPRIGHT", space, 0)
		--
		me.ui.button6:SetPoint("TOPLEFT", me.ui.button4, "BOTTOMLEFT", 0, -space)
		me.ui.button7:SetPoint("TOPLEFT", me.ui.button5, "BOTTOMLEFT", 0, -space)
		--
		me.ui.button8:SetPoint("TOPLEFT", me.ui.button6, "BOTTOMLEFT", 0, -space)
		me.ui.button9:SetPoint("TOPLEFT", me.ui.button2, "BOTTOMLEFT", 0, -space)
		me.ui.button10:SetPoint("TOPRIGHT", me.ui.button9, "BOTTOMRIGHT", 0, -space)
		me.ui.button11:SetPoint("TOPLEFT", me.ui.button3, "BOTTOMLEFT", 0, -space)
		me.ui.button12:SetPoint("TOPLEFT", me.ui.button3, "TOPLEFT", 200, -space)
		me.ui.button13:SetPoint("TOPLEFT", me.ui.button7, "BOTTOMLEFT", 0, -space)
		
		me.ui.button14:SetPoint("TOPLEFT", me.ui.button2, "TOPRIGHT", 0, -space)	
		me.ui.button15:SetPoint("TOPLEFT", me.ui.button2, "BOTTOMRIGHT", 0, -space)
		me.ui.button16:SetPoint("TOPLEFT", me.ui.button9, "BOTTOMRIGHT", 0, -space)
		me.ui.button17:SetPoint("TOPRIGHT", me.ui.button12, "BOTTOMRIGHT", 0, -space)

	-- Priority (LEFT) 优先 (左)
	if (me.db.profile.iconLayout == 1) then
		me.ui.button1:SetPoint("TOPLEFT", me.ui.container, "TOPLEFT",  pad, -pad)
		me.ui.button1:SetSize(size * 2 + space + space, size * 2 + space + space)
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2, me.db.profile.textOffY * 2)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2, me.db.profile.textFlags)
		
		me.ui.button2:SetPoint("TOPLEFT", me.ui.button1, "TOPRIGHT", space, 0)
		--me.ui.button2:SetSize(size * 1 + space, size * 1 + space)
		--me.ui.button2.text.name:ClearAllPoints()
		--me.ui.button2.text.name:SetPoint(me.db.profile.textPos, me.ui.button2.text, me.db.profile.textPos, me.db.profile.textOffX * 1, me.db.profile.textOffY * 1)
		--me:Helper_AdjustFont(me.ui.button2.text.name, me.db.profile.textFont, me.db.profile.textSize * 1, me.db.profile.textFlags)
		
		me.ui.button3:SetPoint("TOPLEFT", me.ui.button2, "TOPRIGHT", space, 0)
		me.ui.button4:SetPoint("TOPLEFT", me.ui.button3, "TOPRIGHT", space, 0)
		me.ui.button5:SetPoint("TOPLEFT", me.ui.button4, "TOPRIGHT", space, 0)		
		me.ui.button6:SetPoint("TOPLEFT", me.ui.button5, "TOPRIGHT", space, 0)
		
		me.ui.button7:SetPoint("BOTTOMLEFT", me.ui.button1, "BOTTOMRIGHT", space, -0)
		me.ui.button8:SetPoint("BOTTOMLEFT", me.ui.button7, "BOTTOMRIGHT", space, 0)
		me.ui.button9:SetPoint("BOTTOMLEFT", me.ui.button8, "BOTTOMRIGHT", space, 0)	
		me.ui.button10:SetPoint("BOTTOMLEFT", me.ui.button9, "BOTTOMRIGHT", space, 0)	
		me.ui.button11:SetPoint("BOTTOMLEFT", me.ui.button10, "BOTTOMRIGHT", space, 0)

		me.ui.button12:SetPoint("BOTTOMLEFT", me.ui.button1, "BOTTOMLEFT", space, -100)
		me.ui.button13:SetPoint("BOTTOMLEFT", me.ui.button12, "BOTTOMRIGHT", space, 0)
		me.ui.button14:SetPoint("BOTTOMLEFT", me.ui.button13, "BOTTOMRIGHT", space, 0)	
		me.ui.button15:SetPoint("BOTTOMLEFT", me.ui.button14, "BOTTOMRIGHT", space, 0)
		me.ui.button16:SetPoint("BOTTOMLEFT", me.ui.button15, "BOTTOMRIGHT", space, 0)
		me.ui.button17:SetPoint("BOTTOMLEFT", me.ui.button16, "BOTTOMRIGHT", space, 0)
		
	-- Look at Me (RIGHT) 超大! (右)
	elseif (me.db.profile.iconLayout == 5) then
		me.ui.button1:SetPoint("TOPRIGHT", me.ui.container, "TOPRIGHT",  -pad, -pad)
		me.ui.button1:SetSize(size * 4 + (space * 3), size * 4 + (space * 3))
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2.5, me.db.profile.textOffY * 2.5)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2.5, me.db.profile.textFlags)
		
		me.ui.button2:SetPoint("TOPRIGHT", me.ui.button1, "TOPLEFT", -space, 0)
		me.ui.button3:SetPoint("TOPLEFT", me.ui.button2, "BOTTOMLEFT", 0, -space)
		me.ui.button4:SetPoint("TOPLEFT", me.ui.button3, "BOTTOMLEFT", 0, -space)
		me.ui.button5:SetPoint("TOPLEFT", me.ui.button4, "BOTTOMLEFT", 0, -space)
		
		me.ui.button6:SetPoint("TOPRIGHT", me.ui.button2, "TOPLEFT", -space, 0)
		me.ui.button7:SetPoint("TOPLEFT", me.ui.button6, "BOTTOMLEFT", 0, -space)
		me.ui.button8:SetPoint("TOPLEFT", me.ui.button7, "BOTTOMLEFT", 0, -space)
		me.ui.button9:SetPoint("TOPLEFT", me.ui.button8, "BOTTOMLEFT", 0, -space)
		
		me.ui.button10:SetPoint("TOPRIGHT", me.ui.button6, "TOPLEFT", -space, 0)
		me.ui.button11:SetPoint("TOPLEFT", me.ui.button10, "BOTTOMLEFT", 0, -space)
		me.ui.button12:SetPoint("TOPLEFT", me.ui.button11, "BOTTOMLEFT", 0, -space)
		me.ui.button13:SetPoint("TOPLEFT", me.ui.button12, "BOTTOMLEFT", 0, -space)

		me.ui.button14:SetPoint("TOPRIGHT", me.ui.button10, "TOPLEFT", 0, -space)
		me.ui.button15:SetPoint("TOPRIGHT", me.ui.button12, "TOPLEFT", 0, -space)
		me.ui.button16:SetPoint("TOPRIGHT", me.ui.button13, "TOPLEFT", 0, -space)
		me.ui.button17:SetPoint("TOPLEFT", me.ui.button14, "TOPLEFT", 0, -100)
				
	-- Priority (RIGHT) 优先 (右) ... A few guildies have asked for a backwards Priority Layout, so here it is
	elseif (me.db.profile.iconLayout == 6) then
		me.ui.button1:SetPoint("TOPRIGHT", me.ui.container, "TOPRIGHT",  -pad, -pad)
		me.ui.button1:SetSize(size * 2 + space + space, size * 2 + space + space)
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2, me.db.profile.textOffY * 2)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2, me.db.profile.textFlags)
		
		me.ui.button2:SetPoint("TOPRIGHT", me.ui.button1, "TOPLEFT", -space, 0)
		--me.ui.button2:SetSize(size * 1 + space, size * 1 + space)
		--me.ui.button2.text.name:ClearAllPoints()
		--me.ui.button2.text.name:SetPoint(me.db.profile.textPos, me.ui.button2.text, me.db.profile.textPos, me.db.profile.textOffX * 1, me.db.profile.textOffY * 1)
		--me:Helper_AdjustFont(me.ui.button2.text.name, me.db.profile.textFont, me.db.profile.textSize * 1, me.db.profile.textFlags)
		
		me.ui.button3:SetPoint("TOPRIGHT", me.ui.button2, "TOPLEFT", -space, 0)
		me.ui.button4:SetPoint("TOPRIGHT", me.ui.button3, "TOPLEFT", -space, 0)
		me.ui.button5:SetPoint("TOPRIGHT", me.ui.button4, "TOPLEFT", -space, 0)
		me.ui.button6:SetPoint("TOPRIGHT", me.ui.button5, "TOPLEFT", -space, 0)
		
		me.ui.button7:SetPoint("BOTTOMRIGHT", me.ui.button1, "BOTTOMLEFT", -space, -0)
		me.ui.button8:SetPoint("BOTTOMRIGHT", me.ui.button7, "BOTTOMLEFT", -space, 0)
		me.ui.button9:SetPoint("BOTTOMRIGHT", me.ui.button8, "BOTTOMLEFT", -space, 0)
		me.ui.button10:SetPoint("BOTTOMRIGHT", me.ui.button9, "BOTTOMLEFT", -space, 0)
		me.ui.button11:SetPoint("BOTTOMRIGHT", me.ui.button10, "BOTTOMLEFT", -space, 0)
	
		me.ui.button12:SetPoint("BOTTOMRIGHT", me.ui.button1, "BOTTOMRIGHT", -space, -100)
		me.ui.button13:SetPoint("BOTTOMRIGHT", me.ui.button12, "BOTTOMLEFT", -space, 0)
		me.ui.button14:SetPoint("BOTTOMRIGHT", me.ui.button13, "BOTTOMLEFT", -space, 0)
		me.ui.button15:SetPoint("BOTTOMRIGHT", me.ui.button14, "BOTTOMLEFT", -space, 0)
		me.ui.button16:SetPoint("BOTTOMRIGHT", me.ui.button15, "BOTTOMLEFT", -space, 0)		
		me.ui.button17:SetPoint("BOTTOMRIGHT", me.ui.button16, "BOTTOMLEFT", -space, 0)