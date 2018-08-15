--地藏『罪业救赎』
function c32022.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c32022.tg1)
	e1:SetOperation(c32022.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,32022+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c32022.con2)
	e2:SetTarget(c32022.tg2)
	e2:SetOperation(c32022.op2)
	c:RegisterEffect(e2)
--
end
--
function c32022.tfilter1(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x410)
end
function c32022.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32022.tfilter1,tp,LOCATION_GRAVE+LOCATION_PZONE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_PZONE+LOCATION_EXTRA)
end
--
function c32022.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,c32022.tfilter1,tp,LOCATION_GRAVE+LOCATION_PZONE+LOCATION_EXTRA,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c32022.cfilter2(c)
	return c:IsLocation(LOCATION_HAND) 
		or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5)
end
function c32022.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c32022.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
end
--
function c32022.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
--
function c32022.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
--
