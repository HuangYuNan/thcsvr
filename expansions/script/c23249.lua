--未经世故的妨碍记者✿姬海棠果
function c23249.initial_effect(c)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c23249.condition)
	e2:SetCost(c23249.cost)
	e2:SetTarget(c23249.target)
	e2:SetOperation(c23249.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23249,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCountLimit(1,23249)
	e1:SetCondition(c23249.spcon)
	e1:SetTarget(c23249.sptg)
	e1:SetOperation(c23249.spop)
	c:RegisterEffect(e1)
end
function c23249.cfilter(c)
	return c:IsCode(0x813) and c:IsFaceup()
end
function c23249.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:IsActiveType(TYPE_MONSTER) and ep==1-tp
end
function c23249.tgfilter(c)
	return c:IsCode(22105) and c:IsAbleToGrave()
end
function c23249.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c23249.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c23249.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c23249.repop)
end
function c23249.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
function c23249.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==0
end
function c23249.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:GetLocation()==LOCATION_SZONE and c23249.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23249.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c23249.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c23249.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)>0 and e:GetHandler():IsRelateToEffect(e) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c23249.filter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
