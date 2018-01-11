 --魔符「星屑幻想」
function c10014.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10014.target)
	e1:SetOperation(c10014.operation)
	c:RegisterEffect(e1)
end
function c10014.filter(c)
	return c:IsFaceup()
end
function c10014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c10014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	if tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(4)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(500)
		tc:RegisterEffect(e2)
	elseif tc:IsType(TYPE_XYZ) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	elseif tc:IsType(TYPE_LINK) and tc:IsControler(tp) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(LINK_MARKER_BOTTOM)
		tc:RegisterEffect(e3)
	elseif tc:IsType(TYPE_LINK) and tc:IsControler(1-tp) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		e4:SetValue(LINK_MARKER_TOP)
		tc:RegisterEffect(e4)
	end
end
