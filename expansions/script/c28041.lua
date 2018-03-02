--秘封冒险家✿莲子
function c28041.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28041,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c28041.cost1)
	e1:SetTarget(c28041.tg1)
	e1:SetOperation(c28041.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c28041.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
--
end
--
function c28041.cfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x211)
end
function c28041.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28041.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c28041.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c28041.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
--
function c28041.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--
function c28041.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(28041,1))
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_PHASE+PHASE_END)
	e2_1:SetCountLimit(1)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	e2_1:SetCondition(c28041.con2_1)
	e2_1:SetOperation(c28041.op2_1)
	Duel.RegisterEffect(e2_1,tp)
end
--
function c28041.cfilter2_1(c,e,tp)
	return c:IsSetCard(0x211) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c28041.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28041.cfilter2_1,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c28041.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c28041.cfilter2_1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	local e2_1_1=Effect.CreateEffect(c)
	e2_1_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1_1:SetCode(EFFECT_DISABLE)
	e2_1_1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_1_1,true)
	local e2_1_2=Effect.CreateEffect(c)
	e2_1_2:SetType(EFFECT_TYPE_SINGLE)
	e2_1_2:SetCode(EFFECT_DISABLE_EFFECT)
	e2_1_2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_1_2,true)
	Duel.SpecialSummonComplete()
end
--

