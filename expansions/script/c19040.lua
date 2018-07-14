--妖怪治退✿大妖精☆
function c19040.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),aux.FilterBoolFunction(Card.IsFusionSetCard,0xc999),true)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19040,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c19040.destg)
	e2:SetOperation(c19040.desop)
	c:RegisterEffect(e2)  
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19040,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(c19040.tg4)
	e4:SetOperation(c19040.op4)
	c:RegisterEffect(e4)
--
end
c19040.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),
aux.FilterBoolFunction(Card.IsFusionSetCard,0xc999),
}
--
function c19040.desfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_FIEND) or c:IsRace(RACE_ZOMBIE))
end
function c19040.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c19040.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c19040.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
--
function c19040.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--
function c19040.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCardFilter(tp,0x999,OPCODE_ISSETCARD,TYPE_FUSION+TYPE_LINK,OPCODE_ISTYPE,OPCODE_AND)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac2=Duel.AnnounceCardFilter(tp,0x999,OPCODE_ISSETCARD,TYPE_FUSION+TYPE_LINK,OPCODE_ISTYPE,OPCODE_AND)
	local token1=Duel.CreateToken(tp,ac1)
	local token2=Duel.CreateToken(tp,ac2)
	local g=Group.CreateGroup()
	g:AddCard(token1)
	g:AddCard(token2)
	g:KeepAlive()
	e:SetLabelObject(g)
end
--
function c19040.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g and g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--