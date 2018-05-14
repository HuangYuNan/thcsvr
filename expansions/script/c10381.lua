--光符『地球光』
function c10381.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10381.target)
	e1:SetOperation(c10381.operation)
	c:RegisterEffect(e1)
	--get hand
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,10381)
	e7:SetCondition(c10381.thcon)
	e7:SetTarget(c10381.thtg)
	e7:SetOperation(c10381.thop)
	c:RegisterEffect(e7)
--
end
--
function c10381.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x200) and c:GetLevel()>0
end
function c10381.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10381.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10381.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10381.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10381.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsFaceup() then return end
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_XYZ) then return end
	if tc:IsType(TYPE_LINK) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,5)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(lv)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
end
--
function c10381.cfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsControler(tp) and not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c10381.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10381.cfilter,1,nil,tp)
end
function c10381.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetCount()==1 and eg:IsExists(c10381.cfilter,1,nil,tp) end
	local tc=eg:GetFirst()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c10381.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local e7_1=Effect.CreateEffect(c)
		e7_1:SetType(EFFECT_TYPE_SINGLE)
		e7_1:SetCode(EFFECT_PUBLIC)
		e7_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e7_1)
		local e7_2=Effect.CreateEffect(c)
		e7_2:SetType(EFFECT_TYPE_SINGLE)
		e7_2:SetCode(EFFECT_CANNOT_TRIGGER)
		e7_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e7_2)
		local e7_3=Effect.CreateEffect(c)
		e7_3:SetType(EFFECT_TYPE_SINGLE)
		e7_3:SetCode(EFFECT_CANNOT_SSET)
		e7_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e7_3)
	end
end
