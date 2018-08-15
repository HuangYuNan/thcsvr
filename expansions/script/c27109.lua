--圣童女『大物忌正餐』
function c27109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c27109.condition)
	e1:SetTarget(c27109.target)
	e1:SetOperation(c27109.activate)
	c:RegisterEffect(e1)
end
function c27109.filter1(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function c27109.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27109.filter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsChainNegatable(ev)
end
function c27109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27109.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local sg=Duel.SelectMatchingCard(tp,c27108.filter1,tp,LOCATION_ONFIELD,0,1,1,nil)
		if sg:GetCount()<1 then return end
		local sc=sg:GetFirst()
		sc:AddCounter(0x119,9)
		end
end
