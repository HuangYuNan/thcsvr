--取材『射命丸文的暴力取材』
function c23252.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c23252.con)
	e1:SetTarget(c23252.tg)
	e1:SetOperation(c23252.activate)
	c:RegisterEffect(e1)
end
function c23252.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<0x8 or Duel.GetCurrentPhase()>0x80
end
function c23252.filter(c)
	return c:IsSetCard(0x125)
end
function c23252.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and
		Duel.IsExistingTarget(c23252.filter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g2=Duel.SelectTarget(tp,c23252.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g1=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c23252.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local fc=g:GetFirst()
	local sc=g:GetNext()
	if not (fc:IsLocation(LOCATION_MZONE) and sc:IsLocation(LOCATION_MZONE)) then return end
	if not fc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(fc,POS_FACEUP_ATTACK)
	end
	if not sc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(sc,POS_FACEUP_ATTACK)
	end
	if not (fc:IsLocation(LOCATION_MZONE) and sc:IsLocation(LOCATION_MZONE)) then return end
	Duel.BreakEffect()
	Duel.CalculateDamage(sc,fc)
end
