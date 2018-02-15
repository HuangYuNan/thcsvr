--鸦符『乌鸦的暗影』
function c23254.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e1:SetTarget(c23254.target)
	e1:SetOperation(c23254.activate)
	c:RegisterEffect(e1)
end
function c23254.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c23254.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c23254.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23254.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c23254.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetFirst():IsType(TYPE_MONSTER) then Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0) end
end
function c23254.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_MONSTER) then 
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		else 
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tc:GetControler(),0)
		end
	end
end
