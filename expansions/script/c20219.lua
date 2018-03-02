--收集春度的庭师✿魂魄妖梦
function c20219.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20219,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c20219.tg2)
	e2:SetOperation(c20219.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20219,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCost(c20219.cost3)
	e3:SetTarget(c20219.tg3)
	e3:SetOperation(c20219.op3)
	c:RegisterEffect(e3)
--
	Duel.AddCustomActivityCounter(20219,ACTIVITY_SPSUMMON,c20219.counterfilter)
--
end
--
function c20219.counterfilter(c)
	return not c:IsLocation(LOCATION_EXTRA)
end
--
function c20219.tfilter2(c)
	return c:IsCode(20086) and not c:IsForbidden()
end
function c20219.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20219.tfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x128b)
end
--
function c20219.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then Duel.NegateEffect(0) return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20219,1))
	local g=Duel.SelectMatchingCard(tp,c20219.tfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		tc:AddCounter(0x128b,2)
	end
end 
--
function c20219.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(20219,tp,ACTIVITY_SPSUMMON)==0 end
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_FIELD)
	e3_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3_1:SetReset(RESET_PHASE+PHASE_END)
	e3_1:SetTargetRange(1,0)
	e3_1:SetTarget(c20219.tg3_1)
	Duel.RegisterEffect(e3_1,tp)
end
function c20219.tg3_1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
--
function c20219.tfilter3(c,tc)
	return c:GetAttack()>=tc:GetAttack() and c:IsAbleToHand()
end
function c20219.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c20219.tfilter3,tp,0,LOCATION_MZONE,1,nil,c) end
	local sg=Duel.GetMatchingGroup(c20219.tfilter3,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
--
function c20219.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c20219.tfilter3,tp,0,LOCATION_MZONE,nil,c)
	local num=Duel.SendtoHand(sg,nil,REASON_EFFECT)
	if num<=0 then return end 
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EFFECT_UPDATE_ATTACK)
		e3_2:SetReset(RESET_EVENT+0x1fe0000)
		e3_2:SetValue(num*500)
		c:RegisterEffect(e3_2)
	end
end
--



