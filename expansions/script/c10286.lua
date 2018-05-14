--神技『天霸风神脚』
function c10286.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c10286.atkcon)
	e1:SetCost(c10286.cost)
	e1:SetOperation(c10286.atkop)
	c:RegisterEffect(e1)
	--setcard
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetValue(0x279)
	c:RegisterEffect(e5)
end
function c10286.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c10286.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	e:SetLabelObject(c)
	return c and c:IsSetCard(0x100) and c:IsRelateToBattle() and c:IsControler(tp) and c:GetLevel()>0
end
function c10286.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	local lv=c:GetLevel()
	if c:IsFaceup() and c:IsRelateToBattle() and lv>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(lv*500)
		c:RegisterEffect(e1)
	end
end
