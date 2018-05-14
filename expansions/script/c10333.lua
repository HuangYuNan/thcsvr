--魔炮警告!!!
function c10333.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10333.tg2)
	e2:SetOperation(c10333.op2)
	c:RegisterEffect(e2)
--
end
--
function c10333.tfilter2_1(c)
	return c:IsSetCard(0x2022) and c:IsAbleToHand()
end
function c10333.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c10333.tfilter2_1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10070,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND,POS_FACEUP_ATTACK,1-tp)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(10333,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10333,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
end
--
function c10333.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()<1 then return end
		if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c10333.tfilter2_1,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	else
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,10070,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND,POS_FACEUP_ATTACK,1-tp) then return end
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft<1 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local num=0
		while num<ft do
			local token=Duel.CreateToken(tp,10070)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2_1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
			e2_1:SetRange(LOCATION_MZONE)
			e2_1:SetValue(1)
			token:RegisterEffect(e2_1)
			local e2_2=Effect.CreateEffect(c)
			e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2_2:SetCode(EVENT_PHASE+PHASE_END)
			e2_2:SetRange(LOCATION_MZONE)
			e2_2:SetCountLimit(1)
			e2_2:SetOperation(c10333.op2_2)
			e2_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			token:RegisterEffect(e2_2,true)
			num=num+1
		end
		Duel.SpecialSummonComplete()
	end
end
--
function c10333.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end
--
