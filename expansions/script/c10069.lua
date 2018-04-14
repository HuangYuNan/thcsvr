--魔符『幻象之星』
function c10069.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c10069.cost1)
	e1:SetTarget(c10069.tg1)
	e1:SetOperation(c10069.op1)
	c:RegisterEffect(e1)
--
end
--
function c10069.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c10069.tfilter1(c,e,tp)
	local seq=c:GetSequence()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x200) and Duel.IsExistingMatchingCard(c10069.tfilter1_1,tp,LOCATION_DECK,0,1,nil,e,tp)
		and (ft>1 or (seq<5 and ft>0))
end
function c10069.tfilter1_1(c,e,tp)
	return c:IsSetCard(0x200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10069.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10069.tfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,10070,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,10070,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND,POS_FACEUP,1-tp)
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c10069.tfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoHand(tc,nil,REASON_COST)
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
--
function c10069.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not tc then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10069.tfilter1_1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()<1 then return end
	local sc=g:GetFirst()
	if not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10070,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10070,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND,POS_FACEUP,1-tp) then return end
	Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_PHASE+PHASE_END)
	e1_2:SetRange(LOCATION_MZONE)
	e1_2:SetCountLimit(1)
	e1_2:SetOperation(c10069.op1_2)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	sc:RegisterEffect(e1_2,true)
	local token1=Duel.CreateToken(tp,10070)
	Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_PHASE+PHASE_END)
	e1_2:SetRange(LOCATION_MZONE)
	e1_2:SetCountLimit(1)
	e1_2:SetOperation(c10069.op1_2)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	token1:RegisterEffect(e1_2,true)
	local token2=Duel.CreateToken(tp,10070)
	Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_PHASE+PHASE_END)
	e1_2:SetRange(LOCATION_MZONE)
	e1_2:SetCountLimit(1)
	e1_2:SetOperation(c10069.op1_2)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	token2:RegisterEffect(e1_2,true)
	Duel.SpecialSummonComplete()
end
--
function c10069.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end
--
