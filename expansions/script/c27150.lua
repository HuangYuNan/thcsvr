--院内清扫山彦✿幽谷响子
function c27150.initial_effect(c)
	Nef.AddXyzProcedureWithDesc(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),2,2,aux.Stringid(27150,0))
	c:EnableReviveLimit()
	--sp2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetDescription(aux.Stringid(27150,1))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c27150.spcon)
	e1:SetOperation(c27150.spop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27150,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c27150.discon)
	e2:SetCost(c27150.cost)
	e2:SetTarget(c27150.distg)
	e2:SetOperation(c27150.disop)
	c:RegisterEffect(e2)
	--destro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27150,3))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c27150.fuscost)
	e3:SetTarget(c27150.destg)
	e3:SetOperation(c27150.desop)
	c:RegisterEffect(e3)
end
function c27150.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and c:GetOriginalLevel()==2 and bit.band(c:GetOriginalType(),TYPE_TOKEN)~=TYPE_TOKEN
		and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_PZONE))
end
function c27150.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCountFromEx(c:GetControler())>0
		and Duel.IsExistingMatchingCard(c27150.spfilter,c:GetControler(),LOCATION_ONFIELD,0,2,nil)
end
function c27150.spop(e,tp,eg,ep,ev,re,r,rp,c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c27150.sumop)
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c27150.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,c27150.spfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	if sg:GetCount()==2 then 
		Duel.Overlay(e:GetHandler(),sg)
	else Duel.SendtoGrave(e:GetHandler(),REASON_RULE) end
end
function c27150.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
		and ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c27150.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c27150.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27150.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local c=e:GetHandler()
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		if c:IsRelateToEffect(e) then
			Duel.ChangePosition(c,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
		end
	end
end
function c27150.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c27150.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c27150.rfilter(c)
	return c:IsSetCard(0x527b) and c:IsAbleToRemove()
end
function c27150.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27150.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c27150.rfilter,tp,LOCATION_GRAVE,0,2,nil) end
	local g=Duel.GetMatchingGroup(c27150.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c27150.desop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.SelectMatchingCard(tp,c27150.rfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if rg:GetCount()==2 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(c27150.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
