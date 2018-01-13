--红魔✿甜蜜陷阱 小恶魔
function c22222.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22222.spcon)
	c:RegisterEffect(e1)
	--ntr
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22222,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c22222.spcon1)
	e2:SetTarget(c22222.sptg)
	e2:SetOperation(c22222.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCondition(c22222.spcon2)
	c:RegisterEffect(e3)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22222,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c22222.cost)
	e3:SetTarget(c22222.target)
	e3:SetOperation(c22222.operation)
	c:RegisterEffect(e3)
end
function c22222.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(Card.IsFaceup,c:GetControler(),LOCATION_ONFIELD,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c22222.spfilter(c,e,tp)
	return c:IsSetCard(0x20a2) and not c:IsCode(22222) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22222.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and rp~=tp and re:GetHandler():IsOnfield() and re:GetHandler():IsType(TYPE_MONSTER)
		and re:GetHandler():IsControlerCanBeChanged()
end
function c22222.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttacker():IsControlerCanBeChanged()
end
function c22222.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c22222.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker() or re:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and (tc:IsRelateToEffect(e) or tc:IsRelateToBattle()) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(tp)
		e1:SetLabel(0)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetCondition(c22222.ctcon)
		tc:RegisterEffect(e1)
	end
end
function c22222.ctcon(e)
	local c=e:GetOwner()
	local h=e:GetHandler()
	return c:IsHasCardTarget(h)
end
function c22222.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanRelease(tp,c) and Duel.CheckReleaseGroup(tp,nil,1,c) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,c)
	sg:AddCard(c)
	Duel.Release(sg,REASON_COST)
end
function c22222.filter1(c)
	return c:IsSetCard(0x221) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) 
end
function c22222.filter2(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) 
end
function c22222.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c22222.filter1,tp,0x30,0,1,nil)
		and Duel.IsExistingTarget(c22222.filter2,tp,0x30,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c22222.filter1,tp,0x30,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c22222.filter2,tp,0x30,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
end
function c22222.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
