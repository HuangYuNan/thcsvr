--四季隐星-究极的绝对秘神✿摩多罗隐岐奈
function c32047.initial_effect(c)
c:EnableReviveLimit()
c32047.dfc_front_side=32035
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c32047.con1)
	e1:SetValue(1800)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c32047.efilter2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c32047.indesval3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32047,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c32047.cost4)
	e4:SetTarget(c32047.tg4)
	e4:SetOperation(c32047.op4)
	c:RegisterEffect(e4)
end
function c32047.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<1
end
function c32047.efilter2(e,te)
	return te:IsActiveType(TYPE_MONSTER) 
		and te:GetHandler():GetLevel()~=12
end
function c32047.indesval3(e,re,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function c32047.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c32047.tfilter4(c,p)
	return Duel.IsPlayerCanSendtoGrave(p,c)
end
function c32047.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct=sg:GetCount()
		-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)*2
	if chk==0 then return ct>0 and sg:IsExists(c32047.tfilter4,1,nil,1-tp) and not Duel.IsPlayerAffectedByEffect(1-tp,30459350) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,ct,0,0)
end
function c32047.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(1-tp,30459350) then return end
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct=sg:GetCount()
		-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)*2
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local tg=sg:FilterSelect(1-tp,c32047.tfilter4,ct,ct,nil,1-tp)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end