--鸟符『人类的双重牢笼』
function c21154.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21154.cost)
	e1:SetOperation(c21154.spop)
	c:RegisterEffect(e1)
	--cannot return
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_GRAVE+LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)
	--Atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c21154.tg)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--Def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c21154.tg)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(500)
	c:RegisterEffect(e4)
end
function c21154.tg(e,c)
	return c:IsSetCard(0x522)
end
function c21154.cfilter(c,e,tp)
	return c:IsRace(RACE_WINDBEAST) and c:IsSetCard(0x208)
end
function c21154.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c21154.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c21154.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c21154.spfilter(c,e,tp)
	return c:IsSetCard(0x522) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_PZONE))
end
function c21154.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c21154.spfilter,tp,LOCATION_GRAVE+LOCATION_PZONE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(21154,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c21154.spfilter,tp,LOCATION_GRAVE+LOCATION_PZONE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
