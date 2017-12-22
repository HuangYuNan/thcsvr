--审判者-四季映姬✿亚玛萨那度
function c25175.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c25175.tgcon)
	e1:SetCountLimit(1,25175)
	e1:SetCost(c25175.ccost)
	e1:SetTarget(c25175.tgtg)
	e1:SetOperation(c25175.tgop)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(25175,ACTIVITY_SPSUMMON,c25175.counterfilter)
end
function c25175.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c25175.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c25175.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(25175,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c25175.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c25175.tgfilter(c)
	return (c:IsSetCard(0x114) or c:IsSetCard(0x740)) and c:IsAbleToGrave()
end
function c25175.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25175.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	if e:GetHandler():GetReasonPlayer()==1-tp and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c25175.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c25175.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():GetReasonPlayer()==1-tp then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
			if sg:GetCount()>0 then
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end
function c25175.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
