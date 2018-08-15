--运气『破局的开门』
function c27107.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27107+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27107.tg1)
	e1:SetOperation(c27107.op1)
	c:RegisterEffect(e1)
--
end
--
function c27107.tfilter1_1(c,e,tp)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsFaceup()
		and c:IsCanAddCounter(0x119,12)
		and Duel.IsExistingMatchingCard(c27107.tfilter1_2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c27107.tfilter1_2(c,e,tp,tc)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
		and not c:IsCode(tc:GetCode())
end
--
function c27107.tfilter1_3(c,e,tp)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c27107.tfilter1_4,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c27107.tfilter1_4(c,e,tp,tc)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
		and c:GetLevel()~=tc:GetLevel()
end
--
function c27107.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(c27107.tfilter1_1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c27107.tfilter1_3,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(27107,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(27107,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_COUNTER)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectTarget(tp,c27107.tfilter1_1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,12,0,0x119)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local sg=Duel.SelectMatchingCard(tp,c27107.tfilter1_3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		e:SetLabelObject(tc)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
--
function c27107.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		if tc:IsFacedown() then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c27107.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if sg:GetCount()<1 then return end
		local sc=sg:GetFirst()
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)<1 then return end
		sc:CompleteProcedure()
		if Duel.Destroy(sc,REASON_EFFECT)<1 then return end
		Duel.BreakEffect()
		tc:AddCounter(0x119,12)
	else
		local tc=e:GetLabelObject()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c27107.tfilter1_4,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if sg:GetCount()<1 then return end
		local sc=sg:GetFirst()
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)<1 then return end
		sc:CompleteProcedure()
		Duel.Destroy(sc,REASON_EFFECT)
	end
end