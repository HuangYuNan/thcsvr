--橙✿夏季限定装
function c19055.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x225a),aux.FilterBoolFunction(Card.IsFusionSetCard,0x9999),true)  
	--9atk
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c19055.condition)  
	e1:SetOperation(c19055.op)
	c:RegisterEffect(e1)	
end
--
c19055.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x225a),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x9999),
}
--
function c19055.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasCategory(CATEGORY_TOGRAVE) or re:IsHasCategory(CATEGORY_DESTROY) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON))
end
--
function c19055.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()~=PHASE_END then
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		else
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		end
		c:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetValue(1)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()~=PHASE_END then
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		else
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		end
		c:RegisterEffect(e3)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(8)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()~=PHASE_END then
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		else
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		end
		c:RegisterEffect(e2)
	end
end
--
