Scriptname OBodyNGMCMScript extends SKI_ConfigBase

; Settings
int setORefit
int setNippleRandomization
int setGenitalRandomization
int setPresetListKey
int setResetBodyDistribution
int setResetActor
int setPerformanceMode


OBodyNGScript property OBody auto


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
	setPerformanceMode = AddToggleOption("$obody_option_performance_mode", OBody.PerformanceMode)

	AddEmptyOption()

	setPresetListKey = AddKeyMapOption("$obody_option_preset_key", OBody.PresetKey)

	AddEmptyOption()

	setResetBodyDistribution = AddToggleOption("$obody_option_reset_distribution", false)

	AddEmptyOption()

	Actor actorInCrosshair = Game.GetCurrentCrosshairRef() as Actor

	if actorInCrosshair == none
		actorInCrosshair = OBody.PlayerRef
	endif

	setResetActor = AddTextOption("$obody_option_reset_actor", actorInCrosshair.GetActorBase().GetName())
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
	elseif (option == setPerformanceMode)
		if (OBody.PerformanceMode)
			bool continue = ShowMessage("$obody_message_performance_mode")

			if continue
				OBody.PerformanceMode = false
				SetToggleOptionValue(setPerformanceMode, OBody.PerformanceMode)
			endif
		else
			OBody.PerformanceMode = true
			SetToggleOptionValue(setPerformanceMode, OBody.PerformanceMode)
		endif
	elseif (option == setResetBodyDistribution)
		bool continue = ShowMessage("$obody_message_reset_distribution")

		if continue
			OBody.ResetDistribution()

			ShowMessage("$obody_message_reset_distribution_success", false)
		endif
	elseif (option == setResetActor)
		Actor actorInCrosshair = Game.GetCurrentCrosshairRef() as Actor

		if actorInCrosshair == none
			actorInCrosshair = OBody.PlayerRef
		endif

		if (actorInCrosshair)
			OBodyNative.ResetActorOBodyMorphs(actorInCrosshair)
			StorageUtil.UnsetStringValue(none, "obody_" + actorInCrosshair.GetActorBase().GetName() + "_preset")
			StorageUtil.UnsetStringValue(none, "obody_" + actorInCrosshair.GetFormID() + "_preset")
		endif

		ShowMessage("$obody_message_reset_actor", false)
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
	elseif (option == setPerformanceMode)
		SetInfoText("$obody_highlight_performance_mode")
	elseif (option == setResetBodyDistribution)
		SetInfoText("$obody_highlight_reset_distribution")
	elseif (option == setResetActor)
		SetInfoText("$obody_highlight_reset_actor")
	endif
endEvent
