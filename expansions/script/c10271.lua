--灵符『梦想封印』
function c10271.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10271.cost1)
	e1:SetCondition(c10271.con1)
	e1:SetTarget(c10271.tg1)
	e1:SetOperation(c10271.op1)
	c:RegisterEffect(e1)
--
end
--
function c10271.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
--
function c10271.cfilter1(c)
	return c:IsSetCard(0x100) and c:IsFaceup()
end
function c10271.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10271.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c10271.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
--
function c10271.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Destroy(tc,REASON_EFFECT)<1 then return end
	if Duel.Damage(1-tp,1000,REASON_EFFECT)>0 then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetProperty(EFFECT_FLAG_OATH)
		e1_1:SetCode(EFFECT_CANNOT_ATTACK)
		e1_1:SetTargetRange(0,LOCATION_MZONE)
		e1_1:SetTarget(c10271.tg1_1)
		e1_1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1_1,tp)
	end
end
--
function c10271.tg1_1(e,c)
	return c:GetAttack()>1999
end
--
