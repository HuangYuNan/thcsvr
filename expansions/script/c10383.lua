--光击『射向幼月』
function c10383.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10383.target)
	e1:SetOperation(c10383.operation)
	c:RegisterEffect(e1)
	--get hand
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,10383+EFFECT_COUNT_CODE_DUEL)
	e7:SetCondition(c10383.thcon)
	e7:SetTarget(c10383.thtg)
	e7:SetOperation(c10383.thop)
	c:RegisterEffect(e7)
end
function c10383.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x200) and c:GetLevel()>0
end
function c10383.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10383.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10383.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=e:GetHandler():GetColumnGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10383.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c10383.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) or tc:IsType(TYPE_XYZ+TYPE_LINK) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,5)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(lv)
	tc:RegisterEffect(e1)
	local g=tc:GetColumnGroup()
	g:RemoveCard(tc)
	local ng=g:Filter(c10383.disfilter,nil)
	local nc=ng:GetFirst()
	while nc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		nc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		nc:RegisterEffect(e2)
		if nc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			nc:RegisterEffect(e3)
		end
		nc=ng:GetNext()
	end
end
function c10383.disfilter(c)
	return (not c:IsDisabled() or c:IsType(TYPE_TRAPMONSTER)) and not (c:IsType(TYPE_NORMAL) and bit.band(c:GetOriginalType(),TYPE_NORMAL)) and c:IsLocation(LOCATION_MZONE)
end
function c10383.cfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_HAND)
end
function c10383.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10383.cfilter,1,nil,tp)
end
function c10383.filter1(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c10383.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=eg:GetFirst():GetCode()
	if chk==0 then return eg:GetCount()==1 and eg:IsExists(c10383.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c10383.filter1,tp,LOCATION_DECK,0,2,nil,code) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c10383.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=eg:GetFirst():GetCode()
	local g=Duel.GetMatchingGroup(c10383.filter1,tp,LOCATION_DECK,0,nil,code)
	if g:GetCount()<2 then return end
	local hg=g:RandomSelect(tp,2)
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)
	local tc=hg:GetFirst()
	while tc do
		local e7_1=Effect.CreateEffect(c)
		e7_1:SetType(EFFECT_TYPE_SINGLE)
		e7_1:SetCode(EFFECT_PUBLIC)
		e7_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e7_1)
		local e7_2=Effect.CreateEffect(c)
		e7_2:SetType(EFFECT_TYPE_SINGLE)
		e7_2:SetCode(EFFECT_CANNOT_TRIGGER)
		e7_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e7_2)
		local e7_3=Effect.CreateEffect(c)
		e7_3:SetType(EFFECT_TYPE_SINGLE)
		e7_3:SetCode(EFFECT_CANNOT_SSET)
		e7_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e7_3)
		tc=hg:GetNext()
	end
end
