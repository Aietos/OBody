Scriptname OBodyMCMScript extends SKI_ConfigBase

; Settings
int setORefit
int setNippleRandomization
int setGenitalRandomization
int setPresetListKey


OBodyScript property OBody auto


event OnInit()
	parent.OnInit()

	Modname = "OBody NG"
endEvent


event OnGameReload()
	parent.onGameReload()
endevent


event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)

	setORefit = AddToggleOption("$obody_option_refit", OBody.ORefitEnabled)
	setNippleRandomization = AddToggleOption("$obody_option_nipple", OBody.NippleRandEnabled)
	setGenitalRandomization = AddToggleOption("$obody_option_genitals", OBody.GenitalRandEnabled)
	setPresetListKey = AddKeyMapOption("$obody_option_preset_key", OBody.PresetKey)
endEvent


event OnOptionSelect(int option)
	if (option == setORefit)
		OBody.ORefitEnabled = !OBody.ORefitEnabled
		SetToggleOptionValue(setORefit, OBody.ORefitEnabled)
	elseif (option == setNippleRandomization)
		OBody.NippleRandEnabled = !OBody.NippleRandEnabled
		SetToggleOptionValue(setNippleRandomization, OBody.NippleRandEnabled)
	elseif (option == setGenitalRandomization)
		OBody.GenitalRandEnabled = !OBody.GenitalRandEnabled
		SetToggleOptionValue(setGenitalRandomization, OBody.GenitalRandEnabled)
	endif
endEvent


event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	If (option == setPresetListKey)
		bool continue = true

		if (conflictControl != "")
			string msg

			if (conflictName != "")
				msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
			else
				msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
			endIf

			continue = ShowMessage(msg, true, "$obody_message_box_option_yes", "$obody_message_box_option_no")
		endIf

		if (continue)
			int previousKey = OBody.PresetKey
			OBody.PresetKey = keyCode
			SetKeymapOptionValue(setPresetListKey, keyCode)
			OBody.updatePresetKey(previousKey)
		endIf
	EndIf
endEvent


event OnOptionHighlight(int option)
	if (option == setORefit)
		SetInfoText("$obody_highlight_refit")
	elseif (option == setNippleRandomization)
		SetInfoText("$obody_highlight_nipple")
	elseif (option == setGenitalRandomization)
		SetInfoText("$obody_highlight_genitals")
	elseif (option == setPresetListKey)
		SetInfoText("$obody_highlight_preset_key")
	endif
endEvent
