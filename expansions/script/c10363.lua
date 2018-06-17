--恋符『非定向光线』
function c10363.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10363.tg1)
	e1:SetOperation(c10363.op1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_DECKDES+CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10363.con3)
	e3:SetTarget(c10363.tg3)
	e3:SetOperation(c10363.op3)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_HANDES+CATEGORY_DECKDES+CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10363.con4)
	e4:SetTarget(c10363.tg3)
	e4:SetOperation(c10363.op3)
	c:RegisterEffect(e4)
	--
	local e5=e3:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(c10363.con5)
	c:RegisterEffect(e5)
end
function c10363.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	c:SetTurnCounter(0)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetCode(EVENT_PHASE+PHASE_END)
	e1_1:SetCountLimit(1)
	e1_1:SetRange(LOCATION_SZONE)
	e1_1:SetOperation(c10363.op1_1)
	e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	c:RegisterEffect(e1_1)
	c:RegisterFlagEffect(10363,RESET_PHASE+PHASE_END,0,1)
	c10363[c]=e1_1
end
--
function c10363.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==1 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(10363)
	end
end
function c10363.con3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x200)
end
function c10363.con4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x200)
end
function c10363.con5(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x200)
end
function c10363.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,1-tp,LOCATION_DECK)
end
--
function c10363.ofilter3_1(c)
	return c:GetAttack()>0 and c:IsFaceup()
end
function c10363.ofilter3_2(c)
	return c:GetDefense()>0 and c:IsFaceup()
end
function c10363.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then return end
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
--
		local sg1=Duel.GetMatchingGroup(c10363.ofilter3_1,tp,0,LOCATION_MZONE,nil)
		if sg1:GetCount()>0 then
			local sc=sg1:GetFirst()
			while sc do
				local e3_1=Effect.CreateEffect(c)
				e3_1:SetType(EFFECT_TYPE_SINGLE)
				e3_1:SetCode(EFFECT_UPDATE_ATTACK)
				e3_1:SetValue(-400)
				e3_1:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e3_1)
				sc=sg1:GetNext()
			end
		end
--
		local sg2=Duel.GetMatchingGroup(c10363.ofilter3_2,tp,0,LOCATION_MZONE,nil)
		if sg2:GetCount()>0 then
			local sc=sg2:GetFirst()
			while sc do
				local e3_2=Effect.CreateEffect(c)
				e3_2:SetType(EFFECT_TYPE_SINGLE)
				e3_2:SetCode(EFFECT_UPDATE_DEFENSE)
				e3_2:SetValue(-400)
				e3_2:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e3_2)
				sc=sg2:GetNext()
			end
		end
--
		local gn=Group.CreateGroup()
		if Duel.IsPlayerCanDiscardDeck(tp,1) then
			local sg3=Duel.GetDecktopGroup(tp,1)
			gn:Merge(sg3)
		end
		if Duel.IsPlayerCanDiscardDeck(1-tp,1) then
			local sg4=Duel.GetDecktopGroup(1-tp,1)
			gn:Merge(sg4)
		end	 
		if gn:GetCount()>0 then
			Duel.SendtoGrave(gn,REASON_EFFECT)
		end
--
		Duel.Damage(1-tp,800,REASON_EFFECT)
		local e3_3=Effect.CreateEffect(c)
		e3_3:SetType(EFFECT_TYPE_FIELD)
		e3_3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e3_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3_3:SetTargetRange(0,1)
		e3_3:SetValue(1)
		e3_3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3_3,tp)
	end
end
