--尸解失败✿物部布都
function c27127.initial_effect(c)
c27127.dfc_front_side=27113
--
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x119)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c27127.con1)
	e1:SetTarget(c27127.tg1)
	e1:SetOperation(c27127.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c27127.con2)
	e2:SetOperation(c27127.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c27127.con3)
	e3:SetOperation(c27127.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c27127.op4)
	c:RegisterEffect(e4)
--
end
--
function c27127.cfilter1(c,tp)
	return c:GetPreviousControler()==tp
		and (c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_HAND))
		and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE))
end
function c27127.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27127.cfilter1,1,nil,tp)
end
--
function c27127.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=eg:FilterCount(c27127.cfilter1,nil,tp)
	local num1=math.min(num,Duel.GetFieldGroupCount(tp,0,LOCATION_HAND))
	local num2=math.min(num,Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,num1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,num2,1-tp,LOCATION_ONFIELD)
end
--
function c27127.op1(e,tp,eg,ep,ev,re,r,rp)
	local num=eg:FilterCount(c27127.cfilter1,nil,tp)
	local num1=math.min(num,Duel.GetFieldGroupCount(tp,0,LOCATION_HAND))
	local num2=math.min(num,Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD))
	local sg=Group.CreateGroup()
	local sg1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local tg2=sg2:RandomSelect(tp,num2)
	if sg1:GetCount()>0 then 
		local tg1=sg1:RandomSelect(tp,num1)
		sg:Merge(tg1)
	end
	if sg2:GetCount()>0 then 
		local tg2=sg2:RandomSelect(tp,num1)
		sg:Merge(tg2)
	end
	if sg:GetCount()<1 then return end
	if Duel.SendtoGrave(sg,REASON_EFFECT)<1 then return end
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--
function c27127.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_RITUAL)~=0
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
--
function c27127.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--
function c27127.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_RITUAL)~=0
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
--
function c27127.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(27127,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
end
--
function c27127.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(27127)<1 then return end
	c:ResetFlagEffect(27127)
	Duel.Destroy(c,REASON_EFFECT)
end
--
