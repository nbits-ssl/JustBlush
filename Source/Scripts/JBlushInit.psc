Scriptname JBlushInit extends Quest  

Quest Property JustBlushPlayer  Auto  

Event OnInit()
	if !(JustBlushPlayer.IsRunning())
		JustBlushPlayer.Start()
	endif
	self.Stop()
EndEvent
