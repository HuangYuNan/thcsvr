--入魔『快速尸解』
function c27030.initial_effect(c)
--td
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c27030.cost)
	e1:SetTarget(c27030.tg)
	e1:SetOperation(c27030.op)
	c:RegisterEffect(e1)
end
function c27030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27030.tobirafilter,tp,0x12,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c27030.tobirafilter,tp,0x12,0,1,1,nil)
	local mc=cg:GetFirst()
	Duel.Remove(mc,POS_FACEUP,REASON_COST)
	e:SetLabel(mc.dfc_front_side)
end
function c27030.tfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c27030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27030.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c27030.tobirafilter(c)
	return c.dfc_front_side and not c:IsType(TYPE_FLIP) and c:IsType(TYPE_RITUAL)
end
function c27030.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c27030.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local mcode=tc:GetOriginalCode()
	if Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK,POS_FACEDOWN_DEFENSE,POS_FACEDOWN_ATTACK,POS_FACEDOWN_DEFENSE)>0 then
		local tcode=e:GetLabel()
		tc:SetEntityCode(tcode,true)
		tc:ReplaceEffect(tcode,0,0)
		Duel.SetMetatable(tc,_G["c"..tcode])
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			if not mcode then return end
			c:SetEntityCode(mcode)
			c:ReplaceEffect(mcode,0,0)
			Duel.SetMetatable(c,_G["c"..mcode])
		end)
		tc:RegisterEffect(e2)	
		local e3=e2:Clone()
		e3:SetRange(0)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetCode(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		tc:RegisterEffect(e3)
	end
end
