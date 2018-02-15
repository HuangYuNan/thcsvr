--风神『风神木叶隐身术』
function c23257.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23257.target)
	e1:SetOperation(c23257.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23257,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c23257.thcost)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c23257.filter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(c23257.filter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c23257.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
end
function c23257.filter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAbleToHand()
end
function c23257.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsPosition(POS_FACEUP_ATTACK) and chkc:IsSetCard(0x208) and chkc:IsRace(RACE_WINDBEAST+RACE_BEASTWARRIOR) end
	if chk==0 then return Duel.IsExistingTarget(function(c) return
		c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0x208) and c:IsRace(RACE_WINDBEAST+RACE_BEASTWARRIOR) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,function(c) return
		c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0x208) and c:IsRace(RACE_WINDBEAST+RACE_BEASTWARRIOR) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c23257.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(aux.imval1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e2:SetValue(aux.tgoval)
		tc:RegisterEffect(e2)
	end
end
function c23257.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c23257.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c23257.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23257.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end