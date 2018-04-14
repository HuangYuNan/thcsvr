--战符「小小军势」
function c20075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20075.condition)
	e1:SetCost(Senya.DiscardHandCost(1))
	e1:SetTarget(c20075.target)
	e1:SetOperation(c20075.activate)
	c:RegisterEffect(e1)
end
function c20075.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c20075.cfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x186)
end
function c20075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20075.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c20075.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c20075.filter(c,e,tp)
	return c:IsSetCard(0x186) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttackBelow(1000)
end
function c20075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>2
		and Duel.IsExistingMatchingCard(c20075.filter,tp,LOCATION_DECK,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK)
end
function c20075.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20075.filter,tp,LOCATION_DECK,0,3,3,nil,e,tp)
	if g:GetCount()>2 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetOperation(c20075.desop)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(100)
			tc:RegisterEffect(e2)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			e5:SetValue(1)
			tc:RegisterEffect(e5)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function c20075.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
