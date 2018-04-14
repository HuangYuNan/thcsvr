--决斗胜负！
function c10067.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10067.con1)
	e1:SetTarget(c10067.tg1)
	e1:SetOperation(c10067.op1)
	c:RegisterEffect(e1)
--
end
--
function c10067.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1
end
--
function c10067.tfilter1(c,e,tp)
	return (c:IsSetCard(0x100) or c:IsSetCard(0x200)) and c:GetLevel()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c10067.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10067.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c10067.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10067.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()<1 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
--
