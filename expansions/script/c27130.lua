--大神神话圣童女✿物部布都
function c27130.initial_effect(c)
--
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x119)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c27130.val1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27130,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,27130)
	e2:SetTarget(c27130.tg2)
	e2:SetOperation(c27130.op2)
	c:RegisterEffect(e2)	
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c27130.con3)
	e3:SetOperation(c27130.op3)
	c:RegisterEffect(e3)
--
end
--
function c27130.val1(e,c)
	return Duel.GetCounter(0,1,1,0x119)*100
end
--
function c27130.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
--
function c27130.tfilter2(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c27130.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27130.tfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,sg:GetCount(),0,0)
end
--
function c27130.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c27130.tfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	if Duel.SendtoGrave(sc,REASON_EFFECT)<1 then return end
	local tg=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
	if tg:GetCount()<1 then return end
	local tc=tg:GetFirst()
	while tc do
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_DISABLE)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_1)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetCode(EFFECT_DISABLE_EFFECT)
		e2_2:SetValue(RESET_TURN_SET)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_2)
		tc=tg:GetNext()
	end
end
--
function c27130.cfilter3(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() 
		and c:IsSetCard(0x119) and not c:IsCode(27130)
end
function c27130.con3(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c27130.cfilter3,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--
function c27130.op3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,c27130.cfilter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_COST)
end
--
