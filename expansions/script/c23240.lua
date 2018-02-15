--黄昏风鸦✿射命丸文
function c23240.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23240,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,23240)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c23240.spcost)
	e1:SetTarget(c23240.sptg)
	e1:SetOperation(c23240.spop)
	c:RegisterEffect(e1)
    --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23240,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,23241)
	e3:SetCondition(c23240.con)
	e3:SetTarget(c23240.target)
	e3:SetOperation(c23240.activate)
	c:RegisterEffect(e3)
end
function c23240.cfilter(c,ft)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and (ft>0 or c:GetSequence()<5)
end
function c23240.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c23240.cfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c23240.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c23240.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c23240.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c23240.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==0
end
function c23240.filter(c)
	return (c:IsSetCard(0x127) or c:IsSetCard(0x224)) and c:IsAbleToHand()
end
function c23240.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23240.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c23240.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23240.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
