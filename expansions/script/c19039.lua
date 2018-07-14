--水晶巫女✿琪露诺
function c19039.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),aux.FilterBoolFunction(Card.IsFusionSetCard,0x9999),true)  
	--draw
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19039,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c19039.con1)
	e1:SetOperation(c19039.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c19039.con2)
	e2:SetOperation(c19039.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c19039.con3)
	e3:SetOperation(c19039.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19039,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(c19039.tg4)
	e4:SetOperation(c19039.op4)
	c:RegisterEffect(e4)
--
end
--
c19039.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x9999),
}
--
function c19039.cfilter1(c,tp)
	return c:GetPreviousLocation()==LOCATION_DECK and c:IsSetCard(0x999) and c:IsControler(tp) and not c:IsPublic()
end
function c19039.con1(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c19039.cfilter1,nil,tp)
	return sg and sg:GetCount()==1
		and ((not re) or (re and not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)))
end
--
function c19039.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c19039.cfilter1,nil,tp)
	if sg and sg:GetCount()==1 
		and Duel.SelectYesNo(tp,aux.Stringid(19039,0)) then
		Duel.ConfirmCards(1-tp,sg)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
--
function c19039.con2(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c19039.cfilter1,nil,tp)
	return sg:GetCount()==1 and re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
--
function c19039.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c19039.cfilter1,nil,tp)
	local sc=sg:GetFirst()
	sc:RegisterFlagEffect(19039,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(tp,19039,RESET_CHAIN,0,1)
end
--
function c19039.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,19039)>0
end
--
function c19039.ofilter3(c)
	return c:GetFlagEffect(19039)>0
end
function c19039.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19039.ofilter3,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 
		and Duel.SelectYesNo(tp,aux.Stringid(19039,0)) then
		Duel.ConfirmCards(1-tp,g)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(19039)
		tc=g:GetNext()
	end
	Duel.ResetFlagEffect(tp,19039)
end
--
function c19039.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCardFilter(tp,0x999,OPCODE_ISSETCARD,TYPE_XYZ+TYPE_SYNCHRO,OPCODE_ISTYPE,OPCODE_AND)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac2=Duel.AnnounceCardFilter(tp,0x999,OPCODE_ISSETCARD,TYPE_XYZ+TYPE_SYNCHRO,OPCODE_ISTYPE,OPCODE_AND)
	local token1=Duel.CreateToken(tp,ac1)
	local token2=Duel.CreateToken(tp,ac2)
	local g=Group.CreateGroup()
	g:AddCard(token1)
	g:AddCard(token2)
	g:KeepAlive()
	e:SetLabelObject(g)
end
--
function c19039.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g and g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--