--魔法使之徒 濑笈叶
--require "expansions/script/nef/afi"
local M = c999002
local Mid = 999002
function M.initial_effect(c)
	-- fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c, aux.FilterBoolFunction(Card.IsFusionSetCard, 0xaa6), aux.FilterBoolFunction(Card.IsFusionSetCard, 0x200), true)
	--
	Afi.AdjustFieldInfoStore(c)
	-- atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(M.condtion)
	e1:SetValue(M.value)
	c:RegisterEffect(e1)
	-- atk change
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(Mid,0))
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_ADJ_ATK)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(M.damtg)
	e0:SetOperation(M.damop)
	c:RegisterEffect(e0)
	-- to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(Mid,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1, Mid)
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
aux.FilterBoolFunction(Card.IsFusionSetCard,0x200),
}

function M.ffilter(c)
	return c:IsSetCard(0x200)
end

function M.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end

function M.value(e,c)
	local tp = e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(M.ffilter, tp, LOCATION_GRAVE, 0, nil)*400
end

function M.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk == 0 then return ev and ev < e:GetHandler():GetAttack() end
	Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1-tp, e:GetHandler():GetAttack() - ev)
end

function M.damop(e,tp,eg,ep,ev,re,r,rp)
	if ev and ev < e:GetHandler():GetAttack() then
		local dam = e:GetHandler():GetAttack() - ev
		Duel.Damage(1-tp, dam, REASON_EFFECT)
	end
end

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
	return c:IsAbleToHand() and (c:IsSetCard(0x200) or c:GetCode() == 24094653 or c:GetCode() == 24235)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) then return end
	local g = Duel.SelectMatchingCard(tp, M.thfilter, tp,  LOCATION_GRAVE+LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end