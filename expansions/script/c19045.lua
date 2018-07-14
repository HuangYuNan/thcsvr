--临时替补巫女✿古明地觉
function c19045.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),aux.FilterBoolFunction(Card.IsFusionSetCard,0x214a),true) 
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c19045.limit1)
	c:RegisterEffect(e1)  
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c19045.op2)
	c:RegisterEffect(e2) 
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19045,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c19045.con3)
	e3:SetTarget(c19045.tg3)
	e3:SetOperation(c19045.op3)
	c:RegisterEffect(e3)
end
--
c19045.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x214a),
}
--
function c19045.limit1(e,c)
	return c:GetAttack()>1899 and not c:IsImmuneToEffect(e)
end
--
function c19045.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(EFFECT_PUBLIC)
	e2_1:SetTargetRange(0,LOCATION_HAND)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_1,tp)
end
--
function c19045.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
--
function c19045.tfilter3(c,num)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetAttack()<num
end
function c19045.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return Duel.IsChainNegatable(ev) or Duel.IsExistingMatchingCard(c19045.tfilter3,tp,LOCATION_DECK,0,1,1,rc:GetAttack()) end
end
--
function c19045.op3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local b1=Duel.IsChainNegatable(ev)
	local b2=Duel.IsExistingMatchingCard(c19045.tfilter3,tp,LOCATION_DECK,0,1,1,rc:GetAttack())
	if not (b1 or b2) then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(19045,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(19045,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then Duel.Destroy(eg,REASON_EFFECT) end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c19045.tfilter3,tp,LOCATION_DECK,0,1,1,nil,rc:GetAttack())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--
