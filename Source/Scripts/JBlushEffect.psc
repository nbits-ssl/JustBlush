Scriptname JBlushEffect extends activemagiceffect  

Function Log(String msg)
	bool debugLogFlag = true
	
	; if (debugLogFlag)
	if (Config.debugLogFlag)
		debug.trace("[JBlush] " + msg)
	endif
EndFunction

int Function GetArousal(Actor act)
	return act.GetFactionRank(sla_Arousal)
EndFunction

; --------------------------------

string BlushTexture = "Actors\\Character\\JustBlush\\blush.dds"

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if (Config.modEnabled && self.isValidActor(akCaster))
		self.Register()
		Caster = akCaster

		if (akCaster.IsInFaction(JustBlushFaction))
			self.blushUpdate(akCaster)
		else
			self.blushInit(akCaster)
		endif
	else
		akCaster.RemoveSpell(JustBlushSpell)
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if (akCaster.IsInFaction(JustBlushFaction))
		self.blushClear(akCaster)
	endif
	self.Log("EffectFinish: " + akCaster.GetLeveledActorBase().GetName())
EndEvent

bool Function isValidActor(Actor act)
	Race actRace
	
	if (act.Is3dLoaded() && (act.isEssential() || act == PlayerActor))
		if (Config.disableKhajiit || Config.disableArgonian)
			actRace = act.GetRace()
			
			if ((Config.disableKhajiit && actRace == KhajiitRace) || \
				(Config.disableArgonian && actRace == ArgonianRace))
				
					return false
			endif
		endif
		
		return true
	endif
	
	return false
EndFunction

Function Register()
	RegisterForModEvent("HookAnimationStart", "OnSexLabSexStart")
	RegisterForModEvent("HookAnimationEnding", "OnSexLabSexEnd")
	RegisterForModevent("sla_UpdateComplete", "OnArousalComputed")
EndFunction


Event SexLabSexStart(int tid, bool hasPlayer)
	if (Caster.HasKeyWordString("SexLabActive"))
		sslThreadController controller = SexLab.GetController(tid)
		if (controller.Positions.Find(Caster))
			Utility.Wait(1.0)
			Utility.Wait(Utility.RandomFloat())
			self.Log("OnSexStart: Update")
			self.blushUpdate(Caster, true) ; bySex = true
		endif
	endif
EndEvent

Event SexLabSexEnd(int tid, bool hasPlayer)
	if (Caster.HasKeyWordString("SexLabActive"))
		sslThreadController controller = SexLab.GetController(tid)
		if (controller.Positions.Find(Caster))
			Utility.Wait(3.0)
			Utility.Wait(Utility.RandomFloat())
			self.Log("OnSexEnd: Update")
			self.blushUpdate(Caster)
		endif
	endif
EndEvent

Event OnArousalComputed(string eventName, string argString, float argNum, form sender)
	Utility.Wait(2.0)
	Utility.Wait(Utility.RandomFloat())
	self.Log("OnArousalComputed: Update")
	self.blushUpdate(Caster)
EndEvent


string Function getNode(int i)
	return "Face [Ovl" + i + "]"
EndFunction

int Function searchNode(Actor target)
	int i = 0
	string node
	bool isfemale = target.GetLeveledActorBase().GetSex() as bool
	int maxoverlays = NiOverride.GetNumFaceOverlays()
	
	While (i < maxoverlays)
		node = self.getNode(i)
		if !(NiOverride.HasNodeOverride(target, isfemale, node, 9, 0))
			return i
		endif
		i += 1
	EndWhile
	
	return -1
EndFunction

Function blushInit(Actor target)
	ActorBase actbase = target.GetLeveledActorBase()
	bool isfemale = actbase.GetSex() as bool
	int nodeID = self.searchNode(target)
	float waitTime = 0.05
	
	if (nodeID > -1)
		target.SetFactionRank(JustBlushFaction, nodeID)
		if !(NiOverride.HasOverlays(target))
			NiOverride.AddOverlays(target)
			self.Log("Init, " + actbase.GetName() + " does not have overlay, added")
		endIf
		
		self.Log("Init, " + actbase.GetName() + "'s face overlay Node ID: " + nodeID)
		
		Utility.Wait(Utility.RandomFloat())
		string node = self.getNode(nodeID)
		Utility.Wait(waitTime)
		NiOverride.AddNodeOverrideString(target, isfemale, node, 9, 0, BlushTexture, true)
		Utility.Wait(waitTime)
		NiOverride.AddNodeOverrideInt(target, isfemale, node, 0, -1, 0, true) ; emit
		Utility.Wait(waitTime)
		NiOverride.AddNodeOverrideInt(target, isfemale, node, 7, -1, 0, true) ; color
		Utility.Wait(waitTime)
		NiOverride.AddNodeOverrideFloat(target, isfemale, node, 1, -1, 1.0, true) ; emit multiple
		Utility.Wait(waitTime)
		
		self.blushUpdate(target)
	else
		self.Log("Init, Can't get face overlay node: " + actbase.GetName())
		debug.notification("[JustBlush] Can't get face overlay node")
	endif
EndFunction

Function blushUpdate(Actor target, bool bySex = false, bool byNude = false)
	if !(target)
		return
	endif
	
	ActorBase actbase = target.GetLeveledActorBase()
	bool isfemale = actbase.GetSex() as bool
	string node = self.getNode(target.GetFactionRank(JustBlushFaction))
	int arousal = self.GetArousal(target)
	float alpha = self.calcAlpha(target, arousal, bySex, byNude)
	
	self.Log("Update: " + actbase.GetName() + " arousal: " + arousal + ", alpha: " + alpha)
	
	NiOverride.AddNodeOverrideFloat(target, isfemale, node, 8, -1, alpha, true)
EndFunction

Function blushClear(Actor target)
	ActorBase actbase = target.GetLeveledActorBase()
	bool isfemale = actbase.GetSex() as bool
	string node = self.getNode(target.GetFactionRank(JustBlushFaction))

	NiOverride.RemoveAllNodeNameOverrides(target, isfemale, node)
	target.RemoveFromFaction(JustBlushFaction)

	self.Log("Clear: " + actbase.GetName())
EndFunction

float Function calcAlpha(Actor target, int arousal, bool bySex = false, bool byNude = false)
	ActorBase actbase = target.GetLeveledActorBase()
	bool isfemale = actbase.GetSex() as bool
	
	float alpha = Config.GetBaseAlpha(isfemale)
	alpha = self.weakSkinAdjust(target, alpha)
	
	if (Config.enableTestMode)
		return alpha
	elseif (bySex)
		return alpha * Config.GetSexAlpha(isfemale)
	endif
	
	if (arousal < 0)
		alpha = 0.0
	else
		alpha = alpha * arousal * 0.01
	endif
	
	if (byNude)
		return alpha + Config.GetNudeAlpha(isfemale)
	else
		return alpha
	endif
EndFunction

float Function weakSkinAdjust(Actor target, float alpha)
	int skinAdjust = 1
	float brightness = PO3_SKSEFunctions.GetSkinColor(target).GetValue()

	if (brightness * 2 < 1)
		if (Config.weakSkinAdjust)
			skinAdjust = 2
		endif
		alpha = alpha * brightness * skinAdjust
	endif
	
	return alpha
EndFunction

SexLabFramework Property SexLab  Auto

Actor Property PlayerActor  Auto  
Actor Property Caster  Auto  
SPELL Property JustBlushSpell  Auto  
Faction Property JustBlushFaction  Auto  
Faction Property sla_Arousal  Auto  

Race Property KhajiitRace  Auto  
Race Property ArgonianRace  Auto  

JBlushConfig Property Config  Auto  
