/mob/living/silicon/ai
	var/fireloss = 0
	var/bruteloss = 0
	var/oxyloss = 0

/mob/living/silicon/ai/getFireLoss()
	return fireloss

/mob/living/silicon/ai/getBruteLoss()
	return bruteloss

/mob/living/silicon/ai/getOxyLoss()
	return oxyloss

/mob/living/silicon/ai/adjustFireLoss(var/amount)
	if(status_flags & GODMODE) return
	fireloss = max(0, fireloss + min(amount, health))

/mob/living/silicon/ai/adjustBruteLoss(var/amount)
	if(status_flags & GODMODE) return
	bruteloss = max(0, bruteloss + min(amount, health))

/mob/living/silicon/ai/adjustOxyLoss(var/amount)
	if(status_flags & GODMODE) return
	oxyloss = max(0, oxyloss + min(amount, max_health - oxyloss))

/mob/living/silicon/ai/setFireLoss(var/amount)
	if(status_flags & GODMODE)
		fireloss = 0
		return
	fireloss = max(0, amount)

/mob/living/silicon/ai/setOxyLoss(var/amount)
	if(status_flags & GODMODE)
		oxyloss = 0
		return
	oxyloss = max(0, amount)

/mob/living/silicon/ai/updatehealth()
	if(status_flags & GODMODE)
		health = max_health
		set_stat(CONSCIOUS)
		setOxyLoss(0)
	else
		health = max_health - getFireLoss() - getBruteLoss() // Oxyloss is not part of health as it represents AIs backup power. AI is immune against ToxLoss as it is machine.

/mob/living/silicon/ai/rejuvenate()
	..()
	add_ai_verbs(src)

// Returns percentage of AI's remaining backup capacitor charge (max_health - oxyloss).
/mob/living/silicon/ai/proc/backup_capacitor()
	return ((getOxyLoss() - max_health) / max_health) * (-100)

// Returns percentage of AI's remaining hardware integrity (max_health - (bruteloss + fireloss))
/mob/living/silicon/ai/proc/hardware_integrity()
	return (health / max_health) * 100