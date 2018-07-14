--白芷的竹伞-处暑
function c60822.initial_effect(c)
	--umb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60822,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60822.atkcon)
	e1:SetCost(c60822.cost)
	e1:SetOperation(c60822.atkop)
	c:RegisterEffect(e1)
	--to grave
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(60822,1))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60822)
	e2:SetCost(c60822.drcost)
	e2:SetTarget(c60822.drtg)
	e2:SetOperation(c60822.drop)
	c:RegisterEffect(e2)
end
c60822.DescSetName = 0x229
function c60822.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	if c:GetControler()~=tp then c=Duel.GetAttackTarget() end
	local tc=Duel.GetFieldCard(1-tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)-1)
	e:SetLabelObject(c)
	return tc and c and c:IsAttribute(ATTRIBUTE_WATER) and c:IsControler(tp) and c:IsRelateToBattle()
end
function c60822.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60822.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(1-tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)-1)
	local c=e:GetLabelObject()
	if c:IsFaceup() and c:IsRelateToBattle() and tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(tc:GetAttack())
		c:RegisterEffect(e1)
	end
end
function c60822.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c60822.setfilter(c,e,tp,zc1,zc2)
	if c:IsType(TYPE_MONSTER) then
		flag = zc1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelBelow(3)
	else
		flag = c:IsSSetable(true) and zc2 or c:IsType(TYPE_FIELD)
	end
	return flag
end
function c60822.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c60822.setfilter(chkc,e,tp) end
	local zc1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local zc2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chk==0 then return Duel.IsExistingTarget(c60822.setfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,zc1,zc2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c60822.setfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp,zc1,zc2)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	if g:GetFirst():IsType(TYPE_MONSTER) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c60822.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		elseif tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.SSet(tp,tc)
		else return end
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1,true)
	end
end
