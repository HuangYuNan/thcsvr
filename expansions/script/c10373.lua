--掠日彗星『Sungrazer』
function c10373.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCost(c10373.cost)
	e1:SetTarget(c10373.target)
	e1:SetOperation(c10373.activate)
	c:RegisterEffect(e1)   
end
function c10373.sfilter(c)
	return c:IsSetCard(0x2024) and c:IsAbleToRemoveAsCost()
end
function c10373.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10373.sfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10373.sfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10373.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x200)
end
function c10373.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c10373.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10373.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10373.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(c10373.efilter)
		e2:SetOwnerPlayer(tp)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetOperation(c10373.desop)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetRange(LOCATION_MZONE)
		tc:RegisterEffect(e4)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_CHANGE_DAMAGE)
		e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e7:SetTargetRange(0,1)
		e7:SetValue(c10373.damval)
		e7:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e7,tp)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e8:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e8,tp)
	end
end
function c10373.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c10373.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c10373.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
