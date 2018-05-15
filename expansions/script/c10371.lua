--星符『卫星幻觉』
function c10371.initial_effect(c)
	 --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10371.tg)
	e1:SetOperation(c10371.op)
	c:RegisterEffect(e1)
-- 
end
function c10371.thfilter(c,e,tp,ft)
	return c:IsSetCard(0x200) and c:IsAbleToHand() and c:IsFaceup() 
		and ((c:IsLocation(LOCATION_MZONE) and (ft>0 or c:GetSequence()<5)) or (c:IsLocation(LOCATION_REMOVED) and ft>0))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10070,0,0x4011,c:GetTextAttack(),c:GetTextDefense(),0,1,RACE_FAIRY,ATTRIBUTE_WIND)
end
function c10371.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c10371.thfilter,tp,LOCATION_REMOVED+LOCATION_MZONE,0,1,nil,e,tp,ft) end
	local g=Duel.SelectTarget(tp,c10371.thfilter,tp,LOCATION_REMOVED+LOCATION_MZONE,0,1,1,nil,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c10371.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10070,0,0x4011,tc:GetTextAttack(),tc:GetTextDefense(),0,1,RACE_FAIRY,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,10070)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)<1 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetTextAttack())
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetTextDefense())
		token:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		--token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CHANGE_DAMAGE)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(0,1)
		e4:SetValue(c10371.damval)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end
end
function c10371.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
--
