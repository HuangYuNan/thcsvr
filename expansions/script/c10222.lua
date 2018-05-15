--乐园的花巫女✿博丽灵梦
function c10222.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10222,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10222)
	e1:SetTarget(c10222.tg1)
	e1:SetOperation(c10222.op1)
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
	e4:SetCountLimit(1,10223)
	e4:SetCondition(c10222.con4)
	e4:SetOperation(c10222.op4)
	c:RegisterEffect(e4)
end
function c10222.tfilter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x279)
end
function c10222.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10222.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c10222.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10222.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<1 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--
function c10222.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
end
--
function c10222.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10225,0x208,0x4011,0,0,2,RACE_PLANT,ATTRIBUTE_WIND) then return end
	local num=0
	while num<3 do
		local token=Duel.CreateToken(tp,10225)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4_1:SetValue(c10222.val4_1)
		e4_1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e4_1,true)
		local e4_2=e4_1:Clone()
		e4_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e4_2,true)
		num=num+1
	end
	Duel.SpecialSummonComplete()
end
--
function c10222.val4_1(e,c)
	return not c:IsSetCard(0x100)
end
--
