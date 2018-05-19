--红魔与夜刃的连结✿十六夜咲夜
function c22516.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),2)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(22516)
	--atk & def down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22516,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e1:SetCountLimit(1)
	e1:SetCondition(c22516.atkcon)
	e1:SetTarget(c22516.atktg)
	e1:SetOperation(c22516.atkop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22516,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,22516)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c22516.tgtg)
	e2:SetOperation(c22516.tgop)
	c:RegisterEffect(e2)
end
function c22516.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ((Duel.GetTurnPlayer()==tp and ph>=PHASE_MAIN1 and ph<=PHASE_MAIN2) or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and (not Duel.IsDamageCalculated() or ph~=PHASE_DAMAGE)
end
function c22516.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c22516.atkop(e,tp,eg,ep,ev,re,r,rp)
	local atk=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)*100
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-atk)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-atk)
		tc:RegisterEffect(e2)
	end
end
function c22516.tgfilter(c)
	return c:IsFacedown()
end
function c22516.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsSetCard(0x813)
end
function c22516.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c22516.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c22516.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22516.tgop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetMatchingGroup(c22516.spfilter,tp,LOCATION_HAND,0,nil,e,tp,zone)
	local lv=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,3,nil)
	local tc=sg:GetFirst()
	while zone~=0 and g:GetCount()>0 and tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		Duel.BreakEffect()
		zone=e:GetHandler():GetLinkedZone(tp)
		lv=lv+tc:GetLevel()
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	if lv==16 then
		Duel.Draw(tp,3,REASON_EFFECT)
		local ug=Duel.GetMatchingGroup(aux.TRUE,tp,0x33,0x33,nil):RandomSelect(tp,3,true)
		if ug:RandomSelect(tp,1,true):IsContains(ug:GetFirst()) then
			Duel.Hint(11,0,aux.Stringid(22516,4))
		end
	end
end
