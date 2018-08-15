--风符『三轮的皿风暴』
function c27108.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27108+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(c27108.cost1)
	e1:SetTarget(c27108.tg1)
	e1:SetOperation(c27108.op1)
	c:RegisterEffect(e1)
--
end
--
function c27108.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c27108.tfilter1(c)
	return c:GetCounter(0x119)>0
end
function c27108.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c27108.tfilter1,tp,LOCATION_ONFIELD,0,1,nil)
			and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,3,nil)
	end
	local counternum=0
	local sg=Duel.GetMatchingGroup(c27108.tfilter1,tp,LOCATION_ONFIELD,0,nil)
	local tc=sg:GetFirst()
	while tc do
		local ct=tc:GetCounter(0x119)
		counternum=counternum+ct
		tc:RemoveCounter(tp,0x119,ct,REASON_COST)
		tc=sg:GetNext()
	end
	e:SetLabel(counternum)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,counternum*100)
end
--
function c27108.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()<1 then return end
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)<1 then return end
	local counternum=e:GetLabel()
	Duel.Damage(1-tp,counternum*100,REASON_EFFECT)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_PHASE+PHASE_END)
	e1_1:SetCountLimit(1)
	e1_1:SetLabel(counternum)
	e1_1:SetOperation(c27108.op1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c27108.ofilter1_1(c,num)
	return c:IsCanAddCounter(0x119,num) and c:IsSetCard(0x119) and c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function c27108.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local counternum=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectMatchingCard(tp,c27108.ofilter1_1,tp,LOCATION_ONFIELD,0,1,1,nil,counternum)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	sc:AddCounter(0x119,counternum)
end
--
