--钓瓶『连接异世的吊索』
function c24153.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c24153.target)
	e1:SetOperation(c24153.activate)
	c:RegisterEffect(e1)
end
function c24153.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetAttack()>=1500 and c:GetSummonType()==SUMMON_TYPE_LINK
		and c:GetSummonPlayer()~=tp and c:IsAbleToRemove() and c:IsType(TYPE_LINK)
end
function c24153.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c24153.filter,1,nil,tp) end
	local g=eg:Filter(c24153.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c24153.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT,LOCATION_REMOVED)
	end
end
