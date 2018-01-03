--『疾走风靡』
local M = c999108
local Mid = 999108
function M.initial_effect(c)
	--
	Afi.AdjustFieldInfoStore(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(Mid, 1))
	e1:SetCountLimit(1, Mid*10+1)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(M.thcost)
	e1:SetTarget(M.thtg)
	e1:SetOperation(M.thop)
	c:RegisterEffect(e1)
	--
	-- pos change
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(Mid, 0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_ADJ_LOC)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1, Mid*10+2)
	e0:SetTarget(M.mvtg)
	e0:SetOperation(M.mvop)
	c:RegisterEffect(e0)
end
--
function M.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end

function M.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(M.cfilter, tp, LOCATION_MZONE+LOCATION_HAND, 0, 1, nil) 
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectMatchingCard(tp, M.cfilter, tp, LOCATION_MZONE+LOCATION_HAND, 0, 1, 1, nil)
	Duel.ConfirmCards(1-tp, g)
	Duel.SendtoDeck(g, nil, 1, REASON_COST)
end

function M.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then 
		return c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE) 
	end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, c)
	end
end
--
function M.seq2col(seq)
	if seq > 4 then seq = seq == 5 and 1 or 3 end
	return seq
end

function M.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk == 0 then
		if not eg or eg:GetCount() ~= 1 then return false end
		local tc = eg:GetFirst()
		if not tc:IsOnField() or tc:IsControler(e:GetHandler():GetControler()) then return false end

		local pp, pn = Afi.AFIFindLastMI(tc)
		pn = M.seq2col(pn)

		local seq = M.seq2col(tc:GetSequence())

		e:SetLabel(seq*10 + pn)
		return pn ~= seq
	end
end

function M.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not eg or eg:GetCount() ~= 1 then return false end
	local temp = e:GetLabel()
	local seq = math.floor(temp/10)
	local pn = temp%10
	local diff = math.abs(seq - pn)
	if diff < 1 then return end

	local tc = eg:GetFirst()

	if diff > 0 then
		local e2 = Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3 = e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e3)
	end

	if diff > 1 then
		Duel.Draw(tp, 1, REASON_EFFECT)
	end

	if diff > 2 then
		local sg = Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
		local dg = sg:RandomSelect(tp, 1)
		Duel.SendtoGrave(dg, REASON_EFFECT+REASON_DISCARD)
	end

	if diff > 3 then
		local isAble2Hand = Duel.IsExistingMatchingCard(M.birdFilter, tp, LOCATION_MZONE, 0, 1, nil)
		
		local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
		local isAble2Sp = ft > 0 and Duel.IsExistingMatchingCard(M.birdSpFilter, tp, LOCATION_DECK+LOCATION_EXTRA, 0, 1, nil, e, tp)
		
		local t = {}
		if isAble2Hand then 
			t[#t+1] = {desc = aux.Stringid(Mid, 2), index = 1}
		end
		if isAble2Sp then
			t[#t+1] = {desc = aux.Stringid(Mid, 3), index = 2}
		end

		if #t > 0 then
			local opt = Duel.SelectOption(tp, Nef.unpackOneMember(t, "desc"))+1
			local index = t[opt].index

			if index == 1 then
				local g = Duel.GetFieldGroup(tp, LOCATION_MZONE, LOCATION_MZONE)
				g:RemoveCard(tc)
				g:Sub(tc:GetColumnGroup())
				Duel.SendtoHand(g, nil, REASON_EFFECT)
			else
				local sc = Duel.SelectMatchingCard(tp, M.birdSpFilter, tp, LOCATION_DECK+LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
				Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP)
			end
		else
			Duel.SelectOption(tp, aux.Stringid(Mid, 4))
		end
	end
end

function M.birdFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) 
		and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WINDBEAST)
end

function M.birdSpFilter(c, e, tp)
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp) < 1 then
		return false 
	end

	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WINDBEAST)
		and c:IsLevelAbove(4) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
