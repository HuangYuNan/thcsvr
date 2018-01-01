--背负植物之人 濑笈叶
local M = c999011
local Mid = 999011
function M.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, Mid*10+1)
	e1:SetCondition(M.spcon)
	c:RegisterEffect(e1)

	-- to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1, Mid*10+2)
	e2:SetTarget(M.tdTg)
	e2:SetOperation(M.tdOp)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	-- to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1, Mid*10+3)
	e4:SetCondition(M.thCon)
	e4:SetTarget(M.thTg)
	e4:SetOperation(M.thOp)
	c:RegisterEffect(e4)
end

--
function M.spcon(e,c)
	if c == nil then return true end
	return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_GRAVE, 0, 1, nil)
end
function M.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaa6)
end

--
function M.tdTg(e,tp,eg,ep,ev,re,r,rp,chk)
	local allg = Duel.GetMatchingGroup(M.tdTgFilter, tp, LOCATION_GRAVE, 0, nil)
	local count = allg:GetCount()
	if chk == 0 then 
		return allg:FilterCount(Card.IsAbleToDeckAsCost, nil) == count
	end
	Duel.SendtoDeck(allg, nil, 2, REASON_COST)

	local heal = count*100
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(heal)
	Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, heal)
end
function M.tdTgFilter(c)
	return not c:IsCode(0xaa6) and c:IsType(TYPE_MONSTER)
end

function M.tdOp(e,tp,eg,ep,ev,re,r,rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Recover(p, d, REASON_EFFECT)
end

--
function M.thCon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r & REASON_FUSION == REASON_FUSION
end

function M.thfilter(c)
	return c:IsSetCard(0xaa6) and not c:IsCode(Mid) and c:IsAbleToHand()
end

function M.thTg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk == 0 then return Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function M.thOp(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(M.thfilter, tp, LOCATION_DECK, 0, nil)
	if g:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local tg = g:Select(tp, 1, 1, nil)
		if tg:GetCount() > 0 then
			Duel.SendtoHand(tg, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, tg)
		end
	end
end
