--司掌龙脉的风水师✿物部布都
function c27119.initial_effect(c)
--
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x119)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27119,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27119)
	e1:SetCondition(c27119.con1)
	e1:SetTarget(c27119.tg1)
	e1:SetOperation(c27119.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27119,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_COUNTER)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c27119.con2)
	e2:SetTarget(c27119.tg2)
	e2:SetOperation(c27119.op2)
	c:RegisterEffect(e2)
--
end
--
function c27119.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 
		or Duel.GetCurrentPhase()==PHASE_MAIN2
end
--
function c27119.tfilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c27119.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c27119.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27119.tfilter1,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,c27119.tfilter1,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
--
function c27119.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(tc,tp,REASON_EFFECT)<1 then return end
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetDescription(aux.Stringid(27119,2))
	e1_1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1_1:SetType(EFFECT_TYPE_IGNITION)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetCountLimit(1)
	e1_1:SetTarget(c27119.tg1_1)
	e1_1:SetOperation(c27119.op1_1)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1_1)  
end
--
function c27119.tfilter1_1(c)
	return c:GetCounter(0x119)>0
end
function c27119.tfilter1_2(c,e,tp,num)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return num>=c:GetLevel()
end
function c27119.tg1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local counternum=0
		local sg=Duel.GetMatchingGroup(c27108.tfilter1_1,tp,LOCATION_ONFIELD,0,nil)
		local tc=sg:GetFirst()
		while tc do
			local ct=tc:GetCounter(0x119)
			counternum=counternum+ct
			tc=sg:GetNext()
		end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c27119.tfilter1_2,tp,LOCATION_HAND,0,1,nil,e,tp,counternum)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--
function c27119.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local counternum=0
	local sg=Duel.GetMatchingGroup(c27108.tfilter1_1,tp,LOCATION_ONFIELD,0,nil)
	local tc=sg:GetFirst()
	while tc do
		local ct=tc:GetCounter(0x119)
		counternum=counternum+ct
		tc=sg:GetNext()
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c27119.tfilter1_2,tp,LOCATION_HAND,0,1,1,nil,e,tp,counternum)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x119,sc:GetLevel(),REASON_COST)
	sc:SetMaterial(nil)
	Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	sc:CompleteProcedure()
end
--
function c27119.con2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE 
		and Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x119)<1
end
--
function c27119.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return re:GetHandler():IsControlerCanBeChanged() and re:GetHandler():IsLocation(LOCATION_MZONE) and c:IsCanAddCounter(0x119,5) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,re:GetHandler(),1,0,0)
end
--
function c27119.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	if tc:IsFacedown() then return end
	if not tc:IsRelateToEffect(re) then return end
	if Duel.GetControl(tc,tp,PHASE_END,1)<1 then return end
	c:AddCounter(0x119,5)
end
--
