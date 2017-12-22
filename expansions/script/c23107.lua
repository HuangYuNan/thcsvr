--水符『河童光学大激波』
function c23107.initial_effect(c)
	--Activate(jb)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c23107.target)
	e1:SetOperation(c23107.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c23107.descon)
	e3:SetTarget(c23107.target)
	e3:SetOperation(c23107.activate)
	c:RegisterEffect(e3)
end
function c23107.cfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_LINK
end
function c23107.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23107.cfilter,1,nil)
end
function c23107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c23107.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
