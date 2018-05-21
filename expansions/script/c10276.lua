--灵符『梦想樱花封印』
function c10276.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10276.cost1)
	e1:SetCondition(c10276.con1)
	e1:SetTarget(c10276.target)
	e1:SetOperation(c10276.op1)
	c:RegisterEffect(e1)
end
function c10276.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c10276.cfilter1(c)
	return c:IsSetCard(0x100) and c:IsFaceup()
end
function c10276.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10276.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c10276.rfilter(c)
	return c:IsAbleToRemove()
end
function c10276.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and c10276.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10276.rfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10276.rfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10276.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		if Duel.Recover(tp,1000,REASON_EFFECT)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetTarget(c10276.tg1)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c10276.tg1(e,c)
	return c:GetAttack()<=2000
end
