Scriptname JBlushConfig extends SKI_ConfigBase  

bool Property modEnabled = true Auto
bool Property enableTestMode = false Auto
bool Property debugLogFlag = false Auto

bool Property weakSkinAdjust = false Auto

int Property baseAlphaMale = 75 Auto
int Property sexAlphaMale = 100 Auto
int Property nudeAlphaMale = 10 Auto
int Property baseAlphaFemale = 75 Auto
int Property sexAlphaFemale = 100 Auto
int Property nudeAlphaFemale = 50 Auto

bool Property disableKhajiit = false Auto
bool Property disableArgonian = false Auto

int modEnabledID
int enableTestModeID
int debugLogFlagID

int weakSkinAdjustID

int baseAlphaMaleID
int sexAlphaMaleID
int nudeAlphaMaleID
int baseAlphaFemaleID
int sexAlphaFemaleID
int nudeAlphaFemaleID

int disableKhajiitID
int disableArgonianID

int configSaveID
int configLoadID

string configFileName = "../JustBlushConfig.json"

int Function GetVersion()
	return 20210715
EndFunction 

Event OnConfigInit()
	Pages = new string[2]
	Pages[0] = "$JBlushConfig"
	Pages[1] = "$JBlushLevel"
EndEvent

Event OnPageReset(string page)

	if (page == "" || page == "$JBlushConfig")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$JBlushSystem")
		modEnabledID = AddToggleOption("$JBlushEnable", modEnabled)
		
		AddEmptyOption()
		
		AddHeaderOption("$JBlushDebug")
		enableTestModeID = AddToggleOption("$JBlushEnableTestMode", enableTestMode)
		debugLogFlagID = AddToggleOption("$JBlushDebugLogFlag", debugLogFlag)
		
		SetCursorPosition(1)
		
		AddHeaderOption("$JBlushProfile")

		configSaveID = AddTextOption("$JBlushConfigSave", "$JBlushDoIt")
		if (JsonUtil.JsonExists(configFileName))
			configLoadID = AddTextOption("$JBlushConfigLoad", "$JBlushDoIt")
		else
			configLoadID = AddTextOption("$JBlushConfigLoad", "$JBlushDoIt", OPTION_FLAG_DISABLED)
		endif
		
	elseif (page == "$JBlushLevel")

		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$JBlushLevelSystem")
		
		weakSkinAdjustID = AddToggleOption("$JBlushWeakSkinAdjust", weakSkinAdjust)
		
		AddEmptyOption()

		AddHeaderOption("$JBlushLevelConfig")
		
		baseAlphaMaleID = AddSliderOption("$JBlushBaseAlphaMale", baseAlphaMale)
		sexAlphaMaleID = AddSliderOption("$JBlushSexAlphaMale", sexAlphaMale)
		nudeAlphaMaleID = AddSliderOption("$JBlushNudeAlphaMale", nudeAlphaMale)

		baseAlphaFemaleID = AddSliderOption("$JBlushBaseAlphaFemale", baseAlphaFemale)
		sexAlphaFemaleID = AddSliderOption("$JBlushSexAlphaFemale", sexAlphaFemale)
		nudeAlphaFemaleID = AddSliderOption("$JBlushNudeAlphaFemale", nudeAlphaFemale)

		SetCursorPosition(1)

		AddHeaderOption("$JBlushDisableRace")
		disableKhajiitID = AddToggleOption("$JBlushDisbleKhajiit", disableKhajiit)
		disableArgonianID = AddToggleOption("$JBlushDisbleArgonian", disableArgonian)
	endif
EndEvent

Event OnOptionHighlight(int option)
	if (option == modEnabledID)
		SetInfoText("$JBlushEnableInfo")
	elseif (option == enableTestModeID)
		SetInfoText("$JBlushEnableTestModeInfo")
	elseif (option == configSaveID)
		SetInfoText("$JBlushConfigSaveInfo")
	elseif (option == configLoadID)
		SetInfoText("$JBlushConfigLoadInfo")
	elseif (option == weakSkinAdjustID)
		SetInfoText("$JBlushWeakSkinAdjustInfo")
	elseif (option == baseAlphaMaleID || option == baseAlphaFemaleID)
		SetInfoText("$JBlushBaseAlphaInfo")
	elseif (option == sexAlphaMaleID || option == sexAlphaFemaleID)
		SetInfoText("$JBlushSexAlphaInfo")
	elseif (option == nudeAlphaMaleID || option == nudeAlphaFemaleID)
		SetInfoText("$JBlushNudeAlphaInfo")
	endif
EndEvent

Event OnOptionSelect(int option)
	if (option == modEnabledID)
		modEnabled = !modEnabled
		SetToggleOptionValue(option, modEnabled)
		; ###############FIXME####################
	elseif (option == enableTestModeID)
		enableTestMode = !enableTestMode
		SetToggleOptionValue(option, enableTestMode)
		; ###############FIXME####################
	elseif (option == debugLogFlagID)
		debugLogFlag = !debugLogFlag
		SetToggleOptionValue(option, debugLogFlag)

	elseif (option == configSaveID)
		self.saveConfig(configFileName)
		SetTextOptionValue(option, "$JBlushDone")
	elseif (option == configLoadID)
		self.loadConfig(configFileName)
		SetTextOptionValue(option, "$JBlushDone")

	elseif (option == weakSkinAdjustID)
		weakSkinAdjust = !weakSkinAdjust
		SetToggleOptionValue(option, weakSkinAdjust)
	elseif (option == disableKhajiitID)
		disableKhajiit = !disableKhajiit
		SetToggleOptionValue(option, disableKhajiit)
	elseif (option == disableArgonianID)
		disableArgonian = !disableArgonian
		SetToggleOptionValue(option, disableArgonian)
	endif
EndEvent

Event OnOptionSliderOpen(int option)
	if (option == baseAlphaMaleID)
		SetSliderDialogDefaultValue(75)
		self._setSliderDialogWithPercentage(baseAlphaMale)
	elseif (option == sexAlphaMaleID)
		SetSliderDialogDefaultValue(100)
		self._setSliderDialogWithPercentage(sexAlphaMale)
	elseif (option == nudeAlphaMaleID)
		SetSliderDialogDefaultValue(10)
		self._setSliderDialogWithPercentage(nudeAlphaMale)
	elseif (option == baseAlphaFemaleID)
		SetSliderDialogDefaultValue(75)
		self._setSliderDialogWithPercentage(baseAlphaFemale)
	elseif (option == sexAlphaFemaleID)
		SetSliderDialogDefaultValue(100)
		self._setSliderDialogWithPercentage(sexAlphaFemale)
	elseif (option == nudeAlphaFemaleID)
		SetSliderDialogDefaultValue(50)
		self._setSliderDialogWithPercentage(nudeAlphaFemale)
	endif
EndEvent

Function _setSliderDialogWithPercentage(int x)
	SetSliderDialogStartValue(x)
	SetSliderDialogRange(0.0, 100.0)
	SetSliderDialogInterval(1.0)
EndFunction

Event OnOptionSliderAccept(int option, float value)
	int ivalue = value as int
	
	if (option == baseAlphaMaleID)
		baseAlphaMale = ivalue
	elseif (option == sexAlphaMaleID)
		sexAlphaMale = ivalue
	elseif (option == nudeAlphaMaleID)
		nudeAlphaMale = ivalue
	elseif (option == baseAlphaFemaleID)
		baseAlphaFemale = ivalue
	elseif (option == sexAlphaFemaleID)
		sexAlphaFemale = ivalue
	elseif (option == nudeAlphaFemaleID)
		nudeAlphaFemale = ivalue
	endif
	
	SetSliderOptionValue(option, ivalue)
EndEvent


Function saveConfig(string configFile)
	JsonUtil.SetIntValue(configFile, "modEnabled", modEnabled as int)
	JsonUtil.SetIntValue(configFile, "enableTestMode", enableTestMode as int)
	JsonUtil.SetIntValue(configFile, "debugLogFlag", debugLogFlag as int)

	JsonUtil.SetIntValue(configFile, "weakSkinAdjust", weakSkinAdjust as int)

	JsonUtil.SetIntValue(configFile, "baseAlphaMale", baseAlphaMale)
	JsonUtil.SetIntValue(configFile, "sexAlphaMale", sexAlphaMale)
	JsonUtil.SetIntValue(configFile, "nudeAlphaMale", nudeAlphaMale)
	JsonUtil.SetIntValue(configFile, "baseAlphaFemale", baseAlphaFemale)
	JsonUtil.SetIntValue(configFile, "sexAlphaFemale", sexAlphaFemale)
	JsonUtil.SetIntValue(configFile, "nudeAlphaFemale", nudeAlphaFemale)

	JsonUtil.SetIntValue(configFile, "disableKhajiit", disableKhajiit as int)
	JsonUtil.SetIntValue(configFile, "disableArgonian", disableArgonian as int)

	JsonUtil.Save(configFile)
EndFunction

Function loadConfig(string configFile)
	modEnabled = JsonUtil.GetIntValue(configFile, "modEnabled")
	enableTestMode = JsonUtil.GetIntValue(configFile, "enableTestMode")
	debugLogFlag = JsonUtil.GetIntValue(configFile, "debugLogFlag")

	weakSkinAdjust = JsonUtil.GetIntValue(configFile, "weakSkinAdjust")

	baseAlphaMale = JsonUtil.GetIntValue(configFile, "baseAlphaMale")
	sexAlphaMale = JsonUtil.GetIntValue(configFile, "sexAlphaMale")
	nudeAlphaMale = JsonUtil.GetIntValue(configFile, "nudeAlphaMale")
	baseAlphaFemale = JsonUtil.GetIntValue(configFile, "baseAlphaFemale")
	sexAlphaFemale = JsonUtil.GetIntValue(configFile, "sexAlphaFemale")
	nudeAlphaFemale = JsonUtil.GetIntValue(configFile, "nudeAlphaFemale")

	disableKhajiit = JsonUtil.GetIntValue(configFile, "disableKhajiit")
	disableArgonian = JsonUtil.GetIntValue(configFile, "disableArgonian")
EndFunction

float Function GetBaseAlpha(bool isfemale)
	float alpha
	
	if (isfemale)
		alpha = baseAlphaFemale
	else
		alpha = baseAlphaMale
	endif
	
	return alpha * 0.01
EndFunction

float Function GetSexAlpha(bool isfemale)
	float alpha
	
	if (isfemale)
		alpha = sexAlphaFemale
	else
		alpha = sexAlphaMale
	endif

	return alpha * 0.01
EndFunction

float Function GetNudeAlpha(bool isfemale)
	float alpha
	
	if (isfemale)
		alpha = nudeAlphaFemale
	else
		alpha = nudeAlphaMale
	endif

	return alpha * 0.01
EndFunction
