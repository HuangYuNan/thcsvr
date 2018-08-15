--因风水而摔碟的尸解仙✿物部布都
function c27125.initial_effect(c)
--
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x119)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c27125.op1)
	c:RegisterEffect(e1)
--
	local e2_0=Effect.CreateEffect(c)
	e2_0:SetDescription(aux.Stringid(27125,0))
	e2_0:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2_0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2_0:SetType(EFFECT_TYPE_IGNITION)
	e2_0:SetRange(LOCATION_MZONE)
	e2_0:SetCountLimit(1)
	e2_0:SetTarget(c27125.tg2)
	e2_0:SetOperation(c27125.op2)
	c:RegisterEffect(e2_0)
	local e2_1=e2_0:Clone()
	e2_1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2_1)  
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c27125.con3)
	e3:SetOperation(c27125.op3)
	c:RegisterEffect(e3)
--
end
--
function c27125.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)<1 then return end
	local rc=re:GetHandler()
	if not (rc:IsType(TYPE_RITUAL) or rc:IsType(TYPE_FIELD)) then return end
	c:AddCounter(0x119,2)
end
--
function c27125.tfilter2_1(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsDestructable()
end
function c27125.tfilter2_2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL)
end
function c27125.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c27125.tfilter2_1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27125.tfilter2_1,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) and Duel.IsExistingMatchingCard(c27125.tfilter2_2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,c27125.tfilter2_1,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
--
function c27125.ofilter2(c)
	return c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c27125.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Destroy(tc,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c27125.tfilter2_2,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	if bit.band(e:GetActivateLocation(),LOCATION_ONFIELD)~=0 then
		if c:GetCounter(0x119)<1 then return end
		if not Duel.IsExistingMatchingCard(c27125.ofilter2,tp,LOCATION_DECK,0,1,nil) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(27125,1)) then
			Duel.BreakEffect()
			c:RemoveCounter(tp,0x119,c:GetCounter(0x119),REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c27125.ofilter2,tp,LOCATION_DECK,0,1,1,nil)
			if tg:GetCount()<1 then return end
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
--
function c27125.cfilter3(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() 
		and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c27125.con3(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c27125.cfilter3,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
--
function c27125.op3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,c27125.cfilter3,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_COST)
end
--

