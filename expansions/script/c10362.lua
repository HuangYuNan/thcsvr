--恋符『机枪火花』
function c10362.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c10362.con1)
	e1:SetTarget(c10362.tg1)
	e1:SetOperation(c10362.op1)
	c:RegisterEffect(e1)
--
end
--
function c10362.cfilter1(c)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsType(TYPE_SPELL)
end
function c10362.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10362.cfilter1,1,nil)
end
--
function c10362.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
--
function c10362.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.Damage(1-tp,500,REASON_EFFECT)>0 then
		if not c:IsRelateToEffect(e) then return end
		c:CancelToGrave()
		if c:IsCanTurnSet() then
			Duel.BreakEffect()
			if Duel.ChangePosition(c,POS_FACEDOWN)<1 then return end
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_FIELD)
			e1_1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1_1:SetTargetRange(0,1)
			e1_1:SetValue(1)
			e1_1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_1,tp)
		else
			c:CancelToGrave(true)
		end
	end
end
--
