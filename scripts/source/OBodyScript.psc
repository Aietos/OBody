ScriptName OBodyScript extends Quest

import outils

bool Property ORefitEnabled auto
bool Property NippleRandEnabled auto
bool Property GenitalRandEnabled auto

int Property PresetKey auto

Actor PlayerRef

Actor Property TargetOrPlayer
	Actor Function Get()
		Actor ret = Game.GetCurrentCrosshairRef() as Actor

		If !ret
			ret = PlayerRef
		EndIf

		Return ret
	EndFunction
EndProperty


obodyscript Function Get() Global
	return GetFormFromFile(0x1800, "OBody.esp") as OBodyScript
EndFunction


Event OnInit()
	PlayerRef = Game.GetPlayer()
	Int femaleSize = OBodyNative.GetFemaleDatabaseSize()
	Int maleSize = OBodyNative.GetMaleDatabaseSize()
	Debug.Notification("OBody Installed: [F: " + femaleSize + "] [M: " + maleSize + "]")

	OUtils.getOStim().RegisterForGameLoadEvent(self)
	RegisterForOUpdate(self)

	OnLoad()
EndEvent


Function OnLoad()
	RegisterForKey(PresetKey)
	OBodyNative.SetORefit(ORefitEnabled)
	OBodyNative.SetNippleRand(NippleRandEnabled)
	OBodyNative.SetGenitalRand(GenitalRandEnabled)
EndFunction


Function updatePresetKey(int previousKey)
	UnregisterForKey(previousKey)
	RegisterForKey(PresetKey)
EndFunction


int Function GetAPIVersion()
	return 2
endfunction 


Event OnGameLoad()
	OnLoad()
EndEvent


Event OnKeyDown(int KeyPress)
	If outils.MenuOpen()
		Return
	EndIf

	if KeyPress == PresetKey
		ShowPresetMenu(TargetOrPlayer)
	endif
EndEvent


Function ShowPresetMenu(Actor act)
	Debug.Notification("Editing " + act.GetDisplayName())
	UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	listMenu.ResetMenu()

	string[] title = new String[1]
	title[0] = "-   OBody    -"

	string[] presets = OBodyNative.GetAllPossiblePresets(act)
	int l = presets.Length
	Console((l) + " presets found")

	int pagesNeeded
	If l > 125
		pagesNeeded = (l / 125) + 1

		int i = 0
		While i < pagesNeeded
			listMenu.AddEntryItem("OBody set " + (i + 1))
			i += 1
		EndWhile

		listMenu.OpenMenu(act)
		int num = listMenu.GetResultInt()
		If num < 0
			Return
		EndIf

		int startingPoint = num * 125
		int endPoint
		If num == (pagesNeeded - 1) ; last set
			endPoint = presets.Length - 1
		Else
			endPoint = startingPoint + 124
		EndIf

		listMenu.ResetMenu()
		presets = PapyrusUtil.SliceStringArray(presets, startingPoint, endPoint)
	EndIf

	presets = PapyrusUtil.MergeStringArray(title, presets)

	int i = 0
	int max = presets.length
	While (i < max)
		listMenu.AddEntryItem(presets[i])
		i += 1
	EndWhile

	listMenu.OpenMenu(act)
	string result = listMenu.GetResultString()

	int num = listMenu.GetResultInt()
	If !(num < 1)
		OBodyNative.ApplyPresetByName(act, result)
		Console("Applying: " + result)

		int me = ModEvent.Create("obody_manualchange")
		ModEvent.PushForm(me, act)
		ModEvent.Send(me)
	EndIf
EndFunction
