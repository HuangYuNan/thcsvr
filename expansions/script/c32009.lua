--烈日下不融的冰妖精☆晒黑了的琪露诺✿
function c32009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32009,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c32009.con1)
	e1:SetTarget(c32009.tg1)
	e1:SetOperation(c32009.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32009,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c32009.con2)
	e2:SetTarget(c32009.tg2)
	e2:SetOperation(c32009.op2)
	c:RegisterEffect(e2)
--
end
--
function c32009.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
--
function c32009.tfilter1(c)
	return c:IsSetCard(0x999) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function c32009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32009.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c32009.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c32009.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		local lg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,tc:GetCode())
		Duel.SendtoHand(lg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,lg)
	end
end
--
function c32009.con2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
--
function c32009.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
end
--
function c32009.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_DISABLE)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2_1)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetCode(EFFECT_DISABLE_EFFECT)
		e2_2:SetValue(RESET_TURN_SET)
		e2_2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2_2)
	end
end
--
