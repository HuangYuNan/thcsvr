--乐园的可爱萨满✿博丽灵梦
function c10057.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10057,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c10057.tg1)
	e1:SetOperation(c10057.op1)
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
	e4:SetCondition(c10057.con4)
	e4:SetOperation(c10057.op4)
	c:RegisterEffect(e4)
--
end
--
function c10057.tfilter1(c)
	return c:IsSetCard(0x100) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10057.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,10057)
	local fb=Duel.GetFlagEffect(tp,10058)
	local fc=fa-fb
	if chk==0 then return Duel.IsExistingMatchingCard(c10057.tfilter1,tp,LOCATION_DECK,0,1,nil) and fc<1 end
	Duel.RegisterFlagEffect(tp,10057,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c10057.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10057.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<1 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--
function c10057.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
end
--
function c10057.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10058,0,0,0)
end
--