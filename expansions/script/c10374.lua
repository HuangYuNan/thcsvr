--魔符『小行星带』
function c10374.initial_effect(c)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e5)
	 --des and tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10374,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c10374.destg)
	e1:SetOperation(c10374.desop)
	c:RegisterEffect(e1) 
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10374,1))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1,10374)
	e7:SetCondition(c10374.thcon)
	e7:SetTarget(c10374.thtg)
	e7:SetOperation(c10374.thop)
	c:RegisterEffect(e7)
--
end
function c10374.desfilter(c)
	return not (c:IsFaceup() and c:IsSetCard(0x200)) 
end
function c10374.tfilter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x2023) and c:IsFaceup()
end
function c10374.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10374.desfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c10374.tfilter1,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c10374.sfilter(c,e)
	return c:IsDestructable() and c:IsRelateToEffect(e) and not (c:IsFaceup() and c:IsSetCard(0x200))
end
function c10374.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=Duel.TossCoin(tp,1)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c10374.sfilter,nil,e)
	if res~=0 then return end
	if g:GetCount()<1 then return end
	if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c10374.tfilter1,tp,LOCATION_SZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local s=Duel.SelectMatchingCard(tp,c10374.tfilter1,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(s,nil,REASON_EFFECT)
	end
end
--
function c10374.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_SPELLCASTER)
end
function c10374.thfilter(c)
	return c:IsSetCard(0x2024) and c:IsAbleToHand()
end
function c10374.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10374.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10374.thop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10374.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

