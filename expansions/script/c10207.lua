--快晴的巫女✿博丽灵梦
function c10207.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10207.con1)
	e1:SetOperation(c10207.op1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10207.con2)
	e2:SetOperation(c10207.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,10207)
	e3:SetCondition(c10207.con3)
	e3:SetOperation(c10207.op3)
	c:RegisterEffect(e3)
--
end
--
function c10207.cfilter1_1(c)
	return c:IsCode(10000) and c:IsFaceup()
end
function c10207.con1(e,c)
	local fa=Duel.GetFlagEffect(tp,10207)
	local fb=Duel.GetFlagEffect(tp,10208)
	local fc=fa-fb
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10207.cfilter1_1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and fc<1 
end
--
function c10207.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	Duel.RegisterFlagEffect(p,10207,0,0,0)
end
--
function c10207.cfilter2(c)
	return c:IsSetCard(0x10a) and c:IsSSetable()
end
function c10207.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c10207.cfilter2,tp,LOCATION_DECK,0,1,nil) and c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
--
function c10207.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10207.cfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
	Duel.SSet(tp,tc)
	Duel.ConfirmCards(1-tp,tc)
end
--
function c10207.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
end
--
function c10207.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10208,0,0,0)
end
--
