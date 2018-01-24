--魔化使魔契约
function c22221.initial_effect(c)
	--befiend
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22221,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22221)
	e1:SetCost(c22221.cost)
	e1:SetTarget(c22221.target)
	e1:SetOperation(c22221.operation)
	c:RegisterEffect(e1)
	--choise one
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22221,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,222221)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22221.sptg)
	e2:SetOperation(c22221.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22221,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,222221)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22221.thtg)
	e3:SetOperation(c22221.thop)
	c:RegisterEffect(e3)
end
function c22221.costfilter(c,ft,tp)
	return c:IsSetCard(0x111) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function c22221.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c22221.costfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c22221.costfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c22221.filter(c,e,tp)
	return c:IsSetCard(0x222) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22221.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c22221.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c22221.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22221.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22221.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22221.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22221.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22221.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22221.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22221.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand()
end
function c22221.thfilter2(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c22221.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22221.thfilter2,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c22221.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function c22221.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22221.thfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c22221.thfilter2,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:Select(tp,1,1,nil)
	local sg2=g2:Select(tp,1,1,nil)
	sg:Merge(sg2)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	--Duel.ConfirmCards(1-tp,sg)
end
