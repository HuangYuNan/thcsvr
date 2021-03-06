--天空的花之都
function c20161.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c20161.valcon)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20161,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_RECOVER)
	e4:SetCountLimit(1)
	e4:SetTarget(c20161.target)
	e4:SetOperation(c20161.operation)
	c:RegisterEffect(e4)
end
function c20161.spfilter(c,e,tp)
	return c:IsSetCard(0x123) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c20161.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c20161.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp))) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c20161.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCountFromEx(tp)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c20161.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
			Duel.SpecialSummonComplete()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1620000)
			e1:SetCondition(c20161.ccon)
			e1:SetOperation(c20161.cop)
			tc:RegisterEffect(e1)
		end
	else
		if Duel.GetLocationCountFromEx(tp)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c20161.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc:CompleteProcedure()
				Duel.SpecialSummonComplete()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_BE_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1620000)
				e1:SetCondition(c20161.ccon)
				e1:SetOperation(c20161.cop)
				tc:RegisterEffect(e1)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c20161.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc:CompleteProcedure()
				Duel.SpecialSummonComplete()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_BE_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1620000)
				e1:SetCondition(c20161.ccon)
				e1:SetOperation(c20161.cop)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c20161.ccon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c20161.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--leave redirect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:GetReasonCard():RegisterEffect(e1)
end
--
function c20161.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end