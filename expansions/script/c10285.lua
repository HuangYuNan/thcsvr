--梦符『退魔符乱舞』
function c10285.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,31051)
	e1:SetCost(c10285.cost)
	e1:SetTarget(c10285.target)
	e1:SetOperation(c10285.activate)
	c:RegisterEffect(e1)
end
function c10285.cfilter(c)
	return (c:IsSetCard(0x279) or c:IsSetCard(0x1012)) and c:IsAbleToRemoveAsCost()
end
function c10285.filter(c)
	return c:IsAbleToHand() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c10285.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10285.cfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c10285.cfilter,tp,LOCATION_GRAVE,0,3,33,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetCount())
end
function c10285.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10285.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_MZONE)
end
function c10285.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10285.filter,tp,0,LOCATION_MZONE,nil)
	local hg=g:RandomSelect(tp,e:GetLabel())
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
end
