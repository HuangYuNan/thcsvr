--四季隐星✿蝴蝶妖精☆爱塔妮缇拉尔瓦
function c32001.initial_effect(c)
c32001.dfc_front_side=32039
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c32001.con1)
	e1:SetTarget(c32001.tg1)
	e1:SetOperation(c32001.op1)
	c:RegisterEffect(e1)   
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 

end
--
function c32001.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousLocation(),LOCATION_HAND)~=0
end
--
function c32001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,1000)
end
--
function c32001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--
	local num1=0
	local num2=0
	num1=Duel.Recover(tp,1000,REASON_EFFECT,true)
	num2=Duel.Recover(1-tp,1000,REASON_EFFECT,true)
	Duel.RDComplete()
	if num1<1 and num2<1 then return end
--
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_HAND_LIMIT)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetTargetRange(0,1)
	e1_1:SetValue(2)
	e1_1:SetLabel(Duel.GetTurnCount())
	if Duel.GetTurnPlayer()~=tp 
		or Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1_1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,1)
	else
		e1_1:SetCondition(c32001.con1_1)
		e1_1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,2)
	end
	Duel.RegisterEffect(e1_1,tp)
--
end
--
function c32001.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=Duel.GetTurnCount()
end
--
