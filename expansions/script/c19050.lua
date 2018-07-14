--黑白的巫女✿雾雨魔里沙
function c19050.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x200),aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),true)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c19050.tg2)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c19050.tg3)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3) 
	--destroy
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_TOHAND)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_BATTLE_DESTROYING)
	e10:SetCondition(c19050.con10)
	e10:SetTarget(c19050.tg10)
	e10:SetOperation(c19050.op10)
	c:RegisterEffect(e10)
--
end
--
c19050.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x200),
}
--
function c19050.tg2(e,c)
	return c:GetAttack()>=e:GetHandler():GetAttack() 
		and c:GetSummonLocation()==LOCATION_EXTRA 
		and not c:IsImmuneToEffect(e) 
end
--
function c19050.tg3(e,c)
   return c:GetAttack()>=e:GetHandler():GetAttack()*2 
		and not c:IsImmuneToEffect(e)
end
--
function c19050.con10(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttacker()
	if d==c then d=Duel.GetAttackTarget() end
	return c:IsRelateToBattle() 
		and d:IsLocation(LOCATION_GRAVE) and d:IsReason(REASON_BATTLE) and d:IsType(TYPE_MONSTER)
end
--
function c19050.tg10(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local d=Duel.GetAttacker()
	if d==c then d=Duel.GetAttackTarget() end
	if chk==0 then return c:IsRelateToBattle() and d:IsLocation(LOCATION_GRAVE) and d:IsReason(REASON_BATTLE) and d:IsType(TYPE_MONSTER) and d:IsAbleToHand() end
	e:SetLabelObject(d)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,d,1,0,0)
end
--
function c19050.op10(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	if d then Duel.SendtoHand(d,tp,REASON_EFFECT) end
end
--
