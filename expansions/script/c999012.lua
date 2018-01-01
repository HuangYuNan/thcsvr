--杜鹃花✿濑笈叶
local M = c999012
local Mid = 999012
function M.initial_effect(c)
	-- fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c, aux.FilterBoolFunction(Card.IsFusionSetCard, 0xaa6), aux.FilterBoolFunction(Card.IsFusionSetCard, 0x522), true)

	-- move
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(Mid, 3))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(M.mvTg)
	e1:SetOperation(M.mvOp)
	c:RegisterEffect(e1)

	-- add birduff
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e2:SetTarget(M.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)

	-- cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e3:SetTarget(M.limitTg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)

	-- to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1, Mid*10+2)
	e2:SetCondition(M.thcon)
	e2:SetOperation(M.repop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
end

M.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa6),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x522),
}

--
function M.isInMainMonsterZone(c, tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence() < 5
end

function M.mvTgCheckFilter(c, bird)
	local pc = c:GetControler()
	local pbird = bird:GetControler()
	if pc == pbird then
		return c == bird
	else
		local isAbleToMoveC = bird:GetColumnGroup():FilterCount(M.isInMainMonsterZone, nil, pc) == 0
		local isAbleToMoveBird = c:GetColumnGroup():FilterCount(M.isInMainMonsterZone, nil, pbird) == 0
		
		return isAbleToMoveC or isAbleToMoveBird
	end
end

function M.mvTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local c = e:GetHandler()
	if chk == 0 then return 
		c:GetFlagEffect(Mid) < 1 and Duel.IsExistingTarget(M.mvTgCheckFilter, tp, 0, LOCATION_MZONE, 1, nil, c) 
			and Duel.IsExistingTarget(M.mvTgCheckFilter, tp, LOCATION_MZONE, 0, 1, nil, c) 
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, M.mvTgCheckFilter, tp, 0, LOCATION_MZONE, 1, 1, nil, c)
	Duel.SelectTarget(tp, M.mvTgCheckFilter, tp, LOCATION_MZONE, 0, 1, 1, nil, c)
	c:RegisterFlagEffect(Mid, RESET_EVENT+0x1fe0000, 0, 1)
end

function M.mvOp(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect, nil, e)
	local bird = e:GetHandler()
	g:RemoveCard(bird)
	local tc = g:GetFirst()

	local pc = tc:GetControler()
	local pbird = bird:GetControler()
	if pc == pbird then return end

	local isAbleToMoveBird = tc:GetColumnGroup():FilterCount(M.isInMainMonsterZone, nil, pbird) == 0
	local isAbleToMoveC = bird:GetColumnGroup():FilterCount(M.isInMainMonsterZone, nil, pc) == 0
	
	local t = {}
	if isAbleToMoveC then 
		t[#t+1] = {desc = aux.Stringid(Mid, 0), index = 1}
	end
	if isAbleToMoveBird then 
		t[#t+1] = {desc = aux.Stringid(Mid, 1), index = 2}
	end

	if #t > 0 then
		local opt = Duel.SelectOption(tp, Nef.unpackOneMember(t, "desc"))+1
		local index = t[opt].index

		if index == 1 then
			local seq = bird:GetSequence()
			if seq > 4 then seq = seq == 5 and 1 or 3 end
			Duel.MoveSequence(tc, 4-seq)
		else
			local seq = tc:GetSequence()
			if seq > 4 then seq = seq == 5 and 1 or 3 end
			Duel.MoveSequence(bird, 4-seq)
		end
	end
end

--
function M.getCol(c)
	local seq = c:GetSequence()
	if seq > 4 then seq = seq == 5 and 1 or 3 end
	return seq
end

function M.isSameCol(c1, c2)
	local col1 = M.getCol(c1)
	local col2 = M.getCol(c2)
	if c1:GetControler() == c2:GetControler() then
		return col1 == col2
	else
		return col1 + col2 == 4
	end
end

function M.disable(e, c)
	if not c or c == e:GetHandler() then return false end
	return M.isSameCol(e:GetHandler(), c) and (c:IsType(TYPE_EFFECT) or (c:GetOriginalType() & TYPE_EFFECT == TYPE_EFFECT))
end

function M.limitTg(e, c)
	if not c or c == e:GetHandler() then return false end
	return M.isSameCol(e:GetHandler(), c)
end

--
function M.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function M.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid, 2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(M.thtg)
	e1:SetOperation(M.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

function M.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, 0)
end

function M.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x522)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) then return end
	local g = Duel.SelectMatchingCard(tp, M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end