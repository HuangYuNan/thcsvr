--鸦符『暗夜之砾』
function c23253.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(23253,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--activate (return)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23253,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c23253.thcost)
	e1:SetTarget(c23253.thtg1)
	e1:SetOperation(c23253.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c23253.condition)
	e3:SetOperation(c23253.operation)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--less damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c23253.con)
	e4:SetOperation(c23253.op)
	c:RegisterEffect(e4)
end
function c23253.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(23253)==0 end
	e:GetHandler():RegisterFlagEffect(23253,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c23253.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c23253.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c23253.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23253.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c23253.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c23253.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(c23253.thfilter,tp,0,LOCATION_GRAVE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(23253,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		end
	end
end
function c23253.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23253.tpfilter,1,nil,tp)
end
function c23253.tpfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c23253.operation(e,tp,eg,ep,ev,re,r,rp)
	local dmg=eg:GetCount()*500
	Duel.Damage(1-tp,dmg,REASON_EFFECT)
end
function c23253.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and Duel.IsExistingMatchingCard(c23253.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c23253.cfilter(c)
	return c:IsSetCard(0x125) and c:IsFaceup()
end
function c23253.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,23253)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c23253.condition)
	e3:SetOperation(c23253.operation2)
	Duel.RegisterEffect(e3,tp)
	local e6=e3:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e6,tp)
end
function c23253.operation2(e,tp,eg,ep,ev,re,r,rp)
	local dmg=eg:GetCount()*100
	Duel.Damage(1-tp,dmg,REASON_EFFECT)
end
