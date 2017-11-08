--秘封『月之妖鸟、化猫之幻』
function c28035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28035)
	e1:SetCost(c28035.cost)
	e1:SetTarget(c28035.target)
	e1:SetOperation(c28035.activate)
	c:RegisterEffect(e1)
	if not c28035.global_check then
		c28035.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c28035.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c28035.clear)
		Duel.RegisterEffect(ge2,0)
	end
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28035,0))
	e2:SetCategory(CATEGORY_SPSUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,280350)
	e2:SetCost(c28035.cost1)
	e2:SetTarget(c28035.target1)
	e2:SetOperation(c28035.operation)
	c:RegisterEffect(e2)
end
function c28035.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x211) then
			c28035[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c28035.clear(e,tp,eg,ep,ev,re,r,rp)
	c28035[0]=true
	c28035[1]=true
end
function c28035.cfilter(c)
	return not c:IsSetCard(0x211)
end
function c28035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c28035[tp] and Duel.GetFlagEffect(tp,28035)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTarget(aux.TargetBoolFunction(c28035.cfilter))
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c28035.tgfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToGrave() and not c:IsCode(28035)
end
function c28035.rmfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToRemove() and not c:IsCode(28035)
end
function c28035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c28035.tgfilter,tp,LOCATION_DECK,0,nil)
	return g:GetCount()>0 and Duel.IsExistingMatchingCard(c28035.rmfilter,tp,LOCATION_DECK,0,1,g:GetFirst()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c28035.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28035.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c28035.rmfilter,tp,LOCATION_DECK,0,1,1,g)
		if g2:GetCount()>0 then
			Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c28035.cfilter(c)
	return c:IsSetCard(0x211) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c28035.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c28035.cfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28035.cfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
end
function c28035.filter(c,e,tp)
	return c:IsSetCard(0x211) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28035.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c28035.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c28035.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c28035.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
