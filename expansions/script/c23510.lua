--速度与天狗的连结✿射命丸文
function c23510.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c23510.matfilter,2,3)
	c:EnableReviveLimit()
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23510,0))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCondition(c23510.condition)
	e3:SetTarget(c23510.target)
	e3:SetOperation(c23510.operation)
	c:RegisterEffect(e3)
	--double atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23510,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c23510.atkcost)
	e1:SetOperation(c23510.atkop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23510,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c23510.dacost)
	e2:SetOperation(c23510.daop)
	c:RegisterEffect(e2)
end
function c23510.matfilter(c)
	return not c:IsLinkType(TYPE_PENDULUM) and c:IsLinkType(TYPE_EFFECT)
end
function c23510.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c23510.filter(c)
	return c:IsAbleToDeck()
end
function c23510.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=e:GetHandler():GetMaterial():Filter(c23510.filter,nil)
	if chk==0 then return mg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,mg,mg:GetCount(),0,0)
end
function c23510.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetHandler():GetMaterial():Filter(c23510.filter,nil)
	Duel.SendtoDeck(mg,nil,1,REASON_EFFECT)
end
function c23510.cfilter(c)
	return c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c23510.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23510.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c23510.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c23510.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c23510.dfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c23510.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23510.dfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c23510.dfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c23510.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
