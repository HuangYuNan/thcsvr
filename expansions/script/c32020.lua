--后符·秘神的后光
function c32020.initial_effect(c)
--tobira
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+32035)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,32020)
	e1:SetCondition(c32020.con)
	e1:SetTarget(c32020.tg)
	e1:SetOperation(c32020.op)
	c:RegisterEffect(e1)
end
function c32020.cfilter1(c)
	return c:IsFaceup() and c:GetOriginalCode()==32007
end
function c32020.cfilter2(c)
	return c:IsFaceup() and c:GetOriginalCode()==32015
end
function c32020.cfilter3(c)
	return c:IsFaceup() and c:GetOriginalCode()==32018
end
function c32020.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		or Duel.IsExistingMatchingCard(c32020.cfilter1,tp,LOCATION_PZONE,0,1,nil)
end
function c32020.tfilter(c)
	return not c:IsType(TYPE_LINK)
end
function c32020.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c32020.tfilter(chkc) end
	local clc=0
	if Duel.IsExistingMatchingCard(c32020.cfilter2,tp,LOCATION_PZONE,0,1,nil) then clc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingTarget(c32020.tfilter,tp,LOCATION_MZONE,clc,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c32020.tfilter,tp,LOCATION_MZONE,clc,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c32020.tobirafilter(c)
	return c.dfc_front_side and not c:IsType(TYPE_FLIP)
end
function c32020.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mc=Duel.SelectMatchingCard(tp,c32020.tobirafilter,tp,0x3,0,1,1,nil):GetFirst()
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local mcode=tc:GetOriginalCode()
	if not tc:IsRelateToEffect(e) then return end
	if not tc:IsLocation(LOCATION_MZONE) then return end 
	if Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK,POS_FACEDOWN_DEFENSE,POS_FACEDOWN_ATTACK,POS_FACEDOWN_DEFENSE)>0 then
		local tcode=mc.dfc_front_side
		tc:SetEntityCode(tcode,true)
		tc:ReplaceEffect(tcode,0,0)
		Duel.SetMetatable(tc,_G["c"..tcode])
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		if tc:IsControler(1-tp) and Duel.IsExistingMatchingCard(c32020.cfilter3,tp,LOCATION_PZONE,0,1,nil) then
			Duel.GetControl(tc,tp)
		end
		Duel.SendtoGrave(mc,REASON_EFFECT)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			if not mcode then return end
			c:SetEntityCode(mcode)
			c:ReplaceEffect(mcode,0,0)
			Duel.SetMetatable(c,_G["c"..mcode])
		end)
		tc:RegisterEffect(e2)	
		-- local e3=e2:Clone()
		-- e3:SetRange(0)
		-- e3:SetCode(EVENT_LEAVE_FIELD)
		-- e3:SetCode(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		-- tc:RegisterEffect(e3)
	end
end
