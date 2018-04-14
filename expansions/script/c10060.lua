--极其普通的魔法使✿雾雨魔理沙
function c10060.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10060,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c10060.tg1)
	e1:SetOperation(c10060.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10060.con4)
	e4:SetOperation(c10060.op4)
	c:RegisterEffect(e4)
--
end
--
function c10060.tfilter1(c,e,tp)
	return c:IsSetCard(0x200) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<5
end
function c10060.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,10060)
	local fb=Duel.GetFlagEffect(tp,10061)
	local fc=fa-fb
	if chk==0 then return Duel.IsExistingMatchingCard(c10060.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and fc<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.RegisterFlagEffect(tp,10060,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c10060.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10060.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()<1 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--
function c10060.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
--
function c10060.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10061,0,0,0)
end


