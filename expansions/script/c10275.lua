--灵符『梦想封印 散』
function c10275.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10275.cost1)
	e1:SetCondition(c10275.con1)
	e1:SetTarget(c10275.tg1)
	e1:SetOperation(c10275.op1)
	c:RegisterEffect(e1)
	--d
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10275,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c10275.lvcost)
	e2:SetTarget(c10275.destg)
	e2:SetOperation(c10275.lvop)
	c:RegisterEffect(e2)
end
function c10275.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c10275.cfilter1(c)
	return c:IsSetCard(0x100) and c:IsFaceup()
end
function c10275.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10275.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c10275.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1000)
end
function c10275.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil):RandomSelect(tp,1)
	if Duel.Destroy(g,REASON_EFFECT)<1 then return end
	if Duel.Damage(1-tp,1000,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetTarget(c10275.tg)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10275.tg(e,c)
	return c:GetAttack()<=2000
end
function c10275.costfilter(c)
	return c:IsSetCard(0x1011) and c:IsAbleToRemoveAsCost()
end
function c10275.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(c10275.costfilter, tp, LOCATION_GRAVE, 0, e:GetHandler())
	if chk == 0 then return g:GetCount() >= 2 end
	local rg = Duel.SelectMatchingCard(tp,c10275.costfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	rg:AddCard(e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
end
function c10275.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c10275.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	local tc=g:RandomSelect(tp,1):GetFirst()

	Duel.Destroy(tc,REASON_EFFECT)
end
