--朝歌夜弦✿藤原妹红
function c19060.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x137),aux.FilterBoolFunction(Card.IsFusionSetCard,0x522),true) 
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c19060.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c19060.con2)
	e2:SetCost(c19060.cost2)
	e2:SetTarget(c19060.tg2)
	e2:SetOperation(c19060.op2)
	c:RegisterEffect(e2)
--
end
--
c19060.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x137),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x522),
}
--
function c19060.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=true
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(19060,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(19060,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1_1:SetTargetRange(LOCATION_MZONE,0)
		e1_1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WINDBEAST))
		e1_1:SetValue(1)
		e1_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)
		Duel.RegisterEffect(e1_1,tp)
		Duel.RegisterFlagEffect(tp,19060,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)
	else
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_FIELD)
		e1_2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1_2:SetTargetRange(1,0)
		e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_2:SetTarget(c19060.tg1_2)
		e1_2:SetValue(1)
		e1_2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		Duel.RegisterEffect(e1_2,tp)
		Duel.RegisterFlagEffect(tp,19060,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
	end
end
function c19060.tg1_2(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
--
function c19060.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,19060)<1
end
--
function c19060.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,(Duel.GetLP(tp)/2)) end
	Duel.PayLPCost(tp,(Duel.GetLP(tp)/2))
end
--
function c19060.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c19060.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--
