--忠诚的念缚灵✿宫古芳香
function c19056.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x251d),aux.FilterBoolFunction(Card.IsFusionSetCard,0x242),true) 
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(c19056.op1)
	c:RegisterEffect(e1)
--
	if not c19056.global_check then
		c19056.global_check=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_LEVEL_UP)
		e2:SetLabelObject(c)
		e2:SetOperation(c19056.op2)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c19056.tg3)
		e3:SetLabelObject(e2)
		Duel.RegisterEffect(e3,0)
	end
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+19056)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(c19056.tg4)
	e4:SetOperation(c19056.op4)
	c:RegisterEffect(e4)
--
end
--
c19056.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x242),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x251d),
}
--
function c19056.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1_1:SetCountLimit(1)
	e1_1:SetCondition(c19056.con1_1)
	e1_1:SetOperation(c19056.op1_1)
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1_1:SetLabel(Duel.GetTurnCount())
		e1_1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,2)
	else
		e1_1:SetLabel(0)
		e1_1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1_1,tp)
end
function c19056.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	return Duel.GetTurnPlayer()~=tp and num~=Duel.GetTurnCount()
end
function c19056.ofilter1_1(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c19056.op1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,19056)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c19056.ofilter1_1,tp,0,LOCATION_MZONE,nil,e)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		while tc do
			local e1_1_1=Effect.CreateEffect(c)
			e1_1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1_1:SetCode(EFFECT_UPDATE_ATTACK)
			e1_1_1:SetValue(100)
			e1_1_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_1_1)
			local e1_1_2=e1_1_1:Clone()
			e1_1_2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e1_1_2)
			tc=sg:GetNext()
		end
	end
	local ct=sg:GetCount()
	Duel.Damage(1-tp,ct*400+500,REASON_EFFECT)
end
--
function c19056.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.RaiseEvent(c,EVENT_CUSTOM+19056,re,r,rp,ep,ev)
end
--
function c19056.tg3(e,c)
	return c:IsFaceup()
end
--
function c19056.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c19056.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--
